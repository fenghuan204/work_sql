select t1.order_day,case when t4.users_id is not null then '黑代'
else '非代理' end 代理与否,t1.sub_channel 渠道小类,t1.flights_date,
t2.flights_segment_name 航段,t1.flag_id,t1.seat_type,t1.ticket_price,t1.min_seat_price,
t1.insurce_fee+t1.other_fee 辅收,t3.youhui_id 优惠规则ID,
   case when t6.yh_style=2 then '绿翼立减'
            when t6.seg_lc_type =2 then '往返立减'
            when t6.seg_lc_type =3 then '中转立减'
            when t6.yh_style = 1 then 'B2G协议立减'
            when t6.yh_style = 0 then '基本立减'
            end 立减类型, 
t3.youhui_result 优惠金额,t5.use_money 优惠券使用金额,t7.act_name 券对应活动名称,
t4.feature 代理特征ID,
t4.feature_value 代理特征值
from dw.Fact_recent_Order_Detail t1
join dw.da_flight t2 on t2.segment_head_id=t1.segment_head_id
left join stg.c_cq_order_youhui_detail t3 on t1.flights_order_head_id=t3.flights_order_head_id
left join stg.c_cq_youhui_policy_main t6 on t3.youhui_id=t6.id
left join dw.bi_yhq_use t5 on t5.flights_order_head_id=t1.flights_order_head_id
left join dw.bi_yhq_batch t7 on t5.batch_id=t7.batch_id
left join if.v_da_restrict_userinfo t4 on t1.client_id=t4.users_id
where t1.flights_Order_id in('ZJVGQL','ZJZNRB')