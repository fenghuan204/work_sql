

--实时封杀邮箱异常的用户，并针对IP、注册密码、邮箱交叉维度验证有问题的账号进行封杀；

--邮箱异常 email-batch
select  h1.users_id||',' usersid,h1.*
from(
select t1.users_id,t1.reg_date,t1.email,split_part(t1.email,'@',2) email2,
case when t2.users_id is not null then '代理'
else null end agenttype,case when t4.flag  is not null then '被封'
else '2' end type1,t2.feature_value,t3.last_orderdate,t3.ordernum,t3.CHNUM
from cust.cq_flights_users@to_air t1
left join dw.da_restrict_userinfo t2 on t1.users_id=t2.users_id
left join dw.da_user_purchase t3 on t1.users_id=t3.users_id
left join cqsale.cq_user_restrict@to_air t4 on t1.users_id=t4.user_id and t4.flag in(4,5)
where reg_date>=trunc(sysdate-7)
and t1.email is not null
and (split_part(t1.email,'@',2)  in(
'm.bccto.me',
'mail.libivan.com',
'bccto.me',
'www.bccto.me',
'dawin.com',
'chaichuang.com',
'4057.com',
'vedmail.com',
'3202.com',
'cr219.com',
'oiizz.com',
'juyouxi.com',
'68apps.com',
'a7996.com',
'jnpayy.com',
'yidaiyiluwang.com',
'wca.cn.com',
'gbf48123.com',
'my-zelala.net',
'etc2019.top',
--'asd.com',
--'7nac.cn',
'chacuo.net',
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
'ewojeow.mvow',
'wfw.fwkljl3',
'ouewoe.45eq',
'819110.com',
'oiuoqwjeqw.11aa',
'czpanda.cn',
'jiaxin8736.com',
'advaoptical.com',
'ywiohea.klwqwe',
'77452ds.fwp',
'yeohdls.32dsfaw',
'qieoqqw.llkq',
'yeooa.322sa',
'yuweoej.mnewq',
'yoehoq.nmzss',
'4579.jwlje',
'ueqooq.3365',
'yeoheoq.669qw',
'mail.bccto.me',
'899079.com',
'xunixiaozhan.com',
'120mail.com',
'1766258.com',
'xuyushuai.com',
'sltmail.com',
'ag163.top',
' chacuo.net',
'fubuki.shp7.cn',
'mail.re173q9.com',
'mail.202y.cn',
'mail.fgoyq.com',
'56787.com',
'mail.wvwvw.tech',
'heihamail.com',
'yopmail.fr',
'yopmail.net',
'cool.fr.nf',
'jetable.fr.nf',
'nospam.ze.tc',
'nomail.xl.cx',
'mega.zik.dj',
'speed.1s.fr',
'courriel.fr.nf',
'moncourrier.fr.nf',
'monemail.fr.nf',
'monmail.fr.nf',
'gaochunqiu.net',
'gao.chunqiu',
'sp-jsontech.net',
'outlv.com',
'asd.com',
'7nac.cn',
'mail.jpgames.net',
'fremail.club',
'pincoffee.com',
'agbm.cc',
'114207.com',
'opmmail.com',
'evcmail.com',
'fxfmail.com',
'gao.chunqiu',
'027168.com',
'sharklasers.com',
'urhen.com',
'guerrillamail.info',
'grr.la',
'guerrillamail.biz',
'guerrillamail.com',
'guerrillamail.de',
'guerrillamail.net',
'guerrillamail.org',
'guerrillamailblock.com',
'pokemail.net',
'spam4.me',
'9em.org',
'10min.club',
'10mins.org',
'mt2015.com',
'mt2014',
'thankyou2010.com',
'trash2009.com',
'mt2009.com',
'trashymail.com',
'mytrashmail.com',
'0box.com',
'contbay.com',
'damnthespam.com',
'kurzepost.de',
'objectmail.com',
'proxymail.eu',
'rcpt.at',
'trash-mail.at',
'trashmail.at',
'trashmail.com',
'trashmail.io',
'trashmail.net',
'trashmail.me',
'wegwerfmail.de',
'wegwerfmail.net',
'wegwerfmail.org',
'10minutemail.net',
'4533.top',
'hotmali.cn',
'yxpf.xyz',
'haimai.pro',
'4533.top',
'hotmali.cn',
'yxpf.xyz',
'haimai.pro',
'80600.net',
'jnpayy.com',
'119mail.com',
'4057.com',
'chaichuang.com',
'a7996.com',
'120mail.com',
'pincoffee.com',
'263mali.cn',
'1766258.com',
'juyouxi.com',
'huaweimali.cn',
'ag163.top',
'4533.top',
'hotmali.cn',
'yxpf.xyz',
'haimai.pro'
/*,
'wo.com',
'wo.com.cn'*/
) 
)


)h1
where h1.type1 ='2';

