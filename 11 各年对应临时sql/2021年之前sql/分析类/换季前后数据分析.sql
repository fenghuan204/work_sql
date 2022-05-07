select tp1.flights_city_name ����,tp1.origincity_name ʼ��,tp1.destcity_name Ŀ��,
case when tp2.flights_city_name is not null and tp2.flightnum< tp1.flightnum then '�ڷɼ���'
when tp2.flights_city_name is not null and tp2.flightnum> tp1.flightnum then '�ڷɼ���'
when tp2.flights_city_name is not null and tp2.flightnum= tp1.flightnum then '�ڷɲ���'
when tp2.flights_city_name is null and tp3.flights_city_name is not null then '����'
when tp2.flights_city_name is null and tp3.flights_city_name is null then '�¿�����'
end ����,tp1.num �ܺ�����,tp1.layout �ܼƻ���,tp1.flightnum �ܺ�����,tp2.flightnum �ϸ������ܺ�����,
tp1.mindate ���ﺽ����ʼʱ��,tp1.maxdate ���ﺽ������ʱ��,tp2.mindate ��һ��������ʼʱ��,tp2.maxdate ��һ����������ʱ��,
tp3.mindate ����ʱ��,
tp3.maxdate ����һ����������ʱ��
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
