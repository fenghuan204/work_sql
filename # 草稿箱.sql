# 草稿箱
with tp as
(select d.*,
       replace(d.flight_no_1,'9C','') || '/' || substr(d.flight_no_2,-2,2) || ' ' || d.fhour_1 || '/' ||
       d.fhour_2 flighthour
  from (select q.wf_segment_name,
               q.flight_no flight_no_1,
               q.flight_date flight_date_1,
               q.segment_code segment_code_1,
               q.diff_hour,
               q.fhour fhour_1,
               h.flight_no flight_no_2,
               h.flight_date flight_date_2,
               h.segment_code segment_code_2,
               h.fhour fhour_2,
               replace(q.route_name,'－','＝') wf,
               row_number() over(partition by q.wf_segment_name, q.flight_no, q.flight_date, q.segment_code, q.fhour order by abs(h.origin_std - q.origin_std)) rid,
               row_number() over(partition by h.wf_segment_name, h.flight_no, h.flight_date, h.segment_code, h.fhour order by abs(h.origin_std - q.origin_std)) rid2
          from (select s.wf_segment_name,
                       to_char(f.origin_std, 'hh24mi') fhour,
                       f.flight_no,                       
                       f.flight_date,
                       f.segment_code,
                       f.origin_std,
                       f.route_name,
                       (f.dest_sta-f.origin_std)*24 diff_hour,
                       to_number(regexp_substr(substr(f.flight_no, 3, 4),
                                               '[0-9]+')) flightnum
                  from dw.da_flight f
                  join dw.dim_segment_type s on f.h_route_id = s.h_route_id
                                            and f.route_id = s.route_id
                 where f.flight_date >= trunc(sysdate) - 1
                   and f.flight_date <= trunc(sysdate) + 3
                   and f.flag <> 2
                   and f.segment_type in ('实航班', '经停AC段')
                   and mod(to_number(regexp_substr(substr(f.flight_no, 6, 1),
                                                   '[0-9]+')),
                           2) = 1
                   and f.company_id = 0) q
          join (select s.wf_segment_name,
                      to_char(f.origin_std, 'hh24mi') fhour,
                      f.flight_no,
                      f.flight_date,
                      f.segment_code,
                      f.origin_std,
                      to_number(regexp_substr(substr(f.flight_no, 3, 4),
                                              '[0-9]+')) flightnum
                 from dw.da_flight f
                 join dw.dim_segment_type s on f.h_route_id = s.h_route_id
                                           and f.route_id = s.route_id
                where f.flight_date >= trunc(sysdate) - 1
                  and f.flight_date <= trunc(sysdate) + 3
                  and f.flag <> 2
                  and f.segment_type in ('实航班', '经停AC段')
                  and mod(to_number(regexp_substr(substr(f.flight_no, 6, 1),
                                                  '[0-9]+')),
                          2) = 0
                  and f.company_id = 0) h on q.wf_segment_name =
                                             h.wf_segment_name
                                         and q.flightnum + 1 = h.flightnum
                                         and h.flight_date - q.flight_date <= 1
                                         and h.flight_date - q.flight_date >= 0) d
 where rid = 1
   and rid2 = 1)

