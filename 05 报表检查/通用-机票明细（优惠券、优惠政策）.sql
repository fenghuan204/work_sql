select t1.order_day,case when t4.users_id is not null then '�ڴ�'
else '�Ǵ���' end �������,t1.sub_channel ����С��,t1.flights_date,
t2.flights_segment_name ����,t1.flag_id,t1.seat_type,t1.ticket_price,t1.min_seat_price,
t1.insurce_fee+t1.other_fee ����,t3.youhui_id �Żݹ���ID,
   case when t6.yh_style=2 then '��������'
            when t6.seg_lc_type =2 then '��������'
            when t6.seg_lc_type =3 then '��ת����'
            when t6.yh_style = 1 then 'B2GЭ������'
            when t6.yh_style = 0 then '��������'
            end ��������, 
t3.youhui_result �Żݽ��,t5.use_money �Ż�ȯʹ�ý��,t7.act_name ȯ��Ӧ�����,
t4.feature ��������ID,
t4.feature_value ��������ֵ
from dw.Fact_recent_Order_Detail t1
join dw.da_flight t2 on t2.segment_head_id=t1.segment_head_id
left join stg.c_cq_order_youhui_detail t3 on t1.flights_order_head_id=t3.flights_order_head_id
left join stg.c_cq_youhui_policy_main t6 on t3.youhui_id=t6.id
left join dw.bi_yhq_use t5 on t5.flights_order_head_id=t1.flights_order_head_id
left join dw.bi_yhq_batch t7 on t5.batch_id=t7.batch_id
left join if.v_da_restrict_userinfo t4 on t1.client_id=t4.users_id
where t1.flights_Order_id in('ZJVGQL','ZJZNRB')