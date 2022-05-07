select trunc(t.order_date) 日期,
case when t1.seats_name in('B','G','G1','G2','O') then 'BGO'
else '非BGO' end isbgo,
       case
         when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and t.ex_nfd1 <= 1 then
          '网站'
         when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and t.ex_nfd1 = 2 then
          'm网站'
         when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and
              t.ex_nfd1 in (3, 8) then
          'IOS'
         when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and
              t.ex_nfd1 in (4, 9) then
          '安卓'
         when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and
              t.ex_nfd1 in (5, 10) then
          '微信'
         when t.web_id in(128,146,435,150) then decode(t.web_id,128,'携程',146,'同程',435,'淘宝',150,'去哪儿') 
           when t.terminal_id in
                (300, 1233, 1309, 1330, 1400, 1401, 1516, 1571, 1801, 1802, 1803, 1805, 1806, 1807, 1808, 3505) then
            '呼叫中心'
         else '其他' end,
       case
         when t.terminal_id < 0 and t.web_id = 0 and t5.users_id is not null then
          '线上自有黑代'
          when t.terminal_id < 0 and t.web_id = 0 and
              t.pay_gate =15 then
          '商旅卡'
         when t.terminal_id < 0 and t.web_id = 0 and
              t.pay_gate in ( 29, 31) then
          '易宝支付'
         when t.terminal_id < 0 and t.web_id = 0 then
          '线上纯量'
          when t.web_id in(128,146,435,150) then decode(t.web_id,128,'携程',146,'同程',435,'淘宝',150,'去哪儿') 
            when t.terminal_id in
                (300, 1233, 1309, 1330, 1400, 1401, 1516, 1571, 1801, 1802, 1803, 1805, 1806, 1807, 1808, 3505) then
            '呼叫中心'
         else '其他' end,
           case
         when t4.flights_order_head_id is not null and t4.is_beneficiary = 1 then
          '受益人立减'
         when t4.flights_order_head_id is not null and t4.is_beneficiary = 0 then
          '绿翼立减'
         else
          '普通购买'
       end,
       count(1) 票量
  from cqsale.cq_order@to_air t
  join cqsale.cq_order_head@to_air t1 on t.flights_order_id =t1.flights_order_id
  join dw.da_flight t2 on t1.segment_head_id = t2.segment_head_id
  left join dw.da_restrict_userinfo t5 on t.client_id = t5.users_id
  left join (select t1.flights_order_head_id,
                    nvl(t1.is_beneficiary, 0) is_beneficiary,
                    t1.youhui_result
               from cust.cq_order_youhui_detail@to_air t1
               join cust.cq_youhui_policy_main@to_air t2 on t1.youhui_id=t2.id
              where t1.product_type = 0
                and t1.yh_ret_time is null
                and t1.youhui_result is not null
                and t2.YH_STYLE=2
                and t1.create_date >= trunc(sysdate) - 8) t4 on t1.flights_order_head_id =
                                                              t4.flights_order_head_id
 where t.order_date>= trunc(sysdate)-8
   and t.order_date < sysdate
   --and to_char(t.order_date,'hh24:mi')< '15:11'
   and t1.r_flights_date >= trunc(sysdate)-8-7
   and t2.flag <> 2
   --and trunc(t.order_date) in(trunc(sysdate),trunc(sysdate)-7,trunc(sysdate)-1)
   and t1.flag_id in (3, 5, 40, 41)
   and t1.seats_name is not null
   and t1.whole_flight like '9C%'
 group by trunc(t.order_date) ,
 case when t1.seats_name in('B','G','G1','G2','O') then 'BGO'
