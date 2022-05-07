
-----查找“辅收数据整理”


select flightmonth,sname,sum(h2.book_num),sum(h2.book_fee)
from(
select t1.flights_date,t1.nationflag,
       
       case
         when t1.xtype_name in ('境外险', '延误险', '取消险', '航意险') then
          t1.xtype_name
         when t1.xtype_id in (6, 10, 17) then
          '线上行李'       
         when t1.xtype_id = 21 and
              regexp_like(upper(t1.xproduct_name),
                          '(WIFI)|(WF)|(4G)|(上网卡)') then
          'WIFI'
         when t1.xtype_id = 21 and t1.xproduct_name like '%泊车%' then
          '泊车'
         when t1.xtype_id = 16 then
          '接送机'
         when t1.xtype_id = 14 and t1.xproduct_name = '大巴票' then
          '空巴联运'
         when t1.xtype_id = 14 and t1.xproduct_name = '火车票' then
          '空铁联运'
         when t1.xtype_id = 16 then
          '接送机'
         when t1.xtype_id = 24  then
          '地面行李'
         when t1.xtype_id = 25  then
          '地面选座'
          when t1.xtype_id = 7  then
          '线上餐食'
           else
          t1.xtype_name
       end sname,sum(t1.book_num) booknum,sum(t1.book_fee) bookfee
  from dw.fact_other_order_detail t1
 where t1.flights_date >= to_date('2018-01-01', 'yyyy-mm-dd')
   and t1.flights_date < to_date('2018-09-01', 'yyyy-mm-dd')
   and t1.company_id = 0
   and t1.xtype_id not in(24,25)
   and t1.flag_id in (3, 5, 40, 41)
   group by t1.flights_date,
       case
         when t1.xtype_name in ('境外险', '延误险', '取消险', '航意险') then
          t1.xtype_name
         when t1.xtype_id in (6, 10, 17) then
          '线上行李'       
         when t1.xtype_id = 21 and
              regexp_like(upper(t1.xproduct_name),
                          '(WIFI)|(WF)|(4G)|(上网卡)') then
          'WIFI'
         when t1.xtype_id = 21 and t1.xproduct_name like '%泊车%' then
          '泊车'
         when t1.xtype_id = 16 then
          '接送机'
         when t1.xtype_id = 14 and t1.xproduct_name = '大巴票' then
          '空巴联运'
         when t1.xtype_id = 14 and t1.xproduct_name = '火车票' then
          '空铁联运'
         when t1.xtype_id = 16 then
          '接送机'
         when t1.xtype_id = 24  then
          '地面行李'
         when t1.xtype_id = 25  then
          '地面选座'
          when t1.xtype_id = 7  then
          '线上餐食'
           else
          t1.xtype_name
       end
   
   
   
   union all
   
   select to_char(t2.r_flights_date,'yyyymm') flightmonth,
   t2.flights_order_id,t2.valid_code,'团队餐',
               t1.dinner_num booknum,
               t1.dinner_price * t1.dinner_num bookfee           
          from stg.s_cq_group_dinner_detail t1
          join stg.s_cq_order_head t2 on t1.order_head_id =t2.flights_order_head_id
         where t2.flag_id in (3, 5, 40, 41)
           and t2.whole_flight like '9C%'
           and t2.r_flights_date>=to_date('2018-01-01', 'yyyy-mm-dd')
           and t2.r_flights_date< to_date('2018-09-01', 'yyyy-mm-dd')
           
   
   union all
   
   
   select to_char(h1.flights_date,'yyyymm') flightmonth,
    h1.dcs_rl,h1.DCS_RI,'地面选座',1,h1.af_v
   from stg.s_cq_dcs_money_h h1
   where h1.flights_date>=to_date('2018-01-01', 'yyyy-mm-dd')
     and h1.flights_date< to_date('2018-09-01', 'yyyy-mm-dd')
     and h1.AF_V>0
     
     union all 
     
     select to_char(h1.flights_date,'yyyymm') flightmonth,h1.dcs_rl,h1.DCS_RI,'地面行李',1,h1.AF_B+h1.Af_F
   from stg.s_cq_dcs_money_h h1
   where h1.flights_date>=to_date('2018-01-01', 'yyyy-mm-dd')
     and h1.flights_date< to_date('2018-09-01', 'yyyy-mm-dd')
     and h1.AF_B+h1.Af_F>0
     
     union all 
     
      select to_char(h1.flights_date,'yyyymm') flightmonth,h1.dcs_rl,h1.DCS_RI,'地面选座',1,h1.AF_B+h1.Af_F
   from stg.s_cq_dcs_money_h h1
   where h1.flights_date>=to_date('2018-01-01', 'yyyy-mm-dd')
     and h1.flights_date< to_date('2018-09-01', 'yyyy-mm-dd')
     and h1.Af_E>0)h2
     group by flightmonth,sname
     
     union all
     
     select to_char(to_date(t1.flight_date,'yyyymmdd'),'yyyymm'),
case when t1.type_name in('餐食','饮料','小吃') then '机上餐食'
when t1.type_name ='机上纪念品' then '机上纪念品'
else '其他机供品' end,sum(t1.booknum),sum(t1.booknum)
from dw.fact_prt_order_detail t1
where t1.TERMINAL_TYPE=4
and t1.FLIGHT_DATE>='20180101'
and t1.flight_date< '20180901'
and t1.flight_no like '9C%'
group by to_char(to_date(t1.flight_date,'yyyymmdd'),'yyyymm'),
case when t1.type_name in('餐食','饮料','小吃') then '机上餐食'
when t1.type_name ='机上纪念品' then '机上纪念品'
else '其他机供品' end
     
     



