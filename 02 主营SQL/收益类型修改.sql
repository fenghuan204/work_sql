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
select t1.area_id,t1.ap_ori||t1.ap_dest segment_code,t2.area_name,decode(t3.main_area_id,1,'国内',2,'国际',3,'区域') nationflag from cqrm.BI_AREA_SEGMENT@to_cqrm t1
         join cqrm.bi_area@to_cqrm t2 on t1.area_id=t2.area_id
         join cqrm.bi_area_link@to_cqrm t3 on t2.area_id=t3.area_id         
where t1.audit_flag<=1)h2 on h1.segment_code=h2.segment_code
)h3
left join dw.dim_segment_type h4 on h3.route_id=h4.route_id and h3.h_route_id=h4.h_route_id
where /*h4.income_type is null
and*/ h3.company_id=0;

--删除未关联到h_route_Id的数据，新增航线
delete from hdb.temp_feng_1021
where h_route_id is null ;
commit;

--删除历史航线未设置收益类型
delete from hdb.temp_feng_1021
where income_type is null 
and area_name is null;
commit;

--确定h_route_id,route_id是否有重复
select count(1),count(distinct h_route_id||route_id) from hdb.temp_feng_1021;

--删除现在收益类型与以前一致的情况
delete from hdb.temp_feng_1021
where nvl(income_type,'-') =nvl( area_name,'-');
commit;


---更新新设置的收益类型

update dw.dim_segment_type t1
set t1.income_type=(select t2.area_name   from hdb.temp_feng_1021 t2 
where t1.h_route_id=t2.h_route_id
and t1.route_id=t2.route_id)
where t1.route_id||t1.h_route_id in(select route_id||h_route_id
from hdb.temp_feng_1021);




---判断是否有新增income_type 未 进行录入


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
select t1.area_id,t1.ap_ori||t1.ap_dest segment_code,t2.area_name,decode(t3.main_area_id,1,'国内',2,'国际',3,'区域') nationflag from cqrm.BI_AREA_SEGMENT@to_cqrm t1
         join cqrm.bi_area@to_cqrm t2 on t1.area_id=t2.area_id
         join cqrm.bi_area_link@to_cqrm t3 on t2.area_id=t3.area_id         
where t1.audit_flag<=1)h2 on h1.segment_code=h2.segment_code
)h3
left join dw.dim_segment_type h4 on h3.route_id=h4.route_id and h3.h_route_id=h4.h_route_id
where h4.income_type is null
and h3.company_id=0;


---检查收益是否修改过收益类型

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
select t1.area_id,t1.ap_ori||t1.ap_dest segment_code,t2.area_name,decode(t3.main_area_id,1,'国内',2,'国际',3,'区域') nationflag from cqrm.BI_AREA_SEGMENT@to_cqrm t1
         join cqrm.bi_area@to_cqrm t2 on t1.area_id=t2.area_id
         join cqrm.bi_area_link@to_cqrm t3 on t2.area_id=t3.area_id         
where t1.audit_flag<=1)h2 on h1.segment_code=h2.segment_code
)h3
left join dw.dim_segment_type h4 on h3.route_id=h4.route_id and h3.h_route_id=h4.h_route_id
where h4.income_type is not null
and h3.area_name is not null
and h4.income_type<>h3.area_name
and h3.company_id=0;



---查找修改dw.dim_segment_type 
select *
 from dba_source t1
 where lower(t1.text) like '%dw.dim_segment_type%' 
 for update
 
 
 
 ----新增航线的收益类型--手动更新
 
 insert into dw.dim_segment_type
 select distinct t1.route_id,t1.h_route_id,t1.root_route_type,t1.segment_type,t1.segment_code,
       case when t1.segment_type like '%经停%' then null
       else t1.originairport||'－'||t1.destairport end root_segment_code,
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
select t1.area_id,t1.ap_ori||t1.ap_dest segment_code,t2.area_name,decode(t3.main_area_id,1,'国内',2,'国际',3,'区域') nationflag from cqrm.BI_AREA_SEGMENT@to_cqrm t1
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
 
 
