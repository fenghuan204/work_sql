select p.flight_date º½°àÈÕÆÚ,
       p.flight_no º½°àºÅ,
       p.route_name º½Ïß,
       (case
         when p.flight_date < to_date('2020-11-11', 'yyyy-mm-dd') then
          least(p.limit_num + p.tktnum, 20)
         when p.flight_date < to_date('2020-11-20', 'yyyy-mm-dd') then
          least(p.limit_num + p.tktnum, 30)
         else
          p.limit_num + p.tktnum
       end) - p.tktnum Ê£Óà¿É¶Ò»»Á¿,
       greatest((case
                  when p.flight_date < to_date('2020-11-11', 'yyyy-mm-dd') then
                   least(p.limit_num_v1 + p.tktnum1, 20)
                  when p.flight_date < to_date('2020-11-20', 'yyyy-mm-dd') then
                   least(p.limit_num_v1 + p.tktnum1, 20)
                  else
                   p.limit_num_v1 + p.tktnum1
                end) - p.tktnum1,
                0) "Ì×Æ±1.0Ê£Óà¿É¶Ò»»Á¿",
       greatest((case
                  when p.flight_date < to_date('2020-11-11', 'yyyy-mm-dd') then
                   0
                  when p.flight_date < to_date('2020-11-20', 'yyyy-mm-dd') then
                   least(p.limit_num_v2 + p.tktnum2 + p.tktnum3, 10)
                  else
                   p.limit_num_v2 + p.tktnum2 + p.tktnum3
                end) - (p.tktnum2 + p.tktnum3),
                0) "Ì×Æ±2.0Ê£Óà¿É¶Ò»»Á¿",
       nvl(p.tktnum, 0) ¶Ò»»Á¿,
       nvl(p.tktnum2, 0) "Ì×Æ±2.0¶Ò»»Á¿",
       nvl(p.tktnum1, 0) "Ì×Æ±1.0¶Ò»»Á¿",
       nvl(p.tktnum3, 0) "ÈÃ°®·ÉÏèÌ×Æ±¶Ò»»Á¿",
       case
         when p.flight_date < to_date('2020-11-11', 'yyyy-mm-dd') then
          least(p.limit_num + p.tktnum, 20)
         when p.flight_date < to_date('2020-11-20', 'yyyy-mm-dd') then
          least(p.limit_num + p.tktnum, 30)
         else
          p.limit_num + p.tktnum
       end ×ÜÏŞ¶î,
       p.ticket_num,
       p.oversale,
       nvl(p.predict_ticket_num, p.total_ticket_num) predict_ticket_num,
       p.total_oversale
  from (select h.flight_date,
               h.flight_no,
               h.route_name,
               h.oversale,
               h.total_oversale,
               h.ticket_num,
               h.total_ticket_num,
               h1.limit_num_v1 + h1.limit_num_v2 limit_num,
               h1.limit_num_v1,
               h1.limit_num_v2,
               nvl(h2.tktnum, 0) tktnum,
               nvl(h2.tktnum2, 0) tktnum2,
               nvl(h2.tktnum1, 0) tktnum1,
               nvl(h2.tktnum3, 0) tktnum3,
               h3.predict_ticket_num
          from (select t2.flight_date,
                       t2.flight_no,
                       t2.route_name,
                       t2.flights_id,
                       sum(t2.oversale - t2.bgo_plan) oversale,
                       sum(t2.oversale) total_oversale,
                       sum(nvl(t1.ticket_num, 0)) ticket_num,
                       sum(nvl(t1.total_ticket_num, 0)) total_ticket_num
                  from dw.da_flight t2
                  left join (select segment_head_id,
                                   sum(case
                                         when seats_name not in
                                              ('B', 'G', 'G1', 'G2', 'O') then
                                          1
                                         else
                                          0
                                       end) ticket_num,
                                   count(1) total_ticket_num
                              from cqsale.cq_order_head@to_air
                             where whole_flight like '9C%'
                               and r_flights_date >= trunc(sysdate) - 31
                               and r_flights_date >=
                                   to_date('${sdate}', 'yyyy-mm-dd')
                               and r_flights_date <=
                                   to_date('${edate}', 'yyyy-mm-dd')
                               and flag_id in (3, 5, 40, 41)
                               and seats_name is not null
                             group by segment_head_id) t1 on t1.segment_head_id =
                                                             t2.segment_head_id
                  left join hdb.cq_airport ap3 on ap3.threecodeforcity =
                                                  t2.originairport
                  left join hdb.cq_airport ap4 on ap4.threecodeforcity =
                                                  t2.destairport
                 where t2.flag = 0
                   and t2.company_id = 0
                   and t2.oversale - t2.bgo_plan > 0
                   and t2.flight_date >= trunc(sysdate) - 31
                  and t2.nationflag <> '¹ú¼Ê'
          
                 group by t2.flight_date,
                          t2.flight_no,
                          t2.route_name,
                          t2.flights_id) h
          left join (select *
                      from (select t2.flights_id,
                                   case
                                     when t2.flight_date >=
                                          to_date('2021-01-01', 'yyyy-mm-dd') then
                                      0
                                     else
                                      nvl(nvl(l.limit_num_v1, s.limit), 20)
                                   end limit_num_v1,
                                   case
                                     when t2.flight_date <
                                          to_date('2020-11-11', 'yyyy-mm-dd') then
                                      0
                                     else
                                      nvl(l.limit_num_v2, s2.limit)
                                   end limit_num_v2,
                                   row_number() over(partition by t2.flights_id order by s.flight_no, s.ori_airport, s.dest_airport, s2.flight_no, s2.ori_airport, s2.dest_airport) rid
                              from dw.da_flight t2
                              left join stg.y_cq_new_yhq_flights_limit l on l.segment_head_id =
                                                                            t2.segment_head_id
                              left join yhq.cq_suit_ticket_limit_rule@to_air s on s.batch_nos_id = 1
                                                                              and s.status = 1
                                                                              and t2.flight_date >=
                                                                                  to_date(s.flight_date_s,
                                                                                          'yyyy-mm-dd')
                                                                              and t2.flight_date <=
                                                                                  to_date(s.flight_date_e,
                                                                                          'yyyy-mm-dd')
                                                                              and (case when
                                                                                   s.ori_airport is null then 1 when
                                                                                   s.ori_airport =
                                                                                   t2.originairport then 1 else 0 end) = 1
                                                                              and (case when
                                                                                   s.dest_airport is null then 1 when
                                                                                   s.dest_airport =
                                                                                   t2.destairport then 1 else 0 end) = 1
                                                                              and (case when
                                                                                   s.flight_no is null then 1 when
                                                                                   s.flight_no =
                                                                                   t2.flight_no then 1 else 0 end) = 1
                              left join yhq.cq_suit_ticket_limit_rule@to_air s2 on s2.batch_nos_id = 1000
                                                                               and s2.status = 1
                                                                               and t2.flight_date >=
                                                                                   to_date(s2.flight_date_s,
                                                                                           'yyyy-mm-dd')
                                                                               and t2.flight_date <=
                                                                                   to_date(s2.flight_date_e,
                                                                                           'yyyy-mm-dd')
                                                                               and (case when
                                                                                    s2.ori_airport is null then 1 when
                                                                                    s2.ori_airport =
                                                                                    t2.originairport then 1 else 0 end) = 1
                                                                               and (case when
                                                                                    s2.dest_airport is null then 1 when
                                                                                    s2.dest_airport =
                                                                                    t2.destairport then 1 else 0 end) = 1
                                                                               and (case when
                                                                                    s2.flight_no is null then 1 when
                                                                                    s2.flight_no =
                                                                                    t2.flight_no then 1 else 0 end) = 1
                             where t2.flag = 0
                               and t2.company_id = 0
                               and t2.flight_date >= trunc(sysdate) - 31
                               and t2.flight_date >=
                                   to_date('${sdate}', 'yyyy-mm-dd')
                               and t2.flight_date <=
                                   to_date('${edate}', 'yyyy-mm-dd')
                               and t2.oversale - t2.bgo_plan > 0)
                     where rid = 1) h1 on h.flights_id = h1.flights_id
          left join (select t2.flights_id,
                           count(1) tktnum,
                           sum(case
                                 when combo_vision = 'Ì×Æ±2.1' then
                                  1
                                 else
                                  0
                               end) tktnum3,
                           sum(case
                                 when combo_vision = 'Ì×Æ±2.0' then
                                  1
                                 else
                                  0
                               end) tktnum2,
                           sum(case
                                 when combo_vision = 'Ì×Æ±1.0' then
                                  1
                                 else
                                  0
                               end) tktnum1
                      from dw.fact_combo_ticket c
                      join dw.da_flight t2 on c.segment_head_id =
                                              t2.segment_head_id
                     where c.payflag = 1
                     group by t2.flights_id) h2 on h1.flights_id =
                                                   h2.flights_id
          left join (select t2.flights_id,
                           sum(t1.predict_ticket_num) predict_ticket_num
                      from dw.fr_segment_income_predict3 t1
                      join dw.da_flight t2 on t1.segment_head_id =
                                              t2.segment_head_id
                     where t2.flag = 0
                       and t2.company_id = 0
                       and t2.oversale - t2.bgo_plan > 0
                     group by t2.flights_id) h3 on h1.flights_id =
                                                   h3.flights_id) p
 order by 1, 3
