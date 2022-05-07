select  h1.users_id||',' usersid,h1.*
from(
select t1.users_id,t1.email,split_part(t1.email,'@',2) email2,case when t2.users_id is not null then '¥˙¿Ì'
else null end agenttype,case when t4.flag in(4,5) then '±ª∑‚'
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




YOPmail

Õ¯÷∑£∫http://www.yopmail.com/zh/

10∑÷÷”” œ‰
Õ¯÷∑£∫https://10minutemail.net/error-due.html


BccTo.ME

Õ¯÷∑£∫http://bccto.me/



24–° ±” œ‰

Õ¯÷∑£∫http://24mail.chacuo.net/