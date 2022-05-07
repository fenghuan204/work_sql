select /*c.channel, */case when t.terminal_id<0 and t.web_id=0 and t2.users_id is not null then '代理'
else '非代理' end,count(1)/sum(count(1))over(partition by 1)
  from cqsale.cq_order@to_air t
  join cqsale.cq_order_head@to_air t1 on t.flights_order_id=t1.flights_order_id
  left join dw.da_restrict_userinfo t2 on t.client_Id=t2.users_id
  left join dw.da_channel_part c on c.terminal_id = t.terminal_id
                                and c.web_id = nvl(t.web_id, 0)
                                and c.station_id =
                                    (case when t.terminal_id < 0 and
                                     nvl(t.ex_nfd1, 0) <= 1 then 1 else
                                     nvl(t.ex_nfd1, 0) end)
                                and t.order_date >= c.sdate
                                and t.order_date < c.edate + 2
                                
              where t.order_date>=trunc(sysdate)
              and t1.whole_flight like '9C%'
              and t1.flag_id in(3,5,40)
              and t1.seats_name not in('B','G','G1','G2','O')
              group by /*c.channel,*/ case when t.terminal_id<0 and t.web_id=0 and t2.users_id is not null then '代理'
else '非代理' end;


===========================================实时绿翼立减数据=========================================

select trunc(t.order_date) 日期,
       case when to_char(t.order_date,'hh24:mi')>='10:00' then '10点以后'
       else '其他时间' end,
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
       end,
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
       end,
       case
         when t4.flights_order_head_id is not null and t4.is_beneficiary = 1 then
          '受益人立减'
         when t4.flights_order_head_id is not null and t4.is_beneficiary = 0 then
          '绿翼立减'
         else
          '普通购买'
       end,
       t4.youhui_result,
       case when t6.flights_order_head_id is not null then '套票'
       else '非套票' end 是否套票,
       case when t1.flag_id in(7,11,12) then '退票'
       else '已支付' end 机票状态,
       count(1) 票量
  from cqsale.cq_order@to_air t
  join cqsale.cq_order_head@to_air t1 on t.flights_order_id =t1.flights_order_id
  join dw.da_flight t2 on t1.segment_head_id = t2.segment_head_id
  left join dw.da_restrict_userinfo t5 on t.client_id = t5.users_id
  left join dw.fact_combo_ticket t6 on t1.flights_order_head_id=t6.flights_order_head_id
  left join (select t1.flights_order_head_id,
                    nvl(t1.is_beneficiary, 0) is_beneficiary,
                    t1.youhui_result
               from cust.cq_order_youhui_detail@to_air t1
               join cust.cq_youhui_policy_main@to_air t2 on t1.youhui_id=t2.id
              where t1.product_type = 0
                and t1.yh_ret_time is null
                and t1.youhui_result is not null
                and t2.YH_STYLE=2
                and t1.create_date >= trunc(sysdate) - 30) t4 on t1.flights_order_head_id =
                                                              t4.flights_order_head_id
 where t.order_date >= trunc(sysdate) - 7
   and t.order_date < sysdate
   and t1.r_flights_date >= trunc(sysdate - 7) - 7
   and t2.flag <> 2
   and to_char(t.order_date,'hh24:mi')<='15:17'
   and t1.flag_id in (3, 5, 40, 41,7,11,12)
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
            when t4.flights_order_head_id is not null and
                 t4.is_beneficiary = 1 then
             '受益人立减'
            when t4.flights_order_head_id is not null and
                 t4.is_beneficiary = 0 then
             '绿翼立减'
            else
             '普通购买'
          end,
          t4.youhui_result,
          case when t6.flights_order_head_id is not null then '套票'
       else '非套票' end,     case when t1.flag_id in(7,11,12) then '退票'
       else '已支付' end,
        case when to_char(t.order_date,'hh24:mi')>='10:00' then '10点以后'
       else '其他时间' end;
		  
-------------------------------历史数据------------------------------------------------------------------------------

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
       end,
       case
         when t1.terminal_id < 0 and t1.web_id = 0 and t5.users_id is not null then
          '线上自有黑代'
         when t1.terminal_id < 0 and t1.web_id = 0 and
              t1.pay_gate in (15, 29, 31) then
          '线上自有易宝商旅卡'
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
       end,
       count(1) 票量
  from dw.fact_order_detail t1
   join dw.da_flight t2 on t1.segment_head_id = t2.segment_head_id
  left join dw.da_restrict_userinfo t5 on t1.client_id = t5.users_id
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
 where t1.order_day >= trunc(sysdate) - 7
   and t1.order_day < sysdate
   and t1.flights_date >= trunc(sysdate - 7) - 7
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
         when t1.terminal_id < 0 and t1.web_id = 0 and t5.users_id is not null then
          '线上自有黑代'
         when t1.terminal_id < 0 and t1.web_id = 0 and
              t1.pay_gate in (15, 29, 31) then
          '线上自有易宝商旅卡'
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


 =================================================


