
---取消航班参考数据

---限定订单日期

select  /*+parallel(4) */
h1.route_name,h1.wf_segment_name,'0201~0211' datetype,sum(h1.oversale) oversale,sum(ticketnum) ticketnum,
sum(ticketprice) ticke,
           sum(h1.allprice) allprice,count(distinct h1.flights_id) 
from(
select t1.segment_head_id,t2.flights_id,t2.route_name,t3.wf_segment_name,t2.oversale,
        sum(case when t1.seats_name is not null then 1 else 0 end) ticketnum,
    sum(t1.ticket_price) ticketprice,sum(case when t1.seats_name is not null then t1.price else 0 end） allprice
   from dw.fact_order_detail t1
   join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
   left join dw.dim_segment_type t3 on t2.route_id=t3.route_id and t2.h_route_id=t3.h_route_id
   where t1.flights_date>=to_date('2020-02-01','yyyy-mm-dd')
     and t1.flights_date<=to_date('2020-02-11','yyyy-mm-dd')
   and t1.company_id=0
   and t1.nationflag='国内'
   and t1.order_day>=trunc(sysdate-7)
   and t1.seats_name is  not null
   group by t1.segment_head_id,t2.route_name,t3.wf_segment_name,t2.oversale,t2.flights_id
   )h1
   group by h1.route_name,h1.wf_segment_name
   
   union  all
   
  select  h1.route_name,h1.wf_segment_name,'0212~0229' datetype,sum(h1.oversale) oversale,sum(ticketnum) ticketnum,
  sum(ticketprice),
           sum(h1.allprice) allprice,count(distinct h1.flights_id) 
from(
select t1.segment_head_id,t2.flights_id,t2.route_name,t3.wf_segment_name,t2.oversale,
        sum(case when t1.seats_name is not null then 1 else 0 end) ticketnum,
    sum(t1.ticket_price) ticketprice,sum(case when t1.seats_name is not null then t1.price else 0 end） allprice
   from dw.fact_order_detail t1
   join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
   left join dw.dim_segment_type t3 on t2.route_id=t3.route_id and t2.h_route_id=t3.h_route_id
   where t1.flights_date>=to_date('2020-02-12','yyyy-mm-dd')
     and t1.flights_date<=to_date('2020-02-29','yyyy-mm-dd')
   and t1.company_id=0
   and  t1.order_day>=trunc(sysdate-7)
   and t1.nationflag='国内'
   and t1.seats_name is  not null
   group by t1.segment_head_id,t2.route_name,t3.wf_segment_name,t2.oversale,t2.flights_id)h1
   group by h1.route_name,h1.wf_segment_name;
   
   
   
 ---不限定订单日期  
   
select  /*+parallel(4) */
h1.route_name,h1.wf_segment_name,'0201~0211' datetype,sum(h1.oversale) oversale,sum(ticketnum) ticketnum,
sum(ticketprice) ticketprice,
           sum(h1.allprice) allprice,count(distinct h1.flights_id) 
from(
select t1.segment_head_id,t2.flights_id,t2.route_name,t3.wf_segment_name,t2.oversale,
        sum(case when t1.seats_name is not null then 1 else 0 end) ticketnum,
    sum(t1.ticket_price) ticketprice,sum(case when t1.seats_name is not null then t1.price else 0 end） allprice
   from dw.fact_order_detail t1
   join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
   left join dw.dim_segment_type t3 on t2.route_id=t3.route_id and t2.h_route_id=t3.h_route_id
   where t1.flights_date>=to_date('2020-02-01','yyyy-mm-dd')
     and t1.flights_date<=to_date('2020-02-11','yyyy-mm-dd')
   and t1.company_id=0
   and t1.nationflag='国内'
   and t1.seats_name is  not null
   group by t1.segment_head_id,t2.route_name,t3.wf_segment_name,t2.oversale,t2.flights_id
   )h1
   group by h1.route_name,h1.wf_segment_name
   
   union  all
   
  select  h1.route_name,h1.wf_segment_name,'0212~0229' datetype,sum(h1.oversale) oversale,sum(ticketnum) ticketnum,
  sum(ticketprice) ticketprice,
           sum(h1.allprice) allprice,count(distinct h1.flights_id) 
from(
select t1.segment_head_id,t2.flights_id,t2.route_name,t3.wf_segment_name,t2.oversale,
        sum(case when t1.seats_name is not null then 1 else 0 end) ticketnum,
    sum(t1.ticket_price) ticketprice,sum(case when t1.seats_name is not null then t1.price else 0 end） allprice
   from dw.fact_order_detail t1
   join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
   left join dw.dim_segment_type t3 on t2.route_id=t3.route_id and t2.h_route_id=t3.h_route_id
   where t1.flights_date>=to_date('2020-02-12','yyyy-mm-dd')
     and t1.flights_date<=to_date('2020-02-29','yyyy-mm-dd')
   and t1.company_id=0
   and t1.nationflag='国内'
   and t1.seats_name is  not null
   group by t1.segment_head_id,t2.route_name,t3.wf_segment_name,t2.oversale,t2.flights_id)h1
   group by h1.route_name,h1.wf_segment_name;
   
   
   
   --------------第一版：飞行小时、小时成本等测算
   
     select /*+parallel(4) */
  h1.*,nvl(nvl(h3.avgtime,h2.avgtime),h4.avgtime) avgtime
  from(
  select '今年' type,t2.flights_city_name,sum(case when t1.seats_name not in('B','G','G1','G2') then 1 else 0 end) ticketnum,
  sum(case when t1.seats_name not in('B','G','G1','G2') then t1.ticket_price+t1.ad_fy else 0 end) ticketfee,
  count(distinct t1.segment_head_id) flightnum
  from dw.fact_order_detail t1
           join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
           where t1.flights_date>=to_date('2020-01-20','yyyy-mm-dd')
             and t1.flights_date<=tO_date('2020-01-26','yyyy-mm-dd')
             and t1.company_id=0
             and t2.flag<>2
             and t1.seats_name is not null
             group by t2.flights_city_name
    
 union all
 
  select '去年同期',t2.flights_city_name,sum(case when t1.seats_name not in('B','G','G1','G2') then 1 else 0 end) ticketnum,
  sum(case when t1.seats_name not in('B','G','G1','G2') then t1.ticket_price+t1.ad_fy else 0 end) ticketfee,
  count(distinct t1.segment_head_id)
  from dw.fact_order_detail t1
           join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
           where t1.flights_date>=to_date('2019-01-31','yyyy-mm-dd')
             and t1.flights_date<=tO_date('2019-02-06','yyyy-mm-dd')
             and t1.company_id=0
             and t2.flag<>2
             and t1.seats_name is not null
             group by t2.flights_city_name
         
  union all
 
  select '去年年后',t2.flights_city_name,sum(case when t1.seats_name not in('B','G','G1','G2') then 1 else 0 end) ticketnum,
  sum(case when t1.seats_name not in('B','G','G1','G2') then t1.ticket_price+t1.ad_fy else 0 end) ticketfee,
  count(distinct t1.segment_head_id)
  from dw.fact_order_detail t1
           join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
           where t1.flights_date>=to_date('2019-02-11','yyyy-mm-dd')
             and t1.flights_date<=tO_date('2019-02-17','yyyy-mm-dd')
             and t1.company_id=0
             and t2.flag<>2
             and t1.seats_name is not null
             group by t2.flights_city_name)h1
             left join (select tb2.flights_city_name,sum(tb1.FLIGHT_TIME)/count(distinct tb1.segment_head_id) avgtime
                from dw.da_foc_flight tb1
                join dw.da_flight tb2 on tb1.segment_head_id=tb2.segment_head_id
                where tb1.flights_date>=to_date('2020-01-19','yyyy-mm-dd')
             and tb1.flights_date<=tO_date('2020-01-25','yyyy-mm-dd')
             and tb2.flag<>2
             and tb2.company_id=0
             group by  tb2.flights_city_name)h2 on h1.flights_city_name=h2.flights_city_name
      left join (select  replace(replace(tb1.route_name,'浦东','上海'),'虹桥','上海') route_name ,sum(ROUND_TIME)/count(1) avgtime
                         from hdb.recent_flights_cost tb1
                         where tb1.flight_date>=to_date('2020-01-19','yyyy-mm-dd')
             and tb1.flight_date<=tO_date('2020-01-25','yyyy-mm-dd')
       and tb1.total_cost>0
       group by replace(replace(tb1.route_name,'浦东','上海'),'虹桥','上海'))h3  on h1.flights_city_name=h3.route_name
        left join (select tb2.flights_city_name,sum(tb1.FLIGHT_TIME)/count(distinct tb1.segment_head_id) avgtime
                from dw.da_foc_flight tb1
                join dw.da_flight tb2 on tb1.segment_head_id=tb2.segment_head_id
                where tb1.flights_date>=to_date('2019-01-31','yyyy-mm-dd')
             and tb1.flights_date<=tO_date('2019-02-17','yyyy-mm-dd')
             and tb2.flag<>2
             and tb2.company_id=0
             group by  tb2.flights_city_name)h4 on h1.flights_city_name=h4.flights_city_name;
    
   
   