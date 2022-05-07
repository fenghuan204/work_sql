select to_char(h1.flight_date,'mm/dd') 日期,h1.area_type 航线性质,num1 今年航班量,num2 去年航班量
from(
 select  t1.flight_date,t1.area_type,count(1) num1
   from dw.da_flight t1
where t1.flight_date>=to_date('2020-01-10','yyyy-mm-dd')
   and t1.flight_date< to_date('2020-02-03','yyyy-mm-dd')
   and t1.flag<>2
   and t1.company_id=0
   group by t1.flight_date,t1.area_type)h1
   left join(  
 select  t3.datetime,t1.area_type,count(1) num2
   from dw.da_flight t1
   join (select * from dw.adt_chunyun_corredate 
where chunyun_year = 2020 and corre_year = 2019)t3 on t1.flight_date=t3.corre_date
where t1.flight_date>=to_date('2019-01-21','yyyy-mm-dd')
   and t1.flight_date<to_date('2020-02-03','yyyy-mm-dd')
   and  t3.datetime>=to_date('2020-01-10','yyyy-mm-dd')
   and t3.datetime< to_date('2020-02-03','yyyy-mm-dd')
   and t1.flag<>2
   and t1.company_id=0
   group by t3.datetime,t1.area_type）h2 on h1.flight_date=h2.datetime and h1.area_type=h2.area_type;
   
   
   
   
   select to_char(h1.flight_date,'mm/dd') 日期,num1 今年旅客量,num2 去年旅客量
from(
 select  t1.flight_date,sum(t1.checkin_mile)/sum(t1.checkin_s_mile) num1
   from dw.bi_tbl_plf   t1
where t1.flight_date>=to_date('2020-01-10','yyyy-mm-dd')
   and t1.flight_date< to_date('2020-02-03','yyyy-mm-dd')
   and t1.checkin_mile>0
   and t1.checkin_s_mile>0
   group by  t1.flight_date
   )h1
   left join(  
 select  t3.datetime,sum(t1.checkin_mile)/sum(t1.checkin_s_mile) num2
   from dw.bi_tbl_plf t1
   join (select * from dw.adt_chunyun_corredate 
where chunyun_year = 2020 and corre_year = 2019)t3 on t1.flight_date=t3.corre_date
where t1.flight_date>=to_date('2019-01-21','yyyy-mm-dd')
   and t1.flight_date<to_date('2020-02-03','yyyy-mm-dd')
   and  t3.datetime>=to_date('2020-01-10','yyyy-mm-dd')
   and t3.datetime< to_date('2020-02-03','yyyy-mm-dd')
  and t1.checkin_mile>0
   and t1.checkin_s_mile>0
   group by t3.datetime）h2 on h1.flight_date=h2.datetime;
   
   
   
   
   select to_char(h1.flight_date,'mm/dd') 日期,num1 今年旅客量,num2 去年旅客量
from(
 select  t1.flight_date,sum(t1.checkin_num) num1
   from hdb.recent_flights_cost   t1
where t1.flight_date>=to_date('2020-01-10','yyyy-mm-dd')
   and t1.flight_date< to_date('2020-02-03','yyyy-mm-dd')
   group by  t1.flight_date
   )h1
   left join(  
 select  t3.datetime,sum(t1.checkin_num) num2
   from hdb.recent_flights_cost t1
   join (select * from dw.adt_chunyun_corredate 
where chunyun_year = 2020 and corre_year = 2019)t3 on t1.flight_date=t3.corre_date
where t1.flight_date>=to_date('2019-01-21','yyyy-mm-dd')
   and t1.flight_date<to_date('2020-02-03','yyyy-mm-dd')
   and  t3.datetime>=to_date('2020-01-10','yyyy-mm-dd')
   and t3.datetime< to_date('2020-02-03','yyyy-mm-dd')
   group by t3.datetime）h2 on h1.flight_date=h2.datetime;
  

