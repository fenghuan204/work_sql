select /*+parallel(4) */
tb2.*,tb3.totalnum 去年总销量,tb3.swnum 去年散客销量,tb3.oversale 去年计划数,tb3.swplan 去年散客计划数,
tb3.swprice 去年散客票价和
from (select h1.flight_date,
                    h1.flights_segment_name,
                    h1.nationflag,
                    h1.income_type,
                    h1.date_interval,
                    sum(h1.oversale) oversale,
                    sum(swplan) swplan,
                    sum(nvl(totalnum, 0)) totalnum,
                    sum(nvl(swnum, 0)) swnum,
                    sum(nvl(h2.swprice,0)) swprice                   
               from (select t2.segment_head_id,
                            t2.flight_date,
                            t2.flights_segment_name,
                            t2.nationflag,
                            t4.income_type,
                            t3.date_interval,
                            t2.oversale,
                            t2.oversale - t2.bgo_plan swplan
                       from dw.da_flight t2
                       join DW.ADT_SPRING_DATE t3 on t2.flight_date =
                                                     t3.datetime
                       left join dw.dim_segment_type t4 on t2.route_id =
                                                           t4.route_id
                                                       and t2.h_route_id =
                                                           t4.h_route_id
                      where t3.chunyun_year = '2019'
                        and t2.company_Id = 0
                        and t2.flag <> 2) h1
               left join (select t1.segment_head_id,
                                t2.flight_date,
                                t2.flights_segment_name,
                                t3.date_interval,
                                sum(case
                                      when t1.seats_name is not null then
                                       1
                                      else
                                       0
                                    end) totalnum,
                                sum(case
                                      when t1.seats_name is not null and
                                           t1.seats_name not in
                                           ('B', 'G', 'G1', 'G2', 'O') then
                                       1
                                      else
                                       0
                                    end) swnum,
                                  sum(case
                                      when t1.seats_name not in
                                           ('B', 'G', 'G1', 'G2', 'O') then
                                       t1.ticket_price
                                      else
                                       0
                                    end) swprice   
                           from dw.fact_order_detail t1
                           join dw.da_flight t2 on t1.segment_head_id =
                                                   t2.segment_head_id
                           join dw.adt_spring_date t3 on t2.flight_date =
                                                         t3.datetime
                          where t2.flag <> 2
                            and t3.chunyun_year = '2019'
                            and t1.flights_date >=
                                to_date('2019-01-06', 'yyyy-mm-dd')
                            and t1.flights_date <=
                                to_date('2019-02-28', 'yyyy-mm-dd')
                            and t1.company_id = 0
                            and t1.order_day < trunc(sysdate)
                          group by t1.segment_head_id,
                                   t2.flight_date,
                                   t2.flights_segment_name,
                                   t3.date_interval) h2 on h1.segment_head_id =
                                                           h2.segment_head_id
              group by h1.flight_date,
                       h1.flights_segment_name,
                       h1.nationflag,
                       h1.income_type,
                       h1.date_interval) tb2

  left join (select tb1.flights_segment_name,
                    tb1.date_interval,
                    sum(totalnum) totalnum,
                    sum(tb1.swnum) swnum,
                    sum(tb1.oversale) oversale,
                    sum(tb1.swplan) swplan,
                    sum(tb1.swprice) swprice
               from (select t1.segment_head_id,
                            t2.oversale,
                            t2.oversale - t2.bgo_plan swplan,
                            t2.flight_date,
                            t2.flights_segment_name,
                            t3.date_interval,
                            sum(case
                                  when t1.seats_name is not null then
                                   1
                                  else
                                   0
                                end) totalnum,
                            sum(case
                                  when t1.seats_name is not null and
                                       t1.seats_name not in
                                       ('B', 'G', 'G1', 'G2', 'O') then
                                   1
                                  else
                                   0
                                end) swnum,
                               sum(case
                                  when t1.seats_name is not null and
                                       t1.seats_name not in
                                       ('B', 'G', 'G1', 'G2', 'O') then
                                   t1.ticket_price
                                  else
                                   0
                                end) swprice
                       from dw.fact_order_detail t1
                       join dw.da_flight t2 on t1.segment_head_id =
                                               t2.segment_head_id
                       join dw.adt_spring_date t3 on t2.flight_date =
                                                     t3.datetime
                      where t2.flag <> 2
                        and t3.chunyun_year = '2018'
                        and t1.flights_date >=
                            to_date('2018-01-17', 'yyyy-mm-dd')
                        and t1.flights_date <=
                            to_date('2018-03-11', 'yyyy-mm-dd')
                        and t1.company_id = 0
                        and t1.order_day <
                            add_months(trunc(sysdate), -12) + 11
                      group by t1.segment_head_id,
                               t2.oversale,
                               t2.oversale - t2.bgo_plan,
                               t2.flight_date,
                               t2.flights_segment_name,
                               t3.date_interval) tb1
              group by tb1.flights_segment_name,
                       tb1.date_interval
             
             )tb3 on tb2.date_interval=tb3.date_interval and tb2.flights_segment_name=tb3.flights_segment_name;






