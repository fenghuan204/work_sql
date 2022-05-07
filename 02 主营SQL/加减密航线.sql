
--换季前后航线的情况对比

select case when tb1.weeks is null then '换季后无此航线'
when tb1.weeks is not null and tb2.weeks is null then '换季后新开航线'
when tb1.weeks is not null and tb2.weeks is not null then '老航线' end 航线类型,
case when tb1.weeks is null then '无'
when tb1.weeks is not null and tb2.weeks is null then '无'
when tb1.weeks is not null and tb2.weeks is not null then 
case when tb1.totalsegment> tb2.totalsegment  then '加密'
when tb1.totalsegment< tb2.totalsegment  then '减密'
when tb1.totalsegment=tb2.totalsegment  then '保持一致' end
end 加减航班,
case when tb1.weeks is null then tb2.h_route_id 
else tb1.h_route_id end h_route_id,
case when tb1.weeks is null then tb2.route_name 
else tb1.route_name end route_name,
case when tb1.weeks is null then tb2.root_route_type 
else tb1.root_route_type end root_route_type,
tb1.weeklist,tb1.flightnumlist,tb1.flightnolist,tb1.totalsegment,tb1.flightnonum,
tb2.weeklist,tb2.flightnumlist,tb2.flightnolist,tb2.totalsegment,tb2.flightnonum
from(
select h4.weeks,h4.h_route_id,h4.route_name,h4.root_route_type,h4.weeklist,h4.flightnumlist,h4.flightnolist,h4.totalsegment,sum(flights) flightnonum
from(
select h3.weeks,h3.h_route_id,h3.route_name,h3.root_route_type,listagg(listagg,';') within group(order by flightnum) over(partition by 
h3.weeks,h3.h_route_id,h3.route_name,h3.root_route_type) weeklist,
listagg(flightnum,';') within group(order by flightnum) over(partition by 
h3.weeks,h3.h_route_id,h3.route_name,h3.root_route_type) flightnumlist ,
listagg(flights,';') within group(order by flightnum) over(partition by 
h3.weeks,h3.h_route_id,h3.route_name,h3.root_route_type) flightnolist ,
flightnum,
totalsegment,
flights
from(
select h2.weeks,h2.h_Route_id,h2.route_name,h2.root_route_type,listagg,sum(flightnum) flightnum,totalsegment,count(distinct flight_no) flights
from(
select h1.weeks,h1.h_route_id,h1.route_name,h1.root_route_type,h1.flight_no,listagg(h1.week_num,',')within group (
 order by h1.week_num)over(partition by h1.weeks,h1.h_route_id,h1.route_name,h1.root_route_type,h1.flight_no) listagg ,flightnum,totalsegment
from(
select t1.weeks,
       t1.flight_no,
       t1.h_route_id,
       t1.route_name,
       t1.ROOT_ROUTE_TYPE,       
       t1.week_num,
       count(distinct t1.flights_id) flightnum,
       sum(count(t1.flights_id)) over(partition by t1.weeks,t1.route_name) totalsegment
  from dw.da_flight t1
 where t1.flight_date >= to_date('2019-03-31', 'yyyy-mm-dd')
   and t1.flight_date <= to_date('2019-10-26', 'yyyy-mm-dd')
   and t1.flag <> 2
   and t1.company_id = 0
 group by t1.weeks,
       t1.flight_no,
       t1.h_route_id,
       t1.route_name,
       t1.ROOT_ROUTE_TYPE,       
       t1.week_num
       )h1
  where h1.weeks='2019-14')h2
  group by h2.weeks,h2.h_Route_id,h2.route_name,h2.root_route_type,listagg,totalsegment)h3)h4
  group by h4.weeks,h4.h_route_id,h4.route_name,h4.root_route_type,h4.weeklist,h4.flightnumlist,h4.flightnolist,h4.totalsegment
  )tb1
  full outer join 
  ( 
  
select h4.weeks,h4.h_route_id,h4.route_name,h4.root_route_type,h4.weeklist,h4.flightnumlist,h4.flightnolist,h4.totalsegment,sum(flights) flightnonum
from(
select h3.weeks,h3.h_route_id,h3.route_name,h3.root_route_type,listagg(listagg,';') within group(order by flightnum) over(partition by 
h3.weeks,h3.h_route_id,h3.route_name,h3.root_route_type) weeklist,
listagg(flightnum,';') within group(order by flightnum) over(partition by 
h3.weeks,h3.h_route_id,h3.route_name,h3.root_route_type) flightnumlist ,
listagg(flights,';') within group(order by flightnum) over(partition by 
h3.weeks,h3.h_route_id,h3.route_name,h3.root_route_type) flightnolist ,
flightnum,
totalsegment,
flights
from(
select h2.weeks,h2.h_Route_id,h2.route_name,h2.root_route_type,listagg,sum(flightnum) flightnum,totalsegment,count(distinct flight_no) flights
from(
select h1.weeks,h1.h_route_id,h1.route_name,h1.root_route_type,h1.flight_no,listagg(h1.week_num,',')within group (
 order by h1.week_num)over(partition by h1.weeks,h1.h_route_id,h1.route_name,h1.root_route_type,h1.flight_no) listagg ,flightnum,totalsegment
from(
select t1.weeks,
       t1.flight_no,
       t1.h_route_id,
       t1.route_name,
       t1.ROOT_ROUTE_TYPE,       
       t1.week_num,
       count(distinct t1.flights_id) flightnum,
       sum(count(t1.flights_id)) over(partition by t1.weeks,t1.route_name) totalsegment
  from dw.da_flight t1
 where t1.flight_date >= to_date('2018-10-28', 'yyyy-mm-dd')
   and t1.flight_date <= to_date('2019-03-30', 'yyyy-mm-dd')
   and t1.flag <> 2
   and t1.company_id = 0
 group by t1.weeks,
       t1.flight_no,
       t1.h_route_id,
       t1.route_name,
       t1.ROOT_ROUTE_TYPE,       
       t1.week_num
       )h1
  where h1.weeks='2019-10')h2
  group by h2.weeks,h2.h_Route_id,h2.route_name,h2.root_route_type,listagg,totalsegment)h3)h4
  group by h4.weeks,h4.h_route_id,h4.route_name,h4.root_route_type,h4.weeklist,h4.flightnumlist,h4.flightnolist,h4.totalsegment
  ) tb2   on tb1.h_route_id =tb2.h_route_id and tb1.route_name =tb2.route_name and tb1.root_route_type=tb2.root_route_type;
  
  
  
  
  
  
  
  ==================按照城市航线进行区分===================
  
  
