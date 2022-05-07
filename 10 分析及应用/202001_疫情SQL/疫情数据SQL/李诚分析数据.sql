select  t1.segment_head_id 航段id, t1.flights_date 航班日期,t1.whole_flight 航班号,t2.flights_segment_name 航段,t3.wf_segment_name 往返航段,
t2.nationflag 航线性质,
t2.segment_type 航段类型,t2.oversale 计划量,
t1.channel 渠道,
t1.sub_channel 渠道大类,
case when t1.seats_name in('B','G','G1','G2') then 'BG'
else '非BG' end BG类型,
case when t1.order_day< to_date('2020-01-24','yyyy-mm-dd') and t2.origin_std>=to_date('2020-01-24','yyyy-mm-dd')
then '符合免票规则'
when  t1.order_day< to_date('2020-01-28','yyyy-mm-dd') and t2.origin_std>=to_date('2020-01-28','yyyy-mm-dd')
then '符合免票规则'  
else '不符合规则' end 是否符合免费退,
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
      and t1.flights_date<= to_date('2020-02-15','yyyy-mm-dd')
    and t1.seats_name is not null
    group by t1.segment_head_id , t1.flights_date ,t1.whole_flight ,t2.flights_segment_name ,t3.wf_segment_name ,
t2.nationflag ,
t2.segment_type ,t2.oversale ,
t1.channel ,
t1.sub_channel ,
case when t1.seats_name in('B','G','G1','G2') then 'BG'
else '非BG' end,
case when t1.order_day< to_date('2020-01-24','yyyy-mm-dd') and t2.origin_std>=to_date('2020-01-24','yyyy-mm-dd')
then '符合免票规则'
when  t1.order_day< to_date('2020-01-28','yyyy-mm-dd') and t2.origin_std>=to_date('2020-01-28','yyyy-mm-dd')
then '符合免票规则'  
else '不符合规则' end;







select '今年' lab,
               trunc(d.money_date) mday,
               t2.nationflag,
               t2.flights_segment_name,
               t3.channel,
               t3.sub_channel,
               case when trunc(t2.flight_date)-trunc(d.money_date)>45
               then '>45'
               when trunc(t2.flight_date)-trunc(d.money_date)< 0
               then '< 0'
               else to_char(trunc(t2.flight_date)-trunc(d.money_date))
               end   ahdays,
               count(1) tktnum
          from dw.da_order_drawback d
          join dw.da_flight t2 on t2.segment_head_id = d.segment_head_id
          left join dw.fact_recent_order_detail t3 on d.flights_order_head_id=t3.flights_order_head_id
         where d.money_date >= to_date('2020-01-22','yyyy-mm-dd')
           and d.money_date < trunc(sysdate)
           and t2.flag<>2
         group by  trunc(d.money_date) ,
               t2.nationflag,
               t2.flights_segment_name,
               case when trunc(t2.flight_date)-trunc(d.money_date)>45
               then '>45'
               when trunc(t2.flight_date)-trunc(d.money_date)< 0
               then '< 0'
               else to_char(trunc(t2.flight_date)-trunc(d.money_date))
               end,
                      t3.channel,
               t3.sub_channel;

