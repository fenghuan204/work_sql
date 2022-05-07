select t1.segment_head_id,t2.flight_date,t2.flight_no,t2.flights_segment_name,t1.* from cqsale.CQ_SUB_CABIN_SEGMENT_HEAD@to_air t1
join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
where t2.flight_date>=trunc(sysdate+1)
and state=1
and t2.flag<>2
and t1.segment_head_id in(1403620,1458833);

select * from cqsale.cq_sub_cabin_detail@to_air
where segment_head_id in(1403620,1458833)
and main_cabin='P1'
and state=1;

select *
 from cqsale.cq_sub_cabin_rule@to_air

select t1.flights_date,t1.whole_flight,t1.whole_segment,t1.seats_name,t1.segment_head_id,t1.ex_cfd5,t1.*
 from dw.fact_order_detail t1
 where t1.flights_date>=trunc(sysdate)+1
 --and t1.order_day>=trunc(sysdate)-1
 --and t1.EX_CFD5 is not null
 and t1.segment_head_id in(1403620,1458833)
 and t1.seats_name ='P1'
