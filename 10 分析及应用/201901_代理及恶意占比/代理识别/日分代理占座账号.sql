--日分占座代理账号

select distinct t.client_id||',',t3.reg_date
from cqsale.cq_order@to_air  t
join cqsale.cq_Order_head@to_air t1 on t.flights_order_id=t1.flights_order_id
left join cqsale.cq_user_restrict@to_air t2 on t.client_id=t2.user_id
left join cust.cq_flights_users@to_air t3 on t.client_Id=t3.users_id
where t.work_tel='13049186386'
and t1.flag_id not in(3,5,40,41)
and t2.user_Id is null
and t.terminal_id<0
and t.web_id=0;

--验证数据

select t.client_id,t2.cust_id,t.work_tel,t1.r_tel,t.remote_ip,t1.whole_flight,t1.whole_segment,t1.r_flights_date,t1.flag_id
from cqsale.cq_order@to_air t
join cqsale.cq_order_head@to_air t1 on t.flights_order_id=t1.flights_order_id
left join cust.cq_flights_users@to_air t2 on t.client_id=t2.users_id
where t.flights_order_id in('TRGPNQ',
'TRGQJY',
'TRGQKC');


