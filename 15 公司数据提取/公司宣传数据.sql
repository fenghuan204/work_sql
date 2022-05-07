select * 
from stg.f_day_statistics t1
where t1.date_time>= to_date('2019-02-01','yyyy-mm-dd')
and t1.date_time<=to_date('2019-02-28','yyyy-mm-dd');

截止2019年2月底 机队规模
截止2019年2月底  航线数（国内、国际、地区），通达城市、机场 

（建议4月底的时候 再出一版 换季后的最新数据）


1、截止到2019年2月底 84架飞机

2、18/19年冬春航季数据 (航线）--截止到2月底还在飞航线

select distinct t2.nationflag 航线性质,t2.flights_segment_name 航线,t2.origincity_name 始发城市,t2.destcity_name 目的城市
from dw.da_flight t2
where t2.flight_date<=to_date('2019-02-28','yyyy-mm-dd')
  and t2.flight_date>=to_date('2018-10-28','yyyy-mm-dd')
  and t2.company_id=0
  and t2.flag<>2

3、 18/19年冬春航季数据 (城市、航点）--截止到2月底在飞城市及机场


select distinct t2.origin_country 国家,t2.origincity_name 城市,t2.originairport_name 机场
from dw.da_flight t2
where t2.flight_date<=to_date('2019-02-28','yyyy-mm-dd')
  and t2.flight_date>=to_date('2018-10-28','yyyy-mm-dd')
  and t2.company_id=0
  and t2.flag<>2