--换季前后航线的情况对比

select case when tb1.weeks is null then '换季后无此航线'
when tb1.weeks is not null and tb2.weeks is null then '换季后新开航线'
when tb1.weeks is not null and tb2.weeks is not null then '老航线' end 航线类型,
case when tb1.weeks is null then '无'
when tb1.weeks is not null and tb2.weeks is null then '无'
when tb1.weeks is not null and tb2.weeks is not null then 
case when tb1.totalsegment> tb2.totalsegment  then '加密'
when tb1.totalsegment< tb2.totalsegment  then '减密'
when tb1.totalsegment=tb2.totalsegment  then '保持一致' end
end 加减航班,
case when tb1.weeks is null then tb2.route_name 
else tb1.route_name end route_name,
case when tb1.weeks is null then tb2.root_route_type 
else tb1.root_route_type end root_route_type,
tb1.weeklist,tb1.flightnumlist,tb1.flightnolist,tb1.totalsegment,tb1.flightnonum,
tb2.weeklist,tb2.flightnumlist,tb2.flightnolist,tb2.totalsegment,tb2.flightnonum
from(
select h4.weeks,h4.route_name,h4.root_route_type,h4.weeklist,h4.flightnumlist,h4.flightnolist,h4.totalsegment,sum(flights) flightnonum
from(
select h3.weeks,h3.route_name,h3.root_route_type,listagg(listagg,';') within group(order by flightnum) over(partition by 
h3.weeks,h3.route_name,h3.root_route_type) weeklist,
listagg(flightnum,';') within group(order by flightnum) over(partition by 
h3.weeks,h3.route_name,h3.root_route_type) flightnumlist ,
listagg(flights,';') within group(order by flightnum) over(partition by 
h3.weeks,h3.route_name,h3.root_route_type) flightnolist ,
flightnum,
totalsegment,
flights
from(
select h2.weeks,h2.route_name,h2.root_route_type,listagg,sum(flightnum) flightnum,totalsegment,count(distinct flight_no) flights
from(
select h1.weeks,h1.route_name,h1.root_route_type,h1.flight_no,listagg(h1.week_num,',')within group (
 order by h1.week_num)over(partition by h1.weeks,h1.route_name,h1.root_route_type,h1.flight_no) listagg ,flightnum,totalsegment
from(
select t1.weeks,
       t1.flight_no,
       replace(replace(t1.route_name,'虹桥','上海'),'浦东','上海') route_name,
       t1.ROOT_ROUTE_TYPE,       
       t1.week_num,
       count(distinct t1.flights_id) flightnum,
       sum(count(t1.flights_id)) over(partition by t1.weeks,replace(replace(t1.route_name,'虹桥','上海'),'浦东','上海')) totalsegment
  from dw.da_flight t1
 where t1.flight_date >= to_date('2019-03-31', 'yyyy-mm-dd')
   and t1.flight_date <= to_date('2019-10-26', 'yyyy-mm-dd')
   and t1.flag <> 2
   and t1.company_id = 0
 group by t1.weeks,
       t1.flight_no,
       replace(replace(t1.route_name,'虹桥','上海'),'浦东','上海'),
       t1.ROOT_ROUTE_TYPE,       
       t1.week_num
       )h1
  where h1.weeks='2019-14')h2
  group by h2.weeks,h2.route_name,h2.root_route_type,listagg,totalsegment)h3)h4
  group by h4.weeks,h4.route_name,h4.root_route_type,h4.weeklist,h4.flightnumlist,h4.flightnolist,h4.totalsegment
  )tb1
  full outer join 
  ( 
  
select h4.weeks,h4.route_name,h4.root_route_type,h4.weeklist,h4.flightnumlist,h4.flightnolist,h4.totalsegment,sum(flights) flightnonum
from(
select h3.weeks,h3.route_name,h3.root_route_type,listagg(listagg,';') within group(order by flightnum) over(partition by 
h3.weeks,h3.route_name,h3.root_route_type) weeklist,
listagg(flightnum,';') within group(order by flightnum) over(partition by 
h3.weeks,h3.route_name,h3.root_route_type) flightnumlist ,
listagg(flights,';') within group(order by flightnum) over(partition by 
h3.weeks,h3.route_name,h3.root_route_type) flightnolist ,
flightnum,
totalsegment,
flights
from(
select h2.weeks,h2.route_name,h2.root_route_type,listagg,sum(flightnum) flightnum,totalsegment,count(distinct flight_no) flights
from(
select h1.weeks,h1.route_name,h1.root_route_type,h1.flight_no,listagg(h1.week_num,',')within group (
 order by h1.week_num)over(partition by h1.weeks,h1.route_name,h1.root_route_type,h1.flight_no) listagg ,flightnum,totalsegment
from(
select t1.weeks,
       t1.flight_no,
       replace(replace(t1.route_name,'虹桥','上海'),'浦东','上海') route_name,
       t1.ROOT_ROUTE_TYPE,       
       t1.week_num,
       count(distinct t1.flights_id) flightnum,
       sum(count(t1.flights_id)) over(partition by t1.weeks,replace(replace(t1.route_name,'虹桥','上海'),'浦东','上海')) totalsegment
  from dw.da_flight t1
 where t1.flight_date >= to_date('2018-10-28', 'yyyy-mm-dd')
   and t1.flight_date <= to_date('2019-03-30', 'yyyy-mm-dd')
   and t1.flag <> 2
   and t1.company_id = 0
 group by t1.weeks,
       t1.flight_no,
       replace(replace(t1.route_name,'虹桥','上海'),'浦东','上海'),
       t1.ROOT_ROUTE_TYPE,       
       t1.week_num
       )h1
  where h1.weeks='2019-10')h2
  group by h2.weeks,h2.route_name,h2.root_route_type,listagg,totalsegment)h3)h4
  group by h4.weeks,h4.route_name,h4.root_route_type,h4.weeklist,h4.flightnumlist,h4.flightnolist,h4.totalsegment
  ) tb2   on tb1.route_name =tb2.route_name and tb1.root_route_type=tb2.root_route_type;
  
  
  
  ----增加相关计划数
  
  select case when tb1.weeks is null then '换季后无此航线'
