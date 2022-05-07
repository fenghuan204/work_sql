---上海、石家庄、宁波、沈阳、兰州、揭阳、扬州、深圳、广州、南昌

select '全部' base,
count(distinct replace(replace(replace(replace(t2.wf_segment,'浦东','上海'),'虹桥','上海'),'黔江','重庆'),'茅台','遵义')) 往返航线条数,
          count(distinct case when t1.dest_country_id=0 and t1.destcity_name not like '%上海%' then 
          replace(replace(replace(replace(t1.destcity_name,'浦东','上海'),'虹桥','上海'),'黔江','重庆'),'茅台','遵义')
          else null end) 境内目的地数,
          count(distinct case when t1.dest_country_id>0 then 
          replace(replace(replace(replace(t1.destcity_name,'浦东','上海'),'虹桥','上海'),'黔江','重庆'),'茅台','遵义')
          else null end) 境外目的地数,
          round(sum(t1.layout)/(to_date('2021-11-22','yyyy-mm-dd')-  to_date('2021-03-28','yyyy-mm-dd')+1),0) 日销量          
 from dw.da_flight t1
 join dw.dim_segment_type t2 on t1.h_route_id=t2.h_route_id and t1.route_id=t2.route_id
 where t1.flight_date>=to_date('2021-03-28','yyyy-mm-dd')
 and t1.flight_date<= to_date('2021-11-21','yyyy-mm-dd')
   and t1.company_id=0
   and t1.flag<>2

union all 


select '上海' base,
count(distinct replace(replace(replace(replace(t2.wf_segment,'浦东','上海'),'虹桥','上海'),'黔江','重庆'),'茅台','遵义')) 往返航线条数,
          count(distinct case when t1.dest_country_id=0 and t1.destcity_name not like '%上海%' then 
          replace(replace(replace(replace(t1.destcity_name,'浦东','上海'),'虹桥','上海'),'黔江','重庆'),'茅台','遵义')
          else null end) 境内目的地数,
          count(distinct case when t1.dest_country_id>0 then 
          replace(replace(replace(replace(t1.destcity_name,'浦东','上海'),'虹桥','上海'),'黔江','重庆'),'茅台','遵义')
          else null end) 境外目的地数,
          round(sum(t1.layout)/(to_date('2021-11-21','yyyy-mm-dd')-  to_date('2021-03-28','yyyy-mm-dd')+1),0) 日销量          
 from dw.da_flight t1
 join dw.dim_segment_type t2 on t1.h_route_id=t2.h_route_id and t1.route_id=t2.route_id
 where t1.flight_date>=to_date('2021-03-28','yyyy-mm-dd')
 and t1.flight_date<= to_date('2021-11-21','yyyy-mm-dd')
   and t1.company_id=0
   and t1.flag<>2
   and t1.flights_city_name like '%上海%'
   
   union all
   

