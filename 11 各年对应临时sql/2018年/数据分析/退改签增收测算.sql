
--1、退票费用，改签费用

select to_char(t1.origin_std,'yyyymm') smonth,t2.area_type,'退票'  type,
case when t1.seats_name like 'P%' then 'PR舱'
when t1.seats_name like 'R%' then 'PR舱'
when t1.seats_name in('E','U','X','T','Q','N') then 'EUXTQN'
when t1.seats_name in('Y','S','H','V','K','L','M') then 'YSHVKLM'
else '其他' end 舱位类型,count(1) ticketnum,sum(t1.money_fy) moneyfee,sum(t1.ticketprice) 机票金额,0 机票数
  from dw.da_order_drawback t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  where t1.origin_std>=to_date('2016-11-01','yyyy-mm-dd')
    and t1.origin_std< to_date('2018-11-01','yyyy-mm-dd')
    and t2.company_id=0
     and t1.seats_name not in('B','G','G1','G2','O','A','D','Z','I','J')
    and t1.money_fy>0
    group by to_char(t1.origin_std,'yyyymm') ,t2.area_type,
case when t1.seats_name like 'P%' then 'PR舱'
when t1.seats_name like 'R%' then 'PR舱'
when t1.seats_name in('E','U','X','T','Q','N') then 'EUXTQN'
when t1.seats_name in('Y','S','H','V','K','L','M') then 'YSHVKLM'
else '其他' end
    
union all


   select to_char(t1.old_origin_std,'yyyymm'),t2.area_type,'改签' 类型,
   case when t1.old_seat_name like 'P%' then 'PR舱'
when t1.old_seat_name like 'R%' then 'PR舱'
when t1.old_seat_name in('E','U','X','T','Q','N') then 'EUXTQN'
when t1.old_seat_name in('Y','S','H','V','K','L','M') then 'YSHVKLM'
else '其他' end,count(1) 机票,sum(t1.money_fy*t1.rate) 改签费用,sum(t1.old_seat_price),0
  from dw.da_order_change t1
  join dw.da_flight t2 on t1.old_segment_id=t2.segment_head_id
  where t1.old_origin_std>=to_date('2016-11-01','yyyy-mm-dd')
    and t1.old_origin_std< to_date('2018-11-01','yyyy-mm-dd')
    and t2.company_id=0
    and t1.old_seat_name not in('B','G','G1','G2','O','A','D','Z','I','J')
    and t1.money_fy>0
    group by to_char(t1.old_origin_std,'yyyymm'),t2.area_type,
   case when t1.old_seat_name like 'P%' then 'PR舱'
when t1.old_seat_name like 'R%' then 'PR舱'
when t1.old_seat_name in('E','U','X','T','Q','N') then 'EUXTQN'
when t1.old_seat_name in('Y','S','H','V','K','L','M') then 'YSHVKLM'
else '其他' end
    

union all

 select to_char(t1.flights_date,'yyyymm'),t2.area_type,'机票' 类型,case when t1.seats_name like 'P%' then 'PR舱'
when t1.seats_name like 'R%' then 'PR舱'
when t1.seats_name in('E','U','X','T','Q','N') then 'EUXTQN'
when t1.seats_name in('Y','S','H','V','K','L','M') then 'YSHVKLM'
else '其他' end,0,0 ,sum(t1.ticket_price),count(1) 机票
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  where t1.flights_date>=to_date('2016-11-01','yyyy-mm-dd')
    and t1.flights_date< to_date('2018-11-01','yyyy-mm-dd')
    and t2.company_id=0
    and t2.flag<>2
    and t1.seats_name not in('B','G','G1','G2','O','A','D','Z','I','J')
    group by to_char(t1.flights_date,'yyyymm'),t2.area_type,case when t1.seats_name like 'P%' then 'PR舱'
when t1.seats_name like 'R%' then 'PR舱'
when t1.seats_name in('E','U','X','T','Q','N') then 'EUXTQN'
when t1.seats_name in('Y','S','H','V','K','L','M') then 'YSHVKLM'
else '其他' end;



----2、汇总数据


