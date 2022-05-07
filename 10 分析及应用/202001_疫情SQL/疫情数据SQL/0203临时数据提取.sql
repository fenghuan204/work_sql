select '今年' lab,
               trunc(d.money_date) mday,
               t2.nationflag,
               t2.flights_segment_name,
               t3.channel,
               t3.sub_channel,
               case when trunc(t2.flight_date)-trunc(d.money_date)>45
               then '>45'
               when trunc(t2.flight_date)-trunc(d.money_date)< 0
               then '< 0'
               else to_char(trunc(t2.flight_date)-trunc(d.money_date))
               end   ahdays,
               count(1) tktnum
          from dw.da_order_drawback d
          join dw.da_flight t2 on t2.segment_head_id = d.segment_head_id
          left join dw.fact_recent_order_detail t3 on d.flights_order_head_id=t3.flights_order_head_id
         where d.money_date >= to_date('2020-01-22','yyyy-mm-dd')
           and d.money_date < trunc(sysdate)
           and t2.flag<>2
		   and t3.sub_channel ='携程'
		   and t2.flight_date< trunc(sysdate)
         group by  trunc(d.money_date) ,
               t2.nationflag,
               t2.flights_segment_name,
               case when trunc(t2.flight_date)-trunc(d.money_date)>45
               then '>45'
               when trunc(t2.flight_date)-trunc(d.money_date)< 0
               then '< 0'
               else to_char(trunc(t2.flight_date)-trunc(d.money_date))
               end,
                      t3.channel,
               t3.sub_channel;
			   
			
---------------------接送机短信发送


1、推送人群
1）订单中仅包括30-50岁的男性并且乘坐xxx-xxx的往返航班(商务) 
2）订单中包括12岁以下儿童或70岁以上老人并且乘坐xxx-xxx的往返航班(家庭出行，公共交通不方便) 
3）去程/返程在23-7点间并且乘坐xxx-xxx的往返航班(红眼，无公共交通)
2、推送航班日期：2月4日-2月23日，对应推送提前期：3天
3、xxx-xxx的往返航班
往返我们航线多个城市的乘客（上海浦东、上海虹桥、石家庄正定、合肥新桥、青岛流亭、重庆江北、武汉天河、杭州萧山、南京禄口、成都双流、济南遥墙、银川河东、南昌昌北、深圳宝安、沈阳桃仙、哈尔滨太平、兰州中川、乌鲁木齐地窝堡、太原武宿、昆明长水、郑州新郑、陕西咸阳、长沙黄花、宁波栎社、扬泰机场）
4、推送订票人还是乘机人
推送乘机人
5、短信推送限制条件：同一个往返，一个订座编码只推送一次
6、推送量



select flights_date,count(1)
from(
select distinct  t1.flights_date,getmobile(t1.r_tel)
 from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
 where t1.flights_date>=to_date('2020-02-04','yyyy-mm-dd')
 and t1.flights_date<= to_date('2020-02-23','yyyy-mm-dd')
 and t1.company_id=0
 and t2.flag<>2
 and t1.seats_name is not null
 and t2.destairport_name  in('浦东','虹桥','石家庄','合肥','青岛','重庆','武汉','杭州','南京','成都','济南','银川','南昌','深圳','沈阳','哈尔滨','兰州','乌鲁木齐','太原','昆明','郑州','西安','长沙','宁波','扬州泰州')
 and t1.flights_order_head_id=t1.wf_lc_father_id
 and not exists(select  1
                        from dw.fact_order_detail h1
            join dw.bi_order_region h2 on h1.flights_order_head_id=h2.flights_order_head_id
            where h1.flights_date>=to_date('2020-02-04','yyyy-mm-dd')
 and h1.flights_date<= to_date('2020-02-23','yyyy-mm-dd')
 and h1.company_id=0
 and h1.flights_order_id=t1.flights_order_id
 and (h2.AGE<30 or h2.age>50))
 and getmobile(t1.r_tel)<>'-'
 
 
 union 
 
 select distinct  t1.flights_date,getmobile(t1.r_tel)
 from dw.fact_order_detail t1
 join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
 where t1.flights_date>=to_date('2020-02-04','yyyy-mm-dd')
 and t1.flights_date<= to_date('2020-02-23','yyyy-mm-dd')
 and t2.flag<>2
 and t1.company_id=0
 and t1.seats_name is not null
 and  t2.destairport_name  in('浦东','虹桥','石家庄','合肥','青岛','重庆','武汉','杭州','南京','成都','济南','银川','南昌','深圳','沈阳','哈尔滨','兰州','乌鲁木齐','太原','昆明','郑州','西安','长沙','宁波','扬州泰州')
 and t1.flights_order_head_id=t1.wf_lc_father_id
 and  exists(select  1
                        from dw.fact_order_detail h1
            join dw.bi_order_region h2 on h1.flights_order_head_id=h2.flights_order_head_id
            where h1.flights_date>=to_date('2020-02-04','yyyy-mm-dd')
 and h1.flights_date<= to_date('2020-02-23','yyyy-mm-dd')
 and h1.company_id=0
 and h1.flights_order_id=t1.flights_order_id
 and (h2.AGE<=12 or h2.age>=70))
 and getmobile(t1.r_tel)<>'-'
 
  union 
 
 select distinct  t1.flights_date,getmobile(t1.r_tel)
 from dw.fact_order_detail t1
 join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
 where t1.flights_date>=to_date('2020-02-04','yyyy-mm-dd')
 and t1.flights_date<= to_date('2020-02-23','yyyy-mm-dd')
 and t2.flag<>2
 and t1.company_id=0
 and t1.seats_name is not null
 and t2.destairport_name  in('浦东','虹桥','石家庄','合肥','青岛','重庆','武汉','杭州','南京','成都','济南','银川','南昌','深圳','沈阳','哈尔滨','兰州','乌鲁木齐','太原','昆明','郑州','西安','长沙','宁波','扬州泰州')
 and t1.flights_order_head_id=t1.wf_lc_father_id
 and getmobile(t1.r_tel)<>'-'
 and ((to_char(t2.origin_std,'hh24')>='00' and to_char(t2.origin_std,'hh24')<'07')
 or (to_char(t2.origin_std,'hh24')>='23' and to_char(t2.origin_std,'hh24')<='24'))
 )
 group by flights_date;
 
 
 
  select /*+parallel(4) */
