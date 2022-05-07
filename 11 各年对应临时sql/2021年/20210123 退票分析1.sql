select case when trunc(t1.money_date)<=to_date('2020-12-21','yyyy-mm-dd') then '12月21日之前'
            when trunc(t1.money_date)>=to_date('2020-12-22','yyyy-mm-dd')  
            and trunc(t1.money_date)<=to_date('2021-01-03','yyyy-mm-dd') then '1222~0103'
            when trunc(t1.money_date)>=to_date('2021-01-04','yyyy-mm-dd')  
            and trunc(t1.money_date)<=to_date('2021-01-20','yyyy-mm-dd') then '0104~0120'
            when trunc(t1.money_date)>=to_date('2021-01-21','yyyy-mm-dd')  
            and trunc(t1.money_date)<=to_date('2021-01-21','yyyy-mm-dd') then '0121' end,

decode(t7.gender,0,'-',1,'男',2,'女') 性别,
case when t7.age>=0 and t7.age< 12 then '[00,12)' 
when t7.age< 18 then '[12,18)' 
when t7.age< 24 then '[18,24)'
when t7.age< 30 then '[24,30)'  
when t7.age< 40 then '[30,40)' 
when t7.age< 50 then '[40,50)'  
when t7.age< 60 then '[50,60)' 
when t7.age>=60 then '60+' end , 
t8.part,         
 
case when t2.flag in(1,2) then '取消航班'
when t2.flag=0 then '正常航班' end 航班类型,
case when t1.seats_name in('B','G','G1','G2','O') then 'BGO'
else '非BGO' end 舱位类型,
case when t3.flights_order_id is not null then '套票'
when t1.money_fy = 0 then '0元退票'
when t1.money_fy > 0 then '正常退票' end 退票类型,
case when t1.origin_std-t1.money_date < =0 then '离站后'
when t1.origin_std-t1.money_date <=0.5 then '（0,12H]'
when t1.origin_std-t1.money_date <=1 then '（12,24H]'
when t1.origin_std-t1.money_date <=3 then '（1,3D]'
when t1.origin_std-t1.money_date <=7 then '（3,7D]'
when t1.origin_std-t1.money_date <=15 then '（7,15D]'
when t1.origin_std-t1.money_date <=30 then '（15,30D]'
when t1.origin_std-t1.money_date <=60 then '（30,60D]'
when t1.origin_std-t1.money_date > 60 then '60+' end 退票提前期分布,
sum(case when t2.flights_city_name like '%上海%' then 1 else 0 end) shanum,
sum(case when t2.flights_city_name like '%石家庄%' then 1 else 0 end) swjnum,
sum(case when t2.flights_city_name like '%沈阳%' then 1 else 0 end) shenum,
sum(case when t2.flights_city_name like '%揭阳%' then 1 else 0 end) swanum,
sum(case when t2.flights_city_name like '%扬州%' then 1 else 0 end) ytynum,
sum(case when t2.flights_city_name like '%深圳%' then 1 else 0 end) szxnum,
sum(case when t2.flights_city_name like '%兰州%' then 1 else 0 end) lhwnum,
sum(case when t2.flights_city_name like '%宁波%' then 1 else 0 end) ngonum,
count(1) 退票量,
sum(t1.money_fy) 退票金额
  from dw.da_order_drawback t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  left join dw.fact_combo_ticket t3 on t1.flights_order_head_Id=t3.flights_order_head_Id
  left join dw.dim_segment_type t6 on t2.h_route_id=t6.h_route_id and t2.route_id=t6.route_id
  left join dw.bi_order_region t7 on t1.flights_order_head_id=t7.flights_order_head_id
  left join dw.fact_orderhead_trippurpose@to_ods t8 on t1.flights_order_head_id=t8.flights_order_head_id
  where t1.money_date>=to_date('2020-12-01','yyyy-mm-dd')
    and t1.money_date< to_date('2021-01-22','yyyy-mm-dd')
    and t1.seats_name is not null
    group by case when trunc(t1.money_date)<=to_date('2020-12-21','yyyy-mm-dd') then '12月21日之前'
            when trunc(t1.money_date)>=to_date('2020-12-22','yyyy-mm-dd')  
            and trunc(t1.money_date)<=to_date('2021-01-03','yyyy-mm-dd') then '1222~0103'
            when trunc(t1.money_date)>=to_date('2021-01-04','yyyy-mm-dd')  
            and trunc(t1.money_date)<=to_date('2021-01-20','yyyy-mm-dd') then '0104~0120'
            when trunc(t1.money_date)>=to_date('2021-01-21','yyyy-mm-dd')  
            and trunc(t1.money_date)<=to_date('2021-01-21','yyyy-mm-dd') then '0121' end,

