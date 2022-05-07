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
