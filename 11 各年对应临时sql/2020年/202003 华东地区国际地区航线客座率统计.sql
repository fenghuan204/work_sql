---���Ҫ����ֶ��������ʵ������߿�����
--�����������ʵ����ÿͿ�����ͳ�Ʊ�

select /*+parallel(4) */
tb3.flight_date �������� ,tb3.flight_no �����,
tt1.c_name||'-'||tt2.c_name ����,
tb3.origin_country ʼ����,
tb3.dest_country Ŀ�ĵ�,
tb3.layout ������λ��,
nvl(ticketnum,0) ԤԼ��,
nvl(ticketnum,0)/tb3.layout ������
from  cqsale.cq_flights_segment_head@to_air tb1 
join cqsale.cq_flights_seats_amount_plan@to_air t6  on tb1.segment_Head_id=t6.segment_Head_id
join dw.da_flight tb3  on tb1.segment_head_id=tb3.segment_head_id
left join stg.f_airport tt1 on tb3.originairport=tt1.t_code
left join stg.f_airport tt2 on tb3.destairport=tt2.t_code
left join 
(
select t1.segment_head_id,count(1)  ticketnum
from cqsale.cq_order_head@to_air t1
join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
where t1.r_flights_date>=trunc(sysdate)
and t1.r_flights_date<=trunc(sysdate)+6
and t1.flag_id in(3,5,40,41)
and t2.company_id=0
and t2.flag<>2
and t1.seats_name is not null
and t2.flights_segment_name like '%�ֶ�%'
and t2.nationflag<>'����'
group by t1.segment_head_id)tb4 on tb3.segment_head_id=tb4.segment_head_id
where tb1.flag<>2
and  tb3.flight_date>=trunc(sysdate)
and  tb3.flight_date<=trunc(sysdate)+6
and tb3.company_id=0
and tb3.flights_segment_name like '%�ֶ�%'
and tb3.nationflag<>'����'
order by 1,2
