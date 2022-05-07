
#换季数据

select '2018' 年,case when t1.flight_date>=to_date('2018-10-21','yyyy-mm-dd')
     and t1.flight_date< =to_date('2018-10-27','yyyy-mm-dd') then '换季前一周' 
     when t1.flight_date>=to_date('2018-10-28','yyyy-mm-dd')
     and t1.flight_date< =to_date('2018-11-03','yyyy-mm-dd') then '换季后一周' end 日期类型,
     count(distinct t1.segment_head_id) 航班量,suM(t1.oversale) 座位数,sum(t1.bgo_plan-t1.o_plan)/sum(t1.oversale)  计划包销比例
  from  dw.da_flight t1
  where t1.flight_date>=to_date('2018-10-21','yyyy-mm-dd')
    and t1.flight_date<=to_date('2018-11-03','yyyy-mm-dd')
    and t1.flag<>2
    and  t1.company_id=0
    group by case when t1.flight_date>=to_date('2018-10-21','yyyy-mm-dd')
     and t1.flight_date< =to_date('2018-10-27','yyyy-mm-dd') then '换季前一周' 
     when t1.flight_date>=to_date('2018-10-28','yyyy-mm-dd')
     and t1.flight_date< =to_date('2018-11-03','yyyy-mm-dd') then '换季后一周' end
   
union all


select '2017' 年,case when t1.flight_date>=to_date('2017-10-22','yyyy-mm-dd')
     and t1.flight_date< =to_date('2017-10-28','yyyy-mm-dd') then '换季前一周' 
     when t1.flight_date>=to_date('2017-10-29','yyyy-mm-dd')
     and t1.flight_date< =to_date('2018-11-04','yyyy-mm-dd') then '换季后一周' end,
     count(distinct t1.segment_head_id),suM(t1.oversale),sum(t1.bgo_plan-t1.o_plan)/sum(t1.oversale) 
  from  dw.da_flight t1
  where t1.flight_date>=to_date('2017-10-22','yyyy-mm-dd')
    and t1.flight_date<=to_date('2017-11-04','yyyy-mm-dd')
    and t1.flag<>2
    and  t1.company_id=0
    group by case when t1.flight_date>=to_date('2017-10-22','yyyy-mm-dd')
     and t1.flight_date< =to_date('2017-10-28','yyyy-mm-dd') then '换季前一周' 
     when t1.flight_date>=to_date('2017-10-29','yyyy-mm-dd')
     and t1.flight_date< =to_date('2018-11-04','yyyy-mm-dd') then '换季后一周' end;



select case when t3.segment_code is  null then '上航季无'
when t2.segment_code is  null then '上上航季无' 
else '老航线' end 航线类型,
count(distinct t1.segment_code) 航段数,
sum(t1.oversale) 计划量
  from  dw.da_flight t1
  left join (select distinct t1.segment_code
  from  dw.da_flight t1
  where t1.flight_date>=to_date('2017-10-29','yyyy-mm-dd')
    and t1.flight_date<=to_date('2018-03-24','yyyy-mm-dd')
    and t1.flag<>2
    and  t1.company_id=0) t2 on t2.segment_code=t1.segment_code
    
    left join (select distinct t1.segment_code
  from  dw.da_flight t1
  where t1.flight_date>=to_date('2018-03-25','yyyy-mm-dd')
    and t1.flight_date<=to_date('2018-10-27','yyyy-mm-dd')
    and t1.flag<>2
    and  t1.company_id=0) t3 on t1.segment_code=t3.segment_code    
  where t1.flight_date>=to_date('2018-10-28','yyyy-mm-dd')
    and t1.flight_date<=to_date('2018-11-03','yyyy-mm-dd')
    and t1.flag<>2
    and  t1.company_id=0
    group by case when t3.segment_code is  null then '上航季无'
when t2.segment_code is  null then '上上航季无' 
else '老航线' end;




    
    
   
   

 
select distinct t1.segment_code,t1.flights_segment_name, case when instr(h3.wf_segment,'＝',1,2)>0 then split_part(h3.wf_segment,'＝',1)||'＝'||split_part(h3.wf_segment,'＝',3)
else h3.wf_segment end wf_segment,
case when t3.segment_code is  null then '上航季无'
when t2.segment_code is  null then '上上航季无' 
else '老航线' end segmenttype
  from  dw.da_flight t1
  left join dw.dim_segment_type h3 on t1.route_id=h3.route_id and t1.h_route_id=h3.h_route_id
  left join (select distinct t1.segment_code
  from  dw.da_flight t1
  where t1.flight_date>=to_date('2017-10-29','yyyy-mm-dd')
    and t1.flight_date<=to_date('2018-03-24','yyyy-mm-dd')
    and t1.flag<>2
    and  t1.company_id=0) t2 on t2.segment_code=t1.segment_code
    
    left join (select distinct t1.segment_code
  from  dw.da_flight t1
  where t1.flight_date>=to_date('2018-03-25','yyyy-mm-dd')
    and t1.flight_date<=to_date('2018-10-27','yyyy-mm-dd')
    and t1.flag<>2
    and  t1.company_id=0) t3 on t1.segment_code=t3.segment_code    
  where t1.flight_date>=to_date('2018-10-28','yyyy-mm-dd')
    and t1.flight_date<=to_date('2018-11-03','yyyy-mm-dd')
    and t1.flag<>2
    and  t1.company_id=0





