 1、退票日期数据：20200101~至今 对比日期20190112~去年春运相同日期    每个日期的退票量
 2、航段退票量差距：票量差TOP 20    航渡 昨天退票量、 20200113~20200119 平均退票量  票量差
 3、航班日期 昨天退票量
 
 select '今年' 类型,trunc(t1.money_date) 退票日期,count(1)  退票量
from dw.da_order_drawback t1
join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
where t1.money_date>=to_date('2020-01-01','yyyy-mm-dd')
  and t1.money_date< trunc(sysdate)
  and t2.flag<>2
  and t1.seats_name is not null
  group  by trunc(t1.money_date)

union all


select '去年同期' 类型,t3.datetime,count(1)
from dw.da_order_drawback t1
join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
join (select * from dw.adt_chunyun_corredate 
where chunyun_year = 2020 and corre_year = 2019)t3 on trunc(t1.money_date)=t3.corre_date
where t1.money_date>=to_date('2019-01-12','yyyy-mm-dd')
  and t1.money_date< trunc(sysdate)
  and t3.datetime>=to_date('2020-01-01','yyyy-mm-dd')
  and t3.datetime< trunc(sysdate)
  and t2.flag<>2
  and t1.seats_name is not null
  group by t3.datetime;
  
  
  
  
  select h1.flights_segment_name 航段, h1.ticketnum 昨日退票量,nvl(h2.avgnum,0) "0113~0119平均退票量",
h1.ticketnum-nvl(h2.avgnum,0) 票量差,row_number()over(order by h1.ticketnum-nvl(h2.avgnum,0) desc) 票量差排序
from(
select t2.flights_segment_name,count(1) ticketnum
from dw.da_order_drawback t1
join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
where t1.money_date>=trunc(sysdate-1)
  and t1.money_date< trunc(sysdate)
  and t2.flag<>2
  and t1.seats_name is not null
  group  by t2.flights_segment_name)h1
  left join (
  select flights_segment_name,round(avg(ticketnum),0) avgnum
  from(
  select t2.flights_segment_name,trunc(t1.money_date) moneydate,count(1) ticketnum
from dw.da_order_drawback t1
join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
where t1.money_date>=to_date('2020-01-13','yyyy-mm-dd')
  and t1.money_date< to_date('2020-01-20','yyyy-mm-dd')
  and t2.flag<>2
  and t1.seats_name is not null
  group  by t2.flights_segment_name,trunc(t1.money_date))
  group by flights_segment_name)h2 on h1.flights_segment_name=h2.flights_segment_name;
  
  
  
  select h1.flight_date 航班日期, h1.adheads 退票提前期,h1.ticketnum 昨日退票量,
nvl(h2.avgnum,0) "0113~0119提前期平均退票量",
h1.ticketnum-nvl(h2.avgnum,0) 票量差,row_number()over(order by h1.ticketnum-nvl(h2.avgnum,0) desc) 票量差排序
from(
select t2.flight_date,t2.flight_date-trunc(t1.money_date) adheads,count(1) ticketnum
from dw.da_order_drawback t1
join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
where t1.money_date>=trunc(sysdate-1)
  and t1.money_date< trunc(sysdate)
  and t2.flag<>2
  and t1.seats_name is not null
  group  by t2.flight_date,t2.flight_date-trunc(t1.money_date)
  )h1
  left join (
  select t2.flight_date-trunc(t1.money_date) adheads,round(count(1)/7,0) avgnum
from dw.da_order_drawback t1
join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
where t1.money_date>=to_date('2020-01-13','yyyy-mm-dd')
  and t1.money_date< to_date('2020-01-20','yyyy-mm-dd')
  and t2.flag<>2
  and t1.seats_name is not null
  group by t2.flight_date-trunc(t1.money_date)
 )h2 on h1.adheads=h2.adheads;




 select to_char(t1.money_date,'mmd') 类型,t2.flights_segment_name 航段,count(1) 退票量
from dw.da_order_drawback t1
join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
where t1.money_date>=to_date('2020-01-20','yyyy-mm-dd')
  and t1.money_date< trunc(sysdate)
  and t2.flag<>2
  and t1.seats_name is not null
  group  by to_char(t1.money_date,'mmd'),t2.flights_segment_name
  
  union all
  
  select '0113~0119' 类型, flights_segment_name,round(avg(ticketnum),0) avgnum
  from(
  select t2.flights_segment_name,trunc(t1.money_date) moneydate,count(1) ticketnum
from dw.da_order_drawback t1
join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
where t1.money_date>=to_date('2020-01-13','yyyy-mm-dd')
  and t1.money_date< to_date('2020-01-20','yyyy-mm-dd')
  and t2.flag<>2
  and t1.seats_name is not null
  group  by t2.flights_segment_name,trunc(t1.money_date))
  group by flights_segment_name;
 
 
 
select *
from(
select h1.*,h2.fee_rate
from(
select trunc(t1.origin_std) flightdate,case when t1.seattype='商务座' then '商务座'
else '非商务座' end seattype,
case when regexp_like(t1.seats_name ,'Y|W') then 'YW'
when regexp_like(t1.seats_name ,'S|H|V|K|L|M') then 'SHVKLM'
when regexp_like(t1.seats_name ,'N|Q|T|X|U|E') then 'NQTXUE'
when regexp_like(t1.seats_name ,'R1|R2|R3|R4') then 'R1R2R3R4'
when regexp_like(t1.seats_name ,'B|G|G1|G2|O') then 'BGO'
when regexp_like(t1.seats_name ,'P|P1|P2|P3|P4|P5') then 'PP1P2P3P4P5'
else '其他' end seatname,
case when t2.area_type='国内' then 
case when (t1.origin_std-t1.money_date)*24< 2 then '2h-'
when (t1.origin_std-t1.money_date)*24>= 2 
and (t1.origin_std-t1.money_date)*24< 24 then '[2h,1D)'
when (t1.origin_std-t1.money_date)>= 1 
and (t1.origin_std-t1.money_date)< 3 then '[1D,3D)'
when (t1.origin_std-t1.money_date)>= 3 
and (t1.origin_std-t1.money_date)< 7 then '[3D,7D)'
when (t1.origin_std-t1.money_date)>= 7
 then '7D+'
end
when t2.area_type='国际' then 
case when (t1.origin_std-t1.money_date)*24< 0 then '离站后'
when (t1.origin_std-t1.money_date)*24>= 0
and (t1.origin_std-t1.money_date)*24< 24 then '[0,1D)'
when (t1.origin_std-t1.money_date)>= 1 
and (t1.origin_std-t1.money_date)< 7 then '[1D,7D)'
when (t1.origin_std-t1.money_date)>= 7
and (t1.origin_std-t1.money_date)< 15 then '[7D,15D)'
when (t1.origin_std-t1.money_date)>= 15
and (t1.origin_std-t1.money_date)< 30 then '[15D,30D)'
when (t1.origin_std-t1.money_date)>= 30 then '30D+'
end
end priod_date,t2.flights_segment_name,
t2.area_type,
t1.money_fy,t1.ticketprice,
case when t1.ticketprice=0 then 0
else t1.money_fy/ t1.ticketprice end rate
from dw.da_order_drawback t1
join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
where t1.money_date>=trunc(sysdate)-1
and t1.seats_name is not null)h1
left join dw.dim_tg_rule h2 on h2.seat_type=h1.seattype and h2.nationflag=h1.area_type and h2.priod_date=h1.priod_date and h1.seatname=h2.seats_name
where h2.fee_rate is not null)h3
where round(h3.fee_rate*10,0)-round(h3.rate*10,0)>0.1;
