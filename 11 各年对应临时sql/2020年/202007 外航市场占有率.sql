 select h1.segment_code,h1.flights_segment_name,h1.oversale/h1.tnum,case when h2.chplan/h2.snum=0 then 0.2125
 else  nvl(h2.chplan/h2.snum,0.2125) end,h1.flightnum,h3.plf
 from(
 select t1.segment_code,t1.flights_segment_name,sum(T1.OVERSALE) OVERSALE,SUM(sum(T1.OVERSALE))over(partition by 1) tnum,
        count(1) flightnum
  from dw.da_flight t1
  where t1.flight_date>=to_date('2020-07-19','yyyy-mm-dd')
    and t1.flight_date<=to_date('2020-10-24','yyyy-mm-dd')
    and t1.flag<>2
    and t1.nationflag='国内'
    and t1.company_id=0
    group by t1.segment_code,t1.flights_segment_name)h1
 left join (select ori||dst segment_code,sum(case when company='9C' then num else 0 end) chplan,sum(num) snum,
 sum(sum(case when company='9C' then num else 0 end))over(partition by 1) tnum1,
 sum(sum(num))over(partition by 1)  tnum2  
 from anl.fact_variflight_his@to_dds
 where company<>'执行航班总量'
 and sdate>=to_date('2020-05-03','yyyy-mm-dd')
 and sdate<=to_date('2020-06-27','yyyy-mm-dd')
 group by ori||dst)h2 on h1.segment_code=h2.segment_code
 left join(select tt2.segment_code,sum(tt1.boardnum)/suM(tt2.oversale) plf
             from dw.da_main_order tt1
             join dw.da_flight tt2 on tt1.segment_head_id=tt2.segment_head_id
             where tt1.flights_date>=to_date('2020-07-01','yyyy-mm-dd')
                and tt1.flights_date< to_date('2020-07-13','yyyy-mm-dd')
                and tt2.flag<>2
                and tt2.company_id=0
                group by tt2.segment_code)h3 on h1.segment_code=h3.segment_code
 