select trunc(t.order_date) 日期,to_char(t.order_date,'hh24') 时刻,
case
         when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and
              t.ex_nfd1 in (3, 8) then
          'IOS'
         when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and
              t.ex_nfd1 in (4, 9) then
          '安卓'
         when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and
              t.ex_nfd1 in (5, 10) then
          '微信'
         when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and
              t.ex_nfd1=2 then
          'M网站'
         when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and t.ex_nfd1 = 6 then
          '智能客服'
         when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and
              nvl(t.ex_nfd1, 0) <= 1 then
          '网站'
         when t.web_id > 0 and t4.abrv like '%TMC%' then
          'B2G机构客户'
         when t.web_id > 0 and t4.abrv like '%航信%' then
          'B2B代理'
         when t.terminal_id = 3714 then
          'B2B代理'
         when t.terminal_id < 0 and
              t.web_id in (240, 242, 312, 375, 1810, 2505, 3334, 3714) then
          'B2B代理'
         when t.web_id > 0 and
              regexp_like(t4.abrv,
                          '(CAACSC)|(阿斯兰)|(宝钢国旅)|(95524)|(机构客户)|(集团客户)|(特航商旅)|(杭州万途)|(上海趣卫)') then
          'B2G机构客户'
         when t.terminal_id > 0 and
              regexp_like(t3.terminal,
                          '(CAACSC)|(阿斯兰)|(宝钢国旅)|(95524)|(机构客户)|(集团客户)|(特航商旅)|(杭州万途)|(上海趣卫)') then
          'B2G机构客户'
         when t.terminal_id in
              (300, 1233, 1309, 1330, 1400, 1401, 1516, 1571, 1801, 1802, 1803, 1805, 1806, 1807, 1808, 3505) then
          '呼叫中心'
         when t.terminal_id < 0 and nvl(t.web_id, 0) > 0 then
          decode(t4.agent_type,
                 1,
                 'OTA',
                 2,
                 'B2B代理',
                 4,
                 'CPS',
                 5,
                 'B2G机构客户')
         when nvl(t.web_id, 0) > 0 and t4.agent_type is null then
          'B2B'
         else
          'B2B'
       end 渠道分类1,
       case
         when t.terminal_id < 0 and t.web_id = 0 and t5.users_id is not null then
          '黑代'
         when t.terminal_id < 0 and t.web_id = 0 and
              t.pay_gate in (15, 29, 31) then
          '易宝商旅卡'
         when t.terminal_id < 0 and t.web_id = 0 then
          '线上自有'
         when t4.abrv in ('携程', '同程', '去哪儿', '淘宝') then
          t4.abrv
         else
          '其他'
       end 渠道分类2,
	   case when t.terminal_id < 0 and t.web_id = 0 and t6.users_id is not null then
          '黑代'
		  else '非黑代' end 渠道分类3,
       count(1) 票量
  FROM cqsale.cq_order@to_air t
  join cqsale.cq_order_head@to_air t1 ON t.flights_order_id =
                                         t1.flights_order_id
  JOIN dw.da_flight t2 ON t1.segment_head_id = t2.segment_head_id
  LEFT JOIN stg.s_cq_terminal t3 ON t.terminal_id = t3.terminal_id
  LEFT JOIN stg.s_cq_agent_info t4 ON t.web_id = t4.agent_id
  left join dw.da_restrict_userinfo t5 on t.client_id = t5.users_id
  left join if.v_da_restrict_userinfo t6 on t.client_Id=t6.users_id
 WHERE t.order_date >= trunc(sysdate)-7
   and t.order_date < sysdate
   and trunc(t.order_date) in(trunc(sysdate-7),trunc(sysdate))
   and t1.r_flights_date>=trunc(sysdate-7)-7
   --and to_char(t.order_date,'hh24:mi')< '17:00'
   and t2.flag <> 2
   and t1.flag_id in (3, 5, 40, 41)
   and t1.seats_name is not null
   and t1.whole_flight like '9C%'
 group by trunc(t.order_date),
 case
            when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and
                 t.ex_nfd1 in (3, 8) then
             'IOS'
            when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and
                 t.ex_nfd1 in (4, 9) then
             '安卓'
            when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and
                 t.ex_nfd1 in (5, 10) then
             '微信'
             when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and
              t.ex_nfd1=2 then
          'M网站'
            when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and
                 t.ex_nfd1 = 6 then
             '智能客服'
            when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and
                 nvl(t.ex_nfd1, 0) <= 1 then
             '网站'
            when t.web_id > 0 and t4.abrv like '%TMC%' then
             'B2G机构客户'
            when t.web_id > 0 and t4.abrv like '%航信%' then
             'B2B代理'
            when t.terminal_id = 3714 then
             'B2B代理'
            when t.terminal_id < 0 and
                 t.web_id in (240, 242, 312, 375, 1810, 2505, 3334, 3714) then
             'B2B代理'
            when t.web_id > 0 and
                 regexp_like(t4.abrv,
                             '(CAACSC)|(阿斯兰)|(宝钢国旅)|(95524)|(机构客户)|(集团客户)|(特航商旅)|(杭州万途)|(上海趣卫)') then
             'B2G机构客户'
            when t.terminal_id > 0 and
                 regexp_like(t3.terminal,
                             '(CAACSC)|(阿斯兰)|(宝钢国旅)|(95524)|(机构客户)|(集团客户)|(特航商旅)|(杭州万途)|(上海趣卫)') then
             'B2G机构客户'
            when t.terminal_id in
                 (300, 1233, 1309, 1330, 1400, 1401, 1516, 1571, 1801, 1802, 1803, 1805, 1806, 1807, 1808, 3505) then
             '呼叫中心'
            when t.terminal_id < 0 and nvl(t.web_id, 0) > 0 then
             decode(t4.agent_type,
                    1,
                    'OTA',
                    2,
                    'B2B代理',
                    4,
                    'CPS',
                    5,
                    'B2G机构客户')
            when nvl(t.web_id, 0) > 0 and t4.agent_type is null then
             'B2B'
            else
             'B2B'
          end,
          case
            when t.terminal_id < 0 and t.web_id = 0 and
                 t5.users_id is not null then
             '黑代'
            when t.terminal_id < 0 and t.web_id = 0 and
                 t.pay_gate in (15, 29, 31) then
             '易宝商旅卡'
            when t.terminal_id < 0 and t.web_id = 0 then
             '线上自有'
            when t4.abrv in ('携程', '同程', '去哪儿', '淘宝') then
             t4.abrv
            else
             '其他'
          end,to_char(t.order_date,'hh24'),	   case when t.terminal_id < 0 and t.web_id = 0 and t6.users_id is not null then
          '黑代'
		  else '非黑代' end
		  
		  
		  
		  
		  
		  select trunc(t.order_date) 日期,to_char(t.order_date,'hh24') 时刻,
