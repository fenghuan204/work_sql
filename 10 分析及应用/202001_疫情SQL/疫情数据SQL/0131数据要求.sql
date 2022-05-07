
----   未针对取消航班




select  /*+parallel(4) */
h1.route_name,h1.wf_segment_name,h1.nationflag,'0211~0224' datetype,sum(h1.oversale) oversale,sum(ticketnum) ticketnum,
sum(ticketprice) ticke, sum(h1.allprice) allprice,count(distinct h1.flights_id) 
from(
select t1.segment_head_id,t2.flights_id,t2.flights_city_name route_name,  
replace(replace(case when instr(t3.wf_segment, '＝', 1, 2) > 0 then
          split_part(t3.wf_segment, '＝', 1) || '＝' ||
          split_part(t3.wf_segment, '＝', 3)
         else
          t3.wf_segment
       end,'浦东','上海'）,'虹桥','上海')  wf_segment_name,t2.oversale,t1.nationflag,
        sum(case when t1.seats_name is not null then 1 else 0 end) ticketnum,
    sum(t1.ticket_price) ticketprice,sum(case when t1.seats_name is not null then t1.price else 0 end） allprice
   from dw.fact_order_detail t1
   join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
   left join dw.dim_segment_type t3 on t2.route_id=t3.route_id and t2.h_route_id=t3.h_route_id
   where t1.flights_date>=to_date('2020-02-11','yyyy-mm-dd')
     and t1.flights_date<=to_date('2020-02-24','yyyy-mm-dd')
   and t1.company_id=0
   and t1.order_day< trunc(sysdate)
   and t1.seats_name is  not null
   group by t1.segment_head_id,t2.flights_id,t2.flights_city_name,  
replace(replace(case when instr(t3.wf_segment, '＝', 1, 2) > 0 then
          split_part(t3.wf_segment, '＝', 1) || '＝' ||
          split_part(t3.wf_segment, '＝', 3)
         else
          t3.wf_segment
       end,'浦东','上海'）,'虹桥','上海'),t2.oversale,t1.nationflag
   )h1
   group by h1.route_name,h1.wf_segment_name,h1.nationflag
   
   
   union all
   
  select  
h1.route_name,h1.wf_segment_name,h1.nationflag,'去年同期' datetype,sum(h1.oversale) oversale,sum(ticketnum) ticketnum,
sum(ticketprice) ticke, sum(h1.allprice) allprice,count(distinct h1.flights_id) 
from(
select t1.segment_head_id,t2.flights_id,t2.flights_city_name route_name,  
replace(replace(case when instr(t3.wf_segment, '＝', 1, 2) > 0 then
          split_part(t3.wf_segment, '＝', 1) || '＝' ||
          split_part(t3.wf_segment, '＝', 3)
         else
          t3.wf_segment
       end,'浦东','上海'）,'虹桥','上海')  wf_segment_name,t2.oversale,t1.nationflag,
        sum(case when t1.seats_name is not null then 1 else 0 end) ticketnum,
    sum(t1.ticket_price) ticketprice,sum(case when t1.seats_name is not null then t1.price else 0 end） allprice
   from dw.fact_order_detail t1
   join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
   left join dw.dim_segment_type t3 on t2.route_id=t3.route_id and t2.h_route_id=t3.h_route_id
   where t1.flights_date>=to_date('2019-02-22','yyyy-mm-dd')
     and t1.flights_date<=to_date('2019-03-06','yyyy-mm-dd')
   and t1.company_id=0
   and t1.order_day< to_date('2019-02-11','yyyy-mm-dd')
   and t1.seats_name is  not null
   group by t1.segment_head_id,t2.flights_id,t2.flights_city_name,  
replace(replace(case when instr(t3.wf_segment, '＝', 1, 2) > 0 then
          split_part(t3.wf_segment, '＝', 1) || '＝' ||
          split_part(t3.wf_segment, '＝', 3)
         else
          t3.wf_segment
       end,'浦东','上海'）,'虹桥','上海'),t2.oversale,t1.nationflag
   )h1
   group by h1.route_name,h1.wf_segment_name,h1.nationflag
   
   union  all
   
  select  
h1.route_name,h1.wf_segment_name,h1.nationflag,'近一周流量' datetype,sum(h1.oversale) oversale,sum(ticketnum) ticketnum,
sum(ticketprice) ticke, sum(h1.allprice) allprice,count(distinct h1.flights_id) 
from(
select t1.segment_head_id,t2.flights_id,t2.flights_city_name route_name,  
replace(replace(case when instr(t3.wf_segment, '＝', 1, 2) > 0 then
          split_part(t3.wf_segment, '＝', 1) || '＝' ||
          split_part(t3.wf_segment, '＝', 3)
         else
          t3.wf_segment
       end,'浦东','上海'）,'虹桥','上海')  wf_segment_name,t2.oversale,t1.nationflag,
        sum(case when t1.seats_name is not null then 1 else 0 end) ticketnum,
    sum(t1.ticket_price) ticketprice,sum(case when t1.seats_name is not null then t1.price else 0 end） allprice
   from dw.fact_order_detail t1
   join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
   left join dw.dim_segment_type t3 on t2.route_id=t3.route_id and t2.h_route_id=t3.h_route_id
   where t1.flights_date>=to_date('2020-02-11','yyyy-mm-dd')
     and t1.flights_date<=to_date('2020-02-24','yyyy-mm-dd')
   and t1.company_id=0
   and t1.order_day >=trunc(sysdate)-7
   and t1.order_day< trunc(sysdate)
   and t1.seats_name is  not null
   group by t1.segment_head_id,t2.flights_id,t2.flights_city_name,  
replace(replace(case when instr(t3.wf_segment, '＝', 1, 2) > 0 then
          split_part(t3.wf_segment, '＝', 1) || '＝' ||
          split_part(t3.wf_segment, '＝', 3)
         else
          t3.wf_segment
       end,'浦东','上海'）,'虹桥','上海'),t2.oversale,t1.nationflag
   )h1
   group by h1.route_name,h1.wf_segment_name,h1.nationflag;
   
   






----下面是剔除取消航班的数据

select  /*+parallel(4) */
h1.route_name,h1.wf_segment_name,h1.nationflag,'0211~0224' datetype,sum(h1.oversale) oversale,sum(ticketnum) ticketnum,
sum(ticketprice) ticke, sum(h1.allprice) allprice,count(distinct h1.flights_id) 
from(
select t1.segment_head_id,t2.flights_id,t2.flights_city_name route_name,  
replace(replace(case when instr(t3.wf_segment, '＝', 1, 2) > 0 then
          split_part(t3.wf_segment, '＝', 1) || '＝' ||
          split_part(t3.wf_segment, '＝', 3)
         else
          t3.wf_segment
       end,'浦东','上海'）,'虹桥','上海')  wf_segment_name,t2.oversale,t1.nationflag,
        sum(case when t1.seats_name is not null then 1 else 0 end) ticketnum,
    sum(t1.ticket_price) ticketprice,sum(case when t1.seats_name is not null then t1.price else 0 end） allprice
   from dw.fact_order_detail t1
   join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
   left join dw.dim_segment_type t3 on t2.route_id=t3.route_id and t2.h_route_id=t3.h_route_id
   where t1.flights_date>=to_date('2020-02-11','yyyy-mm-dd')
     and t1.flights_date<=to_date('2020-02-24','yyyy-mm-dd')
	 and t2.flag<>2
   and t1.company_id=0
   and t1.order_day< trunc(sysdate)
   and t1.seats_name is  not null
   group by t1.segment_head_id,t2.flights_id,t2.flights_city_name,  
replace(replace(case when instr(t3.wf_segment, '＝', 1, 2) > 0 then
          split_part(t3.wf_segment, '＝', 1) || '＝' ||
          split_part(t3.wf_segment, '＝', 3)
         else
          t3.wf_segment
       end,'浦东','上海'）,'虹桥','上海'),t2.oversale,t1.nationflag
   )h1
   group by h1.route_name,h1.wf_segment_name,h1.nationflag
   
   
   union all
   
  select  
h1.route_name,h1.wf_segment_name,h1.nationflag,'去年同期' datetype,sum(h1.oversale) oversale,sum(ticketnum) ticketnum,
sum(ticketprice) ticke, sum(h1.allprice) allprice,count(distinct h1.flights_id) 
from(
select t1.segment_head_id,t2.flights_id,t2.flights_city_name route_name,  
replace(replace(case when instr(t3.wf_segment, '＝', 1, 2) > 0 then
          split_part(t3.wf_segment, '＝', 1) || '＝' ||
          split_part(t3.wf_segment, '＝', 3)
         else
          t3.wf_segment
       end,'浦东','上海'）,'虹桥','上海')  wf_segment_name,t2.oversale,t1.nationflag,
        sum(case when t1.seats_name is not null then 1 else 0 end) ticketnum,
    sum(t1.ticket_price) ticketprice,sum(case when t1.seats_name is not null then t1.price else 0 end） allprice
   from dw.fact_order_detail t1
   join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
   left join dw.dim_segment_type t3 on t2.route_id=t3.route_id and t2.h_route_id=t3.h_route_id
   where t1.flights_date>=to_date('2019-02-22','yyyy-mm-dd')
     and t1.flights_date<=to_date('2019-03-06','yyyy-mm-dd')
   and t1.company_id=0
   and t2.flag<>2
   and t1.order_day< to_date('2019-02-11','yyyy-mm-dd')
   and t1.seats_name is  not null
   group by t1.segment_head_id,t2.flights_id,t2.flights_city_name,  
replace(replace(case when instr(t3.wf_segment, '＝', 1, 2) > 0 then
          split_part(t3.wf_segment, '＝', 1) || '＝' ||
          split_part(t3.wf_segment, '＝', 3)
         else
          t3.wf_segment
       end,'浦东','上海'）,'虹桥','上海'),t2.oversale,t1.nationflag
   )h1
   group by h1.route_name,h1.wf_segment_name,h1.nationflag
   
   union  all
   
  select  
h1.route_name,h1.wf_segment_name,h1.nationflag,'近一周流量' datetype,sum(h1.oversale) oversale,sum(ticketnum) ticketnum,
sum(ticketprice) ticke, sum(h1.allprice) allprice,count(distinct h1.flights_id) 
from(
select t1.segment_head_id,t2.flights_id,t2.flights_city_name route_name,  
replace(replace(case when instr(t3.wf_segment, '＝', 1, 2) > 0 then
          split_part(t3.wf_segment, '＝', 1) || '＝' ||
          split_part(t3.wf_segment, '＝', 3)
         else
          t3.wf_segment
       end,'浦东','上海'）,'虹桥','上海')  wf_segment_name,t2.oversale,t1.nationflag,
        sum(case when t1.seats_name is not null then 1 else 0 end) ticketnum,
    sum(t1.ticket_price) ticketprice,sum(case when t1.seats_name is not null then t1.price else 0 end） allprice
   from dw.fact_order_detail t1
   join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
   left join dw.dim_segment_type t3 on t2.route_id=t3.route_id and t2.h_route_id=t3.h_route_id
   where t1.flights_date>=to_date('2020-02-11','yyyy-mm-dd')
     and t1.flights_date<=to_date('2020-02-24','yyyy-mm-dd')
   and t1.company_id=0
   and t2.flag<>2
   and t1.order_day >=trunc(sysdate)-7
   and t1.order_day< trunc(sysdate)
   and t1.seats_name is  not null
   group by t1.segment_head_id,t2.flights_id,t2.flights_city_name,  
replace(replace(case when instr(t3.wf_segment, '＝', 1, 2) > 0 then
          split_part(t3.wf_segment, '＝', 1) || '＝' ||
          split_part(t3.wf_segment, '＝', 3)
         else
          t3.wf_segment
       end,'浦东','上海'）,'虹桥','上海'),t2.oversale,t1.nationflag
   )h1
   group by h1.route_name,h1.wf_segment_name,h1.nationflag;
   
   
   
   
 --- 去年同期数据（完成情况）
    
  select  
h1.route_name,h1.wf_segment_name,h1.nationflag,'去年同期' datetype,sum(h1.oversale) oversale,sum(ticketnum) ticketnum,
sum(ticketprice) ticke, sum(h1.allprice) allprice,count(distinct h1.flights_id) 
from(
select t1.segment_head_id,t2.flights_id,t2.flights_city_name route_name,  
replace(replace(case when instr(t3.wf_segment, '＝', 1, 2) > 0 then
          split_part(t3.wf_segment, '＝', 1) || '＝' ||
          split_part(t3.wf_segment, '＝', 3)
         else
          t3.wf_segment
       end,'浦东','上海'）,'虹桥','上海')  wf_segment_name,t2.oversale,t1.nationflag,
        sum(case when t1.seats_name is not null then 1 else 0 end) ticketnum,
    sum(t1.ticket_price) ticketprice,sum(case when t1.seats_name is not null then t1.price else 0 end） allprice
   from dw.fact_order_detail t1
   join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
   left join dw.dim_segment_type t3 on t2.route_id=t3.route_id and t2.h_route_id=t3.h_route_id
   where t1.flights_date>=to_date('2019-02-22','yyyy-mm-dd')
     and t1.flights_date<=to_date('2019-03-06','yyyy-mm-dd')
   and t1.company_id=0
   and t2.flag<>2
   and t1.order_day< to_date('2019-02-11','yyyy-mm-dd')
   and t1.seats_name is  not null
   group by t1.segment_head_id,t2.flights_id,t2.flights_city_name,  
replace(replace(case when instr(t3.wf_segment, '＝', 1, 2) > 0 then
          split_part(t3.wf_segment, '＝', 1) || '＝' ||
          split_part(t3.wf_segment, '＝', 3)
         else
          t3.wf_segment
       end,'浦东','上海'）,'虹桥','上海'),t2.oversale,t1.nationflag
   )h1
   group by h1.route_name,h1.wf_segment_name,h1.nationflag;
  
  
  
  
  ------------平时航段的销售提前期分布情况
  
  
 select  /*+parallel(4) */
h1.route_name,h1.wf_segment_name,h1.nationflag,'0211~0224' datetype,sum(h1.oversale) oversale,sum(ticketnum) ticketnum,
sum(ticketprice) ticke, sum(h1.allprice) allprice,count(distinct h1.flights_id) 
from(
select t1.segment_head_id,t2.flights_id,t2.flights_city_name route_name,  
replace(replace(case when instr(t3.wf_segment, '＝', 1, 2) > 0 then
          split_part(t3.wf_segment, '＝', 1) || '＝' ||
          split_part(t3.wf_segment, '＝', 3)
         else
          t3.wf_segment
       end,'浦东','上海'）,'虹桥','上海')  wf_segment_name,t2.oversale-t2.bgo_plan+t2.o_plan oversale,t1.nationflag,
        sum(case when t1.seats_name is not null then 1 else 0 end) ticketnum,
    sum(t1.ticket_price) ticketprice,sum(case when t1.seats_name is not null then t1.price else 0 end） allprice
   from dw.fact_order_detail t1
   join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
   left join dw.dim_segment_type t3 on t2.route_id=t3.route_id and t2.h_route_id=t3.h_route_id
   where t1.flights_date>=to_date('2019-11-11','yyyy-mm-dd')
     and t1.flights_date<=to_date('2019-11-24','yyyy-mm-dd')
   and t2.flag<>2
   and t1.company_id=0
   and t1.seats_name not in('B','G','G1','G2')
   and t1.order_day>=to_date('2019-10-24','yyyy-mm-dd')
   and t1.order_day< to_date('2019-10-31','yyyy-mm-dd')
   and t1.seats_name is  not null
   group by t1.segment_head_id,t2.flights_id,t2.flights_city_name,  
replace(replace(case when instr(t3.wf_segment, '＝', 1, 2) > 0 then
          split_part(t3.wf_segment, '＝', 1) || '＝' ||
          split_part(t3.wf_segment, '＝', 3)
         else
          t3.wf_segment
       end,'浦东','上海'）,'虹桥','上海'),t2.oversale-t2.bgo_plan+t2.o_plan,t1.nationflag
   )h1
   group by h1.route_name,h1.wf_segment_name,h1.nationflag
   
   