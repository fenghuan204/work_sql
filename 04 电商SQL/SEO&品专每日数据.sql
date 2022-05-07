===========SEO数据======================================================
select sdate,trmnl_tp,
       sum(M.UV) UV,
       sum(M.PV) PV,
       sum(M.allorders) 提交订单数,
       sum(M.orders) 支付订单数,
       sum(M.tickets) 机票量,
       sum(M.ticketsale) 机票销售,
       sum(M.feesale) 辅收,
       sum(M.allsale) 总营收,
       sum(M.clients) 提交订单会员数,
       sum(M.pay_clients) 支付订单会员数
  from (select trunc(visit_date) sdate,trmnl_tp,
               sum(UV) UV,
               sum(PV) PV,
               0 allorders,
               0 orders,
               0 tickets,
               0 ticketsale,
               0 feesale,
               0 allsale，
               0 clients,
               0 pay_clients
        from dw.cj_sdaily_seo@to_ods t
         left join (select source_media
                             from dw.cj_sdaily_seo@to_ods roi
                             join dw.cj_search_rules o3 on upper(roi.source_media) like '%' ||upper(o3.keywds) || '%'
                             where trunc(visit_date) >=to_date('2018-03-01', 'yyyy-mm-dd')
                               and trunc(visit_date)<to_date('2018-04-22', 'yyyy-mm-dd') + 1
                               group by source_media) seo on seo.source_media=t.source_media
         where visit_date >= to_date('2018-03-01', 'yyyy-mm-dd')
           and visit_date < to_date('2018-04-22', 'yyyy-mm-dd') + 1
           and cmpid='-'
           and seo.source_media is not null
         group by trunc(visit_date),trmnl_tp
     union all
 select  roi.orderday,
 roi.terminal,
        0 UV,0 PV,
        sum(roi.allorders) allorders,
        sum(roi.orders) orders,
        sum(roi.tickets) tickets,
        sum(case when roi.company_id=6 then roi.ticketsale/16 else roi.ticketsale end) ticketsale,
        sum(case when roi.company_id=6 then roi.valuesale/16 else roi.valuesale end) valuesale,
        sum(case when roi.company_id=6 then roi.allsale/16 else roi.allsale end) allsale,
        sum(roi.clients) clients,
        sum(roi.pay_clients) pay_clients 
from               
(select trunc(r.order_date) orderday,
r.terminal,r.company_id,
               count(distinct r.ordernum) allorders,
               count(distinct case when r.flag_id = '已支付' then r.ordernum else null end) orders,
               sum(case when r.flag_id = '已支付' then  r.tickets else 0 end) tickets,
               sum(case  when r.flag_id = '已支付' then r.ticketsale  else 0 end) ticketsale,
               sum(case when r.flag_id = '已支付' then r.valuesale else 0  end) valuesale,
               sum(case when r.flag_id = '已支付' then r.allsale  else  0 end) allsale,
                count(distinct client_id) clients,
                count(distinct case when r.flag_id = '已支付' then r.client_id else null end) pay_clients
          from dw.cj_roi_order r
          left join dw.da_restrict_userinfo t5 on t5.users_id=r.client_id
          left join dw.da_user_purchase t6 on t6.users_id= r.client_id and trunc(t6.first_orderdate)=r.order_date
         where r.order_date >= to_date('2018-03-01', 'yyyy-mm-dd')
           and r.order_date < to_date('2018-04-22', 'yyyy-mm-dd') + 1
           and r.ch1='SEO'
         group by trunc(r.order_date),
r.terminal,r.company_id)roi
    group by roi.orderday,
 roi.terminal ) M
 group by sdate,trmnl_tp

 
 
 
 
 
 
 select M.sdate,
 M.trmnl_tp,
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
  from (select  trunc(visit_date) sdate,
  trmnl_tp,
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
               and visit_date >= to_date('2018-03-01', 'yyyy-mm-dd')
           and visit_date < to_date('2018-04-22', 'yyyy-mm-dd') + 1
         group by trunc(visit_date),trmnl_tp,                  
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
        select  roi.orderday,roi.terminal,roi.channel1,roi.channel2,
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
(select  trunc(r.order_date) orderday,
r.terminal,r.ch1 channel1,r.ch2 channel2,r.company_id,
               count(distinct r.ordernum) allorders,
               count(distinct case when r.flag_id = '已支付' then r.ordernum else null end) orders,
               sum(case when r.flag_id = '已支付' then r.tickets else 0 end) tickets,
               sum(case when r.flag_id = '已支付' then r.ticketsale else 0 end) ticketsale,
               sum(case when r.flag_id = '已支付' then r.valuesale else 0 end) valuesale,
               sum(case when r.flag_id = '已支付' then r.allsale else 0 end) allsale,
               count(distinct client_id) clients,
               count(distinct case when r.flag_id = '已支付' then r.client_id else null end) pay_clients
          from dw.cj_roi_order r
          left join dw.da_restrict_userinfo t5 on t5.users_id=r.client_id
         where 1=1
           and order_date >= to_date('2018-03-01', 'yyyy-mm-dd')
           and order_date < to_date('2018-04-22', 'yyyy-mm-dd') + 1
              group by  trunc(r.order_date) ,r.terminal,r.ch1,r.ch2,r.cmpid,r.company_id
                )roi
    group by roi.orderday,roi.terminal,roi.channel1,roi.channel2 ) M
where 1=1
 group by M.sdate,
 M.trmnl_tp,
       M.channel1,
       M.channel2


