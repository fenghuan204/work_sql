--郑州 宁波 沈阳 深圳 赣州 北海 潍坊 丽江 扬州泰州 三明 揭阳 西安  兰州  喀什 克拉玛依


select '上海',count(distinct replace(replace(replace(replace(t2.wf_segment,'浦东','上海'),'虹桥','上海'),'黔江','重庆'),'茅台','遵义')),
          count(distinct case when t1.dest_country_id=0 and t1.destcity_name not like '%上海%' then 
          replace(replace(replace(replace(t1.destcity_name,'浦东','上海'),'虹桥','上海'),'黔江','重庆'),'茅台','遵义')
          else null end),
          count(distinct case when t1.dest_country_id>0 then 
          replace(replace(replace(replace(t1.destcity_name,'浦东','上海'),'虹桥','上海'),'黔江','重庆'),'茅台','遵义')
          else null end),
          sum(t1.layout) layout                    
 from dw.da_flight t1
 join dw.dim_segment_type t2 on t1.h_route_id=t2.h_route_id and t1.route_id=t2.route_id
 where t1.flight_date>=to_date('2020-10-25','yyyy-mm-dd')
 and t1.flight_date<= to_date('2020-10-31','yyyy-mm-dd')
   and t1.company_id=0
   and t1.flag<>2
   and t1.flights_city_name like '%上海%'
   
   union all
   

select '郑州',count(distinct replace(replace(replace(replace(t2.wf_segment,'浦东','上海'),'虹桥','上海'),'黔江','重庆'),'茅台','遵义')),
          count(distinct case when t1.dest_country_id=0 and t1.destcity_name not like '%郑州%' then 
          replace(replace(replace(replace(t1.destcity_name,'浦东','上海'),'虹桥','上海'),'黔江','重庆'),'茅台','遵义')
          else null end),
          count(distinct case when t1.dest_country_id>0 then 
          replace(replace(replace(replace(t1.destcity_name,'浦东','上海'),'虹桥','上海'),'黔江','重庆'),'茅台','遵义')
          else null end),
          sum(t1.layout) layout                    
 from dw.da_flight t1
 join dw.dim_segment_type t2 on t1.h_route_id=t2.h_route_id and t1.route_id=t2.route_id
 where t1.flight_date>=to_date('2020-10-25','yyyy-mm-dd')
 and t1.flight_date<= to_date('2020-10-31','yyyy-mm-dd')
   and t1.company_id=0
   and t1.flag<>2
   and t1.flights_city_name like '%郑州%'
   
   union all
   
 select '宁波',count(distinct replace(replace(replace(replace(t2.wf_segment,'浦东','上海'),'虹桥','上海'),'黔江','重庆'),'茅台','遵义')),
          count(distinct case when t1.dest_country_id=0 and t1.destcity_name not like '%宁波%' then 
          replace(replace(replace(replace(t1.destcity_name,'浦东','上海'),'虹桥','上海'),'黔江','重庆'),'茅台','遵义')
          else null end),
          count(distinct case when t1.dest_country_id>0 then 
          replace(replace(replace(replace(t1.destcity_name,'浦东','上海'),'虹桥','上海'),'黔江','重庆'),'茅台','遵义')
          else null end),
          sum(t1.layout) layout                    
 from dw.da_flight t1
 join dw.dim_segment_type t2 on t1.h_route_id=t2.h_route_id and t1.route_id=t2.route_id
 where t1.flight_date>=to_date('2020-10-25','yyyy-mm-dd')
 and t1.flight_date<= to_date('2020-10-31','yyyy-mm-dd')
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
          sum(t1.layout) layout                    
 from dw.da_flight t1
 join dw.dim_segment_type t2 on t1.h_route_id=t2.h_route_id and t1.route_id=t2.route_id
 where t1.flight_date>=to_date('2020-10-25','yyyy-mm-dd')
 and t1.flight_date<= to_date('2020-10-31','yyyy-mm-dd')
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
          sum(t1.layout) layout                    
 from dw.da_flight t1
 join dw.dim_segment_type t2 on t1.h_route_id=t2.h_route_id and t1.route_id=t2.route_id
 where t1.flight_date>=to_date('2020-10-25','yyyy-mm-dd')
 and t1.flight_date<= to_date('2020-10-31','yyyy-mm-dd')
   and t1.company_id=0
   and t1.flag<>2
   and t1.flights_city_name like '%深圳%'
   
   union all
   