else '非BGO' end,
       case
         when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and t.ex_nfd1 <= 1 then
          '网站'
         when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and t.ex_nfd1 = 2 then
          'm网站'
         when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and
              t.ex_nfd1 in (3, 8) then
          'IOS'
         when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and
              t.ex_nfd1 in (4, 9) then
          '安卓'
         when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and
              t.ex_nfd1 in (5, 10) then
          '微信'
        when t.web_id in(128,146,435,150) then decode(t.web_id,128,'携程',146,'同程',435,'淘宝',150,'去哪儿') 
          when t.terminal_id in
                (300, 1233, 1309, 1330, 1400, 1401, 1516, 1571, 1801, 1802, 1803, 1805, 1806, 1807, 1808, 3505) then
            '呼叫中心'
         else '其他' end,
       case
         when t.terminal_id < 0 and t.web_id = 0 and t5.users_id is not null then
          '线上自有黑代'
          when t.terminal_id < 0 and t.web_id = 0 and
              t.pay_gate =15 then
          '商旅卡'
         when t.terminal_id < 0 and t.web_id = 0 and
              t.pay_gate in ( 29, 31) then
          '易宝支付'
         when t.terminal_id < 0 and t.web_id = 0 then
          '线上纯量'
         when t.web_id in(128,146,435,150) then decode(t.web_id,128,'携程',146,'同程',435,'淘宝',150,'去哪儿') 
           when t.terminal_id in
                (300, 1233, 1309, 1330, 1400, 1401, 1516, 1571, 1801, 1802, 1803, 1805, 1806, 1807, 1808, 3505) then
            '呼叫中心'
         else '其他' end,
       case
         when t4.flights_order_head_id is not null and t4.is_beneficiary = 1 then
          '受益人立减'
         when t4.flights_order_head_id is not null and t4.is_beneficiary = 0 then
          '绿翼立减'
         else
          '普通购买'
       end;


---============================================================实时提前期/年龄/性别

 select h1.orderday,h1.r_flights_date,
case when h1.aheads<=7 then to_char(h1.aheads)
when h1.aheads<=15 then '8~15'
when h1.aheads<=30 then '15~30'
when h1.aheads<=45 then '31~45'
when h1.aheads<=60 then '45~60'
ELSE '60+' END aheads,h1.flights_segment_name,h1.origincity_name,h1.destcity_name,
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
            sum(ticketprice)
