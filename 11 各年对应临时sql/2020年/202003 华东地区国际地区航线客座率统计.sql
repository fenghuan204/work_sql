---李剑总要求的浦东往返国际地区航线客座率
--华东地区国际地区旅客客座率统计表

select /*+parallel(4) */
tb3.flight_date 航班日期 ,tb3.flight_no 航班号,
tt1.c_name||'-'||tt2.c_name 航线,
tb3.origin_country 始发地,
tb3.dest_country 目的地,
tb3.layout 机型座位数,
nvl(ticketnum,0) 预约数,
nvl(ticketnum,0)/tb3.layout 客座率
from  cqsale.cq_flights_segment_head@to_air tb1 
join cqsale.cq_flights_seats_amount_plan@to_air t6  on tb1.segment_Head_id=t6.segment_Head_id
join dw.da_flight tb3  on tb1.segment_head_id=tb3.segment_head_id
left join stg.f_airport tt1 on tb3.originairport=tt1.t_code
left join stg.f_airport tt2 on tb3.destairport=tt2.t_code
left join 
(
select t1.segment_head_id,count(1)  ticketnum
from cqsale.cq_order_head@to_air t1
join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
where t1.r_flights_date>=trunc(sysdate)
and t1.r_flights_date<=trunc(sysdate)+6
and t1.flag_id in(3,5,40,41)
and t2.company_id=0
and t2.flag<>2
and t1.seats_name is not null
and t2.flights_segment_name like '%浦东%'
and t2.nationflag<>'国内'
group by t1.segment_head_id)tb4 on tb3.segment_head_id=tb4.segment_head_id
where tb1.flag<>2
and  tb3.flight_date>=trunc(sysdate)
and  tb3.flight_date<=trunc(sysdate)+6
and tb3.company_id=0
and tb3.flights_segment_name like '%浦东%'
and tb3.nationflag<>'国内'
order by 1,2
