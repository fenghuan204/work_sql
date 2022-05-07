select trunc(t.order_date),count(1)
from cqsale.cq_order@to_air  t
join cqsale.cq_order_head@to_air t1 on t.flights_order_id=t1.flights_order_id
left join cqsale.cq_user_restrict@to_air t2 on t.client_id=t2.user_id
where t.client_id>0
and t.order_date>=trunc(sysdate-3)
and t.terminal_id=-1
and t.web_id=0
and t1.flag_id=8
and to_char(t.order_date,'hh24:mi')<='15:31'
and t1.seats_name='P2'
group by trunc(t.order_date)
order by 1
