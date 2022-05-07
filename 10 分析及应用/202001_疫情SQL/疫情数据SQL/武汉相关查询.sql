select count(1)
 from cqsale.cq_order@to_air t
 join cqsale.cq_order_head@to_air t1 on t.flights_order_id=t1.flights_order_id
 join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
 left join dw.adt_mobile_list t3 on substr(getmobile(t1.r_tel),1,7) =t3.mobilenumber
 left join dw.adt_region_code t4 on t1.codetype=1 and substr(t1.codeno,1,6)=t4.regioncode
where t1.r_flights_date>=trunc(sysdate)
  and t1.flag_id in(3,5,40)
  and t2.flag<>2
  and t1.whole_flight like '9C%'
  and (t3.city like '%武汉%' or t4.city like '%武汉%');
  
  
  --武汉大阪旅客返程（取消--返程）
  
  select 
distinct 
hh1.flights_segment_name 第一程航段,hh1.flight_date 第一程航班日期,substr(hh1.sname,1,3)||'******' 姓名,substr(hh1.codeno,1,3)||'****' 证件号,hh1.flag_name 机票状态,hh1.seats_name 第一程舱位,
hh1.flights_order_id 第一程订单号,hh2.flights_segment_name "25号以后购票航段",hh2.r_flights_date 航班日期,hh2.whole_flight 航班号,hh2.flights_order_id 订单号,hh2.flag_name 第二程机票状态,
hh2.seats_name 第二程舱位
from(
select  t2.flights_segment_name,t2.flight_date,t1.name||' '||coalesce(t1.second_name,'') sname ,t1.codeno,t1.flights_order_id,t2.destairport,t1.seats_name,
t4.flag_name
 from cqsale.cq_order_head@to_AIR t1
 join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
 left join stg.s_cq_order_head_flag t4 on t1.flag_id=t4.flag
 where t2.flights_segment_name like '武汉%'
   and t2.flight_date>=to_date('2020-01-06','yyyy-mm-dd')
   and t2.flight_date< to_date('2020-01-25','yyyy-mm-dd')
   and t1.flag_id in(3,5,40,41,7,11,12)
   and regexp_like(t2.flights_segment_name , '(大阪)|(东京)|(成田)%'))hh1
 join(select h1.whole_segment,h2.flights_segment_name,h1.r_flights_date,h1.name||' '||coalesce(h1.second_name,'') sname,h1.codeno,h1.flights_order_id,
 h2.originairport, h1.seats_name,h1.whole_flight,h3.flag_name
           from cqsale.cq_order_head@to_AIR h1
           join dw.da_flight h2 on h1.segment_head_id=h2.segment_head_id
        left join stg.s_cq_order_head_flag h3 on h1.flag_id=h3.flag
           where h1.r_flights_DATE>=to_date('2020-01-25','yyyy-mm-dd')
            --and h2.flights_segment_name like '大阪%'
            and h1.flag_id in(3,5,40,41)
            and h2.flag<>2
            )hh2 on hh1.sname=hh2.sname and hh1.codeno=hh2.codeno;
			
			
			
			select t1.r_flights_date,t1.whole_flight,t2.flights_segment_name,t2.nationflag,count(1) ticketnum
 from cqsale.cq_order@to_air t
 join cqsale.cq_order_head@to_air t1 on t.flights_order_id=t1.flights_order_id
 join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
 left join dw.adt_mobile_list t3 on substr(getmobile(t1.r_tel),1,7) =t3.mobilenumber
 left join dw.adt_mobile_list t4 on substr(getmobile(t.work_tel),1,7) =t4.mobilenumber
  left join dw.adt_region_code t5 on t1.codetype=1 and substr(t1.codeno,1,6)=t5.regioncode
where t1.r_flights_date>=trunc(sysdate)
  and t1.flag_id in(3,5,40)
  and t2.nationflag<>'国内'
  and t2.flag<>2
  and t1.whole_flight like '9C%'
  and (t4.province like '%湖北%' or t4.province like '%湖北%'
  or t5.province like '%湖北%');
			
			

			

