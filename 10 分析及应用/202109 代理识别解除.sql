select t1.order_day,case when t1.channel in('��վ','�ֻ�') then '��������'
when t1.channel in('OTA','�콢��') then 'OTA'
else '����' end ���� ,case when t1.gate_name like '%���ÿ�%' then '���ÿ�'
when t1.gate_name like '%�ױ�%' then '�ױ�'
else '����' end ֧����ʽ,t1.sub_channel,
case when t4.flights_order_head_id is not null and t4.is_beneficiary = 1 then
          '��������'
         when t4.flights_order_head_id is not null and t4.is_beneficiary = 0 then
          '��������'
         else
          '��ͨ����'
       end ��������,
case when t2.users_id is not null then 1 else 0 end �������,
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
 and t1.channel  in('��վ','�ֻ�')
 group by t1.order_day,case when t1.channel in('��վ','�ֻ�') then '��������'
when t1.channel in('OTA','�콢��') then 'OTA'
else '����' end  ,case when t1.gate_name like '%���ÿ�%' then '���ÿ�'
when t1.gate_name like '%�ױ�%' then '�ױ�'
else '����' end ,t1.sub_channel,
case
         when t4.flights_order_head_id is not null and t4.is_beneficiary = 1 then
          '��������'
         when t4.flights_order_head_id is not null and t4.is_beneficiary = 0 then
          '��������'
         else
          '��ͨ����'
       end ,
case when t2.users_id is not null then 1 else 0 end ,
t1.channel,t1.sub_channel,t1.client_id,t1.terminal_id,t5.user_id,t5.flag
