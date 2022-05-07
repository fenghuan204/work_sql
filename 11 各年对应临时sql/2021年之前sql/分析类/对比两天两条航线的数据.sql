select 
T1.ORDER_DAY,case when t1.channel='�ֻ�' and t1.station_id=2 then 'M��վ'
    when t1.channel='�ֻ�' and t1.station_id in(5,10) then '΢��'
    else channel end ����,
      t1.sub_channel,   
/*   case when t1.ahead_days<=3 then '00-03'
         when t1.ahead_days<=7 then '04-07'
       when t1.ahead_days<=15 then '08-15'
       when t1.ahead_days<=30 then '15-30'
       when t1.ahead_days<=60 then '31-60'
       when t1.ahead_days<=90 then '61-90'
       when t1.ahead_days> 90 then '90+' end ��ǰ��,*/
       t1.nationflag,
t2.flights_segment_name,
 case when t1.is_swj=1 then '������'
 when t1.EX_CFD6 is not null then '������'
 when t1.sex=3 then 'YE'
            when t1.seats_name in('P2','P3','P4','P5') then '���'
            when t1.seats_name in('P','P1','R1','R2','R3','R4') then 'PR��'
            when t1.seats_name in('E','U','X') then 'EUX��'
            when t1.seats_name in('A','D','Z','I','J','O') then '�����λ'
            else '5�����ϲ�λ' end  ��λ,
      count(1) ��Ʊ��,
      sum(t1.ticket_price) ���,
      sum(t1.insurce_fee+t1.other_fee) ���ս��
 from dw.fact_order_detail t1
 join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
 left join dw.da_restrict_userinfo t4 on t1.client_id=t4.users_id
 left join dw.dim_segment_type t3 on t2.h_route_id=t3.h_route_id and t2.route_id=t3.route_id
 where t2.flag<>2
   and t1.order_day>=trunc(SYSDATE-8)
   and t1.order_day<=trunc(SYSDATE-1)
   AND T1.SEATS_NAME IS NOT NULL
   and t1.company_id=0
   and t1.channel in('OTA','�콢��')
   and t1.seats_name not in('B','G','G1','G2','O')
   and to_char(t1.order_day,'day') in('���ڶ�')
   group by T1.ORDER_DAY,case when t1.channel='�ֻ�' and t1.station_id=2 then 'M��վ'
    when t1.channel='�ֻ�' and t1.station_id in(5,10) then '΢��'
    else channel end ,
      t1.sub_channel,   
/*   case when t1.ahead_days<=3 then '00-03'
         when t1.ahead_days<=7 then '04-07'
       when t1.ahead_days<=15 then '08-15'
       when t1.ahead_days<=30 then '15-30'
       when t1.ahead_days<=60 then '31-60'
       when t1.ahead_days<=90 then '61-90'
       when t1.ahead_days> 90 then '90+' end ,*/
        t1.nationflag,
t2.flights_segment_name,
 case when t1.is_swj=1 then '������'
 when t1.EX_CFD6 is not null then '������'
 when t1.sex=3 then 'YE'
            when t1.seats_name in('P2','P3','P4','P5') then '���'
            when t1.seats_name in('P','P1','R1','R2','R3','R4') then 'PR��'
            when t1.seats_name in('E','U','X') then 'EUX��'
            when t1.seats_name in('A','D','Z','I','J','O') then '�����λ'
            else '5�����ϲ�λ' end
  
  