select '2018换季后一周' 类型, hh1.segmenttype,hh1.area_type,sum(hh1.swplan),sum(hh1.swnum)
from(
select t1.segment_head_id,h1.segmenttype,t2.area_type,t2.oversale-t2.bgo_plan swplan,count(1) swnum
from dw.fact_order_detail t1
join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
join 

(
select distinct t1.segment_code,t1.flights_segment_name, case when instr(h3.wf_segment,'＝',1,2)>0 then split_part(h3.wf_segment,'＝',1)||'＝'||split_part(h3.wf_segment,'＝',3)
else h3.wf_segment end wf_segment,
case when t3.segment_code is  null then '上航季无'
when t2.segment_code is  null then '上上航季无' 
else '老航线' end segmenttype
  from  dw.da_flight t1
  left join dw.dim_segment_type h3 on t1.route_id=h3.route_id and t1.h_route_id=h3.h_route_id
  left join (select distinct t1.segment_code
  from  dw.da_flight t1
  where t1.flight_date>=to_date('2017-10-29','yyyy-mm-dd')
    and t1.flight_date<=to_date('2018-03-24','yyyy-mm-dd')
    and t1.flag<>2
    and  t1.company_id=0) t2 on t2.segment_code=t1.segment_code
    
    left join (select distinct t1.segment_code
  from  dw.da_flight t1
  where t1.flight_date>=to_date('2018-03-25','yyyy-mm-dd')
    and t1.flight_date<=to_date('2018-10-27','yyyy-mm-dd')
    and t1.flag<>2
    and  t1.company_id=0) t3 on t1.segment_code=t3.segment_code    
  where t1.flight_date>=to_date('2018-10-28','yyyy-mm-dd')
    and t1.flight_date<=to_date('2018-11-03','yyyy-mm-dd')
    and t1.flag<>2
    and  t1.company_id=0)h1 on h1.segment_code=t2.segment_code
    where t1.seats_name not in('B','G','G1','G2','O')
    and t1.flights_date>=to_date('2018-10-28','yyyy-mm-dd')
    and t1.flights_date<=to_date('2018-11-03','yyyy-mm-dd')
    and t2.flag<>2
    and  t1.company_id=0
    group by t1.segment_head_id,h1.segmenttype,t2.area_type,t2.oversale-t2.bgo_plan  
    
    
    )hh1
    group by hh1.segmenttype,hh1.area_type
    
    
    union all
    
    
    
select '2017换季后一周' 类型, hh1.segmenttype,hh1.area_type,sum(hh1.swplan),sum(hh1.swnum)
from(
select t1.segment_head_id,h1.segmenttype,t2.area_type,t2.oversale-t2.bgo_plan swplan,count(1) swnum
from dw.fact_order_detail t1
join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
join 

(
select distinct t1.segment_code,t1.flights_segment_name, case when instr(h3.wf_segment,'＝',1,2)>0 then split_part(h3.wf_segment,'＝',1)||'＝'||split_part(h3.wf_segment,'＝',3)
else h3.wf_segment end wf_segment,
case when t3.segment_code is  null then '上航季无'
when t2.segment_code is  null then '上上航季无' 
else '老航线' end segmenttype
  from  dw.da_flight t1
  left join dw.dim_segment_type h3 on t1.route_id=h3.route_id and t1.h_route_id=h3.h_route_id
  left join (select distinct t1.segment_code
  from  dw.da_flight t1
  where t1.flight_date>=to_date('2016-10-30','yyyy-mm-dd')
    and t1.flight_date<=to_date('2017-03-25','yyyy-mm-dd')
    and t1.flag<>2
    and  t1.company_id=0) t2 on t2.segment_code=t1.segment_code
    
    left join (select distinct t1.segment_code
  from  dw.da_flight t1
  where t1.flight_date>=to_date('2017-03-26','yyyy-mm-dd')
    and t1.flight_date<=to_date('2017-10-28','yyyy-mm-dd')
    and t1.flag<>2
    and  t1.company_id=0) t3 on t1.segment_code=t3.segment_code    
  where t1.flight_date>=to_date('2017-10-29','yyyy-mm-dd')
    and t1.flight_date<=to_date('2017-11-04','yyyy-mm-dd')
    and t1.flag<>2
    and  t1.company_id=0)h1 on h1.segment_code=t2.segment_code
    where t1.seats_name not in('B','G','G1','G2','O')
    and t1.flights_date>=to_date('2017-10-29','yyyy-mm-dd')
    and t1.flights_date<=to_date('2017-11-04','yyyy-mm-dd')
    and t2.flag<>2
    and  t1.company_id=0
    and t1.order_day< to_date('2017-10-27','yyyy-mm-dd')
    group by t1.segment_head_id,h1.segmenttype,t2.area_type,t2.oversale-t2.bgo_plan      
    
    )hh1
    group by hh1.segmenttype,hh1.area_type






