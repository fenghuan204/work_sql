select case when t1.order_day>=to_date('2017-06-12','yyyy-mm-dd')
            and t1.order_day< to_date('2017-06-15','yyyy-mm-dd') then '上周'
            when t1.order_day>=to_date('2017-06-19','yyyy-mm-dd')
            and t1.order_day< to_date('2017-06-22','yyyy-mm-dd') then '本周' end ,
   to_char(t1.order_day,'day') 星期,t1.ahead_days,t1.flights_date,
    case when instr(t3.wf_segment,'＝',1,2)>0 then split_part(t3.wf_segment,'＝',1)||'＝'||split_part(t3.wf_segment,'＝',3)
else t3.wf_segment end wf_segment,
t2.flights_segment_name,t2.flight_no,
      count(1) 机票数,
            sum(t1.ticket_price) 金额
 from dw.fact_order_detail t1
 join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
 left join dw.dim_segment_type t3 on t2.h_route_id=t3.h_route_id and t2.route_id=t3.route_id
 where t2.flag<>2
   and t1.order_day>=to_date('2017-06-12','yyyy-mm-dd')
   and t1.order_day< to_date('2017-06-22','yyyy-mm-dd')
   and to_char(t1.order_day-1,'d') in('1','2','3')
   and t1.seats_name not in('B','G1','G2','G','O')
   and t1.company_id=0
   group by case when t1.order_day>=to_date('2017-06-12','yyyy-mm-dd')
            and t1.order_day< to_date('2017-06-15','yyyy-mm-dd') then '上周'
            when t1.order_day>=to_date('2017-06-19','yyyy-mm-dd')
            and t1.order_day< to_date('2017-06-22','yyyy-mm-dd') then '本周' end ,
   to_char(t1.order_day,'day') ,
    case when instr(t3.wf_segment,'＝',1,2)>0 then split_part(t3.wf_segment,'＝',1)||'＝'||split_part(t3.wf_segment,'＝',3)
else t3.wf_segment end ,
t2.flights_segment_name,t1.ahead_days,t2.flight_no,t1.flights_date