--赣州 北海 潍坊 丽江 扬州泰州 三明 揭阳 西安  兰州  喀什 克拉玛依
   
 select '赣州',count(distinct replace(replace(replace(replace(t2.wf_segment,'浦东','上海'),'虹桥','上海'),'黔江','重庆'),'茅台','遵义')),
          count(distinct case when t1.dest_country_id=0 and t1.destcity_name not like '%赣州%' then 
          replace(replace(replace(replace(t1.destcity_name,'浦东','上海'),'虹桥','上海'),'黔江','重庆'),'茅台','遵义')
          else null end),
          count(distinct case when t1.dest_country_id>0 then 
          replace(replace(replace(replace(t1.destcity_name,'浦东','上海'),'虹桥','上海'),'黔江','重庆'),'茅台','遵义')
          else null end),
          sum(t1.layout) layout                    
 from dw.da_flight t1
 join dw.dim_segment_type t2 on t1.h_route_id=t2.h_route_id and t1.route_id=t2.route_id
 where t1.flight_date>=to_date('2020-10-25','yyyy-mm-dd')
 and t1.flight_date<= to_date('2020-10-31','yyyy-mm-dd')
   and t1.company_id=0
   and t1.flag<>2
   and t1.flights_city_name like '%赣州%'
   
   
     union all
   
--赣州 北海 潍坊 丽江 扬州泰州 三明 揭阳 西安  兰州  喀什 克拉玛依
   
 select '北海',count(distinct replace(replace(replace(replace(t2.wf_segment,'浦东','上海'),'虹桥','上海'),'黔江','重庆'),'茅台','遵义')),
          count(distinct case when t1.dest_country_id=0 and t1.destcity_name not like '%北海%' then 
          replace(replace(replace(replace(t1.destcity_name,'浦东','上海'),'虹桥','上海'),'黔江','重庆'),'茅台','遵义')
          else null end),
          count(distinct case when t1.dest_country_id>0 then 
          replace(replace(replace(replace(t1.destcity_name,'浦东','上海'),'虹桥','上海'),'黔江','重庆'),'茅台','遵义')
          else null end),
          sum(t1.layout) layout                    
 from dw.da_flight t1
 join dw.dim_segment_type t2 on t1.h_route_id=t2.h_route_id and t1.route_id=t2.route_id
 where t1.flight_date>=to_date('2020-10-25','yyyy-mm-dd')
 and t1.flight_date<= to_date('2020-10-31','yyyy-mm-dd')
   and t1.company_id=0
   and t1.flag<>2
   and t1.flights_city_name like '%北海%'
   
   
      union all
   
--赣州 北海 潍坊 丽江 扬州泰州 三明 揭阳 西安  兰州  喀什 克拉玛依
   
 select '潍坊',count(distinct replace(replace(replace(replace(t2.wf_segment,'浦东','上海'),'虹桥','上海'),'黔江','重庆'),'茅台','遵义')),
          count(distinct case when t1.dest_country_id=0 and t1.destcity_name not like '%潍坊%' then 
          replace(replace(replace(replace(t1.destcity_name,'浦东','上海'),'虹桥','上海'),'黔江','重庆'),'茅台','遵义')
          else null end),
          count(distinct case when t1.dest_country_id>0 then 
          replace(replace(replace(replace(t1.destcity_name,'浦东','上海'),'虹桥','上海'),'黔江','重庆'),'茅台','遵义')
          else null end),
          sum(t1.layout) layout                    
 from dw.da_flight t1
 join dw.dim_segment_type t2 on t1.h_route_id=t2.h_route_id and t1.route_id=t2.route_id
 where t1.flight_date>=to_date('2020-10-25','yyyy-mm-dd')
 and t1.flight_date<= to_date('2020-10-31','yyyy-mm-dd')
   and t1.company_id=0
   and t1.flag<>2
   and t1.flights_city_name like '%潍坊%'
   
       union all
   
--赣州 北海 潍坊 丽江 扬州泰州 三明 揭阳 西安  兰州  喀什 克拉玛依
   
 select '丽江',count(distinct replace(replace(replace(replace(t2.wf_segment,'浦东','上海'),'虹桥','上海'),'黔江','重庆'),'茅台','遵义')),
          count(distinct case when t1.dest_country_id=0 and t1.destcity_name not like '%丽江%' then 
          replace(replace(replace(replace(t1.destcity_name,'浦东','上海'),'虹桥','上海'),'黔江','重庆'),'茅台','遵义')
          else null end),
          count(distinct case when t1.dest_country_id>0 then 
          replace(replace(replace(replace(t1.destcity_name,'浦东','上海'),'虹桥','上海'),'黔江','重庆'),'茅台','遵义')
          else null end),
          sum(t1.layout) layout                    
 from dw.da_flight t1
 join dw.dim_segment_type t2 on t1.h_route_id=t2.h_route_id and t1.route_id=t2.route_id
 where t1.flight_date>=to_date('2020-10-25','yyyy-mm-dd')
 and t1.flight_date<= to_date('2020-10-31','yyyy-mm-dd')
   and t1.company_id=0
   and t1.flag<>2
   and t1.flights_city_name like '%丽江%'
   
       union all
   
