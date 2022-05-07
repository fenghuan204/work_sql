select t1.order_day,to_char(t1.flights_date,'mmdd'),'全部' type,count(1)
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  left join dw.dim_segment_type t4 on t2.route_id=t4.route_id and t2.h_route_id=t4.h_route_id
  where t2.flag<>2
  and t1.order_day>=trunc(sysdate-1)
  and t1.order_day< trunc(sysdate)
  and t1.company_id=0
  and t1.seats_name is not null
  group by t1.order_day,to_char(t1.flights_date,'mmdd')
  
  union all
  
  select t1.order_day,to_char(t1.flights_date,'mmdd'),'上海' type,count(1)
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  left join dw.dim_segment_type t4 on t2.route_id=t4.route_id and t2.h_route_id=t4.h_route_id
  where t2.flag<>2
  and t1.order_day>=trunc(sysdate-1)
  and t1.order_day< trunc(sysdate)
  and t1.company_id=0
  and t1.seats_name is not null
  and t2.flights_city_name like '%上海%'
  group by t1.order_day,to_char(t1.flights_date,'mmdd')
  
  union all
  
  select t1.order_day,to_char(t1.flights_date,'mmdd'),'石家庄' type,count(1)
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  left join dw.dim_segment_type t4 on t2.route_id=t4.route_id and t2.h_route_id=t4.h_route_id
  where t2.flag<>2
  and t1.order_day>=trunc(sysdate-1)
  and t1.order_day< trunc(sysdate)
  and t1.company_id=0
  and t1.seats_name is not null
  and t2.flights_city_name like '%石家庄%'
  group by t1.order_day,to_char(t1.flights_date,'mmdd')
  
    union all
  
  select t1.order_day,to_char(t1.flights_date,'mmdd'),'沈阳' type,count(1)
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  left join dw.dim_segment_type t4 on t2.route_id=t4.route_id and t2.h_route_id=t4.h_route_id
  where t2.flag<>2
  and t1.order_day>=trunc(sysdate-1)
  and t1.order_day< trunc(sysdate)
  and t1.company_id=0
  and t1.seats_name is not null
  and t2.flights_city_name like '%沈阳%'
  group by t1.order_day,to_char(t1.flights_date,'mmdd')
  
  union all
  
  select t1.order_day,to_char(t1.flights_date,'mmdd'),'深圳' type,count(1)
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  left join dw.dim_segment_type t4 on t2.route_id=t4.route_id and t2.h_route_id=t4.h_route_id
  where t2.flag<>2
  and t1.order_day>=trunc(sysdate-1)
  and t1.order_day< trunc(sysdate)
  and t1.company_id=0
  and t1.seats_name is not null
  and t2.flights_city_name like '%深圳%'
  group by t1.order_day,to_char(t1.flights_date,'mmdd')
  
   union all
  
  select t1.order_day,to_char(t1.flights_date,'mmdd'),'广州' type,count(1)
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  left join dw.dim_segment_type t4 on t2.route_id=t4.route_id and t2.h_route_id=t4.h_route_id
  where t2.flag<>2
  and t1.order_day>=trunc(sysdate-1)
  and t1.order_day< trunc(sysdate)
  and t1.company_id=0
  and t1.seats_name is not null
  and t2.flights_city_name like '%广州%'
  group by t1.order_day,to_char(t1.flights_date,'mmdd')
  
   union all
  
  select t1.order_day,to_char(t1.flights_date,'mmdd'),'扬州' type,count(1)
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  left join dw.dim_segment_type t4 on t2.route_id=t4.route_id and t2.h_route_id=t4.h_route_id
  where t2.flag<>2
  and t1.order_day>=trunc(sysdate-1)
  and t1.order_day< trunc(sysdate)
  and t1.company_id=0
  and t1.seats_name is not null
  and t2.flights_city_name like '%扬州泰州%'
  group by t1.order_day,to_char(t1.flights_date,'mmdd')
  
  union all
  
  select t1.order_day,to_char(t1.flights_date,'mmdd'),'宁波' type,count(1)
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  left join dw.dim_segment_type t4 on t2.route_id=t4.route_id and t2.h_route_id=t4.h_route_id
  where t2.flag<>2
  and t1.order_day>=trunc(sysdate-1)
  and t1.order_day< trunc(sysdate)
  and t1.company_id=0
  and t1.seats_name is not null
  and t2.flights_city_name like '%宁波%'
  group by t1.order_day,to_char(t1.flights_date,'mmdd')
  
    union all
  
  select t1.order_day,to_char(t1.flights_date,'mmdd'),'兰州' type,count(1)
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  left join dw.dim_segment_type t4 on t2.route_id=t4.route_id and t2.h_route_id=t4.h_route_id
  where t2.flag<>2
  and t1.order_day>=trunc(sysdate-1)
  and t1.order_day< trunc(sysdate)
  and t1.company_id=0
  and t1.seats_name is not null
  and t2.flights_city_name like '%兰州%'
  group by t1.order_day,to_char(t1.flights_date,'mmdd')
  
  union all
  
  select t1.order_day,to_char(t1.flights_date,'mmdd'),'揭阳' type,count(1)
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  left join dw.dim_segment_type t4 on t2.route_id=t4.route_id and t2.h_route_id=t4.h_route_id
  where t2.flag<>2
  and t1.order_day>=trunc(sysdate-1)
  and t1.order_day< trunc(sysdate)
  and t1.company_id=0
  and t1.seats_name is not null
  and t2.flights_city_name like '%揭阳%'
  group by t1.order_day,to_char(t1.flights_date,'mmdd')
  
     union all
  
  select t1.order_day,to_char(t1.flights_date,'mmdd'),'西安' type,count(1)
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  left join dw.dim_segment_type t4 on t2.route_id=t4.route_id and t2.h_route_id=t4.h_route_id
  where t2.flag<>2
  and t1.order_day>=trunc(sysdate-1)
  and t1.order_day< trunc(sysdate)
  and t1.company_id=0
  and t1.seats_name is not null
  and t2.flights_city_name like '%西安%'
  group by t1.order_day,to_char(t1.flights_date,'mmdd')
  
  
   union all
  
  select t1.order_day,to_char(t1.flights_date,'mmdd'),'日本' type,count(1)
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  left join dw.dim_segment_type t4 on t2.route_id=t4.route_id and t2.h_route_id=t4.h_route_id
  where t2.flag<>2
  and t1.order_day>=trunc(sysdate-1)
  and t1.order_day< trunc(sysdate)
  and t1.company_id=0
  and t1.seats_name is not null
  and t2.segment_country='日本'
  group by t1.order_day,to_char(t1.flights_date,'mmdd')
  
  
    union all
  
  select t1.order_day,to_char(t1.flights_date,'mmdd'),'泰国' type,count(1)
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  left join dw.dim_segment_type t4 on t2.route_id=t4.route_id and t2.h_route_id=t4.h_route_id
  where t2.flag<>2
  and t1.order_day>=trunc(sysdate-1)
  and t1.order_day< trunc(sysdate)
  and t1.company_id=0
  and t1.seats_name is not null
  and t2.segment_country='泰国'
  group by t1.order_day,to_char(t1.flights_date,'mmdd')
  
     union all
  
  select t1.order_day,to_char(t1.flights_date,'mmdd'),'韩国' type,count(1)
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  left join dw.dim_segment_type t4 on t2.route_id=t4.route_id and t2.h_route_id=t4.h_route_id
  where t2.flag<>2
  and t1.order_day>=trunc(sysdate-1)
  and t1.order_day< trunc(sysdate)
  and t1.company_id=0
  and t1.seats_name is not null
  and t2.segment_country='韩国'
  group by t1.order_day,to_char(t1.flights_date,'mmdd')
  

   union all
  
  select t1.order_day,to_char(t1.flights_date,'mmdd'),'港澳台' type,count(1)
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  left join dw.dim_segment_type t4 on t2.route_id=t4.route_id and t2.h_route_id=t4.h_route_id
  where t2.flag<>2
  and t1.order_day>=trunc(sysdate-1)
  and t1.order_day< trunc(sysdate)
  and t1.company_id=0
  and t1.seats_name is not null
  and regexp_like(t2.segment_country,'(香港)|(澳门)|(台湾)'）
  group by t1.order_day,to_char(t1.flights_date,'mmdd');
  
  
  


































  
  
  

  
