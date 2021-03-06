--1、邮箱异常的账号

--create view dw.v_fact_agent_identify as
select  h1.users_id||',' usersid,h1.*
from(
select t1.users_id,t1.reg_date,t1.email,split_part(t1.email,'@',2) email2,case when t2.users_id is not null then '代理'
else null end agenttype,case when t4.flag in(4,5) then '被封'
else '2' end type1,t2.feature_value,t3.last_orderdate,t3.ordernum,t3.CHNUM
from cust.cq_flights_users@to_air t1
left join dw.da_restrict_userinfo t2 on t1.users_id=t2.users_id
left join dw.da_user_purchase t3 on t1.users_id=t3.users_id
left join cqsale.cq_user_restrict@to_air t4 on t1.users_id=t4.user_id
where reg_date>=trunc(sysdate-1)
and t1.email is not null
and split_part(t1.email,'@',2)  in('m.bccto.me','mail.libivan.com','bccto.me','www.bccto.me','dawin.com','chaichuang.com',
'm.bccto.me','4057.com','vedmail.com',
'3202.com','cr219.com','oiizz.com','juyouxi.com','68apps.com','a7996.com','jnpayy.com','yidaiyiluwang.com','wca.cn.com','gbf48123.com',
'my-zelala.net','etc2019.top','asd.com','wo.com','wo.com.cn','7nac.cn','chacuo.net',
'eowe.vmlwa',
'sfwl.fns',
'785fw.vmwewe6',
'659.woew',
'yopmail.com',
'njfwo.vuwoejo',
'weoofw.vwlkoe',
'1263.cwe',
'weew36.fmlw',
'wjeow.366fs',
'ewojeow.mvow'))h1
where h1.type1 ='2';

--2、导入封杀表

--create view dw.v_fact_mid_dataimport as
select t1.user_id,case when t3.identify='troy' then 'troy'||'--'||t3.feature
else t3.identify end feature,t3.feature_id,t3.feature_value,trunc(sysdate-1) create_date,87 batch_id
from cqsale.cq_user_restrict@to_air t1
left join hdb.wb_agent_rcd t2 on t2.client_id=t1.user_id
left join dw.da_restrict_userinfo t3 on t1.user_id=t3.users_id
where t1.flag in(4,5)
and t2.client_id is null;


---3、筛选相关账号

with tp as(
select t1.client_id
from hdb.wb_agent_rcd_factor t1
left join cqsale.cq_user_restrict@to_air t4 on t1.client_id=t4.user_id and t4.flag in(4,5)
where t4.user_id is  null)
select client_id||',' clientid from tp sample(50)
order by dbms_random.value;


---4、订单数量多

select *
from(
select h1.work_tel,h1.client_id,h1.agentflag,h1.banned,h1.paynum,h1.cancelnum,h1.payorders,h1.cancelorders,
sum(paynum)over(partition by h1.work_tel) allpaynum,
sum(cancelnum)over(partition by h1.work_tel) allcancelnum,
sum(payorders)over(partition by h1.work_tel) allpayorders,
sum(cancelorders)over(partition by h1.work_tel) allcancelorders
from(
select t.work_tel,t.client_id,
case when t2.users_id is not null then '代理'
else '非代理' end agentflag,
case when t3.user_id is not null then '封杀'
else '未封杀' end banned,
sum(case when t1.flag_id in(3,5,40,41,7,11,12) then 1 else 0 end) paynum,
sum(case when t1.flag_id not in(3,5,40,41,7,11,12) then 1 else 0 end) cancelnum,
count(distinct case when t1.flag_id in(3,5,40,41,7,11,12) then t.flights_order_id else null end) payorders,
count(distinct case when t1.flag_id not in(3,5,40,41,7,11,12) then t.flights_Order_Id else null end) cancelorders
 from stg.s_cq_order t
 join stg.s_cq_order_head t1 on t.flights_order_id=t1.flights_order_id
 left join dw.da_restrict_userinfo t2 on t.client_id=t2.users_id
 left join stg.s_cq_user_restrict t3 on t.client_id=t3.user_id
 where t.order_date>=trunc(sysdate-30)
   and t.order_date< trunc(sysdate)
   and t1.whole_flight like '9C%'
   and t1.seats_name is not null 
   and t1.seats_name not in('B','G','G1','G2','O')
   and t.terminal_id=-1
   and t.web_id=0
   and getmobile(t.work_tel) <>'-'
   group by t.work_tel,t.client_id,
case when t2.users_id is not null then '代理'
else '非代理' end ,
case when t3.user_id is not null then '封杀'
else '未封杀' end)h1)h2
where h2.allpaynum+h2.allcancelnum>=300;


---4.1 超时取消过多


--订票人联系方式

