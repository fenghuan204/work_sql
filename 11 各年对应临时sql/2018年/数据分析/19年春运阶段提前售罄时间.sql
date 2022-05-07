select t.flightdate,t.whole_flight,t.flights_segment_name, t1.nationflag,t1.segment_region segment_country,t1.income_type income_type,t.segment_type,t.route_name,t.plannum,t.bgoplan,
trunc(t.earlyday) 提前售罄天数,t.orderday 最后订单日期
 
from dw.bi_sy_earlysoldout t
left join dw.dim_segment_type t1 on t.route_id=t1.route_id and t.h_route_id=t1.h_route_id
where t.flightdate>=to_date('2019-01-06','yyyy-mm-dd')
  and t.flightdate<=to_date('2019-02-28','yyyy-mm-dd')
  and t.orderday< trunc(sysdate)
  
  union all
  
  select t.flightdate,t.whole_flight,t.flights_segment_name, t1.nationflag,t1.segment_region segment_country,t1.income_type income_type,t.segment_type,t.route_name,t.plannum,t.bgoplan,
trunc(t.earlyday),t.orderday
 
from dw.bi_sy_earlysoldout t
left join dw.dim_segment_type t1 on t.route_id=t1.route_id and t.h_route_id=t1.h_route_id
where t.flightdate>=to_date('2018-01-17','yyyy-mm-dd')
  and t.flightdate<=to_date('2018-03-11','yyyy-mm-dd')
  and t.orderday< to_date('2018-01-17','yyyy-mm-dd')-to_date('2019-01-06','yyyy-mm-dd')+trunc(sysdate)
