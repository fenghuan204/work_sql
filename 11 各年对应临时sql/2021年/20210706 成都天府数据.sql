select h.flight_date,case when h.originairport_name like '%成都%' then '天府' 
when h.originairport_name like '%武隆%' then '重庆'
else h.originairport_name end 始发站 ,
case when h.destairport_name like '%成都%' then '天府' 
when h.destairport_name like '%武隆%' then '重庆'
else h.destairport_name end 目的站,
h.flight_no,
h.layout,
h.flag,
sum(h1.tkt)


from dw.da_flight h
left join (
select t1.segment_head_id,t2.origin_std,t1.whole_segment,t2.segment_code,t2.flights_segment_name,t2.layout,t2.flight_no,t2.flag,t2.route_name,
count(1) tkt
 from cqsale.cq_order_head@to_air t1
 join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
 where t1.r_flights_date=trunc(sysdate)
 and t1.flag_id in(3,5,40,41)
 and t1.seats_name is not null
 and t1.whole_segment like '%TFU%'
 group by t1.segment_head_id,t2.origin_std,t1.whole_segment,t2.segment_code,t2.flights_segment_name,t2.layout,t2.flight_no,t2.flag,t2.route_name)
 h1 on h.segment_head_id=h1.segment_head_id
 where h.segment_code like '%TFU%'
 and h.flag=0
 and h.flight_date =trunc(sysdate)
 group by h.flight_date,case when h.originairport_name like '%成都%' then '天府' 
when h.originairport_name like '%武隆%' then '重庆'
else h.originairport_name end ,
case when h.destairport_name like '%成都%' then '天府' 
when h.destairport_name like '%武隆%' then '重庆'
else h.destairport_name end ,
h.flight_no,
h.layout,
h.flag
 
