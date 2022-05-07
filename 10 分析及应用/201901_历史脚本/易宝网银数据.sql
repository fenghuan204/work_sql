select t.work_tel 订票人联系方式,t.r_tel 乘机人联系方式,count(1) 销量,sum(count(1))over(partition by 1) 总量,
count(1)/sum(count(1))over(partition by 1)*100 占比
 from dw.fact_recent_order_detail t
left join dw.da_restrict_userinfo t1 on t.client_id=t1.users_id
left join stg.p_cq_pay_gate t2 on t.pay_gate=id
where t.order_day>=trunc(sysdate-3)
and t.order_day in(trunc(sysdate-3),trunc(sysdate-1))
and t.seats_name not in('B','G','G1','G2','O')
and t.flag_id in(3,5,40,41)
and t2.gate_name='易宝网银'
and t1.users_id is null
and t.channel in('网站','手机')
group by t.work_tel,t.r_tel
