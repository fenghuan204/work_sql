select replace(replace(replace(t1.route_name, '����', '�Ϻ�'),
                       '�ֶ�',
                       '�Ϻ�'),
               'ę́',
               '����') flight_city_name,
               regexp_substr(t1.route_name,'(�ֶ�)|(����)|(ę́)|(����)'),
sum(t1.vari_cost)/sum(t1.round_time) avgtime
from  hdb.recent_flights_cost t1
 where t1.flight_date >= to_date('2020-04-01', 'yyyy-mm-dd')
   and t1.flight_date < trunc(sysdate)
   and nvl(t1.round_time, 0) > 0
   and nvl(t1.checkin_s_mile, 0) > 0
   and t1.total_cost > 0
   and replace(replace(replace(t1.route_name, '����', '�Ϻ�'),
                       '�ֶ�',
                       '�Ϻ�'),
               'ę́',
               '����')
               in

(
select replace(replace(replace(t1.route_name, '����', '�Ϻ�'),
                       '�ֶ�',
                       '�Ϻ�'),
               'ę́',
               '����')
  from hdb.recent_flights_cost t1
 where t1.flight_date >= to_date('2020-04-01', 'yyyy-mm-dd')
   and t1.flight_date < trunc(sysdate)
   and nvl(t1.round_time, 0) > 0
   and nvl(t1.checkin_s_mile, 0) > 0
   and t1.total_cost > 0
 group by replace(replace(replace(t1.route_name, '����', '�Ϻ�'),
                       '�ֶ�',
                       '�Ϻ�'),
               'ę́',
               '����')
               having count(distinct t1.route_name)>1)
               group by replace(replace(replace(t1.route_name, '����', '�Ϻ�'),
                       '�ֶ�',
                       '�Ϻ�'),
               'ę́',
               '����') ,regexp_substr(t1.route_name,'(�ֶ�)|(����)|(ę́)|(����)')
