--1-去程；2-回程；0-单程

select t1.users_id,avg(t4.flights_date-t2.flights_date),count(distinct t2.flights_order_head_id)
 from hdb.temp_feng_08282 t1
 join dw.fact_recent_order_detail t2 on t1.flights_order_head_id=t2.flights_order_head_id
  join dw.da_flight t3 on t1.segment_head_id=t3.segment_head_id
  join dw.fact_recent_order_detail t4 on t2.wf_flights_order_head_id=t4.flights_order_head_id
 where t2.is_qu_hui =1
 and t3.flights_city_name  like '%上海%'
 and t3.flights_city_name like '%深圳%'
 and t4.flights_date-t2.flights_date>=0
 group by t1.users_id;



 
 
