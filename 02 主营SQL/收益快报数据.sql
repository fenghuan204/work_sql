select h1.flightmonth 月份,substr(h1.flightmonth,1,4) year,substr(h1.flightmonth,5,2) month,h1.datenum 天数,
       h1.checkin_num/h1.datenum 日乘机人数,h1.round_time/h1.datenum 日轮档小时,h1.flightnum/h1.datenum 日航班量,
       h1.vari_cost/h1.datenum 日变动成本,h1.vari_cost/h1.round_time 小时变动成本, 
       h1.checkin_num 乘机人数,h1.plf 客座率,h1.round_time 轮档小时,h1.flightnum 航班量,h1.day_income 收益,h1.total_income 收入,
       h1.total_cost 成本,h1.vari_cost 变动成本,h2.最大飞机运行数,h2.日均运行数,h2.飞机总数
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
 select to_char(t1.date_time,'yyyymm') flightmonth,max(t1.run_airplane_count) 最大飞机运行数,
 avg(t1.run_airplane_count) 日均运行数,max(t1.flight_count) 飞机总数
 from stg.f_day_statistics t1
 where t1.date_time>=add_months(last_day(trunc(sysdate))+1,-24)
   and t1.date_time< trunc(sysdate)
   group by to_char(t1.date_time,'yyyymm'))h2 on h1.flightmonth=h2.flightmonth;
   
   
   
   
   select t1.route_name 航线,to_char(t1.flight_date,'yyyymm') 月份,sum(t1.bax_num)/sum(t1.plan) 包销比例,
sum(t1.total_income) 收入,sum(t1.total_cost) 成本,
sum(t1.day_income) 收益,sum(t1.totalnum) 总人数,sum(t1.total_income)/sum(t1.checkin_mile) 客公里收入,
sum(t1.total_income)/sum(t1.checkin_s_mile) 座公里收入
from hdb.recent_flights_cost t1
where t1.flight_date>=to_date('2015-10-01','yyyy-mm-dd')
  and t1.flight_date< to_date('2017-09-01','yyyy-mm-dd')
  and t1.total_cost>0
  and t1.checkin_mile>0
  and t1.checkin_s_mile>0
  and t1.flight_no not like '%+%'
  and t1.route_name like '石家庄%'
  group by t1.route_name,to_char(t1.flight_date,'yyyymm')