select '石家庄',count(distinct replace(replace(replace(replace(t2.wf_segment,'浦东','上海'),'虹桥','上海'),'黔江','重庆'),'茅台','遵义')),
          count(distinct case when t1.dest_country_id=0 and t1.destcity_name not like '%石家庄%' then 
          replace(replace(replace(replace(t1.destcity_name,'浦东','上海'),'虹桥','上海'),'黔江','重庆'),'茅台','遵义')
          else null end),
          count(distinct case when t1.dest_country_id>0 then 
          replace(replace(replace(replace(t1.destcity_name,'浦东','上海'),'虹桥','上海'),'黔江','重庆'),'茅台','遵义')
          else null end),
          sum(t1.layout)/(to_date('2021-11-21','yyyy-mm-dd')-  to_date('2021-03-28','yyyy-mm-dd')+1)                     
 from dw.da_flight t1
 join dw.dim_segment_type t2 on t1.h_route_id=t2.h_route_id and t1.route_id=t2.route_id
 where t1.flight_date>=to_date('2021-03-28','yyyy-mm-dd')
 and t1.flight_date<= to_date('2021-11-21','yyyy-mm-dd')
   and t1.company_id=0
   and t1.flag<>2
   and t1.flights_city_name like '%石家庄%'
   
   union all
   
 select '宁波',count(distinct replace(replace(replace(replace(t2.wf_segment,'浦东','上海'),'虹桥','上海'),'黔江','重庆'),'茅台','遵义')),
          count(distinct case when t1.dest_country_id=0 and t1.destcity_name not like '%宁波%' then 
          replace(replace(replace(replace(t1.destcity_name,'浦东','上海'),'虹桥','上海'),'黔江','重庆'),'茅台','遵义')
          else null end),
          count(distinct case when t1.dest_country_id>0 then 
          replace(replace(replace(replace(t1.destcity_name,'浦东','上海'),'虹桥','上海'),'黔江','重庆'),'茅台','遵义')
          else null end),
          round(sum(t1.layout)/(to_date('2021-11-21','yyyy-mm-dd')-  to_date('2021-03-28','yyyy-mm-dd')+1),0) daysale                    
 from dw.da_flight t1
 join dw.dim_segment_type t2 on t1.h_route_id=t2.h_route_id and t1.route_id=t2.route_id
 where t1.flight_date>=to_date('2021-03-28','yyyy-mm-dd')
 and t1.flight_date<=to_date('2021-11-21','yyyy-mm-dd')
   and t1.company_id=0
   and t1.flag<>2
   and t1.flights_city_name like '%宁波%'
   
   union all
   
 select '沈阳',count(distinct replace(replace(replace(replace(t2.wf_segment,'浦东','上海'),'虹桥','上海'),'黔江','重庆'),'茅台','遵义')),
          count(distinct case when t1.dest_country_id=0 and t1.destcity_name not like '%沈阳%' then 
          replace(replace(replace(replace(t1.destcity_name,'浦东','上海'),'虹桥','上海'),'黔江','重庆'),'茅台','遵义')
          else null end),
          count(distinct case when t1.dest_country_id>0 then 
          replace(replace(replace(replace(t1.destcity_name,'浦东','上海'),'虹桥','上海'),'黔江','重庆'),'茅台','遵义')
          else null end),
          round(sum(t1.layout)/(to_date('2021-11-21','yyyy-mm-dd')-  to_date('2021-03-28','yyyy-mm-dd')+1),0)                     
 from dw.da_flight t1
 join dw.dim_segment_type t2 on t1.h_route_id=t2.h_route_id and t1.route_id=t2.route_id
 where t1.flight_date>=to_date('2021-03-28','yyyy-mm-dd')
 and t1.flight_date<=to_date('2021-11-21','yyyy-mm-dd')
   and t1.company_id=0
   and t1.flag<>2
   and t1.flights_city_name like '%沈阳%'
   
   
      union all
   
 select '深圳',count(distinct replace(replace(replace(replace(t2.wf_segment,'浦东','上海'),'虹桥','上海'),'黔江','重庆'),'茅台','遵义')),
          count(distinct case when t1.dest_country_id=0 and t1.destcity_name not like '%深圳%' then 
          replace(replace(replace(replace(t1.destcity_name,'浦东','上海'),'虹桥','上海'),'黔江','重庆'),'茅台','遵义')
          else null end),
          count(distinct case when t1.dest_country_id>0 then 
          replace(replace(replace(replace(t1.destcity_name,'浦东','上海'),'虹桥','上海'),'黔江','重庆'),'茅台','遵义')
          else null end),
          round(sum(t1.layout)/(to_date('2021-11-21','yyyy-mm-dd')-  to_date('2021-03-28','yyyy-mm-dd')+1),0)                     
 from dw.da_flight t1
 join dw.dim_segment_type t2 on t1.h_route_id=t2.h_route_id and t1.route_id=t2.route_id
 where t1.flight_date>=to_date('2021-03-28','yyyy-mm-dd')
 and t1.flight_date<= to_date('2021-11-21','yyyy-mm-dd')
   and t1.company_id=0
   and t1.flag<>2
   and t1.flights_city_name like '%深圳%'
   
         union all
   
 select '广州',count(distinct replace(replace(replace(replace(t2.wf_segment,'浦东','上海'),'虹桥','上海'),'黔江','重庆'),'茅台','遵义')),
          count(distinct case when t1.dest_country_id=0 and t1.destcity_name not like '%广州%' then 
          replace(replace(replace(replace(t1.destcity_name,'浦东','上海'),'虹桥','上海'),'黔江','重庆'),'茅台','遵义')
          else null end),
          count(distinct case when t1.dest_country_id>0 then 
          replace(replace(replace(replace(t1.destcity_name,'浦东','上海'),'虹桥','上海'),'黔江','重庆'),'茅台','遵义')
          else null end),
          round(sum(t1.layout)/(to_date('2021-11-21','yyyy-mm-dd')-  to_date('2021-03-28','yyyy-mm-dd')+1),0)                   
 from dw.da_flight t1
 join dw.dim_segment_type t2 on t1.h_route_id=t2.h_route_id and t1.route_id=t2.route_id
 where t1.flight_date>=to_date('2021-03-28','yyyy-mm-dd')
 and t1.flight_date<= to_date('2021-11-21','yyyy-mm-dd')
   and t1.company_id=0
   and t1.flag<>2
   and t1.flights_city_name like '%广州%'
   
   
   union all
   