--赣州 北海 潍坊 丽江 扬州泰州 三明 揭阳 西安  兰州  喀什 克拉玛依
   
 select '扬州泰州',count(distinct replace(replace(replace(replace(t2.wf_segment,'浦东','上海'),'虹桥','上海'),'黔江','重庆'),'茅台','遵义')),
          count(distinct case when t1.dest_country_id=0 and t1.destcity_name not like '%扬州泰州%' then 
          replace(replace(replace(replace(t1.destcity_name,'浦东','上海'),'虹桥','上海'),'黔江','重庆'),'茅台','遵义')
          else null end),
          count(distinct case when t1.dest_country_id>0 then 
          replace(replace(replace(replace(t1.destcity_name,'浦东','上海'),'虹桥','上海'),'黔江','重庆'),'茅台','遵义')
          else null end),
          sum(t1.layout) layout                    
 from dw.da_flight t1
 join dw.dim_segment_type t2 on t1.h_route_id=t2.h_route_id and t1.route_id=t2.route_id
 where t1.flight_date>=to_date('2020-10-25','yyyy-mm-dd')
 and t1.flight_date<= to_date('2020-10-31','yyyy-mm-dd')
   and t1.company_id=0
   and t1.flag<>2
   and t1.flights_city_name like '%扬州泰州%'
          union all
   
--赣州 北海 潍坊 丽江 扬州泰州 三明 揭阳 西安  兰州  喀什 克拉玛依
   
 select '三明',count(distinct replace(replace(replace(replace(t2.wf_segment,'浦东','上海'),'虹桥','上海'),'黔江','重庆'),'茅台','遵义')),
          count(distinct case when t1.dest_country_id=0 and t1.destcity_name not like '%三明%' then 
          replace(replace(replace(replace(t1.destcity_name,'浦东','上海'),'虹桥','上海'),'黔江','重庆'),'茅台','遵义')
          else null end),
          count(distinct case when t1.dest_country_id>0 then 
          replace(replace(replace(replace(t1.destcity_name,'浦东','上海'),'虹桥','上海'),'黔江','重庆'),'茅台','遵义')
          else null end),
          sum(t1.layout) layout                    
 from dw.da_flight t1
 join dw.dim_segment_type t2 on t1.h_route_id=t2.h_route_id and t1.route_id=t2.route_id
 where t1.flight_date>=to_date('2020-10-25','yyyy-mm-dd')
 and t1.flight_date<= to_date('2020-10-31','yyyy-mm-dd')
   and t1.company_id=0
   and t1.flag<>2
   and t1.flights_city_name like '%三明%'
   
          union all
   
--赣州 北海 潍坊 丽江 扬州泰州 三明 揭阳 西安  兰州  喀什 克拉玛依
   
 select '揭阳',count(distinct replace(replace(replace(replace(t2.wf_segment,'浦东','上海'),'虹桥','上海'),'黔江','重庆'),'茅台','遵义')),
          count(distinct case when t1.dest_country_id=0 and t1.destcity_name not like '%揭阳%' then 
          replace(replace(replace(replace(t1.destcity_name,'浦东','上海'),'虹桥','上海'),'黔江','重庆'),'茅台','遵义')
          else null end),
          count(distinct case when t1.dest_country_id>0 then 
          replace(replace(replace(replace(t1.destcity_name,'浦东','上海'),'虹桥','上海'),'黔江','重庆'),'茅台','遵义')
          else null end),
          sum(t1.layout) layout                    
 from dw.da_flight t1
 join dw.dim_segment_type t2 on t1.h_route_id=t2.h_route_id and t1.route_id=t2.route_id
 where t1.flight_date>=to_date('2020-10-25','yyyy-mm-dd')
 and t1.flight_date<= to_date('2020-10-31','yyyy-mm-dd')
   and t1.company_id=0
   and t1.flag<>2
   and t1.flights_city_name like '%揭阳%'
   
        union all
   
