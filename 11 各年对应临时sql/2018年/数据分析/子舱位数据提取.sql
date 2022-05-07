--#子舱位相关数据
select t1.flights_date,t2.flights_segment_name,t3.wf_segment_name,t4.manager,
sum(case when t1.EX_CFD5 is  not null then 1 else 0 end),count(1)
from dw.fact_order_detail t1
join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
left join dw.adt_wf_segment t3 on t2.h_route_id=t3.route_id
left join (select  wf_segment_name,manager from dw.adt_route_daypractice_nqx
where nationflag is not null)t4 on t3.wf_segment_name=t4.wf_segment_name
where  t1.flights_date>=trunc(sysdate,'mm')
and t1.flights_date< trunc(sysdate)
and t2.flag<>2
and t1.seats_name is not NULL
and t1.seats_name not in('B','G','G1','G2','O')
and t1.company_id=0
group by t1.flights_date,t2.flights_segment_name,t3.wf_segment_name,t4.manager;