--直接导入cqsale.cq_user_restrict





--2、注册IP、注册邮件、注册密码等交叉维度识别


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

--导入代理表  memo:pwd-batch
select distinct t1.users_id||',',t1.*
from user_suspect_identify t1
left join cqsale.cq_user_restrict@to_air t2 on t1.users_id=t2.user_id and t2.flag in(4,5,0)
where t2.user_id is null;

---3、注册账号登录次数、注册天数的之间的关系进行判断

select t.users_id||',' usersid,trunc(reg_date),t.users_id,t.login_times,t.last_login_time,t.login_times/(trunc(t.last_login_time)+1-trunc(t.reg_date)) avgtimes,
t.email,t.login_pwd,t.reg_date,t.realname,t1.memo,t1.user_id,t1.flag
from cust.cq_flights_users@to_air t
left join cqsale.cq_user_restrict@to_air t1 on t.users_id=t1.user_id
where t.reg_date>=trunc(sysdate-1)
--and trunc(t.last_login_time)+1-trunc(t.reg_date)<=3
and t.login_times/(trunc(t.last_login_time)+1-trunc(t.reg_date))>=100
and nvl(t1.flag,0) not in(4,5);






--账号取消订票过多（恶意占座的账号）：新增特征值、封杀相关账号；
TRUNCATE TABLE hdb.mid_agent_select_cancel;

insert into hdb.mid_agent_select_cancel
select h2.*,h3.mobile,1 flag,trunc(sysdate) create_date
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
 left join stg.s_cq_user_restrict t3 on t.client_id=t3.user_id  and t3.flag  in(4,5)
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
where cancelnums>=300
 

union all

select h2.*,h3.mobile,2 flag,sysdate create_date
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
 left join stg.s_cq_user_restrict t3 on t.client_id=t3.user_id and t3.flag  in(4,5)
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
where cancelnums>=300


union all


select h2.*,h3.mobile,3 flag,sysdate create_date
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
 left join stg.s_cq_user_restrict t3 on t.client_id=t3.user_id and t3.flag  in(4,5)
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
where cancelnums>=300;


commit;


---查询及封杀账号 (查找未识别到的特征值)

select t1.work_tel,t1.flag,t1.agentflag,case when t3.user_id is not null then '封杀'
else '未封杀' end banned,
case when t2.feature_id is not null then 1 else 0 end 是否规则,count(1)
from hdb.mid_agent_select_cancel t1
left join cqsale.CQ_BLACK_FEATURE_RULE_DETAIL@to_air t2 on t1.work_tel=t2.feature_value
left join cqsale.cq_user_restrict@to_air t3 on t1.client_id=t3.user_id and t3.flag in(4,5)
where t1.feature is null
group by t1.work_tel,t1.flag,t1.agentflag,case when t3.user_id is not null then '封杀'
else '未封杀' end,case when t2.feature_id is not null then 1 else 0 end;

--导入代理账号 memo:cancel-batch

select distinct t1.client_id||','
from hdb.mid_agent_select_cancel t1
left join cqsale.cq_user_restrict@to_air t3 on t1.client_id=t3.user_id and t3.flag in(4,5,0)
where  t3.user_id is null;


针对特征值、troy识别筛选销售机票较多的账号进行分批封杀；
---导入factor-batch的历史数据表
delete from hdb.wb_agent_rcd_factor tt
where tt.client_id in(select client_id from hdb.wb_agent_rcd_factor_history);

commit;

insert into hdb.wb_agent_rcd_factor_history
select * from hdb.wb_agent_rcd_factor;

commit;


---重新识别factor-batch的账号

truncate table hdb.wb_agent_rcd_factor;

