select h1.*,h2.num2 实际运行架数,h2.flight_count 飞机总数
from(
select to_char(t1.flight_date,'yyyymm') 航班月,count(distinct t1.segment_code) 航段数
  from dw.da_flight t1
  where t1.flight_date>=to_date('2020-07-01','yyyy-mm-dd')
    and t1.flight_date< to_date('2020-09-01','yyyy-mm-dd')
    and t1.flag<>2
    and t1.company_id=0
    group by to_char(t1.flight_date,'yyyymm'))h1
  left join(  
select  to_char(t1.date_time,'yyyymm') months,avg(run_airplane_count) num2,max(t1.flight_count) flight_count
 from stg.f_day_statistics t1
 where t1.date_time>=to_date('2020-07-01','yyyy-mm-dd')
   and t1.date_time< to_date('2020-09-01','yyyy-mm-dd')
   group by to_char(t1.date_time,'yyyymm'))h2  on h1.航班月=h2.months
