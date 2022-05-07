select --to_char(t1.flights_date,'yyyymm'),
       t1.channel,
       count(1) ticketnum,
       sum(count(1))over(partition by 1)
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  where t1.flights_date>=to_date('2020-01-01','yyyy-mm-dd')
    and t1.flights_date< to_date('2020-07-01','yyyy-mm-dd')
    and t2.flag<>2
    and t1.whole_flight like '9C%'
    and t1.seats_name is not null
    and t1.seats_name not in('B','G','G1','G2','O')
    and t1.flag_id=40
    group by t1.channel;
    
    
   select to_char(t1.flights_date,'yyyy'),
       t1.channel,
       count(1) ticketnum
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  where t1.flights_date>=to_date('2021-01-01','yyyy-mm-dd')
    and t1.flights_date< to_date('2021-10-01','yyyy-mm-dd')
    and t2.flag<>2
    --and to_char(t1.flights_date,'mm') in('01','02','03','04','05','06')
    and t1.whole_flight like '9C%'
    --and t1.channel in('????','???¨²')
    --and t1.station_id in(5,10)
    and t1.seats_name is not null
    and t1.seats_name not in('B','G','G1','G2','O')
    and t1.flag_id=40
   group by to_char(t1.flights_date,'yyyy'),
       t1.channel
