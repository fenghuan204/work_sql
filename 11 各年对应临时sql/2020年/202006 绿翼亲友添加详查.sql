select t1.flights_order_head_id,t1.flights_order_id,t1.order_date ����,
t1.remote_ip �µ�IP,
t1.work_tel ��ϵ��ʽ,
t1.r_tel �˻�����ϵ��ʽ,
t1.flights_date ��������,
t1.client_id ע��ID,
t9.reg_date ��ͨע������,
t9.register_ip ��ͨע��IP,
t9.reg_city ��ͨע�����,
t8.realname ��������,
t8.reg_date ����ע������,
t8.register_ip ����ע��IP,
t8.reg_city ����ע�����,
t8.login_id ����ע���ֻ���,
t7.create_date �����������,
t7.mobile ��������ֻ���,
t1.traveller_name,
t1.codetype,
t1.codeno,
t77.codtype,
t77.last_time,
t77.flag,
--lower(md5(t8.login_Id)) ע���ֻ���MD5���ܣ�
        case when t1.channel in('��վ','�ֻ�') then '��������'
            else '����' end ����,
     /*   case
         when t1.channel in('��վ','�ֻ�') and t5.users_id is not null then
          'odsʶ��'
          when t1.channel in('��վ','�ֻ�') then '��������'
          else '����' end odsʶ��,*/
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
       case when t1.channel in('��վ','�ֻ�') and t6.users_id is not null then 1
       when t1.channel in('��վ','�ֻ�') and t1.pay_gate in (15, 29, 31) then 1
            when t1.channel in('��վ','�ֻ�') and t6.users_id is not null then 1
         else 0 end ʶ������
         
  from dw.fact_order_detail t1
   join dw.da_flight t2 on t1.segment_head_id = t2.segment_head_id
  --left join dw.da_restrict_userinfo@to_ods t5 on t1.client_id = t5.users_id
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
 left join (select t1.users_id,t2.code_no,min(t1.create_time) create_date,max(t1.mobile) mobile 
      from cust.cq_flights_benefic_users@to_air t1
      left join cust.cq_benefic_users_codes@to_air t2 on t2.benefic_users_id = t1.crm_favoree_id
      where t1.status = 1
      and t2.flag = 1
      and trunc(t1.create_time) >= to_date('2020-03-01', 'yyyy-mm-dd')
      and trunc(t1.create_time) < trunc(sysdate)
      group by t1.users_id,t2.code_no)t7 on t1.client_id=t7.users_id and t1.codeno=t7.code_no
  left join (select t1.users_id,t2.code_no,min(t1.create_time) create_date,max(t1.mobile) mobile,max(t2.code_type) codtype,
  max(t2.last_update_time) last_time,max(t2.flag) flag
      from cust.cq_flights_benefic_users@to_air t1
      left join cust.cq_benefic_users_codes@to_air t2 on t2.benefic_users_id = t1.crm_favoree_id
      where  trunc(t1.create_time) >= to_date('2020-03-01', 'yyyy-mm-dd')
      and trunc(t1.create_time) <=trunc(sysdate)
      group by t1.users_id,t2.code_no)t77 on t1.client_id=t77.users_id and t1.codeno=t77.code_no  
      
    
 left join dw.da_lyuser t8 on t1.client_id=t8.users_id_fk
 left join dw.da_b2c_user t9 on t1.client_id=t9.users_id
 where t1.order_day >= trunc(sysdate) - 7
   and t1.order_day < sysdate
   and t1.flights_date >= trunc(sysdate - 1) - 7
   and t2.flag <> 2
   --and t1.flights_order_head_id=241409791
   and t1.flag_id in (3, 5, 40, 41)
   and t1.seats_name is not null
    and t4.is_beneficiary = 1
   and t1.whole_flight like '9C%'
   and t1.channel in('��վ','�ֻ�')
   and t4.flights_order_head_id is not null
   and (t6.users_id is not null or t1.pay_gate in(15, 29, 31))
   --and t7.users_id is null   --���֤���ŵ�©������ƥ��
   --and t1.client_id=189220474  --��������
   
   
   
