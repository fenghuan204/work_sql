------每天发送查询数据

---每天退票量、退票金额、退票手续费

select /*+parallel(4) */
 trunc(t1.money_date) 退票日期,
sum(case when t1.seats_name is not null then 1 else 0 end) 退票量,
 sum((t3.ticket_price+t3.ad_fy+t3.port_pay+t3.other_fee+t3.other_fy+t3.insurance_fee)*nvl(t3.r_com_rate,1)) 退票金额,
 sum(t1.money_fy) 退票手续费 
    from dw.da_order_drawback t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  join cqsale.cq_order_head@to_air t3 on t1.flights_order_head_id=t3.flights_order_head_id
where t1.money_date>=to_date('2020-01-20','yyyy-mm-dd')
  and t1.money_date< trunc(sysdate)
  and t2.company_id=0
  group by trunc(t1.money_date)；
  
  
--累计退票量、退票金额 &每日订票量、订票金额

select  /*+parallel(4)*/
h1.moneyday 日期,h1.backnum 退票量,h1.ticketfee 退票涉及机票金额,h1.money_fy 退票手续费,h1.退给旅客费用,
h2.ordernum 订票量,h2.ticketfee 订票金额
from(
select  trunc(t1.money_date) moneyday,
sum(case when t1.seats_name is not null then 1 else 0 end)  backnum,
 sum((t3.ticket_price+t3.ad_fy+t3.port_pay+t3.other_fee+t3.other_fy+t3.insurance_fee)*nvl(t3.r_com_rate,1))  ticketfee,
 sum(t1.money_fy)  money_fy,
 sum((t3.ticket_price+t3.ad_fy+t3.port_pay+t3.other_fee+t3.other_fy+t3.insurance_fee)*nvl(t3.r_com_rate,1))-sum(t1.money_fy)  退给旅客费用
 from dw.da_order_drawback t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  join cqsale.cq_order_head@to_air t3 on t1.flights_order_head_id=t3.flights_order_head_id
where t1.money_date>=to_date('2020-01-20','yyyy-mm-dd')
  and t1.money_date< trunc(sysdate)
  and t2.company_id=0
  group by trunc(t1.money_date))h1
   left join(select  tt1.order_day,count(1) ordernum,sum(tt1.ticket_price+tt1.ad_fy+tt1.port_pay+tt1.other_fy+tt1.insurce_fee+tt1.other_fee+tt1.sx_fy) ticketfee
              from dw.fact_order_detail tt1
              join dw.da_flight tt2 on tt1.segment_Head_id=tt2.segment_head_id
              where tt2.flag<>2
              and tt1.order_day>=to_date('2020-01-20','yyyy-mm-dd')
              and tt1.order_day< trunc(sysdate)
        and tt2.company_id=0
        group by  tt1.order_day)h2 on h1.moneyday=h2.order_day;


  
select  /*+parallel(4)*/
h1.moneyday 日期,h1.backnum 退票量,h1.ticketfee 退票涉及机票金额,h1.money_fy 退票手续费,h1.退给旅客费用,
h3.ticketnum 去年退票量,h3.ticketfee 去年退票涉及机票金额,h3.money_fy 去年退票手续费,h3.退给旅客费用 去年退给旅客费用,
h2.ordernum 订票量,h2.ticketfee 订票金额
from(
select  trunc(t1.money_date) moneyday,
sum(case when t1.seats_name is not null then 1 else 0 end)  backnum,
 sum((t3.ticket_price+t3.ad_fy+t3.port_pay+t3.other_fee+t3.other_fy+t3.insurance_fee)*nvl(t3.r_com_rate,1))  ticketfee,
 sum(t1.money_fy)  money_fy,
 sum((t3.ticket_price+t3.ad_fy+t3.port_pay+t3.other_fee+t3.other_fy+t3.insurance_fee)*nvl(t3.r_com_rate,1))-sum(t1.money_fy)  退给旅客费用
 from dw.da_order_drawback t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  join cqsale.cq_order_head@to_air t3 on t1.flights_order_head_id=t3.flights_order_head_id
where t1.money_date>=to_date('2020-01-01','yyyy-mm-dd')
  and t1.money_date< trunc(sysdate)
  and t2.company_id=0
  group by trunc(t1.money_date))h1
   left join(select  tt1.order_day,count(1) ordernum,sum(tt1.ticket_price+tt1.ad_fy+tt1.port_pay+tt1.other_fy+tt1.insurce_fee+tt1.other_fee+tt1.sx_fy) ticketfee
              from dw.fact_order_detail tt1
              join dw.da_flight tt2 on tt1.segment_Head_id=tt2.segment_head_id
              where tt2.flag<>2
              and tt1.order_day>=to_date('2020-01-01','yyyy-mm-dd')
              and tt1.order_day< trunc(sysdate)
        and tt2.company_id=0
        group by  tt1.order_day)h2 on h1.moneyday=h2.order_day