case
         when t.terminal_id < 0 and nvl(t.web_id, 0) = 0  then '线上自有'
     when t.web_id > 0 and t4.abrv like '%TMC%' then
          'B2G机构客户'
         when t.web_id > 0 and t4.abrv like '%航信%' then
          'B2B代理'
         when t.terminal_id = 3714 then
          'B2B代理'
         when t.terminal_id < 0 and
              t.web_id in (240, 242, 312, 375, 1810, 2505, 3334, 3714) then
          'B2B代理'
         when t.web_id > 0 and
              regexp_like(t4.abrv,
                          '(CAACSC)|(阿斯兰)|(宝钢国旅)|(95524)|(机构客户)|(集团客户)|(特航商旅)|(杭州万途)|(上海趣卫)') then
          'B2G机构客户'
         when t.terminal_id > 0 and
              regexp_like(t3.terminal,
                          '(CAACSC)|(阿斯兰)|(宝钢国旅)|(95524)|(机构客户)|(集团客户)|(特航商旅)|(杭州万途)|(上海趣卫)') then
          'B2G机构客户'
         when t.terminal_id in
              (300, 1233, 1309, 1330, 1400, 1401, 1516, 1571, 1801, 1802, 1803, 1805, 1806, 1807, 1808, 3505) then
          '呼叫中心'
         when t.terminal_id < 0 and nvl(t.web_id, 0) > 0 then
          decode(t4.agent_type,
                 1,
                 'OTA',
                 2,
                 'B2B代理',
                 4,
                 'CPS',
                 5,
                 'B2G机构客户')
         when nvl(t.web_id, 0) > 0 and t4.agent_type is null then
          'B2B'
         else
          'B2B'
       end 渠道分类1,     
     case
         when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and t.ex_nfd1<=1 then '网站'
         when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and t.ex_nfd1=2 then 'M网站'
         when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and t.ex_nfd1 in(3,8) then 'IOS'
         when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and t.ex_nfd1 in(4,9) then '安卓'
         when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and t.ex_nfd1 in(5,10) then '微信'
         when t.terminal_id < 0 and nvl(t.web_id, 0) = 0  then '线上自有其他'           
      when t4.abrv in ('携程', '同程', '去哪儿', '淘宝') then
          t4.abrv
      else '其他' end 渠道分类2,    
       case
         when t.terminal_id < 0 and t.web_id = 0 and t5.users_id is not null then
          '黑代'
         when t.terminal_id < 0 and t.web_id = 0 and  t.pay_gate in (15, 29, 31) then
          '易宝商旅卡'
         when t.terminal_id < 0 and t.web_id = 0 then
          '线上纯量'
         when t4.abrv in ('携程', '同程', '去哪儿', '淘宝') then
          t4.abrv
         else
          '其他'
       end 渠道分类3,
	    case when t.terminal_id < 0 and t.web_id = 0 and t6.users_id is not null then
          '黑代'
		  else '非黑代' end 渠道分类4,
       count(1) 票量
  FROM cqsale.cq_order@to_air t
  join cqsale.cq_order_head@to_air t1 ON t.flights_order_id =
                                         t1.flights_order_id
  JOIN dw.da_flight t2 ON t1.segment_head_id = t2.segment_head_id
  LEFT JOIN stg.s_cq_terminal t3 ON t.terminal_id = t3.terminal_id
  LEFT JOIN stg.s_cq_agent_info t4 ON t.web_id = t4.agent_id
  left join dw.da_restrict_userinfo t5 on t.client_id = t5.users_id
    left join if.v_da_restrict_userinfo t6 on t.client_Id=t6.users_id
 WHERE t.order_date >= trunc(sysdate)-7
   and t.order_date < sysdate
   and trunc(t.order_date) in(trunc(sysdate-7),trunc(sysdate))
   and t1.r_flights_date>=trunc(sysdate-7)-7
   --and to_char(t.order_date,'hh24:mi')< '17:00'
   and t2.flag <> 2
   and t1.flag_id in (3, 5, 40, 41)
   and t1.seats_name is not null
   and t1.whole_flight like '9C%'
 group by trunc(t.order_date),to_char(t.order_date,'hh24'),case
         when t.terminal_id < 0 and nvl(t.web_id, 0) = 0  then '线上自有'
     when t.web_id > 0 and t4.abrv like '%TMC%' then
          'B2G机构客户'
         when t.web_id > 0 and t4.abrv like '%航信%' then
          'B2B代理'
         when t.terminal_id = 3714 then
          'B2B代理'
         when t.terminal_id < 0 and
              t.web_id in (240, 242, 312, 375, 1810, 2505, 3334, 3714) then
          'B2B代理'
         when t.web_id > 0 and
              regexp_like(t4.abrv,
                          '(CAACSC)|(阿斯兰)|(宝钢国旅)|(95524)|(机构客户)|(集团客户)|(特航商旅)|(杭州万途)|(上海趣卫)') then
          'B2G机构客户'
         when t.terminal_id > 0 and
              regexp_like(t3.terminal,
                          '(CAACSC)|(阿斯兰)|(宝钢国旅)|(95524)|(机构客户)|(集团客户)|(特航商旅)|(杭州万途)|(上海趣卫)') then
          'B2G机构客户'
         when t.terminal_id in
              (300, 1233, 1309, 1330, 1400, 1401, 1516, 1571, 1801, 1802, 1803, 1805, 1806, 1807, 1808, 3505) then
          '呼叫中心'
         when t.terminal_id < 0 and nvl(t.web_id, 0) > 0 then
          decode(t4.agent_type,
                 1,
                 'OTA',
                 2,
                 'B2B代理',
                 4,
                 'CPS',
                 5,
                 'B2G机构客户')
         when nvl(t.web_id, 0) > 0 and t4.agent_type is null then
          'B2B'
         else
          'B2B'
       end ,     
     case
         when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and t.ex_nfd1<=1 then '网站'
         when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and t.ex_nfd1=2 then 'M网站'
         when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and t.ex_nfd1 in(3,8) then 'IOS'
         when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and t.ex_nfd1 in(4,9) then '安卓'
         when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and t.ex_nfd1 in(5,10) then '微信'
         when t.terminal_id < 0 and nvl(t.web_id, 0) = 0  then '线上自有其他' 
      when t4.abrv in ('携程', '同程', '去哪儿', '淘宝') then
          t4.abrv
      else '其他' end ,    
       case
         when t.terminal_id < 0 and t.web_id = 0 and t5.users_id is not null then
          '黑代'
         when t.terminal_id < 0 and t.web_id = 0 and  t.pay_gate in (15, 29, 31) then
          '易宝商旅卡'
         when t.terminal_id < 0 and t.web_id = 0 then
          '线上纯量'
         when t4.abrv in ('携程', '同程', '去哪儿', '淘宝') then
          t4.abrv
         else
          '其他'
       end,   case when t.terminal_id < 0 and t.web_id = 0 and t6.users_id is not null then
          '黑代'
		  else '非黑代' end;
		  
		  
		  
		   select trunc(t.order_date) 日期,to_char(t.order_date,'hh24') 时刻,
