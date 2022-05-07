select to_char(t1.order_day, 'yyyymm') flightmonth,
       case
         when t3.channel3='境外渠道' then '线下渠道'
         when t4.users_id is not null and t1.channel in('网站','手机') then '线下渠道'
         when t1.channel in('手机','网站') then '线上自营渠道'
         when t1.channel in('OTA','旗舰店') then 'OTA+旗舰店'
         else '线下渠道' end,
         case when t3.channel3='境外渠道' then '境外渠道'
         when t1.channel ='B2G机构客户' then 'B2GTMC'
         when t1.channel ='B2B' then 'B2B'
        when t4.users_id is not null and t1.channel in('网站','手机') then 'B2B代理'
         when t1.channel ='B2B代理' then 'B2B代理'
         when t1.channel ='呼叫中心' then '呼叫中心'
         when t1.channel in('手机','网站') then '线上自营渠道'
         when t1.channel in('OTA','旗舰店') then 'OTA+旗舰店'
         else t1.sub_channel end,

         case when t3.channel3='境外渠道' then t3.area_out
          else '其他' end,
       suM(case
             when t1.seats_name is not null then
              1
             else
              0
           end) ticketnum
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id = t2.segment_head_id
  left join dw.da_restrict_userinfo t4 on t1.client_id = t4.users_id
  left join hdb.an_termianl_classify t3 on t1.sub_channel=t3.terminal
 where t1.order_day >= to_date('2018-09-01', 'yyyy-mm-dd')
   and t1.order_day <  to_date('2018-12-01', 'yyyy-mm-dd')
   and t1.company_id = 0
   and t1.flag_id in (3, 5, 40, 41)
   and t1.seats_name not in('B','G','G1','G2','O')
   and t2.flag <> 2
 group by to_char(t1.order_day, 'yyyymm') ,
       case
         when t3.channel3='境外渠道' then '线下渠道'
         when t4.users_id is not null and t1.channel in('网站','手机') then '线下渠道'
         when t1.channel in('手机','网站') then '线上自营渠道'
         when t1.channel in('OTA','旗舰店') then 'OTA+旗舰店'
         else '线下渠道' end,
         case when t3.channel3='境外渠道' then '境外渠道'
         when t1.channel ='B2G机构客户' then 'B2GTMC'
         when t1.channel ='B2B' then 'B2B'
        when t4.users_id is not null and t1.channel in('网站','手机') then 'B2B代理'
         when t1.channel ='B2B代理' then 'B2B代理'
         when t1.channel ='呼叫中心' then '呼叫中心'
         when t1.channel in('手机','网站') then '线上自营渠道'
         when t1.channel in('OTA','旗舰店') then 'OTA+旗舰店'
         else t1.sub_channel end,
         case when t3.channel3='境外渠道' then t3.area_out
          else '其他' end
