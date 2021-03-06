/*1、开航近两年每月运力情况，趋势；
2、客座率变化；
3、乘客分布变化趋势；
--4、乘客年龄和性别变化趋势；
--5、乘客复购率变化；
--6、票均价格变化（按月）；
7、石家庄连程航线销量趋势；
8、石家庄通航航点变化，按航季节，航线数量变化（按国际国内区域统计一下）
9、航线运力占春秋的所有的占比变化*/



1、数据从2017年1月到2018年9月



select to_char(t1.flights_date,'yyyy'),to_char(t1.flights_date,'yyyymm'),count(1),count(distinct t2.segment_code)
  from dw.fact_recent_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id = t2.segment_head_id
  where t2.flights_segment_name like '%石家庄%'
    and t1.flights_date>=to_date('2017-01-01','yyyy-mm-dd')
    and t1.flights_date< to_date('2018-10-01','yyyy-mm-dd')
    and t1.flag_id in(3,5,40,41)
    group by to_char(t1.flights_date,'yyyy'),to_char(t1.flights_date,'yyyymm');
    
    ---年度乘机人数
   select to_char(t1.flights_date,'yyyy'),count(1),count(distinct t2.segment_code)
  from dw.fact_recent_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id = t2.segment_head_id
  where t2.flights_segment_name like '%石家庄%'
    and t1.flights_date>=to_date('2017-01-01','yyyy-mm-dd')
    and t1.flights_date< to_date('2018-10-01','yyyy-mm-dd')
    and t1.flag_id in(3,5,40,41)
    group by to_char(t1.flights_date,'yyyy');
    
    
  ---具体航线  
  select distinct to_char(t1.flights_date,'yyyy'), case
         when instr(t3.wf_segment, '＝', 1, 2) > 0 then
          split_part(t3.wf_segment, '＝', 1) || '＝' ||
          split_part(t3.wf_segment, '＝', 3)
         else
          t3.wf_segment
       end wf_segment
  from dw.fact_recent_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id = t2.segment_head_id
  left join dw.dim_segment_type t3 on t2.route_id=t3.route_id and t3.h_route_id=t3.h_route_id
  where t2.flights_segment_name like '%石家庄%'
    and t1.flights_date>=to_date('2017-01-01','yyyy-mm-dd')
    and t1.flights_date< to_date('2018-10-01','yyyy-mm-dd')
    and t1.flag_id in(3,5,40,41)

    
    
2、客座率变化


select to_char(t1.flight_date,'yyyy'),to_char(t1.flight_date,'yyyymm'),sum(t1.checkin_mile)/sum(t1.checkin_s_mile)
from dw.bi_tbl_plf t1
where t1.flight_segment like '%石家庄%'
    and t1.flight_date>=to_date('2017-01-01','yyyy-mm-dd')
    and t1.flight_date< to_date('2018-10-01','yyyy-mm-dd')
    group by to_char(t1.flight_date,'yyyy'),to_char(t1.flight_date,'yyyymm');
    
    
  
3、乘机人地域分布

select to_char(t1.flights_date,'yyyy'),
case when t3.nationality like '%中国%' then '中国'
     else '外国' end,
     case when t3.nationality like '%中国%' then t3.cust_province
     else '-' end ,
     count(1)
  from dw.fact_recent_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id = t2.segment_head_id
  left join dw.bi_order_region t3 on t1.flights_order_head_id=t3.flights_order_head_id
  where t2.flights_segment_name like '%石家庄%'
    and t1.flights_date>=to_date('2017-01-01','yyyy-mm-dd')
    and t1.flights_date< to_date('2018-10-01','yyyy-mm-dd')
    and t1.flag_id in(3,5,40,41)
    group by to_char(t1.flights_date,'yyyy'),
case when t3.nationality like '%中国%' then '中国'
     else '外国' end,
     case when t3.nationality like '%中国%' then t3.cust_province
     else '-' end;
     
7、石家庄联程航线

select  to_char(t1.flights_date_1,'yyyy'),to_char(t1.flights_date_1,'yyyymm'),count(1)
from dw.bi_connect_segment t1
where t1.flights_date_1>=to_date('2017-01-01','yyyy-mm-dd')
  and t1.flights_date_1< to_date('2018-10-01','yyyy-mm-dd')
  and t1.flights_segment_1 like '%SJW'
  group by to_char(t1.flights_date_1,'yyyy'),to_char(t1.flights_date_1,'yyyymm');



8、航线量变化

select t2.flight_quarter,count(distinct t1.flights_segment_name)
from dw.da_flight t1
join dw.adt_corre_date t2 on t1.flight_date=t2.datetime
where t1.flight_date>=to_date('2017-03-26','yyyy-mm-dd')
and t1.flag<>2
and t1.flights_segment_name like '%石家庄%'
group by t2.flight_quarter;

9、运力变化


select to_char(t1.flights_date,'yyyy'),to_char(t1.flights_date,'yyyymm'),
t1.seat_type,    count(1)
  from dw.fact_recent_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id = t2.segment_head_id
  where t1.flights_date>=to_date('2017-01-01','yyyy-mm-dd')
    and t1.flights_date< to_date('2018-10-01','yyyy-mm-dd')
    and t1.flag_id in(3,5,40,41)
    and t2.flights_segment_name like '%石家庄%'
    and t1.seats_name is not null
    group by to_char(t1.flights_date,'yyyy'),to_char(t1.flights_date,'yyyymm'),t1.seat_type


    
