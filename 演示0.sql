select 
from cqsale.cq_order@to_air t
  join cqsale.cq_order_head@to_air t1 on t1.flights_order_id=t.flights_Order_Id
 where t.order_date>=date'2022-04-01'
 and t1.r_flights_date>=date'2022-04-01'
 and t1.flag_id in(8,9,10)
 and t1.whole_flight like '9C%'
 and 