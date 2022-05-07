---1、每日数据更新报错监控

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
  and creation_date< trunc(sysdate)+1
  and model_name <>'if_common_pkg.insert_sql_hist'
   AND LEVELS > 4
   and model_name not in('dw_bi_seckill','pro_dw_bi_call_center','BI_MONITOR_15MI','BI_MONITOR_PERHOUR','BI_MONITOR_10MI',
   'dw_bi_secmonitor','pro_dw_bi_aftertoday_kucun','pro_bi_message_alter','pro_dw_realtime_sale_kuncun')
   --and model_name in('pro_dw_bi_route_summary_1')
 order by id desc ;
 
 
 
 ---2、每日收益类型表监控(新增航线、收益类型更新）
 
/*select route_id||h_route_id||',',t1.* 
 from dw.dim_segment_type t1
where t1.wf_segment_name in(select distinct split_part(t2.wf_segment,'＝',2)||'＝'||split_part(t2.wf_segment,'＝',1)
from dw.dim_segment_type t2)
and route_id not in(2119)

union all

select route_id||h_route_id||',',t1.* from dw.dim_segment_type t1
where split_part(t1.wf_segment,'＝',2)||'＝'||split_part(t1.wf_segment,'＝',1) 
in(select distinct  t2.wf_segment
from dw.dim_segment_type t2)
and  route_id not in(2119);
*/


select route_id||h_route_id||',',t1.* 
 from dw.dim_segment_type t1
where t1.wf_segment_name in(
select distinct case when split_part(t2.wf_segment_name,'＝',3) is  null then '' 
else split_part(t2.wf_segment_name,'＝',3)||'＝' end
||split_part(t2.wf_segment_name,'＝',2)||'＝'||split_part(t2.wf_segment_name,'＝',1)
from dw.dim_segment_type t2)
and route_id not in(2119)

union all

select route_id||h_route_id||',',t1.* 
from dw.dim_segment_type t1
where case when split_part(t1.wf_segment_name,'＝',3) is  null then '' 
else split_part(t1.wf_segment_name,'＝',3)||'＝' end
||split_part(t1.wf_segment_name,'＝',2)||'＝'||split_part(t1.wf_segment_name,'＝',1) 
in(select distinct  t2.wf_segment_name
from dw.dim_segment_type t2)
and  route_id not in(2119)

union all

select route_id||h_route_id||',',t1.* 
 from dw.dim_segment_type t1
where t1.wf_segment in(
select distinct case when split_part(t2.wf_segment,'＝',3) is  null then '' 
else split_part(t2.wf_segment,'＝',3)||'＝' end
||split_part(t2.wf_segment,'＝',2)||'＝'||split_part(t2.wf_segment,'＝',1)
from dw.dim_segment_type t2)
and route_id not in(2119)

union all

select route_id||h_route_id||',',t1.* 
from dw.dim_segment_type t1
where case when split_part(t1.wf_segment,'＝',3) is  null then '' 
else split_part(t1.wf_segment,'＝',3)||'＝' end
||split_part(t1.wf_segment,'＝',2)||'＝'||split_part(t1.wf_segment,'＝',1) 
in(select distinct  t2.wf_segment
from dw.dim_segment_type t2)
and  route_id not in(2119);


select * from dw.dim_segment_type t1
where t1.wf_segment is null
and t1.root_route_type <>'同机中转';


---3\ 收益类型route_name更新

select distinct t1.route_name
 from hdb.recent_flights_cost t1
 left join (select distinct route_name
                  from dw.da_flight t1
                  where t1.flag<>2)t2 on t1.route_name=t2.route_name
 where t2.route_name is  null;

---4\收益数据异常监控

select *
 from hdb.recent_flights_cost t1
 where t1.flight_date>=trunc(sysdate)-30
 and (nvl(t1.total_cost,0)=0
 or nvl(t1.checkin_num,0)=0
 or nvl(t1.checkin_mile,0)=0
 or nvl(t1.checkin_s_mile,0)=0
 or nvl(t1.round_time,0)=0);
 
 
 --5\重复
 
 
select t1.flights_id,t1.segment_head_id,count(1)
  from hdb.recent_flights_cost t1
  group by t1.flights_id,t1.segment_head_id
  having count(1)>1;
  
---6\一个城市两个机场的数据更新要求


select distinct h2.city_name,h2.city_threecode,h2.airport_code,h2.airport_name
from(
select h1.city_name,h1.city_threecode,h1.b_segment airport_code,h1.segment1 airport_name,
sum(count(1))over(partition by h1.city_name,h1.city_threecode ) xnum,
sum(count(1))over(partition by h1.city_name,h1.city_threecode,h1.b_segment ) xnum2
from(
select distinct t3.city_name,t3.city_threecode,b_segment,segment1
 from(
 select distinct  t1.route_id,flights_segment_name,flights_segment,
 split_part(flights_segment,'－',1) segment1,
 case when t1.p_segment1 is not null then split_part(flights_segment,'－',2)
 else null end segment2,
  case when t1.p_segment1 is not  null then split_part(flights_segment,'－',3)
 when t1.p_segment1 is   null then split_part(flights_segment,'－',2) end segment3,
t1.b_segment,t1.p_segment1 mid_segment,
 t1.e_segment
 from(
 select 
  replace(replace(replace(replace(b1.FLIGHTS_SEGMENT_NAME,
                                                                 '---',
                                                                 '－'),
                                                         '--',
                                                         '－'),
                                                 '-',
                                                 '－'),
                                         '—',
                                         '－') flights_segment,b1.*
  from stg.s_cq_flights_segment_route b1)t1
  where t1.flights_segment_name is not null
  )t2
  join stg.s_cq_city t3 on t2.b_segment=t3.threecodeforcity

union

select distinct t3.city_name,t3.city_threecode,mid_segment,segment2
 from(
 select distinct  t1.route_id,flights_segment_name,flights_segment,
 split_part(flights_segment,'－',1) segment1,
 case when t1.p_segment1 is not null then split_part(flights_segment,'－',2)
 else null end segment2,
  case when t1.p_segment1 is not  null then split_part(flights_segment,'－',3)
 when t1.p_segment1 is   null then split_part(flights_segment,'－',2) end segment3,
t1.b_segment,t1.p_segment1 mid_segment,
 t1.e_segment
 from(
 select 
  replace(replace(replace(replace(b1.FLIGHTS_SEGMENT_NAME,
                                                                 '---',
                                                                 '－'),
                                                         '--',
                                                         '－'),
                                                 '-',
                                                 '－'),
                                         '—',
                                         '－') flights_segment,b1.*
  from stg.s_cq_flights_segment_route b1)t1
  where t1.flights_segment_name is not null
  )t2
  join stg.s_cq_city t3 on t2.mid_segment=t3.threecodeforcity
  where t2.mid_segment is not null
  
  union
  
  select distinct t3.city_name,t3.city_threecode,e_segment,segment3
 from(
 select distinct  t1.route_id,flights_segment_name,flights_segment,
 split_part(flights_segment,'－',1) segment1,
 case when t1.p_segment1 is not null then split_part(flights_segment,'－',2)
 else null end segment2,
  case when t1.p_segment1 is not  null then split_part(flights_segment,'－',3)
 when t1.p_segment1 is   null then split_part(flights_segment,'－',2) end segment3,
t1.b_segment,t1.p_segment1 mid_segment,
 t1.e_segment
 from(
 select 
  replace(replace(replace(replace(b1.FLIGHTS_SEGMENT_NAME,
                                                                 '---',
                                                                 '－'),
                                                         '--',
                                                         '－'),
                                                 '-',
                                                 '－'),
                                         '—',
                                         '－') flights_segment,b1.*
  from stg.s_cq_flights_segment_route b1)t1
  where t1.flights_segment_name is not null
  )t2
  join stg.s_cq_city t3 on t2.e_segment=t3.threecodeforcity
  where t2.e_segment is not null)h1
  group by h1.city_name,h1.city_threecode,h1.b_segment ,h1.segment1)h2
  where xnum=2
  and xnum<>xnum2
  and city_name not in('上海','西安');
  
---验证不同名称
  

 with tp as
 (select h1.city_name,h1.city_threecode,h1.b_segment airport_code,h1.segment1 airport_name,
sum(count(1))over(partition by h1.city_name,h1.city_threecode ) xnum,
sum(count(1))over(partition by h1.city_name,h1.city_threecode,h1.b_segment ) xnum2
from(
select distinct t3.city_name,t3.city_threecode,b_segment,segment1
 from(
 select distinct  t1.route_id,flights_segment_name,flights_segment,
 split_part(flights_segment,'－',1) segment1,
 case when t1.p_segment1 is not null then split_part(flights_segment,'－',2)
 else null end segment2,
  case when t1.p_segment1 is not  null then split_part(flights_segment,'－',3)
 when t1.p_segment1 is   null then split_part(flights_segment,'－',2) end segment3,
t1.b_segment,t1.p_segment1 mid_segment,
 t1.e_segment
 from(
 select 
  replace(replace(replace(replace(b1.FLIGHTS_SEGMENT_NAME,
                                                                 '---',
                                                                 '－'),
                                                         '--',
                                                         '－'),
                                                 '-',
                                                 '－'),
                                         '—',
                                         '－') flights_segment,b1.*
  from stg.s_cq_flights_segment_route b1)t1
  where t1.flights_segment_name is not null
  )t2
  join stg.s_cq_city t3 on t2.b_segment=t3.threecodeforcity

union

select distinct t3.city_name,t3.city_threecode,mid_segment,segment2
 from(
 select distinct  t1.route_id,flights_segment_name,flights_segment,
 split_part(flights_segment,'－',1) segment1,
 case when t1.p_segment1 is not null then split_part(flights_segment,'－',2)
 else null end segment2,
  case when t1.p_segment1 is not  null then split_part(flights_segment,'－',3)
 when t1.p_segment1 is   null then split_part(flights_segment,'－',2) end segment3,
t1.b_segment,t1.p_segment1 mid_segment,
 t1.e_segment
 from(
 select 
  replace(replace(replace(replace(b1.FLIGHTS_SEGMENT_NAME,
                                                                 '---',
                                                                 '－'),
                                                         '--',
                                                         '－'),
                                                 '-',
                                                 '－'),
                                         '—',
                                         '－') flights_segment,b1.*
  from stg.s_cq_flights_segment_route b1)t1
  where t1.flights_segment_name is not null
  )t2
  join stg.s_cq_city t3 on t2.mid_segment=t3.threecodeforcity
  where t2.mid_segment is not null
  
  union
  
  select distinct t3.city_name,t3.city_threecode,e_segment,segment3
 from(
 select distinct  t1.route_id,flights_segment_name,flights_segment,
 split_part(flights_segment,'－',1) segment1,
 case when t1.p_segment1 is not null then split_part(flights_segment,'－',2)
 else null end segment2,
  case when t1.p_segment1 is not  null then split_part(flights_segment,'－',3)
 when t1.p_segment1 is   null then split_part(flights_segment,'－',2) end segment3,
t1.b_segment,t1.p_segment1 mid_segment,
 t1.e_segment
 from(
 select 
  replace(replace(replace(replace(b1.FLIGHTS_SEGMENT_NAME,
                                                                 '---',
                                                                 '－'),
                                                         '--',
                                                         '－'),
                                                 '-',
                                                 '－'),
                                         '—',
                                         '－') flights_segment,b1.*
  from stg.s_cq_flights_segment_route b1)t1
  where t1.flights_segment_name is not null
  )t2
  join stg.s_cq_city t3 on t2.e_segment=t3.threecodeforcity
  where t2.e_segment is not null)h1
  group by h1.city_name,h1.city_threecode,h1.b_segment ,h1.segment1)
  
  select distinct h2.*,h1.originairport_name
   from dw.da_flight h1
   join tp h2 on h2.airport_code=h1.originairport
   where h1.originairport_name<>h2.airport_name
   and h2.city_threecode not  in('HKT','NRT','WDS','CJU','HIJ','HND','URT','NRT','OSA','SGN','YTY');
   
   
   
   select *
from dw.dim_segment_type
where h_route_id in(
select h_route_id
 from dw.dim_segment_type
 where nvl(income_type,'-')='-');
 --and nvl(income_type,'-')<>'-';
 
 
 
 select *
  from dw.dim_segment_type  t1
  where t1.root_route_type like '%经停%'
  and split_part(t1.wf_segment_name,'＝',2) is null;
  
  
  
  select regexp_substr(split_part(t1.memo,',',2),'[0-9]+'),t2.feature_value,count(1)
 from cqsale.cq_user_restrict@to_air t1
 join cqsale.CQ_BLACK_FEATURE_RULE_DETAIL@to_air t2 on regexp_substr(split_part(t1.memo,',',2),'[0-9]+')=to_char(t2.feature_rule_id)
 where t1.create_date>=trunc(sysdate)
 group by regexp_substr(split_part(t1.memo,',',2),'[0-9]+'),t2.feature_value
 order by 3 desc;

 
