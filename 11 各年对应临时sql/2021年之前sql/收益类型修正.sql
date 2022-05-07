drop table hdb.temp_feng_1228 purge;

create table hdb.temp_feng_1228 as
select h3.*
from(
select h1.*,h2.area_name
from(
select distinct t1.route_id,t1.h_route_id,t1.segment_code,t1.flights_segment_name,t1.nationflag,t1.segment_country,t1.company_id
from dw.da_flight t1
where t1.flag<>2
and t1.flight_date>=to_date('2017-01-01','yyyy-mm-dd'))h1
left join 
(
select t1.area_id,t1.ap_ori||t1.ap_dest segment_code,t2.area_name,decode(t3.main_area_id,1,'国内',2,'国际',3,'区域') nationflag from cqrm.BI_AREA_SEGMENT@to_cqrm t1
         join cqrm.bi_area@to_cqrm t2 on t1.area_id=t2.area_id
         join cqrm.bi_area_link@to_cqrm t3 on t2.area_id=t3.area_id         
where t1.audit_flag<=1)h2 on h1.segment_code=h2.segment_code
)h3
left join dw.dim_segment_type h4 on h3.route_id=h4.route_id and h3.h_route_id=h4.h_route_id
where  h3.company_id=0

select tt1.*,tt2.segment_region,tt2.income_type,tt2.route_name
from hdb.temp_feng_1228 tt1
left join dw.dim_segment_type tt2 on tt1.route_id=tt2.route_id and tt1.h_route_id=tt2.h_route_id
where nvl(tt1.area_name,'-')<>tt2.income_type


select tt2.segment_region,tt2.income_type,tt1.area_name,tt2.flights_segment_name,tt2.route_name,tt1.*
from hdb.temp_feng_1228 tt1
right join dw.dim_segment_type tt2 on tt1.route_id=tt2.route_id and tt1.h_route_id=tt2.h_route_id
where nvl(tt1.area_name,'-')<>tt2.income_type
and tt2.flights_segment_name  like '%普吉%'
and tt2.flights_segment_name  like '%浦东%'



select distinct tt1.area_name
from hdb.temp_feng_1228 tt1
left join dw.dim_segment_type tt2 on tt1.route_id=tt2.route_id and tt1.h_route_id=tt2.h_route_id
where nvl(tt1.area_name,'-')<>tt2.income_type

