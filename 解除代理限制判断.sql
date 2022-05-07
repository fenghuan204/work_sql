select * from dw.da_restrict_userinfo t12
where t12.users_id=168967844
t12.feature_value='164876352';

select * from dw.da_b2c_user
where login_id='18931159770';

select lower(md5('18284197563')) from dual 


select * from cqsale.cq_user_restrict@to_air t1
where t1.user_id=158887576;

select * from cust.cq_flights_users_huiyuan@to_air
where users_id_fk ='158887576';


select t.flights_order_id,t.client_id,t.order_date,t.order_linkman,t.work_tel,t.email,t.remote_ip,c.channel,c.terminal,t1.name||coalesce(t1.second_name,'') sname,
t1.codeno,t1.r_tel,t2.flights_segment_name,t1.flag_id,t.EX_CFD4
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

where-- t.client_id=188415438
--t1.r_tel='13311750526'
--and t.terminal_id<0
--t.client_id=174576022
--t.flights_order_id='WDFPEI'
t.work_tel='15516557676'
and t.order_date>=trunc(sysdate)-7



select *
 from dw.da_restrict_userinfo@to_ods
 where users_id=162540430


select *
 from dw.da_b2c_user
 where users_id=162540430
 
 18284197563
 
 15810071790
 
 select lower(md5('15810071790'))
  from dual



select h1.users_id
from(
select h1.users_id,h1.identify||h1.feature_value from dw.da_restrict_userinfo h1
where h1.feature_value in('18439513330','18923780956')

union 

select h1.client_id,h1.feature||h1.feature_value
from hdb.wb_agent_rcd h1
where h1.feature_value in('18439513330','18923780956')

union 

select  user_id,t1.memo
from cqsale.cq_user_restrict@to_air t1
where memo like '%深圳市汇鹏商务有限公司%')h1




------优惠券数据-------------------


select distinct t1.users_id,t1.create_date,t1.effective_date,case when t2.users_id is not null then '代理'
else '非代理' end,t2.identify,t2.feature_value,t3.login_pwd,t3.email,split_part(t3.email,'@',2) email2,
t3.login_id,
t3.reg_date,
t3.register_ip,t5.*
from yhq.cq_new_yhq_relation@to_air t1
left join cqsale.cq_user_restrict@to_air t4 on t1.users_id=t4.user_id and t4.flag in(4,5)
left join dw.da_restrict_userinfo t2 on t1.users_id=t2.users_id
left join stg.c_cq_flights_users t3 on t1.users_id=t3.users_id
left join dw.bi_yhq_batch t5 on to_char(t1.create_id)=t5.batch_id
where  t1.users_id=174933741;




---------验证pwd认证方式


select reg_date,login_id,login_pwd,realname,email,login_times,last_login_ip,register_ip
from stg.c_cq_flights_users
where login_pwd in(select login_pwd from stg.c_cq_flights_users
where users_id=175457857) 
and reg_date>=trunc(sysdate-1)
and reg_date< trunc(sysdate-1)+1;