case
         when t.terminal_id < 0 and nvl(t.web_id, 0) = 0  then '线上自有'
     when t.web_id > 0 and t4.abrv like '%TMC%' then
          'B2G机构客户'
         when t.web_id > 0 and t4.abrv like '%航信%' then
          'B2B代理'
         when t.terminal_id = 3714 then
          'B2B代理'
         when t.terminal_id < 0 and
              t.web_id in (240, 242, 312, 375, 1810, 2505, 3334, 3714) then
          'B2B代理'
         when t.web_id > 0 and
              regexp_like(t4.abrv,
                          '(CAACSC)|(阿斯兰)|(宝钢国旅)|(95524)|(机构客户)|(集团客户)|(特航商旅)|(杭州万途)|(上海趣卫)') then
          'B2G机构客户'
         when t.terminal_id > 0 and
              regexp_like(t3.terminal,
                          '(CAACSC)|(阿斯兰)|(宝钢国旅)|(95524)|(机构客户)|(集团客户)|(特航商旅)|(杭州万途)|(上海趣卫)') then
          'B2G机构客户'
         when t.terminal_id in
              (300, 1233, 1309, 1330, 1400, 1401, 1516, 1571, 1801, 1802, 1803, 1805, 1806, 1807, 1808, 3505) then
          '呼叫中心'
         when t.terminal_id < 0 and nvl(t.web_id, 0) > 0 then
          decode(t4.agent_type,
                 1,
                 'OTA',
                 2,
                 'B2B代理',
                 4,
                 'CPS',
                 5,
                 'B2G机构客户')
         when nvl(t.web_id, 0) > 0 and t4.agent_type is null then
          'B2B'
         else
          'B2B'
       end 渠道分类1,     
     case
         when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and t.ex_nfd1<=1 then '网站'
         when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and t.ex_nfd1=2 then 'M网站'
         when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and t.ex_nfd1 in(3,8) then 'IOS'
         when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and t.ex_nfd1 in(4,9) then '安卓'
         when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and t.ex_nfd1 in(5,10) then '微信'
         when t.terminal_id < 0 and nvl(t.web_id, 0) = 0  then '线上自有其他'           
      when t4.abrv in ('携程', '同程', '去哪儿', '淘宝') then
          t4.abrv
      else '其他' end 渠道分类2,    
       case
         when t.terminal_id < 0 and t.web_id = 0 and t5.users_id is not null then
          '黑代'
         when t.terminal_id < 0 and t.web_id = 0 and t5.users_id is  null then '线上自有'
          else '非黑代' end,
           case
         when t.terminal_id < 0 and t.web_id = 0 and t6.users_id is not null then
          '黑代'
          when t.terminal_id < 0 and t.web_id = 0 and t5.users_id is  null then '线上自有'
          else '非黑代' end,
    case when t.terminal_id < 0 and t.web_id = 0 and  t.pay_gate in (15, 29, 31) then '易宝商旅卡'
          else  t7.gate_name end,
       count(1) 票量
  FROM cqsale.cq_order@to_air t
  join cqsale.cq_order_head@to_air t1 ON t.flights_order_id =
                                         t1.flights_order_id
  JOIN dw.da_flight t2 ON t1.segment_head_id = t2.segment_head_id
  LEFT JOIN stg.s_cq_terminal t3 ON t.terminal_id = t3.terminal_id
  LEFT JOIN stg.s_cq_agent_info t4 ON t.web_id = t4.agent_id
  left join dw.da_restrict_userinfo t5 on t.client_id = t5.users_id
  left join if.v_da_restrict_userinfo t6 on t.client_Id=t6.users_id
  left join stg.p_cq_pay_gate t7 on t.pay_gate=t7.id
 WHERE t.order_date >= trunc(sysdate)-7
   and t.order_date < sysdate
   and trunc(t.order_date) in(trunc(sysdate-7),trunc(sysdate))
   and t1.r_flights_date>=trunc(sysdate-7)-7
   --and to_char(t.order_date,'hh24:mi')< '13:30'
   and t2.flag <> 2
   and t1.flag_id in (3, 5, 40, 41)
   and t1.seats_name is not null
   and t1.whole_flight like '9C%'
 group by trunc(t.order_date) ,to_char(t.order_date,'hh24') ,