left join(   
  select tt3.datetime,
sum(case when t1.seats_name is not null then 1 else 0 end) ticketnum,
sum((t3.ticket_price+t3.ad_fy+t3.port_pay+t3.other_fee+t3.other_fy+t3.insurance_fee)*nvl(t3.r_com_rate,1))  ticketfee,
 sum(t1.money_fy)  money_fy,
 sum((t3.ticket_price+t3.ad_fy+t3.port_pay+t3.other_fee+t3.other_fy+t3.insurance_fee)*nvl(t3.r_com_rate,1))-sum(t1.money_fy)  退给旅客费用
from dw.da_order_drawback t1
join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
join (select * from dw.adt_chunyun_corredate 
where chunyun_year = 2020 and corre_year = 2019)tt3 on trunc(t1.money_date)=tt3.corre_date
join cqsale.cq_order_head@to_air t3 on t1.flights_order_head_id=t3.flights_order_head_id
where t1.money_date>=to_date('2019-01-12','yyyy-mm-dd')
  and t1.money_date< trunc(sysdate)
  and tt3.datetime>=to_date('2020-01-01','yyyy-mm-dd')
  and tt3.datetime< trunc(sysdate)
  and t1.seats_name is not null
  group by tt3.datetime)h3 on h1.moneyday=h3.datetime;
		

 ----hdb.temp_feng_back_yesterday 更新后运行

select trunc(t1.money_date) 退票日期,
sum(case when t1.seats_name is not null then 1 else 0 end) 总退票量,
sum((t3.ticket_price+t3.ad_fy)*nvl(t3.r_com_rate,1)) 票面金额,
sum(case when t1.seats_name is  not null and t2.flights_segment_name like '%武汉%' then 1 else 0 end) 武汉退票量,
sum(case when t1.seats_name is  not null and t2.flights_segment_name like '%武汉%' then (t3.ticket_price+t3.ad_fy)*nvl(t3.r_com_rate,1) else 0 end) 武汉票面金额
 from hdb.temp_feng_back_yesterday t1
 join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
 left join cqsale.cq_order_head@to_air t3 on t1.flights_order_head_id=t3.flights_order_head_id
 where t1.seats_name is not null
 --and t4.flag<>2
 and t1.money_date>=trunc(sysdate)-1
 and t1.money_date< trunc(sysdate)
 and t2.company_id=0
 group by trunc(t1.money_date);

		

----dw.da_order_drawback 更新后运行

select trunc(t1.money_date) 退票日期,
sum(case when t1.seats_name is not null then 1 else 0 end) 总退票量,
sum((t3.ticket_price+t3.ad_fy)*nvl(t3.r_com_rate,1)) 票面金额,
sum(case when t1.seats_name is  not null and t2.flights_segment_name like '%武汉%' then 1 else 0 end) 武汉退票量,
sum(case when t1.seats_name is  not null and t2.flights_segment_name like '%武汉%' then (t3.ticket_price+t3.ad_fy)*nvl(t3.r_com_rate,1) else 0 end) 武汉票面金额
 from dw.da_order_drawback t1
 join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
 left join cqsale.cq_order_head@to_air t3 on t1.flights_order_head_id=t3.flights_order_head_id
 where t1.seats_name is not null
 --and t4.flag<>2
 and t1.money_date>=trunc(sysdate)-1
 and t1.money_date< trunc(sysdate)
 and t2.company_id=0
 group by trunc(t1.money_date);
 
 
 
 -----免费退损失
 
 select money_date 退票日期,sum(h4.ticketprice*nvl(h4.fee_rate,0)) 退票损失,
sum((h5.ticket_price+h5.ad_fy+h5.port_pay+h5.other_fy+h5.insurance_fee+h5.other_fee)*nvl(h5.r_com_rate,1)) 退票机票涉及机票金额
from(
select *
from(
select h1.*,h2.fee_rate
from(
select trunc(t1.money_date) money_date,t1.flights_order_head_id,
trunc(t1.origin_std) flightdate,case when t1.seattype='商务座' then '商务座'
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
  where t1.money_date>=to_date('2020-01-21','yyyy-mm-dd')
and t1.seats_name is not null)h1
left join dw.dim_tg_rule h2 on h2.seat_type=h1.seattype and h2.nationflag=h1.area_type and h2.priod_date=h1.priod_date and h1.seatname=h2.seats_name
)h3
)h4
left join cqsale.cq_order_head@to_air h5 on h4.flights_order_head_id=h5.flights_order_head_id
where h4.money_fy=0
group by money_date;
 
 

 
 
 

 
  
  
 
  
  
  
  
  
  
  
  
  