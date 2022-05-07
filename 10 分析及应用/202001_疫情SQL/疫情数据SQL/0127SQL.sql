select h1.segment_head_id, h1.flights_date,h1.whole_flight,h1.flights_segment_name,h1.wf_segment_name,h1.nationflag,h1.segment_type,h1.oversale,h1.bgtype,
h1.已乘机,
h1.已售未乘机,nvl(h2.num1,0） 起飞后退票,nvl(h2.num2,0) "0~6小时退票",nvl(h2.num3,0) "6~24小时退票"，
nvl(h2.num4,0) "24~48小时退票",nvl(h2.num5,0)  "48小时以上退票"
from(
select  t1.segment_head_id, t1.flights_date,t1.whole_flight,t2.flights_segment_name,t3.wf_segment_name,t2.nationflag,
t2.segment_type,t2.oversale,
case when t1.seats_name in('B','G','G1','G2') then 'BG'
else '非BG' end bgtype,
sum(case when t1.flag_id =40 then 1 else 0 end ) 已乘机,
sum(case when t1.flag_id in(3,5,41) then 1 else 0 end) 已售未乘机
from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  left join dw.dim_segment_type t3 on t2.route_id=t3.route_id and t2.h_route_id=t3.h_route_id
  where t1.flights_date>=to_date('2020-01-23','yyyy-mm-dd')
      and t1.flights_date<= to_date('2020-02-02','yyyy-mm-dd')
    and t1.seats_name is not null
    and t1.company_id=0
    group by t1.segment_head_id, t1.flights_date,t1.whole_flight,t2.flights_segment_name,t3.wf_segment_name,t2.nationflag,
t2.segment_type,t2.oversale ,case when t1.seats_name in('B','G','G1','G2') then 'BG'
else '非BG' end  
    )h1    
left join (    
select  tt1.segment_head_id,case when tt1.seats_name in('B','G','G1','G2') then 'BG'
else '非BG' end bgtype,
sum(case when tt1.origin_std-tt1.money_date< 0 then 1 else 0 end)  num1,
sum(case when tt1.origin_std-tt1.money_date>= 0 and (tt1.origin_std-tt1.money_date)*24<6 
 then 1 else 0 end)  num2,
 sum(case when (tt1.origin_std-tt1.money_date)*24>= 6 and (tt1.origin_std-tt1.money_date)*24<24
 then 1 else 0 end)  num3,
  sum(case when (tt1.origin_std-tt1.money_date)*24>= 24 and (tt1.origin_std-tt1.money_date)*24<48
 then 1 else 0 end)  num4，
   sum(case when (tt1.origin_std-tt1.money_date)*24>= 48 
 then 1 else 0 end)  num5
 
    from dw.da_order_drawback tt1
  join dw.da_flight tt2 on tt1.segment_head_id=tt2.segment_head_id
  where   tt2.flight_date>=to_date('2020-01-23','yyyy-mm-dd')
      and tt2.flight_date<= to_date('2020-01-26','yyyy-mm-dd')
    and tt1.seats_name is not null
    group  by tt1.segment_head_id, case when tt1.seats_name in('B','G','G1','G2') then 'BG'
else '非BG' end )h2 on h1.segment_head_id=h2.segment_head_id and h1.bgtype=h2.bgtype;





select  t1.segment_head_id, t1.flights_date,t1.whole_flight,t2.flights_segment_name,t3.wf_segment_name,t2.nationflag,
t2.segment_type,t2.oversale,
case when t1.seats_name in('B','G','G1','G2') then 'BG'
else '非BG' end bgtype,
count(1) ticketnum,
sum(case when t1.order_day< to_date('2020-01-24','yyyy-mm-dd') then 1 else 0 end) "24号之前销售"
from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  left join dw.dim_segment_type t3 on t2.route_id=t3.route_id and t2.h_route_id=t3.h_route_id
  where t1.flights_date>=to_date('2020-01-23','yyyy-mm-dd')
      and t1.flights_date<= to_date('2020-02-16','yyyy-mm-dd')
    and t1.seats_name is not null
    and t1.company_id=0
    group by t1.segment_head_id, t1.flights_date,t1.whole_flight,t2.flights_segment_name,t3.wf_segment_name,t2.nationflag,
t2.segment_type,t2.oversale ,case when t1.seats_name in('B','G','G1','G2') then 'BG'
else '非BG' end;
 
=======================================

select  trunc(t.order_date) 订单日期,
            case when t.terminal_id=-1 and t.web_id=0 then '线上自有渠道'
               when  t.terminal_id=-1 and t.web_id>0 then 'OTA'
           else '其他' end 渠道,
        case when t2.flight_date-trunc(t.order_date)<=0 then '0'
      when   t2.flight_date-trunc(t.order_date)<=7 then to_char(t2.flight_date-trunc(t.order_date))
      when t2.flight_date-trunc(t.order_date)>=8 and t2.flight_date-trunc(t.order_date)<=15 then '08~15'
      when t2.flight_date-trunc(t.order_date)>=16 and t2.flight_date-trunc(t.order_date)<=30 then '16~30'
      when t2.flight_date-trunc(t.order_date)>=31 and t2.flight_date-trunc(t.order_date)<=60 then '31~60'
      when t2.flight_date-trunc(t.order_date)>=61  then '60+'  end 提前期,
     t1.r_flights_date flightdate,
     case when t4.sname is not null and t4.num1+t4.num2> 0 then '已售再购'
     when t4.sname is not null and t4.num3> 0 then '退票重购'
     else null end 是否重购,
     t4.num1,
     t4.num2，
     t4.num3,
     t4.mindate,
     t4.maxdate,
     t2.flights_segment_name,
     count(1)     
  from cqsale.cq_order@to_air  t 
  join cqsale.cq_order_head@to_air t1 on t.flights_order_id=t1.flights_order_id
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  left  join (select  t3.name||coalesce(t3.second_name,'') sname,t3.codeno,
                              sum(case when t3.flag_id in(3,5) then 1 else 0 end) num1,
                sum(case when t3.flag_id=40 then 1 else 0 end) num2,
                sum(case when t3.flag_id in(7,11,12) then 1 else 0 end ) num3，
                min(t3.r_flights_date) mindate，
                max(t3.r_flights_date) maxdate,
                max(t3.r_order_date) orderday,
                max(t3.flights_order_id) flights_order_id
                       from cqsale.cq_order_head@to_air t3 
             where t3.flag_id in(3,5,40,7,11,12)
                and t3.seats_name is not null
              and t3.r_flights_date>=to_date('2020-01-24','yyyy-mm-dd')
              group by t3.name||coalesce(t3.second_name,'') ,t3.codeno
             ) t4 on t1.name||coalesce(t1.second_name,'')=t4.sname and t1.codeno=t4.codeno and t4.orderday< t.order_date and t.flights_order_id<>t4.flights_order_id
  where t.order_date>=to_date('2020-01-24','yyyy-mm-dd')
     and t.order_date< to_date('2020-01-27 14:00','yyyy-mm-dd hh24:mi')
   and t1.flag_id in(3,5,40)
   and t1.seats_name is not null
   group by trunc(t.order_date) ,
            case when t.terminal_id=-1 and t.web_id=0 then '线上自有渠道'
               when  t.terminal_id=-1 and t.web_id>0 then 'OTA'
           else '其他' end ,
        case when t2.flight_date-trunc(t.order_date)<=0 then '0'
      when   t2.flight_date-trunc(t.order_date)<=7 then to_char(t2.flight_date-trunc(t.order_date))
      when t2.flight_date-trunc(t.order_date)>=8 and t2.flight_date-trunc(t.order_date)<=15 then '08~15'
      when t2.flight_date-trunc(t.order_date)>=16 and t2.flight_date-trunc(t.order_date)<=30 then '16~30'
      when t2.flight_date-trunc(t.order_date)>=31 and t2.flight_date-trunc(t.order_date)<=60 then '31~60'
      when t2.flight_date-trunc(t.order_date)>=61  then '60+'  end ,
     t1.r_flights_date,
     case when t4.sname is not null and t4.num1+t4.num2> 0 then '已售再购'
     when t4.sname is not null and t4.num3> 0 then '退票重购'
     else null end,
     t4.mindate,
     t4.maxdate,
     t2.flights_segment_name,
          t4.num1,
     t4.num2，
     t4.num3;
	 
	 
	 
	 
	 
	 
	 
	 
	 
select  t1.segment_head_id 航段id, t1.flights_date 航班日期,t1.whole_flight 航班号,t2.flights_segment_name 航段,t3.wf_segment_name 往返航段,
t2.nationflag 航线性质,
t2.segment_type 航段类型,t2.oversale 计划量,
t1.channel 渠道,
t1.sub_channel 渠道大类,
case when t1.seats_name in('B','G','G1','G2') then 'BG'
else '非BG' end BG类型,
sum(case when t1.flag_id =40 then 1 else 0 end ) 已乘机,
sum(case when t1.flag_id in(3,5,41) then 1 else 0 end) 已售未乘机,
sum(case when tt1.flights_order_head_id is not null and t2.origin_std-tt1.money_date< 0 then 1 else 0 end)  起飞后退票,
sum(case when tt1.flights_order_head_id is not null and t2.origin_std-tt1.money_date>= 0 and (t2.origin_std-tt1.money_date)*24<6 
 then 1 else 0 end)  "0~6小时退票",
 sum(case when tt1.flights_order_head_id is not null and (t2.origin_std-tt1.money_date)*24>= 6 and (t2.origin_std-tt1.money_date)*24<24
 then 1 else 0 end)  "6~24小时退票",
  sum(case when tt1.flights_order_head_id is not null and (t2.origin_std-tt1.money_date)*24>= 24 and (t2.origin_std-tt1.money_date)*24<48
 then 1 else 0 end)  "24~48小时退票"，
   sum(case when tt1.flights_order_head_id is not null and (t2.origin_std-tt1.money_date)*24>= 48 
 then 1 else 0 end)  "48小时以上退票"
from dw.fact_recent_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id  
  left join dw.dim_segment_type t3 on t2.route_id=t3.route_id and t2.h_route_id=t3.h_route_id
  left join dw.da_order_drawback tt1 on t1.flights_order_head_id=tt1.flights_order_head_id
  where t1.flights_date>=to_date('2020-01-23','yyyy-mm-dd')
      and t1.flights_date<= to_date('2020-02-02','yyyy-mm-dd')
    and t1.seats_name is not null
    group by t1.segment_head_id , t1.flights_date ,t1.whole_flight ,t2.flights_segment_name ,t3.wf_segment_name ,
t2.nationflag ,
t2.segment_type ,t2.oversale ,
t1.channel ,
t1.sub_channel ,
case when t1.seats_name in('B','G','G1','G2') then 'BG'
else '非BG' end
   
	 
