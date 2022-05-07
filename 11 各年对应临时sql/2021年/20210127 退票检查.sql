select /*+leading(t1)*/
'退票' 类型,trunc(t1.money_date) 申请日期,case when t1.money_terminal<0 then 'B2C'
else 'B2B' end,
       case when t2.flight_date>=to_date('2021-01-28','yyyy-mm-dd')
             and t2.flight_date<=to_date('2021-03-08','yyyy-mm-dd') then '0128~0308'
             else '其他航班日期' end,
       case when t1.money_date< to_date('2021-01-27','yyyy-mm-dd') then '0127前提出'
            when t1.money_date>= to_date('2021-01-27','yyyy-mm-dd') then '0127后提出' end 申请日期类型,
       case when t3.r_order_date< to_date('2021-01-27','yyyy-mm-dd')
             and t2.flight_date>=to_date('2021-01-28','yyyy-mm-dd')
             and t2.flight_date<=to_date('2021-02-03','yyyy-mm-dd') and 
             t1.money_date>= to_date('2021-01-27','yyyy-mm-dd') then '符合规则'
            when t3.r_order_date< to_date('2021-01-27','yyyy-mm-dd')
             and t2.flight_date>=to_date('2021-02-04','yyyy-mm-dd')
             and t2.flight_date<=to_date('2021-03-08','yyyy-mm-dd')
             and t1.money_date>= to_date('2021-01-27','yyyy-mm-dd') 
             and t2.origin_std-t1.money_date>=7 then '符合规则' 
             else '不符合规则' end 是否符合免退改规则,
           case when t1.money_fy=0 then '免费'
           else '付费' end 是否免费,
           count(1) 机票量,
           sum(t1.money_fy) 手续费,
           sum((t3.ticket_price+t3.ad_fy+t3.port_pay+t3.other_fy+t3.other_fee+t3.insurance_fee)*t3.r_com_rate)  票款            
 from dw.da_order_drawback_today t1
 join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
 left join stg.s_cq_order_head t3 on t1.flights_order_head_id=t3.flights_order_head_id
 where t1.money_date>=trunc(sysdate)
   and t2.company_id=0
   group by trunc(t1.money_date) ,
       case when t2.flight_date>=to_date('2021-01-28','yyyy-mm-dd')
             and t2.flight_date<=to_date('2021-03-08','yyyy-mm-dd') then '0128~0308'
             else '其他航班日期' end,
       case when t1.money_date< to_date('2021-01-27','yyyy-mm-dd') then '0127前提出'
            when t1.money_date>= to_date('2021-01-27','yyyy-mm-dd') then '0127后提出' end ,
       case when t3.r_order_date< to_date('2021-01-27','yyyy-mm-dd')
             and t2.flight_date>=to_date('2021-01-28','yyyy-mm-dd')
             and t2.flight_date<=to_date('2021-02-03','yyyy-mm-dd') and 
             t1.money_date>= to_date('2021-01-27','yyyy-mm-dd') then '符合规则'
            when t3.r_order_date< to_date('2021-01-27','yyyy-mm-dd')
             and t2.flight_date>=to_date('2021-02-04','yyyy-mm-dd')
             and t2.flight_date<=to_date('2021-03-08','yyyy-mm-dd')
             and t1.money_date>= to_date('2021-01-27','yyyy-mm-dd') 
             and t2.origin_std-t1.money_date>=7 then '符合规则' 
             else '不符合规则' end,
           case when t1.money_fy=0 then '免费'
           else '付费' end,
           case when t1.money_terminal<0 then 'B2C'
else 'B2B' end
  
 union all
 
 
 select /*+leading(t1)*/
'改签' 类型,trunc(t1.modify_date) 申请日期,case when t1.users_id<=0 then 'B2C'
else 'B2B' end,
       case when t2.flight_date>=to_date('2021-01-28','yyyy-mm-dd')
             and t2.flight_date<=to_date('2021-03-08','yyyy-mm-dd') then '0128~0308'
             else '其他航班日期' end,
       case when t1.modify_date< to_date('2021-01-27','yyyy-mm-dd') then '0127前提出'
            when t1.modify_date>= to_date('2021-01-27','yyyy-mm-dd') then '0127后提出' end 申请日期类型,
      case when t4.flights_order_head_id is null then 
       case when t3.r_order_date< to_date('2021-01-27','yyyy-mm-dd')
             and t2.flight_date>=to_date('2021-01-28','yyyy-mm-dd')
             and t2.flight_date<=to_date('2021-02-03','yyyy-mm-dd') and 
             t1.modify_date>= to_date('2021-01-27','yyyy-mm-dd') then '符合规则'
            when t3.r_order_date< to_date('2021-01-27','yyyy-mm-dd')
             and t2.flight_date>=to_date('2021-02-04','yyyy-mm-dd')
             and t2.flight_date<=to_date('2021-03-08','yyyy-mm-dd') and 
             t1.modify_date>= to_date('2021-01-27','yyyy-mm-dd') 
             and t2.origin_std-t1.modify_date>=7 then '符合规则' 
             else '不符合规则' end
           else '不符合规则' end,
           case when t1.money_fy=0 then '免费'
           else '付费' end,
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
             else '其他航班日期' end,
       case when t1.modify_date< to_date('2021-01-27','yyyy-mm-dd') then '0127前提出'
            when t1.modify_date>= to_date('2021-01-27','yyyy-mm-dd') then '0127后提出' end ,
       case when t4.flights_order_head_id is null then 
       case when t3.r_order_date< to_date('2021-01-27','yyyy-mm-dd')
             and t2.flight_date>=to_date('2021-01-28','yyyy-mm-dd')
             and t2.flight_date<=to_date('2021-02-03','yyyy-mm-dd') and 
             t1.modify_date>= to_date('2021-01-27','yyyy-mm-dd') then '符合规则'
            when t3.r_order_date< to_date('2021-01-27','yyyy-mm-dd')
             and t2.flight_date>=to_date('2021-02-04','yyyy-mm-dd')
             and t2.flight_date<=to_date('2021-03-08','yyyy-mm-dd') and 
             t1.modify_date>= to_date('2021-01-27','yyyy-mm-dd') 
             and t2.origin_std-t1.modify_date>=7 then '符合规则' 
             else '不符合规则' end
           else '不符合规则' end,
           case when t1.money_fy=0 then '免费'
           else '付费' end,case when t1.users_id<=0 then 'B2C'
else 'B2B' end;
