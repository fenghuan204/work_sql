select tb1.flight_date,tb1.wf_segment_name,tb1.route_name,tb1.whole_flight,
       tb1.flights_segment_name,tb1.originairport,tb1.originairport_name,tb1.destairport,tb1.destairport_name,
       tb1.nationflag,tb1.round_time,tb1.alltime,tb1.fnum,tb1.layout,tb1.bgplan,tb1.originstd,
       tb1.dest_sta,tb2.AD_PRICE,3865.04551544181*tb1.round_time fee_a2,4390.42561868306*tb1.round_time fee_b2,
       case when tb1.layout in(180,186) then tb2.aircf1 
        when tb1.layout =240 then nvl(tb2.aircf2,tb2.aircf1)
		else tb2.aircf1 end + 
      case when tb1.layout in(180,186) then tb3.aircf1 
        when tb1.layout =240 then nvl(tb3.aircf2,tb3.aircf1)
		else tb3.aircf1 end qj_fee,
        tb2.LK_TOTALFEE,
        tb4.distance,
        2008.45727950159 fee_a4,
        11142.1768134154 fee_b4,
        4278.8461240674*tb1.round_time fee_a5,
        4749.90141012102*tb1.round_time fee_b5
from(
select tp1.flight_date,tp1.wf_segment_name,tp1.route_name,tp1.whole_flight,tp1.flights_segment_name,
tp2.segment_code,tp2.originairport,tp2.originairport_name,tp2.destairport,tp2.destairport_name,tp2.nationflag,
tp1.round_time/60 round_time,tp1.alltime/60 alltime,count(distinct tp1.flights_id) fnum,max(layout) layout,
sum(bg_plan) bgplan,min(originstd) originstd,max(dest_sta) dest_sta
from(
select t2.flight_date,
t2.flight_no whole_flight,
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
t5.wf_segment_name,
t2.bgo_plan-t2.o_plan bg_plan,
to_char(t2.origin_std,'hh24:mi') originstd,
case when t2.segment_type like '%经停AC%' 
then '00:00'
else to_char(t2.dest_sta,'hh24:mi') end dest_sta
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
t5.wf_segment_name,
t2.bgo_plan-t2.o_plan bg_plan,
'23:59' originstd,
to_char(t2.dest_sta,'hh24:mi') dest_sta
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
left join (select   flights_segment_name,segment_code,
           substr(segment_code,1,3) originairport,
           substr(segment_code,4,3) destairport,
           split_part(flights_segment_name,'－',1) originairport_name,
           split_part(flights_segment_name,'－',2) destairport_name,
           min(nationflag) nationflag
             from dw.dim_segment_type
             group by flights_segment_name,segment_code,
           substr(segment_code,1,3) ,
           substr(segment_code,4,3) ) tp2  on tp1.flights_segment_name=tp2.flights_segment_name
  group by tp1.flight_date,tp1.wf_segment_name,tp1.route_name,tp1.whole_flight,tp1.flights_segment_name,
tp2.originairport,tp2.originairport_name,tp2.destairport,tp2.destairport_name,tp2.nationflag,
tp1.round_time,tp1.alltime,tp2.segment_code
)tb1
left join hdb.rep_dim_varicost_airportdetail tb2 on tb1.originairport=tb2.AIRPORT
left join hdb.rep_dim_varicost_airportdetail tb3 on tb1.destairport=tb3.AIRPORT
left join hdb.rep_dim_varicost_distance tb4 on tb1.segment_code=tb4.segment_code