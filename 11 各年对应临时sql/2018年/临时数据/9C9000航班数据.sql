select trunc(t1.origin_std) 航班日期,count(1) 退票数
  from dw.da_order_drawback t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  where t1.origin_std>=to_date('2018-11-25','yyyy-mm-dd')
    and t1.origin_std< to_date('2019-01-01','yyyy-mm-dd')
    and t2.flight_no='9C9000'
    and t2.segment_code='KIXPVG'
    group by trunc(t1.origin_std);
    
 
select t2.flight_date 改签前航班日期,t3.flight_date 改签后航班日期,t3.flight_no 航班号,t3.segment_code 航段,
count(distinct t1.flights_order_head_id)  改签机票数
  from dw.da_order_change t1
  join dw.da_flight t2 on t1.old_segment_id=t2.segment_head_id
  join dw.da_flight t3 on t1.new_segment_id=t3.segment_head_id
  where     t2.flight_no='9C9000'
    and t2.segment_code='KIXPVG'
    and t2.flight_date>=to_date('2018-11-25','yyyy-mm-dd')
    and t2.flight_date< to_date('2019-01-01','yyyy-mm-dd')
    group by t2.flight_date,t3.flight_date,t3.flight_no,t3.segment_code