decode(t7.gender,0,'-',1,'男',2,'女') ,
case when t7.age>=0 and t7.age< 12 then '[00,12)' 
when t7.age< 18 then '[12,18)' 
when t7.age< 24 then '[18,24)'
when t7.age< 30 then '[24,30)'  
when t7.age< 40 then '[30,40)' 
when t7.age< 50 then '[40,50)'  
when t7.age< 60 then '[50,60)' 
when t7.age>=60 then '60+' end , 
t8.part,  
case when t2.flag in(1,2) then '取消航班'
when t2.flag=0 then '正常航班' end ,
case when t1.seats_name in('B','G','G1','G2','O') then 'BGO'
else '非BGO' end ,
case when t3.flights_order_id is not null then '套票'
when t1.money_fy = 0 then '0元退票'
when t1.money_fy > 0 then '正常退票' end ,
case when t1.origin_std-t1.money_date < =0 then '离站后'
when t1.origin_std-t1.money_date <=0.5 then '（0,12H]'
when t1.origin_std-t1.money_date <=1 then '（12,24H]'
when t1.origin_std-t1.money_date <=3 then '（1,3D]'
when t1.origin_std-t1.money_date <=7 then '（3,7D]'
when t1.origin_std-t1.money_date <=15 then '（7,15D]'
when t1.origin_std-t1.money_date <=30 then '（15,30D]'
when t1.origin_std-t1.money_date <=60 then '（30,60D]'
when t1.origin_std-t1.money_date > 60 then '60+' end;


----正常购票用户年龄分布

select case when trunc(t1.order_day)<=to_date('2020-12-21','yyyy-mm-dd') then '12月21日之前'
            when trunc(t1.order_day)>=to_date('2020-12-22','yyyy-mm-dd')  
            and trunc(t1.order_day)<=to_date('2021-01-03','yyyy-mm-dd') then '1222~0103'
            when trunc(t1.order_day)>=to_date('2021-01-04','yyyy-mm-dd')  
            and trunc(t1.order_day)<=to_date('2021-01-20','yyyy-mm-dd') then '0104~0120'
            when trunc(t1.order_day)>=to_date('2021-01-21','yyyy-mm-dd')  
            and trunc(t1.order_day)<=to_date('2021-01-21','yyyy-mm-dd') then '0121' end,

decode(t7.gender,0,'-',1,'男',2,'女') 性别,
case when t7.age>=0 and t7.age< 12 then '[00,12)' 
when t7.age< 18 then '[12,18)' 
when t7.age< 24 then '[18,24)'
when t7.age< 30 then '[24,30)'  
when t7.age< 40 then '[30,40)' 
when t7.age< 50 then '[40,50)'  
when t7.age< 60 then '[50,60)' 
when t7.age>=60 then '60+' end , 
t8.part,         
 

count(1) 退票量
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  left join dw.bi_order_region t7 on t1.flights_order_head_id=t7.flights_order_head_id
  left join dw.fact_orderhead_trippurpose@to_ods t8 on t1.flights_order_head_id=t8.flights_order_head_id
  where t1.order_day>=to_date('2020-12-01','yyyy-mm-dd')
    and t1.order_day< to_date('2021-01-22','yyyy-mm-dd')
    and t1.seats_name is not null
    and t1.company_id=0
    group by case when trunc(t1.order_day)<=to_date('2020-12-21','yyyy-mm-dd') then '12月21日之前'
            when trunc(t1.order_day)>=to_date('2020-12-22','yyyy-mm-dd')  
            and trunc(t1.order_day)<=to_date('2021-01-03','yyyy-mm-dd') then '1222~0103'
            when trunc(t1.order_day)>=to_date('2021-01-04','yyyy-mm-dd')  
            and trunc(t1.order_day)<=to_date('2021-01-20','yyyy-mm-dd') then '0104~0120'
            when trunc(t1.order_day)>=to_date('2021-01-21','yyyy-mm-dd')  
            and trunc(t1.order_day)<=to_date('2021-01-21','yyyy-mm-dd') then '0121' end,

