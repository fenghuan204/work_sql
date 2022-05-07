select tb1.*,tb2.��վ_UV,tB2.΢��_UV,TB2.Mվ_UV,TB3.MAU APPUV
from(
select h1.*,h2.num2 ʵ�����м���,h2.flight_count �ɻ�����
from(
select to_char(t1.flight_date,'yyyymm')  months,count(distinct t1.segment_code)  ������
  from dw.da_flight t1
  where t1.flight_date>=to_date('2021-07-01','yyyy-mm-dd')
    and t1.flight_date< add_months(last_day(trunc(sysdate)),-1)+1
    and t1.flag<>2
    and t1.company_id=0
    group by to_char(t1.flight_date,'yyyymm'))h1
   left join(  
select  to_char(t1.date_time,'yyyymm') months,avg(run_airplane_count) num2,max(t1.flight_count) flight_count
 from stg.f_day_statistics t1
 where t1.date_time>=to_date('2021-07-01','yyyy-mm-dd')
   and t1.date_time< add_months(last_day(trunc(sysdate)),-1)+1
   group by to_char(t1.date_time,'yyyymm'))h2  on h1.months=h2.months)tb1
   left join (select * from 
   (select visit_month,channel,sum(active_user) UV
     from dw.bi_traffic_month_kpi
     where lang='/'
     and visit_month>='202107'
     group by visit_month,channel)h1
     pivot(sum(UV) for channel in('iOS' IOS_UV,'Mվ' Mվ_UV,'��վ' ��վ_UV,'΢��' ΢��_UV,'Android' Android_UV))
     )tb2  on tb1.months=tb2.visit_month
     left join(select to_number(replace(visit_month,'-','')) ym,sum(new_uv) active,sum(UV) mau
from dw.cj_month_trmnl@TO_ODS
      where lang='/'
      and to_number(replace(visit_month,'-',''))>='202107'
        and trmnl_tp in ('Android','IOS')
group by to_number(replace(visit_month,'-','')))tb3 on tb1.months=tb3.ym
order by 1
