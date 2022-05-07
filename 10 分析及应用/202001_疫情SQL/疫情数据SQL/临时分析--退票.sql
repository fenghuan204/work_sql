select /*+parallel(4) */
 trunc(t1.money_date),case when t2.flag=2 then '取消航班' else '正常航班' end,
case when t3.order_date< to_date('2020-01-24','yyyy-mm-dd') then '24号之前购票'
when t3.order_date>=  to_date('2020-01-24','yyyy-mm-dd') then '24号之后购票'
else null end,
case when t1.money_date> t2.origin_std then '离站后'
else '离站前' end,
case when t1.origin_std< to_date('2020-01-24','yyyy-mm-dd')  then '24号之前航班'
when t1.origin_std>= to_date('2020-01-24','yyyy-mm-dd')  then '24号之后航班'
else null end,
case when t3.terminal_id=-1 and t3.web_id =0 then '线上自有渠道'
 when t3.terminal_id in
                (300, 1233, 1309, 1330, 1400, 1401, 1516, 1571, 1801, 1802, 1803, 1805, 1806, 1807, 1808, 3505) then
            '呼叫中心'
when regexp_like(t4.abrv,'(淘宝)|(携程)|(去哪儿)|(同程)|(飞猪)') then t4.abrv
when t3.terminal_id>0 and t3.web_id=0 then 'B2B'
else '其他' end ,
case when t1.money_fy=0 then '免费退'
when t1.money_fy>0 then '非免费退' end,
case when t1.MONEY_TERMINAL<0 then '线上退'
else '线下退' end,
count(distinct t1.flights_order_head_id)
  from hdb.temp_feng_back_today t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  left join cqsale.cq_order@to_air t3 on t1.flights_order_id=t3.flights_order_id
  left join stg.s_cq_agent_info t4 on t3.web_id=t4.agent_id
   where t1.money_date>=trunc(sysdate)
   and t1.money_date< to_date('2020-01-28 21:00','yyyy-mm-dd hh24:mi')
   and t1.seats_name is not null
   and t2.company_id=0
   group by trunc(t1.money_date),case when t2.flag=2 then '取消航班' else '正常航班' end,
case when t3.order_date< to_date('2020-01-24','yyyy-mm-dd') then '24号之前购票'
when t3.order_date>=  to_date('2020-01-24','yyyy-mm-dd') then '24号之后购票'
else null end,
case when t1.money_date> t2.origin_std then '离站后'
else '离站前' end,
case when t1.origin_std< to_date('2020-01-24','yyyy-mm-dd')  then '24号之前航班'
when t1.origin_std>= to_date('2020-01-24','yyyy-mm-dd')  then '24号之后航班'
else null end,
case when t3.terminal_id=-1 and t3.web_id =0 then '线上自有渠道'
 when t3.terminal_id in
                (300, 1233, 1309, 1330, 1400, 1401, 1516, 1571, 1801, 1802, 1803, 1805, 1806, 1807, 1808, 3505) then
            '呼叫中心'
when regexp_like(t4.abrv,'(淘宝)|(携程)|(去哪儿)|(同程)|(飞猪)') then t4.abrv
when t3.terminal_id>0 and t3.web_id=0 then 'B2B'
else '其他' end ,
case when t1.money_fy=0 then '免费退'
when t1.money_fy>0 then '非免费退' end,case when t1.MONEY_TERMINAL<0 then '线上退'
else '线下退' end;





--临时数据

