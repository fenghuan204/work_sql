select distinct t.client_id||','
from cqsale.cq_order@to_air  t
join cqsale.cq_order_head@to_air t1 on t.flights_order_id=t1.flights_order_id
left join cqsale.cq_user_restrict@to_air t2 on t.client_id=t2.user_id
where t1.r_tel in('15641132016','13268421283')
and nvl(t2.flag,6)>=6
and t.client_id>0
and t.order_date>=trunc(sysdate-3)
and t.terminal_id=-1
and t.web_id=0
AND ROWNUM<=3000;



select distinct t.client_id||','
from cqsale.cq_order@to_air  t
join cqsale.cq_order_head@to_air t1 on t.flights_order_id=t1.flights_order_id
left join cqsale.cq_user_restrict@to_air t2 on t.client_id=t2.user_id
where t.work_tel in('15641132016','13268421283')
and nvl(t2.flag,6)>=6
and t.client_id>0
and t.order_date>=trunc(sysdate-3)
and t.terminal_id=-1
and t.web_id=0
AND ROWNUM<=3000
