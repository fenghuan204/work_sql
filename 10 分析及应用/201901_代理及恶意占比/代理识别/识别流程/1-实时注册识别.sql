

--实时封杀邮箱异常的用户，并针对IP、注册密码、邮箱交叉维度验证有问题的账号进行封杀；

--存在后期修改注册信息中邮箱信息的情况 故此识别方式的时间要往前追溯很久，或者直接初始化数据后按照timestatmp的数据

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
where reg_date>=trunc(sysdate-60)
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
'monmail.fr.nf'/*,
'wo.com',
'wo.com.cn'*/
) or t1.email in('2639969001@qq.com','qdpfhk@126.com','873083283@qq.com',
'qqjr888@126.com','303268218@qq.com','1286600330@qq.com','gpyyxgxpz@ctrip.com')
)


)h1
where h1.type1 ='2';


--安卓代理识别

select h1.client_id||',' usersid,h1.*
from(
select t1.r_tel,t1.client_id,
case when t5.users_id is not null then '代理'
else '非代理' end agent_type,count(1) ticketnum,count(distinct t1.flights_order_id) orders,
sum(count(1))over(partition by t1.r_tel) telnum,min(t1.order_day) minday,max(t1.order_day) maxday,
min(min(t1.order_day))over(partition by t1.r_tel) minsday,
max(max(t1.order_day))over(partition by t1.r_tel) maxsday
from dw.fact_order_detail t1
left join dw.da_flight t on t1.segment_head_id=t.segment_head_id
left join dw.da_restrict_userinfo t5 on t1.client_Id=t5.users_id
where t1.terminal_id=-1
and t1.order_day>=trunc(sysdate-7)
and t1.order_day< trunc(sysdate)
and t1.company_id=0
and t1.station_id=4
--and t1.client_id=175650672
and t1.r_tel is not null
group by t1.r_tel,t1.client_id,case when t5.users_id is not null then '代理'
else '非代理' end)h1
where h1.telnum>=100
and h1.agent_type='非代理';



