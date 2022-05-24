select ts1.whole_flight,ts1.flights_segment_name,ts1.segment_code,
       ts1.route_name,ts1.originairport_name,ts1.destairport_name,
       ts1.wf_segment_name,
       ts1.round_time,
       ts1.fnum,
       ts1.layout,
       ts1.plf,ts1.tktfee,ts1.hour_income,ts1.sumtime,
       ts1.last_hour_income,ts1.last_plf,ts1.last_tkt,ts1.last_income,
       ts1.cw_hourvaricost,
       ts1.mh_hourvaricost,
       midhourincome1+midhourincome2+(case when midhourincome1+midhourincome2=0 then ts1.mh_hourvaricost
       else 0 end) bt_hourincome,       
       (midhourincome1+midhourincome2+(case when midhourincome1+midhourincome2=0 then ts1.mh_hourvaricost
       else 0 end) -ts1.cw_hourvaricost)*ts1.sumtime sj_bjgx,
      (midhourincome1+midhourincome2+(case when midhourincome1+midhourincome2=0 then ts1.mh_hourvaricost
       else 0 end) -ts1.mh_hourvaricost)*ts1.sumtime bt_bjgx,
       ts1.subsidy_seg     
from(
select tp2.whole_flight,tp2.flights_segment_name,tp2.route_name,tp2.wf_segment_name,mid0.nationflag,
       mid0.segment_code,
       split_part(tp2.flights_segment_name,'－',1) originairport_name,
       split_part(tp2.flights_segment_name,'－',2) destairport_name,
       tp2.round_time,
       tp2.fnum,
       tp2.layout/tp2.fnum layout,
       tp2.tkt/tp2.layout plf,
       tp2.tktfee tktfee,
       tp2.tktfee/tp2.sumtime hour_income,
       tp2.sumtime,
       case when hp1.hour_income > 0 then hp1.hour_income
       when hp2.hour_income > 0 then hp2.hour_income
       when hs2.hour_income > 0 then hs2.hour_income*(hp3.hour_income/hs3.hour_income)
       when ht2.hour_income>0 then ht2.hour_income*(hp3.hour_income/ht3.hour_income)
       else null end last_hour_income,

       case when hp1.plf > 0 then hp1.plf
       when hp2.plf > 0 then hp2.plf
       when hs2.plf > 0 then hs2.plf*(hp3.plf/hs3.plf)
       when ht2.plf>0 then ht2.plf*(hp3.plf/ht3.plf)
       else null end last_plf,

       (case when hp1.plf > 0 then hp1.plf
       when hp2.plf > 0 then hp2.plf
       when hs2.plf > 0 then hs2.plf*(hp3.plf/hs3.plf)
       when ht2.plf>0 then ht2.plf*(hp3.plf/ht3.plf)
       else null end)*tp2.layout last_tkt,

       (case when hp1.hour_income > 0 then hp1.hour_income
       when hp2.hour_income > 0 then hp2.hour_income
       when hs2.hour_income > 0 then hs2.hour_income*(hp3.hour_income/hs3.hour_income)
       when ht2.hour_income>0 then ht2.hour_income*(hp3.hour_income/ht3.hour_income)
       else null end)*tp2.sumtime last_income,
       
       tp4.cw_hourvaricost,
       tp4.mh_hourvaricost,
       --中间值1
       case when (case when hp1.hour_income > 0 then hp1.hour_income
       when hp2.hour_income > 0 then hp2.hour_income
       when hs2.hour_income > 0 then hs2.hour_income*(hp3.hour_income/hs3.hour_income)
       when ht2.hour_income>0 then ht2.hour_income*(hp3.hour_income/ht3.hour_income)
       else null end) is not null and 
       (case when hp1.hour_income > 0 then hp1.hour_income
       when hp2.hour_income > 0 then hp2.hour_income
       when hs2.hour_income > 0 then hs2.hour_income*(hp3.hour_income/hs3.hour_income)
       when ht2.hour_income>0 then ht2.hour_income*(hp3.hour_income/ht3.hour_income)
       else null end)+24000< tp4.mh_hourvaricost then (case when hp1.hour_income > 0 then hp1.hour_income
       when hp2.hour_income > 0 then hp2.hour_income
       when hs2.hour_income > 0 then hs2.hour_income*(hp3.hour_income/hs3.hour_income)
       when ht2.hour_income>0 then ht2.hour_income*(hp3.hour_income/ht3.hour_income)
       else null end)+24000
       else 0 end midhourincome1,
     
        case when (case when hp1.hour_income > 0 then hp1.hour_income
       when hp2.hour_income > 0 then hp2.hour_income
       when hs2.hour_income > 0 then hs2.hour_income*(hp3.hour_income/hs3.hour_income)
       when ht2.hour_income>0 then ht2.hour_income*(hp3.hour_income/ht3.hour_income)
       else null end) is not null and 
       (case when hp1.hour_income > 0 then hp1.hour_income
       when hp2.hour_income > 0 then hp2.hour_income
       when hs2.hour_income > 0 then hs2.hour_income*(hp3.hour_income/hs3.hour_income)
       when ht2.hour_income>0 then ht2.hour_income*(hp3.hour_income/ht3.hour_income)
       else null end)>= tp4.mh_hourvaricost then (case when hp1.hour_income > 0 then hp1.hour_income
       when hp2.hour_income > 0 then hp2.hour_income
       when hs2.hour_income > 0 then hs2.hour_income*(hp3.hour_income/hs3.hour_income)
       when ht2.hour_income>0 then ht2.hour_income*(hp3.hour_income/ht3.hour_income)
       else null end)
       else 0 end midhourincome2,
       tp2.subsidy_seg       

from(
select tp2.whole_flight,tp2.flightno,tp2.flights_segment_name,
tp2.route_name,tp2.wf_segment_name,tp2.round_time/60 round_time,
sum(tp2.round_time/60) sumtime,
sum(tp2.layout) layout,sum(nvl(tp3.tkt,0)) tkt,sum(nvl(tp3.tktfee,0)) tktfee,
sum(nvl(tp3.hstktfee,0)) hstktfee,sum(tp2.fnum) fnum,sum(sidy1.subsidy_seg) subsidy_seg
from (
select tp1.flight_date,tp1.whole_flight,tp1.flightno,tp1.flights_segment_name,
tp1.route_name,tp1.wf_segment_name,tp1.round_time,tp1.alltime,count(distinct tp1.flights_id) fnum,
max(layout) layout
from(
select t2.flight_date,t2.flight_no whole_flight,
case when t2.segment_type like '%经停AB%' then t2.flight_no||'X'
when t2.segment_type like '%经停BC%' then t2.flight_no||'Y'
when t2.segment_type like '%经停AC%' then t2.flight_no||'X'
else t2.flight_no end flightno,
case when t2.segment_type like '%经停AC%' 
then split_part(t2.route_name,'－',1)||'－'||split_part(t2.route_name,'－',2)
else t2.flights_segment_name end flights_segment_name,
t2.route_name,
t3.round_time,
t4.round_time alltime,
t2.flights_id,
t2.layout,
t5.wf_segment_name
  from dw.da_flight t2 
  left join if.v_rep_segment_roundtime t3 on (case when t2.segment_type like '%经停AC%' then 
  split_part(t2.route_name,'－',1)||'－'||split_part(t2.route_name,'－',2) 
  else t2.flights_segment_name end) =t3.flights_segment_name
  left join if.v_rep_segment_roundtime t4 on t2.route_name=t4.flights_segment_name
 left join dw.dim_segment_type t5 on t2.h_route_id = t5.h_route_id and t2.route_id = t5.route_id
  where t2.flight_date>=to_date('${sdate}', 'yyyy-mm-dd')
    and t2.flight_date<=to_date('${edate}', 'yyyy-mm-dd')
    and t2.flight_no like '9C%'
    and t2.flag<>2

union  all

select t2.flight_date,
t2.flight_no whole_flight,t2.flight_no||'Y' flightno,
split_part(t2.route_name,'－',2)||'－'||split_part(t2.route_name,'－',3) flights_segment_name,
t2.route_name,
t3.round_time,
t4.round_time alltime,
t2.flights_id,
t2.layout,
t5.wf_segment_name
  from  dw.da_flight t2 
  left join if.v_rep_segment_roundtime t3 on split_part(t2.route_name,'－',2)||'－'||split_part(t2.route_name,'－',3) =t3.flights_segment_name
  left join if.v_rep_segment_roundtime t4 on t2.route_name=t4.flights_segment_name
  left join dw.dim_segment_type t5 on t2.h_route_id = t5.h_route_id and t2.route_id = t5.route_id
  where t2.flight_date>=to_date('${sdate}', 'yyyy-mm-dd')
    and t2.flight_date<=to_date('${edate}', 'yyyy-mm-dd')
    and t2.flight_no like '9C%'
    and t2.flag<>2
    and t2.segment_type like '%经停AC段%'  
    )tp1
  group by tp1.flight_date,tp1.whole_flight,tp1.flightno,tp1.flights_segment_name,
tp1.route_name,tp1.round_time,tp1.alltime,tp1.wf_segment_name
) tp2
left join 
(select tb1.flight_date,tb1.whole_flight,tb1.flightno,tb1.flights_segment_name,
       tb1.route_name,sum(tb1.tkt) tkt,sum(tb1.tktfee) tktfee,sum(tb1.hstktfee) hstktfee
from(
select t1.r_flights_date flight_date,t1.whole_flight,
case when t2.segment_type like '%经停AB%' then t1.whole_flight||'X'
when t2.segment_type like '%经停BC%' then t1.whole_flight||'Y'
when t2.segment_type like '%经停AC%' then t1.whole_flight||'X'
else t1.whole_flight end flightno,
case when t2.segment_type like '%经停AC%' 
then split_part(t2.route_name,'－',1)||'－'||split_part(t2.route_name,'－',2)
else t2.flights_segment_name end flights_segment_name,
t2.route_name,
t3.round_time,
t4.round_time alltime,
sum(case when t2.origin_std< sysdate-1/24 and t1.flag_Id=40 and t1.seats_name is not null 
then 1 
when t2.origin_std>= sysdate-1/24 and t1.flag_id in(3,5,40,41) and t1.seats_name is not null then 1
else 0 end     
) tkt,
case when t2.segment_type like '%经停AC段%' THEN 
sum(case when t2.origin_std< sysdate-1/24 and t1.flag_Id=40 
and t2.nationflag='国内' then (t1.ticket_price+t1.ad_fy)*t1.r_rate*(1/1.09) 
when t2.origin_std< sysdate-1/24 and t1.flag_Id=40 
and t2.nationflag<>'国内' then (t1.ticket_price+t1.ad_fy)*t1.r_rate 
when t2.origin_std>= sysdate-1/24 and t1.flag_id in(3,5,40,41)  and t2.nationflag='国内'
then (t1.ticket_price+t1.ad_fy)*t1.r_rate*(1/1.09) 
when t2.origin_std>= sysdate-1/24 and t1.flag_id in(3,5,40,41)  and t2.nationflag<>'国内'
then (t1.ticket_price+t1.ad_fy)*t1.r_rate
else 0 end     
) *(t3.round_time/t4.round_time)
else sum(case when t2.origin_std< sysdate-1/24 and t1.flag_Id=40  
and t2.nationflag='国内' then (t1.ticket_price+t1.ad_fy)*t1.r_rate*(1/1.09) 
when t2.origin_std< sysdate-1/24 and t1.flag_Id=40 
and t2.nationflag<>'国内' then (t1.ticket_price+t1.ad_fy)*t1.r_rate 
when t2.origin_std>= sysdate-1/24 and t1.flag_id in(3,5,40,41)  and t2.nationflag='国内'
then (t1.ticket_price+t1.ad_fy)*t1.r_rate*(1/1.09) 
when t2.origin_std>= sysdate-1/24 and t1.flag_id in(3,5,40,41)  and t2.nationflag<>'国内'
then (t1.ticket_price+t1.ad_fy)*t1.r_rate
else 0 end     
)  end tktfee,
case when t2.segment_type like '%经停AC段%' then 
sum(case when t2.origin_std< sysdate-1/24 and t1.flag_Id=40  
 then (t1.ticket_price+t1.ad_fy)
when t2.origin_std>= sysdate-1/24 and t1.flag_id in(3,5,40,41) 
then (t1.ticket_price+t1.ad_fy)*t1.r_rate
else 0 end     
)*(t3.round_time/t4.round_time)
else sum(case when t2.origin_std< sysdate-1/24 and t1.flag_Id=40  
 then (t1.ticket_price+t1.ad_fy)
when t2.origin_std>= sysdate-1/24 and t1.flag_id in(3,5,40,41)
then (t1.ticket_price+t1.ad_fy)*t1.r_rate
else 0 end     
) end hstktfee
  from cqsale.cq_order_head@to_air t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  left join if.v_rep_segment_roundtime t3 on (case when t2.segment_type like '%经停AC%' then 
  split_part(t2.route_name,'－',1)||'－'||split_part(t2.route_name,'－',2) 
  else t2.flights_segment_name end) =t3.flights_segment_name
  left join if.v_rep_segment_roundtime t4 on t2.route_name=t4.flights_segment_name
  where t1.r_flights_date>=to_date('${sdate}', 'yyyy-mm-dd')
    and t1.r_flights_date<=to_date('${edate}', 'yyyy-mm-dd')
    and t1.whole_flight like '9C%'
    and t1.r_flights_date>=trunc(sysdate)
    and t2.flag<>2
  group by t1.r_flights_date,t1.whole_flight,
case when t2.segment_type like '%经停AB%' then t1.whole_flight||'X'
when t2.segment_type like '%经停BC%' then t1.whole_flight||'Y'
when t2.segment_type like '%经停AC%' then t1.whole_flight||'X'
else t1.whole_flight end ,
case when t2.segment_type like '%经停AC%' 
then split_part(t2.route_name,'－',1)||'－'||split_part(t2.route_name,'－',2)
else t2.flights_segment_name end,t2.route_name,t3.round_time,
t4.round_time,
t2.segment_type

union all 

select t1.r_flights_date,
t1.whole_flight,t1.whole_flight||'Y' flightno,
split_part(t2.route_name,'－',2)||'－'||split_part(t2.route_name,'－',3) flights_segment_name,
t2.route_name,
t3.round_time,
t4.round_time alltime,
sum(case when t2.origin_std< sysdate-1/24 and t1.flag_Id=40 and t1.seats_name is not null 
then 1 
when t2.origin_std>= sysdate-1/24 and t1.flag_id in(3,5,40,41) and t1.seats_name is not null then 1
else 0 end     
) tkt,
sum(case when t2.origin_std< sysdate-1/24 and t1.flag_Id=40 
and t2.nationflag='国内' then (t1.ticket_price+t1.ad_fy)*t1.r_rate*(1/1.09) 
when t2.origin_std< sysdate-1/24 and t1.flag_Id=40 
and t2.nationflag<>'国内' then (t1.ticket_price+t1.ad_fy)*t1.r_rate 
when t2.origin_std>= sysdate-1/24 and t1.flag_id in(3,5,40,41) and t2.nationflag='国内'
then (t1.ticket_price+t1.ad_fy)*t1.r_rate*(1/1.09) 
when t2.origin_std>= sysdate-1/24 and t1.flag_id in(3,5,40,41)  and t2.nationflag<>'国内'
then (t1.ticket_price+t1.ad_fy)*t1.r_rate
else 0 end     
)*(t3.round_time/t4.round_time) tktfee,
sum(case when t2.origin_std< sysdate-1/24 and t1.flag_Id=40 
 then (t1.ticket_price+t1.ad_fy)
when t2.origin_std>= sysdate-1/24 and t1.flag_id in(3,5,40,41) then (t1.ticket_price+t1.ad_fy)*t1.r_rate
else 0 end     
)*(t3.round_time/t4.round_time) hstktfee
  from cqsale.cq_order_head@to_air t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  left join if.v_rep_segment_roundtime t3 on split_part(t2.route_name,'－',2)||'－'||split_part(t2.route_name,'－',3) =t3.flights_segment_name
  left join if.v_rep_segment_roundtime t4 on t2.route_name=t4.flights_segment_name
  where t1.r_flights_date>=to_date('${sdate}', 'yyyy-mm-dd')
    and t1.r_flights_date<=to_date('${edate}', 'yyyy-mm-dd')
    and t1.r_flights_date>=trunc(sysdate)
    and t1.whole_flight like '9C%'
    and t2.flag<>2
    and t2.segment_type like '%经停AC段%'
  group by t1.r_flights_date,t1.whole_flight,t1.whole_flight||'Y' ,
split_part(t2.route_name,'－',2)||'－'||split_part(t2.route_name,'－',3) ,
t2.route_name,t3.round_time,
t4.round_time,
t2.segment_type
)tb1
group by tb1.flight_date,tb1.whole_flight,tb1.flightno,tb1.flights_segment_name,
       tb1.route_name) tp3 on tp2.flight_date=tp3.flight_date and tp2.whole_flight=tp3.whole_flight and tp2.flightno=tp3.flightno
       and tp2.flights_segment_name=tp3.flights_segment_name

--获取补贴
left join(
select h1.flightdate,h1.route_name,h1.whole_flight,h1.flightno,h1.flights_segment_name,sum(h1.subsidy_seg) subsidy_seg
from(
select t1.flightdate,t1.route_name,
t1.flightno whole_flight,split_part(t1.route_name,'－',3) splitname,
case when split_part(t1.route_name,'－',3) is not null then 
t1.flightno||'X'
else t1.flightno end flightno,
case when split_part(t1.route_name,'－',3) is not null then 
split_part(t1.route_name,'－',1)||'－'||split_part(t1.route_name,'－',2)
else t1.route_name end flights_segment_name,t1.subsidy,
case when split_part(t1.route_name,'－',3) is not null then 
to_number(decrypt_des(subsidy, 'subsidy0718'))/2
else to_number(decrypt_des(subsidy, 'subsidy0718'))
end subsidy_seg
from hdb.wb_flight_subsidy_summary t1
where t1.flightdate>=to_date('${sdate}', 'yyyy-mm-dd')
and t1.flightdate<=to_date('${edate}', 'yyyy-mm-dd')

union all 

select t1.flightdate,t1.route_name,
t1.flightno whole_flight,split_part(t1.route_name,'－',3) splitname,
t1.flightno||'Y' flightno,
split_part(t1.route_name,'－',2)||'－'||split_part(t1.route_name,'－',3) flights_segment_name,
t1.subsidy,to_number(decrypt_des(subsidy, 'subsidy0718'))/2
from hdb.wb_flight_subsidy_summary t1
where split_part(t1.route_name,'－',3) is not null
and t1.flightdate>=to_date('${sdate}', 'yyyy-mm-dd')
and t1.flightdate<=to_date('${edate}', 'yyyy-mm-dd')
)h1
group by h1.flightdate,h1.route_name,h1.whole_flight,h1.flightno,h1.flights_segment_name
) sidy1 on sidy1.flightdate=tp2.flight_date and sidy1.whole_flight=tp2.whole_flight and sidy1.flights_segment_name=tp2.flights_segment_name


group by tp2.whole_flight,tp2.flightno,tp2.flights_segment_name,tp2.route_name,tp2.wf_segment_name,tp2.round_time/60
) tp2 
    
--针对flights_segment_name 进行补充

left join (
select flights_segment_name,segment_code,min(nationflag) nationflag,min(nvl(income_type,'-')) income_type
         from dw.dim_segment_type
         where flights_segment_name is not null
         group by flights_segment_name,segment_code
) mid0 on mid0.flights_segment_name=tp2.flights_segment_name

---获取变动成本

left join if.v_rep_segment_varicost tp4 on tp2.flightno=tp4.flightno and tp2.flights_segment_name=tp4.flights_segment_name



---参考时间段1
left join 
(select whole_flight,flights_segment_name,sum(tktfee)/sum(round_time) hour_income,
        sum(tkt)/sum(layout) plf
    from dw.v_fact_segment_detail 
    where flight_date< trunc(sysdate)
    and flight_date>=to_date('${scorr1}', 'yyyy-mm-dd')
    and flight_date<=to_date('${ecorr1}', 'yyyy-mm-dd')
    group by whole_flight,flights_segment_name
    )hp1 on hp1.whole_flight=tp2.whole_flight and hp1.flights_segment_name=tp2.flights_segment_name 
left join 
(select flights_segment_name,sum(tktfee)/sum(round_time) hour_income,
        sum(tkt)/sum(layout) plf
    from dw.v_fact_segment_detail 
    where flight_date< trunc(sysdate)
    and flight_date>=to_date('${scorr1}', 'yyyy-mm-dd')
    and flight_date<=to_date('${ecorr1}', 'yyyy-mm-dd')
    group by  flights_segment_name
    )hp2 on  hp2.flights_segment_name=tp2.flights_segment_name
left join 
(select nationflag,sum(tktfee)/sum(round_time) hour_income,
        sum(tkt)/sum(layout) plf
    from dw.v_fact_segment_detail 
    where flight_date< trunc(sysdate)
    and flight_date>=to_date('${scorr1}', 'yyyy-mm-dd')
    and flight_date<=to_date('${ecorr1}', 'yyyy-mm-dd')
    and nationflag='国内' 
    group by nationflag
    )hp3 on  hp3.nationflag=mid0.nationflag

--参考时间段2

left join 
(select whole_flight,flights_segment_name,sum(tktfee)/sum(round_time) hour_income,
        sum(tkt)/sum(layout) plf
    from dw.v_fact_segment_detail 
    where flight_date< trunc(sysdate)
    and flight_date>=to_date('${scorr2}', 'yyyy-mm-dd')
    and flight_date<=to_date('${ecorr2}', 'yyyy-mm-dd')
    group by whole_flight,flights_segment_name
    )hs1 on hs1.whole_flight=tp2.whole_flight and hs1.flights_segment_name=tp2.flights_segment_name 
left join 
(select flights_segment_name,sum(tktfee)/sum(round_time) hour_income,
        sum(tkt)/sum(layout) plf
    from dw.v_fact_segment_detail 
    where flight_date< trunc(sysdate)
    and flight_date>=to_date('${scorr2}', 'yyyy-mm-dd')
    and flight_date<=to_date('${ecorr2}', 'yyyy-mm-dd')
    group by  flights_segment_name
    )hs2 on  hs2.flights_segment_name=tp2.flights_segment_name 
left join 
(select nationflag,sum(tktfee)/sum(round_time) hour_income,
        sum(tkt)/sum(layout) plf
    from dw.v_fact_segment_detail 
    where flight_date< trunc(sysdate)
    and flight_date>=to_date('${scorr2}', 'yyyy-mm-dd')
    and flight_date<=to_date('${ecorr2}', 'yyyy-mm-dd')
    and nationflag='国内' 
    group by nationflag
    )hs3 on  hs3.nationflag=mid0.nationflag

--参考时间段3

left join 
(select whole_flight,flights_segment_name,sum(tktfee)/sum(round_time) hour_income,
        sum(tkt)/sum(layout) plf
    from dw.v_fact_segment_detail 
    where flight_date< trunc(sysdate)
    and flight_date>=to_date('${scorr3}', 'yyyy-mm-dd')
    and flight_date<=to_date('${ecorr3}', 'yyyy-mm-dd')
    group by whole_flight,flights_segment_name
    )ht1 on ht1.whole_flight=tp2.whole_flight and ht1.flights_segment_name=tp2.flights_segment_name 
left join 
(select flights_segment_name,sum(tktfee)/sum(round_time) hour_income,
        sum(tkt)/sum(layout) plf
    from dw.v_fact_segment_detail 
    where flight_date< trunc(sysdate)
    and flight_date>=to_date('${scorr3}', 'yyyy-mm-dd')
    and flight_date<=to_date('${ecorr3}', 'yyyy-mm-dd')
    group by  flights_segment_name
    )ht2 on  ht2.flights_segment_name=tp2.flights_segment_name 
left join 
(select nationflag,sum(tktfee)/sum(round_time) hour_income,
        sum(tkt)/sum(layout) plf
    from dw.v_fact_segment_detail 
    where flight_date< trunc(sysdate)
    and flight_date>=to_date('${scorr3}', 'yyyy-mm-dd')
    and flight_date<=to_date('${ecorr3}', 'yyyy-mm-dd')
    and nationflag='国内' 
    group by nationflag
    )ht3 on  ht3.nationflag=mid0.nationflag
) ts1 
where 1=1 
     ${if(nflag == '', "", "and ts1.nationflag in ('" + nflag + "')") }
     ${if(itype == '',"","and ts1.income_type in ('" + itype + "')") }
     ${if(wfs == '',"","and ts1.wf_segment_name in ('" + wfs + "')") }   
     ${if(route_name == '',"","and ts1.route_name in ('" + route_name + "')") }
     ${if(fno == '', "", "and ts1.whole_flight in ('" + fno + "')") }
     ${if(fs == '', "", "and ts1.flights_segment_name in ('" + fs + "')") }
     ${if(ocity == '', "", "and ts1.originairport_name in ('" + ocity + "')") }
     ${if(dcity == '', "", "and ts1.destairport_name in ('" + dcity + "')") }