--赣州 北海 潍坊 丽江 扬州泰州 三明 揭阳 西安  兰州  喀什 克拉玛依
   
 select '扬州',count(distinct replace(replace(replace(replace(t2.wf_segment,'浦东','上海'),'虹桥','上海'),'黔江','重庆'),'茅台','遵义')),
          count(distinct case when t1.dest_country_id=0 and t1.destcity_name not like '%扬州%' then 
          replace(replace(replace(replace(t1.destcity_name,'浦东','上海'),'虹桥','上海'),'黔江','重庆'),'茅台','遵义')
          else null end),
          count(distinct case when t1.dest_country_id>0 then 
          replace(replace(replace(replace(t1.destcity_name,'浦东','上海'),'虹桥','上海'),'黔江','重庆'),'茅台','遵义')
          else null end),
          round(sum(t1.layout)/(to_date('2021-11-21','yyyy-mm-dd')-  to_date('2021-03-28','yyyy-mm-dd')+1),0)                    
 from dw.da_flight t1
 join dw.dim_segment_type t2 on t1.h_route_id=t2.h_route_id and t1.route_id=t2.route_id
 where t1.flight_date>=to_date('2021-03-28','yyyy-mm-dd')
 and t1.flight_date<= to_date('2021-11-21','yyyy-mm-dd')
   and t1.company_id=0
   and t1.flag<>2
   and t1.flights_city_name like '%扬州%'
   
   
     union all
   
--赣州 北海 潍坊 丽江 扬州泰州 三明 揭阳 西安  兰州  喀什 克拉玛依
   
 select '揭阳',count(distinct replace(replace(replace(replace(t2.wf_segment,'浦东','上海'),'虹桥','上海'),'黔江','重庆'),'茅台','遵义')),
          count(distinct case when t1.dest_country_id=0 and t1.destcity_name not like '%揭阳%' then 
          replace(replace(replace(replace(t1.destcity_name,'浦东','上海'),'虹桥','上海'),'黔江','重庆'),'茅台','遵义')
          else null end),
          count(distinct case when t1.dest_country_id>0 then 
          replace(replace(replace(replace(t1.destcity_name,'浦东','上海'),'虹桥','上海'),'黔江','重庆'),'茅台','遵义')
          else null end),
          round(sum(t1.layout)/(to_date('2021-11-21','yyyy-mm-dd')-  to_date('2021-03-28','yyyy-mm-dd')+1),0)                   
 from dw.da_flight t1
 join dw.dim_segment_type t2 on t1.h_route_id=t2.h_route_id and t1.route_id=t2.route_id
 where t1.flight_date>=to_date('2021-03-28','yyyy-mm-dd')
 and t1.flight_date<= to_date('2021-11-21','yyyy-mm-dd')
   and t1.company_id=0
   and t1.flag<>2
   and t1.flights_city_name like '%揭阳%'
   
   
      union all
   
--赣州 北海 潍坊 丽江 扬州泰州 三明 揭阳 西安  兰州  喀什 克拉玛依
   
 select '兰州',count(distinct replace(replace(replace(replace(t2.wf_segment,'浦东','上海'),'虹桥','上海'),'黔江','重庆'),'茅台','遵义')),
          count(distinct case when t1.dest_country_id=0 and t1.destcity_name not like '%兰州%' then 
          replace(replace(replace(replace(t1.destcity_name,'浦东','上海'),'虹桥','上海'),'黔江','重庆'),'茅台','遵义')
          else null end),
          count(distinct case when t1.dest_country_id>0 then 
          replace(replace(replace(replace(t1.destcity_name,'浦东','上海'),'虹桥','上海'),'黔江','重庆'),'茅台','遵义')
          else null end),
          round(sum(t1.layout)/(to_date('2021-11-21','yyyy-mm-dd')-  to_date('2021-03-28','yyyy-mm-dd')+1),0)                    
 from dw.da_flight t1
 join dw.dim_segment_type t2 on t1.h_route_id=t2.h_route_id and t1.route_id=t2.route_id
 where t1.flight_date>=to_date('2021-03-28','yyyy-mm-dd')
 and t1.flight_date<= to_date('2021-11-21','yyyy-mm-dd')
   and t1.company_id=0
   and t1.flag<>2
   and t1.flights_city_name like '%兰州%'
   
   
   union 
   
   
   select '南昌',count(distinct replace(replace(replace(replace(t2.wf_segment,'浦东','上海'),'虹桥','上海'),'黔江','重庆'),'茅台','遵义')),
          count(distinct case when t1.dest_country_id=0 and t1.destcity_name not like '%兰州%' then 
          replace(replace(replace(replace(t1.destcity_name,'浦东','上海'),'虹桥','上海'),'黔江','重庆'),'茅台','遵义')
          else null end),
          count(distinct case when t1.dest_country_id>0 then 
          replace(replace(replace(replace(t1.destcity_name,'浦东','上海'),'虹桥','上海'),'黔江','重庆'),'茅台','遵义')
          else null end),
          round(sum(t1.layout)/(to_date('2021-11-21','yyyy-mm-dd')-  to_date('2021-03-28','yyyy-mm-dd')+1),0)                    
 from dw.da_flight t1
 join dw.dim_segment_type t2 on t1.h_route_id=t2.h_route_id and t1.route_id=t2.route_id
 where t1.flight_date>=to_date('2021-03-28','yyyy-mm-dd')
 and t1.flight_date<= to_date('2021-11-21','yyyy-mm-dd')
   and t1.company_id=0
   and t1.flag<>2
   and t1.flights_city_name like '%南昌%'
   
      
