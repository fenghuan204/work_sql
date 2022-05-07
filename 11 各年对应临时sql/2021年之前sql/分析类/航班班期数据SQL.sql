select wf_segment 往返航线,flights_segment_name 航段,originairport_name 始发站,destairport_name 目的站,originstd 起飞时间,deststa 降落时间,
localstd 当地起飞时间,localsta 当地降落时间,list 班期,flightnum 周航班量,num2 夏秋对应周数,flighttonum 夏秋航季总航班量,plannum 夏秋航季总计划数
from(
select wf_segment,flights_segment_name,originairport_name,destairport_name,originstd,deststa,localstd,localsta,list,flightnum,num2,flighttonum,plannum,
row_number()over(partition by wf_segment,flights_segment_name,originairport_name,destairport_name,originstd,deststa,localstd,localsta,list,flightnum,num2,flighttonum,plannum order by num3 desc) nrow
from(
select wf_segment,flights_segment_name,originairport_name,destairport_name,originstd,deststa,localstd,localsta,list,flightnum,num2,flighttonum,plannum,count(1) num3
from(



select weeks,wf_segment,flights_segment_name,originairport_name,destairport_name,originstd,deststa,localstd,localsta,list,flightnum,oversale,count(1) num1,
sum(count(1))over(partition by wf_segment,flights_segment_name,originairport_name,destairport_name,originstd,deststa,localstd,localsta,list,flightnum) num2,
sum(flightnum)over(partition by wf_segment,flights_segment_name,originairport_name,destairport_name,originstd,deststa,localstd,localsta,list)  flighttonum,
sum(oversale) over(partition by wf_segment,flights_segment_name,originairport_name,destairport_name,originstd,deststa,localstd,localsta,list) plannum
from(
select weeks,wf_segment,flights_segment_name,originairport_name,destairport_name,originstd,deststa,localstd,localsta,list,sum(flightnum) flightnum,sum(oversale) oversale
from(
select h1.weeks,h1.wf_segment,h1.flights_segment_name,h1.originairport_name,h1.destairport_name,h1.originstd,h1.deststa, h1.localstd,h1.localsta, h1.weeknum,h1.flightnum,h1.oversale,
listagg(h1.weeknum,'') within group(order by h1.weeknum) over(partition by h1.weeks,h1.wf_segment,h1.flights_segment_name,h1.originairport_name,h1.destairport_name,h1.originstd,h1.deststa,h1.flightnum) list
from(
select to_char(trunc(p1.origin_std)+1,'iw') weeks,
case
         when instr(t4.wf_segment, '＝', 1, 2) > 0 then
          split_part(t4.wf_segment, '＝', 1) || '＝' ||
          split_part(t4.wf_segment, '＝', 3)
         else
          t4.wf_segment
       end wf_segment,
       p1.flights_segment_name,
       p1.originairport_name,
       p1.destairport_name,
       to_char(p1.origin_std,'hh24:mi') originstd,
       to_char(p1.dest_sta,'hh24:mi') deststa,
      to_char(p2.local_std,'hh24:mi') localstd,
       to_char(p2.local_sta,'hh24:mi') localsta,
     
     
       to_char(p1.origin_std-1,'d') weeknum,
       count(1) flightnum,
       sum(p1.oversale) oversale
               from dw.da_flight p1
                  left join stg.s_cq_flights_segment_head p2 on p1.segment_head_id=p2.segment_head_id
               left join dw.dim_segment_type t4 on p1.route_Id = t4.route_Id and p1.h_route_id = t4.h_route_id

where p1.flight_date>=to_date('2019-03-31','yyyy-mm-dd')
  and p1.flight_date<=to_date('2019-10-26','yyyy-mm-dd')
  and p1.flag<>2
  and p1.company_id=0
  and p1.flights_city_name like '%扬州%'
  group by to_char(trunc(p1.origin_std)+1,'iw'),
case
         when instr(t4.wf_segment, '＝', 1, 2) > 0 then
          split_part(t4.wf_segment, '＝', 1) || '＝' ||
          split_part(t4.wf_segment, '＝', 3)
         else
          t4.wf_segment
       end ,
       p1.flights_segment_name,
       p1.originairport_name,
       p1.destairport_name,
       to_char(p1.origin_std,'hh24:mi'),
       to_char(p1.dest_sta,'hh24:mi'),
            to_char(p2.local_std,'hh24:mi') ,
       to_char(p2.local_sta,'hh24:mi') ,
       to_char(p1.origin_std-1,'d')
     )h1 
     )h2
       group by weeks,wf_segment,flights_segment_name,originairport_name,destairport_name,originstd,localstd,localsta,deststa,list
     )h3
       group by weeks,wf_segment,flights_segment_name,originairport_name,destairport_name,originstd,deststa,localstd,localsta,list,flightnum,oversale
     
     
     )h4
       group by wf_segment,flights_segment_name,originairport_name,destairport_name,originstd,deststa,localstd,localsta,list,flightnum,num2,flighttonum,plannum
     )h5
     )h6
       where h6.nrow=1
       order by 1,2,3,4,5,6,9