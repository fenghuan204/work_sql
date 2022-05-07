--商旅通数据
--1、 

select case when fee<100 then '0~100' 
when fee<200 then '100~200' 
when fee<300 then '200~300' 
when fee<400 then '300~400' 
when fee<500 then '400~500' 
when fee<600 then '500~600' 
when fee<900 then '600~900' 
when fee<1000 then '900~1000' 
when fee>=1000 then '1000+' end,type1,count(1) 
from(
select t1.flights_order_id,case when t1.flag_id in(3,5,40,41) then '消费'
when t1.flag_id in(7,11,12) then '退票' end type1,
sum(t1.ticket_price+t1.port_pay+t1.ad_fy+t1.other_fy+t1.insurce_fee+t1.other_fee) fee
 from dw.fact_recent_order_detail t1
 join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
 left join dw.bi_order_region t3 on t1.flights_order_head_id=t3.flights_order_head_id
 where t1.order_day>=trunc(sysdate)-180
  and t1.order_day< trunc(sysdate)
  and t2.flag=0
  and t1.seats_name not in('B','G1','G','G2','O')
  and t1.seats_name is not null 
 group by t1.flights_order_id,case when t1.flag_id in(3,5,40,41) then '消费'
when t1.flag_id in(7,11,12) then '退票' end)
group by case when fee<100 then '0~100' 
when fee<200 then '100~200' 
when fee<300 then '200~300' 
when fee<400 then '300~400' 
when fee<500 then '400~500' 
when fee<600 then '500~600' 
when fee<900 then '600~900' 
when fee<1000 then '900~1000' 
when fee>=1000 then '1000+' end,type1
   
