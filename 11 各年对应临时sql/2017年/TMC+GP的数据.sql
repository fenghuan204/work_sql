/*�����ߣ��������á���ɫ���͡���˹�����人ʤ�⡢���ֹ���
δ���ߣ������غ��������ס���·�ϡ����á��������ͨ�����ǹذ�ͨ������HRG������BCD����Ϊ��ͨ���������⡢�������á�������ͨ���������̡���ȥ�Ƽ�*/


select case when h1.channel in('B2G�����ͻ�','TMC') then 'B2G+TMC'
when h1.channel in('OTA','�콢��') then 'OTA+�콢��'
when h1.channel in('B2B','��������') then 'B2B+��������'
else h1.channel end ����,
h1.channel ������,
sum(ticket) ����
from(
select  case when t1.sub_channel like '%CAACSC%' then 'GP'
when regexp_like(t1.sub_channel,'(���ֹ���)|(����)|(��ɫ����)|(��˹��)|(ʤ��)') then 'TMC'
when t1.channel='�ֻ�' and t1.station_id =2 then 'M��վ'
            when t1.channel='�ֻ�' and t1.station_id in(5,10) then '΢��'
            when t1.channel='�ֻ�' and t1.station_id >2 then 'APP'
            else t1.channel end channel,
        count(1)  ticket       
   from dw.fact_order_detail t1
   join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
   where t1.flights_date>=to_date('2017-10-01','yyyy-mm-dd')
     and t1.flights_date< to_date('2017-11-01','yyyy-mm-dd')
     and t1.company_id=0
     and t1.seats_name is not null
     and t1.seats_name not in('B','G','G1','G2','O')
  group by case when t1.sub_channel like '%CAACSC%' then 'GP'
when regexp_like(t1.sub_channel,'(���ֹ���)|(����)|(��ɫ����)|(��˹��)|(ʤ��)') then 'TMC'
when t1.channel='�ֻ�' and t1.station_id =2 then 'M��վ'
            when t1.channel='�ֻ�' and t1.station_id in(5,10) then '΢��'
            when t1.channel='�ֻ�' and t1.station_id >2 then 'APP'
            else t1.channel end)h1
            group by case when h1.channel in('B2G�����ͻ�','TMC') then 'B2G+TMC'
when h1.channel in('OTA','�콢��') then 'OTA+�콢��'
when h1.channel in('B2B','��������') then 'B2B+��������'
else h1.channel end ,
h1.channel
