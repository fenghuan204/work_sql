select t.work_tel ��Ʊ����ϵ��ʽ,t.r_tel �˻�����ϵ��ʽ,count(1) ����,sum(count(1))over(partition by 1) ����,
count(1)/sum(count(1))over(partition by 1)*100 ռ��
 from dw.fact_recent_order_detail t
left join dw.da_restrict_userinfo t1 on t.client_id=t1.users_id
left join stg.p_cq_pay_gate t2 on t.pay_gate=id
where t.order_day>=trunc(sysdate-3)
and t.order_day in(trunc(sysdate-3),trunc(sysdate-1))
and t.seats_name not in('B','G','G1','G2','O')
and t.flag_id in(3,5,40,41)
and t2.gate_name='�ױ�����'
and t1.users_id is null
and t.channel in('��վ','�ֻ�')
group by t.work_tel,t.r_tel
