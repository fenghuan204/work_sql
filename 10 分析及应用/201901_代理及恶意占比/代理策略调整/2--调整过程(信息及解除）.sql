---1、特征对应的明细信息
select t.client_id,t.order_date,t.flights_Order_Id,t.work_tel,t.email,t.order_linkman,tt1.name,tt1.whole_segment,tt1.r_tel,
t1.mobile,t1.email,t1.identify,t1.feature,t1.feature_id,t1.feature_value,t1.create_date,t3.user_id,t3.memo
from cqsale.cq_order@to_air t 
join cqsale.cq_order_head@to_air tt1 on t.flights_Order_id=tt1.flights_order_id
join dw.da_restrict_userinfo t1 on t.client_id=t1.users_id
left join cqsale.CQ_BLACK_FEATURE_RULE_DETAIL@to_air t2  on t2.feature_rule_id=regexp_substr(t1.feature,'[0-9]')
left join cqsale.cq_user_restrict@to_air t3 on t.client_id=t3.user_id
where t.terminal_id=-1
and t.web_id=0
and tt1.flag_id in(3,5,40,7,11,12)
and t.order_date>=trunc(sysdate-3)
and t1.identify like '%特征%'
and t1.feature ='其他'
and length(t1.feature_value)<11;



---2、解除代理限制判断
select t.client_id,t.flights_Order_id,t.order_date,t.order_linkman,t.work_tel,t.email,t.remote_ip,c.channel,c.terminal,t1.name||coalesce(t1.second_name,'') sname,
t1.codeno,t1.r_tel,t2.flights_segment_name,t1.flag_id
from cqsale.cq_order@to_air  t
join cqsale.cq_Order_head@to_air t1 on t.flights_order_id=t1.flights_order_id
join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id 
 left join dw.da_channel_part c on c.terminal_id = t.terminal_id
                                and c.web_id = nvl(t.web_id, 0)
                                and c.station_id =
                                    (case when t.terminal_id < 0 and
                                     nvl(t.ex_nfd1, 0) <= 1 then 1 else
                                     nvl(t.ex_nfd1, 0) end)
                                and t.order_date >= c.sdate
                                and t.order_date < c.edate + 2

where t.client_id=163129322;
