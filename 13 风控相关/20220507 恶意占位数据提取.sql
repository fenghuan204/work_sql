select 
t.flights_order_id 订单号,
trunc(t.order_date) 订单日期,
t.order_date 订单时间,
case when t.terminal_id<0 and t.web_id=0 then '春航官网/APP'
when t.web_id>0 then t8.abrv 
when t.terminal_id>0 then t7.terminal end 下单终端,
t.remote_ip 下单IP,
t.client_id 订票账号ID,
t.order_linkman 订票人姓名,
t.work_tel 订票人联系方式,
t.email 订票人邮箱,
t1.r_flights_date 航班日期,
t1.whole_flight 航班号,
t1.whole_segment 航段,
t1.name||coalesce(t1.second_name,'') 乘机人姓名,
t1.codeno 乘机人证件号,
t1.r_tel 乘机人联系方式,
t10.flag_name 机票状态,
t1.ticket_price 机票票价,
t9.memo 支付币种,
t1.r_rate 汇率,
case when t.terminal_id<0 and t.web_id=0 and t1.flag_id in(8,9,10) and t6.user_id is not null then '恶意占位'
else '其他' end 恶意占位标识,
t4.login_id 下单账号注册手机号,
t4.email 下单账号注册时预留邮箱,
t4.reg_date 账号注册日期,
t4.register_ip 注册IP,
t4.login_pwd 账号登录密码hash,
t4.last_login_time 最近一次登录时间,
t4.last_login_ip 最近一次登录IP
  from cqsale.cq_order@to_air t
  join cqsale.cq_order_head@to_air t1 on t1.flights_order_id=t.flights_Order_Id
    left join cust.cq_flights_users@to_air t4 on t.client_id=t4.users_id
     left join cqsale.cq_user_restrict@to_air t6 on t.client_id=t6.user_id
    left join cqsale.cq_terminal@to_air t7 on t.terminal_id=t7.terminal_id
    left join cqsale.cq_agent_info@to_air t8 on t.web_id=t8.agent_id
    left join pay.cq_money_class@to_air t9 on t.money_class_id=t9.money_class_id
    left join cqsale.cq_order_head_flag@to_air t10 on t1.flag_id=t10.flag
  where  t.order_date>=date'2022-04-01'
  and t1.r_flights_date = date'2022-04-23'
      and t1.whole_flight='9C8730'
   