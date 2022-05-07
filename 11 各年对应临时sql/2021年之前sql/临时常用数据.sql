select t.order_date,t1.seats_name
 from cqsale.cq_order@to_air t
 join cqsale.cq_order_head@to_air t1 on t.flights_order_id=t1.flights_order_id
 join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
 where t1.r_flights_date=to_date('2020-11-23','yyyy-mm-dd')
   and t1.whole_flight ='9C6617'
   and t1.flag_id in(3,5,40,41)
   and t1.ticket_price=0
   

   




select t1.r_flights_date ��������,t1.whole_flight �����,count(1) Ʊ��
 from cqsale.cq_order@to_air t
 join cqsale.cq_order_head@to_air t1 on t.flights_order_id=t1.flights_order_id
 where t1.r_flights_date=to_date('2020-11-13','yyyy-mm-dd')
   and t1.whole_flight in('9C8625','9C8626')
   and t1.flag_id in(3,5,40,41)
   group by t1.r_flights_date,t1.whole_flight
   
union all
select t1.r_flights_date,t1.whole_flight,count(1)
 from cqsale.cq_order@to_air t
 join cqsale.cq_order_head@to_air t1 on t.flights_order_id=t1.flights_order_id
 where t1.r_flights_date=to_date('2020-11-16','yyyy-mm-dd')
   and t1.whole_flight in('9C8569','9C8570')
   and t1.flag_id in(3,5,40,41)
   group by t1.r_flights_date,t1.whole_flight
   order by 1,2;
   
   
   
   
   ---����ʹ��(ʵ����������ƽ̨ռ��)

select t1.order_day,
case when t1.channel in('�ֻ�','��վ') and t3.users_id is not null  then '��������ƽ̨����'
     when t1.channel in('�ֻ�','��վ')  then '��������ƽ̨����'
     when t1.channel in('OTA','�콢��') then 'OTA�콢��'
     when t1.channel ='B2B����' then 'B2B����'
     else '��������ƽ̨' end,count(1)   
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id = t2.segment_head_id
  left join dw.da_restrict_userinfo@TO_ODS t3 on t1.client_id = t3.users_id
  left join dw.dim_segment_type t4 on t2.route_Id = t4.route_Id and t2.h_route_id = t4.h_route_id
 where t2.flag <> 2
   and t1.order_day >= TRUNC(SYSDATE-30)
  and t1.seats_name is not NULL
   and t1.seats_name not in('B','G','G1','G2','O')
   and t1.company_id=0
   group by t1.order_day,
case when t1.channel in('�ֻ�','��վ') and t3.users_id is not null  then '��������ƽ̨����'
     when t1.channel in('�ֻ�','��վ')  then '��������ƽ̨����'
     when t1.channel in('OTA','�콢��') then 'OTA�콢��'
     when t1.channel ='B2B����' then 'B2B����'
     else '��������ƽ̨' end;
     
     
     
     select *
 from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id = t2.segment_head_id
  left join dw.da_restrict_userinfo t3 on t1.client_id = t3.users_id
  left join dw.dim_segment_type t4 on t2.route_Id = t4.route_Id and t2.h_route_id = t4.h_route_id
 where t2.flag <> 2
   and t1.flights_date >= to_date('2018-01-01', 'yyyy-mm-dd')
   and t1.flights_date <= to_date('2018-01-01', 'yyyy-mm-dd')
   and t1.company_id = 0;
