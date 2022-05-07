select *
from(
select hp1.ROUTE_NAME,
       hp1.FLIGHT_NO,
       hp1.FLIGHTS_DETAIL,
       hp1.OVERSALE,
       hp1.layout,
       hp1.limit_num,
       hp1.SEGMENT_TYPE,
       hp1.BGO_PLAN,
       hp1.BUSI_PLAN,
       hp1.INCOME,
       hp1.TOINCOME,
       hp1.BUSINUM,
       hp1.BGONUM,
       hp1.TKTNUM,
       hp1.TICKET_PRICE,
       hp1.PRICE,
       hp1.FTNUM,
       hp1.JTNUM,
       hp1.BACKGAIFEE,
       hp1.FZFEE,
       case when hp1.ROUTE_NAME in('虹桥－茅台','茅台－虹桥') then hp1.TKTNUM*200
       else  hp1.SUBSIDY end SUBSIDY,
       nvl(hp1.PREDICT_INCOME, hp1.INCOME) PREDICT_INCOME,
       hp1.ROUND_TIME,
       hp1.SMILE,
       hp1.TAX_FEE,
       hp1.TOLINCOME,
       hp1.JTAX_FEE,
       hp1.JTOLINCOME,
       case
         when hp1.segment_type = 0 then
          nvl(hp1.var_cost, hp1.ROUND_TIME * hp2.vari_cost)
         else
          null
       end var_cost,
       case
         when hp1.segment_type = 1 then
          nvl(hp1.JTVAR_COST, hp1.ROUND_TIME * hp2.vari_cost)
         else
          null
       end JTVAR_COST,
       hp1.stype
  from (select h.*,
               nvl(nvl(nvl(tb1.round_time, tb2.round_time), tb3.round_time),
                   tb4.round_time) * h.ftnum round_time, --飞行小时
               nvl(nvl(nvl(tb1.smile, tb2.smile), tb3.smile), tb4.smile) *
               h.ftnum smile,
               nvl(nvl(tb1.tax_fee, tb2.tax_fee),
                   nvl(sb1.tax_fee, sb2.tax_fee)) tax_fee, --税费
               nvl(nvl(tb1.tolincome, tb2.tolincome),
                   nvl(sb1.tolincome, sb2.tolincome)) tolincome, --总收入
               nvl(tb3.jtax_fee, sb3.jtax_fee) jtax_fee,
               nvl(tb3.jtolincome, sb3.jtolincome) jtolincome,
               nvl(nvl(tb1.var_cost, tb2.var_cost),
                   nvl(sb1.var_cost, sb2.var_cost)) * h.ftnum var_cost,
               nvl(tb3.var_cost, sb3.var_cost) * h.jtnum jtvar_cost,
               tb5.stype
          from (select ts.route_name,
                       ts.flight_no,
                       ts.flight_no || '  ' ||
                       to_char(ts.origin_std, 'hh24mi') || '/' ||
                       to_char(ts.dest_sta, 'hh24mi') flights_detail,
                       sum(ts.oversale) oversale,
                       sum(ts.limit_num) limit_num,
                       sum(ts.layout) layout,
                       case
                         when ts.segment_type in ('经停AC段') then
                          1
                         else
                          0
                       end segment_type,
                       sum(ts.bgo_plan) bgo_plan,
                       sum(ts.busi_plan) busi_plan,
                       sum(ts.income) income,
                       sum(ts.toincome) toincome,
                       sum(ts.businum) businum,
                       sum(ts.bgonum) bgonum,
                       sum(ts.tktnum) tktnum,
                       sum(ts.ticket_price) ticket_price,
                       sum(ts.price) price,
                       count(distinct ts.segment_head_id) ftnum,
                       sum(case
                             when ts.segment_type in ('经停AC段') then
                              1
                             else
                              0
                           end) jtnum,
                       sum(nvl(ts1.backfee, 0) + nvl(ts2.gaifee, 0)) backgaifee,
                       sum(nvl(fzfee, 0) * 0.9604) fzfee,
                       sum(nvl(ts3.subsidy, 0)) subsidy,
                       sum(tp1.CORR_PREDICT_INCOME) predict_income
                  from (select f.segment_head_id,
                               f.flight_date,
                               f.flights_segment_name,
                               nvl(t3.limitnum, 0) limit_num,
                               f.segment_code,
                               f.segment_type,
                               t1.wf_segment_name route_name,
                               f.flight_no,
                               f.origin_std,
                               f.dest_sta,
                               f.oversale,
                               case
                                 when f.oversale = 0 and f.flag = 1 then
                                  0
                                 else
                                  case
                                 when f.segment_type like '%经停%' then
                                  f.oversale + nvl(limitnum, 0)
                                 else
                                  f.layout
                               end end layout,
                               f.bgo_plan - f.o_plan bgo_plan,
                               f.oversale - f.bgo_plan + f.o_plan busi_plan,
                               nvl(t.price, 0) price,
                               nvl(t.ticket_price, 0) ticket_price,
                               nvl(t.ad_fy, 0) ad_fy,
                               nvl(t.income, 0) + nvl(t2.huoincome, 0) * 0.94 income,
                               nvl(t.toincome, 0) + nvl(t2.huoincome, 0) toincome,
                               nvl(t.businum, 0) businum,
                               nvl(t.bgonum, 0) bgonum,
                               nvl(tktnum, 0) tktnum,
                               nvl(fzfee, 0) fzfee
                          from dw.da_flight f
                          left join (select t.segment_head_id,
                                           sum(f.price) price,
                                           sum(t.ticket_price * t.r_com_rate) ticket_price,
                                           sum(t.ad_fy * t.r_com_rate) ad_fy,
                                           sum(case
                                                 when f.nationflag = '国内' then
                                                  (t.ticket_price + t.ad_fy) *
                                                  t.r_com_rate * 0.9174
                                                 when f.nationflag <> '国际' then
                                                  (t.ticket_price + t.ad_fy) *
                                                  t.r_com_rate
                                                 else
                                                  (t.ticket_price + t.ad_fy) *
                                                  t.r_com_rate
                                               end) income,
                                           sum((t.ticket_price + t.ad_fy) *
                                               t.r_com_rate) toincome,
                                           sum(case
                                                 when t.seats_name not in
                                                      ('B', 'G', 'G1', 'G2') then
                                                  1
                                                 else
                                                  0
                                               end) businum,
                                           sum(case
                                                 when t.seats_name in
                                                      ('B', 'G', 'G1', 'G2') then
                                                  1
                                                 else
                                                  0
                                               end) bgonum,
                                           count(1) tktnum,
                                           sum((t.insurance_fee + t.other_fee) *
                                               t.r_rate) fzfee
                                      from cqsale.cq_order_head@to_air t
                                      join dw.da_flight f on t.segment_head_id =
                                                             f.segment_head_id
                                     where t.seats_name is not null
                                       and t.flag_id in (3, 5, 40, 41)
                                       and t.whole_flight like '9C%'
                                       and t.r_flights_date >= trunc(sysdate)
                                       and t.r_flights_date >=
                                           to_date('2021-10-27', 'yyyy-mm-dd') - 1
                                       and t.r_flights_date <=
                                           to_date('2021-12-27', 'yyyy-mm-dd') + 1
                                     group by t.segment_head_id) t on f.segment_head_id =
                                                                      t.segment_head_id
                          left join dw.dim_segment_type t1 on f.route_id =
                                                              t1.route_id
                                                          and f.h_route_id =
                                                              t1.h_route_id
                          left join stg.wb_freight_charter t2 on f.flight_date =
                                                                 t2.flight_date
                                                             and f.flight_no =
                                                                 t2.flight_no
                                                             and f.flights_segment_name =
                                                                 t2.flights_segment_name
                          left join (SELECT segment_head_id, COUNT(1) limitnum
                                      FROM cqsale.CQ_AIRCREW@to_air T
                                     WHERE T.STATUS IN (1, 2)
                                       and t.flights_date >= trunc(sysdate)
                                     group by segment_head_id) t3 on f.segment_head_id =
                                                                     t3.segment_head_id
                         where f.flight_date >=
                               to_date('2021-10-27', 'yyyy-mm-dd')
                           and f.flight_date <=
                               to_date('2021-12-27', 'yyyy-mm-dd')
                           and f.flag <> 2
                          -- ${if(flg_flag == '',"","and f.flag = " + flg_flag + "")} --
                           and f.flight_date >= trunc(sysdate)
                           and f.company_id = 0
                        -- ${if(segment_country == '',"","and f.segment_country in ('" + segment_country + "')")}
                        -- ${if(nationflag == '',"","and f.nationflag in ('" + nationflag + "')")}
                        -- ${if(originairport_name == '',"","and f.originairport_name in ('" + originairport_name + "')")}
                        -- ${if(destairport_name == '', "","and f.destairport_name in ('" + destairport_name + "')")}
                        ) ts
                  left join dw.fr_segment_income_predict3 tp1 on ts.segment_head_id =
                                                                 tp1.segment_head_id
                  left join (select segment_head_id,
                                   sum(backfee) backfee,
                                   sum(backmoney) backmoney
                              from (select t1.segment_head_id,
                                           sum(t1.money_fy * 0.94) backfee,
                                           sum(t1.money_fy) backmoney
                                      from dw.da_order_drawback t1
                                      join dw.da_flight t2 on t1.segment_head_id =
                                                              t2.segment_head_id
                                     where t1.origin_std >= trunc(sysdate)
                                       and t1.origin_std >=
                                           to_date('2021-10-27', 'yyyy-mm-dd')
                                       and t1.origin_std <
                                           to_date('2021-12-27', 'yyyy-mm-dd') + 1
                                     group by t1.segment_head_id
                                    
                                    union all
                                    
                                    select t1.segment_head_id,
                                           sum(t1.money_fy * 0.94) backfee,
                                           sum(t1.money_fy) backmoney
                                      from dw.da_order_drawback_today t1
                                      join dw.da_flight t2 on t1.segment_head_id =
                                                              t2.segment_head_id
                                     where t1.origin_std >= trunc(sysdate)
                                       and t1.origin_std >=
                                           to_date('2021-10-27', 'yyyy-mm-dd')
                                       and t1.origin_std <
                                           to_date('2021-12-27', 'yyyy-mm-dd') + 1
                                     group by t1.segment_head_id)
                             group by segment_head_id) ts1 on ts.segment_head_id =
                                                              ts1.segment_head_id
                  left join (select segment_head_id,
                                   sum(gaifee) gaifee,
                                   sum(gaimoney)
                              from (select t1.old_segment_id segment_head_id,
                                           sum(t1.money_fy * t1.rate * 0.94) gaifee,
                                           sum(t1.money_fy * t1.rate) gaimoney
                                      from dw.da_order_change t1
                                      join dw.da_flight t2 on t1.old_segment_id =
                                                              t2.segment_head_id
                                     where t1.old_origin_std >= trunc(sysdate)
                                       and t1.old_origin_std >=
                                           to_date('2021-10-27', 'yyyy-mm-dd')
                                       and t1.old_origin_std <
                                           to_date('2021-12-27', 'yyyy-mm-dd') + 1
                                     group by t1.old_segment_id
                                    
                                    union all
                                    
                                    select t1.old_segment_id,
                                           sum(t1.money_fy * 0.94) gaifee,
                                           sum(t1.money_fy) gaifee
                                      from dw.da_order_change_today t1
                                      join dw.da_flight t2 on t1.old_segment_id =
                                                              t2.segment_head_id
                                     where t1.old_origin_std >= trunc(sysdate)
                                       and t1.old_origin_std >=
                                           to_date('2021-10-27', 'yyyy-mm-dd')
                                       and t1.old_origin_std <
                                           to_date('2021-12-27', 'yyyy-mm-dd') + 1
                                     group by t1.old_segment_id)
                             group by segment_head_id) ts2 on ts.segment_head_id =
                                                              ts2.segment_head_id
                  left join (select t2.segment_head_id,
                                   to_number(decrypt_des(t1.subsidy,
                                                         'subsidy0718')) / 2 subsidy
                              from stg.wb_flight_subsidy t1
                              join dw.da_flight t2 on t1.flightno1 =
                                                      t2.flight_no
                                                  and t1.segment_name1 =
                                                      t2.route_name
                              join dw.dim_segment_type t3 on t2.route_id =
                                                             t3.route_id
                                                         and t2.h_route_id =
                                                             t3.h_route_id
                             where t2.flight_date >=
                                   to_date('2021-10-27', 'yyyy-mm-dd')
                               and t2.flight_date <=
                                   to_date('2021-12-27', 'yyyy-mm-dd')
                               and t2.flag <> 2
                               and t2.flight_date >= t1.sdate
                               and t2.flight_date <= t1.edate
                               and t2.segment_type in ('实航班', '经停AC段')
                            
                            union
                            
                            select t2.segment_head_id,
                                   to_number(decrypt_des(t1.subsidy,
                                                         'subsidy0718')) / 2 subsidy
                              from stg.wb_flight_subsidy t1
                              join dw.da_flight t2 on t1.flightno2 =
                                                      t2.flight_no
                                                  and t1.segment_name2 =
                                                      t2.route_name
                              join dw.dim_segment_type t3 on t2.route_id =
                                                             t3.route_id
                                                         and t2.h_route_id =
                                                             t3.h_route_id
                             where t2.flight_date >=
                                   to_date('2021-10-27', 'yyyy-mm-dd')
                               and t2.flight_date <=
                                   to_date('2021-12-27', 'yyyy-mm-dd')
                               and t2.flag <> 2
                               and t2.flight_date >= t1.sdate
                               and t2.flight_date <= t1.edate
                               and t2.segment_type in ('实航班', '经停AC段')) ts3 on ts.segment_head_id =
                                                                               ts3.segment_head_id
                
                 where 1 = 1
                -- ${if(route_name == '',"","and route_name in ('" + route_name + "')")}
                 group by route_name,
                          flight_no,
                          flight_no || '  ' || to_char(origin_std, 'hh24mi') || '/' ||
                          to_char(dest_sta, 'hh24mi'),
                          case
                            when segment_type in ('经停AC段') then
                             1
                            else
                             0
                          end) h
        --直飞航线 航段+航班号+起飞时间
          left join (select t1.wf_segment_name route_name,
                           f.flight_no,
                           f.flight_no || '  ' ||
                           to_char(f.origin_std, 'hh24mi') || '/' ||
                           to_char(f.dest_sta, 'hh24mi') flights_detail,
                           avg(ROUND_TIME) round_time,
                           sum(t.tax_fee) tax_fee,
                           sum(t.total_income) tolincome,
                           avg(t.vari_cost) var_cost,
                           avg(t.checkin_s_mile) smile
                      from hdb.recent_flights_cost t
                      join dw.da_flight f on f.segment_head_id =
                                             t.segment_head_id
                      join dw.dim_segment_type t1 on f.route_id =
                                                     t1.route_id
                                                 and f.h_route_id =
                                                     t1.h_route_id
                     where f.flag != 2
                       and t.flight_no like '9C%'
                       and t.total_cost > 0
                       and t.flight_no not like '%+%'
                          --and t.checkin_mile>0
                       and t.checkin_s_mile > 0
                       and t.qr_flag is null
                       and t.ROUND_TIME > 0
                       and t.flight_date >= trunc(sysdate - 7)
                       and t.flight_date < trunc(sysdate)
                     group by t1.wf_segment_name,
                              f.flight_no,
                              f.flight_no || '  ' ||
                              to_char(f.origin_std, 'hh24mi') || '/' ||
                              to_char(f.dest_sta, 'hh24mi')) tb1 on h.route_name =
                                                                    tb1.route_name
                                                                and h.flights_detail =
                                                                    tb1.flights_detail
        --- 直飞航线 航班号+航段轮档小时
          left join (select t1.wf_segment_name route_name,
                           f.flight_no,
                           avg(t.round_time) round_time,
                           sum(t.tax_fee) tax_fee,
                           sum(t.total_income) tolincome,
                           avg(t.vari_cost) var_cost,
                           avg(t.checkin_s_mile) smile
                      from hdb.recent_flights_cost t
                      join dw.da_flight f on f.segment_head_id =
                                             t.segment_head_id
                      join dw.dim_segment_type t1 on f.route_id =
                                                     t1.route_id
                                                 and f.h_route_id =
                                                     t1.h_route_id
                     where f.flag != 2
                       and t.flight_no like '9C%'
                       and t.total_cost > 0
                       and t.flight_no not like '%+%'
                          -- and t.checkin_mile>0
                       and t.checkin_s_mile > 0
                       and t.qr_flag is null
                       and t.round_time > 0
                       and t.flight_date >= trunc(sysdate - 7)
                       and t.flight_date < trunc(sysdate)
                     group by t1.wf_segment_name, f.flight_no) tb2 on h.route_name =
                                                                      tb2.route_name
                                                                  and h.flight_no =
                                                                      tb2.flight_no
        ---经停航线轮档时间
          left join (select t1.wf_segment_name route_name,
                           t.flight_no,
                           1 segment_type,
                           avg(t.round_time) round_time,
                           sum(t.tax_fee) jtax_fee,
                           sum(t.total_income) jtolincome,
                           avg(t.vari_cost) var_cost,
                           avg(t.checkin_s_mile) smile
                      from hdb.recent_flights_cost t
                      join (select distinct h_route_id, wf_segment_name
                             from dw.dim_segment_type) t1 on t.flights_id =
                                                             t1.h_route_id
                      join (select t1.flight_date,
                                  t1.h_route_id,
                                  max(t1.flag) flag
                             from dw.da_flight t1
                            where t1.flight_date >= trunc(sysdate - 7)
                              and t1.flight_date < trunc(sysdate)
                              and t1.segment_type like '%经停%'
                              and t1.company_id = 0
                            group by t1.flight_date, t1.h_route_id) t2 on t.flight_date =
                                                                          t2.flight_date
                                                                      and t.flights_id =
                                                                          t2.h_route_id
                     where t.flight_no like '9C%'
                       and t.total_cost > 0
                       and t.flight_no not like '%+%'
                       and t.checkin_mile > 0
                       and t.checkin_s_mile > 0
                       and t2.flag = 0
                       and t.qr_flag = 1
                       and t.round_time > 0
                       and t.flight_date >= trunc(sysdate - 7)
                       and t.flight_date < trunc(sysdate)
                     group by t1.wf_segment_name, t.flight_no) tb3 on h.route_name =
                                                                      tb3.route_name
                                                                  and h.segment_type =
                                                                      tb3.segment_type
                                                                  and h.flight_no =
                                                                      tb3.flight_no
        
        --直飞航线 航段+航班号+起飞时间2
          left join (select t1.wf_segment_name route_name,
                           f.flight_no,
                           f.flight_no || '  ' ||
                           to_char(f.origin_std, 'hh24mi') || '/' ||
                           to_char(f.dest_sta, 'hh24mi') flights_detail,
                           avg(ROUND_TIME) round_time,
                           sum(t.tax_fee) tax_fee,
                           sum(t.total_income) tolincome,
                           avg(t.vari_cost) var_cost,
                           avg(t.checkin_s_mile) smile
                      from hdb.recent_flights_cost t
                      join dw.da_flight f on f.segment_head_id =
                                             t.segment_head_id
                      join dw.dim_segment_type t1 on f.route_id =
                                                     t1.route_id
                                                 and f.h_route_id =
                                                     t1.h_route_id
                     where f.flag != 2
                       and t.flight_no like '9C%'
                       and t.total_cost > 0
                       and t.flight_no not like '%+%'
                          --and t.checkin_mile>0
                       and t.checkin_s_mile > 0
                       and t.qr_flag is null
                       and t.ROUND_TIME > 0
                       and t.flight_date >= trunc(sysdate - 15)
                       and t.flight_date < trunc(sysdate)
                     group by t1.wf_segment_name,
                              f.flight_no,
                              f.flight_no || '  ' ||
                              to_char(f.origin_std, 'hh24mi') || '/' ||
                              to_char(f.dest_sta, 'hh24mi')) sb1 on h.route_name =
                                                                    sb1.route_name
                                                                and h.flights_detail =
                                                                    sb1.flights_detail
        --- 直飞航线 航班号+航段轮档小时2
          left join (select t1.wf_segment_name route_name,
                           f.flight_no,
                           avg(t.round_time) round_time,
                           sum(t.tax_fee) tax_fee,
                           sum(t.total_income) tolincome,
                           avg(t.vari_cost) var_cost,
                           avg(t.checkin_s_mile) smile
                      from hdb.recent_flights_cost t
                      join dw.da_flight f on f.segment_head_id =
                                             t.segment_head_id
                      join dw.dim_segment_type t1 on f.route_id =
                                                     t1.route_id
                                                 and f.h_route_id =
                                                     t1.h_route_id
                     where f.flag != 2
                       and t.flight_no like '9C%'
                       and t.total_cost > 0
                       and t.flight_no not like '%+%'
                          --and t.checkin_mile>0
                       and t.checkin_s_mile > 0
                       and t.qr_flag is null
                       and t.round_time > 0
                       and t.flight_date >= trunc(sysdate - 15)
                       and t.flight_date < trunc(sysdate)
                     group by t1.wf_segment_name, f.flight_no) sb2 on h.route_name =
                                                                      sb2.route_name
                                                                  and h.flight_no =
                                                                      sb2.flight_no
        ---经停航线轮档时间2
          left join (select t1.wf_segment_name route_name,
                           t.flight_no,
                           1 segment_type,
                           avg(t.round_time) round_time,
                           sum(t.tax_fee) jtax_fee,
                           sum(t.total_income) jtolincome,
                           avg(t.vari_cost) var_cost,
                           avg(t.checkin_s_mile) smile
                      from hdb.recent_flights_cost t
                      join (select distinct h_route_id, wf_segment_name
                             from dw.dim_segment_type) t1 on t.flights_id =
                                                             t1.h_route_id
                      join (select t1.flight_date,
                                  t1.h_route_id,
                                  max(t1.flag) flag
                             from dw.da_flight t1
                            where t1.flight_date >= trunc(sysdate - 15)
                              and t1.flight_date < trunc(sysdate)
                              and t1.segment_type like '%经停%'
                              and t1.company_id = 0
                            group by t1.flight_date, t1.h_route_id) t2 on t.flight_date =
                                                                          t2.flight_date
                                                                      and t.flights_id =
                                                                          t2.h_route_id
                     where t.flight_no like '9C%'
                       and t.total_cost > 0
                       and t.flight_no not like '%+%'
                       and t.checkin_mile > 0
                       and t.checkin_s_mile > 0
                       and t2.flag = 0
                       and t.qr_flag = 1
                       and t.round_time > 0
                       and t.flight_date >= trunc(sysdate - 15)
                       and t.flight_date < trunc(sysdate)
                     group by t1.wf_segment_name, t.flight_no) sb3 on h.route_name =
                                                                      sb3.route_name
                                                                  and h.segment_type =
                                                                      sb3.segment_type
                                                                  and h.flight_no =
                                                                      sb3.flight_no
        
        -- 飞行小时统计
          left join (select route_name,
                           flight_no,
                           segment_Type,
                           sum(round_time) round_time,
                           sum(smile) smile
                      from (select tt1.wf_segment_name route_name,
                                   tt.flight_no,
                                   case
                                     when tt.segment_type like '%经停%' then
                                      1
                                     else
                                      0
                                   end segment_Type,
                                   tt.segment_type segmenttype,
                                   avg(round((tt.dest_sta - tt.origin_std) * 24,
                                             2)) round_time,
                                   avg(tt.layout * tt.mile) smile
                              from dw.da_flight tt
                              join dw.dim_segment_type tt1 on tt.route_id =
                                                              tt1.route_id
                                                          and tt.h_route_id =
                                                              tt1.h_route_id
                             where tt.flight_date >=
                                   to_date('2021-10-27', 'yyyy-mm-dd')
                               and tt.flight_date <=
                                   to_date('2021-12-27', 'yyyy-mm-dd')
                               and tt.flag <> 2
                               and tt.company_id = 0
                               and tt.segment_type in
                                   ('实航班', '经停AB段', '经停BC段')
                               and not exists
                             (select 1
                                      from hdb.recent_flights_cost hh1
                                     where hh1.flight_no like '9C%'
                                       and hh1.total_cost > 0
                                          --and hh1.checkin_mile>0
                                       and hh1.checkin_s_mile > 0
                                       and hh1.flight_no not like '%+%'
                                       and hh1.qr_flag = 1
                                       and hh1.flight_date >=
                                           trunc(sysdate - 7)
                                       and hh1.flight_date < trunc(sysdate)
                                       and hh1.route_name = tt.route_name
                                       and hh1.flight_no = tt.flight_no)
                             group by tt1.wf_segment_name,
                                      tt.flight_no,
                                      case
                                        when tt.segment_type like '%经停%' then
                                         1
                                        else
                                         0
                                      end,tt.segment_type)
                     group by route_name, flight_no, segment_Type
                    
                    ) tb4 on h.route_name = tb4.route_name
                         and h.flight_no = tb4.flight_no
                         and h.segment_type = tb4.segment_Type
        
          left join hdb.wb_yunwang_flighttype tb5 on h.flight_no =
                                                     tb5.flight_no) hp1
  left join hdb.v_newsegment_varicost hp2 on hp1.route_name =
                                             hp2.wf_segment_name
                                         and hp1.SEGMENT_TYPE =
                                             hp2.segment_type

union all

select t2.wf_segment_name route_name,
       t1.flight_no,
       t1.flight_no FLIGHTS_DETAIL,
       sum(t1.plan) OVERSALE,
       sum(t1.plan + nvl(t4.limitnum, 0)) layout,
       sum(t4.limitnum) limitnum,
       case
         when instr(t2.wf_segment_name, '＝', 1, 2) > 0 then
          1
         else
          0
       end SEGMENT_TYPE,
       null BGO_PLAN,
       null BGO_PLAN,
       sum(t1.total_income - t1.tax_fee) income,
       sum(t1.total_income) toincome,
       null BUSINUM,
       null BGONUM,
       sum(t1.checkin_num) TKTNUM,
       sum(t1.BJ_TICKET_INCOME + t1.IT_TICKET_INCOME) TICKET_PRICE,
       null price,
       sum(case
             when instr(t2.wf_segment_name, '＝', 1, 2) > 0 then
              0
             else
              1
           end) FTNUM,
       sum(case
             when instr(t2.wf_segment_name, '＝', 1, 2) > 0 then
              1
             else
              0
           end) JTNUM,
       null BACKGAIFEE,
       null FZFEE,
       sum(t3.SUBSIDY),
       null,
       sum(t1.round_time),
       sum(t1.checkin_s_mile) smile,
       null TAX_FEE,
       null TOLINCOME,
       null JTAX_FEE,
       null JTOLINCOME,
       sum(case
             when instr(t2.wf_segment_name, '＝', 1, 2) > 0 then
              null
             else
              t1. vari_cost
           end) var_cost,
       sum(case
             when instr(t2.wf_segment_name, '＝', 1, 2) > 0 then
              t1. vari_cost
             else
              null
           end) JTVAR_COST,
       null stype
  from hdb.recent_flights_cost t1
  join (select t2.route_name,
               t3.wf_segment_name,
               t2.root_nation_flag nationflag,
               split_part(t2.route_name, '－', 1) originairport_name,
               case
                 when instr(t2.route_name, '－', 1, 2) > 0 then
                  split_part(t2.route_name, '－', 3)
                 else
                  split_part(t2.route_name, '－', 2)
               end destairport_name,
               nvl(max(case
                         when t2.segment_country = '中国' then
                          ''
                         else
                          t2.segment_country
                       end),
                   '中国') segment_country
          from dw.da_flight t2
          join dw.dim_segment_type t3 on t2.h_route_id = t3.h_route_id
                                     and t2.route_id = t3.route_id
         where t2.flight_date >= to_date('2020-01-01', 'yyyy-mm-dd')
           and t2.flight_date < trunc(sysdate)
           and t2.flag <> 2
           and t2.company_id = 0
        -- ${if(route_name == '',"","and t3.wf_segment_name in ('" + route_name + "')")}
         group by t2.route_name,
                  t3.wf_segment_name,
                  t2.root_nation_flag,
                  split_part(t2.route_name, '－', 1),
                  case
                    when instr(t2.route_name, '－', 1, 2) > 0 then
                     split_part(t2.route_name, '－', 3)
                    else
                     split_part(t2.route_name, '－', 2)
                  end) t2 on t1.route_name = t2.route_name
  left join (select flightdate,
                    flightno,
                    route_name,
                    if.decrypt_des(subsidy, 'subsidy0718') subsidy
               from hdb.wb_flight_subsidy_summary) t3 on t1.flight_date =
                                                         t3.flightdate
                                                     and t1.flight_no =
                                                         t3.flightno
                                                     and t1.route_name =
                                                         t3.route_name
  left join (select tt1.flight_date,
                    tt1.flight_no,
                    tt1.route_name,
                    sum(limitnum) limitnum
               from dw.da_flight tt1
               join (SELECT segment_head_id, COUNT(1) limitnum
                      FROM cqsale.CQ_AIRCREW@to_air T
                     WHERE T.STATUS IN (1, 2)
                       and t.flights_date >=
                           to_date('2020-01-01', 'yyyy-mm-dd')
                       and t.flights_date < trunc(sysdate)
                     group by segment_head_id) tt2 on tt1.segment_head_id =
                                                      tt2.segment_head_id
              where tt1.flag <> 2
                and tt1.flight_date >= to_date('2020-01-01', 'yyyy-mm-dd')
                and tt1.flight_date < trunc(sysdate)
              group by tt1.flight_date, tt1.flight_no, tt1.route_name) t4 on t1.flight_date =
                                                                             t4.flight_date
                                                                         and t1.flight_no =
                                                                             t4.flight_no
                                                                         and t1.route_name =
                                                                             t4.route_name
 where t1.flight_date >= to_date('2020-01-01', 'yyyy-mm-dd')
   and t1.flight_date < trunc(sysdate)
   and t1.round_time > 0
   and t1.checkin_s_mile > 0
   and t1.total_cost > 0
   --${if(flg_flag == '',"","and 0 = " + flg_flag + "")} --
   and t1.flight_date >= to_date('2021-10-27', 'yyyy-mm-dd')
   and t1.flight_date <= to_date('2021-12-27', 'yyyy-mm-dd')
 group by t2.wf_segment_name,
          t1.flight_no,
          case
            when instr(t2.wf_segment_name, '＝', 1, 2) > 0 then
             1
            else
             0
          end
 order by 1, 2, 3)tb2
 --where tb2.route_name in('虹桥＝茅台')
