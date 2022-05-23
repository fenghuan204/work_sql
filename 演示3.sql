select flights_city_name,count(1)
from(
select distinct segment_code,flights_city_name,flights_segment_name
         from dw.dim_segment_type
         where flights_segment_name is not null)
 group by flights_city_name


 select * from if.v_rep_segment_varicost


 select count(1),count(distinct flightno||flights_segment_name) from if.v_rep_segment_varicost