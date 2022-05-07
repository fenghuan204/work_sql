select id,
       sql_code,
       sql_errm,
       sql_text,
      /* sql_full,*/
       creation_date,
       (nvl(lag(creation_date, 1) over (order by id desc), SYSDATE) - creation_date) * 24 * 60 * 60 "EXECUTE_TIME(S)",
       levels,
       model_name
  from if.if_log_message
 where creation_date >= trunc(sysdate)
  and model_name <>'if_common_pkg.insert_sql_hist'
   AND LEVELS > 4
   and model_name not in('dw_bi_seckill','pro_dw_bi_call_center','BI_MONITOR_15MI','BI_MONITOR_PERHOUR','BI_MONITOR_10MI')
 order by id DESC;
 
 
 
 
select * from stg.s_cq_city t1
left join  hdb.cq_airport t2 on t1.threecodeforcity=t2.threecodeforcity
where t2.threecodeforcity is null;


select * from hdb.cq_airport
where country_name ='中国'
and city is null;


select h3.*
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




-----校验

/*select tb1.route_Id,tb1.h_route_id,tb2.area_name,tb1.income_type,max(tb3.flight_date)
 from dw.dim_segment_type tb1
 left join(
select h3.*
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
where  h3.company_id=0)tb2 on tb1.route_id=tb2.route_id and tb1.h_route_id=tb2.h_route_id
left join dw.da_flight tb3 on tb1.route_id=tb3.route_id and tb1.h_route_id=tb3.h_route_id
group by tb1.route_Id,tb1.h_route_id,tb2.area_name,tb1.income_type
 */