when tb1.weeks is not null and tb2.weeks is null then '换季后新开航线'
when tb1.weeks is not null and tb2.weeks is not null then '老航线' end 航线类型,
case when tb1.weeks is null then '无'
when tb1.weeks is not null and tb2.weeks is null then '无'
when tb1.weeks is not null and tb2.weeks is not null then 
case when tb1.totalsegment> tb2.totalsegment  then '加密'
when tb1.totalsegment< tb2.totalsegment  then '减密'
when tb1.totalsegment=tb2.totalsegment  then '保持一致' end
end 加减航班,
case when tb1.weeks is null then tb2.route_name 
else tb1.route_name end route_name,
case when tb1.weeks is null then tb2.root_route_type 
else tb1.root_route_type end root_route_type,
tb1.weeklist,tb1.flightnumlist,tb1.flightnolist,tb1.totalsegment,tb1.flightnonum,
tb2.weeklist,tb2.flightnumlist,tb2.flightnolist,tb2.totalsegment,tb2.flightnonum,
tb1.plannum,tb2.plannum
from(
select h4.weeks,h4.route_name,h4.root_route_type,h4.weeklist,h4.flightnumlist,h4.flightnolist,h4.totalsegment,sum(plannum) plannum,
sum(flights) flightnonum
from(
select h3.weeks,h3.route_name,h3.root_route_type,plannum,
listagg(listagg,';') within group(order by flightnum) over(partition by 
h3.weeks,h3.route_name,h3.root_route_type) weeklist,
listagg(flightnum,';') within group(order by flightnum) over(partition by 
h3.weeks,h3.route_name,h3.root_route_type) flightnumlist ,
listagg(flights,';') within group(order by flightnum) over(partition by 
h3.weeks,h3.route_name,h3.root_route_type) flightnolist ,
flightnum,
totalsegment,
flights
from(
select h2.weeks,h2.route_name,h2.root_route_type,listagg,sum(plannum) plannum,sum(flightnum) flightnum,totalsegment,count(distinct flight_no) flights
from(
select h1.weeks,h1.route_name,h1.root_route_type,h1.flight_no,plannum,listagg(h1.week_num,',')within group (
 order by h1.week_num)over(partition by h1.weeks,h1.route_name,h1.root_route_type,h1.flight_no) listagg ,flightnum,totalsegment
from(
select t1.weeks,
       t1.flight_no,
       replace(replace(t1.route_name,'虹桥','上海'),'浦东','上海') route_name,
       t1.ROOT_ROUTE_TYPE,       
       t1.week_num,
       sum(t1.oversale) plannum,
       count(distinct t1.flights_id) flightnum,
       sum(count(t1.flights_id)) over(partition by t1.weeks,replace(replace(t1.route_name,'虹桥','上海'),'浦东','上海')) totalsegment
  from dw.da_flight t1
 where t1.flight_date >= to_date('2019-03-31', 'yyyy-mm-dd')
   and t1.flight_date <= to_date('2019-10-26', 'yyyy-mm-dd')
   and t1.flag <> 2
   and t1.company_id = 0
 group by t1.weeks,
       t1.flight_no,
       replace(replace(t1.route_name,'虹桥','上海'),'浦东','上海'),
       t1.ROOT_ROUTE_TYPE,       
       t1.week_num
       )h1
  where h1.weeks='2019-14')h2
  group by h2.weeks,h2.route_name,h2.root_route_type,listagg,totalsegment)h3)h4
  group by h4.weeks,h4.route_name,h4.root_route_type,h4.weeklist,h4.flightnumlist,h4.flightnolist,h4.totalsegment
  )tb1
  full outer join 
  ( 
  
select h4.weeks,h4.route_name,h4.root_route_type,h4.weeklist,h4.flightnumlist,h4.flightnolist,h4.totalsegment,sum(plannum) plannum,sum(flights) flightnonum
from(
select h3.weeks,h3.route_name,h3.root_route_type,plannum,
listagg(listagg,';') within group(order by flightnum) over(partition by 
h3.weeks,h3.route_name,h3.root_route_type) weeklist,
listagg(flightnum,';') within group(order by flightnum) over(partition by 
h3.weeks,h3.route_name,h3.root_route_type) flightnumlist ,
listagg(flights,';') within group(order by flightnum) over(partition by 
h3.weeks,h3.route_name,h3.root_route_type) flightnolist ,
flightnum,
totalsegment,
flights
from(
select h2.weeks,h2.route_name,h2.root_route_type,listagg,sum(plannum) plannum,sum(flightnum) flightnum,totalsegment,count(distinct flight_no) flights
from(
select h1.weeks,h1.route_name,h1.root_route_type,h1.flight_no,plannum,listagg(h1.week_num,',')within group (
 order by h1.week_num)over(partition by h1.weeks,h1.route_name,h1.root_route_type,h1.flight_no) listagg ,flightnum,totalsegment
from(
select t1.weeks,
       t1.flight_no,
       replace(replace(t1.route_name,'虹桥','上海'),'浦东','上海') route_name,
       t1.ROOT_ROUTE_TYPE,       
       t1.week_num,
       count(distinct t1.flights_id) flightnum,
       sum(t1.oversale) plannum,
       sum(count(t1.flights_id)) over(partition by t1.weeks,replace(replace(t1.route_name,'虹桥','上海'),'浦东','上海')) totalsegment
  from dw.da_flight t1
 where t1.flight_date >= to_date('2018-10-28', 'yyyy-mm-dd')
   and t1.flight_date <= to_date('2019-03-30', 'yyyy-mm-dd')
   and t1.flag <> 2
   and t1.company_id = 0
 group by t1.weeks,
       t1.flight_no,
       replace(replace(t1.route_name,'虹桥','上海'),'浦东','上海'),
       t1.ROOT_ROUTE_TYPE,       
       t1.week_num
       )h1
  where h1.weeks='2019-10')h2
  group by h2.weeks,h2.route_name,h2.root_route_type,listagg,totalsegment)h3)h4
  group by h4.weeks,h4.route_name,h4.root_route_type,h4.weeklist,h4.flightnumlist,h4.flightnolist,h4.totalsegment
  ) tb2   on tb1.route_name =tb2.route_name and tb1.root_route_type=tb2.root_route_type;
  

  
  
  
  