select h1.segment_head_id, h1.flights_date,h1.whole_flight,h1.flights_segment_name,h1.wf_segment_name,h1.nationflag,h1.segment_type,h1.oversale,/*h1.bgtype,*/
h1.bgplan,h1.bgnum,
h1.已乘机,
h1.已售未乘机,nvl(h2.num1,0） 起飞后退票,nvl(h2.num2,0) "0~6小时退票",nvl(h2.num3,0) "6~24小时退票"，
nvl(h2.num4,0) "24~48小时退票",nvl(h2.num5,0)  "48小时以上退票",h1.tnum
from(
select  t1.segment_head_id, t1.flights_date,t1.whole_flight,t2.flights_segment_name,t3.wf_segment_name,t2.nationflag,
t2.segment_type,t2.oversale,t2.bgo_plan-t2.o_plan bgplan,
/*case when t1.seats_name in('B','G','G1','G2') then 'BG'
else '非BG' end bgtype,*/
sum(case when t1.seats_name in('B','G','G1','G2') then 1 else 0 end ) bgnum,
sum(case when t1.flag_id =40 then 1 else 0 end ) 已乘机,
sum(case when t1.flag_id in(3,5,41) then 1 else 0 end) 已售未乘机,
sum(case when t1.order_day< to_date('2020-01-24','yyyy-mm-dd') then 1 else 0 end) tnum
from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  left join dw.dim_segment_type t3 on t2.route_id=t3.route_id and t2.h_route_id=t3.h_route_id
  where t1.flights_date>=to_date('2020-01-23','yyyy-mm-dd')
      and t1.flights_date<=to_date('2020-02-15','yyyy-mm-dd')
    and t1.seats_name is not null
    and t1.company_id=0
    and t2.flag<>2
    group by t1.segment_head_id, t1.flights_date,t1.whole_flight,t2.flights_segment_name,t3.wf_segment_name,t2.nationflag,
t2.segment_type,t2.oversale ,t2.bgo_plan-t2.o_plan/*,case when t1.seats_name in('B','G','G1','G2') then 'BG'
else '非BG' end  */
    )h1    
left join (    
select  tt1.segment_head_id,/*case when tt1.seats_name in('B','G','G1','G2') then 'BG'
else '非BG' end bgtype,*/
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
      and tt2.flight_date<= to_date('2020-02-15','yyyy-mm-dd')
    and tt1.seats_name is not null
    and tt2.flag<>2
    group  by tt1.segment_head_id/*, case when tt1.seats_name in('B','G','G1','G2') then 'BG'
else '非BG' end*/ )h2 on h1.segment_head_id=h2.segment_head_id /*and h1.bgtype=h2.bgtype*/;



----------------------------------------------订单日期、渠道、提前期、航线性质、航段、销量、价格


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
     t2.nationflag, 
     t2.flights_segment_name,
     count(1),
     sum((t1.ticket_price+t1.ad_fy)*nvl(t1.r_com_rate,1))
  from cqsale.cq_order@to_air  t 
  join cqsale.cq_order_head@to_air t1 on t.flights_order_id=t1.flights_order_id
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  where t.order_date>=to_date('2020-01-24','yyyy-mm-dd')
     and t.order_date< to_date('2020-01-27 16:00','yyyy-mm-dd hh24:mi')
   and t1.flag_id in(3,5,40)
   and t1.seats_name is not null
   and t1.whole_flight like '9C%'
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
     t1.r_flights_date ,
     t2.nationflag, 
     t2.flights_segment_name;


---当前在售最低价格+当前在售价格

select /*+parallel(4) */
t1.segment_head_id,t2.flight_date,t2.flights_segment_name,t2.flight_no,t2.segment_code,t2.oversale,t2.bgo_plan-t2.o_plan,count(1),
sum(case when t1.seats_name in('B','G','G1','G2') then 1 else 0 end) BGnum,
t2.nationflag,tb2.minmoney,t2.price
 from cqsale.cq_order_head@to_air t1
 join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
left join(select  tb1.segment_head_id,min(tb1.money) minmoney
from(
select h1.segment_head_id,
       h1.seats_name ,
       h1.money ,
       h2.remnant ,
       trunc(h3.origin_std) 起飞时间,
       h3.flights_segment 航段,
       h3.r_flights_no 航班号,
       h4.flights_segment_name 中文航段
  from (select *
          from (select segment_head_id,
                       MONEY_E,
MONEY_H,
MONEY_I,
MONEY_K,
MONEY_L,
MONEY_M,
MONEY_N,
MONEY_P,
MONEY_P1,
MONEY_P2,
MONEY_P3,
MONEY_P4,
MONEY_P5,
MONEY_Q,
MONEY_R1,
MONEY_R2,
MONEY_R3,
MONEY_R4,
MONEY_S,
MONEY_T,
MONEY_U,
MONEY_V,
MONEY_X,
MONEY_Y                       
from cqsale.cq_flights_segment_head@to_air) unpivot(money for seats_name in (MONEY_E as 'E',
MONEY_H as 'H',
MONEY_I as 'I',
MONEY_K as 'K',
MONEY_L as 'L',
MONEY_M as 'M',
MONEY_N as 'N',
MONEY_P as 'P',
MONEY_P1 as 'P1',
MONEY_P2 as 'P2',
MONEY_P3 as 'P3',
MONEY_P4 as 'P4',
MONEY_P5 as 'P5',
MONEY_Q as 'Q',
MONEY_R1 as 'R1',
MONEY_R2 as 'R2',
MONEY_R3 as 'R3',
MONEY_R4 as 'R4',
MONEY_S as 'S',
MONEY_T as 'T',
MONEY_U as 'U',
MONEY_V as 'V',
MONEY_X as 'X',
MONEY_Y as 'Y'
))
                  ) h1
  join (select *
          from (select segment_head_id,
                       REMNANT_E,
REMNANT_H,
REMNANT_I,
REMNANT_K,
REMNANT_L,
REMNANT_M,
REMNANT_N,
REMNANT_P,
REMNANT_P1,
REMNANT_P2,
REMNANT_P3,
REMNANT_P4,
REMNANT_P5,
REMNANT_Q,
REMNANT_R1,
REMNANT_R2,
REMNANT_R3,
REMNANT_R4,
REMNANT_S,
REMNANT_T,
REMNANT_U,
REMNANT_V,
REMNANT_X,
REMNANT_Y
from cqsale.cq_flights_seats_amount@to_air) unpivot(remnant for seats_name in (REMNANT_E AS 'E',
REMNANT_H AS 'H',
REMNANT_I AS 'I',
REMNANT_K AS 'K',
REMNANT_L AS 'L',
REMNANT_M AS 'M',
REMNANT_N AS 'N',
REMNANT_P AS 'P',
REMNANT_P1 AS 'P1',
REMNANT_P2 AS 'P2',
REMNANT_P3 AS 'P3',
REMNANT_P4 AS 'P4',
REMNANT_P5 AS 'P5',
REMNANT_Q AS 'Q',
REMNANT_R1 AS 'R1',
REMNANT_R2 AS 'R2',
REMNANT_R3 AS 'R3',
REMNANT_R4 AS 'R4',
REMNANT_S AS 'S',
REMNANT_T AS 'T',
REMNANT_U AS 'U',
REMNANT_V AS 'V',
REMNANT_X AS 'X',
REMNANT_Y AS 'Y'))) h2 on h1.segment_head_id =  h2.segment_head_id    and h1.seats_name = h2.seats_name
  join cqsale.cq_flights_segment_head@to_air h3 on h1.segment_head_id =  h3.segment_head_id
  join cqsale.cq_flights_seats_amount@to_air h5 on h1.segment_head_id=h5.segment_head_id
  left join dw.da_flight h4 on h1.segment_head_id = h4.segment_head_id
 where h3.origin_std >= trunc(sysdate)
   and h2.remnant > 0
   and h3.flag <> 2
   and h1.money>0
   and h3.r_flights_no like '9C%'
   and h1.seats_name not in('P2','P5','O','A','D','Z','I','J'))tb1
   group by tb1.segment_head_id
   
)tb2 on t1.segment_head_id=tb2.segment_head_id
 where t1.r_flights_date>=trunc(sysdate+1)
   and t1.r_flights_date<=trunc(sysdate+7)
   and t1.flag_id in(3,5,40)
   and t1.seats_name is not null
   and t2.flag<>2
   and t1.whole_flight like '9C%'
   and not exists(select 1 from cqsale.cq_order_head@to_air t3
   where t3.r_order_date>=trunc(sysdate-1)
   and t3.r_order_date< sysdate
   and t3.flag_id in(3,5,40)
   and t1.segment_head_id=t3.segment_head_id)
   group by t1.segment_head_id,t2.flight_date,t2.flights_segment_name,t2.flight_no,t2.segment_code,t2.oversale,t2.bgo_plan-t2.o_plan,
t2.nationflag,tb2.minmoney,t2.price;


----航班销售数据

 select h1.flights_segment_name,h1.segment_type,h1.nationflag,h1.route_name,sum(bgplan),sum(oversale),sum(ticketnum),sum(ticketfee),sum(flightnum)
 from(
 select t1.segment_head_id,t2.flights_segment_name,t2.segment_type,
 t2.bgo_plan-t2.o_plan bgplan,t2.oversale,t2.nationflag,t2.route_name,
  sum(case when t1.seats_name not in('B','G','G1','G2') then 1 else 0 end) ticketnum,
  sum(case when t1.seats_name not in('B','G','G1','G2') then t1.ticket_price+t1.ad_fy else 0 end) ticketfee,
  count(distinct t1.segment_head_id) flightnum
  from dw.fact_order_detail t1
           join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
           where t1.flights_date>=to_date('2020-01-21','yyyy-mm-dd')
             and t1.flights_date<=tO_date('2020-01-27','yyyy-mm-dd')
             and t1.company_id=0
             and t2.flag<>2
             and t1.seats_name is not null
             group by t2.flights_segment_name,t2.segment_type,t1.segment_head_id,t2.flights_city_name,t2.segment_type,
 t2.bgo_plan-t2.o_plan,t2.oversale,t2.nationflag,t2.route_name)h1
 group by h1.flights_segment_name,h1.segment_type,h1.nationflag,h1.route_name;
 
 
 
 
 
 
             
    


