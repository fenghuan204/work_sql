--安卓代理识别

select t1.client_id,case when t5.users_id is not null then '代理'
else '非代理' end 是否代理,t1.work_tel,t1.email,t.flights_segment_name,t1.r_tel,t2.login_id,
tt2.login_pwd,t2.login_times,t2.reg_date,t2.login_times/(trunc(sysdate)-trunc(t2.reg_date)), t2.email,
t2.register_ip,t5.feature_value,t4.gate_name,t3.pay_account,t3.payip,t1.order_date,t3.create_date,t3.yingda_date
from dw.fact_order_detail t1
left join dw.da_flight t on t1.segment_head_id=t.segment_head_id
left join dw.da_b2c_user t2 on t1.client_id=t2.users_id
left join stg.c_cq_flights_users tt2 on t1.client_id=tt2.users_id
left join stg.p_cq_ips_order_id t3 on t1.flights_order_id=t3.flights_order_id and t1.ips_order_id=t3.ips_order_id
left join stg.p_cq_pay_gate t4 on t1.pay_gate=t4.id
left join dw.da_restrict_userinfo t5 on t1.client_Id=t5.users_id
where t1.terminal_id=-1
and t1.order_day>=trunc(sysdate-1)
and t1.order_day< trunc(sysdate)
and t1.company_id=0
and t1.station_id=4





--select * from stg.s_cq_order_origin_type

1、注册IP显示：10.0.2.15   、乘机人联系方式未填写
2、注册IP显示: ,乘机人联系方式为同一个 18907064790


select t1.r_tel,t1.client_id,
case when t5.users_id is not null then '代理'
else '非代理' end,count(1) ticketnum,count(distinct t1.flights_order_id) orders,
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
and t1.client_id=175650672
and t1.r_tel is not null
group by t1.r_tel,t1.client_id,case when t5.users_id is not null then '代理'
else '非代理' end