t1.r_flights_date,t2.originairport,t2.area_type,count(1),count(distinct t2.segment_head_id)
  from cqsale.cq_order_head@to_air t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  where t2.flag<>2
  and t1.r_flights_date>=to_date('2020-01-29','yyyy-mm-dd')
  and t1.r_flights_date< to_date('2020-02-11','yyyy-mm-dd')
 and t1.seats_name is not null
  and t1.whole_flight like '9C%'
  and t1.flag_id in(3,5,40,41)
  and t2.originairport in('SHA','PVG')
  group by t1.r_flights_date,t2.originairport,t2.area_type;
  
  
  
  
  
  
  
  select /*+parallel(4) */
 distinct  t1.flights_date,getmobile(t1.r_tel)
 from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
 where t1.flights_date>=to_date('2020-02-04','yyyy-mm-dd')
 and t1.flights_date<= to_date('2020-02-23','yyyy-mm-dd')
 and t1.company_id=0
 and t2.flag<>2
 and t1.seats_name is not null
 and t2.destairport_name  in('浦东','虹桥','石家庄','合肥','青岛','重庆','武汉','杭州','南京','成都','济南','银川','南昌','深圳','沈阳','哈尔滨','兰州','乌鲁木齐','太原','昆明','郑州','西安','长沙','宁波','扬州泰州')
 and t1.flights_order_head_id=t1.wf_lc_father_id
 and not exists(select  1
                        from dw.fact_order_detail h1
            join dw.bi_order_region h2 on h1.flights_order_head_id=h2.flights_order_head_id
            where h1.flights_date>=to_date('2020-02-04','yyyy-mm-dd')
 and h1.flights_date<= to_date('2020-02-23','yyyy-mm-dd')
 and h1.company_id=0
 and h1.flights_order_id=t1.flights_order_id
 and (h2.AGE<30 or h2.age>50))
 and getmobile(t1.r_tel)<>'-'
 
 
 union 
 
 select distinct  t1.flights_date,getmobile(t1.r_tel)
 from dw.fact_order_detail t1
 join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
 where t1.flights_date>=to_date('2020-02-04','yyyy-mm-dd')
 and t1.flights_date<= to_date('2020-02-23','yyyy-mm-dd')
 and t2.flag<>2
 and t1.company_id=0
 and t1.seats_name is not null
 and  t2.destairport_name  in('浦东','虹桥','石家庄','合肥','青岛','重庆','武汉','杭州','南京','成都','济南','银川','南昌','深圳','沈阳','哈尔滨','兰州','乌鲁木齐','太原','昆明','郑州','西安','长沙','宁波','扬州泰州')
 and t1.flights_order_head_id=t1.wf_lc_father_id
 and  exists(select  1
                        from dw.fact_order_detail h1
            join dw.bi_order_region h2 on h1.flights_order_head_id=h2.flights_order_head_id
            where h1.flights_date>=to_date('2020-02-04','yyyy-mm-dd')
 and h1.flights_date<= to_date('2020-02-23','yyyy-mm-dd')
 and h1.company_id=0
 and h1.flights_order_id=t1.flights_order_id
 and (h2.AGE<=12 or h2.age>=70))
 and getmobile(t1.r_tel)<>'-'
 
  union 
 
 select distinct  t1.flights_date,getmobile(t1.r_tel)
 from dw.fact_order_detail t1
 join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
 where t1.flights_date>=to_date('2020-02-04','yyyy-mm-dd')
 and t1.flights_date<= to_date('2020-02-23','yyyy-mm-dd')
 and t2.flag<>2
 and t1.company_id=0
 and t1.seats_name is not null
 and t2.destairport_name  in('浦东','虹桥','石家庄','合肥','青岛','重庆','武汉','杭州','南京','成都','济南','银川','南昌','深圳','沈阳','哈尔滨','兰州','乌鲁木齐','太原','昆明','郑州','西安','长沙','宁波','扬州泰州')
 and t1.flights_order_head_id=t1.wf_lc_father_id
 and getmobile(t1.r_tel)<>'-'
 and ((to_char(t2.origin_std,'hh24')>='00' and to_char(t2.origin_std,'hh24')<'07')
 or (to_char(t2.origin_std,'hh24')>='23' and to_char(t2.origin_std,'hh24')<='24'));
 
 
 
 
 ----------携程未乘机数据
 
 
 select t3.flights_date,t2.area_type,t2.flights_segment_name,count(1)
