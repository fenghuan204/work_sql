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
  left join (select flights_order_head_id,
                    nvl(is_beneficiary, 0) is_beneficiary,
                    youhui_result
               from cust.cq_order_youhui_detail@to_air
              where product_type = 0
                and yh_ret_time is null
                and youhui_result is not null
                and youhui_id in (1129,1130, 1137,1138)
                and create_date >= trunc(sysdate) - 8) t4 on t1.flights_order_head_id =
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
       end
