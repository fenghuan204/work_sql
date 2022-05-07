--航线收益报表
select h.*,
       h1.round_time * h.ftnum round_time,
       h2.tax_fee,
       h2.tolincome,
       h3.jtax_fee,
       h3.jtolincome,
       h2.var_cost*h.ftnum var_cost,
       h3.var_cost*h.ftnum jtvar_cost
  from (select route_name,
               flight_no || '  ' || to_char(origin_std, 'hh24mi') || '/' ||
               to_char(dest_sta, 'hh24mi') flights_detail,
               sum(oversale) oversale,
               sum(bgo_plan) bgo_plan,
               sum(busi_plan) busi_plan,
               sum(income) income,
               sum(businum) businum,
               sum(bgonum) bgonum,
               sum(tktnum) tktnum,
               sum(ticket_price) ticket_price,
               sum(price) price,
               count(distinct segment_head_id) ftnum,
			   sum(case when segment_type in('实航段','经停AC段')  then 1 else 0 end ) jtnum
          from (select t.segment_head_id,
                       f.flight_date,
                       f.flights_segment_name,
                       f.segment_code,
					   f.segment_type,
                       t1.wf_segment_name route_name,
                       f.flight_no,
                       f.origin_std,
                       f.dest_sta,
                       f.oversale,
                       f.bgo_plan - f.o_plan bgo_plan,
                       f.oversale - f.bgo_plan + f.o_plan busi_plan,
                       sum(f.price) price,
                       sum(t.ticket_price * t.r_com_rate) ticket_price,
                       sum(t.ad_fy * t.r_com_rate) ad_fy,
                       sum((t.ticket_price + t.ad_fy) * t.r_com_rate) income,
                       sum(case
                             when t.seats_name not in ('B', 'G', 'G1', 'G2') then
                              1
                             else
                              0
                           end) businum,
                       sum(case
                             when t.seats_name in ('B', 'G', 'G1', 'G2') then
                              1
                             else
                              0
                           end) bgonum,
                       count(1) tktnum,				
                  from cqsale.cq_order_head@to_air t
                  join dw.da_flight f on t.segment_head_id =
                                         f.segment_head_id
                  join dw.dim_segment_type t1 on f.route_id = t1.route_id
                                             and f.h_route_id = t1.h_route_id
                 where f.company_id = 0
                   and t.seats_name is not null
                   and f.flag != 2
                   and t.flag_id in (3, 5, 40, 41)
                   and t.r_flights_date >= trunc(sysdate)
                   and t.r_flights_date >=
                       to_date('${sdate}', 'yyyy-mm-dd') - 1
                   and t.r_flights_date <=
                       to_date('${edate}', 'yyyy-mm-dd') + 1
                   and f.flight_date >= to_date('${sdate}', 'yyyy-mm-dd')
                   and f.flight_date <= to_date('${edate}', 'yyyy-mm-dd')
                 ${if(segment_country == '',
                            "",
                            "and f.segment_country in ('" + segment_country + "')") }
                 ${if(nationflag == '',
                            "",
                            "and f.nationflag in ('" + nationflag + "')") }
                 ${if(originairport_name == '',
                            "",
                            "and f.originairport_name in ('" +
                               originairport_name + "')") }
                 ${if(destairport_name == '',
                            "",
                            "and f.destairport_name in ('" + destairport_name + "')") }
                 group by t.segment_head_id,
                          f.flight_date,
                          f.flights_segment_name,
                          f.segment_code,
						   f.segment_type,
                          t1.wf_segment_name,
                          f.flight_no,
                          f.origin_std,
                          f.dest_sta,
                          f.oversale,
                          f.bgo_plan - f.o_plan,
                          f.oversale - f.bgo_plan + f.o_plan)
        
         where 1 = 1 ${if(route_name == '',
                    "",
                    "and route_name in ('" + route_name + "')") }
         group by route_name,
                  flight_no || '  ' || to_char(origin_std, 'hh24mi') || '/' ||
                  to_char(dest_sta, 'hh24mi')) h
  left join (select t1.wf_segment_name route_name,
                    f.flight_no || '  ' || to_char(f.origin_std, 'hh24mi') || '/' ||
                    to_char(f.dest_sta, 'hh24mi') flights_detail,
                    avg(t.round_time) round_time
               from hdb.recent_flights_cost t
               join dw.da_flight f on f.segment_head_id = t.segment_head_id
               join dw.dim_segment_type t1 on f.route_id = t1.route_id
                                          and f.h_route_id = t1.h_route_id
              where f.flag != 2
                and t.flight_no like '9C%'
                and t.total_cost > 0
                and t.bal_flag = 1
                and t.flight_no not like '%+%'
                and t.checkin_mile is not null
                and t.cost_flag = 0
                and t.qr_flag is null
                and t.flight_date >= trunc(sysdate - 30)
                and t.flight_date < trunc(sysdate)
              group by t1.wf_segment_name,
                       f.flight_no || '  ' ||
                       to_char(f.origin_std, 'hh24mi') || '/' ||
                       to_char(f.dest_sta, 'hh24mi')
             
             union all
             select t1.wf_segment_name,
                    f.flight_no || '  ' || to_char(f.origin_std, 'hh24mi') || '/' ||
                    to_char(f.dest_sta, 'hh24mi'),
                    avg(foc.flight_time)
               from dw.da_flight f
               join dw.da_foc_flight foc on f.segment_head_id =
                                            foc.segment_head_id
               join dw.dim_segment_type t1 on f.route_id = t1.route_id
                                          and f.h_route_id = t1.h_route_id
              where f.flag != 2
                and f.company_id = 0
                and f.segment_type in ('经停AB段', '经停BC段')
                and f.flight_date >= trunc(sysdate - 30)
                and f.flight_date < trunc(sysdate)
              group by t1.wf_segment_name,
                       f.flight_no || '  ' ||
                       to_char(f.origin_std, 'hh24mi') || '/' ||
                       to_char(f.dest_sta, 'hh24mi')) h1 on h.route_name =
                                                            h1.route_name
                                                        and h.flights_detail =
                                                            h1.flights_detail
  left join (select t1.wf_segment_name route_name,
                    f.flight_no || '  ' || to_char(f.origin_std, 'hh24mi') || '/' ||
                    to_char(f.dest_sta, 'hh24mi') flights_detail,
                    sum(t.tax_fee) tax_fee,
                    sum(t.total_income) tolincome,
                    avg(t.trans_cost-t.gdcost_money) var_cost
               from hdb.recent_flights_cost t
               join dw.da_flight f on f.segment_head_id = t.segment_head_id
               join dw.dim_segment_type t1 on f.route_id = t1.route_id
                                          and f.h_route_id = t1.h_route_id
              where f.flag != 2
                and t.flight_no like '9C%'
                and t.total_cost > 0
                and t.bal_flag = 1
                and t.flight_no not like '%+%'
                and t.checkin_mile is not null
                and t.cost_flag = 0
                and t.qr_flag is null
                and t.flight_date >= trunc(sysdate - 30)
                and t.flight_date < trunc(sysdate)
              group by t1.wf_segment_name,
                       f.flight_no || '  ' ||
                       to_char(f.origin_std, 'hh24mi') || '/' ||
                       to_char(f.dest_sta, 'hh24mi')) h2 on h.route_name =
                                                            h2.route_name
                                                        and h.flights_detail =
                                                            h2.flights_detail
  left join (select t1.wf_segment_name route_name,
                    sum(t.tax_fee) jtax_fee,
                    sum(t.total_income) jtolincome,
                    avg(t.trans_cost-t.gdcost_money) var_cost
               from hdb.recent_flights_cost t
               join dw.dim_segment_type t1 on t.flights_id = t1.h_route_id
              where t.flight_no like '9C%'
                and t.total_cost > 0
                and t.bal_flag = 1
                and t.flight_no not like '%+%'
                and t.checkin_mile is not null
                and t.cost_flag = 3
                and t.qr_flag = 1
                and t.flight_date >= trunc(sysdate - 30)
                and t.flight_date < trunc(sysdate)
              group by t1.wf_segment_name) h3 on h.route_name =
                                                 h3.route_name
 order by 1, 2, 3