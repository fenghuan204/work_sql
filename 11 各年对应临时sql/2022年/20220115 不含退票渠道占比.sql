select '�������ں���Ʊ' ����,
to_char(t1.order_day,'yyyymm'),
       case when t1.channel in('��վ','�ֻ�') and t3.users_id is not null then '����-�ڴ���'
       when t1.channel in('��վ','�ֻ�') and t1.pay_gate in(15,29,31) then '����-�ڴ���'
       when t1.channel in('��վ','�ֻ�')  then '��������'
            when t1.channel in('OTA','�콢��') then 'OTA'
            when t1.sub_channel = 'CAACSC' then  'GP' 
            when t1.channel = 'B2G�����ͻ�' then 'TMCB2G'
            else t1.channel end,
       count(1),
       sum(count(1))over(partition by to_char(t1.order_day,'yyyymm'))
 from dw.fact_order_detail t1
 join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
 left join dw.da_restrict_userinfo t3 on t1.client_id=t3.users_id
 where t1.order_day>=date'2021-01-01'
   and t1.order_day< date'2022-01-12'
   and t1.seats_name is not null 
   and t1.company_id=0
   and t1.seats_name not in('B','G1','G','G2','O')
   group by to_char(t1.order_day,'yyyymm'),
       case when t1.channel in('��վ','�ֻ�') and t3.users_id is not null then '����-�ڴ���'
       when t1.channel in('��վ','�ֻ�') and t1.pay_gate in(15,29,31) then '����-�ڴ���'
       when t1.channel in('��վ','�ֻ�')  then '��������'
            when t1.channel in('OTA','�콢��') then 'OTA'
            when t1.sub_channel = 'CAACSC' then  'GP' 
            when t1.channel = 'B2G�����ͻ�' then 'TMCB2G'
            else t1.channel end
