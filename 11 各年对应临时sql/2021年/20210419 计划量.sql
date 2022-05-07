select h1.flights_date 航班日期,count(distinct h1.flights_id) 航班量,suM(h1.oversale) 计划量,sum(swplan) 散客计划量,suM(ticketnum) 散客销量
from(
select t1.flights_date,t1.segment_head_id,t1.flights_id,t2.oversale,t2.oversale-t2.bgo_plan+t2.o_plan swplan,
suM(case when t1.seats_name not in('B','G','G1','G2') then 1 else 0 end) ticketnum
 from dw.fact_order_detail t1
 join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
 where t1.flights_date>=trunc(sysdate)-14
   and t1.flights_date< trunc(sysdate)+14
   and t1.seats_name is not null
   and (t2.originairport IN('ZAT',
'LNJ',
'SYM',
'WNH',
'JMJ',
'BSD',
'DLU',
'CWJ',
'NLH',
'LUM',
'DIG',
'JHG',
'KMG',
'LJG',
'TCZ') or t2.destairport in('ZAT',
'LNJ',
'SYM',
'WNH',
'JMJ',
'BSD',
'DLU',
'CWJ',
'NLH',
'LUM',
'DIG',
'JHG',
'KMG',
'LJG',
'TCZ')) 
and t2.flag=0
group by t1.flights_date,t1.segment_head_id,t1.flights_id,t2.oversale,t2.oversale-t2.bgo_plan+t2.o_plan)h1
group by h1.flights_date;


select trunc(t1.money_date) 退票日期,t3.wf_segment 往返航线,count(1) 退票量
 from dw.da_order_drawback t1
 join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
 left join dw.dim_segment_type t3 on t2.h_route_id=t3.h_route_id and t2.route_id=t3.route_id
 where (t2.originairport IN('ZAT',
'LNJ',
'SYM',
'WNH',
'JMJ',
'BSD',
'DLU',
'CWJ',
'NLH',
'LUM',
'DIG',
'JHG',
'KMG',
'LJG',
'TCZ') or t2.destairport in('ZAT',
'LNJ',
'SYM',
'WNH',
'JMJ',
'BSD',
'DLU',
'CWJ',
'NLH',
'LUM',
'DIG',
'JHG',
'KMG',
'LJG',
'TCZ')) 
and t1.money_date>=trunc(sysdate)-14
and t1.money_date< trunc(sysdate)+14
group by trunc(t1.money_date),t3.wf_segment;





select trunc(t2.flight_date) 航班日期,t3.wf_segment 往返航线,count(1) 退票量
 from dw.da_order_drawback t1
 join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
 left join dw.dim_segment_type t3 on t2.h_route_id=t3.h_route_id and t2.route_id=t3.route_id
 where (t2.originairport IN('ZAT',
'LNJ',
'SYM',
'WNH',
'JMJ',
'BSD',
'DLU',
'CWJ',
'NLH',
'LUM',
'DIG',
'JHG',
'KMG',
'LJG',
'TCZ') or t2.destairport in('ZAT',
'LNJ',
'SYM',
'WNH',
'JMJ',
'BSD',
'DLU',
'CWJ',
'NLH',
'LUM',
'DIG',
'JHG',
'KMG',
'LJG',
'TCZ')) 
and t2.flight_date>=trunc(sysdate)-14
and t2.flight_date< trunc(sysdate)+14
group by trunc(t2.flight_date),t3.wf_segment
