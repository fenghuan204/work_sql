--ȫ��ɨ��

select *
from(select *
from stg.s_cq_xproduct 
order by dbms_random.value)
where rownum< 6;

---����

select *
from(select *
from stg.s_cq_xproduct sample(10)
order by dbms_random.value)
where rownum< 6;


---ÿ�ζ�ȡ��һ��

select *
from(select *
from stg.s_cq_xproduct 
order by sys_guid())
where rownum< 6;


