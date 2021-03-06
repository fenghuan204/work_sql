select /*+parallel(4) */
to_char(t1.order_day,'yyyymmdd') 日期,t1.channel,
       case when t1.channel in('网站','手机') AND T1.GATE_NAME LIKE '%春秋商旅%' then '春秋商旅卡'
 when t1.channel in('网站','手机') AND T1.GATE_NAME LIKE '%易宝%' then '易宝'
 when t1.channel in('网站','手机') then '线上渠道'
else '其他' end 渠道,
 case when t1.channel in('网站','手机') AND t8.users_id is not null  then '代理识别'
 when t1.channel in('网站','手机') then '线上纯量'
else '其他' end 是否代理,
case
         when t4.flights_order_head_id is not null and t4.is_beneficiary = 1 then
          '受益人立减'
         when t4.flights_order_head_id is not null and t4.is_beneficiary = 0 then
          '绿翼立减'
         else
          '普通购买'
       end 立减类型,
       case when t7.flights_order_head_id is not null then '套票'
       else '非套票' end 是否套票 ,
       count(1) 票量,
     sum(t1.ticket_price) 票价
  from dw.fact_order_detail t1
   join dw.da_flight t2 on t1.segment_head_id = t2.segment_head_id
  left join dw.fact_combo_ticket t7 on t1.flights_order_head_id=t7.flights_order_head_id
  left join dw.da_restrict_userinfo t8 on t1.client_id=t8.users_id
  left join (select flights_order_head_id,
                    nvl(is_beneficiary, 0) is_beneficiary,
                    youhui_result
               from stg.c_cq_order_youhui_detail
              where product_type = 0
                and yh_ret_time is null
                and youhui_result is not null
                and youhui_id in (1129,1130, 1137,1138)
                and trunc(create_date) >= to_date('2021-03-01','yyyy-mm-dd')) t4 on t1.flights_order_head_id =
                                                              t4.flights_order_head_id
 where t1.order_day >= to_date('2021-03-01','yyyy-mm-dd')
   and t1.order_day < trunc(sysdate)
   and t1.seats_name not in('B','G','G1','G2','O')
   and t2.flag <> 2
  -- and t1.seats_name ='P2'
   and t1.flag_id in (3, 5, 40, 41)
   and t1.seats_name is not null
   and t1.whole_flight like '9C%'
 group by to_char(t1.order_day,'yyyymmdd') ,t1.channel,
      case when t1.channel in('网站','手机') AND T1.GATE_NAME LIKE '%春秋商旅%' then '春秋商旅卡'
 when t1.channel in('网站','手机') AND T1.GATE_NAME LIKE '%易宝%' then '易宝'
 when t1.channel in('网站','手机') then '线上渠道'
else '其他' end,
 case when t1.channel in('网站','手机') AND t8.users_id is not null  then '代理识别'
 when t1.channel in('网站','手机') then '线上纯量'
else '其他' end,
          case
         when t4.flights_order_head_id is not null and t4.is_beneficiary = 1 then
          '受益人立减'
         when t4.flights_order_head_id is not null and t4.is_beneficiary = 0 then
          '绿翼立减'
         else
          '普通购买'
       end ,
       case when t7.flights_order_head_id is not null then '套票'
       else '非套票' end