from(
select trunc(t.order_date) orderday,
t1.r_flights_date-trunc(t.order_date) aheads,
t1.r_flights_date,
t2.flights_segment_name,
t2.origincity_name,
t2.destcity_name,
            case WHEN t1.codetype<>1 THEN 
            CASE WHEN t1.birthday IS NOT NULL THEN 
                              floor((trunc(t.order_date)-t1.birthday)/365)
                              ELSE NULL END 
              else getage(t.order_date,t1.birthday)
                              END age ,
     t3.gender ,
     CASE WHEN t3.nationality='CHN' THEN '中国'
          WHEN t3.nationality IS NULL THEN '中国'
          ELSE t6.country_name END nation,
     CASE WHEN (CASE WHEN t3.nationality ='CHN' THEN '中国'
          WHEN t3.nationality IS NULL THEN '中国'
          ELSE t6.country_name END)='中国' THEN 
          CASE WHEN tt1.province IS NOT NULL THEN tt1.province
               WHEN tt1.province IS NULL AND t8.province IS NOT NULL THEN t8.province
               ELSE NULL END 
          ELSE NULL END province,
      CASE WHEN (CASE WHEN t3.nationality ='CHN' THEN '中国'
          WHEN t3.nationality IS NULL THEN '中国'
          ELSE t6.country_name END)='中国' THEN 
          CASE WHEN tt1.province IS NOT NULL THEN tt1.city
               WHEN tt1.province IS NULL AND t8.province IS NOT NULL THEN t8.city
               ELSE NULL END 
          ELSE NULL END city,
                      count(1) ticketnum,
            sum(t1.ticket_price) ticketprice
  from cqsale.cq_order@to_air t
  join cqsale.cq_order_HEAD@TO_AIR t1 on t.flights_order_id=t1.flights_order_id
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  left join dw.da_restrict_userinfo t5 on t.client_id=t5.users_id
  left join dw.adt_mobile_list t8 on regexp_like(t1.r_tel, '^1[0-9]{10}$')
                              and substr(t1.r_tel, 1, 7) = t8.mobilenumber
  left join dw.adt_region_code tt1 on t1.codetype = 1
                            and tt1.regioncode=substr(t1.codeno, 1, 6)
   left join cqsale.cq_traveller_info@to_air t3 on t1.flights_order_head_id=t3.flights_order_head_id
   left join stg.s_cq_country_area t6 on t3.nationality=t6.country_code
   
    where t.order_date>=to_date('2021-05-09','yyyy-mm-dd')
    and t.order_date< sysdate
    and t.order_date< to_date('2021-05-11 13:30','yyyy-mm-dd hh24:mi')
    and t2.flag<>2
    and t1.whole_flight like '9C%'
      and t1.seats_name is not null
    and t1.seats_name not in('B','G','G1','G2','O')
    and t1.seats_name ='P2'
    and t1.flag_id in(3,5,40,2)
    group by trunc(t.order_date) ,
t1.r_flights_date-trunc(t.order_date) ,
t2.flights_segment_name,
t2.origincity_name,
t2.destcity_name,
            case WHEN t1.codetype<>1 THEN 
            CASE WHEN t1.birthday IS NOT NULL THEN 
                              floor((trunc(t.order_date)-t1.birthday)/365)
                              ELSE NULL END 
              else getage(t.order_date,t1.birthday)
                              END  ,
     t3.gender ,
     CASE WHEN t3.nationality='CHN' THEN '中国'
          WHEN t3.nationality IS NULL THEN '中国'
          ELSE t6.country_name END ,
      CASE WHEN (CASE WHEN t3.nationality ='CHN' THEN '中国'
          WHEN t3.nationality IS NULL THEN '中国'
          ELSE t6.country_name END)='中国' THEN 
          CASE WHEN tt1.province IS NOT NULL THEN tt1.province
               WHEN tt1.province IS NULL AND t8.province IS NOT NULL THEN t8.province
               ELSE NULL END 
          ELSE NULL END ,
      CASE WHEN (CASE WHEN t3.nationality ='CHN' THEN '中国'
          WHEN t3.nationality IS NULL THEN '中国'
          ELSE t6.country_name END)='中国' THEN 
          CASE WHEN tt1.province IS NOT NULL THEN tt1.city
               WHEN tt1.province IS NULL AND t8.province IS NOT NULL THEN t8.city
               ELSE NULL END 
          ELSE NULL END ,t1.r_flights_date)h1
          group by h1.orderday,case when h1.aheads<=7 then to_char(h1.aheads)
when h1.aheads<=15 then '8~15'
when h1.aheads<=30 then '15~30'
when h1.aheads<=45 then '31~45'
when h1.aheads<=60 then '45~60'
ELSE '60+' END,h1.flights_segment_name,h1.origincity_name,h1.destcity_name,
case when age<12 then '<12'
            when age<18 then '12~17'
            when age<25 then '18~24'
            when age<30 then '25~29'
            when age<40 then '30~39'
            when age<50 then '40~49'
            when age<60 then '50~59'
            when age< 70 then '60~69'
            when age>=70 then '70+' end ,
h1.gender,h1.nation,h1.province,h1.city,h1.r_flights_date;



------------------------修改一下添加产品类型------------------


