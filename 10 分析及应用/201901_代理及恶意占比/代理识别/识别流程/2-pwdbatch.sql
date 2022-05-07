--2、pwd-batch

with  user_suspect_identify  as
(
select h2.*,trunc(sysdate) create_date
from(
select h1.*
from(
select users_id,reg_date,LOGIN_PWD,register_ip,email,split_part(email,'@',2) email2, login_id,
sum(count(1))over(partition by register_ip,login_pwd) ipnum,2 flag
from CUST.cq_flights_users@TO_AIR
where reg_date>=trunc(sysdate-1)
and register_ip is not null
and not regexp_like(register_ip,'^(10.0)|(192.168)|(127.0.0.1)|(0.0.0.0)')
group by users_id,reg_date,LOGIN_PWD,register_ip,email,split_part(email,'@',2),login_id)h1
where h1.ipnum>=100


union all

select h1.*
from(
select users_id,reg_date,LOGIN_PWD,register_ip,email,split_part(email,'@',2)  email2,login_id,
sum(count(1))over(partition by split_part(email,'@',2),LOGIN_PWD) emailnum,1 flag
from CUST.cq_flights_users@TO_AIR
where reg_date>=trunc(sysdate-1)
and email is not null
and email like '%@%'
group by users_id,reg_date,LOGIN_PWD,register_ip,email,split_part(email,'@',2)  ,login_id)h1
where  h1.emailnum>=100
)h2)

--导入代理表  memo:register-batch
select distinct t1.users_id||',',t1.*
from user_suspect_identify t1
left join cqsale.cq_user_restrict@to_air t2 on t1.users_id=t2.user_id and t2.flag in(4,5,0)
where t2.user_id is null;
