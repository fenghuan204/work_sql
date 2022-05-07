select t1.order_day,to_char(t1.flights_date,'mmdd'),'ȫ��' type,count(1)
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
  
  select t1.order_day,to_char(t1.flights_date,'mmdd'),'�Ϻ�' type,count(1)
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  left join dw.dim_segment_type t4 on t2.route_id=t4.route_id and t2.h_route_id=t4.h_route_id
  where t2.flag<>2
  and t1.order_day>=trunc(sysdate-1)
  and t1.order_day< trunc(sysdate)
  and t1.company_id=0
  and t1.seats_name is not null
  and t2.flights_city_name like '%�Ϻ�%'
  group by t1.order_day,to_char(t1.flights_date,'mmdd')
  
  union all
  
  select t1.order_day,to_char(t1.flights_date,'mmdd'),'ʯ��ׯ' type,count(1)
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  left join dw.dim_segment_type t4 on t2.route_id=t4.route_id and t2.h_route_id=t4.h_route_id
  where t2.flag<>2
  and t1.order_day>=trunc(sysdate-1)
  and t1.order_day< trunc(sysdate)
  and t1.company_id=0
  and t1.seats_name is not null
  and t2.flights_city_name like '%ʯ��ׯ%'
  group by t1.order_day,to_char(t1.flights_date,'mmdd')
  
    union all
  
  select t1.order_day,to_char(t1.flights_date,'mmdd'),'����' type,count(1)
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  left join dw.dim_segment_type t4 on t2.route_id=t4.route_id and t2.h_route_id=t4.h_route_id
  where t2.flag<>2
  and t1.order_day>=trunc(sysdate-1)
  and t1.order_day< trunc(sysdate)
  and t1.company_id=0
  and t1.seats_name is not null
  and t2.flights_city_name like '%����%'
  group by t1.order_day,to_char(t1.flights_date,'mmdd')
  
  union all
  
  select t1.order_day,to_char(t1.flights_date,'mmdd'),'����' type,count(1)
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  left join dw.dim_segment_type t4 on t2.route_id=t4.route_id and t2.h_route_id=t4.h_route_id
  where t2.flag<>2
  and t1.order_day>=trunc(sysdate-1)
  and t1.order_day< trunc(sysdate)
  and t1.company_id=0
  and t1.seats_name is not null
  and t2.flights_city_name like '%����%'
  group by t1.order_day,to_char(t1.flights_date,'mmdd')
  
   union all
  
  select t1.order_day,to_char(t1.flights_date,'mmdd'),'����' type,count(1)
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  left join dw.dim_segment_type t4 on t2.route_id=t4.route_id and t2.h_route_id=t4.h_route_id
  where t2.flag<>2
  and t1.order_day>=trunc(sysdate-1)
  and t1.order_day< trunc(sysdate)
  and t1.company_id=0
  and t1.seats_name is not null
  and t2.flights_city_name like '%����%'
  group by t1.order_day,to_char(t1.flights_date,'mmdd')
  
   union all
  
  select t1.order_day,to_char(t1.flights_date,'mmdd'),'����' type,count(1)
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  left join dw.dim_segment_type t4 on t2.route_id=t4.route_id and t2.h_route_id=t4.h_route_id
  where t2.flag<>2
  and t1.order_day>=trunc(sysdate-1)
  and t1.order_day< trunc(sysdate)
  and t1.company_id=0
  and t1.seats_name is not null
  and t2.flights_city_name like '%����̩��%'
  group by t1.order_day,to_char(t1.flights_date,'mmdd')
  
  union all
  
  select t1.order_day,to_char(t1.flights_date,'mmdd'),'����' type,count(1)
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  left join dw.dim_segment_type t4 on t2.route_id=t4.route_id and t2.h_route_id=t4.h_route_id
  where t2.flag<>2
  and t1.order_day>=trunc(sysdate-1)
  and t1.order_day< trunc(sysdate)
  and t1.company_id=0
  and t1.seats_name is not null
  and t2.flights_city_name like '%����%'
  group by t1.order_day,to_char(t1.flights_date,'mmdd')
  
    union all
  
  select t1.order_day,to_char(t1.flights_date,'mmdd'),'����' type,count(1)
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  left join dw.dim_segment_type t4 on t2.route_id=t4.route_id and t2.h_route_id=t4.h_route_id
  where t2.flag<>2
  and t1.order_day>=trunc(sysdate-1)
  and t1.order_day< trunc(sysdate)
  and t1.company_id=0
  and t1.seats_name is not null
  and t2.flights_city_name like '%����%'
  group by t1.order_day,to_char(t1.flights_date,'mmdd')
  
  union all
  
  select t1.order_day,to_char(t1.flights_date,'mmdd'),'����' type,count(1)
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  left join dw.dim_segment_type t4 on t2.route_id=t4.route_id and t2.h_route_id=t4.h_route_id
  where t2.flag<>2
  and t1.order_day>=trunc(sysdate-1)
  and t1.order_day< trunc(sysdate)
  and t1.company_id=0
  and t1.seats_name is not null
  and t2.flights_city_name like '%����%'
  group by t1.order_day,to_char(t1.flights_date,'mmdd')
  
     union all
  
  select t1.order_day,to_char(t1.flights_date,'mmdd'),'����' type,count(1)
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  left join dw.dim_segment_type t4 on t2.route_id=t4.route_id and t2.h_route_id=t4.h_route_id
  where t2.flag<>2
  and t1.order_day>=trunc(sysdate-1)
  and t1.order_day< trunc(sysdate)
  and t1.company_id=0
  and t1.seats_name is not null
  and t2.flights_city_name like '%����%'
  group by t1.order_day,to_char(t1.flights_date,'mmdd')
  
  
   union all
  
  select t1.order_day,to_char(t1.flights_date,'mmdd'),'�ձ�' type,count(1)
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  left join dw.dim_segment_type t4 on t2.route_id=t4.route_id and t2.h_route_id=t4.h_route_id
  where t2.flag<>2
  and t1.order_day>=trunc(sysdate-1)
  and t1.order_day< trunc(sysdate)
  and t1.company_id=0
  and t1.seats_name is not null
  and t2.segment_country='�ձ�'
  group by t1.order_day,to_char(t1.flights_date,'mmdd')
  
  
    union all
  
  select t1.order_day,to_char(t1.flights_date,'mmdd'),'̩��' type,count(1)
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  left join dw.dim_segment_type t4 on t2.route_id=t4.route_id and t2.h_route_id=t4.h_route_id
  where t2.flag<>2
  and t1.order_day>=trunc(sysdate-1)
  and t1.order_day< trunc(sysdate)
  and t1.company_id=0
  and t1.seats_name is not null
  and t2.segment_country='̩��'
  group by t1.order_day,to_char(t1.flights_date,'mmdd')
  
     union all
  
  select t1.order_day,to_char(t1.flights_date,'mmdd'),'����' type,count(1)
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  left join dw.dim_segment_type t4 on t2.route_id=t4.route_id and t2.h_route_id=t4.h_route_id
  where t2.flag<>2
  and t1.order_day>=trunc(sysdate-1)
  and t1.order_day< trunc(sysdate)
  and t1.company_id=0
  and t1.seats_name is not null
  and t2.segment_country='����'
  group by t1.order_day,to_char(t1.flights_date,'mmdd')
  

   union all
  
  select t1.order_day,to_char(t1.flights_date,'mmdd'),'�۰�̨' type,count(1)
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  left join dw.dim_segment_type t4 on t2.route_id=t4.route_id and t2.h_route_id=t4.h_route_id
  where t2.flag<>2
  and t1.order_day>=trunc(sysdate-1)
  and t1.order_day< trunc(sysdate)
  and t1.company_id=0
  and t1.seats_name is not null
  and regexp_like(t2.segment_country,'(���)|(����)|(̨��)'��
  group by t1.order_day,to_char(t1.flights_date,'mmdd');
  
  
  


































  
  
  

  
