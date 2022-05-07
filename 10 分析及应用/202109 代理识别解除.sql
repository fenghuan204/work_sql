select t1.order_day,case when t1.channel in('网站','手机') then '线上渠道'
when t1.channel in('OTA','旗舰店') then 'OTA'
else '其他' end 渠道 ,case when t1.gate_name like '%商旅卡%' then '商旅卡'
when t1.gate_name like '%易宝%' then '易宝'
else '其他' end 支付方式,t1.sub_channel,
case when t4.flights_order_head_id is not null and t4.is_beneficiary = 1 then
          '亲友立减'
         when t4.flights_order_head_id is not null and t4.is_beneficiary = 0 then
          '绿翼立减'
         else
          '普通购买'
       end 立减类型,
case when t2.users_id is not null then 1 else 0 end 代理与否,
t1.channel,t1.sub_channel,t1.client_id,t1.terminal_id,t5.user_id,t5.flag,
count(1)
from dw.fact_order_detail t1
left join dw.da_restrict_userinfo t2 on t1.client_id=t2.users_id
left join (select t1.flights_order_head_id,
                    nvl(t1.is_beneficiary, 0) is_beneficiary,
                    t1.youhui_result
               from stg.c_cq_order_youhui_detail t1
               join stg.c_cq_youhui_policy_main t2 on t1.youhui_id=t2.id
              where t1.product_type = 0
                and t1.yh_ret_time is null
                and t1.youhui_result is not null
                and t2.YH_STYLE=2
                and t1.create_date >= trunc(sysdate) - 30)t4 on t1.flights_order_head_id=t4.flights_order_head_id
 left join stg.s_cq_user_restrict t5 on t1.client_id=t5.user_id
where t1.order_day>=trunc(sysdate)-30
 and t1.seats_name not in('B','G1','G','G2','O')
 and t1.company_id=0
 and t1.terminal_id<0
 and t4.flights_order_head_id is not null
 and t4.is_beneficiary=1
 and t2.users_id is not null
 and t1.users_id is not null
 and t1.channel  in('网站','手机')
 group by t1.order_day,case when t1.channel in('网站','手机') then '线上渠道'
when t1.channel in('OTA','旗舰店') then 'OTA'
else '其他' end  ,case when t1.gate_name like '%商旅卡%' then '商旅卡'
when t1.gate_name like '%易宝%' then '易宝'
else '其他' end ,t1.sub_channel,
case
         when t4.flights_order_head_id is not null and t4.is_beneficiary = 1 then
          '亲友立减'
         when t4.flights_order_head_id is not null and t4.is_beneficiary = 0 then
          '绿翼立减'
         else
          '普通购买'
       end ,
case when t2.users_id is not null then 1 else 0 end ,
t1.channel,t1.sub_channel,t1.client_id,t1.terminal_id,t5.user_id,t5.flag
