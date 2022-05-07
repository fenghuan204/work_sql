select h1.createdate,h1.hour,h1.stype,h1.status,sum(ticketnum)
from(
select trunc(t1.create_date) createdate,
to_char(t1.create_date,'hh24') hour,
case when t1.COMBO_NAME='��ɾͷɻ�ѡ���' then '��ͨ��2999��Ʊ'
when t1.COMBO_NAME='��ɾͷɾ�ѡ���' then '������3499��Ʊ'
when t1.COMBO_NAME='��ɾͷ���ѡ���' then '������3999��Ʊ'
end stype,decode(t1.STATUS,0,'δ�һ�',1,'�Ѷһ�',2,'����',3,'ȡ����ƱȨ��') status,
count(1) ticketnum
 from yhq.cq_yhq_unlimited_combo@to_air t1
 where t1.CREATE_DATE>=to_DATE('2020-07-15 18:00:00','yyyy-mm-dd hh24:mi:ss')
 and t1.combo_name in('��ɾͷɻ�ѡ���','��ɾͷɾ�ѡ���','��ɾͷ���ѡ���')
 group by trunc(t1.create_date) ,
to_char(t1.create_date,'hh24') ,
case when t1.COMBO_NAME='��ɾͷɻ�ѡ���' then '��ͨ��2999��Ʊ'
when t1.COMBO_NAME='��ɾͷɾ�ѡ���' then '������3499��Ʊ'
when t1.COMBO_NAME='��ɾͷ���ѡ���' then '������3999��Ʊ'
end,decode(t1.STATUS,0,'δ�һ�',1,'�Ѷһ�',2,'����',3,'ȡ����ƱȨ��'))h1
group by createdate,h1.hour,h1.stype,h1.status
 
select trunc(t1.r_order_date) ��������,
       t1.r_flights_date ��������,
       t2.flights_city_name ����,
       t2.flight_no �����,
       h5.YHQ_MONEY �Żݽ��,
       t1.flights_order_head_id �������,
       case when t1.flag_id in(3,5,40,41) then '�ɹ���Ʊ'
            when t1.flag_id in(7,11,12) then '��Ʊ' end ��Ʊ״̬
  from yhq.cq_yhq_unlimited_combo@to_air t
  join yhq.cq_new_yhq_relation@to_air h3 on t.yhq_batch_id = h3.create_id and t.USER_ID=h3.USERS_ID  --���������������
  join yhq.cq_new_yhq_history@to_air h4 on h4.yhq_id = h3.id
  join yhq.cq_new_yhq_history_detail@to_air h5 on h4.id = h5.history_id
  join cqsale.cq_order_head@to_air t1 on h5.order_head_id =t1.flights_order_head_id
  join dw.da_flight t2 on t1.segment_head_id = t2.segment_head_id 
 where t1.flag_id in (3, 5, 40, 41,7,11,12)
   and t1.r_order_date >= to_date('2020-07-15', 'yyyy-mm-dd')
   and t1.r_flights_date >= to_date('2020-07-15', 'yyyy-mm-dd')
   and t.create_date>=to_date('2020-07-15 18:00:00','yyyy-mm-dd hh24:mi:ss');
 
