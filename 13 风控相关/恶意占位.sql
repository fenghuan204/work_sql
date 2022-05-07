select t.flights_order_id,t.order_date,t1.r_flights_date,t.client_id||',',t.work_tel,t.email,t.order_date,t1.flag_id,t1.r_tel,case when t.terminal_id<0 and t.web_id=0 then '线上自有'
when t.terminal_id<0 and t.web_id>0 then 'OTA'
else '其他' end 渠道,t4.email,t4.login_id,t4.reg_date,t4.EX_NFD2,t.remote_ip,t4.register_ip,t.ex_nfd1,t4.memo,
t4.login_pwd,t5.users_id_fk,t5.login_times,lower(md5(nvl(t4.login_id,t4.email))) md5,t6.flag
  from cqsale.cq_order@to_air t
  join cqsale.cq_order_head@to_air t1 on t1.flights_order_id=t.flights_Order_Id
    left join cust.cq_flights_users@to_air t4 on t.client_id=t4.users_id
    left join dw.da_lyuser t5 on t.client_id=t5.users_id_fk
    left join cqsale.cq_user_restrict@to_air t6 on t.client_id=t6.user_id
  where t1.whole_segment like '%TAOSYX%'
   and t.order_date>=trunc(sysdate)
   and t1.flag_id in(8,9,10)
   and t.terminal_id<0
   and t.web_id=0
   and nvl(t4.login_id,t4.email) is not null;
   
 
  select distinct h1.client_id||',',h1.login_id,h1.reg_date,h1.ex_nfd2
from(
select t.client_id,t.work_tel,t.email,t.order_date,t1.flag_id,t1.r_tel,case when t.terminal_id<0 and t.web_id=0 then '线上自有'
when t.terminal_id<0 and t.web_id>0 then 'OTA'
else '其他' end 渠道,t4.email,t4.login_id,t4.reg_date,t4.ex_nfd2,t4.memo
  from cqsale.cq_order@to_air t
  join cqsale.cq_order_head@to_air t1 on t1.flights_order_id=t.flights_Order_Id
    left join cust.cq_flights_users@to_air t4 on t.client_id=t4.users_id
  where --t1.flights_order_id='VKLFDG'
   t1.r_flights_date=trunc(sysdate)+2
   and t1.whole_flight ='9C6299'
   /*and t1.flag_id=2*/)h1;
   
   
  select t.*
 from cust.cq_flights_users@to_air t
 where reg_date>=trunc(sysdate)-7
 and t.register_ip in('110.251.242.229','123.121.238.162','111.201.148.184','124.64.19.204','101.230.218.11')
 and t.login_pwd='8F3ABD1350E060D0C82E44887938EE65';
 
 
 --验证恶意占位情况
 select t2.login_id,t1.pay_flag,count(1)
from cqsale.cq_order@to_air t1
join cust.cq_flights_users@to_air t2 on t1.client_id=t2.users_id
where t1.mobile in('18528210377','19118853872','18692235031','13430539846','17673107501','15573160130','18570109980')
and t1.order_date>=trunc(sysdate)-30
group by t2.login_id,t1.pay_flag




 select t1.work_tel,t1.pay_flag,count(1)
from cqsale.cq_order@to_air t1
join cqsale.cq_Order_head@to_air t3 on t1.flights_order_id=t3.flights_order_id
join cust.cq_flights_users@to_air t2 on t1.client_id=t2.users_id
where t3.r_tel ='13973063911'
and t1.order_date>=trunc(sysdate)-30
group by t1.work_tel,t1.pay_flag
