select h1.flight_no,h1.segment_code,h1.flights_segment_name,h1.segment_type,min(flighthour) minhour,max(flighthour) maxhour,avg(flighthour) maxhour,
sum(flightnum) flightnum,min(min_date) mindate,max(max_date) maxdate,case when min(flighthour)<>max(flighthour) then '不一致' else null end hourtype,
case when min(flighthour)<=90 and max(flighthour)<=90 then '1.5小时含以下'
when min(flighthour)<=90 and max(flighthour)>90 then '时长变化-1.5小时含以下'
else null end ,
case when min(flighthour)<=120 and max(flighthour)<=120 then '2小时含以下'
when min(flighthour)<=120 and max(flighthour)>120 then '时长变化-2小时含以下'
else null end

from(
select t1.flight_no,t1.segment_code,t1.flights_segment_name,t1.segment_type,(t1.dest_sta-t1.origin_std)*24*60 flighthour,count(1) flightnum,
min(min(t1.flight_date))over(partition by t1.flight_no,t1.segment_code,t1.flights_segment_name,t1.segment_type) min_date,
max(max(t1.flight_date))over(partition by t1.flight_no,t1.segment_code,t1.flights_segment_name,t1.segment_type) max_date
from dw.da_flight t1
where t1.flight_date>=to_date('2019-03-31','yyyy-mm-dd')
  and t1.flight_date<=to_date('2019-10-26','yyyy-mm-dd')
  and t1.flag<>2
  and t1.company_id=0
  and regexp_like(substr(t1.flight_no,6,1),'[0-9]')
  and t1.segment_type  not like '%经停AC段%'
  group by t1.flight_no,t1.segment_code,t1.flights_segment_name,t1.segment_type,(t1.dest_sta-t1.origin_std)*24*60)h1
  group by h1.flight_no,h1.segment_code,h1.flights_segment_name,h1.segment_type;