insert into hdb.wb_agent_rcd_factor
select h2.*, case when h2.tnum/h2.totalnum<=0.2 then 0.2
when h2.tnum/h2.totalnum<=0.4 then 0.4
when h2.tnum/h2.totalnum<=0.6 then 0.6
when h2.tnum/h2.totalnum<=0.8 then 0.8
when h2.tnum/h2.totalnum<=1 then 1 end factor,
trunc(sysdate) create_date,
null factor_flag
from(
select h1.client_id,h1.feature,h1.feature_id,h1.feature_value,h1.ticketnum,h1.totalnum1,h3.pnum,
sum(h1.ticketnum)over(partition by h1.feature,h1.feature_value order by h1.ticketnum desc) tnum,
sum(h1.ticketnum)over(partition by h1.feature,h1.feature_value) totalnum
from(
select t1.client_id,case when t2.identify='troy' then 'troy'||'--'||t2.feature
else t2.identify end feature,t2.feature_id,t2.feature_value,count(1) ticketnum,
sum(count(1))over(partition by case when t2.identify='troy' then 'troy'||'--'||t2.feature
else t2.identify end,t2.feature_id,t2.feature_value) totalnum1
  from dw.fact_order_detail t1
  left join dw.da_restrict_userinfo t2 on t1.client_id=t2.users_id
  where t1.channel in('网站','手机')
    and t1.company_id=0
    and t1.order_day>=trunc(sysdate-60)
    and t1.seats_name is not null
    and t2.users_id is not null
    and t1.seats_name <>'O'
    group by t1.client_id,case when t2.identify='troy' then 'troy'||'--'||t2.feature
else t2.identify end,t2.feature_value,t2.feature_id
)h1
left join (
select case when t2.identify='troy' then 'troy'||'--'||t2.feature
else t2.identify end feature,t2.feature_id,t2.feature_value,count(distinct t1.traveller_name||t1.codeno) pnum
  from dw.fact_order_detail t1
  left join dw.da_restrict_userinfo t2 on t1.client_id=t2.users_id
  where t1.channel in('网站','手机')
    and t1.company_id=0
    and t1.order_day>=trunc(sysdate-60)
    and t1.seats_name is not null
    and t2.users_id is not null
    and t1.seats_name <>'O'
    group by case when t2.identify='troy' then 'troy'||'--'||t2.feature
else t2.identify end ,t2.feature_id,t2.feature_value
)h3 on h1.feature=h3.feature and nvl(h1.feature_value,'-')=nvl(h3.feature_value,'-') and nvl(h1.feature_id,0)=nvl(h3.feature_id,0)
where not exists (select 1 from hdb.wb_agent_rcd tt1
where tt1.client_id=h1.client_id)
and not exists(select 1 from dw.da_lyuser tt2
where tt2.users_id_fk is not null
and tt2.users_id_fk=h1.client_id)
and regexp_like(h1.feature,'(troy)|(去哪儿)|(金翔达商旅)|(特征库)')
)h2
where (h2.feature like '%troy%' or (h2.feature not like '%troy%' and h2.totalnum1>60))
and h2.pnum/h2.totalnum> 0.2;

commit;

delete from hdb.wb_agent_rcd_factor tt
where tt.client_id in (select user_id from cqsale.cq_user_restrict@to_air where flag in(4,5,0));

commit;

---导入代理账号 memo = factor-batch
---分批次导入代理表
with tp as(
select t1.client_id
from hdb.wb_agent_rcd_factor t1
left join cqsale.cq_user_restrict@to_air t4 on t1.client_id=t4.user_id and t4.flag in(4,5,0)
where t4.user_id is  null)
select client_id||',' clientid from tp sample(50)
order by dbms_random.value;


select client_id||',' clientid from hdb.wb_agent_rcd_factor sample(50)
order by dbms_random.value;



