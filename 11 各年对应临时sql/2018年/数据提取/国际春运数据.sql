#2019年春运数据

select '2019年' 年,to_char(h1.flight_date,'mmdd') 航班日期,h1.segment_code 航段,h1.flight_no 航班号,h3.income_type 收益类型,
h1.oversale 计划总数,h1.bgo_plan-h1.o_plan BG计划数,h1.oversale-h1.bgo_plan+h1.o_plan 散客计划数,
nvl(h2.swnum,0) 散客已销售数,nvl(h2.swprice,0) 散客票价和,nvl(h2.adfy,0) 散客燃油费,nvl(h2.otherfy,0) 散客其他税费
from dw.da_flight h1
left join (
select t1.segment_head_id,sum(case when t1.seats_name not in('B','G','G1','G2') then 1 else 0 end) swnum ,
    sum(case when t1.seats_name not in('B','G','G1','G2') then t1.ticket_price else 0 end) swprice,
    sum(case when t1.seats_name not in('B','G','G1','G2') then t1.ad_fy else 0 end) adfy,
    sum(case when t1.seats_name not in('B','G','G1','G2') then t1.other_fy else 0 end) otherfy            
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  where t1.flights_date>=to_date('2019-01-09','yyyy-mm-dd')
    and t1.flights_date<=to_date('2019-03-14','yyyy-mm-dd')
    and t2.flag<>2
    and t2.nationflag in('区域','国际')
    and t1.order_day< trunc(sysdate)
    and t1.whole_flight like '9C%'
    group by t1.segment_head_id)h2 on h1.segment_head_id=h2.segment_head_id
    left join dw.dim_segment_type h3 on h1.route_id=h3.route_id and h1.h_route_id=h3.h_route_id
    where h1.flight_date>=to_date('2019-01-09','yyyy-mm-dd')
    and h1.flight_date<=to_date('2019-03-14','yyyy-mm-dd')
    and h1.flag<>2
    and h1.nationflag in('区域','国际')
    and h1.company_id=0
    
    
    
   union all   
   
select '2018年',to_char(t3.spring_date,'mmdd'),t2.segment_code,t2.flight_no,t4.income_type,
t2.oversale,t2.bgo_plan-t2.o_plan bgplan,t2.oversale-t2.bgo_plan+t2.o_plan swplan,
sum(case when t1.seats_name not in('B','G','G1','G2') then 1 else 0 end) swnum ,
    sum(case when t1.seats_name not in('B','G','G1','G2') then t1.ticket_price else 0 end) swprice,
    sum(case when t1.seats_name not in('B','G','G1','G2') then t1.ad_fy else 0 end) adfy,
    sum(case when t1.seats_name not in('B','G','G1','G2') then t1.other_fy else 0 end) otherfy            
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  join hdb.dim_19nation_spring t3 on t2.flight_date=t3.corre_date
  left join dw.dim_segment_type t4 on t2.route_id=t4.route_id and t2.h_route_id=t4.h_route_id
  where t1.flights_date>=to_date('2018-01-10','yyyy-mm-dd')
    and t1.flights_date<=to_date('2018-03-22','yyyy-mm-dd')    
    and t2.flag<>2
    and t2.nationflag in('区域','国际')
    and t1.order_day< add_months(trunc(sysdate),-12)+t3.corre_number
    and t1.whole_flight like '9C%'
    group by to_char(t3.spring_date,'mmdd'),t2.segment_code,t2.flight_no,t4.income_type,
t2.oversale,t2.bgo_plan-t2.o_plan ,t2.oversale-t2.bgo_plan+t2.o_plan;













#2018年春运数据
select '2018年' 年,trunc(sysdate)-1  截止订单日期,h1.flight_date 航班日期,h1.segment_code 航段,h1.flight_no 航班号,
h1.oversale 计划总数,h1.bgo_plan-h1.o_plan BG计划数,h1.oversale-h1.bgo_plan+h1.o_plan 散客计划数,
nvl(h2.swnum,0) 散客已销售数,nvl(h2.swprice,0) 散客票价和,nvl(h2.adfy,0) 散客燃油费,nvl(h2.otherfy,0) 散客其他税费
from dw.da_flight h1
left join (
select t1.segment_head_id,sum(case when t1.seats_name not in('B','G','G1','G2') then 1 else 0 end) swnum ,
    sum(case when t1.seats_name not in('B','G','G1','G2') then t1.ticket_price else 0 end) swprice,
    sum(case when t1.seats_name not in('B','G','G1','G2') then t1.ad_fy else 0 end) adfy,
    sum(case when t1.seats_name not in('B','G','G1','G2') then t1.other_fy else 0 end) otherfy            
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  where t1.flights_date>=to_date('2018-01-20','yyyy-mm-dd')
    and t1.flights_date<=to_date('2018-03-11','yyyy-mm-dd')
    and t2.flag<>2
    and t2.nationflag in('区域','国际')
    and t1.order_day< trunc(sysdate)
    and t1.whole_flight like '9C%'
    group by t1.segment_head_id)h2 on h1.segment_head_id=h2.segment_head_id
    where h1.flight_date>=to_date('2018-01-20','yyyy-mm-dd')
    and h1.flight_date<=to_date('2018-03-11','yyyy-mm-dd')
    and h1.flag<>2
    and h1.nationflag in('区域','国际')
    and h1.company_id=0
    
    
    
   union all
   
   
   select '2017年',add_months(trunc(sysdate),-12)-19-1  截止订单日期,h1.flight_date 航班日期,h1.segment_code 航段,h1.flight_no 航班号,
h1.oversale 计划总数,h1.bgo_plan-h1.o_plan BG计划数,h1.oversale-h1.bgo_plan+h1.o_plan 散客计划数,
nvl(h2.swnum,0) 散客已销售数,nvl(h2.swprice,0) 散客票价和,nvl(h2.adfy,0) 散客燃油费,nvl(h2.otherfy,0) 散客其他税费
from dw.da_flight h1
left join (
select t1.segment_head_id,sum(case when t1.seats_name not in('B','G','G1','G2') then 1 else 0 end) swnum ,
    sum(case when t1.seats_name not in('B','G','G1','G2') then t1.ticket_price else 0 end) swprice,
    sum(case when t1.seats_name not in('B','G','G1','G2') then t1.ad_fy else 0 end) adfy,
    sum(case when t1.seats_name not in('B','G','G1','G2') then t1.other_fy else 0 end) otherfy            
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  where t1.flights_date>=to_date('2017-01-01','yyyy-mm-dd')
    and t1.flights_date<=to_date('2017-02-20','yyyy-mm-dd')
    and t2.flag<>2
    and t2.nationflag in('区域','国际')
    and t1.order_day< add_months(trunc(sysdate),-12)-19
    and t1.whole_flight like '9C%'
    group by t1.segment_head_id)h2 on h1.segment_head_id=h2.segment_head_id
    where h1.flight_date>=to_date('2017-01-01','yyyy-mm-dd')
    and h1.flight_date<=to_date('2017-02-20','yyyy-mm-dd')
    and h1.flag<>2
    and h1.nationflag in('区域','国际')
    and h1.company_id=0
   
   
   