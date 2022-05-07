select case
          when t1.order_day >= to_date('2018-09-24', 'yyyy-mm-dd')
          and t1.order_day <  to_date('2018-10-01', 'yyyy-mm-dd') then
          '0924~0930'
         when t1.order_day >= to_date('2018-10-01', 'yyyy-mm-dd')
          and t1.order_day <  to_date('2018-10-08', 'yyyy-mm-dd') then
          '1001~1008'
         when t1.order_day >= to_date('2018-10-08', 'yyyy-mm-dd')
          and t1.order_day <  to_date('2018-10-15', 'yyyy-mm-dd') then
          '1008~1014'       
       end �Ա�����,       
       case
         when t1.channel in ('�ֻ�', '��վ') and t3.users_id is not null then
          '���Ϻڴ�'
         when t1.channel in ('�ֻ�', '��վ') then '����ֱ��'
         when t1.channel in('B2B', '��������', 'B2G�����ͻ�') then '����ֱ��'
         when t1.channel in ('OTA', '�콢��') then
          'OTA�콢��'
         when t1.channel in ('B2B����') then
          'B2B����'
       end ��������,
       case
         when t1.channel = '�ֻ�' and t1.station_id = 2 then
          'M��վ'
         when t1.channel = '�ֻ�' and t1.station_id in (5, 10) then
          '΢��'
         when t1.channel = '�ֻ�' and t1.station_id in (3, 8) then
          'IOS'
         when t1.channel = '�ֻ�' and t1.station_id in (4, 9) then
          'Andriod'
         else
          t1.channel
       end ����,
       t2.nationflag ��������,
       case
         when t1.seats_name in ('B', 'G', 'G1', 'O') then
          'BGO'
         else
          '��BGO'
       end ��λ����,
       t2.flights_segment_name,
       count(1) ����,
       sum(t1.ticket_price) ��Ʊ���,
       sum(t1.price) �񺽹����ۺ�
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id = t2.segment_head_id
  left join dw.da_restrict_userinfo t3 on t1.client_id = t3.users_id
 where t1.order_day >= to_date('2018-09-24', 'yyyy-mm-dd')
   and t1.order_day < to_date('2018-10-15', 'yyyy-mm-dd')
   and t2.flag <> 2
   and t1.whole_flight like '9C%'
   and t1.seats_name is not null
 group by case
          when t1.order_day >= to_date('2018-09-24', 'yyyy-mm-dd')
          and t1.order_day <  to_date('2018-10-01', 'yyyy-mm-dd') then
          '0924~0930'
         when t1.order_day >= to_date('2018-10-01', 'yyyy-mm-dd')
          and t1.order_day <  to_date('2018-10-08', 'yyyy-mm-dd') then
          '1001~1008'
         when t1.order_day >= to_date('2018-10-08', 'yyyy-mm-dd')
          and t1.order_day <  to_date('2018-10-15', 'yyyy-mm-dd') then
          '1008~1014'       
       end ,       
       case
         when t1.channel in ('�ֻ�', '��վ') and t3.users_id is not null then
          '���Ϻڴ�'
         when t1.channel in ('�ֻ�', '��վ') then '����ֱ��'
         when t1.channel in('B2B', '��������', 'B2G�����ͻ�') then '����ֱ��'
         when t1.channel in ('OTA', '�콢��') then
          'OTA�콢��'
         when t1.channel in ('B2B����') then
          'B2B����'
       end ,
       case
         when t1.channel = '�ֻ�' and t1.station_id = 2 then
          'M��վ'
         when t1.channel = '�ֻ�' and t1.station_id in (5, 10) then
          '΢��'
         when t1.channel = '�ֻ�' and t1.station_id in (3, 8) then
          'IOS'
         when t1.channel = '�ֻ�' and t1.station_id in (4, 9) then
          'Andriod'
         else
          t1.channel
       end ,
       t2.nationflag ,
       case
         when t1.seats_name in ('B', 'G', 'G1', 'O') then
          'BGO'
         else
          '��BGO'
       end ,
       t2.flights_segment_name
