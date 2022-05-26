select whole_flight,flights_segment_name,route_name,wf_segment_name,round_time,
sum(round_time)sumtime,sum(fnum) sumfnum,sum(layout) plannum
from(
select tp1.flight_date,tp1.whole_flight,tp1.flightno,tp1.flights_segment_name,
tp1.route_name,tp1.wf_segment_name,tp1.round_time,tp1.alltime,count(distinct tp1.flights_id) fnum,
max(layout) layout
from(
select t2.flight_date,t2.flight_no whole_flight,
case when t2.segment_type like '%经停AB%' then t2.flight_no||'X'
when t2.segment_type like '%经停BC%' then t2.flight_no||'Y'
when t2.segment_type like '%经停AC%' then t2.flight_no||'X'
else t2.flight_no end flightno,
case when t2.segment_type like '%经停AC%' 
then split_part(t2.route_name,'－',1)||'－'||split_part(t2.route_name,'－',2)
else t2.flights_segment_name end flights_segment_name,
t2.route_name,
t3.round_time,
t4.round_time alltime,
t2.flights_id,
t2.layout,
t5.wf_segment_name
  from dw.da_flight t2 
left join (select  h_route_id,route_id,max(nflag) nflag from dw.dim_route_manager_info_orig group by h_route_id,route_id)qx 
  on t2.h_route_id=qx.h_route_id and t2.route_id=qx.route_id  
  left join if.v_rep_segment_roundtime t3 on (case when t2.segment_type like '%经停AC%' then 
  split_part(t2.route_name,'－',1)||'－'||split_part(t2.route_name,'－',2) 
  else t2.flights_segment_name end) =t3.flights_segment_name
  left join if.v_rep_segment_roundtime t4 on t2.route_name=t4.flights_segment_name
 left join dw.dim_segment_type t5 on t2.h_route_id = t5.h_route_id and t2.route_id = t5.route_id
  where t2.flight_date>=date'2022-05-21'
    and t2.flight_date<=date'2022-07-20'
    and t2.flight_no like '9C%'
    and t2.flag<>2

union  all


select t2.flight_date,
t2.flight_no whole_flight,t2.flight_no||'Y' flightno,
split_part(t2.route_name,'－',2)||'－'||split_part(t2.route_name,'－',3) flights_segment_name,
t2.route_name,
t3.round_time,
t4.round_time alltime,
t2.flights_id,
t2.layout,
t5.wf_segment_name
  from  dw.da_flight t2 
  left join (select  h_route_id,route_id,max(nflag) nflag from dw.dim_route_manager_info_orig group by h_route_id,route_id  )qx 
  on t2.h_route_id=qx.h_route_id and t2.route_id=qx.route_id
  left join if.v_rep_segment_roundtime t3 on split_part(t2.route_name,'－',2)||'－'||split_part(t2.route_name,'－',3) =t3.flights_segment_name
  left join if.v_rep_segment_roundtime t4 on t2.route_name=t4.flights_segment_name
  left join dw.dim_segment_type t5 on t2.h_route_id = t5.h_route_id and t2.route_id = t5.route_id
  where t2.flight_date>=date'2022-05-21'
    and t2.flight_date<=date'2022-07-20'
    and t2.flight_no like '9C%'
    and t2.flag<>2
    and t2.segment_type like '%经停AC段%'      
    )tp1
  group by tp1.flight_date,tp1.whole_flight,tp1.flightno,tp1.flights_segment_name,
tp1.route_name,tp1.round_time,tp1.alltime,tp1.wf_segment_name)
group by whole_flight,flights_segment_name,route_name,wf_segment_name,round_time