select h1.smonth,h1.area_type,h1.舱位类型,sum(退票量) 退票量,sum(退票收入) 退票收入,sum(退票机票金额) 退票机票金额,sum(改签量) 改签量,sum(改签收入) 改签收入,sum(改签机票金额) 改签机票金额,
sum(机票金额) 机票金额,sum(机票量) 机票量
from(
select to_char(t1.origin_std,'yyyymm') smonth,t2.area_type,
case when t1.seats_name like 'P%' then 'PR舱'
when t1.seats_name like 'R%' then 'PR舱'
when t1.seats_name in('E','U','X','T','Q','N') then 'EUXTQN'
when t1.seats_name in('Y','S','H','V','K','L','M') then 'YSHVKLM'
else '其他' end 舱位类型,count(1) 退票量,sum(t1.money_fy) 退票收入,sum(t1.ticketprice) 退票机票金额,
0 改签量,0 改签收入,0 改签机票金额,0 机票金额,0 机票量
  from dw.da_order_drawback t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  where t1.origin_std>=to_date('2016-11-01','yyyy-mm-dd')
    and t1.origin_std< to_date('2018-11-01','yyyy-mm-dd')
    and t2.company_id=0
     and t1.seats_name not in('B','G','G1','G2','O','A','D','Z','I','J')
    and t1.money_fy>0
    group by to_char(t1.origin_std,'yyyymm') ,t2.area_type,
case when t1.seats_name like 'P%' then 'PR舱'
when t1.seats_name like 'R%' then 'PR舱'
when t1.seats_name in('E','U','X','T','Q','N') then 'EUXTQN'
when t1.seats_name in('Y','S','H','V','K','L','M') then 'YSHVKLM'
else '其他' end
    
union all


   select to_char(t1.old_origin_std,'yyyymm'),t2.area_type,
   case when t1.old_seat_name like 'P%' then 'PR舱'
when t1.old_seat_name like 'R%' then 'PR舱'
when t1.old_seat_name in('E','U','X','T','Q','N') then 'EUXTQN'
when t1.old_seat_name in('Y','S','H','V','K','L','M') then 'YSHVKLM'
else '其他' end,0,0,0,count(1) 机票,sum(t1.money_fy*t1.rate) 改签费用,sum(t1.old_seat_price),0,0
  from dw.da_order_change t1
  join dw.da_flight t2 on t1.old_segment_id=t2.segment_head_id
  where t1.old_origin_std>=to_date('2016-11-01','yyyy-mm-dd')
    and t1.old_origin_std< to_date('2018-11-01','yyyy-mm-dd')
    and t2.company_id=0
    and t1.old_seat_name not in('B','G','G1','G2','O','A','D','Z','I','J')
    and t1.money_fy>0
    group by to_char(t1.old_origin_std,'yyyymm'),t2.area_type,
   case when t1.old_seat_name like 'P%' then 'PR舱'
when t1.old_seat_name like 'R%' then 'PR舱'
when t1.old_seat_name in('E','U','X','T','Q','N') then 'EUXTQN'
when t1.old_seat_name in('Y','S','H','V','K','L','M') then 'YSHVKLM'
else '其他' end
    

union all

 select to_char(t1.flights_date,'yyyymm'),t2.area_type,case when t1.seats_name like 'P%' then 'PR舱'
when t1.seats_name like 'R%' then 'PR舱'
when t1.seats_name in('E','U','X','T','Q','N') then 'EUXTQN'
when t1.seats_name in('Y','S','H','V','K','L','M') then 'YSHVKLM'
else '其他' end,0,0,0,0,0,0,sum(t1.ticket_price),count(1) 机票
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  where t1.flights_date>=to_date('2016-11-01','yyyy-mm-dd')
    and t1.flights_date< to_date('2018-11-01','yyyy-mm-dd')
    and t2.company_id=0
    and t2.flag<>2
    and t1.seats_name not in('B','G','G1','G2','O','A','D','Z','I','J')
    group by to_char(t1.flights_date,'yyyymm'),t2.area_type,case when t1.seats_name like 'P%' then 'PR舱'
when t1.seats_name like 'R%' then 'PR舱'
when t1.seats_name in('E','U','X','T','Q','N') then 'EUXTQN'
when t1.seats_name in('Y','S','H','V','K','L','M') then 'YSHVKLM'
else '其他' end)h1
group by h1.smonth,h1.area_type,h1.舱位类型;



======按照退票日期进行计算


