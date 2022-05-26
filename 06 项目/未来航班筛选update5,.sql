select ts4.wf_route_name,
       ts4.flighthour,
       sum(ts4.round_time) round_time,
       sum(ts4.planum) planum,
       sum(ts4.fnum) fnum,
       sum(ts4.sumtime) sumtime,
       sum(ts4.tkt) tkt,
       sum(ts4.tkffee) tkffee,
       sum(ts4.totalincome) totalincome, 
       sum(ts4.sj_income) sj_income,
       sum(ts4.last_tkt)  last_tkt,
       sum(ts4.last_income) last_income,
       sum(ts4.subsidy) subsidy,
       sum(ts4.cwcost) cwcost,
       sum(ts4.mhcost) mhcost,
       sum(ts4.last_bjgx) last_bjgx
from(
select ts2.wf_route_name,
       ts2.flighthour,
       ts2.flights_segment_name,ts2.round_time,
       sum(ts2.plannum) planum,
       sum(ts2.fnum) fnum,
       sum(ts2.sumtime) sumtime,
       sum(ts2.tkt) tkt,
       sum(ts2.tktfee) tkffee,
       sum(ts2.tktfee)+sum(ts2.subsidy) totalincome, 
       sum(ts2.sj_hourincome*ts2.sumtime)-sum(ts2.cw_hourvaricost*ts2.sumtime) sj_income,
       sum(ts2.last_tkt)  last_tkt,
       sum(ts2.last_income) last_income,
       sum(ts2.subsidy) subsidy,
       sum(ts2.cw_hourvaricost*ts2.sumtime) cwcost,
       sum(ts2.mh_hourvaricost*ts2.sumtime) mhcost,
       sum(ts2.sj_bjgx) last_bjgx
from(
select nvl(ts3.wf_route_name,ts1.wf_segment_name) wf_route_name,
ts3.flighthour,
ts1.whole_flight,ts1.flights_segment_name,ts1.segment_code,
       ts1.route_name,ts1.originairport_name,ts1.destairport_name,
       ts1.wf_segment_name,
       ts1.flag,
       ts1.round_time,
       ts1.fnum,
       ts1.layout,
       ts1.plannum,
       ts1.tkt,
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
       ts1.subsidy_seg,
      case when ts1.plf<=0.75 then 
       case when ts1.hour_income+ts1.hoursubsidy+24000<= ts1.mh_hourvaricost 
       then ts1.hour_income+2400+ts1.hoursubsidy
       when ts1.hour_income+ts1.hoursubsidy>= ts1.mh_hourvaricost then ts1.hour_income+ts1.hoursubsidy
       when ts1.hour_income+ts1.hoursubsidy< ts1.mh_hourvaricost and ts1.hour_income+24000+ts1.hoursubsidy> ts1.mh_hourvaricost then  ts1.mh_hourvaricost 
       else null end
       else ts1.hour_income+ts1.hoursubsidy
       end  
       sj_hourincome,
       ts1.subsidy
from(
select tp2.whole_flight,tp2.flights_segment_name,tp2.route_name,
       tp2.wf_segment_name,tp2.nationflag,tp2.income_type,
       tp2.flag,
       tp2.segment_code,
       split_part(tp2.flights_segment_name,'－',1) originairport_name,
       split_part(tp2.flights_segment_name,'－',2) destairport_name,
       tp2.round_time,
       tp2.fnum,
       tp2.layout plannum,
       tp2.tkt tkt,
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
       else null end)+24000+(nvl(tp2.subsidy_seg,0)/tp2.round_time) < tp4.mh_hourvaricost then (case when hp1.hour_income > 0 then hp1.hour_income
       when hp2.hour_income > 0 then hp2.hour_income
       when hs2.hour_income > 0 then hs2.hour_income*(hp3.hour_income/hs3.hour_income)
       when ht2.hour_income>0 then ht2.hour_income*(hp3.hour_income/ht3.hour_income)
       else null end)+24000+(nvl(tp2.subsidy_seg,0)/tp2.round_time) 
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
       else null end)+(nvl(tp2.subsidy_seg,0)/tp2.round_time) >= tp4.mh_hourvaricost then (case when hp1.hour_income > 0 then hp1.hour_income
       when hp2.hour_income > 0 then hp2.hour_income
       when hs2.hour_income > 0 then hs2.hour_income*(hp3.hour_income/hs3.hour_income)
       when ht2.hour_income>0 then ht2.hour_income*(hp3.hour_income/ht3.hour_income)
       else null end)+(nvl(tp2.subsidy_seg,0)/tp2.round_time) 
       else 0 end midhourincome2,
       nvl(tp2.subsidy_seg,0)  subsidy_seg,
       (nvl(tp2.subsidy_seg,0)/tp2.round_time) hoursubsidy,
        nvl(tp2.subsidy_seg,0)*tp2.fnum subsidy

from
(
select tp1.whole_flight,tp1.flights_segment_name,mid0.segment_code,mid0.nationflag,mid0.income_type,
tp1.route_name,tp1.wf_segment_name,tp1.round_time round_time,
case when tp2.whole_flight is null then 1
else 0 end flag,
case when tp2.whole_flight is null then to_date('${edate}', 'yyyy-mm-dd')-to_date('${sdate}', 'yyyy-mm-dd')+1
else tp2.fnum end fnum,
case when tp2.whole_flight is null then (to_date('${edate}', 'yyyy-mm-dd')-to_date('${sdate}', 'yyyy-mm-dd')+1)*tp1.round_time
else tp2.sumtime end sumtime,
case when tp2.whole_flight is null then (to_date('${edate}', 'yyyy-mm-dd')-to_date('${sdate}', 'yyyy-mm-dd')+1)*tp1.avglayout
else tp2.planum end layout,
nvl(tp3.tkt,0) tkt,
nvl(tp3.tktfee,0) tktfee,
nvl(tp3.hstktfee,0) hstktfee,
nvl(sidy1.subsidy,0) subsidy_seg
from 
--5月21日到7月20日4500政策期间航班号+航段
(select whole_flight,flights_segment_name,route_name,wf_segment_name,round_time/60 round_time,
sum(round_time/60) sumtime,sum(fnum) fnum,sum(layout) plannum,sum(layout)/sum(fnum) avglayout
from(
select tp1.flight_date,tp1.whole_flight,tp1.flights_segment_name,
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
left join (select  h_route_id,route_id,max(nflag) nflag from dw.dim_route_manager_info_orig group by h_route_id,route_id)qx 
  on t2.h_route_id=qx.h_route_id and t2.route_id=qx.route_id  
  left join if.v_rep_segment_roundtime t3 on (case when t2.segment_type like '%经停AC%' then 
  split_part(t2.route_name,'－',1)||'－'||split_part(t2.route_name,'－',2) 
  else t2.flights_segment_name end) =t3.flights_segment_name
  left join if.v_rep_segment_roundtime t4 on t2.route_name=t4.flights_segment_name
 left join dw.dim_segment_type t5 on t2.h_route_id = t5.h_route_id and t2.route_id = t5.route_id
  where t2.flight_date>=date'2022-05-21'
    and t2.flight_date<=date'2022-07-20'
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
  left join (select  h_route_id,route_id,max(nflag) nflag from dw.dim_route_manager_info_orig group by h_route_id,route_id  )qx 
  on t2.h_route_id=qx.h_route_id and t2.route_id=qx.route_id
  left join if.v_rep_segment_roundtime t3 on split_part(t2.route_name,'－',2)||'－'||split_part(t2.route_name,'－',3) =t3.flights_segment_name
  left join if.v_rep_segment_roundtime t4 on t2.route_name=t4.flights_segment_name
  left join dw.dim_segment_type t5 on t2.h_route_id = t5.h_route_id and t2.route_id = t5.route_id
  where t2.flight_date>=date'2022-05-21'
    and t2.flight_date<=date'2022-07-20'
    and t2.flight_no like '9C%'
    and t2.flag<>2
    and t2.segment_type like '%经停AC段%'      
    )tp1
  group by tp1.flight_date,tp1.whole_flight,tp1.flights_segment_name,
tp1.route_name,tp1.wf_segment_name,tp1.round_time,tp1.alltime)
group by whole_flight,flights_segment_name,route_name,wf_segment_name,round_time/60
)tp1

---筛选时间段类航班明细

left join(
select tt1.whole_flight,tt1.flights_segment_name,tt1.route_name,
       tt1.wf_segment_name,tt1.round_time/60 round_time,tt1.alltime,sum(fnum) fnum,sum(layout) planum,
       sum(layout)/sum(fnum) avglayout,sum(tt1.round_time/60) sumtime
from(
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
tp1.route_name,tp1.wf_segment_name,tp1.round_time,tp1.alltime)tt1
group by tt1.whole_flight,tt1.flights_segment_name,tt1.route_name,
       tt1.wf_segment_name,tt1.round_time/60 ,tt1.alltime
) tp2 on tp1.whole_flight=tp2.whole_flight and tp1.flights_segment_name=tp2.flights_segment_name

---实时销售数据
left join 
(select tb1.whole_flight,tb1.flights_segment_name,
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
    and t1.r_flights_date>=date'2022-05-21'
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
    and t1.r_flights_date>=date'2022-05-21'
    and t1.whole_flight like '9C%'
    and t2.flag<>2
    and t2.segment_type like '%经停AC段%'
  group by t1.r_flights_date,t1.whole_flight,t1.whole_flight||'Y' ,
split_part(t2.route_name,'－',2)||'－'||split_part(t2.route_name,'－',3) ,
t2.route_name,t3.round_time,
t4.round_time,
t2.segment_type
)tb1
group by tb1.whole_flight,tb1.flights_segment_name,
       tb1.route_name) tp3 on  tp2.whole_flight=tp3.whole_flight  and tp2.flights_segment_name=tp3.flights_segment_name

    
