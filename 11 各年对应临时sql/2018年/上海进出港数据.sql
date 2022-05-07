select '2018年' year,h1.flights_date,h1.whole_flight,h1.whole_segment,h1.nationflag,h1.type,sum(ticketprice)/sum(ticketnum),sum(ticketnum)/sum(h1.oversale)
from(
select t1.segment_head_id,t1.flights_date,t1.whole_flight,t1.whole_segment,t1.nationflag,t2.oversale,
case when t2.flights_city_name like '上海%' then '上海出发'
when t2.flights_city_name like '%上海' then '抵达上海' end type,
count(1) ticketnum,suM(t1.ticket_price) ticketprice
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
 where t1.flights_date>= to_date('2018-11-01', 'yyyy-mm-dd')
   and t1.flights_date<= to_date('2018-11-15', 'yyyy-mm-dd')
   and t1.seats_name not in('B','G','G1','G2')
   and t1.company_id=0
   and t2.flag<>2
   and t2.flights_city_name like '%上海%'
   group by t1.segment_head_id,t1.flights_date,t1.whole_flight,t1.whole_segment,t2.oversale,t1.nationflag,
case when t2.flights_city_name like '上海%' then '上海出发'
when t2.flights_city_name like '%上海' then '抵达上海' end)h1
group by h1.flights_date,h1.whole_flight,h1.whole_segment,h1.type,h1.nationflag

union all

select '2017年' year,h1.flights_date,h1.whole_flight,h1.whole_segment,h1.nationflag,h1.type,sum(ticketprice)/sum(ticketnum),sum(ticketnum)/sum(h1.oversale)
from(
select t1.segment_head_id,t1.flights_date,t1.whole_flight,t1.whole_segment,t1.nationflag,t2.oversale,
case when t2.flights_city_name like '上海%' then '上海出发'
when t2.flights_city_name like '%上海' then '抵达上海' end type,
count(1) ticketnum,suM(t1.ticket_price) ticketprice
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
 where t1.flights_date>= to_date('2017-11-01', 'yyyy-mm-dd')
   and t1.flights_date<= to_date('2017-11-15', 'yyyy-mm-dd')
   and t1.seats_name not in('B','G','G1','G2')
   and t1.company_id=0
   and t1.order_day< add_months(trunc(sysdate),-12)
   and t2.flag<>2
   and t2.flights_city_name like '%上海%'
   group by t1.segment_head_id,t1.flights_date,t1.whole_flight,t1.whole_segment,t2.oversale,t1.nationflag,
case when t2.flights_city_name like '上海%' then '上海出发'
when t2.flights_city_name like '%上海' then '抵达上海' end)h1
group by h1.flights_date,h1.whole_flight,h1.whole_segment,h1.type,h1.nationflag
