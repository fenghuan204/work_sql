select t1.order_day ����,
        case when t1.channel in('��վ','�ֻ�') then '��������'
            else '����' end ����,
        case
         when t1.channel in('��վ','�ֻ�') and t5.users_id is not null then
          'odsʶ��'
          when t1.channel in('��վ','�ֻ�') then '��������'
          else '����' end odsʶ��,
        case
         when t1.channel in('��վ','�ֻ�') and t6.users_id is not null then
          'dwʶ��'
          when t1.channel in('��վ','�ֻ�') then '��������'
          else '����' end dwʶ��,
          
       case when t1.channel in('��վ','�ֻ�') and
              t1.pay_gate in (15, 29, 31) then
          '���������ױ����ÿ�'
         when t1.channel in('��վ','�ֻ�') then '��������'
          else '����' end ֧����ʽ,  
          case
         when t4.flights_order_head_id is not null and t4.is_beneficiary = 1 then
          '����������'
         when t4.flights_order_head_id is not null and t4.is_beneficiary = 0 then
          '��������'
         else
          '��ͨ����'
       end ��������,
       case when t1.channel in('��վ','�ֻ�') and t5.users_id is not null then 1
       when t1.channel in('��վ','�ֻ�') and t1.pay_gate in (15, 29, 31) then 1
            when t1.channel in('��վ','�ֻ�') and t6.users_id is not null then 1
         else 0 end �ۺ�1,
         case when t1.channel in('��վ','�ֻ�') and t6.users_id is not null then 1
       when t1.channel in('��վ','�ֻ�') and t1.pay_gate in (15, 29, 31) then 1
            when t1.channel in('��վ','�ֻ�') and t6.users_id is not null then 1
         else 0 end �ۺ�2,
       count(1) Ʊ��
  from dw.fact_order_detail t1
   join dw.da_flight t2 on t1.segment_head_id = t2.segment_head_id
  left join dw.da_restrict_userinfo@to_ods t5 on t1.client_id = t5.users_id
  left join dw.da_restrict_userinfo t6 on t1.client_id=t6.users_id
  left join (select flights_order_head_id,
                    nvl(is_beneficiary, 0) is_beneficiary,
                    youhui_result
               from stg.c_cq_order_youhui_detail
              where product_type = 0
                and yh_ret_time is null
                and youhui_result is not null
                and youhui_id in (1129,1130, 1137,1138)
                and trunc(create_date) >= trunc(sysdate) - 60) t4 on t1.flights_order_head_id =
                                                              t4.flights_order_head_id
 where t1.order_day >= trunc(sysdate) - 30
   and t1.order_day < trunc(sysdate)
   --and t1.flights_date >= trunc(sysdate - 30) - 7
   and t2.flag <> 2
   and t1.flag_id in (3, 5, 40, 41)
   and t1.seats_name is not null
   and t1.whole_flight like '9C%'
 group by t1.order_day,
       case when t1.channel in('��վ','�ֻ�') then '��������'
            else '����' end,
        case
         when t1.channel in('��վ','�ֻ�') and t5.users_id is not null then
          'odsʶ��'
          when t1.channel in('��վ','�ֻ�') then '��������'
          else '����' end,
        case
         when t1.channel in('��վ','�ֻ�') and t6.users_id is not null then
          'dwʶ��'
          when t1.channel in('��վ','�ֻ�') then '��������'
          else '����' end,
          
       case when t1.channel in('��վ','�ֻ�') and
              t1.pay_gate in (15, 29, 31) then
          '���������ױ����ÿ�'
         when t1.channel in('��վ','�ֻ�') then '��������'
          else '����' end,
          case
         when t4.flights_order_head_id is not null and t4.is_beneficiary = 1 then
          '����������'
         when t4.flights_order_head_id is not null and t4.is_beneficiary = 0 then
          '��������'
         else
          '��ͨ����'
       end, case when t1.channel in('��վ','�ֻ�') and t5.users_id is not null then 1
       when t1.channel in('��վ','�ֻ�') and t1.pay_gate in (15, 29, 31) then 1
            when t1.channel in('��վ','�ֻ�') and t6.users_id is not null then 1
         else 0 end ,
         case when t1.channel in('��վ','�ֻ�') and t6.users_id is not null then 1
       when t1.channel in('��վ','�ֻ�') and t1.pay_gate in (15, 29, 31) then 1
            when t1.channel in('��վ','�ֻ�') and t6.users_id is not null then 1
         else 0 end