#春运阶段对照

select /*+parallel(4) */
tb2.*,tb3.totalnum 去年总销量,tb3.swnum 去年散客销量,tb3.oversale 去年计划数,tb3.swplan 去年散客计划数,
tb3.swprice 去年散客票价和
from (select h1.period,
                    h1.flights_segment_name,
                    h1.nationflag,
                    h1.income_type,
                    h1.date_interval,
                    sum(h1.oversale) oversale,
                    sum(swplan) swplan,
                    sum(nvl(totalnum, 0)) totalnum,
                    sum(nvl(swnum, 0)) swnum,
                    sum(nvl(h2.swprice,0)) swprice                   
               from (select t2.segment_head_id,
                            t2.flight_date,
                            t2.flights_segment_name,
                            t2.nationflag,
                            t4.income_type,
                            t3.date_interval,
                            t3.period,
                            t2.oversale,
                            t2.oversale - t2.bgo_plan swplan
                       from dw.da_flight t2
                       join DW.ADT_SPRING_DATE t3 on t2.flight_date =
                                                     t3.datetime
                       left join dw.dim_segment_type t4 on t2.route_id =
                                                           t4.route_id
                                                       and t2.h_route_id =
                                                           t4.h_route_id
                      where t3.chunyun_year = '2019'
                        and t2.company_Id = 0
                        and t2.flag <> 2) h1
               left join (select t1.segment_head_id,
                                t2.flight_date,
                                t2.flights_segment_name,
                                t3.date_interval,
                                sum(case
                                      when t1.seats_name is not null then
                                       1
                                      else
                                       0
                                    end) totalnum,
                                sum(case
                                      when t1.seats_name is not null and
                                           t1.seats_name not in
                                           ('B', 'G', 'G1', 'G2', 'O') then
                                       1
                                      else
                                       0
                                    end) swnum,
                                  sum(case
                                      when t1.seats_name not in
                                           ('B', 'G', 'G1', 'G2', 'O') then
                                       t1.ticket_price
                                      else
                                       0
                                    end) swprice   
                           from dw.fact_order_detail t1
                           join dw.da_flight t2 on t1.segment_head_id =
                                                   t2.segment_head_id
                           join dw.adt_spring_date t3 on t2.flight_date =
                                                         t3.datetime
                          where t2.flag <> 2
                            and t3.chunyun_year = '2019'
                            and t1.flights_date >=
                                to_date('2019-01-06', 'yyyy-mm-dd')
                            and t1.flights_date <=
                                to_date('2019-02-28', 'yyyy-mm-dd')
                            and t1.company_id = 0
                            and t1.order_day < trunc(sysdate)
                          group by t1.segment_head_id,
                                   t2.flight_date,
                                   t2.flights_segment_name,
                                   t3.date_interval) h2 on h1.segment_head_id =
                                                           h2.segment_head_id
              group by  h1.period,
                       h1.flights_segment_name,
                       h1.nationflag,
                       h1.income_type,
                       h1.date_interval) tb2

  left join (select tb1.flights_segment_name,
                    tb1.period,
                    sum(totalnum) totalnum,
                    sum(tb1.swnum) swnum,
                    sum(tb1.oversale) oversale,
                    sum(tb1.swplan) swplan,
                    sum(tb1.swprice) swprice
               from (select t1.segment_head_id,
                            t2.oversale,
                            t2.oversale - t2.bgo_plan swplan,
                            t2.flight_date,
                            t2.flights_segment_name,
                            t3.date_interval,
                            t3.period,
                            sum(case
                                  when t1.seats_name is not null then
                                   1
                                  else
                                   0
                                end) totalnum,
                            sum(case
                                  when t1.seats_name is not null and
                                       t1.seats_name not in
                                       ('B', 'G', 'G1', 'G2', 'O') then
                                   1
                                  else
                                   0
                                end) swnum,
                               sum(case
                                  when t1.seats_name is not null and
                                       t1.seats_name not in
                                       ('B', 'G', 'G1', 'G2', 'O') then
                                   t1.ticket_price
                                  else
                                   0
                                end) swprice
                       from dw.fact_order_detail t1
                       join dw.da_flight t2 on t1.segment_head_id =
                                               t2.segment_head_id
                       join dw.adt_spring_date t3 on t2.flight_date =
                                                     t3.datetime
                      where t2.flag <> 2
                        and t3.chunyun_year = '2018'
                        and t1.flights_date >=
                            to_date('2018-01-17', 'yyyy-mm-dd')
                        and t1.flights_date <=
                            to_date('2018-03-11', 'yyyy-mm-dd')
                        and t1.company_id = 0
                        and t1.order_day <
                            add_months(trunc(sysdate), -12) + 11
                      group by  t1.segment_head_id,
                            t2.oversale,
                            t2.oversale - t2.bgo_plan,
                            t2.flight_date,
                            t2.flights_segment_name,
                            t3.date_interval,
                            t3.period) tb1
              group by tb1.flights_segment_name,
                       tb1.period
             
             )tb3 on tb2.period=tb3.period and tb2.flights_segment_name=tb3.flights_segment_name