select trunc(t.order_date) 日期,
case when t1.seats_name in('B','G','G1','G2','O') then 'BGO'
else '非BGO' end isbgo,
       case
         when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and t.ex_nfd1 <= 1 then
          '网站'
         when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and t.ex_nfd1 = 2 then
          'm网站'
         when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and
              t.ex_nfd1 in (3, 8) then
          'IOS'
         when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and
              t.ex_nfd1 in (4, 9) then
          '安卓'
         when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and
              t.ex_nfd1 in (5, 10) then
          '微信'
         when t.web_id in(128,146,435,150) then decode(t.web_id,128,'携程',146,'同程',435,'淘宝',150,'去哪儿') 
           when t.terminal_id in
                (300, 1233, 1309, 1330, 1400, 1401, 1516, 1571, 1801, 1802, 1803, 1805, 1806, 1807, 1808, 3505) then
            '呼叫中心'
         else '其他' end,
       case
         when t.terminal_id < 0 and t.web_id = 0 and t5.users_id is not null then
          '线上自有黑代'
          when t.terminal_id < 0 and t.web_id = 0 and
              t.pay_gate =15 then
          '商旅卡'
         when t.terminal_id < 0 and t.web_id = 0 and
              t.pay_gate in ( 29, 31) then
          '易宝支付'
         when t.terminal_id < 0 and t.web_id = 0 then
          '线上纯量'
          when t.web_id in(128,146,435,150) then decode(t.web_id,128,'携程',146,'同程',435,'淘宝',150,'去哪儿') 
            when t.terminal_id in
                (300, 1233, 1309, 1330, 1400, 1401, 1516, 1571, 1801, 1802, 1803, 1805, 1806, 1807, 1808, 3505) then
            '呼叫中心'
         else '其他' end,
           case
         when t4.flights_order_head_id is not null and t4.is_beneficiary = 1 then
          '受益人立减'
         when t4.flights_order_head_id is not null and t4.is_beneficiary = 0 then
          '绿翼立减'
         else
          '普通购买'
       end,
       CASE
           WHEN t1.ex_nfd3 IS NOT NULL AND t1.ex_cfd2 = 'S' THEN
            '商务经济座'
           when t7.set_name is not null then t7.set_name

           ELSE
            '会员专享座'
         END,
              
       
       count(1) 票量
  from cqsale.cq_order@to_air t
  join cqsale.cq_order_head@to_air t1 on t.flights_order_id =t1.flights_order_id
  join dw.da_flight t2 on t1.segment_head_id = t2.segment_head_id
  left join dw.da_restrict_userinfo t5 on t.client_id = t5.users_id
  left join (select t1.flights_order_head_id,
                    nvl(t1.is_beneficiary, 0) is_beneficiary,
                    t1.youhui_result
               from cust.cq_order_youhui_detail@to_air t1
               join cust.cq_youhui_policy_main@to_air t2 on t1.youhui_id=t2.id
              where t1.product_type = 0
                and t1.yh_ret_time is null
                and t1.youhui_result is not null
                and t2.YH_STYLE=2
                and t1.create_date >= trunc(sysdate) - 8) t4 on t1.flights_order_head_id =
                                                              t4.flights_order_head_id
   left join cqsale.cq_order_comb_info@to_air t6 on t6.status=1 and t1.flights_order_head_id=t6.order_head_id
   left join dw.dim_comb_product t7 on t7.comb_type=t1.ex_cfd10 and t7.id=nvl(t6.comb_id,1) 
 where t.order_date>= trunc(sysdate)-8
   and t.order_date < sysdate
   --and to_char(t.order_date,'hh24:mi')< '15:11'
   and t1.r_flights_date >= trunc(sysdate)-8-7
   and t2.flag <> 2
   --and trunc(t.order_date) in(trunc(sysdate),trunc(sysdate)-7,trunc(sysdate)-1)
   and t1.flag_id in (3, 5, 40, 41)
   and t1.seats_name is not null
   and t1.whole_flight like '9C%'
 group by trunc(t.order_date) ,
 case when t1.seats_name in('B','G','G1','G2','O') then 'BGO'
