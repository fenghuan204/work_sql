select /*+parallel(8) */
h1.channel,h1.aheady,case when h1.regday<=7 then '0~7'
when h1.regday<=30 then '8~30'
when h1.regday<=60 then '31~60'
when h1.regday<=90 then '61~90'
else '90+' end regday,h1.regorder,h1.regtype,h1.passtype,h1.ttype2,h1.is_swj,h1.is_rcd,
h1.is_agent,case when age<12 then '<12'
            when age<18 then '12~17'
            when age<24 then '18~23'
            when age<30 then '24~29'
            when age<40 then '30~39'
            when age<50 then '40~49'
            when age<60 then '50~59'
            when age< 70 then '60~69'
            when age>=70 then '70+' end age,
            h1.gender,case when h1.nation in('中国','新加坡') then h1.nation
      else '其他' end nation,h1.province,h1.city,
            
           case when ticket=num1 then '独行'
                when num1> ticket and num1<>num2 then '同行带小孩'
                else '同行' end 类型, 
           case when h1.ticket< h1.num3 and   h1.flights_order_head_id=h1.wf_lc_father_id  then '去程' 
           when h1.ticket< h1.num3 and   h1.flights_order_head_id<>h1.wf_lc_father_id  then '返程'
           else '单程' end 单程与否,  
            sum(ticket),suM(price)