select case when t1.flights_date>=to_date('2018-10-28','yyyy-mm-dd')
             and t1.flights_date<=to_date('2018-11-03','yyyy-mm-dd') then '换季后一周'
             when t1.flights_date>=to_date('2018-10-21','yyyy-mm-dd')
             and t1.flights_date<=to_date('2018-10-27','yyyy-mm-dd') then '换季前一周'
             end,
           case when t1.channel='手机' and t1.station_id =2 then 'M网站'
            when t1.channel='手机' and t1.station_id in(5,10) then '微信'
            when t1.channel='手机' and t1.station_id in(3,8) then 'IOS'
            when t1.channel='手机' and t1.station_id in(4,9) then 'Andriod'
            else t1.channel end channel,
            case when t1.channel in('手机','网站') and t5.users_id is not null then '代理'
            else '非代理' end  is_agent,     
            t2.area_type,
                       
     t1.gender ,       
            case when getage(t1.flights_date,t1.birthday)<12 then '<12'
            when getage(t1.flights_date,t1.birthday)<18 then '12~17'
            when getage(t1.flights_date,t1.birthday)<25 then '18~24'
            when getage(t1.flights_date,t1.birthday)<30 then '25~29'
            when getage(t1.flights_date,t1.birthday)<40 then '30~39'
            when getage(t1.flights_date,t1.birthday)<50 then '40~49'
            when getage(t1.flights_date,t1.birthday)<60 then '50~59'
            when getage(t1.flights_date,t1.birthday)< 70 then '60~69'
            when getage(t1.flights_date,t1.birthday)>=70 then '70+' end age,          
            
            count(1) ticketnum,
            sum(t1.ticket_price) ticketprice,
            sum(t1.price) price

  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  left join dw.da_restrict_userinfo t5 on t1.client_id=t5.users_id
  left join dw.adt_mobile_list t8 on regexp_like(t1.r_tel, '^1[0-9]{10}$')
                              and substr(t1.r_tel, 1, 7) = t8.mobilenumber
  left join dw.adt_region_code tt1 on t1.codetype = 1
                            and tt1.regioncode=substr(t1.codeno, 1, 6)
   left join stg.s_cq_traveller_info t3 on t1.flights_order_head_id=t3.flights_order_head_id
   left join stg.s_cq_country_area t6 on t3.nationality=t6.country_code
   
    where t1.flights_date>=to_date('2018-10-21','yyyy-mm-dd')
    and t1.flights_date<=to_date('2018-11-03','yyyy-mm-dd')
    and t2.flag<>2
    and t1.whole_flight like '9C%'

    and t1.seats_name is not null
   and t1.seats_name not in('B','G','G1','G2','O')
   group by case when t1.flights_date>=to_date('2018-10-28','yyyy-mm-dd')
             and t1.flights_date<=to_date('2018-11-03','yyyy-mm-dd') then '换季后一周'
             when t1.flights_date>=to_date('2018-10-21','yyyy-mm-dd')
             and t1.flights_date<=to_date('2018-10-27','yyyy-mm-dd') then '换季前一周'
             end,
           case when t1.channel='手机' and t1.station_id =2 then 'M网站'
            when t1.channel='手机' and t1.station_id in(5,10) then '微信'
            when t1.channel='手机' and t1.station_id in(3,8) then 'IOS'
            when t1.channel='手机' and t1.station_id in(4,9) then 'Andriod'
            else t1.channel end ,
            case when t1.channel in('手机','网站') and t5.users_id is not null then '代理'
            else '非代理' end  ,     
            t2.area_type,                      
     t1.gender ,       
            case when getage(t1.flights_date,t1.birthday)<12 then '<12'
            when getage(t1.flights_date,t1.birthday)<18 then '12~17'
            when getage(t1.flights_date,t1.birthday)<25 then '18~24'
            when getage(t1.flights_date,t1.birthday)<30 then '25~29'
            when getage(t1.flights_date,t1.birthday)<40 then '30~39'
            when getage(t1.flights_date,t1.birthday)<50 then '40~49'
            when getage(t1.flights_date,t1.birthday)<60 then '50~59'
            when getage(t1.flights_date,t1.birthday)< 70 then '60~69'
            when getage(t1.flights_date,t1.birthday)>=70 then '70+' end 
   




    
    
   
   

    


    
