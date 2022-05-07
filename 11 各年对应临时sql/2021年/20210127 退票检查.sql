select /*+leading(t1)*/
'��Ʊ' ����,trunc(t1.money_date) ��������,case when t1.money_terminal<0 then 'B2C'
else 'B2B' end,
       case when t2.flight_date>=to_date('2021-01-28','yyyy-mm-dd')
             and t2.flight_date<=to_date('2021-03-08','yyyy-mm-dd') then '0128~0308'
             else '������������' end,
       case when t1.money_date< to_date('2021-01-27','yyyy-mm-dd') then '0127ǰ���'
            when t1.money_date>= to_date('2021-01-27','yyyy-mm-dd') then '0127�����' end ������������,
       case when t3.r_order_date< to_date('2021-01-27','yyyy-mm-dd')
             and t2.flight_date>=to_date('2021-01-28','yyyy-mm-dd')
             and t2.flight_date<=to_date('2021-02-03','yyyy-mm-dd') and 
             t1.money_date>= to_date('2021-01-27','yyyy-mm-dd') then '���Ϲ���'
            when t3.r_order_date< to_date('2021-01-27','yyyy-mm-dd')
             and t2.flight_date>=to_date('2021-02-04','yyyy-mm-dd')
             and t2.flight_date<=to_date('2021-03-08','yyyy-mm-dd')
             and t1.money_date>= to_date('2021-01-27','yyyy-mm-dd') 
             and t2.origin_std-t1.money_date>=7 then '���Ϲ���' 
             else '�����Ϲ���' end �Ƿ�������˸Ĺ���,
           case when t1.money_fy=0 then '���'
           else '����' end �Ƿ����,
           count(1) ��Ʊ��,
           sum(t1.money_fy) ������,
           sum((t3.ticket_price+t3.ad_fy+t3.port_pay+t3.other_fy+t3.other_fee+t3.insurance_fee)*t3.r_com_rate)  Ʊ��            
 from dw.da_order_drawback_today t1
 join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
 left join stg.s_cq_order_head t3 on t1.flights_order_head_id=t3.flights_order_head_id
 where t1.money_date>=trunc(sysdate)
   and t2.company_id=0
   group by trunc(t1.money_date) ,
       case when t2.flight_date>=to_date('2021-01-28','yyyy-mm-dd')
             and t2.flight_date<=to_date('2021-03-08','yyyy-mm-dd') then '0128~0308'
             else '������������' end,
       case when t1.money_date< to_date('2021-01-27','yyyy-mm-dd') then '0127ǰ���'
            when t1.money_date>= to_date('2021-01-27','yyyy-mm-dd') then '0127�����' end ,
       case when t3.r_order_date< to_date('2021-01-27','yyyy-mm-dd')
             and t2.flight_date>=to_date('2021-01-28','yyyy-mm-dd')
             and t2.flight_date<=to_date('2021-02-03','yyyy-mm-dd') and 
             t1.money_date>= to_date('2021-01-27','yyyy-mm-dd') then '���Ϲ���'
            when t3.r_order_date< to_date('2021-01-27','yyyy-mm-dd')
             and t2.flight_date>=to_date('2021-02-04','yyyy-mm-dd')
             and t2.flight_date<=to_date('2021-03-08','yyyy-mm-dd')
             and t1.money_date>= to_date('2021-01-27','yyyy-mm-dd') 
             and t2.origin_std-t1.money_date>=7 then '���Ϲ���' 
             else '�����Ϲ���' end,
           case when t1.money_fy=0 then '���'
           else '����' end,
           case when t1.money_terminal<0 then 'B2C'
else 'B2B' end
  
 union all
 
 
 select /*+leading(t1)*/
