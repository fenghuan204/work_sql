1��	�������������� �����������׶�Լ�������������ռ����B2C�����ı���
2��	��Ӫҵ��ı����Ƕ��٣�����ҵ��ı����Ƕ��٣�
3��	���ƽ̨��Ӫ��ռ���Ƕ��٣�
4��	��ҵӪ���������٣�����Ӫ���������٣�
5��	�����ŵ��ж��ټң��ֲ��ڶ��ٳ��У�

select /*+parallel(4) */ 
to_char(t1.flights_date,'yyyy') ����,
case when t1.channel in('��վ','�ֻ�')   then '������������'
when t1.channel in('OTA','�콢��')  then 'OTA'
else '����' end ����,count(distinct t1.flights_order_id)  ������,
sum(case when t1.seats_name is not null then 1 else 0 end) �˻��˴�,
sum(t1.ticket_price+t1.ad_fy) ��Ʊ����,
sum(t1.ticket_price+t1.ad_fy+t1.port_pay+t1.other_fy+t1.sx_fy) ��Ʊ���׶�,
sum(t1.insurce_fee+t1.other_fee) ��������
  from  dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  where t1.flights_date>=to_date('20170101','yyyymmdd')
  and t1.flights_date< to_date('20190101','yyyymmdd')
  and t1.company_id=0
  and t1.flag_id =40
  group by to_char(t1.flights_date,'yyyy'),
case when t1.channel in('��վ','�ֻ�')   then '������������'
when t1.channel in('OTA','�콢��')  then 'OTA'
else '����' end 
  
  
  
  select 
t1.channel,count(1),sum(count(1))over(partition by 1)
 from dw.fact_order_detail t1
 join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
 where t1.flights_date>=to_date('2018-01-01','yyyy-mm-dd')
   and t1.flights_date< to_date('2019-01-01','yyyy-mm-dd')
   and t1.flag_id=40
   and t1.seats_name is not null
   and t1.seats_name not in('B','G','G1','G2','O')
   and t1.company_id=0
   group by t1.channel
   
   
   
   select 
t1.channel,count(1)
 from dw.fact_order_detail t1
 join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
 where t1.flights_date>=to_date('2018-01-01','yyyy-mm-dd')
   and t1.flights_date< to_date('2019-01-01','yyyy-mm-dd')
   and t1.flag_id=40
   and t1.seats_name is not null
   and t1.channel='�ֻ�'
   and t1.station_id in(5,10)
   and t1.seats_name not in('B','G','G1','G2','O')
   and t1.company_id=0
   group by t1.channel
