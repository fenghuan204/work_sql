select to_char(t1.r_flights_date,'yyyy-mm') 航班月,t2.originairport 始发站,t2.area_type 航线性质,count(0) 乘机人数
from stg.s_cq_order_head t1
JOIN dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
where t1.r_flights_date>=last_day(add_months(trunc(sysdate),-2))+1
and t1.r_flights_date< last_day(add_months(trunc(sysdate),-1))+1
and t2.originairport IN('SHA','PVG')
AND t1.r_company_id=0
and t1.flag_id=40 
group by to_char(t1.r_flights_date,'yyyy-mm'),t2.originairport,t2.area_type;




select /* t1.flights_order_head_id,t1.traveller_name,t1.codeno,t3.origin_std,t3.flights_segment_name,
t2.flights_order_head_id,t2.traveller_name,t2.codeno,t4.origin_std,t4.flights_segment_name*/
count(1),count(distinct t1.flights_order_head_id)
  from dw.fact_order_detail t1,
       dw.fact_order_detail t2,
       dw.da_flight t3,
       dw.da_flight t4
  where t1.codeno=t2.codeno
     and t1.whole_segment like '%PVG'
     and t2.whole_segment like 'PVG%'
     and t1.flights_date>=to_date('2019-08-01','yyyy-mm-dd')
     and t1.flights_date< to_date('2019-09-01','yyyy-mm-dd')
     and t2.flights_date>=to_date('2019-08-01','yyyy-mm-dd')
     and t2.flights_date< to_date('2019-09-01','yyyy-mm-dd')+1
     and t1.segment_head_id=t3.segment_head_id
     and t2.segment_head_id=t4.segment_head_id
     and (t4.origin_std-t3.dest_sta)*24<=24
     and t1.nationflag<>'国内'
     and t2.nationflag<>'国内'
     and t2.flag_id =40
     and t1.flag_id=40
     and t1.sex in(1,2)
     and t2.sex in(1,2)
     and t3.destairport='PVG'
     and t4.originairport='PVG'
     --and t1.birthday=t2.birthday
     and t1.en_name=t2.en_name
     and t3.originairport<>t4.destairport
     
   select  (1447+6915+379+362)/266709=3.4%  from dual 