select /*+parallel(4) */
tb2.*,tb3.totalnum 去年总销量,tb3.swnum 去年散客销量,tb3.oversale 去年计划数,tb3.swplan 去年散客计划数,
tb3.swprice 去年散客票价和
from (select h1.period,
                    h1.flights_segment_name,
                    h1.nationflag,
                    h1.income_type,
                        sum(h1.oversale) oversale,
                    sum(swplan) swplan,
                    sum(nvl(totalnum, 0)) totalnum,
                    sum(nvl(swnum, 0)) swnum,
                    sum(nvl(h2.swprice,0)) swprice                   
               from (select t2.segment_head_id,
                            t2.flight_date,
                            t2.flights_segment_name,
                            t2.nationflag,
                            t4.income_type,
                            t3.date_interval,
                            t3.period,
                            t2.oversale,
                            t2.oversale - t2.bgo_plan swplan
                       from dw.da_flight t2
                       join DW.ADT_SPRING_DATE t3 on t2.flight_date =
                                                     t3.datetime
                       left join dw.dim_segment_type t4 on t2.route_id =
                                                           t4.route_id
                                                       and t2.h_route_id =
                                                           t4.h_route_id
                      where t3.chunyun_year = '2019'
                        and t2.company_Id = 0
                        and t2.flag <> 2) h1
               left join (select t1.segment_head_id,
                                t2.flight_date,
                                t2.flights_segment_name,
                                 sum(case
                                      when t1.seats_name is not null then
                                       1
                                      else
                                       0
                                    end) totalnum,
                                sum(case
                                      when t1.seats_name is not null and
                                           t1.seats_name not in
                                           ('B', 'G', 'G1', 'G2', 'O') then
                                       1
                                      else
                                       0
                                    end) swnum,
                                  sum(case
                                      when t1.seats_name not in
                                           ('B', 'G', 'G1', 'G2', 'O') then
                                       t1.ticket_price
                                      else
                                       0
                                    end) swprice   
                           from dw.fact_order_detail t1
                           join dw.da_flight t2 on t1.segment_head_id =
                                                   t2.segment_head_id
                           join dw.adt_spring_date t3 on t2.flight_date =
                                                         t3.datetime
                          where t2.flag <> 2
                            and t3.chunyun_year = '2019'
                            and t1.flights_date >=
                                to_date('2019-01-06', 'yyyy-mm-dd')
                            and t1.flights_date <=
                                to_date('2019-02-28', 'yyyy-mm-dd')
                            and t1.company_id = 0
                            and t1.order_day < trunc(sysdate)
                          group by t1.segment_head_id,
                                   t2.flight_date,
                                   t2.flights_segment_name) h2 on h1.segment_head_id =
                                                           h2.segment_head_id
              group by  h1.period,
                       h1.flights_segment_name,
                       h1.nationflag,
                       h1.income_type
      ) tb2

  left join (select tb1.flights_segment_name,
                    tb1.period,
                    sum(totalnum) totalnum,
                    sum(tb1.swnum) swnum,
                    sum(tb1.oversale) oversale,
                    sum(tb1.swplan) swplan,
                    sum(tb1.swprice) swprice
               from (select t1.segment_head_id,
                            t2.oversale,
                            t2.oversale - t2.bgo_plan swplan,
                            t2.flight_date,
                            t2.flights_segment_name,
                            t3.date_interval,
                            t3.period,
                            sum(case
                                  when t1.seats_name is not null then
                                   1
                                  else
                                   0
                                end) totalnum,
                            sum(case
                                  when t1.seats_name is not null and
                                       t1.seats_name not in
                                       ('B', 'G', 'G1', 'G2', 'O') then
                                   1
                                  else
                                   0
                                end) swnum,
                               sum(case
                                  when t1.seats_name is not null and
                                       t1.seats_name not in
                                       ('B', 'G', 'G1', 'G2', 'O') then
                                   t1.ticket_price
                                  else
                                   0
                                end) swprice
                       from dw.fact_order_detail t1
                       join dw.da_flight t2 on t1.segment_head_id =
                                               t2.segment_head_id
                       join dw.adt_spring_date t3 on t2.flight_date =
                                                     t3.datetime
                      where t2.flag <> 2
                        and t3.chunyun_year = '2018'
                        and t1.flights_date >=
                            to_date('2018-01-17', 'yyyy-mm-dd')
                        and t1.flights_date <=
                            to_date('2018-03-11', 'yyyy-mm-dd')
                        and t1.company_id = 0
                        and t1.order_day <
                            add_months(trunc(sysdate), -12) + 11
                      group by  t1.segment_head_id,
                            t2.oversale,
                            t2.oversale - t2.bgo_plan,
                            t2.flight_date,
                            t2.flights_segment_name,
                            t3.date_interval,
                            t3.period) tb1
              group by tb1.flights_segment_name,
                       tb1.period
             
             )tb3 on tb2.period=tb3.period and tb2.flights_segment_name=tb3.flights_segment_name