case
         when t.terminal_id < 0 and nvl(t.web_id, 0) = 0  then '线上自有'
     when t.web_id > 0 and t4.abrv like '%TMC%' then
          'B2G机构客户'
         when t.web_id > 0 and t4.abrv like '%航信%' then
          'B2B代理'
         when t.terminal_id = 3714 then
          'B2B代理'
         when t.terminal_id < 0 and
              t.web_id in (240, 242, 312, 375, 1810, 2505, 3334, 3714) then
          'B2B代理'
         when t.web_id > 0 and
              regexp_like(t4.abrv,
                          '(CAACSC)|(阿斯兰)|(宝钢国旅)|(95524)|(机构客户)|(集团客户)|(特航商旅)|(杭州万途)|(上海趣卫)') then
          'B2G机构客户'
         when t.terminal_id > 0 and
              regexp_like(t3.terminal,
                          '(CAACSC)|(阿斯兰)|(宝钢国旅)|(95524)|(机构客户)|(集团客户)|(特航商旅)|(杭州万途)|(上海趣卫)') then
          'B2G机构客户'
         when t.terminal_id in
              (300, 1233, 1309, 1330, 1400, 1401, 1516, 1571, 1801, 1802, 1803, 1805, 1806, 1807, 1808, 3505) then
          '呼叫中心'
         when t.terminal_id < 0 and nvl(t.web_id, 0) > 0 then
          decode(t4.agent_type,
                 1,
                 'OTA',
                 2,
                 'B2B代理',
                 4,
                 'CPS',
                 5,
                 'B2G机构客户')
         when nvl(t.web_id, 0) > 0 and t4.agent_type is null then
          'B2B'
         else
          'B2B'
       end ,     
     case
         when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and t.ex_nfd1<=1 then '网站'
         when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and t.ex_nfd1=2 then 'M网站'
         when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and t.ex_nfd1 in(3,8) then 'IOS'
         when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and t.ex_nfd1 in(4,9) then '安卓'
         when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and t.ex_nfd1 in(5,10) then '微信'
         when t.terminal_id < 0 and nvl(t.web_id, 0) = 0  then '线上自有其他'           
      when t4.abrv in ('携程', '同程', '去哪儿', '淘宝') then
          t4.abrv
      else '其他' end ,    
       case
         when t.terminal_id < 0 and t.web_id = 0 and t5.users_id is not null then
          '黑代'
         when t.terminal_id < 0 and t.web_id = 0 and t5.users_id is  null then '线上自有'
          else '非黑代' end,
           case
         when t.terminal_id < 0 and t.web_id = 0 and t6.users_id is not null then
          '黑代'
          when t.terminal_id < 0 and t.web_id = 0 and t5.users_id is  null then '线上自有'
          else '非黑代' end,
    case when t.terminal_id < 0 and t.web_id = 0 and  t.pay_gate in (15, 29, 31) then '易宝商旅卡'
          else  t7.gate_name end;
		  

===========================================历史渠道占比监控===========================================
	
 select t1.order_day, case when t1.channel in('手机','网站') and t1.station_id<=1 then '网站'
  when t1.channel in('手机','网站') and t1.station_id=2 then 'M网站'
  when t1.channel in('手机','网站') and t1.station_id in(3,8) then 'IOS'
  when t1.channel in('手机','网站') and t1.station_id in(4,9) then '安卓'
  when t1.channel in('手机','网站') and t1.station_id =6 then '智能客服'
  when t1.channel in('手机','网站')  then '微信' 
  when t1.channel in('OTA','旗舰店') then 'OTA'
  else t1.channel end ,
  case when t1.channel in('手机','网站')  and t5.users_id is not null then '黑代1'
  when t1.channel in('手机','网站')  and t6.users_id is not null then '黑代2'
  else  '非黑代' end,
t1.gate_name,
case when t4.flights_order_head_id is not null and t4.IS_BENEFICIARY=1 then '受益人立减'
when t4.flights_order_head_id is not null and t4.IS_BENEFICIARY=0 then '绿翼立减'
else '普通购买' end ,
count(1) 票量
  FROM dw.fact_order_detail t1
  JOIN dw.da_flight t2 ON t1.segment_head_id = t2.segment_head_id
  left join dw.da_restrict_userinfo t5 on t1.client_id = t5.users_id
  left join dw.da_restrict_userinfo@to_ods t6 on t1.client_Id=t6.users_id  
  left join (select flights_order_head_id,sum(t1.use_money) use_money
 from dw.bi_yhq_use t1
 where flag=1
 and order_type=0
 and USE_DATE>=trunc(sysdate)-30
 group by flights_order_head_id)t3 on t1.flights_order_head_id=t3.flights_order_head_id
 left join (select flights_order_head_id, nvl(IS_BENEFICIARY,0) IS_BENEFICIARY,youhui_result
 from cust.cq_order_youhui_detail@to_air
 where PRODUCT_TYPE=0
 and YH_RET_TIME is null
 and youhui_result is not null
 and youhui_id in(1129,1137)
 and create_date>=trunc(sysdate)-30
 )t4 on t1.flights_order_head_id=t4.flights_order_head_id
 
 WHERE t1.order_day >= trunc(sysdate)-7
   and t1.order_day < trunc(sysdate)
   and t1.flights_date>=trunc(sysdate-7)-7
   and t2.flag <> 2
   and t1.flag_id in (3, 5, 40, 41)
   and t1.seats_name is not null
   and t1.whole_flight like '9C%'
   and t1.seats_name not in('B','G','G1','G2','O')
   group by t1.order_day, case when t1.channel in('手机','网站') and t1.station_id<=1 then '网站'
  when t1.channel in('手机','网站') and t1.station_id=2 then 'M网站'
  when t1.channel in('手机','网站') and t1.station_id in(3,8) then 'IOS'
  when t1.channel in('手机','网站') and t1.station_id in(4,9) then '安卓'
  when t1.channel in('手机','网站') and t1.station_id =6 then '智能客服'
  when t1.channel in('手机','网站')  then '微信' 
  when t1.channel in('OTA','旗舰店') then 'OTA'
  else t1.channel end ,
  case when t1.channel in('手机','网站')  and t5.users_id is not null then '黑代1'
  when t1.channel in('手机','网站')  and t6.users_id is not null then '黑代2'
  else  '非黑代' end,