--赣州 北海 潍坊 丽江 扬州泰州 三明 揭阳 西安  兰州  喀什 克拉玛依
   
 select '西安',count(distinct replace(replace(replace(replace(t2.wf_segment,'浦东','上海'),'虹桥','上海'),'黔江','重庆'),'茅台','遵义')),
          count(distinct case when t1.dest_country_id=0 and t1.destcity_name not like '%西安%' then 
          replace(replace(replace(replace(t1.destcity_name,'浦东','上海'),'虹桥','上海'),'黔江','重庆'),'茅台','遵义')
          else null end),
          count(distinct case when t1.dest_country_id>0 then 
          replace(replace(replace(replace(t1.destcity_name,'浦东','上海'),'虹桥','上海'),'黔江','重庆'),'茅台','遵义')
          else null end),
          sum(t1.layout) layout                    
 from dw.da_flight t1
 join dw.dim_segment_type t2 on t1.h_route_id=t2.h_route_id and t1.route_id=t2.route_id
 where t1.flight_date>=to_date('2020-10-25','yyyy-mm-dd')
 and t1.flight_date<= to_date('2020-10-31','yyyy-mm-dd')
   and t1.company_id=0
   and t1.flag<>2
   and t1.flights_city_name like '%西安%'
   
   
       union all
   
--赣州 北海 潍坊 丽江 扬州泰州 三明 揭阳 西安  兰州  喀什 克拉玛依
   
 select '兰州',count(distinct replace(replace(replace(replace(t2.wf_segment,'浦东','上海'),'虹桥','上海'),'黔江','重庆'),'茅台','遵义')),
          count(distinct case when t1.dest_country_id=0 and t1.destcity_name not like '%兰州%' then 
          replace(replace(replace(replace(t1.destcity_name,'浦东','上海'),'虹桥','上海'),'黔江','重庆'),'茅台','遵义')
          else null end),
          count(distinct case when t1.dest_country_id>0 then 
          replace(replace(replace(replace(t1.destcity_name,'浦东','上海'),'虹桥','上海'),'黔江','重庆'),'茅台','遵义')
          else null end),
          sum(t1.layout) layout                    
 from dw.da_flight t1
 join dw.dim_segment_type t2 on t1.h_route_id=t2.h_route_id and t1.route_id=t2.route_id
 where t1.flight_date>=to_date('2020-10-25','yyyy-mm-dd')
 and t1.flight_date<= to_date('2020-10-31','yyyy-mm-dd')
   and t1.company_id=0
   and t1.flag<>2
   and t1.flights_city_name like '%兰州%'
   
   
         union all
   
--赣州 北海 潍坊 丽江 扬州泰州 三明 揭阳 西安  兰州  喀什 克拉玛依
   
 select '喀什',count(distinct replace(replace(replace(replace(t2.wf_segment,'浦东','上海'),'虹桥','上海'),'黔江','重庆'),'茅台','遵义')),
          count(distinct case when t1.dest_country_id=0 and t1.destcity_name not like '%喀什%' then 
          replace(replace(replace(replace(t1.destcity_name,'浦东','上海'),'虹桥','上海'),'黔江','重庆'),'茅台','遵义')
          else null end),
          count(distinct case when t1.dest_country_id>0 then 
          replace(replace(replace(replace(t1.destcity_name,'浦东','上海'),'虹桥','上海'),'黔江','重庆'),'茅台','遵义')
          else null end),
          sum(t1.layout) layout                    
 from dw.da_flight t1
 join dw.dim_segment_type t2 on t1.h_route_id=t2.h_route_id and t1.route_id=t2.route_id
 where t1.flight_date>=to_date('2020-10-25','yyyy-mm-dd')
 and t1.flight_date<= to_date('2020-10-31','yyyy-mm-dd')
   and t1.company_id=0
   and t1.flag<>2
   and t1.flights_city_name like '%喀什%'
   
            union all
   
--赣州 北海 潍坊 丽江 扬州泰州 三明 揭阳 西安  兰州  喀什 克拉玛依
   
 select '克拉玛依',count(distinct replace(replace(replace(replace(t2.wf_segment,'浦东','上海'),'虹桥','上海'),'黔江','重庆'),'茅台','遵义')),
          count(distinct case when t1.dest_country_id=0 and t1.destcity_name not like '%克拉玛依%' then 
          replace(replace(replace(replace(t1.destcity_name,'浦东','上海'),'虹桥','上海'),'黔江','重庆'),'茅台','遵义')
          else null end),
          count(distinct case when t1.dest_country_id>0 then 
          replace(replace(replace(replace(t1.destcity_name,'浦东','上海'),'虹桥','上海'),'黔江','重庆'),'茅台','遵义')
          else null end),
          sum(t1.layout) layout                    
 from dw.da_flight t1
 join dw.dim_segment_type t2 on t1.h_route_id=t2.h_route_id and t1.route_id=t2.route_id
 where t1.flight_date>=to_date('2020-10-25','yyyy-mm-dd')
 and t1.flight_date<= to_date('2020-10-31','yyyy-mm-dd')
   and t1.company_id=0
   and t1.flag<>2
   and t1.flights_city_name like '%克拉玛依%'