decode(t7.gender,0,'-',1,'男',2,'女') ,
case when t7.age>=0 and t7.age< 12 then '[00,12)' 
when t7.age< 18 then '[12,18)' 
when t7.age< 24 then '[18,24)'
when t7.age< 30 then '[24,30)'  
when t7.age< 40 then '[30,40)' 
when t7.age< 50 then '[40,50)'  
when t7.age< 60 then '[50,60)' 
when t7.age>=60 then '60+' end , 
t8.part;



---航班日期、航线、退票占比、已售/已退、重购数据

select h1.flight_date,replace(replace(h3.wf_segment,'浦东','上海'),'虹桥','上海') wf_city,
sum(h1.oversale),sum(h1.bgo_plan-h1.o_plan),sum(h2.swnum),sum(h2.plannum),
sum(h2.tuinum),sum(h2.zgnum)
from dw.da_flight h1
left join 
(
select t1.flights_date,t1.segment_head_id,t2.oversale,t2.bgo_plan-t2.o_plan bgplan,
replace(replace(t5.wf_segment,'浦东','上海'),'虹桥','上海') wf_city,
       sum(case when t1.seats_name not in('B','G','G2','G1') then 1 else 0 end) swnum,
       sum(case when t1.seats_name  in('B','G','G2','G1') then 1 else 0 end) plannum,
       count(distinct t3.flights_order_head_id) tuinum,
       count(distinct t4.flights_order_head_id) zgnum       
 from dw.fact_recent_order_detail t1
 join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
 left join dw.da_order_drawback t3 on t1.flights_order_head_id=t3.flights_order_head_id
 left join dw.dim_segment_type t5 on t2.h_route_id=t5.h_route_id and t2.route_id=t5.route_id
 left join (SELECT t1.flights_order_head_id,count(1)
  from dw.fact_order_detail t1,
   dw.da_order_drawback t2,
   dw.da_flight t3
   where t1.codeno=t2.codeno
   and t1.traveller_name=t2.sname
   and t2.segment_head_id=t3.segment_head_id
   and t1.whole_segment=t3.segment_code
   and t1.order_date>=t2.money_date
   and t1.flights_date>=trunc(t2.origin_std)-7
   and t1.flights_date<=trunc(t2.origin_std)+7
   and t1.flights_date>=to_date('2020-12-01','yyyy-mm-dd')
   and t1.flights_date< to_date('2021-03-09','yyyy-mm-dd')
   group by t1.flights_order_head_id)t4 on t1.flights_order_head_id=t4.flights_order_head_id
where t1.flights_date>=to_date('2020-12-01','yyyy-mm-dd')
  and t1.flights_date< to_date('2021-03-09','yyyy-mm-dd')
  and t1.seats_name is not null 
  group by t1.flights_date,t1.segment_head_id,t2.oversale,t2.bgo_plan-t2.o_plan ,
replace(replace(t5.wf_segment,'浦东','上海'),'虹桥','上海'))h2 on h1.segment_head_id=h2.segment_head_id
 left join dw.dim_segment_type h3 on h1.h_route_id=h3.h_route_id and h1.route_id=h3.route_id
 where  h1.flight_date>=to_date('2020-12-01','yyyy-mm-dd')
  and h1.flight_date< to_date('2021-03-09','yyyy-mm-dd')
  and h1.flag=0
  and h1.company_id=0
group by h1.flight_date,replace(replace(h3.wf_segment,'浦东','上海'),'虹桥','上海');

