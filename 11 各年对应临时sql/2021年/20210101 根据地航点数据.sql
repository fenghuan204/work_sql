---�Ϻ���ʯ��ׯ�����������������ݡ����������ݡ����ڡ����ݡ��ϲ�

select 'ȫ��' base,
count(distinct replace(replace(replace(replace(t2.wf_segment,'�ֶ�','�Ϻ�'),'����','�Ϻ�'),'ǭ��','����'),'ę́','����')) ������������,
          count(distinct case when t1.dest_country_id=0 and t1.destcity_name not like '%�Ϻ�%' then 
          replace(replace(replace(replace(t1.destcity_name,'�ֶ�','�Ϻ�'),'����','�Ϻ�'),'ǭ��','����'),'ę́','����')
          else null end) ����Ŀ�ĵ���,
          count(distinct case when t1.dest_country_id>0 then 
          replace(replace(replace(replace(t1.destcity_name,'�ֶ�','�Ϻ�'),'����','�Ϻ�'),'ǭ��','����'),'ę́','����')
          else null end) ����Ŀ�ĵ���,
          round(sum(t1.layout)/(to_date('2021-11-22','yyyy-mm-dd')-  to_date('2021-03-28','yyyy-mm-dd')+1),0) ������          
 from dw.da_flight t1
 join dw.dim_segment_type t2 on t1.h_route_id=t2.h_route_id and t1.route_id=t2.route_id
 where t1.flight_date>=to_date('2021-03-28','yyyy-mm-dd')
 and t1.flight_date<= to_date('2021-11-21','yyyy-mm-dd')
   and t1.company_id=0
   and t1.flag<>2

union all 


select '�Ϻ�' base,
count(distinct replace(replace(replace(replace(t2.wf_segment,'�ֶ�','�Ϻ�'),'����','�Ϻ�'),'ǭ��','����'),'ę́','����')) ������������,
          count(distinct case when t1.dest_country_id=0 and t1.destcity_name not like '%�Ϻ�%' then 
          replace(replace(replace(replace(t1.destcity_name,'�ֶ�','�Ϻ�'),'����','�Ϻ�'),'ǭ��','����'),'ę́','����')
          else null end) ����Ŀ�ĵ���,
          count(distinct case when t1.dest_country_id>0 then 
          replace(replace(replace(replace(t1.destcity_name,'�ֶ�','�Ϻ�'),'����','�Ϻ�'),'ǭ��','����'),'ę́','����')
          else null end) ����Ŀ�ĵ���,
          round(sum(t1.layout)/(to_date('2021-11-21','yyyy-mm-dd')-  to_date('2021-03-28','yyyy-mm-dd')+1),0) ������          
 from dw.da_flight t1
 join dw.dim_segment_type t2 on t1.h_route_id=t2.h_route_id and t1.route_id=t2.route_id
 where t1.flight_date>=to_date('2021-03-28','yyyy-mm-dd')
 and t1.flight_date<= to_date('2021-11-21','yyyy-mm-dd')
   and t1.company_id=0
   and t1.flag<>2
   and t1.flights_city_name like '%�Ϻ�%'
   
   union all
   

