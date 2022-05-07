create table anl.temp_feng_12113 as
select mobile
from(
select *
from hdb.temp_feng_1211@to_dg 
where mobile not in(
select t1.mobile
from anl.temp_feng_12112  t
join hdb.temp_feng_1211@to_dg t1 on t.mobile=t1.mobile)
order by dbms_random.value)h1
where rownum<=271613


update anl.temp_feng_12111 t1
set CRM_TYPE='CRM'
where mobile in(
select t1.mobile
from anl.temp_feng_12112  t
join hdb.temp_feng_1211@to_dg t1 on t.mobile=t1.mobile)


select count(1) from anl.temp_feng_12111 t1
where  CRM_TYPE='CRM'

insert into anl.TEMP_FENG_12111 
select mobile,null,'CRM',null
from anl.temp_feng_12113

update anl.TEMP_FENG_12111
set batch_id ='A'
where mobile in(select mobile
from(
select * from anl.TEMP_FENG_12111
order by dbms_random.value)
where rownum<=400000);


update anl.TEMP_FENG_12111
set batch_id ='B'
where batch_id is null


select batch_id ,count(1)
from anl.TEMP_FENG_12111
group by batch_id