--针对flights_segment_name 进行补充
left join (
select flights_segment_name,segment_code,min(nationflag) nationflag,min(nvl(income_type,'-')) income_type
         from dw.dim_segment_type
         where flights_segment_name is not null
         group by flights_segment_name,segment_code
) mid0 on mid0.flights_segment_name=tp1.flights_segment_name
--获取补贴
left join hdb.rep_dim_segment_subsidy  sidy1 on sidy1.whole_flight=tp2.whole_flight and sidy1.flights_segment=mid0.segment_code


) tp2 


---获取变动成本

left join if.v_rep_segment_varicost tp4 on tp2.whole_flight=tp4.whole_flight and tp2.flights_segment_name=tp4.flights_segment_name


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
    )hp3 on  hp3.nationflag=tp2.nationflag

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
    )hs3 on  hs3.nationflag=tp2.nationflag

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
    )ht3 on  ht3.nationflag=tp2.nationflag
    where 1=1    ${if(flag == '', "", "and tp2.flag in ('" + flag + "')") }

) ts1 

left join
(select hb.wf_segment_name,hb.flight_no,hb.route_name,hb1.wf_route_name,hb1.flighthour,hb1.snum

from
(select distinct t2.wf_segment_name,t1.flight_no,t1.route_name
 from dw.da_flight t1
  left join dw.dim_segment_type t2 on t1.h_route_id=t2.h_route_id and t1.route_id =t2.route_id
  where t1.segment_type not like '%AC%'
  and t1.flight_date>=to_date('2022-05-21','yyyy-mm-dd')
  and t1.flight_date<=to_date('2022-07-20','yyyy-mm-dd')
  and t1.flag<>2 
  and length(t1.flight_no)=6)hb
  left join 

(
select wf_segment_name,flight_no,route_name,min(wf_route_name) wf_route_name,min(flighthour) flighthour,count(1) snum
from(
select distinct h1.wf_segment_name,h1.flight_no,h1.route_name,
case when h2.wf_segment_name is not null then 
case when split_part(h1.route_name,'－',3) is not null then
split_part(h1.route_name,'－',1)||'＝'||split_part(h1.route_name,'－',2)||'＝'||split_part(h1.route_name,'－',3)
else 
split_part(h1.route_name,'－',1)||'＝'||split_part(h1.route_name,'－',2)
end 
when h3.wf_segment_name is not null then 
case when split_part(h3.route_name,'－',3) is not null then
split_part(h3.route_name,'－',1)||'＝'||split_part(h3.route_name,'－',2)||'＝'||split_part(h3.route_name,'－',3)
else 
split_part(h3.route_name,'－',1)||'＝'||split_part(h3.route_name,'－',2)
end 
else null end wf_route_name,
case when h2.wf_segment_name is not null then 
h1.flight_no||' '||h1.origin||'/'||h2.flight_no||' '||h2.origin
when h3.wf_segment_name is not null then 
h3.flight_no||' '||h3.origin||'/'||h1.flight_no||' '||h1.origin
end flighthour

from(
select t2.wf_segment_name,t1.flight_no,t1.route_name,min(to_char(t1.origin_std,'hh24mi')) origin,
max(to_char(t1.dest_sta,'hh24mi')) dest
 from dw.da_flight t1
  left join dw.dim_segment_type t2 on t1.h_route_id=t2.h_route_id and t1.route_id =t2.route_id

  where t1.segment_type not like '%AC%'
  and t1.flight_date>=to_date('2022-05-21','yyyy-mm-dd')
  and t1.flight_date<=to_date('2022-07-20','yyyy-mm-dd')
  and t1.flag<>2 
  and length(t1.flight_no)=6
  and regexp_like(substr(t1.flight_no,6,1),'[0-9]')
  group by  t2.wf_segment_name,t1.flight_no,t1.route_name)h1
  left join 
 (select t2.wf_segment_name,t1.flight_no,t1.route_name,min(to_char(t1.origin_std,'hh24mi')) origin,
max(to_char(t1.dest_sta,'hh24mi')) dest
 from dw.da_flight t1
  left join dw.dim_segment_type t2 on t1.h_route_id=t2.h_route_id and t1.route_id =t2.route_id
  where t1.segment_type not like '%AC%'
  and t1.flight_date>=to_date('2022-05-21','yyyy-mm-dd')
  and t1.flight_date<=to_date('2022-07-20','yyyy-mm-dd')
  and t1.flag<>2 
  and length(t1.flight_no)=6
  and regexp_like(substr(t1.flight_no,6,1),'[0-9]')
  group by  t2.wf_segment_name,t1.flight_no,t1.route_name)h2 on h1.wf_segment_name=h2.wf_segment_name
  and to_number(substr(h1.flight_no,3,4))+1=to_number(substr(h2.flight_no,3,4))
  left join 
 (select t2.wf_segment_name,t1.flight_no,t1.route_name,min(to_char(t1.origin_std,'hh24mi')) origin,
max(to_char(t1.dest_sta,'hh24mi')) dest
 from dw.da_flight t1
  left join dw.dim_segment_type t2 on t1.h_route_id=t2.h_route_id and t1.route_id =t2.route_id
  where t1.segment_type not like '%AC%'
  and t1.flight_date>=to_date('2022-05-21','yyyy-mm-dd')
  and t1.flight_date<=to_date('2022-07-20','yyyy-mm-dd')
  and t1.flag<>2 
  and length(t1.flight_no)=6
  and regexp_like(substr(t1.flight_no,6,1),'[0-9]')
  group by  t2.wf_segment_name,t1.flight_no,t1.route_name)h3 on h1.wf_segment_name=h3.wf_segment_name
  and to_number(substr(h1.flight_no,3,4))=to_number(substr(h3.flight_no,3,4))+1
  where h2.wf_segment_name is  not null 
  or h3.wf_segment_name is  not null )
  group by wf_segment_name,flight_no,route_name
  )hb1 on hb.flight_no=hb1.flight_no and hb.route_name=hb1.route_name
  where hb1.flighthour is not null )ts3 on ts1.whole_flight=ts3.flight_no and ts1.route_name=ts3.route_name

where 1=1 
and ts1.cw_hourvaricost is not null 
and ts1.mh_hourvaricost is not null 
and ts1.round_time>0
and ts1.last_tkt>0
     ${if(nflag == '', "", "and ts1.nationflag in ('" + nflag + "')") }
     ${if(itype == '',"","and ts1.income_type in ('" + itype + "')") }
     ${if(wfs == '',"","and ts1.wf_segment_name in ('" + wfs + "')") }   
     ${if(route_name == '',"","and ts1.route_name in ('" + route_name + "')") }
     ${if(fno == '', "", "and ts1.whole_flight in ('" + fno + "')") }
     ${if(fs == '', "", "and ts1.flights_segment_name in ('" + fs + "')") }
     ${if(ocity == '', "", "and ts1.originairport_name in ('" + ocity + "')") }
     ${if(dcity == '', "", "and ts1.destairport_name in ('" + dcity + "')") }
) ts2 
group by ts2.wf_route_name,
       ts2.flighthour,
       ts2.flights_segment_name,ts2.round_time
       )ts4
     group by ts4.wf_route_name,ts4.flighthour
     order by 1,2