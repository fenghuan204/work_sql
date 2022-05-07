select h1.type,h1.channel,h1.is_agent,
case when age<12 then '<12'
            when age<18 then '12~17'
            when age<25 then '18~24'
            when age<30 then '25~29'
            when age<40 then '30~39'
            when age<50 then '40~49'
            when age<60 then '50~59'
            when age< 70 then '60~69'
            when age>=70 then '70+' end age,
            h1.gender,h1.nation,h1.province,h1.city,sum(ticketnum),
            sum(ticketprice),sum(price)
from(
select case when t1.order_day>=to_date('20160903','yyyymmdd') then '本周'
            when t1.order_day>=to_date('20160827','yyyymmdd') then '上周'
            else '上上周' end type,
           case when t1.channel='手机' and t1.station_id =2 then 'M网站'
            when t1.channel='手机' and t1.station_id in(5,10) then '微信'
            when t1.channel='手机' and t1.station_id in(3,8) then 'IOS'
            when t1.channel='手机' and t1.station_id in(4,9) then 'Andriod'
            else t1.channel end channel,
            case when t1.channel in('手机','网站') and t5.users_id is not null then '代理'
            else '非代理' end  is_agent,
            count(1) ticketnum,
            sum(t1.ticket_price) ticketprice,
            sum(t1.price) price,
            case WHEN t1.codetype<>1 THEN 
            CASE WHEN t1.birthday IS NOT NULL THEN 
                              floor((trunc(t1.order_day)-t1.birthday)/365)
                              ELSE NULL END 
              else getage(t1.order_day,t1.birthday)
                              END age ,
     t1.gender ,
     CASE WHEN t3.nationality='CHN' THEN '中国'
          WHEN t3.nationality IS NULL THEN '中国'
          ELSE t6.country_name END nation,
     CASE WHEN (CASE WHEN t3.nationality ='CHN' THEN '中国'
          WHEN t3.nationality IS NULL THEN '中国'
          ELSE t6.country_name END)='中国' THEN 
          CASE WHEN t8.province IS NOT NULL THEN t8.province
               WHEN t8.province IS NULL AND tt1.province IS NOT NULL THEN tt1.province
               ELSE NULL END 
          ELSE NULL END province,
      CASE WHEN (CASE WHEN t3.nationality ='CHN' THEN '中国'
          WHEN t3.nationality IS NULL THEN '中国'
          ELSE t6.country_name END)='中国' THEN 
          CASE WHEN t8.province IS NOT NULL THEN t8.city
               WHEN t8.province IS NULL AND tt1.province IS NOT NULL THEN tt1.city
               ELSE NULL END 
          ELSE NULL END city 
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  left join dw.da_restrict_userinfo t5 on t1.client_id=t5.users_id
  left join dw.adt_mobile_list t8 on regexp_like(t1.r_tel, '^1[0-9]{10}$')
                              and substr(t1.r_tel, 1, 7) = t8.mobilenumber
  left join dw.adt_region_code tt1 on t1.codetype = 1
                            and tt1.regioncode=substr(t1.codeno, 1, 6)
   left join stg.s_cq_traveller_info t3 on t1.flights_order_head_id=t3.flights_order_head_id
   left join stg.s_cq_country_area t6 on t3.nationality=t6.country_code
   
    where t1.order_day>=to_date('2016-08-20','yyyy-mm-dd')
    and t1.order_day< to_date('2016-09-10','yyyy-mm-dd')
    and t2.flag<>2
    and t1.whole_flight like '9C%'
    AND T1.NATIONFLAG ='国内'
    and t1.seats_name is not null
   and t1.seats_name not in('B','G','G1','G2','O')
    group by case when t1.order_day>=to_date('20160903','yyyymmdd') then '本周'
            when t1.order_day>=to_date('20160827','yyyymmdd') then '上周'
            else '上上周' end ,
           case when t1.channel='手机' and t1.station_id =2 then 'M网站'
            when t1.channel='手机' and t1.station_id in(5,10) then '微信'
            when t1.channel='手机' and t1.station_id in(3,8) then 'IOS'
            when t1.channel='手机' and t1.station_id in(4,9) then 'Andriod'
            else t1.channel end ,
            case when t1.channel in('手机','网站') and t5.users_id is not null then '代理'
            else '非代理' end  ,
                  case WHEN t1.codetype<>1 THEN CASE WHEN t1.birthday IS NOT NULL THEN 
                              floor((trunc(t1.order_day)-t1.birthday)/365)
                              ELSE NULL END 
                                else getage(t1.order_day,t1.birthday)
                              END  ,
     t1.gender ,
     CASE WHEN t3.nationality='CHN' THEN '中国'
          WHEN t3.nationality IS NULL THEN '中国'
          ELSE t6.country_name END ,
     CASE WHEN (CASE WHEN t3.nationality ='CHN' THEN '中国'
          WHEN t3.nationality IS NULL THEN '中国'
          ELSE t6.country_name END)='中国' THEN 
          CASE WHEN t8.province IS NOT NULL THEN t8.province
               WHEN t8.province IS NULL AND tt1.province IS NOT NULL THEN tt1.province
               ELSE NULL END 
          ELSE NULL END ,
      CASE WHEN (CASE WHEN t3.nationality ='CHN' THEN '中国'
          WHEN t3.nationality IS NULL THEN '中国'
          ELSE t6.country_name END)='中国' THEN 
          CASE WHEN t8.province IS NOT NULL THEN t8.city
               WHEN t8.province IS NULL AND tt1.province IS NOT NULL THEN tt1.city
               ELSE NULL END 
          ELSE NULL END)h1
          group by h1.type,h1.channel,h1.is_agent,
case when age<12 then '<12'
            when age<18 then '12~17'
            when age<25 then '18~24'
            when age<30 then '24~29'
            when age<40 then '30~39'
            when age<50 then '40~49'
            when age<60 then '50~59'
            when age< 70 then '60~69'
            when age>=70 then '70+' end ,
            h1.gender,h1.nation,h1.province,h1.city
