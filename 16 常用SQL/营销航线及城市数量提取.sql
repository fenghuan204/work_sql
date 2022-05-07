select count(distinct t1.flights_segment_name) 航段数,count(distinct t2.wf_segment) 航线条数,
count(distinct replace(replace(replace(t1.origincity_name,'黔江','重庆'),'武隆','重庆'),'茅台','遵义')) 城市数量,
count(distinct case when t1.origin_country_id=0 then replace(replace(replace(t1.origincity_name,'黔江','重庆'),'武隆','重庆'),'茅台','遵义')
else null end ) 国内城市数量,
count(distinct case when t1.origin_country_id in(198,199,200) then replace(replace(replace(t1.origincity_name,'黔江','重庆'),'武隆','重庆'),'茅台','遵义')
else null end ) 区域城市数量,
count(distinct case when t1.origin_country_id>0 and t1.origin_country_id not in(198,199,200) then replace(replace(replace(t1.origincity_name,'黔江','重庆'),'武隆','重庆'),'茅台','遵义')
else null end ) 国际城市数量
 from dw.da_flight t1
 join dw.dim_segment_type t2 on t1.h_route_id=t2.h_route_id and t1.route_id=t2.route_id
 where t1.flight_date>=trunc(sysdate)
 and t1.flag=0
 and t1.company_id=0
 and t1.flight_date>=to_date('20210328','yyyymmdd')
 and t1.flight_date<=to_date('20210403','yyyymmdd')
