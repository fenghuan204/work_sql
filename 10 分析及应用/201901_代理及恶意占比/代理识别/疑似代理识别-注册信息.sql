---疑似代理账号 （注册IP地址对应账号数、注册账号密码为同一个账号）

select h3.*
from(
select h2.*,case when h2.pwdnum>=300 then '注册密码'
when h2.ipnum>=300 then 'IP' end 识别方式,row_number()over(partition by h2.users_Id order by xid) nrow
from(
select h1.*
from(
select users_id,reg_date,LOGIN_PWD,register_ip,email,split_part(email,'@',2) email2, login_id,sum(count(1))over(partition by register_ip) ipnum,
sum(count(1))over(partition by LOGIN_PWD) pwdnum,3 xid
from stg.c_cq_flights_users
where reg_date>=trunc(sysdate-30)
and register_ip is not null
and not regexp_like(register_ip,'^(10.0)|(192.168)|(127.0.0.1)|(0.0.0.0)')
group by users_id,reg_date,LOGIN_PWD,register_ip,email,split_part(email,'@',2),login_id)h1
where h1.ipnum>=300

union all

select h1.*
from(
select users_id,reg_date,LOGIN_PWD,register_ip,email,split_part(email,'@',2)  email2,login_id,sum(count(1))over(partition by register_ip) ipnum,
sum(count(1))over(partition by LOGIN_PWD) pwdnum,2
from stg.c_cq_flights_users
where reg_date>=trunc(sysdate-30)
--and not regexp_like(register_ip,'^(10.0)|(192.168)|(127.0.0.1)')
group by users_id,reg_date,LOGIN_PWD,register_ip,email,split_part(email,'@',2)  ,login_id)h1
where  h1.pwdnum>=300



---疑似代理账号 （使用随机邮箱注册）
union all


select users_id,reg_date,LOGIN_PWD,register_ip,email,split_part(t1.email,'@',2) email2,login_id,sum(count(1))over(partition by register_ip) ipnum,
sum(count(1))over(partition by LOGIN_PWD) pwdnum,1
from stg.c_cq_flights_users t1
where reg_date>=trunc(sysdate-30)
and t1.email is not null
and split_part(t1.email,'@',2)  in('m.bccto.me','mail.libivan.com','bccto.me','www.bccto.me','dawin.com','chaichuang.com','m.bccto.me','4057.com','vedmail.com',
'3202.com','cr219.com','oiizz.com','juyouxi.com','68apps.com','a7996.com','jnpayy.com','yidaiyiluwang.com','wca.cn.com','gbf48123.com',
'qunar.com','my-zelala.net','etc2019.top','asd.com','7nac.cn')
group by users_id,reg_date,LOGIN_PWD,register_ip,email,split_part(t1.email,'@',2) ,login_id
)h2)h3
where h3.nrow=1






---查找邮箱异常的账号

select  h1.*
from(
select t1.users_id,t1.email,split_part(t1.email,'@',2) email2,case when t2.users_id is not null then '代理'
else null end agenttype,case when t4.flag in(4,5) then '被封'
else '2' end type1,t2.feature_value,t3.last_orderdate,t3.ordernum,t3.CHNUM
from stg.c_cq_flights_users t1
left join dw.da_restrict_userinfo t2 on t1.users_id=t2.users_id
left join dw.da_user_purchase t3 on t1.users_id=t3.users_id
left join cqsale.cq_user_restrict@to_air t4 on t1.users_id=t4.user_id
where reg_date>=trunc(sysdate-60)
and t1.email is not null
and split_part(t1.email,'@',2)  in('m.bccto.me','mail.libivan.com','bccto.me','www.bccto.me','dawin.com','chaichuang.com',
'm.bccto.me','4057.com','vedmail.com',
'3202.com','cr219.com','oiizz.com','juyouxi.com','68apps.com','a7996.com','jnpayy.com','yidaiyiluwang.com','wca.cn.com','gbf48123.com',
'my-zelala.net','etc2019.top','asd.com','wo.com','wo.com.cn','7nac.cn'))h1
where h1.type1 ='2'



