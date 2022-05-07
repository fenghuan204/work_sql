select tb2.flights_id 航班id,tb3.flight_date 航班日期,tb3.flight_no 航班号,tb3.route_name 航线,tb4.wf_segment_name 往返航线,
tb3.oversale 计划量,
tb2.minmoney 当前在售最低价,nvl(tb5.vari_cost,tb6.vari_cost) 每班变动成本,nvl(tb5.vari_cost,tb6.vari_cost)/(tb3.oversale*0.85) "85%客座率的含油均价",
case when nvl(tb5.vari_cost,tb6.vari_cost)/(tb3.oversale*0.85)> tb2.minmoney then '是'
when nvl(tb5.vari_cost,tb6.vari_cost)/(tb3.oversale*0.85)<= tb2.minmoney then '否' end 最低价是否小于测算定价,
to_char(tb3.flight_date,'mm') 月份,
to_char(tb3.flight_date-1,'d') 星期,
tb4.income_type 收益类型,
tb8.country_name 航线国家,
case when tb3.dest_country_id>0 then '出港'
when tb3.dest_country_id<=0 then '进港' end 进出港类型,
tb4.segment_code 航段三字码,
tb7.ticketnum 当前销售机票量,
tb7.ticketnum/tb3.oversale 当前销售进度,
tb7.ticketprice 当前航班含油收入,
tb7.ticketprice/tb7.ticketnum 当前平均含油票价,
(nvl(tb5.vari_cost,tb6.vari_cost)-tb7.ticketprice)/(tb3.oversale*0.85-tb7.ticketnum)  "85%客座未售计划定价"
from(
select  tb1.flights_id,tb1.h_route_id,min(tb1.money) minmoney
from(
select h1.segment_head_id,
       h3.flights_id,
       h3.h_route_id,
       h3.fy,
       h1.seats_name ,
       h1.money ticketprice,
       h1.money+h3.fy money,
       h2.remnant ,
       trunc(h3.origin_std) 起飞时间,
       h3.flights_segment 航段,
       h3.r_flights_no 航班号,
       h4.flights_segment_name 中文航段
  from (select *
          from (select segment_head_id,
                       MONEY_E,
MONEY_H,
MONEY_I,
MONEY_K,
MONEY_L,
MONEY_M,
MONEY_N,
MONEY_P,
MONEY_P1,
MONEY_P2,
MONEY_P3,
MONEY_P4,
MONEY_P5,
MONEY_Q,
MONEY_R1,
MONEY_R2,
MONEY_R3,
MONEY_R4,
MONEY_S,
MONEY_T,
MONEY_U,
MONEY_V,
MONEY_X,
MONEY_Y                       
from cqsale.cq_flights_segment_head@to_air) unpivot(money for seats_name in (MONEY_E as 'E',
MONEY_H as 'H',
MONEY_I as 'I',
MONEY_K as 'K',
MONEY_L as 'L',
MONEY_M as 'M',
MONEY_N as 'N',
MONEY_P as 'P',
MONEY_P1 as 'P1',
MONEY_P2 as 'P2',
MONEY_P3 as 'P3',
MONEY_P4 as 'P4',
MONEY_P5 as 'P5',
MONEY_Q as 'Q',
MONEY_R1 as 'R1',
MONEY_R2 as 'R2',
MONEY_R3 as 'R3',
MONEY_R4 as 'R4',
MONEY_S as 'S',
MONEY_T as 'T',
MONEY_U as 'U',
MONEY_V as 'V',
MONEY_X as 'X',
MONEY_Y as 'Y'
))
                  ) h1
  join (select *
          from (select segment_head_id,
                       REMNANT_E,
REMNANT_H,
REMNANT_I,
REMNANT_K,
REMNANT_L,
REMNANT_M,
REMNANT_N,
REMNANT_P,
REMNANT_P1,
REMNANT_P2,
REMNANT_P3,
REMNANT_P4,
REMNANT_P5,
REMNANT_Q,
REMNANT_R1,
REMNANT_R2,
REMNANT_R3,
REMNANT_R4,
REMNANT_S,
REMNANT_T,
REMNANT_U,
REMNANT_V,
REMNANT_X,
REMNANT_Y
from cqsale.cq_flights_seats_amount@to_air) unpivot(remnant for seats_name in (REMNANT_E AS 'E',
REMNANT_H AS 'H',
REMNANT_I AS 'I',
REMNANT_K AS 'K',
REMNANT_L AS 'L',
REMNANT_M AS 'M',
REMNANT_N AS 'N',
REMNANT_P AS 'P',
REMNANT_P1 AS 'P1',
REMNANT_P2 AS 'P2',
REMNANT_P3 AS 'P3',
REMNANT_P4 AS 'P4',
REMNANT_P5 AS 'P5',
REMNANT_Q AS 'Q',
REMNANT_R1 AS 'R1',
REMNANT_R2 AS 'R2',
REMNANT_R3 AS 'R3',
REMNANT_R4 AS 'R4',
REMNANT_S AS 'S',
REMNANT_T AS 'T',
REMNANT_U AS 'U',
REMNANT_V AS 'V',
REMNANT_X AS 'X',
REMNANT_Y AS 'Y'))) h2 on h1.segment_head_id =  h2.segment_head_id    and h1.seats_name = h2.seats_name
  join cqsale.cq_flights_segment_head@to_air h3 on h1.segment_head_id =  h3.segment_head_id
  join cqsale.cq_flights_seats_amount@to_air h5 on h1.segment_head_id=h5.segment_head_id
  left join dw.da_flight h4 on h1.segment_head_id = h4.segment_head_id
 where h3.origin_std >= sysdate
   and h2.remnant > 0
   and h3.flag <> 2
   and h1.money>0
   and h3.r_flights_no like '9C%'
   and h1.seats_name not in('P2','P5','O','A','D','Z','I','J')
   )tb1
   group by tb1.flights_id,tb1.h_route_id
   )tb2 
   left join 
   (select
   flights_id,h_route_id,route_name,flight_no,flight_date,sum(oversale) oversale,
   max(dest_country_id) dest_country_id,max(greatest(origin_country_id,dest_country_id)) country_id
   from dw.da_flight
   where flight_date>=trunc(sysdate)
   and flag<>2
   and root_nation_flag<>1
   group by flights_id,h_route_id,route_name,flight_date,flight_no)tb3 on tb2.flights_id=tb3.flights_id
   left join (select distinct  h_route_id,wf_segment_name,income_type,segment_code
   from dw.dim_segment_type
   where h_route_id=route_id
  )tb4 on tb3.h_route_id=tb4.h_route_id  
  left join(select 
   replace(
   replace(
   replace(
   replace(replace(replace(route_name,'扬州','扬州泰州'),'素叻他尼','素叻他尼(万伦)'),'济州','济州岛')
   ,'普吉岛','普吉'),'东京羽田','东京'),'东京成田','成田') route_name,
   
   avg(t1.trans_cost-t1.gdcost_money) vari_cost
from hdb.recent_flights_cost t1
where t1.flight_date>=trunc(sysdate-30)
and t1.flight_date< trunc(sysdate)
and t1.total_cost>0
group by replace(
   replace(
   replace(
   replace(replace(replace(route_name,'扬州','扬州泰州'),'素叻他尼','素叻他尼(万伦)'),'济州','济州岛')
   ,'普吉岛','普吉'),'东京羽田','东京'),'东京成田','成田'))tb5 on tb3.route_name=tb5.route_Name
   
   left join(select 
   replace(
   replace(
   replace(
   replace(replace(replace(route_name,'扬州','扬州泰州'),'素叻他尼','素叻他尼(万伦)'),'济州','济州岛')
   ,'普吉岛','普吉'),'东京羽田','东京'),'东京成田','成田') route_name,
   
   avg(t1.trans_cost-t1.gdcost_money) vari_cost
from hdb.recent_flights_cost t1
where t1.flight_date>=trunc(sysdate-180)
and t1.flight_date< trunc(sysdate)
and t1.total_cost>0
group by replace(
   replace(
   replace(
   replace(replace(replace(route_name,'扬州','扬州泰州'),'素叻他尼','素叻他尼(万伦)'),'济州','济州岛')
   ,'普吉岛','普吉'),'东京羽田','东京'),'东京成田','成田'))tb6 on tb3.route_name=tb6.route_Name   
   
  left join (select tt2.flights_id,max(greatest(tt2.origin_country_id,tt2.dest_country_id)) country_id,
sum(case when tt1.seats_name is not null then 1 else 0 end) ticketnum,
                  sum((tt1.ticket_price+tt1.ad_fy)*nvl(tt1.r_com_rate,1)) ticketprice                  
              from cqsale.cq_order_head@to_air tt1
              join dw.da_flight tt2 on tt1.segment_head_id=tt2.segment_head_id
              where tt1.r_flights_date>=trunc(sysdate)
              and tt1.r_flights_date< to_date('2020-04-01','yyyy-mm-dd')
              and tt2.flag<>2
              and tt1.flag_id in(3,5,40,41)
              and tt1.whole_flight like '9C%'
              group by tt2.flights_id)tb7 on tb2.flights_id=tb7.flights_id
left join stg.s_cq_country_area tb8 on tb3.country_id=tb8.id  
   
where tb3.flight_date>=trunc(sysdate)
and tb3.flight_date< to_date('2020-04-01','yyyy-mm-dd')
