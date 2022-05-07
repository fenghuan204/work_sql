select *
from(
select flight_date ��������,
       flight_no �����,
       route_name ����,
       limit_num ʣ��ɶһ���,
       sum(tktnum) �һ���,
       sum(tktnum2) "��Ʊ2.0�һ���",
       sum(tktnum1) "��Ʊ1.0�һ���",
       limit_num + sum(tktnum) ���޶�
  from (select t2.flight_date,
               t2.flight_no,
               t2.route_name,
               nvl(l.limit_num, 20) limit_num,
               nvl(t.tktnum, 0) tktnum,
               nvl(t.tktnum2, 0) tktnum2,
               nvl(t.tktnum1, 0) tktnum1
          from dw.da_flight t2
          left join stg.y_cq_new_yhq_flights_limit l on l.segment_head_id =
                                                             t2.segment_head_id
          left join (select segment_head_id,
                           count(1) tktnum,
                           sum(case
                                 when combo_vision = '��Ʊ2.0' then
                                  1
                                 else
                                  0
                               end) tktnum2,
                           sum(case
                                 when combo_vision = '��Ʊ1.0' then
                                  1
                                 else
                                  0
                               end) tktnum1
                      from dw.fact_combo_ticket
                     where payflag = 1
                     group by segment_head_id) t on t.segment_head_id =
                                                    t2.segment_head_id
          left join hdb.cq_airport ap3 on ap3.threecodeforcity =
                                          t2.originairport
          left join hdb.cq_airport ap4 on ap4.threecodeforcity =
                                          t2.destairport
         where t2.flag = 0
           and t2.company_id = 0
           and t2.flight_date >=trunc(sysdate)
           and t2.nationflag <> '����'
           and t2.oversale - t2.bgo_plan > 0)
group by flight_date, flight_no, route_name, limit_num)hh1
where hh1.�һ���>=25
