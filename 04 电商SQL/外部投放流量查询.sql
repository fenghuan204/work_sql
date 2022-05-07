select visitdate,
M.trmnl_tp,
       M.lang,
       M.channel1,
       M.channel2,
       case when M.lang = '简体中文' and split_part(M.cmpid, '_', 4) is not null then
          substr(M.cmpid, 1, instr(M.cmpid, '_', 1, 3) - 1) else M.cmpid
       end cmpid,
       sum(M.UV) UV,
       sum(M.new_uv) new_uv,
       sum(M.PV) PV,
       sum(M.allorders) 提交订单数,
       sum(M.orders) 支付订单数,
       sum(M.tickets) 机票量,
       sum(M.ticketsale) 机票销售,
       sum(M.feesale) 辅收,
       sum(M.allsale) 总营收,
       sum(M.clients) 提交订单会员数,
       sum(M.pay_clients) 支付订单会员数
  from (select trunc(visit_date) visitdate,
  trmnl_tp,
               case
                 when upper(lang) like '%CN%' then
                  '简体中文'
                 when upper(lang) like '%EN%' then
                  '英文'
                 when upper(lang) like '%HK%' then
                  '繁体中文'
                 when upper(lang) like '%JP%' then
                  '日文'
                 when upper(lang) like '%KR%' then
                  '韩文'
                 when upper(lang) like '%TH%' then
                  '泰文'
                 else
                  '简体中文'
               end lang,
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
               case
                 when trmnl_tp = '微信' then
                  '微信渠道'
                 when trmnl_tp = 'Android' then
                  '安卓渠道'
                 when trmnl_tp = 'IOS' then
                  'IOS渠道'
                 when trmnl_tp in ('网站', 'M站') and channel2 = '非广告流量' then
                  '直接流量'
                  when trmnl_tp in ('网站', 'M站') and channel1 = '其他' then
                     '其他渠道'
                 else
                  channel2
               end channel2,
                case when trmnl_tp='IOS' then 'spring3g'
                 when channel1='SEM' and upper(cmpid) like '%BLAND%'then '品牌词' 
                 when channel1='SEM' and upper(cmpid) like '%GENERAL%'then '通用词'
                 when channel1='SEM' and upper(cmpid) like '%RUTE%'then '航线词'
                 when channel1='SEM' and upper(cmpid) like '%AREA%'then '地区词'
                 when channel1='SEM' and upper(cmpid) like '%JP%'then '竞品词'
                 when channel1='SEM' then'其他词'
                 else nvl(split_part(cmpid,',',1),'-') end cmpid,
               sum(UV) UV,
               sum(new_uv) new_uv,
               sum(PV) PV,
               0 allorders,
               0 orders,
               0 tickets,
               0 ticketsale,
               0 feesale,
               0 allsale，
               0 clients,
               0 pay_clients
          from dw.cj_sdaily_cmpid@to_ods
         where 1=1
           and visit_date >= to_date('2018-02-01', 'yyyy-mm-dd')
           and visit_date < to_date('2018-02-27', 'yyyy-mm-dd') + 1
         group by trunc(visit_date),trmnl_tp,
                  case
                    when upper(lang) like '%CN%' then
                     '简体中文'
                    when upper(lang) like '%EN%' then
                     '英文'
                    when upper(lang) like '%HK%' then
                     '繁体中文'
                    when upper(lang) like '%JP%' then
                     '日文'
                    when upper(lang) like '%KR%' then
                     '韩文'
                    when upper(lang) like '%TH%' then
                     '泰文'
                    else
                     '简体中文'
                  end,
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
                  case
                    when trmnl_tp = '微信' then
                     '微信渠道'
                    when trmnl_tp = 'Android' then
                     '安卓渠道'
                    when trmnl_tp = 'IOS' then
                     'IOS渠道'
                    when trmnl_tp in ('网站', 'M站') and channel2 = '非广告流量' then
                     '直接流量'
                    when trmnl_tp in ('网站', 'M站') and channel1 = '其他' then
                     '其他渠道'
                    else
                     channel2 end,
                  case when trmnl_tp='IOS' then 'spring3g'
                 when channel1='SEM' and upper(cmpid) like '%BLAND%'then '品牌词' 
                 when channel1='SEM' and upper(cmpid) like '%GENERAL%'then '通用词'
                 when channel1='SEM' and upper(cmpid) like '%RUTE%'then '航线词'
                 when channel1='SEM' and upper(cmpid) like '%AREA%'then '地区词'
                 when channel1='SEM' and upper(cmpid) like '%JP%'then '竞品词'
                 when channel1='SEM' then'其他词'
                 else nvl(split_part(cmpid,',',1),'-') end
     union
        select orderdate,
        roi.terminal,roi.lang,roi.channel1,roi.channel2,
    case when roi.channel1='SEM' and upper(roi.cmpid) like '%BLAND%'then '品牌词' 
         when roi.channel1='SEM' and upper(roi.cmpid) like '%GENERAL%'then '通用词'
         when roi.channel1='SEM' and upper(roi.cmpid) like '%RUTE%'then '航线词'
         when roi.channel1='SEM' and upper(roi.cmpid) like '%AREA%'then '地区词'
         when roi.channel1='SEM' and upper(roi.cmpid) like '%JP%'then '竞品词'
         when roi.channel1='SEM' then'其他词'
         else nvl(roi.cmpid,'-') end cmpid,
        0 UV,
        0 new_uv,
        0 PV,
        sum(roi.allorders) allorders,
        sum(roi.orders) orders,
        sum(roi.tickets) tickets,
        sum(case when roi.company_id=6 then roi.ticketsale/16 else roi.ticketsale end) ticketsale,
        sum(case when roi.company_id=6 then roi.valuesale/16 else roi.valuesale end) valuesale,
        sum(case when roi.company_id=6 then roi.allsale/16 else roi.allsale end) allsale,
        sum(roi.clients) clients,
        sum(roi.pay_clients) pay_clients
from               
(select trunc(order_date) orderdate,
r.terminal,r.order_language lang,r.ch1 channel1,r.ch2 channel2,r.cmpid,r.company_id,
               count(distinct r.ordernum) allorders,
               count(distinct case when r.flag_id = '已支付' then r.ordernum else null end) orders,
               sum(case when r.flag_id = '已支付' then r.tickets else 0 end) tickets,
               sum(case when r.flag_id = '已支付' then r.ticketsale else 0 end) ticketsale,
               sum(case when r.flag_id = '已支付' then r.valuesale else 0 end) valuesale,
               sum(case when r.flag_id = '已支付' then r.allsale else 0 end) allsale,
               count(distinct client_id) clients,
               count(distinct case when r.flag_id = '已支付' then r.client_id else null end) pay_clients 
          from dw.cj_roi_order r
         where 1=1
           and order_date >= to_date('2018-02-01', 'yyyy-mm-dd')
           and order_date < to_date('2018-02-27', 'yyyy-mm-dd') + 1
                group by  trunc(order_date),r.terminal,r.order_language,r.ch1,r.ch2,r.cmpid,r.company_id)roi
    where 1=1 
    group by  orderdate,roi.terminal,roi.lang,roi.channel1,roi.channel2,
case when roi.channel1='SEM' and upper(roi.cmpid) like '%BLAND%'then '品牌词' 
         when roi.channel1='SEM' and upper(roi.cmpid) like '%GENERAL%'then '通用词'
         when roi.channel1='SEM' and upper(roi.cmpid) like '%RUTE%'then '航线词'
         when roi.channel1='SEM' and upper(roi.cmpid) like '%AREA%'then '地区词'
         when roi.channel1='SEM' and upper(roi.cmpid) like '%JP%'then '竞品词'
         when roi.channel1='SEM' then'其他词'
         else nvl(roi.cmpid,'-') end ) M
 group by visitdate,
 M.trmnl_tp,
       M.lang,
       M.channel1,
       M.channel2,
       case when M.lang = '简体中文' and split_part(M.cmpid, '_', 4) is not null then
          substr(M.cmpid, 1, instr(M.cmpid, '_', 1, 3) - 1)
         else
          M.cmpid
       end 