select 'ʯ��ׯ',count(distinct replace(replace(replace(replace(t2.wf_segment,'�ֶ�','�Ϻ�'),'����','�Ϻ�'),'ǭ��','����'),'ę́','����')),
          count(distinct case when t1.dest_country_id=0 and t1.destcity_name not like '%ʯ��ׯ%' then 
          replace(replace(replace(replace(t1.destcity_name,'�ֶ�','�Ϻ�'),'����','�Ϻ�'),'ǭ��','����'),'ę́','����')
          else null end),
          count(distinct case when t1.dest_country_id>0 then 
          replace(replace(replace(replace(t1.destcity_name,'�ֶ�','�Ϻ�'),'����','�Ϻ�'),'ǭ��','����'),'ę́','����')
          else null end),
          sum(t1.layout)/(to_date('2021-11-21','yyyy-mm-dd')-  to_date('2021-03-28','yyyy-mm-dd')+1)                     
 from dw.da_flight t1
 join dw.dim_segment_type t2 on t1.h_route_id=t2.h_route_id and t1.route_id=t2.route_id
 where t1.flight_date>=to_date('2021-03-28','yyyy-mm-dd')
 and t1.flight_date<= to_date('2021-11-21','yyyy-mm-dd')
   and t1.company_id=0
   and t1.flag<>2
   and t1.flights_city_name like '%ʯ��ׯ%'
   
   union all
   
 select '����',count(distinct replace(replace(replace(replace(t2.wf_segment,'�ֶ�','�Ϻ�'),'����','�Ϻ�'),'ǭ��','����'),'ę́','����')),
          count(distinct case when t1.dest_country_id=0 and t1.destcity_name not like '%����%' then 
          replace(replace(replace(replace(t1.destcity_name,'�ֶ�','�Ϻ�'),'����','�Ϻ�'),'ǭ��','����'),'ę́','����')
          else null end),
          count(distinct case when t1.dest_country_id>0 then 
          replace(replace(replace(replace(t1.destcity_name,'�ֶ�','�Ϻ�'),'����','�Ϻ�'),'ǭ��','����'),'ę́','����')
          else null end),
          round(sum(t1.layout)/(to_date('2021-11-21','yyyy-mm-dd')-  to_date('2021-03-28','yyyy-mm-dd')+1),0) daysale                    
 from dw.da_flight t1
 join dw.dim_segment_type t2 on t1.h_route_id=t2.h_route_id and t1.route_id=t2.route_id
 where t1.flight_date>=to_date('2021-03-28','yyyy-mm-dd')
 and t1.flight_date<=to_date('2021-11-21','yyyy-mm-dd')
   and t1.company_id=0
   and t1.flag<>2
   and t1.flights_city_name like '%����%'
   
   union all
   
 select '����',count(distinct replace(replace(replace(replace(t2.wf_segment,'�ֶ�','�Ϻ�'),'����','�Ϻ�'),'ǭ��','����'),'ę́','����')),
          count(distinct case when t1.dest_country_id=0 and t1.destcity_name not like '%����%' then 
          replace(replace(replace(replace(t1.destcity_name,'�ֶ�','�Ϻ�'),'����','�Ϻ�'),'ǭ��','����'),'ę́','����')
          else null end),
          count(distinct case when t1.dest_country_id>0 then 
          replace(replace(replace(replace(t1.destcity_name,'�ֶ�','�Ϻ�'),'����','�Ϻ�'),'ǭ��','����'),'ę́','����')
          else null end),
          round(sum(t1.layout)/(to_date('2021-11-21','yyyy-mm-dd')-  to_date('2021-03-28','yyyy-mm-dd')+1),0)                     
 from dw.da_flight t1
 join dw.dim_segment_type t2 on t1.h_route_id=t2.h_route_id and t1.route_id=t2.route_id
 where t1.flight_date>=to_date('2021-03-28','yyyy-mm-dd')
 and t1.flight_date<=to_date('2021-11-21','yyyy-mm-dd')
   and t1.company_id=0
   and t1.flag<>2
   and t1.flights_city_name like '%����%'
   
   
      union all
   
 select '����',count(distinct replace(replace(replace(replace(t2.wf_segment,'�ֶ�','�Ϻ�'),'����','�Ϻ�'),'ǭ��','����'),'ę́','����')),
          count(distinct case when t1.dest_country_id=0 and t1.destcity_name not like '%����%' then 
          replace(replace(replace(replace(t1.destcity_name,'�ֶ�','�Ϻ�'),'����','�Ϻ�'),'ǭ��','����'),'ę́','����')
          else null end),
          count(distinct case when t1.dest_country_id>0 then 
          replace(replace(replace(replace(t1.destcity_name,'�ֶ�','�Ϻ�'),'����','�Ϻ�'),'ǭ��','����'),'ę́','����')
          else null end),
          round(sum(t1.layout)/(to_date('2021-11-21','yyyy-mm-dd')-  to_date('2021-03-28','yyyy-mm-dd')+1),0)                     
 from dw.da_flight t1
 join dw.dim_segment_type t2 on t1.h_route_id=t2.h_route_id and t1.route_id=t2.route_id
 where t1.flight_date>=to_date('2021-03-28','yyyy-mm-dd')
 and t1.flight_date<= to_date('2021-11-21','yyyy-mm-dd')
   and t1.company_id=0
   and t1.flag<>2
   and t1.flights_city_name like '%����%'
   
         union all
   
 select '����',count(distinct replace(replace(replace(replace(t2.wf_segment,'�ֶ�','�Ϻ�'),'����','�Ϻ�'),'ǭ��','����'),'ę́','����')),
          count(distinct case when t1.dest_country_id=0 and t1.destcity_name not like '%����%' then 
          replace(replace(replace(replace(t1.destcity_name,'�ֶ�','�Ϻ�'),'����','�Ϻ�'),'ǭ��','����'),'ę́','����')
          else null end),
          count(distinct case when t1.dest_country_id>0 then 
          replace(replace(replace(replace(t1.destcity_name,'�ֶ�','�Ϻ�'),'����','�Ϻ�'),'ǭ��','����'),'ę́','����')
          else null end),
          round(sum(t1.layout)/(to_date('2021-11-21','yyyy-mm-dd')-  to_date('2021-03-28','yyyy-mm-dd')+1),0)                   
 from dw.da_flight t1
 join dw.dim_segment_type t2 on t1.h_route_id=t2.h_route_id and t1.route_id=t2.route_id
 where t1.flight_date>=to_date('2021-03-28','yyyy-mm-dd')
 and t1.flight_date<= to_date('2021-11-21','yyyy-mm-dd')
   and t1.company_id=0
   and t1.flag<>2
   and t1.flights_city_name like '%����%'
   
   
   union all
   
