select * 
from stg.f_day_statistics t1
where t1.date_time>= to_date('2019-02-01','yyyy-mm-dd')
and t1.date_time<=to_date('2019-02-28','yyyy-mm-dd');

��ֹ2019��2�µ� ���ӹ�ģ
��ֹ2019��2�µ�  �����������ڡ����ʡ���������ͨ����С����� 

������4�µ׵�ʱ�� �ٳ�һ�� ��������������ݣ�


1����ֹ��2019��2�µ� 84�ܷɻ�

2��18/19�궬���������� (���ߣ�--��ֹ��2�µ׻��ڷɺ���

select distinct t2.nationflag ��������,t2.flights_segment_name ����,t2.origincity_name ʼ������,t2.destcity_name Ŀ�ĳ���
from dw.da_flight t2
where t2.flight_date<=to_date('2019-02-28','yyyy-mm-dd')
  and t2.flight_date>=to_date('2018-10-28','yyyy-mm-dd')
  and t2.company_id=0
  and t2.flag<>2

3�� 18/19�궬���������� (���С����㣩--��ֹ��2�µ��ڷɳ��м�����


select distinct t2.origin_country ����,t2.origincity_name ����,t2.originairport_name ����
from dw.da_flight t2
where t2.flight_date<=to_date('2019-02-28','yyyy-mm-dd')
  and t2.flight_date>=to_date('2018-10-28','yyyy-mm-dd')
  and t2.company_id=0
  and t2.flag<>2
