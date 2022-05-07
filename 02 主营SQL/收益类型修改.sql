create table hdb.temp_feng_1021 as
select distinct h4.h_route_id,h4.route_id,h4.flights_segment_name,h4.route_name,h4.wf_segment_name,h4.income_type,h3.area_name
from(
select h1.*,h2.area_name
from(
select distinct t1.route_id,t1.h_route_id,t1.segment_code,t1.flights_segment_name,t1.nationflag,t1.segment_country,t1.company_id
from dw.da_flight t1
where t1.flag<>2
and t1.flight_date>=to_date('2013-01-01','yyyy-mm-dd'))h1
left join 
(
select t1.area_id,t1.ap_ori||t1.ap_dest segment_code,t2.area_name,decode(t3.main_area_id,1,'����',2,'����',3,'����') nationflag from cqrm.BI_AREA_SEGMENT@to_cqrm t1
         join cqrm.bi_area@to_cqrm t2 on t1.area_id=t2.area_id
         join cqrm.bi_area_link@to_cqrm t3 on t2.area_id=t3.area_id         
where t1.audit_flag<=1)h2 on h1.segment_code=h2.segment_code
)h3
left join dw.dim_segment_type h4 on h3.route_id=h4.route_id and h3.h_route_id=h4.h_route_id
where /*h4.income_type is null
and*/ h3.company_id=0;

--ɾ��δ������h_route_Id�����ݣ���������
delete from hdb.temp_feng_1021
where h_route_id is null ;
commit;

--ɾ����ʷ����δ������������
delete from hdb.temp_feng_1021
where income_type is null 
and area_name is null;
commit;

--ȷ��h_route_id,route_id�Ƿ����ظ�
select count(1),count(distinct h_route_id||route_id) from hdb.temp_feng_1021;

--ɾ������������������ǰһ�µ����
delete from hdb.temp_feng_1021
where nvl(income_type,'-') =nvl( area_name,'-');
commit;


---���������õ���������

update dw.dim_segment_type t1
set t1.income_type=(select t2.area_name   from hdb.temp_feng_1021 t2 
where t1.h_route_id=t2.h_route_id
and t1.route_id=t2.route_id)
where t1.route_id||t1.h_route_id in(select route_id||h_route_id
from hdb.temp_feng_1021);




---�ж��Ƿ�������income_type δ ����¼��


select distinct h4.h_route_id,h4.route_id,h4.flights_segment_name,h4.route_name,h4.wf_segment_name,h4.income_type,h3.area_name
from(
select h1.*,h2.area_name
from(
select distinct t1.route_id,t1.h_route_id,t1.segment_code,t1.flights_segment_name,t1.nationflag,t1.segment_country,t1.company_id
from dw.da_flight t1
where t1.flag<>2
and t1.flight_date>=to_date('2013-01-01','yyyy-mm-dd'))h1
left join 
(
select t1.area_id,t1.ap_ori||t1.ap_dest segment_code,t2.area_name,decode(t3.main_area_id,1,'����',2,'����',3,'����') nationflag from cqrm.BI_AREA_SEGMENT@to_cqrm t1
         join cqrm.bi_area@to_cqrm t2 on t1.area_id=t2.area_id
         join cqrm.bi_area_link@to_cqrm t3 on t2.area_id=t3.area_id         
where t1.audit_flag<=1)h2 on h1.segment_code=h2.segment_code
)h3
left join dw.dim_segment_type h4 on h3.route_id=h4.route_id and h3.h_route_id=h4.h_route_id
where h4.income_type is null
and h3.company_id=0;


---��������Ƿ��޸Ĺ���������

select distinct h4.h_route_id,h4.route_id,h4.flights_segment_name,h4.route_name,h4.wf_segment_name,h4.income_type,h3.area_name
from(
select h1.*,h2.area_name
from(
select distinct t1.route_id,t1.h_route_id,t1.segment_code,t1.flights_segment_name,t1.nationflag,t1.segment_country,t1.company_id
from dw.da_flight t1
where t1.flag<>2
and t1.flight_date>=to_date('2013-01-01','yyyy-mm-dd'))h1
left join 
(
select t1.area_id,t1.ap_ori||t1.ap_dest segment_code,t2.area_name,decode(t3.main_area_id,1,'����',2,'����',3,'����') nationflag from cqrm.BI_AREA_SEGMENT@to_cqrm t1
         join cqrm.bi_area@to_cqrm t2 on t1.area_id=t2.area_id
         join cqrm.bi_area_link@to_cqrm t3 on t2.area_id=t3.area_id         
where t1.audit_flag<=1)h2 on h1.segment_code=h2.segment_code
)h3
left join dw.dim_segment_type h4 on h3.route_id=h4.route_id and h3.h_route_id=h4.h_route_id
where h4.income_type is not null
and h3.area_name is not null
and h4.income_type<>h3.area_name
and h3.company_id=0;



---�����޸�dw.dim_segment_type 
select *
 from dba_source t1
 where lower(t1.text) like '%dw.dim_segment_type%' 
 for update
 
 
 
 ----�������ߵ���������--�ֶ�����
 
 insert into dw.dim_segment_type
 select distinct t1.route_id,t1.h_route_id,t1.root_route_type,t1.segment_type,t1.segment_code,
       case when t1.segment_type like '%��ͣ%' then null
       else t1.originairport||'��'||t1.destairport end root_segment_code,
       t1.flights_segment_name,
       t1.route_name,
       t1.nationflag root_nationfalg,
       t1.nationflag,
       t1.segment_country,
       null income_type,
       t1.originairport,
       t1.destairport,
       null,
       null,
       null        
 from dw.da_flight t1
 left join dw.dim_segment_type t2 on t1.route_id=t2.route_id and t1.h_route_id=t2.h_route_id
 where t1.flight_date>=trunc(sysdate)
 and t2.route_id is null and t2.h_route_id is null;
 
 
 
 
 
 select  *
 from dw.dim_segment_type h1
 left join 
(
select t1.area_id,t1.ap_ori||t1.ap_dest segment_code,t2.area_name,decode(t3.main_area_id,1,'����',2,'����',3,'����') nationflag from cqrm.BI_AREA_SEGMENT@to_cqrm t1
         join cqrm.bi_area@to_cqrm t2 on t1.area_id=t2.area_id
         join cqrm.bi_area_link@to_cqrm t3 on t2.area_id=t3.area_id         
where t1.audit_flag<=1)h2 on h1.segment_code=h2.segment_code
where h1.income_type is null
and h2.area_name is not null ;


select *
 from dw.dim_segment_type
 where route_id in(1834,
2635,
2729)
for update
 
 