--���� ���� Ϋ�� ���� ����̩�� ���� ���� ����  ����  ��ʲ ��������
   
 select '����',count(distinct replace(replace(replace(replace(t2.wf_segment,'�ֶ�','�Ϻ�'),'����','�Ϻ�'),'ǭ��','����'),'ę́','����')),
          count(distinct case when t1.dest_country_id=0 and t1.destcity_name not like '%����%' then 
          replace(replace(replace(replace(t1.destcity_name,'�ֶ�','�Ϻ�'),'����','�Ϻ�'),'ǭ��','����'),'ę́','����')
          else null end),
          count(distinct case when t1.dest_country_id>0 then 
          replace(replace(replace(replace(t1.destcity_name,'�ֶ�','�Ϻ�'),'����','�Ϻ�'),'ǭ��','����'),'ę́','����')
          else null end),
          round(sum(t1.layout)/(to_date('2021-11-21','yyyy-mm-dd')-  to_date('2021-03-28','yyyy-mm-dd')+1),0)                    
 from dw.da_flight t1
 join dw.dim_segment_type t2 on t1.h_route_id=t2.h_route_id and t1.route_id=t2.route_id
 where t1.flight_date>=to_date('2021-03-28','yyyy-mm-dd')
 and t1.flight_date<= to_date('2021-11-21','yyyy-mm-dd')
   and t1.company_id=0
   and t1.flag<>2
   and t1.flights_city_name like '%����%'
   
   
     union all
   