from  dw.fact_recent_order_detail t3
join dw.da_flight t2  on t2.segment_head_id=t3.segment_head_id
         where t2.flag<>2
       and t2.flight_date>=to_date('2020-01-20','yyyy-mm-dd')
       and t3.sub_channel ='携程'
       and t2.flight_date< trunc(sysdate)
       and t3.flag_id in(3,5)
       group by t3.flights_date,t2.area_type,t2.flights_segment_name;
	   
	   
-----航班日期	 
	 
select  t1.segment_head_id, t1.flights_date,t1.whole_flight,t2.flights_segment_name,t3.wf_segment_name,t2.nationflag,
t2.segment_type,t2.oversale,
case when t1.seats_name in('B','G','G1','G2') then 'BG'
else '非BG' end bgtype,
count(1) ticketnum,
sum(case when t1.order_day< to_date('2020-01-28','yyyy-mm-dd') then 1 else 0 end) "28号之前销售"
from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  left join dw.dim_segment_type t3 on t2.route_id=t3.route_id and t2.h_route_id=t3.h_route_id
  where t1.flights_date>=to_date('2020-01-23','yyyy-mm-dd')
      and t1.flights_date<= to_date('2020-02-29','yyyy-mm-dd')
    and t1.seats_name is not null
    and t1.company_id=0
    and t2.flag<>2
    group by t1.segment_head_id, t1.flights_date,t1.whole_flight,t2.flights_segment_name,t3.wf_segment_name,t2.nationflag,
t2.segment_type,t2.oversale ,case when t1.seats_name in('B','G','G1','G2') then 'BG'
else '非BG' end;





===============执行率、客座率


select h1.flight_date 航班日期,h1.航班量,h1.执行率,h2.客座率
from(
select t1.flight_date,count(1) 航班量,sum(case when t2.flag=2 then 1 else 0 end) 取消量 ,1-sum(case when t2.flag=2 then 1 else 0 end)/count(1)  执行率
  from hdb.temp_feng_da_flight t1
  left join cqsale.cq_flights_segment_head@to_air t2 on t1.segment_head_id=t2.segment_head_id
  where t1.flight_date>=to_date('2020-02-03','yyyy-mm-dd')
    and t1.flight_date< to_date('2020-04-01','yyyy-mm-dd')
    and t1.company_id=0
    group by t1.flight_date)h1
    
  left join (
  select h1.flight_date,sum(h1.checkin_mile)/sum(h1.checkin_s_mile) 客座率
     from dw.bi_tbl_plf h1
     where h1.flight_date>=to_date('2020-02-03','yyyy-mm-dd')
    and h1.flight_date< to_date('2020-04-01','yyyy-mm-dd')
    and h1.checkin_mile>0
    and h1.checkin_s_mile>0
    group by h1.flight_date)h2 on h1.flight_date=h2.flight_date;
	
	
	
	
	
	  select trunc(t1.money_date),count(1),sum(t1.money_fy)
 from dw.da_order_drawback t1
 where t1.money_date>=to_date('2020-01-20','yyyy-mm-dd')
   and t1.money_date< to_date('2020-01-28','yyyy-mm-dd')
   and t1.seats_name is not null
   and t1.origin_std> t1.money_date
   and t1.origin_std>=to_date('2020-01-20','yyyy-mm-dd')
   group by trunc(t1.money_date);
   
   
   
   -------------退票损失
   
   
    select /*+parallel(4) */
 money_date 退票日期,count(1),sum(h4.ticketprice*nvl(h4.fee_rate,0)) 退票损失,
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
    
 
  
 

 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 