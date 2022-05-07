select h1.flightmonth,h1.wf_city_name,h1.flight_no,sum(h1.flight_hour) flight_hour,sum(h1.day_income) day_income
from(
select to_char(t1.flight_date,'yyyy-mm') flightmonth,
t2.wf_city_name,
t1.flight_no,
sum(t1.flight_hour) flight_hour,
sum(t1.total_profit) day_income
from hdb.flights_cost_history t1
left join dw.adt_wf_segment t2 on t1.h_route_id=t2.route_id
where to_char(t1.flight_date,'mmdd')>='0401'
  and to_char(t1.flight_date,'mmdd')<='1020'
  and t1.flight_date>=to_date('2013-04-01','yyyy-mm-dd')
  and t1.flight_date< to_date('2016-01-01','yyyy-mm-dd')
  and t1.total_cost>0
  and t1.flag in (0,1,2)
  and t1.flight_hour>0
  and t1.flight_no like '9C%'
group by to_char(t1.flight_date,'yyyy-mm'),
t2.wf_city_name,
t1.flight_no

union all



SELECT to_char(t1.flight_date,'yyyy-mm'),
 CASE WHEN t1.qr_flag=1 THEN replace(replace(t4.wf_segment_name,'虹桥','上海'),'浦东','上海')
      WHEN t1.qr_flag IS NULL THEN replace(replace(t3.wf_segment_name,'虹桥','上海'),'浦东','上海') END,
      t1.flight_no,
      SUM(t1.flight_time),
      SUM(t1.day_income)
 FROM hdb.recent_flights_cost t1
 LEFT JOIN dw.da_flight t2 ON t1.qr_flag IS NULL AND t1.segment_head_id=t2.segment_head_id
 LEFT JOIN dw.adt_wf_segment t3 ON t2.h_route_id=t3.route_id
 LEFT JOIN dw.adt_wf_segment t4 ON t1.qr_flag=1 AND t1.flights_id=t4.route_id
 WHERE to_char(t1.flight_date,'mmdd')>='0401'
  and to_char(t1.flight_date,'mmdd')<='1020'
  and t1.flight_date>=to_date('2013-04-01','yyyy-mm-dd')
  and t1.flight_date< to_date('2016-01-01','yyyy-mm-dd')
   AND t1.total_cost> 0
   and t1.flight_time>0
   and t1.flight_no like '9C%'
 GROUP BY  to_char(t1.flight_date,'yyyy-mm'),CASE WHEN t1.qr_flag=1 THEN replace(replace(t4.wf_segment_name,'虹桥','上海'),'浦东','上海')
      WHEN t1.qr_flag IS NULL THEN replace(replace(t3.wf_segment_name,'虹桥','上海'),'浦东','上海') END,t1.flight_no)h1
 group by h1.flightmonth,h1.wf_city_name,h1.flight_no
