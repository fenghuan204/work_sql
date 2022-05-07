select t1.*,t2.route_name,t3.route_name
  from stg.wb_flight_subsidy t1
  left join (select distinct route_name,flight_no from dw.da_flight where flag <> 2) t2 on t1.segment_name1 =
                                                                                 t2.route_name and t1.flightno1=t2.flight_no
  left join (select distinct route_name,flight_no from dw.da_flight where flag <> 2) t3 on t1.segment_name2 =
                                                                                 t3.route_name and t1.flightno2=t3.flight_no;


select distinct  null flightno,'扬州所有航线' route_name,
null wf_name,121000 subsidy_num,'2020年3月1日-2020年3月31日' datetype,
h1.flight_no,h2.flight_no,h1.route_name,h1.route_name,to_date('2020/3/1','yyyy-mm-dd') sdate,
to_date('2020/3/31','yyyy-mm-dd') edate
from(
select distinct t2.wf_segment_name,60000 subsidy_num,t1.flight_no,t1.route_name,
to_date('2020-03-01','yyyy-mm-dd'),to_date('2020-03-31','yyyy-mm-dd')
from dw.da_flight  t1
left join dw.dim_segment_type t2 on t1.route_id=t2.route_id and t1.h_route_id=t2.h_route_id
where t1.flight_date>=to_date('2020-03-01','yyyy-mm-dd')
  and t1.flight_date<=to_date('2020-03-31','yyyy-mm-dd')
  and t1.route_name like '%扬州%'
  and t1.flag<>2)h1
   join (  
  select distinct t2.wf_segment_name,60000 subsidy_num,t1.flight_no,t1.route_name,
to_date('2020-03-01','yyyy-mm-dd'),to_date('2020-03-31','yyyy-mm-dd')
from dw.da_flight  t1
left join dw.dim_segment_type t2 on t1.route_id=t2.route_id and t1.h_route_id=t2.h_route_id
where t1.flight_date>=to_date('2020-03-01','yyyy-mm-dd')
  and t1.flight_date<=to_date('2020-03-31','yyyy-mm-dd')
  and t1.route_name like '%扬州%'
  and t1.flag<>2)h2 on h1.flight_no=substr(h2.flight_no,1,4)||(to_number(substr(h2.flight_no,5,2))+1) and h1.wf_segment_name=h2.wf_segment_name

