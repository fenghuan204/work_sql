select trunc(t.order_date) 日期,
       case
         when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and t.ex_nfd1 <= 1 then
          '网站'
         when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and t.ex_nfd1 = 2 then
          'm网站'
         when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and
              t.ex_nfd1 in (3, 8) then
          'ios'
         when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and
              t.ex_nfd1 in (4, 9) then
          '安卓'
         when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and
              t.ex_nfd1 in (5, 10) then
          '微信'
         else
          '其他'
       end 渠道,
       case
         when t.terminal_id < 0 and t.web_id = 0 and t5.users_id is not null then
          '线上自有黑代'
         when t.terminal_id < 0 and t.web_id = 0 and
              t.pay_gate in (15, 29, 31) then
          '线上自有易宝商旅卡'
         when t.terminal_id < 0 and t.web_id = 0 then
          '线上纯量'
         else
          '其他'
       end 代理与否,
       case
         when t4.flights_order_head_id is not null and nvl(t4.is_beneficiary,0) = 1 then
          '受益人立减'
         when t4.flights_order_head_id is not null and nvl(t4.is_beneficiary,0) = 0 then
          '绿翼立减'
         else
          '普通购买'
       end 立减类型,
       case when t6.flights_order_head_id is not null then '套票'
       else '非套票' end 是否套票,
       count(1) 票量
  from stg.s_cq_order t
  join stg.s_cq_order_head t1 on t.flights_order_id =t1.flights_order_id
  join dw.da_flight t2 on t1.segment_head_id = t2.segment_head_id
  left join dw.da_restrict_userinfo t5 on t.client_id = t5.users_id
  left join (select t1.flights_order_head_id,
                    nvl(t1.is_beneficiary, 0) is_beneficiary,
                    t1.youhui_result
               from stg.c_cq_order_youhui_detail t1
               join stg.c_cq_youhui_policy_main t2 on t1.youhui_id=t2.id
              where t1.product_type = 0
                and t1.yh_ret_time is null
                and t1.youhui_result is not null
                and t2.YH_STYLE=2
                and t1.create_date >= trunc(sysdate) - 30) t4 on t1.flights_order_head_id =
                                                              t4.flights_order_head_id
  left join dw.fact_combo_ticket t6 on t1.flights_order_head_id=t6.flights_order_head_id
 where t.order_date >= trunc(sysdate) - 7
   and t.order_date < trunc(sysdate)
   and t1.r_flights_date >= trunc(sysdate - 7) - 7
   and t2.flag <> 2
   --and t1.flights_order_head_id='297348040'
   and t1.flag_id in (3, 5, 40, 41)
   and t1.seats_name is not null
   and t1.whole_flight like '9C%'
 group by trunc(t.order_date),
          case
            when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and
                 t.ex_nfd1 <= 1 then
             '网站'
            when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and
                 t.ex_nfd1 = 2 then
             'm网站'
            when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and
                 t.ex_nfd1 in (3, 8) then
             'ios'
            when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and
                 t.ex_nfd1 in (4, 9) then
             '安卓'
            when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and
                 t.ex_nfd1 in (5, 10) then
             '微信'
            else
             '其他'
          end,
          case
            when t.terminal_id < 0 and t.web_id = 0 and
                 t5.users_id is not null then
             '线上自有黑代'
            when t.terminal_id < 0 and t.web_id = 0 and
                 t.pay_gate in (15, 29, 31) then
             '线上自有易宝商旅卡'
            when t.terminal_id < 0 and t.web_id = 0 then
             '线上纯量'
            else
             '其他'
          end,
           case
         when t4.flights_order_head_id is not null and nvl(t4.is_beneficiary,0) = 1 then
          '受益人立减'
         when t4.flights_order_head_id is not null and nvl(t4.is_beneficiary,0) = 0 then
          '绿翼立减'
         else
          '普通购买'
       end ,
               case when t6.flights_order_head_id is not null then '套票'
       else '非套票' end
