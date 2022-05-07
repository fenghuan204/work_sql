select *
from hdb.recent_flights_cost 
where segment_head_id in(
select segment_head_id
 from hdb.recent_flights_cost
 group by segment_head_id
 having count(1)>1)
 for update;
 
 
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
 
 
 
 
