select t2.abrv ÇşµÀ,count(1) ÏúÁ¿
  from cqsale.cq_order@to_air t
  join cqsale.cq_order_head@to_air t1  on t.flights_order_id=t1.flights_order_id
  left join cqsale.cq_agent_info@to_air t2 on t.web_id=t2.agent_id
 where t1.r_order_date >= trunc(sysdate)
   and t1.seats_name = 'P2'
   and t.order_date>=trunc(sysdate)
   and t.web_id>0
   and t1.flag_id in(3,5,40)
   and t.terminal_id<0
   group by t2.abrv
