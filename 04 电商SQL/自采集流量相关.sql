select trmnl_tp,
       case
         when trmnl_tp = '微信' then
          '微信渠道'
         when trmnl_tp = 'Android' then
          '安卓渠道'
         when trmnl_tp = 'IOS' then
          'IOS渠道'
         when trmnl_tp in ('网站', 'M站') and channel1 = '非广告流量' then
          '直接流量'
         when trmnl_tp in ('网站', 'M站') and channel1 = '其他' then
          '其他渠道'
         else
          channel1
       end channel1,
       visit_date,
       sum(UV) UV,
       sum(PV) PV
  from dw.cj_sdaily_cmpid@to_ods
 where 1 = 1
   and visit_date >= to_date('2017-03-01', 'yyyy-mm-dd')
   and visit_date < to_date('2017-10-20', 'yyyy-mm-dd')
   and channel1 <> 'Display'
 group by trmnl_tp,
          case
            when trmnl_tp = '微信' then
             '微信渠道'
            when trmnl_tp = 'Android' then
             '安卓渠道'
            when trmnl_tp = 'IOS' then
             'IOS渠道'
            when trmnl_tp in ('网站', 'M站') and channel1 = '非广告流量' then
             '直接流量'
            when trmnl_tp in ('网站', 'M站') and channel1 = '其他' then
             '其他渠道'
            else
             channel1
          end,
          visit_date
