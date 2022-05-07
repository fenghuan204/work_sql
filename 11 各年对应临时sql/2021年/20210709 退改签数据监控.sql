--退改数据监控

select trunc(t1.money_date),case when t1.money_fy=0 then '0元'
else '非0元' end ,case when t2.flag=0 then '正常执行'
when t2.flag=2 then '取消'
else '其他' end,
case when t1.seats_name not in('B','G','G1','G2','O') then 'BGO'
else '非BGO' end,
t2.flight_date-trunc(t1.money_date) 退票提前期,
t2.flight_date,
count(1)
 from dw.da_order_drawback t1
 join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
 where t1.money_date>=trunc(sysdate)-7
 group by trunc(t1.money_date),case when t1.money_fy=0 then '0元'
else '非0元' end ,case when t2.flag=0 then '正常执行'
when t2.flag=2 then '取消'
else '其他' end,
case when t1.seats_name not in('B','G','G1','G2','O') then 'BGO'
else '非BGO' end,
t2.flight_date-trunc(t1.money_date) ,
t2.flight_date;


select t1.flight_date,count(distinct case when t1.flag=2 then t1.flights_id
else null end) 取消航班量,count(distinct case when t1.flag=0 then t1.flights_id
else null end) 执行航班量,
sum(case when t1.flag=2 then t1.oversale
else null end) 取消计划量,
sum(case when t1.flag=0 then t1.oversale
else null end) 执行航班量
 from dw.da_flight t1
 where t1.flight_date>=trunc(sysdate)-7
 --and t1.flag=2
 and t1.company_id=0
 group by t1.flight_date
 order by t1.flight_date;
 
 
 select t1.flights_segment_name,count(1)
 from dw.da_flight t1
 where t1.flight_date=trunc(sysdate)-1
 and t1.flag=2
 and t1.company_id=0
 group by t1.flights_segment_name
 order by t1.flights_segment_name
 
 
 