else '非BGO' end,
       case
         when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and t.ex_nfd1 <= 1 then
          '网站'
         when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and t.ex_nfd1 = 2 then
          'm网站'
         when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and
              t.ex_nfd1 in (3, 8) then
          'IOS'
         when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and
              t.ex_nfd1 in (4, 9) then
          '安卓'
         when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and
              t.ex_nfd1 in (5, 10) then
          '微信'
        when t.web_id in(128,146,435,150) then decode(t.web_id,128,'携程',146,'同程',435,'淘宝',150,'去哪儿') 
          when t.terminal_id in
                (300, 1233, 1309, 1330, 1400, 1401, 1516, 1571, 1801, 1802, 1803, 1805, 1806, 1807, 1808, 3505) then
            '呼叫中心'
         else '其他' end,
       case
         when t.terminal_id < 0 and t.web_id = 0 and t5.users_id is not null then
          '线上自有黑代'
          when t.terminal_id < 0 and t.web_id = 0 and
              t.pay_gate =15 then
          '商旅卡'
         when t.terminal_id < 0 and t.web_id = 0 and
              t.pay_gate in ( 29, 31) then
          '易宝支付'
         when t.terminal_id < 0 and t.web_id = 0 then
          '线上纯量'
         when t.web_id in(128,146,435,150) then decode(t.web_id,128,'携程',146,'同程',435,'淘宝',150,'去哪儿') 
           when t.terminal_id in
                (300, 1233, 1309, 1330, 1400, 1401, 1516, 1571, 1801, 1802, 1803, 1805, 1806, 1807, 1808, 3505) then
            '呼叫中心'
         else '其他' end,
       case
         when t4.flights_order_head_id is not null and t4.is_beneficiary = 1 then
          '受益人立减'
         when t4.flights_order_head_id is not null and t4.is_beneficiary = 0 then
          '绿翼立减'
         else
          '普通购买'
       end,CASE
           WHEN t1.ex_nfd3 IS NOT NULL AND t1.ex_cfd2 = 'S' THEN
            '商务经济座'
           when t7.set_name is not null then t7.set_name

           ELSE
            '会员专享座'
         END;

--====================================================20210812实时销售监控=============================================================================

----

select trunc(t.order_date) 日期,
case when t1.seats_name in('B','G','G1','G2','O') then 'BGO'
else '非BGO' end isbgo,
       case
         when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and t.ex_nfd1 <= 1 then
          '网站'
         when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and t.ex_nfd1 = 2 then
          'm网站'
         when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and
              t.ex_nfd1 in (3, 8) then
          'IOS'
         when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and
              t.ex_nfd1 in (4, 9) then
          '安卓'
         when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and
              t.ex_nfd1 in (5, 10) then
          '微信'
         when t.web_id in(128,146,435,150) then decode(t.web_id,128,'携程',146,'同程',435,'淘宝',150,'去哪儿') 
           when t.terminal_id in
                (300, 1233, 1309, 1330, 1400, 1401, 1516, 1571, 1801, 1802, 1803, 1805, 1806, 1807, 1808, 3505) then
            '呼叫中心'
         else '其他' end,
       case
         when t.terminal_id < 0 and t.web_id = 0 and t5.users_id is not null then
          '线上自有黑代'
          when t.terminal_id < 0 and t.web_id = 0 and
              t.pay_gate =15 then
          '商旅卡'
         when t.terminal_id < 0 and t.web_id = 0 and
              t.pay_gate in ( 29, 31) then
          '易宝支付'
         when t.terminal_id < 0 and t.web_id = 0 then
          '线上纯量'
          when t.web_id in(128,146,435,150) then decode(t.web_id,128,'携程',146,'同程',435,'淘宝',150,'去哪儿') 
            when t.terminal_id in
                (300, 1233, 1309, 1330, 1400, 1401, 1516, 1571, 1801, 1802, 1803, 1805, 1806, 1807, 1808, 3505) then
            '呼叫中心'
         else '其他' end,
           case
         when t4.flights_order_head_id is not null and t4.is_beneficiary = 1 then
          '受益人立减'
         when t4.flights_order_head_id is not null and t4.is_beneficiary = 0 then
          '绿翼立减'
         else
          '普通购买'
       end,
       CASE
           WHEN t1.ex_nfd3 IS NOT NULL AND t1.ex_cfd2 = 'S' THEN
            '商务经济座'
           when t7.set_name is not null then t7.set_name

           ELSE
            '会员专享座'
         END,             
       
       count(1) 票量
  from cqsale.cq_order@to_air t
  join cqsale.cq_order_head@to_air t1 on t.flights_order_id =t1.flights_order_id
  join dw.da_flight t2 on t1.segment_head_id = t2.segment_head_id
  left join dw.da_restrict_userinfo t5 on t.client_id = t5.users_id
  left join (select t1.flights_order_head_id,
                    nvl(t1.is_beneficiary, 0) is_beneficiary,
                    t1.youhui_result
               from cust.cq_order_youhui_detail@to_air t1
               join cust.cq_youhui_policy_main@to_air t2 on t1.youhui_id=t2.id
              where t1.product_type = 0
                and t1.yh_ret_time is null
                and t1.youhui_result is not null
                and t2.YH_STYLE=2
                and t1.create_date >= trunc(sysdate) - 2) t4 on t1.flights_order_head_id =
                                                              t4.flights_order_head_id
   left join cqsale.cq_order_comb_info@to_air t6 on t6.status=1 and t1.flights_order_head_id=t6.order_head_id
   left join dw.dim_comb_product t7 on t7.type_id=t1.ex_cfd10 and t7.id=nvl(t6.comb_id,1) 
 where t.order_date>= trunc(sysdate)-1
   and t.order_date < sysdate
  -- and to_char(t.order_date,'hh24:mi')< '${shour}'
   and t1.r_flights_date >= trunc(sysdate)-2
   and t2.flag <> 2
   and t1.flag_id in (3, 5, 40, 41)
   and t1.seats_name is not null
   and t1.whole_flight like '9C%'
 group by trunc(t.order_date) ,
 case when t1.seats_name in('B','G','G1','G2','O') then 'BGO'
