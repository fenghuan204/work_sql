select count(distinct t1.flights_segment_name) ������,count(distinct t2.wf_segment) ��������,
count(distinct replace(replace(replace(t1.origincity_name,'ǭ��','����'),'��¡','����'),'ę́','����')) ��������,
count(distinct case when t1.origin_country_id=0 then replace(replace(replace(t1.origincity_name,'ǭ��','����'),'��¡','����'),'ę́','����')
else null end ) ���ڳ�������,
count(distinct case when t1.origin_country_id in(198,199,200) then replace(replace(replace(t1.origincity_name,'ǭ��','����'),'��¡','����'),'ę́','����')
else null end ) �����������,
count(distinct case when t1.origin_country_id>0 and t1.origin_country_id not in(198,199,200) then replace(replace(replace(t1.origincity_name,'ǭ��','����'),'��¡','����'),'ę́','����')
else null end ) ���ʳ�������
 from dw.da_flight t1
 join dw.dim_segment_type t2 on t1.h_route_id=t2.h_route_id and t1.route_id=t2.route_id
 where t1.flight_date>=trunc(sysdate)
 and t1.flag=0
 and t1.company_id=0
 and t1.flight_date>=to_date('20210328','yyyymmdd')
 and t1.flight_date<=to_date('20210403','yyyymmdd')
