/*2020��7��30�����ﺽ���Ͼ�»�ڹ��ʻ������ں�������۵Ĺ�̨���ǻ��ڴ�Ŀǰ��T2��վ¥��Ǩ��T1��վ¥��
��Ҫ��ȡ�ÿ�������7��20��14:55��ǰ������7��30�գ��������Ͼ��������ں�����������к��ߵ��ÿ�������
��������/�����/��������/����/����/������ϵ�绰/��ϵ�绰/���䣩*/

select distinct t.flights_order_id ������,t1.whole_flight �����,t1.r_flights_date ��������,
t1.whole_segment ����,t1.name||' '||coalesce(t1.second_name,'') ����,
t.work_tel ��ϵ�绰,t1.r_tel ������ϵ�绰,t.email ����
from cqsale.cq_order@to_air t
join cqsale.cq_order_head@to_air t1 on t.flights_order_id=t1.flights_order_id
where t1.r_flights_date>=to_date('2020-08-02','yyyy-mm-dd')
and t.order_date< to_date('2020-07-31 15:45','yyyy-mm-dd hh24:mi')
--and t1.r_nation_flag=1
 and t1.whole_segment like '%URC%'
  and t1.flag_id in(3,5,40,41);



  


 
