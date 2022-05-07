select *
 from hdb.v_may_varicost
 
 select t1.wf_segment_name,t1.route_name,t1.flight_no,t1.varicost_per,t2.perhour_cost,CASE WHEN T2.PERHOUR_COST IS NULL THEN NULL
 ELSE t1.varicost_per-t2.perhour_cosT END
 from hdb.wb_route_varicost_may t1
 join hdb.v_may_varicost t2 on t1.wf_segment_name=t2.wf_segment_name and t1.route_name=t2.route_name and t1.flight_no=t2.flight_no;
 
 
 select t1.flight_date,sum(t1.vari_cost),sum(t1.vari_cost)/sum(t1.round_time),sum(nvl(t2.varicost_per*t1.round_time,t1.vari_cost)),
 sum(nvl(t2.varicost_per*t1.round_time,t1.vari_cost))/sum(t1.round_time) 
  from hdb.recent_flights_cost t1
  left join hdb.wb_route_varicost_may t2 on t1.route_name=t2.route_name and t1.flight_no=t2.flight_no
  where t1.flight_date>=to_date('2020-04-01','yyyy-mm-dd')
  and t1.total_cost>0
  and t1.checkin_s_mile>0
  and t1.round_time>0
  group by t1.flight_date
  order by 1
  
  
  
 select t1.flight_date,t1.nation_flag,sum(t1.total_income),sum(t1.vari_cost),sum(t1.tax_fee),sum(t1.tax_fee)/sum(t1.total_income)
 sum(t1.vari_cost)/sum(t1.round_time),sum(nvl(t2.perhour_cost*t1.round_time,t1.vari_cost)),
 sum(nvl(t2.perhour_cost*t1.round_time,t1.vari_cost))/sum(t1.round_time) 
  from hdb.recent_flights_cost t1
  left join hdb.v_may_varicost t2 on t1.route_name=t2.route_name and t1.flight_no=t2.flight_no
  where t1.flight_date=to_date('2020-05-11','yyyy-mm-dd')
 and t1.total_cost>0
 and t1.checkin_s_mile>0
 and t1.round_time>0
  group by t1.flight_date,t1.nation_flag

  
  
 
 