t1.gate_name,
case when t4.flights_order_head_id is not null and t4.IS_BENEFICIARY=1 then '受益人立减'
when t4.flights_order_head_id is not null and t4.IS_BENEFICIARY=0 then '绿翼立减'
else '普通购买' end;


=====优化后



select t1.order_day, case when t1.channel in('手机','网站') and t1.station_id<=1 then '网站'
  when t1.channel in('手机','网站') and t1.station_id=2 then 'M网站'
  when t1.channel in('手机','网站') and t1.station_id in(3,8) then 'IOS'
  when t1.channel in('手机','网站') and t1.station_id in(4,9) then '安卓'
  when t1.channel in('手机','网站') and t1.station_id =6 then '智能客服'
  when t1.channel in('手机','网站')  then '微信' 
  when t1.channel in('OTA','旗舰店') then 'OTA'
  else t1.channel end 渠道,  
  case when t1.channel in('手机','网站')  then '线上自有'
  when t1.channel in('OTA','旗舰店') then 'OTA'
  else 'B2B' end 渠道大类,  
  case when t1.channel in('手机','网站')  and t5.users_id is not null then '黑代'
  else  '非黑代' end 代理与否,
case when t1.gate_name like '%商旅卡%' then '易宝商旅卡'
when t1.gate_name like '%易宝%' then '易宝商旅卡'
when t1.gate_name like '%支付宝%' then '支付宝'
when t1.gate_name like '%微信%' then '微信'
when t1.gate_name like '%财付通%' then '微信'
else '其他' end 支付渠道,
case when t4.flights_order_head_id is not null and t4.IS_BENEFICIARY=1 then '受益人立减'
when t4.flights_order_head_id is not null and t4.IS_BENEFICIARY=0 then '绿翼立减'
else '普通购买' end 购票优惠 ,
case when t8.create_date> to_date('2020-05-19','yyyy-mm-dd')  and t4.flights_order_head_id is not null then '19以后受益人立减'
when t8.create_date<= to_date('2020-05-19','yyyy-mm-dd')  and t4.flights_order_head_id is not null then '19之前受益人立减'
when t8.create_date> to_date('2020-05-19','yyyy-mm-dd')  then '19以后添加绿翼亲友'
when t8.create_date<= to_date('2020-05-19','yyyy-mm-dd')  then '19之前添加绿翼亲友'
end 绿翼亲友,
 case when t7.reg_day=t1.order_day then '当天注册'
when t7.reg_day<=to_date('2020-05-19','yyyy-mm-dd') then '19号之前'
when t7.reg_day> to_date('2020-05-19','yyyy-mm-dd') then '19号之后'
end 绿翼注册,
count(1) 票量
  FROM dw.fact_order_detail t1
  JOIN dw.da_flight t2 ON t1.segment_head_id = t2.segment_head_id
  left join dw.da_restrict_userinfo t5 on t1.client_id = t5.users_id
  left join (select flights_order_head_id, nvl(IS_BENEFICIARY,0) IS_BENEFICIARY,youhui_result
 from cust.cq_order_youhui_detail@to_air
 where PRODUCT_TYPE=0
 and YH_RET_TIME is null
 and youhui_result is not null
 and  youhui_id in (1129,1130, 1137,1138)
 and create_date>=trunc(sysdate)-30
 )t4 on t1.flights_order_head_id=t4.flights_order_head_id
 left join dw.da_lyuser t7 on t1.client_Id=t7.users_id_fk
 left join (select t1.users_id,t2.code_no,min(t1.create_time) create_date
      from cust.cq_flights_benefic_users@to_air t1
      left join cust.cq_benefic_users_codes@to_air t2 on t2.benefic_users_id = t1.crm_favoree_id
      where t1.status = 1
      and t2.flag = 1
      and trunc(t1.create_time) >= to_date('2020-03-01', 'yyyy-mm-dd')
      and trunc(t1.create_time) < trunc(sysdate)
      group by t1.users_id,t2.code_no)t8 on t1.client_Id=t8.users_id  and t1.codeno=t8.code_no 
 WHERE t1.order_day >= to_date('2020-05-11','yyyy-mm-dd')
   and t1.order_day < trunc(sysdate)
   and t1.flights_date>=to_date('2020-05-11','yyyy-mm-dd')-7
   and t2.flag <> 2
   and t1.flag_id in (3, 5, 40, 41)
   and t1.seats_name is not null
   and t1.whole_flight like '9C%'
   and t1.seats_name not in('B','G','G1','G2','O')
   group by t1.order_day, case when t1.channel in('手机','网站') and t1.station_id<=1 then '网站'
  when t1.channel in('手机','网站') and t1.station_id=2 then 'M网站'
  when t1.channel in('手机','网站') and t1.station_id in(3,8) then 'IOS'
  when t1.channel in('手机','网站') and t1.station_id in(4,9) then '安卓'
  when t1.channel in('手机','网站') and t1.station_id =6 then '智能客服'
  when t1.channel in('手机','网站')  then '微信' 
  when t1.channel in('OTA','旗舰店') then 'OTA'
  else t1.channel end ,  
  case when t1.channel in('手机','网站')  then '线上自有'
  when t1.channel in('OTA','旗舰店') then 'OTA'
  else 'B2B' end ,  
  case when t1.channel in('手机','网站')  and t5.users_id is not null then '黑代'
  else  '非黑代' end ,
