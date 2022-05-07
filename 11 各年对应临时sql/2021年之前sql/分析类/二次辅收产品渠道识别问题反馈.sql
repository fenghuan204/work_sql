select t1.flights_order_id,t1.flights_order_head_id,t1.other_order_head_id,t4.pay_together,t3.terminal_id,t3.web_id,t3.ex_nfd1,t4.terminal_id,t4.ext_1,t4.ex_nfd1
from dw.fact_other_order_detail t1
join stg.s_cq_other_order_head t2 on t1.other_order_head_id=t2.other_order_head_id
join stg.s_cq_order t3 on t1.flights_order_id=t3.flights_order_id
join stg.s_cq_other_order t4 on t1.order_id=t4.order_id
where t1.order_day>=trunc(sysdate-1)
and t1.pay_together=1
and t1.flights_order_head_id=159355747