else '非BGO' end,
       case
         when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and t.ex_nfd1 <= 1 then
          '网站'
         when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and t.ex_nfd1 = 2 then
          'm网站'
         when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and
              t.ex_nfd1 in (3, 8) then
          'IOS'
         when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and
              t.ex_nfd1 in (4, 9) then
          '安卓'
         when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and
              t.ex_nfd1 in (5, 10) then
          '微信'
        when t.web_id in(128,146,435,150) then decode(t.web_id,128,'携程',146,'同程',435,'淘宝',150,'去哪儿') 
          when t.terminal_id in
                (300, 1233, 1309, 1330, 1400, 1401, 1516, 1571, 1801, 1802, 1803, 1805, 1806, 1807, 1808, 3505) then
            '呼叫中心'
         else '其他' end,
       case
         when t.terminal_id < 0 and t.web_id = 0 and t5.users_id is not null then
          '线上自有黑代'
          when t.terminal_id < 0 and t.web_id = 0 and
              t.pay_gate =15 then
          '商旅卡'
         when t.terminal_id < 0 and t.web_id = 0 and
              t.pay_gate in ( 29, 31) then
          '易宝支付'
         when t.terminal_id < 0 and t.web_id = 0 then
          '线上纯量'
         when t.web_id in(128,146,435,150) then decode(t.web_id,128,'携程',146,'同程',435,'淘宝',150,'去哪儿') 
           when t.terminal_id in
                (300, 1233, 1309, 1330, 1400, 1401, 1516, 1571, 1801, 1802, 1803, 1805, 1806, 1807, 1808, 3505) then
            '呼叫中心'
         else '其他' end,
       case
         when t4.flights_order_head_id is not null and t4.is_beneficiary = 1 then
          '受益人立减'
         when t4.flights_order_head_id is not null and t4.is_beneficiary = 0 then
          '绿翼立减'
         else
          '普通购买'
       end,CASE
           WHEN t1.ex_nfd3 IS NOT NULL AND t1.ex_cfd2 = 'S' THEN
            '商务经济座'
           when t7.set_name is not null then t7.set_name

           ELSE
            '会员专享座'
         END;
