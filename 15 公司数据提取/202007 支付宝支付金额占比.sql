/*喜欢，今年支付宝总是搞活动，帮忙做一个Excel统计一下上周的份额，
份额这么计算 支付宝的和支付宝无线的、微信支付的合计在一起算100%，然后看支付宝合计的占总体的比率*/
--喜欢，7.27-8.9和8.10-8.23的支付宝份 发一下

select t1.order_day 订单日期,case when t1.gate_name like '%微信%' then '微信'
when t1.gate_name like '%支付宝%' then '支付宝' end 支付方式,t1.gate_name 支付渠道,
sum(t1.ticket_price+t1.port_pay+t1.ad_fy+t1.other_fy+t1.insurce_fee+t1.other_fee) 支付金额,
count(1) 机票量 ,count(distinct t1.flights_Order_id) 订单号,
sum(count(1))over(partition by t1.order_day ) tonum,
round(count(1)/sum(count(1))over(partition by t1.order_day )*100,2) 占比
 from dw.fact_order_detail t1
 where t1.order_day>=trunc(sysdate)-30
   and t1.order_day< trunc(sysdate)
   and t1.gate_name in('微信小程序','财付通微信','支付宝','支付宝无线')
   and t1.channel in('网站','手机')
   and t1.whole_flight like '9C%'
   group by t1.order_day,case when t1.gate_name like '%微信%' then '微信'
when t1.gate_name like '%支付宝%' then '支付宝' end,t1.gate_name
   

   
   
 
 
 
