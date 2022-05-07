#1、根据地相关数据

select '上海' 类型,to_char(t2.flight_date,'yyyy') 年,to_char(t2.flight_date,'yyyymm') 月,count(distinct t2.flights_id) 班次,sum(t2.oversale) 计划量
from  dw.da_flight t2 
where t2.flight_date>=to_date('2016-11-01','yyyy-mm-dd')
  and t2.flight_date< to_date('2018-11-01','yyyy-mm-dd')
  and t2.company_id=0
  and t2.flag<>2
  and t2.flights_city_name like '%上海%'
  group by to_char(t2.flight_date,'yyyy'),to_char(t2.flight_date,'yyyymm')
  
  union all
  
  select '沈阳' 根据地,to_char(t2.flight_date,'yyyy') 年,to_char(t2.flight_date,'yyyymm') 月,count(distinct t2.flights_id) 班次,sum(t2.oversale) 计划量
from  dw.da_flight t2 
where t2.flight_date>=to_date('2016-11-01','yyyy-mm-dd')
  and t2.flight_date< to_date('2018-11-01','yyyy-mm-dd')
  and t2.company_id=0
  and t2.flag<>2
  and t2.flights_city_name like '%沈阳%'
  group by to_char(t2.flight_date,'yyyy'),to_char(t2.flight_date,'yyyymm')
  
  union all
  
  select '石家庄' 根据地,to_char(t2.flight_date,'yyyy') 年,to_char(t2.flight_date,'yyyymm') 月,count(distinct t2.flights_id) 班次,sum(t2.oversale) 计划量
from  dw.da_flight t2 
where t2.flight_date>=to_date('2016-11-01','yyyy-mm-dd')
  and t2.flight_date< to_date('2018-11-01','yyyy-mm-dd')
  and t2.company_id=0
  and t2.flag<>2
  and t2.flights_city_name like '%石家庄%'
  group by to_char(t2.flight_date,'yyyy'),to_char(t2.flight_date,'yyyymm')
  
  
  union all
  
  select '扬泰' 根据地,to_char(t2.flight_date,'yyyy') 年,to_char(t2.flight_date,'yyyymm') 月,count(distinct t2.flights_id) 班次,sum(t2.oversale) 计划量
from  dw.da_flight t2 
where t2.flight_date>=to_date('2016-11-01','yyyy-mm-dd')
  and t2.flight_date< to_date('2018-11-01','yyyy-mm-dd')
  and t2.company_id=0
  and t2.flag<>2
  and t2.flights_city_name like '%扬州%'
  group by to_char(t2.flight_date,'yyyy'),to_char(t2.flight_date,'yyyymm')
  
  
  
  union all
  
  select '哈尔滨' 根据地,to_char(t2.flight_date,'yyyy') 年,to_char(t2.flight_date,'yyyymm') 月,count(distinct t2.flights_id) 班次,sum(t2.oversale) 计划量
from  dw.da_flight t2 
where t2.flight_date>=to_date('2016-11-01','yyyy-mm-dd')
  and t2.flight_date< to_date('2018-11-01','yyyy-mm-dd')
  and t2.company_id=0
  and t2.flag<>2
  and t2.flights_city_name like '%哈尔滨%'
  group by to_char(t2.flight_date,'yyyy'),to_char(t2.flight_date,'yyyymm')
  
  
  
  union all
  
  select '宁波' 根据地,to_char(t2.flight_date,'yyyy') 年,to_char(t2.flight_date,'yyyymm') 月,count(distinct t2.flights_id) 班次,sum(t2.oversale) 计划量
from  dw.da_flight t2 
where t2.flight_date>=to_date('2016-11-01','yyyy-mm-dd')
  and t2.flight_date< to_date('2018-11-01','yyyy-mm-dd')
  and t2.company_id=0
  and t2.flag<>2
  and t2.flights_city_name like '%宁波%'
  group by to_char(t2.flight_date,'yyyy'),to_char(t2.flight_date,'yyyymm')
  
  
  
  union all
  
  select '揭阳' 根据地,to_char(t2.flight_date,'yyyy') 年,to_char(t2.flight_date,'yyyymm') 月,count(distinct t2.flights_id) 班次,sum(t2.oversale) 计划量
from  dw.da_flight t2 
where t2.flight_date>=to_date('2016-11-01','yyyy-mm-dd')
  and t2.flight_date< to_date('2018-11-01','yyyy-mm-dd')
  and t2.company_id=0
  and t2.flag<>2
  and t2.flights_city_name like '%揭阳%'
  group by to_char(t2.flight_date,'yyyy'),to_char(t2.flight_date,'yyyymm')
  
  
  union all
  
  select '深圳' 根据地,to_char(t2.flight_date,'yyyy') 年,to_char(t2.flight_date,'yyyymm') 月,count(distinct t2.flights_id) 班次,sum(t2.oversale) 计划量
from  dw.da_flight t2 
where t2.flight_date>=to_date('2016-11-01','yyyy-mm-dd')
  and t2.flight_date< to_date('2018-11-01','yyyy-mm-dd')
  and t2.company_id=0
  and t2.flag<>2
  and t2.flights_city_name like '%深圳%'
  group by to_char(t2.flight_date,'yyyy'),to_char(t2.flight_date,'yyyymm')
  
  union all
  select '全部根据地' 根据地,to_char(t2.flight_date,'yyyy') 年,to_char(t2.flight_date,'yyyymm') 月,count(distinct t2.flights_id) 班次,sum(t2.oversale) 计划量
from  dw.da_flight t2 
where t2.flight_date>=to_date('2016-11-01','yyyy-mm-dd')
  and t2.flight_date< to_date('2018-11-01','yyyy-mm-dd')
  and t2.company_id=0
  and t2.flag<>2
  and regexp_like(t2.flights_city_name,'(上海)|(宁波)|(扬州)|(揭阳)|(沈阳)|(石家庄)|(哈尔滨)|(深圳)')
  group by to_char(t2.flight_date,'yyyy'),to_char(t2.flight_date,'yyyymm')
  
  union all
  
  select '非根据地' 根据地,to_char(t2.flight_date,'yyyy') 年,to_char(t2.flight_date,'yyyymm') 月,count(distinct t2.flights_id) 班次,sum(t2.oversale) 计划量
from  dw.da_flight t2 
where t2.flight_date>=to_date('2016-11-01','yyyy-mm-dd')
  and t2.flight_date< to_date('2018-11-01','yyyy-mm-dd')
  and t2.company_id=0
  and t2.flag<>2
  and not regexp_like(t2.flights_city_name,'(上海)|(宁波)|(扬州)|(揭阳)|(沈阳)|(石家庄)|(哈尔滨)|(深圳)')
  group by to_char(t2.flight_date,'yyyy'),to_char(t2.flight_date,'yyyymm');



  
  
  