--���� ���� Ϋ�� ���� ����̩�� ���� ���� ����  ����  ��ʲ ��������
   
 select '����',count(distinct replace(replace(replace(replace(t2.wf_segment,'�ֶ�','�Ϻ�'),'����','�Ϻ�'),'ǭ��','����'),'ę́','����')),
          count(distinct case when t1.dest_country_id=0 and t1.destcity_name not like '%����%' then 
          replace(replace(replace(replace(t1.destcity_name,'�ֶ�','�Ϻ�'),'����','�Ϻ�'),'ǭ��','����'),'ę́','����')
          else null end),
          count(distinct case when t1.dest_country_id>0 then 
          replace(replace(replace(replace(t1.destcity_name,'�ֶ�','�Ϻ�'),'����','�Ϻ�'),'ǭ��','����'),'ę́','����')
          else null end),
          round(sum(t1.layout)/(to_date('2021-11-21','yyyy-mm-dd')-  to_date('2021-03-28','yyyy-mm-dd')+1),0)                   
 from dw.da_flight t1
 join dw.dim_segment_type t2 on t1.h_route_id=t2.h_route_id and t1.route_id=t2.route_id
 where t1.flight_date>=to_date('2021-03-28','yyyy-mm-dd')
 and t1.flight_date<= to_date('2021-11-21','yyyy-mm-dd')
   and t1.company_id=0
   and t1.flag<>2
   and t1.flights_city_name like '%����%'
   
   
      union all
   
--���� ���� Ϋ�� ���� ����̩�� ���� ���� ����  ����  ��ʲ ��������
   
 select '����',count(distinct replace(replace(replace(replace(t2.wf_segment,'�ֶ�','�Ϻ�'),'����','�Ϻ�'),'ǭ��','����'),'ę́','����')),
          count(distinct case when t1.dest_country_id=0 and t1.destcity_name not like '%����%' then 
          replace(replace(replace(replace(t1.destcity_name,'�ֶ�','�Ϻ�'),'����','�Ϻ�'),'ǭ��','����'),'ę́','����')
          else null end),
          count(distinct case when t1.dest_country_id>0 then 
          replace(replace(replace(replace(t1.destcity_name,'�ֶ�','�Ϻ�'),'����','�Ϻ�'),'ǭ��','����'),'ę́','����')
          else null end),
          round(sum(t1.layout)/(to_date('2021-11-21','yyyy-mm-dd')-  to_date('2021-03-28','yyyy-mm-dd')+1),0)                    
 from dw.da_flight t1
 join dw.dim_segment_type t2 on t1.h_route_id=t2.h_route_id and t1.route_id=t2.route_id
 where t1.flight_date>=to_date('2021-03-28','yyyy-mm-dd')
 and t1.flight_date<= to_date('2021-11-21','yyyy-mm-dd')
   and t1.company_id=0
   and t1.flag<>2
   and t1.flights_city_name like '%����%'
   
   
   union 
   
   
   select '�ϲ�',count(distinct replace(replace(replace(replace(t2.wf_segment,'�ֶ�','�Ϻ�'),'����','�Ϻ�'),'ǭ��','����'),'ę́','����')),
          count(distinct case when t1.dest_country_id=0 and t1.destcity_name not like '%����%' then 
          replace(replace(replace(replace(t1.destcity_name,'�ֶ�','�Ϻ�'),'����','�Ϻ�'),'ǭ��','����'),'ę́','����')
          else null end),
          count(distinct case when t1.dest_country_id>0 then 
          replace(replace(replace(replace(t1.destcity_name,'�ֶ�','�Ϻ�'),'����','�Ϻ�'),'ǭ��','����'),'ę́','����')
          else null end),
          round(sum(t1.layout)/(to_date('2021-11-21','yyyy-mm-dd')-  to_date('2021-03-28','yyyy-mm-dd')+1),0)                    
 from dw.da_flight t1
 join dw.dim_segment_type t2 on t1.h_route_id=t2.h_route_id and t1.route_id=t2.route_id
 where t1.flight_date>=to_date('2021-03-28','yyyy-mm-dd')
 and t1.flight_date<= to_date('2021-11-21','yyyy-mm-dd')
   and t1.company_id=0
   and t1.flag<>2
   and t1.flights_city_name like '%�ϲ�%'
   
      
