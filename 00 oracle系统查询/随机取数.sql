--全表扫描

select *
from(select *
from stg.s_cq_xproduct 
order by dbms_random.value)
where rownum< 6;

---采样

select *
from(select *
from stg.s_cq_xproduct sample(10)
order by dbms_random.value)
where rownum< 6;


---每次都取的一样

select *
from(select *
from stg.s_cq_xproduct 
order by sys_guid())
where rownum< 6;


