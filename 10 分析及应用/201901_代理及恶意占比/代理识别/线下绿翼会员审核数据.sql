with tp as(
select t.air_crew,trunc(t.apply_date),t.check_phone_no,t.check_card_no
from stg.c_cq_apply_lyhy t
--join stg.s_cq_user t1 on t.air_crew=to_char(t1.USERS_NAME)
where t.apply_date>=trunc(sysdate-60)
and t.air_crew  not like '%呼叫中心%'
and t.air_crew in('99964/春秋商务旅行部/商务旅行部西藏路/董晓芸','99610/春秋南京分社/南京分社/张倩雯')
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
and t1.air_crew  not like '%呼叫中心%'
and t1.air_crew in('99964/春秋商务旅行部/商务旅行部西藏路/董晓芸','99610/春秋南京分社/南京分社/张倩雯')

