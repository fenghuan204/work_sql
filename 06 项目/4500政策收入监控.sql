select tp2.flight_date,to_char(tp2.flight_date,'day') weeknum,
to_char(tp2.flight_date-1,'d') weekname,
tp2.whole_flight,tp2.flightno,tp2.flights_segment_name,
tp2.route_name,tp2.wf_segment_name,
tp2.round_time/60 round_time,tp2.alltime/60 alltime,
tp2.layout,nvl(tp3.tkt,0) tkt,nvl(tp3.tktfee,0) tktfee,nvl(tp3.hstktfee,0) hstktfee,
fnum,
tp4.vari_cost,
nvl(tp5.subsidy_seg,0) subsidy_seg
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
left join (select  h_route_id,route_id,max(nflag) nflag from dw.dim_route_manager_info_orig group by h_route_id,route_id)qx 
  on t2.h_route_id=qx.h_route_id and t2.route_id=qx.route_id  
  left join if.v_rep_segment_roundtime t3 on (case when t2.segment_type like '%经停AC%' then 
  split_part(t2.route_name,'－',1)||'－'||split_part(t2.route_name,'－',2) 
  else t2.flights_segment_name end) =t3.flights_segment_name
  left join if.v_rep_segment_roundtime t4 on t2.route_name=t4.flights_segment_name
 left join dw.dim_segment_type t5 on t2.h_route_id = t5.h_route_id and t2.route_id = t5.route_id
  where t2.flight_date>=to_date('${sdate}', 'yyyy-mm-dd')
    and t2.flight_date<=to_date('${edate}', 'yyyy-mm-dd')
    and t2.flight_no like '9C%'
    and t2.flag<>2
     ${if(quflag == '', "", "and nvl(qx.nflag,'-') in ('" + quflag + "')") }
     ${if(flag == '', "", "and t2.flag in ('" + flag + "')") }
     ${if(nflag == '', "", "and t2.nationflag in ('" + nflag + "')") }
     ${if(scountry == '',"","and t2.segment_country in ('" + scountry + "')") }
     ${if(itype == '',"","and t5.income_type in ('" + itype + "')") }
     ${if(wfs == '',"","and t5.wf_segment_name in ('" + wfs + "')") }
   
     ${if(route_name == '',"","and t2.route_name in ('" + route_name + "')") }
     ${if(fno == '', "", "and t2.flight_no in ('" + fno + "')") }
     ${if(ocity == '', "", "and t2.origincity_name in ('" + ocity + "')") }
     ${if(dcity == '', "", "and t2.destcity_name in ('" + dcity + "')") }

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
  where t2.flight_date>=to_date('${sdate}', 'yyyy-mm-dd')
    and t2.flight_date<=to_date('${edate}', 'yyyy-mm-dd')
    and t2.flight_no like '9C%'
    and t2.flag<>2
    and t2.segment_type like '%经停AC段%'
    ${if(flag == '', "", "and t2.flag in ('" + flag + "')") }
    ${if(quflag == '', "", "and nvl(qx.nflag,'-') in ('" + quflag + "')") }
     ${if(nflag == '', "", "and t2.nationflag in ('" + nflag + "')") }
     ${if(scountry == '',"","and t2.segment_country in ('" + scountry + "')") }
     ${if(itype == '',"","and t5.income_type in ('" + itype + "')") }
     ${if(wfs == '',"","and t5.wf_segment_name in ('" + wfs + "')") }
     --${if(fs == '',"","and t2.flights_segment_name in ('" + fs + "')") }
     ${if(route_name == '',"","and t2.route_name in ('" + route_name + "')") }
     ${if(fno == '', "", "and t2.flight_no in ('" + fno + "')") }
     ${if(ocity == '', "", "and t2.origincity_name in ('" + ocity + "')") }
     ${if(dcity == '', "", "and t2.destcity_name in ('" + dcity + "')") }
    
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
and t2.nationflag='国内' then (t1.ticket_price+t1.ad_fy)*t1.r_rate*0.9174 
when t2.origin_std< sysdate-1/24 and t1.flag_Id=40 
and t2.nationflag<>'国内' then (t1.ticket_price+t1.ad_fy)*t1.r_rate 
when t2.origin_std>= sysdate-1/24 and t1.flag_id in(3,5,40,41)  and t2.nationflag='国内'
then (t1.ticket_price+t1.ad_fy)*t1.r_rate*0.9174 
when t2.origin_std>= sysdate-1/24 and t1.flag_id in(3,5,40,41)  and t2.nationflag<>'国内'
then (t1.ticket_price+t1.ad_fy)*t1.r_rate
else 0 end     
) *(t3.round_time/t4.round_time)
else sum(case when t2.origin_std< sysdate-1/24 and t1.flag_Id=40  
and t2.nationflag='国内' then (t1.ticket_price+t1.ad_fy)*t1.r_rate*0.9174 
when t2.origin_std< sysdate-1/24 and t1.flag_Id=40 
and t2.nationflag<>'国内' then (t1.ticket_price+t1.ad_fy)*t1.r_rate 
when t2.origin_std>= sysdate-1/24 and t1.flag_id in(3,5,40,41)  and t2.nationflag='国内'
then (t1.ticket_price+t1.ad_fy)*t1.r_rate*0.9174 
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
and t2.nationflag='国内' then (t1.ticket_price+t1.ad_fy)*t1.r_rate*0.9174 
when t2.origin_std< sysdate-1/24 and t1.flag_Id=40 
and t2.nationflag<>'国内' then (t1.ticket_price+t1.ad_fy)*t1.r_rate 
when t2.origin_std>= sysdate-1/24 and t1.flag_id in(3,5,40,41) and t2.nationflag='国内'
then (t1.ticket_price+t1.ad_fy)*t1.r_rate*0.9174 
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
left join if.v_rep_segment_varicost tp4 on tp2.flightno=tp4.flightno and tp2.flights_segment_name=tp4.flights_segment_name
left join 
(select h1.flightdate,h1.route_name,h1.whole_flight,h1.flightno,h1.flights_segment_name,
h1.subsidy,h1.subsidy_seg
from(
select  t1.flightdate,t1.route_name,
t1.flightno whole_flight,split_part(t1.route_name,'－',3) splitname,
case when split_part(t1.route_name,'－',3) is not null then 
t1.flightno||'X'
else t1.flightno end flightno,
case when split_part(t1.route_name,'－',3) is not null then 
split_part(t1.route_name,'－',1)||'－'||split_part(t1.route_name,'－',2)
else t1.route_name end flights_segment_name,t1.subsidy,
case when split_part(t1.route_name,'－',3) is not null then 
to_number(decrypt_des(subsidy, 'subsidy0718'))/2
else to_number(decrypt_des(subsidy, 'subsidy0718')) end  subsidy_seg
from hdb.wb_flight_subsidy_summary t1

union all 

select  t1.flightdate,t1.route_name,
t1.flightno whole_flight,split_part(t1.route_name,'－',3) splitname,
t1.flightno||'Y'  flightno,
split_part(t1.route_name,'－',2)||'－'||split_part(t1.route_name,'－',3)  flights_segment_name,
t1.subsidy,to_number(decrypt_des(subsidy, 'subsidy0718'))/2
from hdb.wb_flight_subsidy_summary t1
where split_part(t1.route_name,'－',3) is not null
)h1
) tp5 on tp2.flight_date =tp5.flightdate and tp2.flightno=tp5.flightno and tp2.flights_segment_name=tp5.flights_segment_name
where 1=1
           ${if(len(lower1)==0,"","and nvl(tp3.tkt,0)/tp2.layout>="+ lower1 +"")}
           ${if(len(upper1)==0,"","and nvl(tp3.tkt,0)/tp2.layout<="+ upper1 +"")}
           ${if(len(lower2)==0,"","and tktfee/(tp2.round_time/60)>="+ lower2 +"")}
           ${if(len(upper2)==0,"","and tktfee/(tp2.round_time/60)<="+upper2 +"")}
             ${if(fs == '',"","and tp2.flights_segment_name in ('" + fs + "')") }
       order by 1,8,4,5
