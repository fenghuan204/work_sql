select /*+parallel(4) */
h1.passnum,h1.passnum2,count(1)
from(
select t1.traveller_name||t1.codeno sname,count(1) passnum,count(distinct t3.wf_segment_name) passnum2
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  left join dw.dim_segment_type t3 on t2.h_route_id=t3.h_route_id and t2.route_id=t3.route_id
  where t1.flights_date>=to_date('2016-09-01','yyyy-mm-dd')
    and t1.flights_date< to_date('2017-09-01','yyyy-mm-dd')
    and t1.company_id=0
    and t1.seats_name is not null 
    group by t1.traveller_name||t1.codeno)h1
    group by h1.passnum,h1.passnum2
