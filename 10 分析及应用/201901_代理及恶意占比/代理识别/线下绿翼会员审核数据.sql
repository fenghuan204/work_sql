with tp as(
select t.air_crew,trunc(t.apply_date),t.check_phone_no,t.check_card_no
from stg.c_cq_apply_lyhy t
--join stg.s_cq_user t1 on t.air_crew=to_char(t1.USERS_NAME)
where t.apply_date>=trunc(sysdate-60)
and t.air_crew  not like '%��������%'
and t.air_crew in('99964/�����������в�/�������в�����·/����ܿ','99610/�����Ͼ�����/�Ͼ�����/��ٻ��')
--group by t.air_crew,trunc(t.apply_date)
)
select distinct check_phone_no,t2.stat
froM(
select * from tp t1
left join anl.fact_mobile_detail@to_dds t2 on t1.check_phone_no=t2.phone
)




select distinct t1.check_phone_no,t2.stat
from stg.c_cq_apply_lyhy t1
left join anl.fact_mobile_detail@to_dds t2 on t1.check_phone_no=t2.phone
where t1.apply_date>=trunc(sysdate-60)
and t1.air_crew  not like '%��������%'
and t1.air_crew in('99964/�����������в�/�������в�����·/����ܿ','99610/�����Ͼ�����/�Ͼ�����/��ٻ��')

