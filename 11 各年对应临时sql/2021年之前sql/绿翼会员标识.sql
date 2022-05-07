select t.users_id 用户ID,
       t.cust_id 会员ID,
       (case t.change_from
         when 0 then
          '线下'
         when 1 then
          'PC'
         when 2 then
          'M站'
         when 3 then
          'IOS'
         when 4 then
          'Android'
         when 5 then
          '微信公众号'
         when 10 then
          '微信小程序'
         when 11 then
          '机上Wifi'
         when 12 then
          '商旅通'
         when 13 then
          'OTA转换'
         else
          ''
       end) 渠道,
       (case t.authentication_methods
         when '1' then
          '线下审核'
         when '2' then
          '支付宝'
         when '3' then
          '微信'
         when '4' then
          '联名卡'
         when '5' then
          '值机'
         else
          ''
       end) 认证方式,
       t.authentication_scenario 认证场景
  from cq_users_huiyuan_change t
 where t.create_date >= to_date('2019-07-13', 'yyyy-mm-dd')
   and t.create_date <=
       to_date('2019-07-14 23:59:59', 'yyyy-mm-dd hh24:mi:ss')
