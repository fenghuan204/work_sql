select h1.flightmonth �·�,substr(h1.flightmonth,1,4) year,substr(h1.flightmonth,5,2) month,h1.datenum ����,
       h1.checkin_num/h1.datenum �ճ˻�����,h1.round_time/h1.datenum ���ֵ�Сʱ,h1.flightnum/h1.datenum �պ�����,
       h1.vari_cost/h1.datenum �ձ䶯�ɱ�,h1.vari_cost/h1.round_time Сʱ�䶯�ɱ�, 
       h1.checkin_num �˻�����,h1.plf ������,h1.round_time �ֵ�Сʱ,h1.flightnum ������,h1.day_income ����,h1.total_income ����,
       h1.total_cost �ɱ�,h1.vari_cost �䶯�ɱ�,h2.���ɻ�������,h2.�վ�������,h2.�ɻ�����
from(
select to_char(t1.flight_date,'yyyymm') flightmonth,count(distinct t1.flight_date) datenum,
       sum(t1.checkin_num) checkin_num,
       sum(t1.checkin_mile)/sum(t1.checkin_s_mile) plf,sum(t1.round_time) round_time,count(1) flightnum,
       sum(t1.day_income) day_income,sum(t1.total_income) total_income,sum(t1.total_cost-t1.tax_fee) total_cost,suM(t1.vari_cost) vari_cost
 from hdb.recent_flights_cost t1
 where t1.flight_date>=to_date('2019-01-01','yyyy-mm-dd')
   and t1.flight_date< trunc(sysdate)
   and t1.total_cost>0
   and t1.checkin_s_mile>0
   and t1.round_time is not null 
   group by to_char(t1.flight_date,'yyyymm'))h1
   left join(   
 select to_char(t1.date_time,'yyyymm') flightmonth,max(t1.run_airplane_count) ���ɻ�������,
 avg(t1.run_airplane_count) �վ�������,max(t1.flight_count) �ɻ�����
 from stg.f_day_statistics t1
 where t1.date_time>=add_months(last_day(trunc(sysdate))+1,-24)
   and t1.date_time< trunc(sysdate)
   group by to_char(t1.date_time,'yyyymm'))h2 on h1.flightmonth=h2.flightmonth;
   
   
   
   
   select t1.route_name ����,to_char(t1.flight_date,'yyyymm') �·�,sum(t1.bax_num)/sum(t1.plan) ��������,
sum(t1.total_income) ����,sum(t1.total_cost) �ɱ�,
sum(t1.day_income) ����,sum(t1.totalnum) ������,sum(t1.total_income)/sum(t1.checkin_mile) �͹�������,
sum(t1.total_income)/sum(t1.checkin_s_mile) ����������
from hdb.recent_flights_cost t1
where t1.flight_date>=to_date('2015-10-01','yyyy-mm-dd')
  and t1.flight_date< to_date('2017-09-01','yyyy-mm-dd')
  and t1.total_cost>0
  and t1.checkin_mile>0
  and t1.checkin_s_mile>0
  and t1.flight_no not like '%+%'
  and t1.route_name like 'ʯ��ׯ%'
  group by t1.route_name,to_char(t1.flight_date,'yyyymm')


