select t1.*,t2.name
from cqsale.cq_order@to_air t1
join cqsale.cq_order_head@to_air t2 on t1.flights_order_id=t2.flights_order_id
/*left join cust.cq_flights_users@to_air t3 on t1.client_id=t3.users_id*/
where  t1.work_tel='18624336656'