select h1.smonth,h1.area_type,h1.舱位类型,sum(退票量) 退票量,sum(退票收入) 退票收入,sum(退票机票金额) 退票机票金额,sum(改签量) 改签量,sum(改签收入) 改签收入,sum(改签机票金额) 改签机票金额,
sum(机票金额) 机票金额,sum(机票量) 机票量
from(
select to_char(t1.money_date,'yyyymm') smonth,t2.area_type,
case when t1.seats_name like 'P%' then 'PR舱'
when t1.seats_name like 'R%' then 'PR舱'
when t1.seats_name in('E','U','X','T','Q','N') then 'EUXTQN'
when t1.seats_name in('Y','S','H','V','K','L','M') then 'YSHVKLM'
else '其他' end 舱位类型,count(1) 退票量,sum(t1.money_fy) 退票收入,sum(t1.ticketprice) 退票机票金额,
0 改签量,0 改签收入,0 改签机票金额,0 机票金额,0 机票量
  from dw.da_order_drawback t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  where t1.money_date>=to_date('2016-11-01','yyyy-mm-dd')
    and t1.money_date< to_date('2018-12-01','yyyy-mm-dd')
    and t2.company_id=0
     and t1.seats_name not in('B','G','G1','G2','O','A','D','Z','I','J')
    and t1.money_fy>0
    group by to_char(t1.money_date,'yyyymm') ,t2.area_type,
case when t1.seats_name like 'P%' then 'PR舱'
when t1.seats_name like 'R%' then 'PR舱'
when t1.seats_name in('E','U','X','T','Q','N') then 'EUXTQN'
when t1.seats_name in('Y','S','H','V','K','L','M') then 'YSHVKLM'
else '其他' end
    
union all


   select to_char(t1.modify_date,'yyyymm'),t2.area_type,
   case when t1.old_seat_name like 'P%' then 'PR舱'
when t1.old_seat_name like 'R%' then 'PR舱'
when t1.old_seat_name in('E','U','X','T','Q','N') then 'EUXTQN'
when t1.old_seat_name in('Y','S','H','V','K','L','M') then 'YSHVKLM'
else '其他' end,0,0,0,count(1) 机票,sum(t1.money_fy*t1.rate) 改签费用,sum(t1.old_seat_price),0,0
  from dw.da_order_change t1
  join dw.da_flight t2 on t1.old_segment_id=t2.segment_head_id
  where t1.modify_date>=to_date('2016-11-01','yyyy-mm-dd')
    and t1.modify_date< to_date('2018-12-01','yyyy-mm-dd')
    and t2.company_id=0
    and t1.old_seat_name not in('B','G','G1','G2','O','A','D','Z','I','J')
    and t1.money_fy>0
    group by to_char(t1.modify_date,'yyyymm'),t2.area_type,
   case when t1.old_seat_name like 'P%' then 'PR舱'
when t1.old_seat_name like 'R%' then 'PR舱'
when t1.old_seat_name in('E','U','X','T','Q','N') then 'EUXTQN'
when t1.old_seat_name in('Y','S','H','V','K','L','M') then 'YSHVKLM'
else '其他' end  

)h1
group by h1.smonth,h1.area_type,h1.舱位类型;


===========================================每个月退票收入数据===================================


select h1.smonth,h1.area_type,h1.舱位类型,sum(退票量) 退票量,sum(退票收入) 退票收入,sum(退票机票金额) 退票机票金额,sum(改签量) 改签量,sum(改签收入) 改签收入,sum(改签机票金额) 改签机票金额
from(
select to_char(t1.origin_std,'yyyymm') smonth,t2.area_type,
case when t1.seats_name like 'P%' then 'PR舱'
when t1.seats_name like 'R%' then 'PR舱'
when t1.seats_name in('E','U','X','T','Q','N') then 'EUXTQN'
when t1.seats_name in('Y','S','H','V','K','L','M') then 'YSHVKLM'
else '其他' end 舱位类型,count(1) 退票量,sum(t1.money_fy) 退票收入,sum(t1.ticketprice) 退票机票金额,
0 改签量,0 改签收入,0 改签机票金额
  from dw.da_order_drawback t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  where t1.origin_std>=to_date('2018-10-01','yyyy-mm-dd')
    and t1.origin_std< to_date('2018-11-01','yyyy-mm-dd')
    and t2.company_id=0
    and t1.money_fy>0
    group by to_char(t1.origin_std,'yyyymm') ,t2.area_type,
case when t1.seats_name like 'P%' then 'PR舱'
when t1.seats_name like 'R%' then 'PR舱'
when t1.seats_name in('E','U','X','T','Q','N') then 'EUXTQN'
when t1.seats_name in('Y','S','H','V','K','L','M') then 'YSHVKLM'
else '其他' end
    
union all


   select to_char(t1.old_origin_std,'yyyymm'),t2.area_type,
   case when t1.old_seat_name like 'P%' then 'PR舱'
when t1.old_seat_name like 'R%' then 'PR舱'
when t1.old_seat_name in('E','U','X','T','Q','N') then 'EUXTQN'
when t1.old_seat_name in('Y','S','H','V','K','L','M') then 'YSHVKLM'
else '其他' end,0,0,0,count(1) 机票,sum(t1.money_fy*t1.rate) 改签费用,sum(t1.old_seat_price)
  from dw.da_order_change t1
  join dw.da_flight t2 on t1.old_segment_id=t2.segment_head_id
  where t1.old_origin_std>=to_date('2018-10-01','yyyy-mm-dd')
    and t1.old_origin_std< to_date('2018-11-01','yyyy-mm-dd')
    and t2.company_id=0
    and t1.money_fy>0
    group by to_char(t1.old_origin_std,'yyyymm'),t2.area_type,
   case when t1.old_seat_name like 'P%' then 'PR舱'
when t1.old_seat_name like 'R%' then 'PR舱'
when t1.old_seat_name in('E','U','X','T','Q','N') then 'EUXTQN'
when t1.old_seat_name in('Y','S','H','V','K','L','M') then 'YSHVKLM'
else '其他' end
    )h1
group by h1.smonth,h1.area_type,h1.舱位类型;


