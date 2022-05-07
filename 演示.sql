SELECT *
  FROM (
  select P.*, rownum  rid
          from (select
       
          
          
                 p1.origin_airport1 始发,
                       p1.dest_airport1 中转1,
                       p1.origin_airport2 中转2,
                       p1.dest_airport2 抵达,
                       p1.cname1 航线城市1,
                       cname2 航线城市2,
                       p1.deviation_ratio 绕航率 ,
                       p1.angle 夹角 ,
                       p1.mct_range MCT分钟,
                       p1.route_hour 路程小时,
                       p1.pace 班期 ,
                       nvl(p2.gnum, 0) MCT销售,
                       nvl(p2.ttnum, 0) 销售组数,
                       p1.ap_same 同异场,
                       p1.is_same_code 直飞经停,
                       p1.seg_flag 航线性质
                  from (select origin_airport1,
                               dest_airport1,
                               origin_airport2,
                               dest_airport2,
                               cname1,
                               cname2,
                               deviation_ratio,
                               angle,
                               mct mct_range,
                               route_hour,
                               listagg(wd, '|') within
                         group(
                         order by wd) pace, ap_same, is_same_code, seg_flag
                          from (select distinct cf.origin_airport1,
                                                cf.dest_airport1,
                                                cf.origin_airport2,
                                                cf.dest_airport2,
                                                c1.flights_city_name cname1,
                                                c2.flights_city_name cname2,
                                                cf.deviation_ratio,
                                                cf.angle,
                                                ceil(cf.hub_interval * 60) mct,
                                                round((cf.dest_sta2 -
                                                      cf.origin_std) * 24,
                                                      2) route_hour,
                                                to_char(cf.origin_std - 1, 'd') wd,
                                                case
                                                  when cf.dest_airport1 =
                                                       cf.origin_airport2 then
                                                   '同场'
                                                  else
                                                   '异场'
                                                end ap_same,
                                                case
                                                  when s.segment_code is not null then
                                                   '直飞经停'
                                                end is_same_code,
                                                cf.seg_flag
                                  from dw.da_connect_flight cf
                                  join stg.s_cq_lc_flights lc on lc.origin_airport1 =
                                                                 cf.origin_airport1
                                                             and lc.dest_airport1 =
                                                                 cf.dest_airport1
                                                             and lc.origin_airport2 =
                                                                 cf.origin_airport2
                                                             and lc.dest_airport2 =
                                                                 cf.dest_airport2
                                                             and lc.hub1_interval <=
                                                                 cf.hub_interval * 60
                                                             and lc.hub1_day_interval >
                                                                 cf.hub_interval * 60
                                  join dw.da_flight c1 on c1.segment_head_id =
                                                          cf.segment_id1
                                  join dw.da_flight c2 on c2.segment_head_id =
                                                          cf.segment_id2
                                  left join (select distinct origincity ||
                                                            destcity segment_code
                                              from dw.da_flight
                                             where company_id = 0
                                               and flight_date >=
                                                   to_date('${sdate}',
                                                           'yyyy-mm-dd')
                                               and flight_date <=
                                                   to_date('${edate}',
                                                           'yyyy-mm-dd')) s on s.segment_code =
                                                                               c1.origincity ||
                                                                               c2.destcity
                                
                                 where lc.is_valid = 1
                                   and lc.company_id1 = 0
                                   and lc.company_id2 = 0
                                   and cf.origin_std >=
                                       to_date('${sdate}', 'yyyy-mm-dd')
                                   and cf.origin_std <
                                       to_date('${edate}', 'yyyy-mm-dd') + 1
                                 ${if(segflag = '',
                                            "",
                                            "and cf.seg_flag in ('" + segflag + "')") }
                                   ${if(isgy = '',
                                              "",if(isgy = 1,                               "and trunc(cf.origin_std) <> trunc(cf.origin_std2)","and trunc(cf.origin_std) = trunc(cf.origin_std2)"))}
                                 ${if(apo = '',
                                            "",
                                            "and cf.origin_airport1 in ('" + apo + "')") }
                                   and (${if(apm = '',
                                             "1 = 1",
                                             "cf.dest_airport1 in ('" + apm + "')") } or
                                        ${if(apm = '',
                                                                                         "1 = 1",
                                                                                         "cf.origin_airport2 in ('" + apm + "')") })
                                 ${if(apd = '',
                                            "",
                                            "and cf.dest_airport2 in ('" + apd + "')") }
                                 ${if(apsame = 'ALL',
                                            "",
                                            if(apsame = 'Same',
                                               "and cf.dest_airport1 = cf.origin_airport2",
                                               "and cf.dest_airport1 <> cf.origin_airport2")) }
                                 ${if(drate = '',
                                            "",
                                            "and (cf.deviation_ratio is null or cf.deviation_ratio <= " + drate +
                                            " / 100)") }
                                 ${if(mctm = '',
                                            "",
                                            "and cf.hub_interval * 60 <= " + mctm + " ") }
                                 ${if(angm = '',
                                            "",
                                            "and (cf.angle is null or cf.angle >= " + angm + " )") }
                                 ${if(rhan = 'ALL',
                                            "",
                                            if(rhan = '1',
                                               "and s.segment_code is not null",
                                               "and s.segment_code is null")) })
                         group by origin_airport1,
                                  dest_airport1,
                                  origin_airport2,
                                  dest_airport2,
                                  cname1,
                                  cname2,
                                  deviation_ratio,
                                  angle,
                                  mct,
                                  route_hour,
                                  ap_same,
                                  is_same_code,
                                  seg_flag) p1
                  left join (select t.flights_segment_1,
                                   t.flights_segment_2,
                                   ceil((t.origin_std_2 - t.dest_sta_1) * 24 * 60) mct_range,
                                   count(1) gnum,
                                   sum(count(1)) over(partition by t.flights_segment_1, t.flights_segment_2) ttnum
                              from dw.bi_connect_segment t
                             where t.flights_date_1 >=
                                   to_date('${sdate}', 'yyyy-mm-dd')
                               and t.flights_date_1 <=
                                   to_date('${edate}', 'yyyy-mm-dd')
                             group by t.flights_segment_1,
                                      t.flights_segment_2,
                                      ceil((t.origin_std_2 - t.dest_sta_1) * 24 * 60)) p2 on p2.flights_segment_1 =
                                                                                             p1.origin_airport1 ||
                                                                                             p1.dest_airport1
                                                                                         and p2.flights_segment_2 =
                                                                                             p1.origin_airport2 ||
                                                                                             p1.dest_airport2
                                                                                         and p2.mct_range =
                                                                                             p1.mct_range
                /* order by ttnum desc, gnum desc, 1 asc, 2 asc, 3 asc, 4 asc*/
                 
                 ) P
                 
 -- where 1=1  ${if(fnc == 2, "", "") }
                 )
-- where ceil(r_id / ${p_num}) = ${page}
 where  1=1  ${if(fnc == 2, "", "and ceil(rid / " + p_num + ") = " + page + " ") }
 order by 销售组数 desc, MCT销售 desc, 1 asc, 2 asc, 3 asc, 4 asc