'��ǩ' ����,trunc(t1.modify_date) ��������,case when t1.users_id<=0 then 'B2C'
else 'B2B' end,
       case when t2.flight_date>=to_date('2021-01-28','yyyy-mm-dd')
             and t2.flight_date<=to_date('2021-03-08','yyyy-mm-dd') then '0128~0308'
             else '������������' end,
       case when t1.modify_date< to_date('2021-01-27','yyyy-mm-dd') then '0127ǰ���'
            when t1.modify_date>= to_date('2021-01-27','yyyy-mm-dd') then '0127�����' end ������������,
      case when t4.flights_order_head_id is null then 
       case when t3.r_order_date< to_date('2021-01-27','yyyy-mm-dd')
             and t2.flight_date>=to_date('2021-01-28','yyyy-mm-dd')
             and t2.flight_date<=to_date('2021-02-03','yyyy-mm-dd') and 
             t1.modify_date>= to_date('2021-01-27','yyyy-mm-dd') then '���Ϲ���'
            when t3.r_order_date< to_date('2021-01-27','yyyy-mm-dd')
             and t2.flight_date>=to_date('2021-02-04','yyyy-mm-dd')
             and t2.flight_date<=to_date('2021-03-08','yyyy-mm-dd') and 
             t1.modify_date>= to_date('2021-01-27','yyyy-mm-dd') 
             and t2.origin_std-t1.modify_date>=7 then '���Ϲ���' 
             else '�����Ϲ���' end
           else '�����Ϲ���' end,
           case when t1.money_fy=0 then '���'
           else '����' end,
           count(1),
           sum(t1.money_fy*t1.rate),
           sum((t3.ticket_price+t3.ad_fy+t3.port_pay+t3.other_fy+t3.other_fee+t3.insurance_fee)*t3.r_com_rate)              
 from dw.da_order_change_today t1
 join dw.da_flight t2 on t1.old_segment_id=t2.segment_head_id
 left join stg.s_cq_order_head t3 on t1.flights_order_head_id=t3.flights_order_head_id
 left join(select h1.flights_order_head_id,count(1)
from(
select *
 from dw.da_order_change_today t1
 where t1.old_origin_std>=to_date('2021-01-28','yyyy-mm-dd')
   and t1.old_origin_std< to_date('2021-03-09','yyyy-mm-dd')
 union all
 select *
 from dw.da_order_change t1
  where t1.old_origin_std>=to_date('2021-01-28','yyyy-mm-dd')
   and t1.old_origin_std< to_date('2021-03-09','yyyy-mm-dd')
 )h1
 group by h1.flights_order_head_id
 having count(1)>1) t4 on t1.flights_order_head_id=t4.flights_order_head_id
 where t1.modify_date>=trunc(sysdate)
   and t2.company_id=0
   group by trunc(t1.modify_date) ,
       case when t2.flight_date>=to_date('2021-01-28','yyyy-mm-dd')
             and t2.flight_date<=to_date('2021-03-08','yyyy-mm-dd') then '0128~0308'
             else '������������' end,
       case when t1.modify_date< to_date('2021-01-27','yyyy-mm-dd') then '0127ǰ���'
            when t1.modify_date>= to_date('2021-01-27','yyyy-mm-dd') then '0127�����' end ,
       case when t4.flights_order_head_id is null then 
       case when t3.r_order_date< to_date('2021-01-27','yyyy-mm-dd')
             and t2.flight_date>=to_date('2021-01-28','yyyy-mm-dd')
             and t2.flight_date<=to_date('2021-02-03','yyyy-mm-dd') and 
             t1.modify_date>= to_date('2021-01-27','yyyy-mm-dd') then '���Ϲ���'
            when t3.r_order_date< to_date('2021-01-27','yyyy-mm-dd')
             and t2.flight_date>=to_date('2021-02-04','yyyy-mm-dd')
             and t2.flight_date<=to_date('2021-03-08','yyyy-mm-dd') and 
             t1.modify_date>= to_date('2021-01-27','yyyy-mm-dd') 
             and t2.origin_std-t1.modify_date>=7 then '���Ϲ���' 
             else '�����Ϲ���' end
           else '�����Ϲ���' end,
           case when t1.money_fy=0 then '���'
           else '����' end,case when t1.users_id<=0 then 'B2C'
else 'B2B' end;
