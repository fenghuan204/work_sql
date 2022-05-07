select t1.flight_date,
count(distinct t1.flights_id),count(distinct case when t1.flag=2 then t1.flights_id else null end)
 from dw.da_flight t1
 left join hdb.cq_airport t2 on t1.originairport=t2.threecodeforcity
 left join hdb.cq_airport t3 on t1.destairport=t3.threecodeforcity
 where (t1.originairport in('HDG',
'ZQZ',
'SHP',
'TVS',
'SJW',
'BPE',
'ZDE',
'XNT',
'HSU',
'BAD',
'AGB',
'DZB',
'XJB',
'CDE') or t1.destairport in('HDG',
'ZQZ',
'SHP',
'TVS',
'SJW',
'BPE',
'ZDE',
'XNT',
'HSU',
'BAD',
'AGB',
'DZB',
'XJB',
'CDE'))
 and t1.flight_date>=to_date('2020-01-01','yyyy-mm-dd')
 and t1.flight_date< to_date('2020-04-01','yyyy-mm-dd')
 and t1.company_id=0
 group by t1.flight_date;
 

select t1.flight_date,sum(t1.day_income)
 from hdb.recent_flights_cost t1
 where t1.flight_date>=to_date('2020-01-01','yyyy-mm-dd')
 and regexp_like(t1.route_name,'(承德)|(邯郸)|(石家庄)|(张家口)')
 and t1.total_cost>0
 group by t1.flight_date
