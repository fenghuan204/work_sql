select * from dw.da_b2c_user t1
where t1.email='chunqiuij9clala@163.com'


select * from cust.cq_flights_users@to_air
where email ='chunqiuij9clala@163.com'


select distinct t.client_Id||',',t1.login_id,t1.email,t1.login_pwd,t2.flag,t1.reg_date from cqsale.cq_order@to_air t
left join cust.cq_flights_users@to_air t1 on t.client_Id=t1.users_id
left join cqsale.cq_user_restrict@to_air t2 on t.client_id=t2.user_id
where t.order_date>=trunc(sysdate)
and t.r_company_id=6
and t.pay_flag=2
and t.email='chunqiuij9clala@163.com';




select  t.email,count(1) from cqsale.cq_order@to_air t
left join cust.cq_flights_users@to_air t1 on t.client_Id=t1.users_id
left join cqsale.cq_user_restrict@to_air t2 on t.client_id=t2.user_id
where t.order_date>=trunc(sysdate)
and t.r_company_id=6
and t.pay_flag=2
group by t.email 



0
