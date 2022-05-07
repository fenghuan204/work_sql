select t4.login_id,t7.city,t6.city worktel,t4.reg_date,t4.realname,t4.idno,t4.register_ip,
t.work_tel,t4.email,t4.login_pwd,case when t3.gate_name like '%易宝%' then '易宝'
when t3.gate_name like '%商旅卡%' then '商旅卡' 
else '其他' end 支付渠道,case when t2.users_id is not null then 1 
else 0 end 是否代理,case when t5.feature_value is not null then 1 else 0 end 是否特征值,
t4.login_times,t.remote_ip,t4.last_login_ip,t8.country,t8.city,
count(1),sum(case when t1.flag_id in(3,5,40,7,11,12) then 1 else 0 end) succcess,
sum(case when t1.flag_id not in(3,5,40,7,11,12) then 1 else 0 end) failed,
sum(case when t1.flag_id in(3,5,40,7,11,12)  and t.terminal_id<0 and t.web_id=0 then 1 else 0 end) webnum,
count(distinct t.client_id),
count(distinct t1.name||t1.codeno)
  from stg.s_cq_order t
  join stg.s_cq_order_head t1 on t.flights_order_id = t1.flights_Order_id
  left join dw.da_restrict_userinfo t2 on t.client_id = t2.users_id
  left join stg.p_cq_pay_gate t3 on t.pay_gate=t3.id
  left join stg.c_cq_flights_users t4 on t.client_Id=t4.users_id
  left join cqsale.CQ_BLACK_FEATURE_RULE_DETAIL@to_air t5 on t.work_tel=t5.feature_value
  left join dw.adt_mobile_list t6 on substr(t.work_tel,1,7) =t6.mobilenumber
    left join dw.adt_mobile_list t7 on substr(t4.login_id,1,7) =t7.mobilenumber
    left join hdb.tbl_iprepository t8 on t.remote_ip=t8.ip   
    where t.order_date >= trunc(sysdate-4)
   and t.order_date < trunc(sysdate)
   and t.terminal_id < 0
   --and t4.login_pwd='73C8918C3FB14EB28138F3CEE4480290'
   and t.web_id = 0
   --and t1.r_tel is null
   and t.r_company_id = 0
   and t2.users_id is null   
   and t4.register_ip='10.0.2.15'
   and t.pay_gate in(15,29,31)
   group by t.work_tel,t4.email,t4.login_pwd,t4.login_times,t4.last_login_ip,t.remote_ip,t8.country,t8.city,case when t3.gate_name like '%易宝%' then '易宝'
when t3.gate_name like '%商旅卡%' then '商旅卡' 
else '其他' end ,case when t2.users_id is not null then 1 
else 0 end ,case when t5.feature_value is not null then 1 else 0 end ,t4.reg_date,t4.realname,t4.idno,t4.register_ip,t4.login_id,t7.city,t6.city
--having count(1)>=10


select t4.reg_date,t4.login_id,t7.city,t7.province,t4.email,t4.realname,t4.idno,t4.register_ip,t8.country,t8.city,t9.ip,t9.country,t9.city
from  stg.c_cq_flights_users t4 
    left join dw.adt_mobile_list t7 on substr(t4.login_id,1,7) =t7.mobilenumber
    left join hdb.tbl_iprepository t8 on t4.register_ip=t8.ip
    left join hdb.tbl_iprepository t9 on t4.last_login_ip=t9.ip
where t4.reg_date>=trunc(sysdate-4)
and t4.login_pwd='73C8918C3FB14EB28138F3CEE4480290'



select count(1),min(reg_date) from cust.cq_flights_users@to_air
where /*reg_date>=trunc(sysdate-180)
and*/ email like '%gao%'
and email like '%chunqiu%'


select 
from stg.c_cq_flights_users