---删除掉cmpid


select visitdate,
M.trmnl_tp,
       M.lang,
       M.channel1,
       M.channel2,     
       sum(M.UV) UV,
       sum(M.new_uv) new_uv,
       sum(M.PV) PV,
       sum(M.allorders) 提交订单数,
       sum(M.orders) 支付订单数,
       sum(M.tickets) 机票量,
       sum(M.ticketsale) 机票销售,
       sum(M.feesale) 辅收,
       sum(M.allsale) 总营收,
       sum(M.clients) 提交订单会员数,
       sum(M.pay_clients) 支付订单会员数
  from (select trunc(visit_date) visitdate,
  trmnl_tp,
               case
                 when upper(lang) like '%CN%' then
                  '简体中文'
                 when upper(lang) like '%EN%' then
                  '英文'
                 when upper(lang) like '%HK%' then
                  '繁体中文'
                 when upper(lang) like '%JP%' then
                  '日文'
                 when upper(lang) like '%KR%' then
                  '韩文'
                 when upper(lang) like '%TH%' then
                  '泰文'
                 else
                  '简体中文'
               end lang,
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
               case
                 when trmnl_tp = '微信' then
                  '微信渠道'
                 when trmnl_tp = 'Android' then
                  '安卓渠道'
                 when trmnl_tp = 'IOS' then
                  'IOS渠道'
                 when trmnl_tp in ('网站', 'M站') and channel2 = '非广告流量' then
                  '直接流量'
                  when trmnl_tp in ('网站', 'M站') and channel1 = '其他' then
                     '其他渠道'
                 else
                  channel2
               end channel2,              
               sum(UV) UV,
               sum(new_uv) new_uv,
               sum(PV) PV,
               0 allorders,
               0 orders,
               0 tickets,
               0 ticketsale,
               0 feesale,
               0 allsale，
               0 clients,
               0 pay_clients
          from dw.cj_sdaily_cmpid@to_ods
         where 1=1
           and visit_date >= to_date('2018-02-01', 'yyyy-mm-dd')
           and visit_date < to_date('2018-02-27', 'yyyy-mm-dd') + 1
         group by trunc(visit_date),trmnl_tp,
                  case
                    when upper(lang) like '%CN%' then
                     '简体中文'
                    when upper(lang) like '%EN%' then
                     '英文'
                    when upper(lang) like '%HK%' then
                     '繁体中文'
                    when upper(lang) like '%JP%' then
                     '日文'
                    when upper(lang) like '%KR%' then
                     '韩文'
                    when upper(lang) like '%TH%' then
                     '泰文'
                    else
                     '简体中文'
                  end,
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
                  case
                    when trmnl_tp = '微信' then
                     '微信渠道'
                    when trmnl_tp = 'Android' then
                     '安卓渠道'
                    when trmnl_tp = 'IOS' then
                     'IOS渠道'
                    when trmnl_tp in ('网站', 'M站') and channel2 = '非广告流量' then
                     '直接流量'
                    when trmnl_tp in ('网站', 'M站') and channel1 = '其他' then
                     '其他渠道'
                    else
                     channel2 end
                 
     union
        select orderdate,
        roi.terminal,roi.lang,roi.channel1,roi.channel2,
        0 UV,
        0 new_uv,
        0 PV,
        sum(roi.allorders) allorders,
        sum(roi.orders) orders,
        sum(roi.tickets) tickets,
        sum(case when roi.company_id=6 then roi.ticketsale/16 else roi.ticketsale end) ticketsale,
        sum(case when roi.company_id=6 then roi.valuesale/16 else roi.valuesale end) valuesale,
        sum(case when roi.company_id=6 then roi.allsale/16 else roi.allsale end) allsale,
        sum(roi.clients) clients,
        sum(roi.pay_clients) pay_clients
from               
(select trunc(order_date) orderdate,
r.terminal,r.order_language lang,r.ch1 channel1,r.ch2 channel2,r.company_id,
               count(distinct r.ordernum) allorders,
               count(distinct case when r.flag_id = '已支付' then r.ordernum else null end) orders,
               sum(case when r.flag_id = '已支付' then r.tickets else 0 end) tickets,
               sum(case when r.flag_id = '已支付' then r.ticketsale else 0 end) ticketsale,
               sum(case when r.flag_id = '已支付' then r.valuesale else 0 end) valuesale,
               sum(case when r.flag_id = '已支付' then r.allsale else 0 end) allsale,
               count(distinct client_id) clients,
               count(distinct case when r.flag_id = '已支付' then r.client_id else null end) pay_clients 
          from dw.cj_roi_order r
         where 1=1
           and order_date >= to_date('2018-02-01', 'yyyy-mm-dd')
           and order_date < to_date('2018-02-27', 'yyyy-mm-dd') + 1
                group by  trunc(order_date),r.terminal,r.order_language,r.ch1,r.ch2,r.company_id)roi
    where 1=1 
    group by  orderdate,roi.terminal,roi.lang,roi.channel1,roi.channel2 ) M
 group by visitdate,
 M.trmnl_tp,
       M.lang,
       M.channel1,
       M.channel2；