case when t1.gate_name like '%商旅卡%' then '易宝商旅卡'
when t1.gate_name like '%易宝%' then '易宝商旅卡'
when t1.gate_name like '%支付宝%' then '支付宝'
when t1.gate_name like '%微信%' then '微信'
when t1.gate_name like '%财付通%' then '微信'
else '其他' end ,
case when t4.flights_order_head_id is not null and t4.IS_BENEFICIARY=1 then '受益人立减'
when t4.flights_order_head_id is not null and t4.IS_BENEFICIARY=0 then '绿翼立减'
else '普通购买' end,case when t8.create_date> to_date('2020-05-19','yyyy-mm-dd')  and t4.flights_order_head_id is not null then '19以后受益人立减'
when t8.create_date<= to_date('2020-05-19','yyyy-mm-dd')  and t4.flights_order_head_id is not null then '19之前受益人立减'
when t8.create_date> to_date('2020-05-19','yyyy-mm-dd')  then '19以后添加绿翼亲友'
when t8.create_date<= to_date('2020-05-19','yyyy-mm-dd')  then '19之前添加绿翼亲友'
end,
 case when t7.reg_day=t1.order_day then '当天注册'
when t7.reg_day<=to_date('2020-05-19','yyyy-mm-dd') then '19号之前'
when t7.reg_day> to_date('2020-05-19','yyyy-mm-dd') then '19号之后'
end



==================================明细查询=======================


select t1.client_id,t1.flights_order_id,t1.order_day, case when t1.channel in('手机','网站') and t1.station_id<=1 then '网站'
  when t1.channel in('手机','网站') and t1.station_id=2 then 'M网站'
  when t1.channel in('手机','网站') and t1.station_id in(3,8) then 'IOS'
  when t1.channel in('手机','网站') and t1.station_id in(4,9) then '安卓'
  when t1.channel in('手机','网站') and t1.station_id =6 then '智能客服'
  when t1.channel in('手机','网站')  then '微信' 
  when t1.channel in('OTA','旗舰店') then 'OTA'
  else t1.channel end 渠道,  
  case when t1.channel in('手机','网站')  then '线上自有'
  when t1.channel in('OTA','旗舰店') then 'OTA'
  else 'B2B' end 渠道大类,  
  case when t1.channel in('手机','网站')  and t5.users_id is not null then '黑代'
  else  '非黑代' end 代理与否,
case when t1.gate_name like '%商旅卡%' then '易宝商旅卡'
when t1.gate_name like '%易宝%' then '易宝商旅卡'
when t1.gate_name like '%支付宝%' then '支付宝'
when t1.gate_name like '%微信%' then '微信'
when t1.gate_name like '%财付通%' then '微信'
else '其他' end 支付渠道,
case when t4.flights_order_head_id is not null and t4.IS_BENEFICIARY=1 then '受益人立减'
when t4.flights_order_head_id is not null and t4.IS_BENEFICIARY=0 then '绿翼立减'
else '普通购买' end 购票优惠 ,
case when t8.create_date> to_date('2020-05-19','yyyy-mm-dd')  and t4.flights_order_head_id is not null then '19以后受益人立减'
when t8.create_date<= to_date('2020-05-19','yyyy-mm-dd')  and t4.flights_order_head_id is not null then '19之前受益人立减'
when t8.create_date> to_date('2020-05-19','yyyy-mm-dd')  then '19以后添加绿翼亲友'
when t8.create_date<= to_date('2020-05-19','yyyy-mm-dd')  then '19之前添加绿翼亲友'
end 绿翼亲友,
 case when t7.reg_day=t1.order_day then '当天注册'
when t7.reg_day<=to_date('2020-05-19','yyyy-mm-dd') then '19号之前'
when t7.reg_day> to_date('2020-05-19','yyyy-mm-dd') then '19号之后'
end 绿翼注册,
count(1) 票量
  FROM dw.fact_order_detail t1
  JOIN dw.da_flight t2 ON t1.segment_head_id = t2.segment_head_id
  left join dw.da_restrict_userinfo t5 on t1.client_id = t5.users_id
  left join (select flights_order_head_id, nvl(IS_BENEFICIARY,0) IS_BENEFICIARY,youhui_result
 from cust.cq_order_youhui_detail@to_air
 where PRODUCT_TYPE=0
 and YH_RET_TIME is null
 and youhui_result is not null
 and youhui_id in(1129,1137)
 and create_date>=trunc(sysdate)-30
 )t4 on t1.flights_order_head_id=t4.flights_order_head_id
 left join dw.da_lyuser t7 on t1.client_Id=t7.users_id_fk
 left join (select t1.users_id,t2.code_no,min(t1.create_time) create_date
      from cust.cq_flights_benefic_users@to_air t1
      left join cust.cq_benefic_users_codes@to_air t2 on t2.benefic_users_id = t1.crm_favoree_id
      where t1.status = 1
      and t2.flag = 1
      and trunc(t1.create_time) >= to_date('2020-03-01', 'yyyy-mm-dd')
      and trunc(t1.create_time) < trunc(sysdate)
      group by t1.users_id,t2.code_no)t8 on t1.client_Id=t8.users_id  and t1.codeno=t8.code_no 
 WHERE t1.order_day >= to_date('2020-05-11','yyyy-mm-dd')
   and t1.order_day < trunc(sysdate)
   and t1.order_day>=trunc(sysdate)-1
   and t1.flights_date>=to_date('2020-05-11','yyyy-mm-dd')-7
   and t2.flag <> 2
   and t1.flag_id in (3, 5, 40, 41)
   and t1.seats_name is not null
   and t1.whole_flight like '9C%'
   and t1.seats_name not in('B','G','G1','G2','O')
   group by t1.order_day, case when t1.channel in('手机','网站') and t1.station_id<=1 then '网站'
  when t1.channel in('手机','网站') and t1.station_id=2 then 'M网站'
  when t1.channel in('手机','网站') and t1.station_id in(3,8) then 'IOS'
  when t1.channel in('手机','网站') and t1.station_id in(4,9) then '安卓'
  when t1.channel in('手机','网站') and t1.station_id =6 then '智能客服'
  when t1.channel in('手机','网站')  then '微信' 
  when t1.channel in('OTA','旗舰店') then 'OTA'
  else t1.channel end ,  
  case when t1.channel in('手机','网站')  then '线上自有'
  when t1.channel in('OTA','旗舰店') then 'OTA'
  else 'B2B' end ,  
  case when t1.channel in('手机','网站')  and t5.users_id is not null then '黑代'
  else  '非黑代' end ,
