select replace(replace(replace(t1.route_name, '虹桥', '上海'),
                       '浦东',
                       '上海'),
               '茅台',
               '遵义') flight_city_name,
               regexp_substr(t1.route_name,'(浦东)|(虹桥)|(茅台)|(遵义)'),
sum(t1.vari_cost)/sum(t1.round_time) avgtime
from  hdb.recent_flights_cost t1
 where t1.flight_date >= to_date('2020-04-01', 'yyyy-mm-dd')
   and t1.flight_date < trunc(sysdate)
   and nvl(t1.round_time, 0) > 0
   and nvl(t1.checkin_s_mile, 0) > 0
   and t1.total_cost > 0
   and replace(replace(replace(t1.route_name, '虹桥', '上海'),
                       '浦东',
                       '上海'),
               '茅台',
               '遵义')
               in

(
select replace(replace(replace(t1.route_name, '虹桥', '上海'),
                       '浦东',
                       '上海'),
               '茅台',
               '遵义')
  from hdb.recent_flights_cost t1
 where t1.flight_date >= to_date('2020-04-01', 'yyyy-mm-dd')
   and t1.flight_date < trunc(sysdate)
   and nvl(t1.round_time, 0) > 0
   and nvl(t1.checkin_s_mile, 0) > 0
   and t1.total_cost > 0
 group by replace(replace(replace(t1.route_name, '虹桥', '上海'),
                       '浦东',
                       '上海'),
               '茅台',
               '遵义')
               having count(distinct t1.route_name)>1)
               group by replace(replace(replace(t1.route_name, '虹桥', '上海'),
                       '浦东',
                       '上海'),
               '茅台',
               '遵义') ,regexp_substr(t1.route_name,'(浦东)|(虹桥)|(茅台)|(遵义)')
