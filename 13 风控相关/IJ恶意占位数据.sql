select t1.flights_order_id 订单号,t1.order_date 订单日期,t1.client_id||',' 会员ID,
t3.login_id,t1.work_tel 订票人联系方式,t3.login_id 账号注册手机号,
t1.email 订票人邮箱 ,t1.order_linkman 订票人姓名,t1.remote_ip 下单IP,t2.name 乘客姓名,t2.second_name,t2.r_flights_date 航班日期,t2.whole_flight 航班号,
t2.whole_segment 航段,t2.ticket_price*t2.r_com_rate 票面金额,t2.r_tel 乘机人联系方式,t3.reg_date 账号注册日期,t3.email 账号邮箱信息,
t3.register_ip 注册IP,t3.last_login_ip 最近登录IP,t3.login_pwd,t1.EX_CFD4 语言
from cqsale.cq_order@to_air t1
join cqsale.cq_order_head@to_air t2 on t1.flights_order_id=t2.flights_order_id
left join cust.cq_flights_users@to_air t3 on t1.client_id=t3.users_id
where t1.order_date>=trunc(sysdate)-1
--and t1.email in('hshbdjj@163.com','588546697@qq.com','hebdbsj@163.com','fvjkmng@163.com','haolinjia@163.com')
and t1.flights_order_id in('XCSTGJ','XCSTID','XCTBTH','XCTBYB','XCTIBG')
