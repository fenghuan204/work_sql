select t.client_id,t.order_date,t.order_linkman,t.work_tel,t.email,t.remote_ip,c.channel,c.terminal,t1.name||coalesce(t1.second_name,'') sname,
t1.codeno,t1.r_tel,t2.flights_segment_name,t1.whole_flight,t3.login_id,t3.email,t3.register_ip,t1.flag_id,t4.cust_id,t4.realname,
t4.codeno,t5.gate_name
from cqsale.cq_order@to_air  t
join cqsale.cq_Order_head@to_air t1 on t.flights_order_id=t1.flights_order_id
join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id 
left join dw.da_b2c_user t3 on t.client_id=t3.users_id
left join dw.da_lyuser t4 on t.client_id=t4.users_id_fk
left join stg.p_cq_pay_gate t5 on t.pay_gate=t5.id
 left join dw.da_channel_part c on c.terminal_id = t.terminal_id
                                and c.web_id = nvl(t.web_id, 0)
                                and c.station_id =
                                    (case when t.terminal_id < 0 and
                                     nvl(t.ex_nfd1, 0) <= 1 then 1 else
                                     nvl(t.ex_nfd1, 0) end)
                                and t.order_date >= c.sdate
                                and t.order_date < c.edate + 2

where t.client_id=65903640 