from(
select  t1.flights_order_id,t1.flights_order_head_id,t1.wf_lc_father_id,
decode(t1.sex,1,1,2) sex,
t1.channel,t1.segment_head_id,case when t1.ahead_days<=7 then '0~7' 
when t1.ahead_days<=30 then '8~30'
when t1.ahead_days<=60 then '31~60'
when t1.ahead_days<=90 then '61~90'
else '90+' end aheady,t1.order_day-tb1.reg_day regday,t1.order_language,
case when t1.order_day=nvl(trunc(tb2.first_orderdate),t1.order_day) then '首次购票'
else '非首次购票' end regorder,
case when tb1.is_ly=1 then '绿翼'
else '非绿翼' end regtype,
case when nvl(tb3.min_flightdate,t1.flights_date)=t1.flights_date then '首次乘机'
else '非首次乘机' end passtype,
case when t1.EX_CFD1 is not null then '绿翼'
else '非绿翼' end ttype2,
case when nvl(t1.min_seat_name,t1.seats_name)=t1.seats_name then '否'
else '是' end is_rcd,t1.is_swj,
       case when t1.channel in('手机','网站') and t5.users_id is not null then '代理'
            else '非代理' end  is_agent,
                    case WHEN t1.codetype<>1 THEN 
            CASE WHEN t1.birthday IS NOT NULL THEN 
                              floor((trunc(t1.order_day)-t1.birthday)/365)
                              ELSE NULL END 
              else getage(t1.order_day,t1.birthday)
                              END age ,
     t1.gender ,
     CASE WHEN t3.nationality='CHN' THEN '中国'
          WHEN t3.nationality IS NULL THEN '中国'
          ELSE 
          case when t6.country_name=t2.segment_country then t6.country_name
          else '其他' end END nation,
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
          ELSE NULL END city,
                    count(1) ticket,
                    sum(t1.ticket_price) price,                  
          sum(count(1))over( partition by t1.flights_order_id,t1.segment_head_id) num1,
          sum(count(1))over( partition by t1.flights_order_id,t1.segment_head_id,decode(t1.sex,1,1,2))  num2,
          sum(count(1))over(partition by t1.flights_order_id,t1.wf_lc_father_id) num3
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  left join dw.da_restrict_userinfo t5 on t1.client_id=t5.users_id
  left join dw.adt_mobile_list t8 on regexp_like(t1.r_tel, '^1[0-9]{10}$')
                              and substr(t1.r_tel, 1, 7) = t8.mobilenumber
  left join dw.adt_region_code tt1 on t1.codetype = 1
                            and tt1.regioncode=substr(t1.codeno, 1, 6)
   left join stg.s_cq_traveller_info t3 on t1.flights_order_head_id=t3.flights_order_head_id
   left join stg.s_cq_country_area t6 on t3.nationality=t6.country_code
   left join dw.da_b2c_user tb1 on t1.client_id=tb1.users_id
   left join dw.da_user_purchase tb2 on t1.client_id=tb2.users_id
   left join dw.fact_idno_statistics tb3 on t1.codeno=tb3.codeno and t1.codetype=tb3.codetype
       where t1.flights_date>=to_date('2017-10-01','yyyy-mm-dd')
    and t1.flights_date< to_date('2017-11-01','yyyy-mm-dd')
    and t2.flag<>2
    and t1.whole_flight like '9C%'
    and t2.flights_segment_name like '%浦东%'
    and t2.flights_segment_name like '%新加坡%'
    and t1.seats_name is not null
    and t1.channel in('网站','手机')
    and t1.station_id not in(2,5,10)
   and t1.seats_name not in('B','G','G1','G2','O')
    group by t1.flights_order_id,t1.flights_order_head_id,t1.wf_lc_father_id,decode(t1.sex,1,1,2) ,
t1.channel,t1.segment_head_id,case when t1.ahead_days<=7 then '0~7' 
when t1.ahead_days<=30 then '8~30'
when t1.ahead_days<=60 then '31~60'
when t1.ahead_days<=90 then '61~90'
else '90+' end ,t1.order_day-tb1.reg_day ,
case when t1.order_day=nvl(trunc(tb2.first_orderdate),t1.order_day) then '首次购票'
else '非首次购票' end ,t1.order_language,
case when tb1.is_ly=1 then '绿翼'
else '非绿翼' end ,
case when nvl(tb3.min_flightdate,t1.flights_date)=t1.flights_date then '首次乘机'
else '非首次乘机' end ,
case when t1.EX_CFD1 is not null then '绿翼'
else '非绿翼' end ,
case when nvl(t1.min_seat_name,t1.seats_name)=t1.seats_name then '否'
else '是' end,t1.is_swj,
       case when t1.channel in('手机','网站') and t5.users_id is not null then '代理'
            else '非代理' end  ,
            case WHEN t1.codetype<>1 THEN 
            CASE WHEN t1.birthday IS NOT NULL THEN 
                              floor((trunc(t1.order_day)-t1.birthday)/365)
                              ELSE NULL END 
              else getage(t1.order_day,t1.birthday)
                              END  ,
     t1.gender ,
     CASE WHEN t3.nationality='CHN' THEN '中国'
          WHEN t3.nationality IS NULL THEN '中国'
          ELSE 
          case when t6.country_name=t2.segment_country then t6.country_name
          else '其他' end END ,
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
          ELSE NULL END )h1
          group by h1.channel,h1.aheady,h1.regorder,
          case when h1.regday<=7 then '0~7'
when h1.regday<=30 then '8~30'
when h1.regday<=60 then '31~60'
when h1.regday<=90 then '61~90'
else '90+' end ,h1.regtype,h1.passtype,h1.ttype2,h1.is_swj,
h1.is_agent,case when age<12 then '<12'
            when age<18 then '12~17'
            when age<24 then '18~23'
            when age<30 then '24~29'
            when age<40 then '30~39'
            when age<50 then '40~49'
            when age<60 then '50~59'
            when age< 70 then '60~69'
            when age>=70 then '70+' end ,
            h1.gender,case when h1.nation in('中国','新加坡') then h1.nation
      else '其他' end,h1.province,h1.city,
            
           case when ticket=num1 then '独行'
                when num1> ticket and num1<>num2 then '同行带小孩'
                else '同行' end,h1.is_rcd,case when h1.ticket< h1.num3 and   h1.flights_order_head_id=h1.wf_lc_father_id  then '去程' 
           when h1.ticket< h1.num3 and   h1.flights_order_head_id<>h1.wf_lc_father_id  then '返程'
           else '单程' end
        
