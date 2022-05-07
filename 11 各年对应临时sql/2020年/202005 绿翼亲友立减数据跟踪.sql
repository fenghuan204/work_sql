select t1.order_day 日期,
       case
         when t1.terminal_id < 0 and nvl(t1.web_id, 0) = 0 and t1.station_id <= 1 then
          '网站'
         when t1.terminal_id < 0 and nvl(t1.web_id, 0) = 0 and t1.station_id = 2 then
          'm网站'
         when t1.terminal_id < 0 and nvl(t1.web_id, 0) = 0 and
              t1.station_id in (3, 8) then
          'ios'
         when t1.terminal_id < 0 and nvl(t1.web_id, 0) = 0 and
              t1.station_id in (4, 9) then
          '安卓'
         when t1.terminal_id < 0 and nvl(t1.web_id, 0) = 0 and
              t1.station_id in (5, 10) then
          '微信'
         else
          '其他'
       end 终端,
       case
         when t1.terminal_id < 0 and t1.web_id = 0 and t6.users_id is not null then
          '线上自有黑代'
         when t1.terminal_id < 0 and t1.web_id = 0 and
              t1.pay_gate in (15, 29, 31) then
          '线上自有易宝商旅卡'
         when t1.terminal_id < 0 and t1.web_id = 0 and t5.users_id is not null then
          '线上自有黑代2' 
         when t1.terminal_id < 0 and t1.web_id = 0 then
          '线上纯量'
         else
          '其他'
       end 渠道分类,
       case
         when t4.flights_order_head_id is not null and t4.is_beneficiary = 1 then
          '受益人立减'
         when t4.flights_order_head_id is not null and t4.is_beneficiary = 0 then
          '绿翼立减'
         else
          '普通购买'
       end 立减类型,
       count(1) 票量
  from dw.fact_order_detail t1
   join dw.da_flight t2 on t1.segment_head_id = t2.segment_head_id
  left join dw.da_restrict_userinfo@to_ods t5 on t1.client_id = t5.users_id
  left join dw.da_restrict_userinfo t6 on t1.client_id=t6.users_id
  left join (select flights_order_head_id,
                    nvl(is_beneficiary, 0) is_beneficiary,
                    youhui_result
               from stg.c_cq_order_youhui_detail
              where product_type = 0
                and yh_ret_time is null
                and youhui_result is not null
                and youhui_id in (1129,1130, 1137,1138)
                and trunc(create_date) >= trunc(sysdate) - 60) t4 on t1.flights_order_head_id =
                                                              t4.flights_order_head_id
 where t1.order_day >= trunc(sysdate) - 32
   and t1.order_day < sysdate
   and t1.flights_date >= trunc(sysdate - 32) - 7
   and t2.flag <> 2
   and t1.flag_id in (3, 5, 40, 41)
   and t1.seats_name is not null
   and t1.whole_flight like '9C%'
 group by t1.order_day,
       case
         when t1.terminal_id < 0 and nvl(t1.web_id, 0) = 0 and t1.station_id <= 1 then
          '网站'
         when t1.terminal_id < 0 and nvl(t1.web_id, 0) = 0 and t1.station_id = 2 then
          'm网站'
         when t1.terminal_id < 0 and nvl(t1.web_id, 0) = 0 and
              t1.station_id in (3, 8) then
          'ios'
         when t1.terminal_id < 0 and nvl(t1.web_id, 0) = 0 and
              t1.station_id in (4, 9) then
          '安卓'
         when t1.terminal_id < 0 and nvl(t1.web_id, 0) = 0 and
              t1.station_id in (5, 10) then
          '微信'
         else
          '其他'
       end,
       case
         when t1.terminal_id < 0 and t1.web_id = 0 and t6.users_id is not null then
          '线上自有黑代'
         when t1.terminal_id < 0 and t1.web_id = 0 and
              t1.pay_gate in (15, 29, 31) then
          '线上自有易宝商旅卡'
         when t1.terminal_id < 0 and t1.web_id = 0 and t5.users_id is not null then
          '线上自有黑代2' 
         when t1.terminal_id < 0 and t1.web_id = 0 then
          '线上纯量'
         else
          '其他'
       end,
       case
         when t4.flights_order_head_id is not null and t4.is_beneficiary = 1 then
          '受益人立减'
         when t4.flights_order_head_id is not null and t4.is_beneficiary = 0 then
          '绿翼立减'
         else
          '普通购买'
       end
