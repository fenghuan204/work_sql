select t1.r_flights_date ��������,t1.whole_flight �����,t1.whole_segment ����,
sum(case when t1.sex=1 then 1 else 0 end) ������,suM(case when t1.sex=2 then 1 else 0 end) ��ͯ��,
sum( case when t1.sex=3 then 1 else 0 end) Ӥ����
from cqsale.cq_order@to_air t
join cqsale.cq_order_head@to_air t1 on t.flights_order_id=t1.flights_order_id
where t1.whole_flight ='9C8855'
and t1.r_flights_date=trunc(sysdate)
and t1.flag_id in(3,5,40,41)
group by t1.r_flights_date,t1.whole_flight,t1.whole_segment;



select t.order_date ��������,t.order_linkman ��Ʊ��ϵ��,t.work_tel ��Ʊ��ϵ��ʽ, t.email ��Ʊ������,
c.channel ��������,c.terminal �ն�,CASE WHEN t.terminal_id<=0 and t.web_id=0 and t5.users_id is  not null then '�ڴ�'
else '�Ǻڴ�' end �Ƿ�ڴ�,
t1.r_flights_date ��������,t1.whole_flight �����,t1.whole_segment ����,
t1.name||coalesce(t1.second_name,'') �ÿ����� ,t1.codetype ֤������,t1.codeno ֤����,
decode(t1.sex,1,'����',2,'��ͯ',3,'Ӥ��') �˻�������,getage(t1.r_flights_date,t1.birthday) ����,
   CASE WHEN t3.nationality='CHN' THEN '�й�'
          WHEN t3.nationality IS NULL THEN '�й�'
          ELSE t6.country_name END ����,
     CASE WHEN (CASE WHEN t3.nationality='CHN' THEN '�й�'
          WHEN t3.nationality IS NULL THEN '�й�'
          ELSE t6.country_name END) like '%�й�%' THEN      
          CASE WHEN t.terminal_id<=0 and t.web_id=0 and t5.users_id is  not null 
          and tt1.province is not null then tt1.province
          when  t8.province IS NOT NULL THEN t8.province
               WHEN t8.province IS NULL AND tt1.province IS NOT NULL THEN tt1.province
               ELSE NULL END 
          ELSE NULL END ʡ��,
      CASE WHEN ((CASE WHEN t3.nationality='CHN' THEN '�й�'
          WHEN t3.nationality IS NULL THEN '�й�'
          ELSE t6.country_name END)) like '%�й�%' THEN 
      CASE WHEN t.terminal_id<=0 and t.web_id=0 and t5.users_id is  not null 
          and tt1.province is not null then tt1.city
           WHEN t8.province IS NOT NULL THEN t8.city
               WHEN t8.province IS NULL AND tt1.province IS NOT NULL THEN tt1.city
               ELSE NULL END 
          ELSE NULL END ����
from cqsale.cq_order@to_air t
join cqsale.cq_order_head@to_air t1 on t.flights_order_id=t1.flights_order_id
left join dw.da_restrict_userinfo t5 on t.client_id=t5.users_id
left join dw.adt_mobile_list t8 on regexp_like(t1.r_tel, '^1[0-9]{10}$')
                          and substr(t1.r_tel, 1, 7) = t8.mobilenumber
left join dw.adt_region_code tt1 on t1.codetype = 1
                        and tt1.regioncode=substr(t1.codeno, 1, 6)
   left join stg.s_cq_traveller_info t3 on t1.flights_order_head_id=t3.flights_order_head_id
   left join stg.s_cq_country_area t6 on t3.nationality=t6.country_code  
    left join dw.da_channel_part c on c.terminal_id = t.terminal_id
                                and c.web_id = nvl(t.web_id, 0)
                                and c.station_id =
                                    (case when t.terminal_id < 0 and
                                     nvl(t.ex_nfd1, 0) <= 1 then 1 else
                                     nvl(t.ex_nfd1, 0) end)
                                and t.order_date >= c.sdate
                                and t.order_date < c.edate + 1
where t1.whole_flight ='9C8855'
and t1.r_flights_date=trunc(sysdate)
and t1.flag_id in(3,5,40,41);
