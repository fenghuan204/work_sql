
---�鷳��ʦ��ȡ8��2��-16��������³ľ��ʼ������³ľ������������ȡ���ÿͶ����� ���� ������ϵ�绰/��ϵ�绰/����@��ϲ�� 
--лл ֮��ÿ��12�㷢12��������12�������ÿ���Ϣ 

select distinct t.flights_order_id ������,t1.name||' '||coalesce(t1.second_name,'') ����,
t.work_tel ��ϵ�绰,t1.r_tel ������ϵ�绰,t.email ����
from cqsale.cq_order@to_air t
join cqsale.cq_order_head@to_air t1 on t.flights_order_id=t1.flights_order_id
join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
where t1.r_flights_date>=to_date('2020-08-02','yyyy-mm-dd')
and t1.r_flights_date<=to_date('2020-08-16','yyyy-mm-dd')
--and to_char(t1.r_flights_date,'yyyymmdd') in('20200811','20200818','20200825')
 --and t1.whole_flight='9C8580'
 and t2.originairport_name='��³ľ��'
 and t2.destairport_name<>'����'
 and t1.flag_id in(3,5,40,41)
 and t1.whole_flight like '9C%'
  
  
  ---��³ľ����ۼ���������
  ---�鷳��ʦ��ȡ8��2��-16��������³ľ���������ÿͶ����� ���� ������ϵ�绰/��ϵ�绰/����@��ϲ�� 
  --лл ֮��ÿ��12�㷢12��������12�������ÿ���Ϣ 
  
select distinct t.flights_order_id ������,t1.name||' '||coalesce(t1.second_name,'') ����,
t.work_tel ��ϵ�绰,t1.r_tel ������ϵ�绰,t.email ����
from cqsale.cq_order@to_air t
join cqsale.cq_order_head@to_air t1 on t.flights_order_id=t1.flights_order_id
join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
where t1.r_flights_date>=to_date('2020-08-02','yyyy-mm-dd')
and t1.r_flights_date<=to_date('2020-08-16','yyyy-mm-dd')
--and to_char(t1.r_flights_date,'yyyymmdd') in('20200811','20200818','20200825')
 --and t1.whole_flight='9C8580'
 and t2.originairport_name='��³ľ��'
 and t2.destairport_name='����'
 and t1.flag_id in(3,5,40,41)
 and t1.whole_flight like '9C%';
 
 
 
 ---�鷳��ʦ��ȡ8��2��-16��������³ľ��ʼ������³ľ������������ȡ���ÿͶ����� ���� ������ϵ�绰/��ϵ�绰/����@��ϲ�� 
--лл ֮��ÿ��12�㷢12��������12�������ÿ���Ϣ 

select distinct t.flights_order_id ������,t1.name||' '||coalesce(t1.second_name,'') ����,
t.work_tel ��ϵ�绰,t1.r_tel ������ϵ�绰,t.email ����
from cqsale.cq_order@to_air t
join cqsale.cq_order_head@to_air t1 on t.flights_order_id=t1.flights_order_id
join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
where t1.r_flights_date>=to_date('2020-07-25','yyyy-mm-dd')
and t1.r_flights_date<=to_date('2020-08-09','yyyy-mm-dd')
--and to_char(t1.r_flights_date,'yyyymmdd') in('20200811','20200818','20200825')
 --and t1.whole_flight='9C8580'
 and t2.destairport_name='��³ľ��'
 and t1.flag_id in(3,5,40,41)
 and t1.whole_flight like '9C%'