select h2.*,h3.mobile
from(
select h1.work_tel,h1.client_id,h1.agentflag,h1.banned,h1.cancelnum,h1.passenger,
sum(cancelnum)over(partition by h1.work_tel) cancelnums,
sum(passenger)over(partition by h1.work_tel) passengers
from(
select t.work_tel,t.client_id,
case when t2.users_id is not null then '代理'
else '非代理' end agentflag,
case when t3.user_id is not null then '封杀'
else '未封杀' end banned,
count(1) cancelnum,
count(distinct t1.name||t1.codeno) passenger
 from stg.s_cq_order t
 join stg.s_cq_order_head t1 on t.flights_order_id=t1.flights_order_id
 left join dw.da_restrict_userinfo t2 on t.client_id=t2.users_id
 left join stg.s_cq_user_restrict t3 on t.client_id=t3.user_id
 where t.order_date>=trunc(sysdate-30)
   and t.order_date< trunc(sysdate)
   and t1.whole_flight like '9C%'
   and t1.seats_name is not null 
   and t1.seats_name not in('B','G','G1','G2','O')
   and t.terminal_id=-1
   and t.web_id=0
   and t1.flag_id=8
   and getmobile(t.work_tel) <>'-'
   group by t.work_tel,t.client_id,
case when t2.users_id is not null then '代理'
else '非代理' end ,
case when t3.user_id is not null then '封杀'
else '未封杀' end)h1)h2
left join (select distinct feature_value mobile from dw.da_restrict_userinfo 
where feature_value is not null 
and getmobile(feature_value)<>'-')h3 on h2.work_tel=h3.mobile
where cancelnums>=300;
 



--乘机人联系方式

select h2.*,h3.mobile
from(
select h1.work_tel,h1.client_id,h1.agentflag,h1.banned,h1.cancelnum,h1.passenger,
sum(cancelnum)over(partition by h1.work_tel) cancelnums,
sum(passenger)over(partition by h1.work_tel) passengers
from(
select t1.r_tel work_tel,t.client_id,
case when t2.users_id is not null then '代理'
else '非代理' end agentflag,
case when t3.user_id is not null then '封杀'
else '未封杀' end banned,
count(1) cancelnum,
count(distinct t1.name||t1.codeno) passenger
 from stg.s_cq_order t
 join stg.s_cq_order_head t1 on t.flights_order_id=t1.flights_order_id
 left join dw.da_restrict_userinfo t2 on t.client_id=t2.users_id
 left join stg.s_cq_user_restrict t3 on t.client_id=t3.user_id
 where t.order_date>=trunc(sysdate-30)
   and t.order_date< trunc(sysdate)
   and t1.whole_flight like '9C%'
   and t1.seats_name is not null 
   and t1.seats_name not in('B','G','G1','G2','O')
   and t.terminal_id=-1
   and t.web_id=0
   and t1.flag_id=8
   and getmobile(t1.r_tel) <>'-'
   group by t1.r_tel,t.client_id,
case when t2.users_id is not null then '代理'
else '非代理' end ,
case when t3.user_id is not null then '封杀'
else '未封杀' end)h1)h2
left join (select distinct feature_value mobile from dw.da_restrict_userinfo 
where feature_value is not null 
and getmobile(feature_value)<>'-')h3 on h2.work_tel=h3.mobile
where cancelnums>=300;


--邮箱

select h2.*,h3.mobile
from(
select h1.work_tel,h1.client_id,h1.agentflag,h1.banned,h1.cancelnum,h1.passenger,
sum(cancelnum)over(partition by h1.work_tel) cancelnums,
sum(passenger)over(partition by h1.work_tel) passengers
from(
select t.email work_tel,t.client_id,
case when t2.users_id is not null then '代理'
else '非代理' end agentflag,
case when t3.user_id is not null then '封杀'
else '未封杀' end banned,
count(1) cancelnum,
count(distinct t1.name||t1.codeno) passenger
 from stg.s_cq_order t
 join stg.s_cq_order_head t1 on t.flights_order_id=t1.flights_order_id
 left join dw.da_restrict_userinfo t2 on t.client_id=t2.users_id
 left join cqsale.cq_user_restrict@to_air t3 on t.client_id=t3.user_id
 where t.order_date>=trunc(sysdate-30)
   and t.order_date< trunc(sysdate)
   and t1.whole_flight like '9C%'
   and t1.seats_name is not null 
   and t1.seats_name not in('B','G','G1','G2','O')
   and t.terminal_id=-1
   and t.web_id=0
   and t1.flag_id=8
   and t.email like '%@%'
   group by t.email ,t.client_id,
case when t2.users_id is not null then '代理'
else '非代理' end ,
case when t3.user_id is not null then '封杀'
else '未封杀' end)h1)h2
left join (select distinct feature_value mobile from dw.da_restrict_userinfo 
where feature_value  like '%@%')h3 on h2.work_tel=h3.mobile
where cancelnums>=300
and h2.banned='未封杀'
 