select h.flight_date,
       h.fd,
       h.wf_segment_name,
       nvl(p.wf,h.wf_segment_name) wf,
       nvl(p.flighthour,h.flights_detail) flighthour,
       sum(h.tktnum) tktnum,
       sum(h.layout) layout,
       round(sum(h.toincome)/10000,2) toincome,
       sum(h.bgo_plan) bgo_plan,
       sum(nvl(nvl(nvl(tb1.round_time, tb2.round_time), tb3.round_time),p.diff_hour)) round_time, --飞行小时 
       round(sum(h.toincome) /
       nullif(sum(nvl(nvl(nvl(tb1.round_time, tb2.round_time), tb3.round_time),p.diff_hour)),
              0)/10000,2) 小时收入
  from (select ts.route_name,
               ts.flight_no,
               ts.wf_segment_name,
               ts.flights_id,
               ts.flight_date,
               to_char(ts.flight_date, 'mmdd') fd,
               case
                 when ts.segment_type not like '%经停%' then
                  to_char(ts.origin_std, 'hh24mi') || '/' ||
                  to_char(ts.dest_sta, 'hh24mi')
                 else
                  null
               end flights_detail,
               min(to_char(ts.origin_std, 'hh24mi')) f_hour,
               max(case
                     when ts.segment_type in ('实航班', '经停AC段') then
                      segment_code
                     else
                      null
                   end) segment_code,
               sum(ts.oversale) oversale,
               sum(ts.limit_num) limit_num,
               sum(ts.layout) layout,
               max(case
                     when ts.segment_type = '经停AC段' then
                      1
                     else
                      0
                   end) segment_type,
               sum(ts.bgo_plan) bgo_plan,
               sum(ts.busi_plan) busi_plan,
               sum(ts.toincome) toincome,
               sum(ts.businum) businum,
               sum(ts.bgonum) bgonum,
               sum(ts.tktnum) tktnum,
               sum(ts.ticket_price) ticket_price,
               sum(ts.price) price
          from (select f.segment_head_id,
                       f.flight_date,
                       f.flights_id,
                       f.flights_segment_name,
                       nvl(t3.limitnum, 0) limit_num,
                       f.segment_code,
                       f.segment_type,
                       f.route_name,
                       t1.wf_segment_name,
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
                       nvl(t.toincome, 0) toincome,
                       nvl(t.businum, 0) businum,
                       nvl(t.bgonum, 0) bgonum,
                       nvl(tktnum, 0) tktnum
                  from dw.da_flight f
                  left join (select t.segment_head_id,
                                   sum(f.price) price,
                                   sum(t.ticket_price * t.r_com_rate) ticket_price,
                                   sum(t.ad_fy * t.r_com_rate) ad_fy,
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
                                   count(1) tktnum
                              from cqsale.cq_order_head@to_air t
                              join dw.da_flight f on t.segment_head_id =
                                                     f.segment_head_id
                             where t.seats_name is not null
                               and t.flag_id in (3, 5, 40, 41)
                               and t.whole_flight like '9C%'
                               and t.r_flights_date >= trunc(sysdate)
                               and t.r_flights_date <= trunc(sysdate) + 2 + 1
                             group by t.segment_head_id) t on f.segment_head_id =
                                                              t.segment_head_id
                  left join dw.dim_segment_type t1 on f.route_id =
                                                      t1.route_id
                                                  and f.h_route_id =
                                                      t1.h_route_id
                  left join (SELECT segment_head_id, COUNT(1) limitnum
                              FROM cqsale.CQ_AIRCREW@to_air T
                             WHERE T.STATUS IN (1, 2)
                               and t.flights_date >= trunc(sysdate)
                             group by segment_head_id) t3 on f.segment_head_id =
                                                             t3.segment_head_id
                 where f.flight_date >= trunc(sysdate)
                   and f.flight_date <= trunc(sysdate) + 2
                   and f.flight_date = to_date('${query_date}', 'yyyy-mm-dd')
                   and f.flag = 0
                   and length(f.flight_no) = 6
                   and REGEXP_LIKE(f.FLIGHT_NO, '[0-9]$')
                   and f.company_id = 0
                  ${if(flg_flag == '',"","and f.flag = " + flg_flag + "")} --
                  ${if(segment_country == '',"","and f.segment_country in ('" + segment_country + "')")}
                  ${if(nationflag == '',"","and f.nationflag in ('" + nationflag + "')")}
                  ${if(originairport_name == '',"","and f.originairport_name in ('" + originairport_name + "')")}
                  ${if(destairport_name == '',"","and f.destairport_name in ('" + destairport_name + "')")}
                ) ts
         group by ts.route_name,
                  ts.flight_no,
                  ts.wf_segment_name,
                  ts.flights_id,
                  ts.flight_date,
                  to_char(ts.flight_date, 'mmdd'),
                  case
                    when ts.segment_type not like '%经停%' then
                     to_char(ts.origin_std, 'hh24mi') || '/' ||
                     to_char(ts.dest_sta, 'hh24mi')
                    else
                     null
                  end) h
  LEFT JOIN (select d.*,
                    row_number() over(partition by d.wf_segment_name, d.flight_no, d.flight_date, d.segment_code order by d.flighthour) rid
               from (select q.wf_segment_name,
                            q.flight_no_1 flight_no,
                            q.flight_date_1 flight_date,
                            q.segment_code_1 segment_code,
                            q.fhour_1 fhour,
                            q.flighthour,
                            q.wf,
                            q.diff_hour
                       from tp q
                     union all
                     select h.wf_segment_name,
                            h.flight_no_2,
                            h.flight_date_2,
                            h.segment_code_2,
                            h.fhour_2,
                            h.flighthour,
                            h.wf,
                            h.diff_hour
                       from tp h) d) P ON h.FLIGHT_NO = P.FLIGHT_NO
                                      AND h.wf_segment_name =
                                          P.wf_segment_name
                                      and h.flight_date = p.flight_date
                                      and h.segment_code = p.segment_code
                                      AND P.RID = 1
--直飞航线 航段+航班号+起飞时间
  left join (select t1.wf_segment_name route_name,
                    f.flight_no,
                    f.flight_no || '  ' || to_char(f.origin_std, 'hh24mi') || '/' ||
                    to_char(f.dest_sta, 'hh24mi') flights_detail,
                    avg(ROUND_TIME) round_time,
                    sum(t.tax_fee) tax_fee,
                    sum(t.total_income) tolincome,
                    avg(t.vari_cost) var_cost,
                    avg(t.checkin_s_mile) smile
               from hdb.recent_flights_cost t
               join dw.da_flight f on f.segment_head_id = t.segment_head_id
               join dw.dim_segment_type t1 on f.route_id = t1.route_id
                                          and f.h_route_id = t1.h_route_id
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
                       to_char(f.dest_sta, 'hh24mi')) tb1 on h.wf_segment_name =
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
               join dw.da_flight f on f.segment_head_id = t.segment_head_id
               join dw.dim_segment_type t1 on f.route_id = t1.route_id
                                          and f.h_route_id = t1.h_route_id
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
              group by t1.wf_segment_name, f.flight_no) tb2 on h.wf_segment_name =
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
               join (select t1.flight_date, t1.h_route_id, max(t1.flag) flag
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
              group by t1.wf_segment_name, t.flight_no) tb3 on h.wf_segment_name =
                                                               tb3.route_name
                                                           and h.segment_type =
                                                               tb3.segment_type
                                                           and h.flight_no =
                                                               tb3.flight_no
 where 1=1 ${if(w_f == '',"","and p.wf in ('" + w_f + "')")}
 group by h.flight_date, h.fd,h.wf_segment_name,nvl(p.wf,h.wf_segment_name),nvl(p.flighthour,h.flights_detail)
 order by split_part(wf,'＝',1), 11 desc




select next_day(last_day(to_date(to_char(sysdate,'yyyy')||'-10-01','yyyy-mm-dd')),'星期六')-7,

select 
to_char(sysdate,'yyyy')

from dual 

NLS_LANG
AMERICAN_AMERICA.ZHS16GBK
