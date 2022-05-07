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
