
---1��
select t1.cust_id,t1.users_id_fk,t1.login_id, lower(md5(t1.login_id)),1 flag,sysdate create_date
from dw.da_lyuser t1
join dw.da_restrict_userinfo t2 on t1.users_id_fk=t2.users_id
left join cqsale.cq_user_restrict@to_air t3 on t1.users_id_fk=t3.user_id
where t2.users_id is not null
and nvl(t3.flag,6) not in(4,5)
and t1.login_id<>'-'
and rownum<=3500

union all
select t1.cust_id,t1.users_id_fk,t1.login_id, lower(md5(getmobile(t1.login_id))),2 flag,sysdate create_date
  from dw.da_lyuser t1
  join stg.c_cq_apply_lyhy t2 on t1.users_id_fk = t2.users_id
  left join cqsale.cq_user_restrict@to_air t3 on t2.users_id=t3.user_id
 where t2.users_id is not null
 and nvl(t3.flag,111) not in(4,5,6,7,8,9,10)
 and t2.apply_date>=to_date('2019-04-13','yyyy-mm-dd')
 and getmobile(t1.login_id)<>'-'


--------------------------------------------------------


select count(1)
from dw.da_lyuser t1
join dw.da_restrict_userinfo t2 on t1.users_id_fk=t2.users_id
left join cqsale.cq_user_restrict@to_air t3 on t1.users_id_fk=t3.user_id
where t2.users_id is not null
and nvl(t3.flag,6) not in(4,5)
and get;



--������Դ 0-��վ 1-�ǻۿͲ� 2-HCC 3-�ÿ�ˢ�ǻ��� 4-B2B 5-����APP 6-����΢�� 7-M��վ  8-����WIFI

--״̬  0-������  1-�Ѻ˶� 2-������ɹ� 3-��ȡ��
select trunc(t2.apply_date),count(1)
from dw.da_lyuser t1
join stg.c_cq_apply_lyhy t2 on t1.users_id_fk=t2.users_id
where t2.users_id is not null
and t2.apply_date>=to_date('2019-04-01','yyyy-mm-dd')
group by trunc(t2.apply_date)
