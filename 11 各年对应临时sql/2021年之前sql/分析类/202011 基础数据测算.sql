--�������ݲ�������
select t1.flight_date,count(distinct t1.flights_id) ������,sum(t1.oversale) ���ۼƻ���,
sum(t1.oversale+nvl(t2.limit_num,0)) ������λ��,sum(t1.oversale)/count(distinct t1.flights_id) ÿ��ƻ���,
sum(t1.oversale+nvl(t2.limit_num,0))/count(distinct t1.flights_id) ÿ����λ��
 from dw.da_flight t1
 left join( select segment_head_id,count(1) limit_num
   from cqsale.cq_aircrew@to_air
   where STATUS in(1,2)
   and flights_date>=trunc(sysdate)-30-1
   group by segment_head_id)t2 on t1.segment_head_id=t2.segment_head_id
  where t1.flight_date>=trunc(sysdate)-30
   and t1.flight_date< trunc(sysdate)
   and t1.company_id=0
   --and t1.nationflag<>'����'
   and t1.flag<>2
   group by t1.flight_date
   
  
   
   



