--2019�괺�ﺽ���Ϻ����ֺ��֣�ͨ�����������е������ÿ�������

select t2.originairport_name,t2.destairport_name,count(1)
 from dw.fact_order_detail t1
 join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
 where t1.flights_date>=to_date('2019-01-01','yyyy-mm-dd')
  and t1.flights_date< to_date('2020-01-01','yyyy-mm-dd')
  and t1.flag_id=40
  and t1.seats_name is not null
  and t1.company_id=0
  and t2.flights_city_name like '%�Ϻ�%'
  group by t2.originairport_name,t2.destairport_name;
