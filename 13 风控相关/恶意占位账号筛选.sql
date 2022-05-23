select t.flights_order_id,t1.whole_segment,t.order_date,t1.r_flights_date,t.client_id||',',t.work_tel,t.email,t.order_date,t1.flag_id,t1.r_tel,case when t.terminal_id<0 and t.web_id=0 then '线上自有'
when t.terminal_id<0 and t.web_id>0 then 'OTA'
else '其他' end 渠道,t4.email,t4.login_id,t4.reg_date,t4.EX_NFD2,t.remote_ip,t4.register_ip,t.ex_nfd1,t4.memo,
t4.login_pwd,t5.users_id_fk,t5.login_times,lower(md5(nvl(t4.login_id,t4.email))) md5,t6.flag,t.pay_gate
  from cqsale.cq_order@to_air t
  join cqsale.cq_order_head@to_air t1 on t1.flights_order_id=t.flights_Order_Id
    left join cust.cq_flights_users@to_air t4 on t.client_id=t4.users_id
    left join dw.da_lyuser t5 on t.client_id=t5.users_id_fk
    left join cqsale.cq_user_restrict@to_air t6 on t.client_id=t6.user_id
  where  t.flights_order_id in('ZSELHQ',
'ZSENJL',
'ZSFOGS',
'ZSFPEB',
'ZSFQZB',
'ZSFVXI',
'ZSGDFB',
'ZSGDIZ',
'ZSGHZM',
'ZSGKKJ',
'ZSGTQD',
'ZSGRJQ')