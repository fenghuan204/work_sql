select trunc(t1.money_date) ��Ʊ����,case when t2.flag=2 then 'ȡ������'
when t3.province like '%����%' or t4.province like '%����%' then '����'
when t3.province like '%����%' or t4.province like '%����%' then '����'
   else '����' end �������� ,
   case when  t3.province like '%����%' or t4.province like '%����%' then '����'
   when t3.province like '%����%' or t4.province like '%����%' then '����'
   else '����' end ���麽��,
   t2.flights_segment_name ����,count(1) Ʊ��
 from dw.da_order_drawback t1
 join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
 left join hdb.cq_airport t3 on t2.originairport=t3.threecodeforcity
 left join hdb.cq_airport t4 on t2.destairport=t4.threecodeforcity
 where t1.money_date>=trunc(sysdate)-8
   --and trunc(t1.money_date) in(trunc(sysdate)-1-7,trunc(sysdate)-1)
   and t2.flight_no like '9C%'
   group by trunc(t1.money_date),case when t2.flag=2 then 'ȡ������'
when t3.province like '%����%' or t4.province like '%����%' then '����'
when t3.province like '%����%' or t4.province like '%����%' then '����'
   else '����' end ,
   case when  t3.province like '%����%' or t4.province like '%����%' then '����'
   when t3.province like '%����%' or t4.province like '%����%' then '����'
   else '����' end ,
   t2.flights_segment_name
