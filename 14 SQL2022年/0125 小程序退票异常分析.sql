select /*+parallel(2) */ 
*
from (
select 
t1.flights_order_id 订单号,
t3.whole_flight 航班号,
t3.flights_date 航班日期,
t3.whole_segment 航段,
t3.traveller_name 旅客姓名,
t3.channel 渠道大类,
t3.sub_channel 订票终端,
t3.order_day 订单日,
t3.order_date 订单时间,
t3.ticket_price 票价,
t3.seats_name 舱位,
nvl(tt3.youhui_result,0)+nvl(tt5.use_money,0) 机票优惠金额,
tt6.gate_name 支付机构,
case when t3.channel in('网站','手机') then tt7.realname
when t3.channel in('OTA','旗舰店') then utl_raw.cast_to_varchar2(utl_raw.cast_to_raw(tt8.order_name))
else t3.order_linkman end 预订人姓名,
case when t3.channel in('网站','手机') then tt7.login_id
when t3.channel in('OTA','旗舰店') then tt8.order_mobile
else t3.work_tel end 注册预订电话,
t3.r_tel 紧急联系人电话,
t3.work_tel 联系人电话,
case when t1.TERMINAL_ID<0 and nvl(t1.web_id,0)=0 and t1.SALE_TYPE_DETAIL <=2 then '网站'
when t1.TERMINAL_ID<0 and nvl(t1.web_id,0)=0 and t1.SALE_TYPE_DETAIL in(5,10) then '小程序'
when t1.TERMINAL_ID<0 and nvl(t1.web_id,0)=0 and t1.SALE_TYPE_DETAIL in(3,8)  then 'IOS'
when t1.TERMINAL_ID<0 and nvl(t1.web_id,0)=0 and t1.SALE_TYPE_DETAIL in(4,9)  then 'Android'
else '线上渠道' end 退票终端,
t5.money_fy 退票费用,
t1.OPERATE_INFO 退票手机号 ,
'' 退票IP地址无,
t3.remote_ip 下单IP地址,
t4.flights_order_id 重购订单号,
count(distinct t1.flights_order_head_id),
sum(count(distinct t1.flights_order_head_id))over(partition by t1.OPERATE_INFO) xnum
 from stg.s_cq_return_ticket_channel t1
 join dw.fact_recent_order_detail t3 on t1.flights_order_head_id=t3.flights_Order_head_id
 join dw.da_order_drawback t5 on t1.flights_order_head_id=t5.flights_order_head_id
 left join dw.fact_recent_order_detail t4 on t3.segment_head_id=t4.segment_head_id and 
 t3.flights_order_head_id<>t4.flights_order_head_id
 and t3.codeno=t4.codeno and t4.order_date>=t5.money_date 
 left join stg.c_cq_order_youhui_detail tt3 on t1.flights_order_head_id=tt3.flights_order_head_id
left join dw.bi_yhq_use tt5 on tt5.flights_order_head_id=t1.flights_order_head_id
left join stg.p_cq_pay_gate tt6 on tt6.id=t3.pay_gate
left join dw.da_b2c_user tt7 on tt7.users_id=t3.client_id
left join cqsale.cq_order_ota_success_detail@to_air tt8 on t3.flights_order_id=tt8.flights_order_id
 
 where 
 t1.TERMINAL_ID<0 
 and nvl(t1.web_id,0)=0
 and t1.sale_type_detail in(5,10)
 and t1.OPERATE_INFO is not null 
 group by t1.flights_order_id,
t3.whole_flight,
t3.flights_date,
t3.whole_segment,
t3.traveller_name,
t3.channel,
t3.sub_channel,
t3.order_day,
t3.order_date,
t3.ticket_price,
t3.seats_name,
nvl(tt3.youhui_result,0)+nvl(tt5.use_money,0) ,
tt6.gate_name,
case when t3.channel in('网站','手机') then tt7.realname
when t3.channel in('OTA','旗舰店') then utl_raw.cast_to_varchar2(utl_raw.cast_to_raw(tt8.order_name))  
else t3.order_linkman end,
case when t3.channel in('网站','手机') then tt7.login_id
when t3.channel in('OTA','旗舰店') then tt8.order_mobile
else t3.work_tel end,
t3.r_tel,
t3.work_tel,
case when t1.TERMINAL_ID<0 and nvl(t1.web_id,0)=0 and t1.SALE_TYPE_DETAIL <=2 then '网站'
when t1.TERMINAL_ID<0 and nvl(t1.web_id,0)=0 and t1.SALE_TYPE_DETAIL in(5,10) then '小程序'
when t1.TERMINAL_ID<0 and nvl(t1.web_id,0)=0 and t1.SALE_TYPE_DETAIL in(3,8)  then 'IOS'
when t1.TERMINAL_ID<0 and nvl(t1.web_id,0)=0 and t1.SALE_TYPE_DETAIL in(4,9)  then 'Android'
else '线上渠道' end ,
t5.money_fy ,
t1.OPERATE_INFO  ,
t3.remote_ip ,
t4.flights_order_id
  
 )
where xnum>=100;