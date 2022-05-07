select tp1.flights_city_name 航线,tp1.origincity_name 始发,tp1.destcity_name 目的,
case when tp2.flights_city_name is not null and tp2.flightnum< tp1.flightnum then '在飞加密'
when tp2.flights_city_name is not null and tp2.flightnum> tp1.flightnum then '在飞减密'
when tp2.flights_city_name is not null and tp2.flightnum= tp1.flightnum then '在飞不变'
when tp2.flights_city_name is null and tp3.flights_city_name is not null then '复飞'
when tp2.flights_city_name is null and tp3.flights_city_name is null then '新开航线'
end 类型,tp1.num 总航班量,tp1.layout 总计划数,tp1.flightnum 周航班量,tp2.flightnum 上个航季周航班量,
tp1.mindate 夏秋航季开始时间,tp1.maxdate 夏秋航季结束时间,tp2.mindate 上一个航季开始时间,tp2.maxdate 上一个航季结束时间,
tp3.mindate 开航时间,
tp3.maxdate 上上一个航季结束时间
from(

select  tb1.*,tb2.flightnum
from(
select t2.flights_city_name,t2.origincity_name,t2.destcity_name,count(1) num,suM(t2.layout)  layout,min(flight_date) mindate,max(flight_date) maxdate
from dw.da_flight t2 
where t2.flight_date>=to_date('2019-03-31','yyyy-mm-dd')
  and t2.flight_date<=to_date('2019-10-26','yyyy-mm-dd')
  and t2.flag<>2
  and t2.company_id=0
   group by t2.flights_city_name,t2.origincity_name,t2.destcity_name)tb1 
  left join (
  select p4.flights_city_name,p4.flightnum
  from(
  select p3.flights_city_name,p3.flightnum,row_number()over(partition by p3.flights_city_name order by fnum desc) srow
  from( 
select p2.flights_city_name,p2.flightnum,count(1) fnum
from (
select p1.flights_city_name,to_char(trunc(p1.origin_std)+1,'iw') weeks,count(1) flightnum
               from dw.da_flight p1
               where p1.flight_date>=to_date('2019-03-31','yyyy-mm-dd')
  and p1.flight_date<=to_date('2019-10-26','yyyy-mm-dd')
  and p1.flag<>2
  and p1.company_id=0
  group by p1.flights_city_name,to_char(trunc(p1.origin_std)+1,'iw'))p2
  group by p2.flights_city_name,p2.flightnum)p3)p4
  where p4.srow=1
                  
) tb2 on tb1.flights_city_name=tb2.flights_city_name
  
) tp1 
left join 
(
select  tb1.*,tb2.flightnum
from(
select t2.flights_city_name,t2.origincity_name,t2.destcity_name,count(1) num,suM(t2.layout)  layout,min(flight_date) mindate,max(flight_date) maxdate
from dw.da_flight t2 
where t2.flight_date>=to_date('2018-10-28','yyyy-mm-dd')
  and t2.flight_date<=to_date('2019-03-30','yyyy-mm-dd')
  and t2.flag<>2
  and t2.company_id=0
  group by t2.flights_city_name,t2.origincity_name,t2.destcity_name)tb1 
  left join (
  select p4.flights_city_name,p4.flightnum
  from(
  select p3.flights_city_name,p3.flightnum,row_number()over(partition by p3.flights_city_name order by fnum desc) srow
  from( 
select p2.flights_city_name,p2.flightnum,count(1) fnum
from (
select p1.flights_city_name,to_char(p1.flight_date,'iw') weeks,count(1) flightnum
               from dw.da_flight p1
               where p1.flight_date>=to_date('2018-10-28','yyyy-mm-dd')
  and p1.flight_date<=to_date('2019-03-30','yyyy-mm-dd')
  and p1.flag<>2
  and p1.company_id=0
  group by p1.flights_city_name,to_char(p1.flight_date,'iw'))p2
  group by p2.flights_city_name,p2.flightnum)p3)p4
  where p4.srow=1                  
) tb2 on tb1.flights_city_name=tb2.flights_city_name
  
  )tp2 on tp1.flights_city_name=tp2.flights_city_name
  
left join(  
select t2.flights_city_name,min(t2.flight_date) mindate,max(t2.flight_date) maxdate
from dw.da_flight t2 
where t2.flight_date< to_date('2018-10-28','yyyy-mm-dd')
  and t2.flag<>2
  and t2.company_id=0
  group by t2.flights_city_name
  )tp3 on tp3.flights_city_name=tp1.flights_city_name
