select 
trunc(t1.money_date) 退票日期,
t2.flights_segment_name 退票航段,
t4.flight_date-t2.flight_date 重购航班日期减去退票航班日期,
t4.flights_segment_name 重购航段,
t4.flight_date 重购航班日期,
count(distinct t3.flights_order_head_id) 重购机票数
/*case when t3.r_flights_date is not null then t3.r_flights_date-trunc(t1.origin_std) 
else null end ,
case when t3.r_flights_date is not null then  t3.ticket_price*nvl(t3.r_com_rate,1) -t1.ticketprice
else null end ,
t4.flights_segment_name,
count(distinct t1.flights_order_head_id),count(distinct t3.flights_order_head_id)*/
from dw.da_order_drawback t1
 join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
 join cqsale.cq_order_head@to_air  t3 on t1.codeno=t3.codeno and t1.sname=t3.name||coalesce(t3.second_name,'') and t3.r_flights_date<>trunc(t1.origin_std) and 
t3.r_order_date> t1.money_date and t3.flag_id in(3,5,40) and t3.r_order_date>=trunc(sysdate)-1 and t3.r_flights_date>=trunc(sysdate)-1
 join dw.da_flight t4 on t3.segment_head_id=t4.segment_head_id
where t1.money_date>=trunc(sysdate)-1
and t1.seats_name is not null
group by /*case when t3.r_flights_date is not null then t3.r_flights_date-trunc(t1.origin_std) 
else null end ,
case when t3.r_flights_date is not null then  t3.ticket_price*nvl(t3.r_com_rate,1) -t1.ticketprice
else null end,
t4.flights_segment_name
*/
trunc(t1.money_date) ,
t2.flights_segment_name ,
t4.flights_segment_name ,
t4.flight_date,
t4.flight_date-t2.flight_date;




----------------------每天发给梁子的数据



select /*+parallel(4) */
trunc(t1.origin_std) flightdate,
case when t5.orderday is not null then '重购'
else '未重购' end,
case when t5.orderday is not null and t2.segment_code=t5.flightsegment then '相同航段'
when t5.orderday is not null and t2.segment_code<>t5.flightsegment then '不相同航段'
else null end ,
case when t5.orderday is not null then  t5.flightdate-trunc(t1.origin_std) 
else null end ,case when t1.seattype='商务座' then '商务座'
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
case when t3.order_date< to_date('2020-01-24','yyyy-mm-dd') then '24号之前'
else '24号以后' end,count(1)  退票量
from dw.da_order_drawback t1
join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
join cqsale.cq_order@to_air t3 on t1.flights_order_id=t3.flights_order_id
left  join (select  t4.name||coalesce(t4.second_name,'') sname,t4.codeno,min(t4.r_flights_date) flightdate,
min(t4.r_order_date) orderday,min(t4.whole_segment) flightsegment
                  from cqsale.cq_order_head@to_air t4 
          where t4.r_order_date> =to_date('2020-01-19','yyyy-mm-dd')
          and t4.flag_id in(3,5,40)
          and t4.seats_name is not null
          group by t4.name||coalesce(t4.second_name,'') ,t4.codeno
            ) t5 on t1.sname=t5.sname and t1.codeno=t5.codeno and t1.money_date< t5.orderday
where t2.flight_date>=to_date('2020-01-19','yyyy-mm-dd')
and t2.flight_date< to_date('2020-02-16','yyyy-mm-dd')
and t1.money_date< trunc(sysdate)
and t2.company_id=0
group by trunc(t1.origin_std) ,
case when t5.orderday is not null then '重购'
else '未重购' end,
case when t5.orderday is not null and t2.segment_code=t5.flightsegment then '相同航段'
when t5.orderday is not null and t2.segment_code<>t5.flightsegment then '不相同航段'
else null end ,
case when t5.orderday is not null then  t5.flightdate-trunc(t1.origin_std) 
else null end ,case when t1.seattype='商务座' then '商务座'
else '非商务座' end ,
case when regexp_like(t1.seats_name ,'Y|W') then 'YW'
when regexp_like(t1.seats_name ,'S|H|V|K|L|M') then 'SHVKLM'
when regexp_like(t1.seats_name ,'N|Q|T|X|U|E') then 'NQTXUE'
when regexp_like(t1.seats_name ,'R1|R2|R3|R4') then 'R1R2R3R4'
when regexp_like(t1.seats_name ,'B|G|G1|G2|O') then 'BGO'
when regexp_like(t1.seats_name ,'P|P1|P2|P3|P4|P5') then 'PP1P2P3P4P5'
else '其他' end ,
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
end ,t2.flights_segment_name,
t2.area_type,
case when t3.order_date< to_date('2020-01-24','yyyy-mm-dd') then '24号之前'
else '24号以后' end;



