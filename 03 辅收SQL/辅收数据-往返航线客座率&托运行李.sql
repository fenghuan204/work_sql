SELECT CASE
         WHEN t1.qr_flag = 1 THEN
          replace(replace(t4.wf_segment_name, '虹桥', '上海'),
                  '浦东',
                  '上海')
         WHEN t1.qr_flag IS NULL THEN
          replace(replace(t3.wf_segment_name, '虹桥', '上海'),
                  '浦东',
                  '上海')
       END,
       t1.route_name,
       decode(t1.nation_flag, 1, '国内', 2, '区域', 3, '国际') nationflag,
       sum(t1.checkin_mile) / sum(t1.checkin_s_mile) 值机客座率,
       sum(t1.it_num) / sum(t1.totalnum) 散客占比
  FROM hdb.recent_flights_cost t1
  LEFT JOIN dw.da_flight t2 ON t1.qr_flag IS NULL
                           AND t1.segment_head_id = t2.segment_head_id
  LEFT JOIN dw.adt_wf_segment t3 ON t2.h_route_id = t3.route_id
  LEFT JOIN dw.adt_wf_segment t4 ON t1.qr_flag = 1
                                AND t1.flights_id = t4.route_id
 WHERE t1.flight_date >= to_date('2018-03-28', 'yyyy-mm-dd')
   and t1.flight_date < to_date('2019-03-28', 'yyyy-mm-dd')
   AND t1.total_cost > 0
   and t1.flight_time > 0
   and t1.flight_no like '9C%'
 GROUP BY CASE
            WHEN t1.qr_flag = 1 THEN
             replace(replace(t4.wf_segment_name, '虹桥', '上海'),
                     '浦东',
                     '上海')
            WHEN t1.qr_flag IS NULL THEN
             replace(replace(t3.wf_segment_name, '虹桥', '上海'),
                     '浦东',
                     '上海')
          END,
          t1.route_name,
          decode(t1.nation_flag, 1, '国内', 2, '区域', 3, '国际');

select h1.flights_segment_name,
       h1.nationflag,
       case
         when h2.seat_type is not null then
          h2.seat_type
         else
          '普通座'
       end,
       count(1),
       avg(t1.bagw),
       Median(t1.bagw)
  from stg.s_dcs_old_h_bak t1
  left join (select distinct segment_code, flights_segment_name, nationflag
               from dw.da_flight) h1 on t1.fs = h1.segment_code
  left join dw.fact_recent_order_detail h2 on t1.RL = h2.flights_order_id
                                          and t1.ri = h2.valid_code
 where t1.fdate >= to_date('2018-03-16', 'yyyy-mm-dd')
   and t1.fdate < to_date('2019-03-16', 'yyyy-mm-dd')
   and t1.fn like '9C%'
 group by h1.flights_segment_name,
          h1.nationflag,
          case
            when h2.seat_type is not null then
             h2.seat_type
            else
             '普通座'
          end;
