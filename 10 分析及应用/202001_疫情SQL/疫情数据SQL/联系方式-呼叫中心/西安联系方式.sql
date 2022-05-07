--3月3日6349深圳西安，6280杭州西安，8753深圳西安 ，麻烦提供下联系方式

select distinct getmobile(t1.r_tel) 西安航线联系方式 
from cqsale.cq_order@to_air t
join  cqsale.cq_order_head@to_air  t1 on t.flights_order_id=t1.flights_order_Id
join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
join cqsale.cq_flights_segment_head@to_air t3 on t1.segment_head_id=t3.segment_head_id
where t1.r_flights_date=trunc(sysdate)+1
and t3.flag<>2
and t1.flag_id in(3,5,40,41)
and t1.whole_flight like '9C%'
and t1.whole_flight in('9C6349','9C6280','9C8753')
and t2.destairport_name='西安'
and getmobile(t1.r_tel)<>'-'

union 

select distinct t.work_tel
from cqsale.cq_order@to_air t
join  cqsale.cq_order_head@to_air  t1 on t.flights_order_id=t1.flights_order_Id
join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
join cqsale.cq_flights_segment_head@to_air t3 on t1.segment_head_id=t3.segment_head_id
where t1.r_flights_date=trunc(sysdate)+1
and t3.flag<>2
and t1.flag_id in(3,5,40,41)
and t1.whole_flight like '9C%'
and t1.whole_flight in('9C6349','9C6280','9C8753')
and t2.destairport_name='西安'
and getmobile(t.work_tel)<>'-' ;
