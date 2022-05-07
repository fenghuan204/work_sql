  select t1.flight_ruleid,t1.dayflightid,t1.daylinedate,t1.flightno,t2.t_code||t3.t_code,t1.is_com,t1.comairport,t1.flighttype,t1.day_adjust,t1.is_can,
     t1.f_std,t1.f_sta,t1.flight_ruleid
     from stg.f_day_flight t1
     join stg.f_airport t2 on t1.oriairport=t2.f_code
     join stg.f_airport t3 on t1.arrairport=t3.f_code
     where  daylinedate>=to_date('2014/5/11','yyyy-mm-dd')
     and daylinedate< to_date('2014/5/13','yyyy-mm-dd')
     and t2.t_code||t3.t_code='SHESZX';
     
     
     select flight_date,segment_head_id,flights_id,segment_code,flight_no,flight_date,flag,FLIGHT_TYPE
 from dw.da_flight 
 where segment_code='PVGTPE'
 and flight_date>=to_date('2015-07-01','yyyy-mm-dd')
 and flight_date< to_date('2015-07-20','yyyy-mm-dd');
 
 
 select *
   from hdb.recent_flights_cost
   where flights_segment='PVGTPE'
 and flight_date>=to_date('2015-07-01','yyyy-mm-dd')
 and flight_date< to_date('2015-07-20','yyyy-mm-dd');
 
 
select t1.flight_date,t1.segment_head_id,t1.flights_id,t1.segment_code,t1.flight_no,t1.flag,t1.FLIGHT_TYPE,
t2.ticketnum,t2.boardnum
 from dw.da_flight t1
 join dw.da_main_order t2 on t1.segment_head_id=t2.segment_head_id 
 where segment_code='PVGTPE'
 and flight_date>=to_date('2015-07-01','yyyy-mm-dd')
 and flight_date< to_date('2015-07-20','yyyy-mm-dd');
 
