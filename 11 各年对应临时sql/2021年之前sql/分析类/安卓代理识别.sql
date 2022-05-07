select *
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
and h1.agent_type='非代理'