针对领取优惠券、使用优惠券的代理账号封杀；
--优惠券领用数据
select h1.*
from(
select t1.users_id,
       t1.create_date 创建时间,
       t1.status 是否使用,
       t1.effective_date 有效期,
       case
         when t2.users_id is not null then
          '代理'
         else
          '非代理'
       end 代理与否,
       case
         when t4.user_id is not null then
          '封杀'
         else
          '未封杀'
       end banned,
       case when t6.cust_id is not null then '绿翼'
       else '非绿翼' end 是否绿翼,
       t2.identify 识别方式,
       t2.feature_value 识别特征值,
       t4.memo 识别备注,
       t5.batch_id,
       t5.act_name 活动名称,
       t5.user_type 活动类型,
       t5.money_type 优惠类型,
       t5.if_same_name,
       t5.yh_type,
       sum(t5.money_var) 优惠金额
  from yhq.cq_new_yhq_relation@to_air t1
  left join cqsale.cq_user_restrict@to_air t4 on t1.users_id = t4.user_id
                                             and t4.flag in (4, 5, 0)
  left join dw.da_restrict_userinfo t2 on t1.users_id = t2.users_id
  left join dw.bi_yhq_batch t5 on to_char(t1.create_id) = t5.batch_id
  left join dw.da_lyuser t6 on t1.users_id=t6.users_id_fk
 where t1.create_date >= trunc(sysdate - 7)
   and t2.users_id is not null
 group by t1.users_id,
          t1.create_date,
          t1.status,
          t1.effective_date,
          case
            when t2.users_id is not null then
             '代理'
            else
             '非代理'
          end,
          case
            when t4.user_id is not null then
             '封杀'
            else
             '未封杀'
          end,
          t2.identify,
          t2.feature_value,
          t4.memo,
          t5.batch_id,
          t5.act_name,
          t5.user_type,
          t5.if_same_name,
          t5.yh_type,
          t5.money_type,
          case when t6.cust_id is not null then '绿翼'
       else '非绿翼' end)h1
       where h1.banned='未封杀';



--代理使用券的信息

select h1.*
from(
select t.client_id,h1.use_date,case when t2.users_id is not null then '代理'
else '非代理' end,case when t3.user_id is not null then '封杀'
else '未封杀' end banned,
 case when t6.cust_id is not null then '绿翼'
       else '非绿翼' end 是否绿翼,
       t2.identify 识别方式,
       t2.feature_value 识别特征值,
       t3.memo 识别备注,t5.batch_id,
       t5.act_name 活动名称,
       t5.user_type 活动类型,
       t5.money_type 优惠类型,
       t5.if_same_name,
       t5.yh_type,
       sum(h1.use_money) 优惠金额
from dw.bi_yhq_use h1
join stg.s_cq_order t on h1.flights_order_id=t.flights_Order_id
left join dw.da_restrict_userinfo t2 on t.client_id=t2.users_id
left join cqsale.cq_user_restrict@to_air t3 on t.client_id=t3.user_id and t3.flag in(4,5,0)
left join dw.bi_yhq_batch t5 on h1.batch_id = t5.batch_id
  left join dw.da_lyuser t6 on t.client_id=t6.users_id_fk
where h1.use_date>=trunc(sysdate-7)
and t.order_date>=trunc(sysdate-7)
and t2.users_id is not null
group by t.client_id,h1.use_date,case when t2.users_id is not null then '代理'
else '非代理' end,case when t3.user_id is not null then '封杀'
else '未封杀' end,
 case when t6.cust_id is not null then '绿翼'
       else '非绿翼' end ,
       t2.identify ,
       t2.feature_value ,
       t3.memo,h1.batch_id,t5.batch_id,
       t5.act_name ,
       t5.user_type ,
       t5.money_type ,
       t5.if_same_name,
       t5.yh_type)h1
       where h1.banned='未封杀';    


--导入代理封杀表 cqsale.cq_user_restrict 
备注：memo = yhq-batch


借助外界能力，携程等OTA提供的代理真实订票联系方式，封杀相关账号；
剔除已投诉取消
delete from xxxx
where users_id in(select user_id from cqsale.cq_user_restrict@to_air where flag <4))


封杀账号导入
drop  table hdb.mid_agent_import purge;

create table hdb.mid_agent_import as
select t1.user_id,case when t3.identify='troy' then 'troy'||'--'||t3.feature
else t3.identify end feature,t3.feature_id,t3.feature_value,trunc(sysdate) create_date,(select max(batch_id)+1 from  hdb.wb_agent_rcd )batch_id
from cqsale.cq_user_restrict@to_air t1
left join hdb.wb_agent_rcd t2 on t2.client_id=t1.user_id
left join dw.da_restrict_userinfo t3 on t1.user_id=t3.users_id
where t1.flag in(4,5)
and t2.client_id is null;

--select count(1), max(batch_id) from hdb.wb_agent_rcd;

insert into hdb.wb_agent_rcd
select * from hdb.mid_agent_import;

delete from hdb.wb_agent_rcd_factor tb1
where tb1.client_id in(select tb2.client_id
 from hdb.wb_agent_rcd_factor_history tb2);
 
insert into hdb.wb_agent_rcd_factor_history
select * from hdb.wb_agent_rcd_factor;

TRUNCATE TABLE HDB.WB_AGENT_RCD_FACTOR;


      
