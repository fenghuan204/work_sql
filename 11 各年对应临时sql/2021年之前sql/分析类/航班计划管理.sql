select *
  from cqsale.CQ_FLIGHTS_CHANGE_HISTORY@to_air;
  
   select flights_no,count(1)
   from(
        select t1.flights_plan_id,
               t1.flights_no,
               t1.ac_reg,
               t1.ac_type || '(' || t2.LAYOUT_NAME || ')' ac_type,
               to_char(t1.flights_begint_date, 'yyyy-mm-dd') flights_begint_date,
               to_char(t1.flights_end_date, 'yyyy-mm-dd') flights_end_date,
               to_char(t1.flights_begint_date, 'yyyymm') bm,
               to_char(t1.flights_end_date, 'yyyymm') em,
               t1.flights_property,
               t1.flights_plan_flag,
               t1.plan_memo,
               t1.AC_TYPE type_name,
               t1.layout_id
          from cqsale.cq_flights_plan@to_air t1, cqsale.CQ_LAYOUT_TYPE@to_air t2
         where t1.company_id = 0
           and not regexp_like(substr(t1.flights_no,length(t1.flights_no),1),'[A-Z]')
           and t1.status = -1
           and t1.flights_no='9C8646'
           and t1.layout_id = t2.id
           and t1.flights_begint_date >=
               TO_DATE('2018-03-25' || ' 00:00:00', 'yyyy-mm-dd hh24:mi:ss')
           and t1.flights_begint_date <=
               TO_DATE('2018-10-27' || ' 23:59:59', 'yyyy-mm-dd hh24:mi:ss')
           and t1.flights_end_date >=
               TO_DATE('2018-03-25' || ' 00:00:00', 'yyyy-mm-dd hh24:mi:ss')
           and t1.flights_end_date <=
               TO_DATE('2018-10-27' || ' 23:59:59', 'yyyy-mm-dd hh24:mi:ss')
         order by t1.flights_plan_id)
         group by flights_no
         having count(1)>1;
         
         select * from cqsale.cq_flights_plan@to_air
         where flights_no='9C8646';
         
         
       
select *
from dw.da_flight h1
left join (
        select 2018 Äê,t1.flights_no,
               min(t1.flights_begint_date) flights_begint_date,
               max(t1.flights_end_date) flights_end_date,
               min(trunc(FLIGHTS_PLAN_DATE)) FLIGHTS_PLAN_DATE
          from cqsale.cq_flights_plan@to_air t1,
               cqsale.CQ_LAYOUT_TYPE@to_air  t2
         where t1.company_id = 0
           and not
                regexp_like(substr(t1.flights_no, length(t1.flights_no), 1),
                            '[A-Z]')
           and t1.status = -1
           and t1.layout_id = t2.id
           and t1.flights_begint_date >=
               TO_DATE('2018-03-25' || ' 00:00:00', 'yyyy-mm-dd hh24:mi:ss')
           and t1.flights_begint_date <=
               TO_DATE('2018-10-27' || ' 23:59:59', 'yyyy-mm-dd hh24:mi:ss')
           and t1.flights_end_date >=
               TO_DATE('2018-03-25' || ' 00:00:00', 'yyyy-mm-dd hh24:mi:ss')
           and t1.flights_end_date <=
               TO_DATE('2018-10-27' || ' 23:59:59', 'yyyy-mm-dd hh24:mi:ss')
         group by t1.flights_no
         
         
         union all
         
         select 2019 Äê,t1.flights_no,
                min(t1.flights_begint_date) flights_begint_date,
                max(t1.flights_end_date) flights_end_date,
                min(trunc(FLIGHTS_PLAN_DATE)) FLIGHTS_PLAN_DATE
           from cqsale.cq_flights_plan@to_air t1,
                cqsale.CQ_LAYOUT_TYPE@to_air  t2
          where t1.company_id = 0
            and not
                 regexp_like(substr(t1.flights_no, length(t1.flights_no), 1),
                             '[A-Z]')
            and t1.status = -1
            and t1.layout_id = t2.id
            and t1.flights_begint_date >=
                TO_DATE('2019-03-31' || ' 00:00:00',
                        'yyyy-mm-dd hh24:mi:ss')
            and t1.flights_begint_date <=
                TO_DATE('2019-10-26' || ' 23:59:59',
                        'yyyy-mm-dd hh24:mi:ss')
            and t1.flights_end_date >=
                TO_DATE('2019-03-31' || ' 00:00:00',
                        'yyyy-mm-dd hh24:mi:ss')
            and t1.flights_end_date <=
                TO_DATE('2019-10-26' || ' 23:59:59',
                        'yyyy-mm-dd hh24:mi:ss')
          group by t1.flights_no)h2 on h1.flight_no=h2.flights_no and h1.flight_date>=h2.flights_begint_date and h1.flight_date<=flights_end_date
      
