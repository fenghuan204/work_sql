
--1、函数：listagg

with temp as(  
  select '1' nation ,'Guangzhou' city from dual union all  
  select '2' nation ,'Shanghai' city from dual union all  
  select 'China' nation ,'Beijing' city from dual union all  
  select 'USA' nation ,'New York' city from dual union all  
  select 'USA' nation ,'Bostom' city from dual union all  
  select 'Japan' nation ,'Tokyo' city from dual   
)  
select nation,listagg(city,',') within GROUP (order by city)  
from temp  
group by nation

--2、窗口函数

---每一行合计所有月的数据

select month,flightnum,sum(flightnum)over(order by month rows between unbounded preceding and unbounded following ) 
from(
select to_char(t2.flight_date,'yyyymm') month,count(1) flightnum
  from dw.da_flight t2
  where t2.flag<>0
  and t2.flight_date>=to_date('2016-01-01','yyyy-mm-dd')
  group by  to_char(t2.flight_date,'yyyymm'));
  
  
  --按月累计
  select month,flightnum,sum(flightnum)over(order by month rows between unbounded preceding and current row ) 
from(
select to_char(t2.flight_date,'yyyymm') month,count(1) flightnum
  from dw.da_flight t2
  where t2.flag<>0
  and t2.flight_date>=to_date('2016-01-01','yyyy-mm-dd')
  group by  to_char(t2.flight_date,'yyyymm'));

--前后2行+当前行的平均值

 select month,flightnum,avg(flightnum)over(order by month rows between 2 preceding and 2 following ) 
from(
select to_char(t2.flight_date,'yyyymm') month,count(1) flightnum
  from dw.da_flight t2
  where t2.flag<>0
  and t2.flight_date>=to_date('2016-01-01','yyyy-mm-dd')
  group by  to_char(t2.flight_date,'yyyymm'));
  
  --前后偏移2行，平均每日销售额
  
  select flight_date,sum(flightnum),sum(sum(flightnum))over(order by flight_date 
  range between interval '0' day preceding and interval '6' day following) flight
  from (
 select t2.flight_date,count(1) flightnum
  from dw.da_flight t2
  where t2.flag<>0
  and t2.flight_date>=to_date('2017-07-03','yyyy-mm-dd')
  and t2.flight_date< to_date('2017-08-07','yyyy-mm-dd')
  group by  t2.flight_date)
  group by flight_date
  
  
  ---显示每一行的上下偏移行。

  select flight_date,flightnum,first_value(flightnum)over(order by flight_date rows between 1 preceding and 1  following) 偏移上行,
  last_value(flightnum)over(order by flight_date rows between 1 preceding and 1  following) 偏移下行,
  lag(flightnum)over(order by flight_date) 上行,
  lead(flightnum)over(order by flight_date) 下行
  from (
 select t2.flight_date,count(1) flightnum
  from dw.da_flight t2
  where t2.flag<>0
  and t2.flight_date>=to_date('2017-07-03','yyyy-mm-dd')
  and t2.flight_date< to_date('2017-08-07','yyyy-mm-dd')
  group by  t2.flight_date);

---正则表达式

 WHERE REGEXP_LIKE(text, 'CEDAR LAKE', 'c'); --大小写敏感

 WHERE REGEXP_LIKE(text, 'CEDAR LAKE', 'i'); --大小写不敏感


  