case when t1.gate_name like '%商旅卡%' then '易宝商旅卡'
when t1.gate_name like '%易宝%' then '易宝商旅卡'
when t1.gate_name like '%支付宝%' then '支付宝'
when t1.gate_name like '%微信%' then '微信'
when t1.gate_name like '%财付通%' then '微信'
else '其他' end ,
case when t4.flights_order_head_id is not null and t4.IS_BENEFICIARY=1 then '受益人立减'
when t4.flights_order_head_id is not null and t4.IS_BENEFICIARY=0 then '绿翼立减'
else '普通购买' end,case when t8.create_date> to_date('2020-05-19','yyyy-mm-dd')  and t4.flights_order_head_id is not null then '19以后受益人立减'
when t8.create_date<= to_date('2020-05-19','yyyy-mm-dd')  and t4.flights_order_head_id is not null then '19之前受益人立减'
when t8.create_date> to_date('2020-05-19','yyyy-mm-dd')  then '19以后添加绿翼亲友'
when t8.create_date<= to_date('2020-05-19','yyyy-mm-dd')  then '19之前添加绿翼亲友'
end,
 case when t7.reg_day=t1.order_day then '当天注册'
when t7.reg_day<=to_date('2020-05-19','yyyy-mm-dd') then '19号之前'
when t7.reg_day> to_date('2020-05-19','yyyy-mm-dd') then '19号之后'
end,t1.client_id,t1.flights_Order_id
 

--==================================================易宝、商旅卡区分开=====================================================================



select trunc(t.order_date) 日期,
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
         else
          '其他'
       end,
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
                and create_date >= trunc(sysdate) - 2) t4 on t1.flights_order_head_id =
                                                              t4.flights_order_head_id
 where t.order_date >= trunc(sysdate) - 1
   and t.order_date < sysdate
   and t1.r_flights_date >= trunc(sysdate - 1) - 7
   and t2.flag <> 2
   and trunc(t.order_date) in(trunc(sysdate),trunc(sysdate)-1)
   and to_char(t.order_date,'hh24:mi')<='16:14'
   and t1.flag_id in (3, 5, 40, 41)
   and t1.seats_name is not null
   and t1.whole_flight like '9C%'
 group by trunc(t.order_date) ,
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
         else
          '其他'
       end,
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
       end;

 --------------------历史数据-----------------------------------------    
select t1.order_day 日期,
case when t1.gate_name like '%商旅卡%' then '商旅卡'
when t1.gate_name like '%易宝%' then '易宝'
when t1.gate_name like '%支付宝%' then '支付宝'
when t1.gate_name like '%微信%' then '微信'
when t1.gate_name like '%财付通%' then '微信'
else '其他' end 支付渠道,

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
         when t1.terminal_id < 0 and t1.web_id = 0 and t5.users_id is not null then
          '线上自有黑代'
         when t1.terminal_id < 0 and t1.web_id = 0 and
              t1.pay_gate in (15, 29, 31) then
          '线上自有易宝商旅卡'
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
       end,
       count(1) 票量
  from dw.fact_order_detail t1
   join dw.da_flight t2 on t1.segment_head_id = t2.segment_head_id
  left join dw.da_restrict_userinfo t5 on t1.client_id = t5.users_id
  left join (select flights_order_head_id,
                    nvl(is_beneficiary, 0) is_beneficiary,
                    youhui_result
               from stg.c_cq_order_youhui_detail
              where product_type = 0
                and yh_ret_time is null
                and youhui_result is not null
                and youhui_id in (1129,1130, 1137,1138)
                and trunc(create_date) >= trunc(sysdate) - 30) t4 on t1.flights_order_head_id =
                                                              t4.flights_order_head_id
 where t1.order_day >= trunc(sysdate) - 7
   and t1.order_day < sysdate
   and t1.flights_date >= trunc(sysdate - 7) - 7
   and t2.flag <> 2
   and t1.flag_id in (3, 5, 40, 41)
   and t1.seats_name is not null
   and t1.whole_flight like '9C%'
 group by t1.order_day ,
case when t1.gate_name like '%商旅卡%' then '商旅卡'
when t1.gate_name like '%易宝%' then '易宝'
when t1.gate_name like '%支付宝%' then '支付宝'
when t1.gate_name like '%微信%' then '微信'
when t1.gate_name like '%财付通%' then '微信'
else '其他' end ,
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
         when t1.terminal_id < 0 and t1.web_id = 0 and t5.users_id is not null then
          '线上自有黑代'
         when t1.terminal_id < 0 and t1.web_id = 0 and
              t1.pay_gate in (15, 29, 31) then
          '线上自有易宝商旅卡'
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
       end;

