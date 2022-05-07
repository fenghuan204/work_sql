select /*+parallel(4) */
'辅收',tb3.*,null
from(
select t1.flights_date,
       t1.nationflag,
       case when t1.is_swj>=1 then '商务经济座'
       when t1.EX_CFD3 is not null then '经济座'
       else '普通座' end, 
       case when t1.seats_name in('B','G','G1','G2') then 'BG'
       else '非BG' end bgtype,
       case when t1.channel in('网站','手机') and t2.users_id is not null then '代理'
       else '非代理' end channeltype,
           
             
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
       end sname,sum(t1.book_num) booknum,sum(t1.book_fee) bookfee,
       null
  from dw.fact_other_order_detail t1
  left join dw.da_restrict_userinfo t2 on t1.client_id=t2.users_id
 where t1.flights_date >= to_date('2018-02-01', 'yyyy-mm-dd')
   and t1.flights_date < =to_date('2019-03-01', 'yyyy-mm-dd')
   and ((t1.flights_date>=to_date('2018-02-01', 'yyyy-mm-dd')
   and t1.flights_date <=to_date('2018-03-12', 'yyyy-mm-dd'))
   or (t1.flights_date>=to_date('2018-12-12', 'yyyy-mm-dd')
   and t1.flights_date <=to_date('2019-03-01', 'yyyy-mm-dd')))
   and t1.company_id = 0
   and t1.xtype_id not in(24,25)
   and t1.flag_id in (3, 5, 40, 41)
   group by t1.flights_date,
       t1.nationflag,
       case when t1.is_swj>=1 then '商务经济座'
       when t1.EX_CFD3 is not null then '经济座'
       else '普通座' end,
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
       end,case when t1.seats_name in('B','G','G1','G2') then 'BG'
       else '非BG' end ,
       case when t1.channel in('网站','手机') and t2.users_id is not null then '代理'
       else '非代理' end
   
   
   
   union all
   
   select  t3.flights_date,
       t3.nationflag,
       case when t3.is_swj>=1 then '商务经济座'
       when t3.EX_CFD6 is not null then '经济座'
       else '普通座' end,
      'BG',
       '非代理' , 
       
       
       '团队餐' type,
       sum(t1.dinner_num) booknum,
               sum(t1.dinner_price * t1.dinner_num) bookfee,
               null          
          from stg.s_cq_group_dinner_detail t1
          join stg.s_cq_order_head t2 on t1.order_head_id =t2.flights_order_head_id
          join dw.fact_order_detail t3 on t2.flights_order_Head_id=t3.flights_order_head_id
         where t2.flag_id in (3, 5, 40, 41)
           and t2.whole_flight like '9C%'
          and  t3.flights_date >= to_date('2018-02-01', 'yyyy-mm-dd')
   and t3.flights_date < =to_date('2019-03-01', 'yyyy-mm-dd')
   and ((t3.flights_date>=to_date('2018-02-01', 'yyyy-mm-dd')
   and t3.flights_date <=to_date('2018-03-12', 'yyyy-mm-dd'))
   or (t3.flights_date>=to_date('2018-12-12', 'yyyy-mm-dd')
   and t3.flights_date <=to_date('2019-03-01', 'yyyy-mm-dd')))
   group by t3.flights_date,
       t3.nationflag,
       case when t3.is_swj>=1 then '商务经济座'
       when t3.EX_CFD6 is not null then '经济座'
       else '普通座' end
           


   
   union all
   
   
   select tb2.flights_date,tb2.nationflag,tb2.tickettype,tb2.bgtype,tb2.channeltype,
   
   tb2.type,sum(tb2.booknum),sum(tb2.bookfee),null
   from(
   select tb1.flights_date,tb1.nationflag,tb1.tickettype,tb1.type,tb1.booknum,tb1.bookfee,tb1.bgtype,tb1.channeltype,
   row_number()over(partition by tb1.flights_date,tb1.nationflag,tb1.tickettype,tb1.type order by tb1.flights_date) xid  

   from(   
  select h2.flights_Order_head_id,h2.segment_head_id,
  h2.flights_date,
       h2.nationflag,
       case when h2.is_swj>=1 then '商务经济座'
       when h2.EX_CFD6 is not null then '经济座'
       else '普通座' end tickettype,
       case when h2.seats_name in('B','G','G1','G2') then 'BG'
       else '非BG' end bgtype,
       '非代理' channeltype,
       
       '地面选座' type,1 booknum,h1.af_e bookfee
   from stg.s_cq_dcs_money_h h1
  join dw.fact_order_detail h2 on h1.dcs_rl=h2.flights_order_id and h1.dcs_ri=h2.valid_code
  left join dw.da_restrict_userinfo h3 on h2.client_id=h3.users_id
   where  h2.flights_date >= to_date('2018-02-01', 'yyyy-mm-dd')
   and h2.flights_date < =to_date('2019-03-01', 'yyyy-mm-dd')
   and ((h2.flights_date>=to_date('2018-02-01', 'yyyy-mm-dd')
   and h2.flights_date <=to_date('2018-03-12', 'yyyy-mm-dd'))
   or (h2.flights_date>=to_date('2018-12-12', 'yyyy-mm-dd')
   and h2.flights_date <=to_date('2019-03-01', 'yyyy-mm-dd')))
     and h1.Af_E>0
     and h1.DCS_TYPE=0
     
     union all
     
     select h2.flights_Order_head_id,h2.segment_head_id,
  h2.flights_date,
       h2.nationflag,
       case when h2.is_swj>=1 then '商务经济座'
       when h2.EX_CFD6 is not null then '经济座'
       else '普通座' end,
       case when h2.seats_name in('B','G','G1','G2') then 'BG'
       else '非BG' end bgtype,
       '非代理' channeltype,
       '快登机' type,1,h1.af_V
   from stg.s_cq_dcs_money_h h1
    join dw.fact_order_detail h2 on h1.dcs_rl=h2.flights_order_id and h1.dcs_ri=h2.valid_code
   where  h2.flights_date >= to_date('2018-02-01', 'yyyy-mm-dd')
   and h2.flights_date < =to_date('2019-03-01', 'yyyy-mm-dd')
   and ((h2.flights_date>=to_date('2018-02-01', 'yyyy-mm-dd')
   and h2.flights_date <=to_date('2018-03-12', 'yyyy-mm-dd'))
   or (h2.flights_date>=to_date('2018-12-12', 'yyyy-mm-dd')
   and h2.flights_date <=to_date('2019-03-01', 'yyyy-mm-dd')))
     and h1.AF_V>0
     and h1.DCS_TYPE=0)tb1)tb2
     where tb2.xid=1     
   group by tb2.flights_date,tb2.nationflag,tb2.tickettype,tb2.bgtype,tb2.channeltype,
   
   tb2.type
   
   
   union all
   
   select t2.flights_date,
       t2.nationflag,
       case when t2.is_swj>=1 then '商务经济座'
       when t2.EX_CFD3 is not null then '经济座'
       else '普通座' end, 
       case when t2.seats_name in('B','G','G1','G2') then 'BG'
       else '非BG' end bgtype,
       '非代理' channeltype,
       '地面行李',
       count(1) booknum,
       sum(t1.FEE_GT+t1.FEE_ZZ+t1.FEE_XC) bookfee,
       null
      
   from dw.fact_luggage_detail t1
   join dw.fact_order_detail t2 on t1.flights_order_head_id=t2.flights_order_head_id
   where t2.flights_date >= to_date('2018-02-01', 'yyyy-mm-dd')
   and t2.flights_date < =to_date('2019-03-01', 'yyyy-mm-dd')
   and ((t2.flights_date>=to_date('2018-02-01', 'yyyy-mm-dd')
   and t2.flights_date <=to_date('2018-03-12', 'yyyy-mm-dd'))
   or (t2.flights_date>=to_date('2018-12-12', 'yyyy-mm-dd')
   and t2.flights_date <=to_date('2019-03-01', 'yyyy-mm-dd')))
   and t1.FEE_GT+t1.FEE_ZZ+t1.FEE_XC>0
   group by t2.flights_date,
       t2.nationflag,
       case when t2.is_swj>=1 then '商务经济座'
       when t2.EX_CFD3 is not null then '经济座'
       else '普通座' end, 
       case when t2.seats_name in('B','G','G1','G2') then 'BG'
       else '非BG' end ,
       '非代理' ,
       '地面行李')tb3      
     
       
       
     
   union all   
   
   
   
 
   
   
   select '机票', t1.flights_date,
       t1.nationflag,
       case when t1.is_swj>=1 then '商务经济座'
       when t1.EX_CFD3 is not null then '经济座'
       else '普通座' end, 
       case when t1.seats_name in('B','G','G1','G2') then 'BG'
       else '非BG' end bgtype,
       case when t1.channel in('网站','手机') and t2.users_id is not null then '代理'
       else '非代理' end channeltype,
       null,0,0,count(1) ticketnum,sum(case when t1.ticket_price-nvl(t1.MIN_SEAT_PRICE*t1.RCD_RATE,t1.ticket_price)<0 then 0 else  t1.ticket_price-nvl(t1.MIN_SEAT_PRICE*t1.RCD_RATE,t1.ticket_price) end ) minprice   
  
  from dw.fact_order_detail t1
  left join dw.da_restrict_userinfo t2 on t1.client_id=t2.users_id
  left join dw.da_flight t3 on t1.segment_head_id=t3.segment_head_id
 where t1.flights_date >= to_date('2018-02-01', 'yyyy-mm-dd')
   and t1.flights_date < =to_date('2019-03-01', 'yyyy-mm-dd')
   and ((t1.flights_date>=to_date('2018-02-01', 'yyyy-mm-dd')
   and t1.flights_date <=to_date('2018-03-12', 'yyyy-mm-dd'))
   or (t1.flights_date>=to_date('2018-12-12', 'yyyy-mm-dd')
   and t1.flights_date <=to_date('2019-03-01', 'yyyy-mm-dd')))
   and t1.company_id = 0
   and t1.flag_id in (3, 5, 40, 41)
   and t1.seats_name is not null
   and t3.flag<>2
   group by t1.flights_date,
       t1.nationflag,
       case when t1.is_swj>=1 then '商务经济座'
       when t1.EX_CFD3 is not null then '经济座'
       else '普通座' end,
          case when t1.seats_name in('B','G','G1','G2') then 'BG'
       else '非BG' end ,
       case when t1.channel in('网站','手机') and t2.users_id is not null then '代理'
       else '非代理' end;
       
       
       
   
     
     
 ---机上销售
   
   
select to_date(t1.FLIGHT_DATE,'yyyymmdd'),
sum(t1.booknum),sum(t1.bookfee)
from dw.fact_prt_order_detail t1
where t1.TERMINAL_TYPE=4
and  t1.status in ('200', '300', '301', '400', '500')
and to_date(t1.FLIGHT_DATE,'yyyymmdd') >= to_date('2018-02-01', 'yyyy-mm-dd')
   and to_date(t1.FLIGHT_DATE,'yyyymmdd') < =to_date('2019-03-01', 'yyyy-mm-dd')
   and ((to_date(t1.FLIGHT_DATE,'yyyymmdd')>=to_date('2018-02-01', 'yyyy-mm-dd')
   and to_date(t1.FLIGHT_DATE,'yyyymmdd') <=to_date('2018-03-12', 'yyyy-mm-dd'))
   or (to_date(t1.FLIGHT_DATE,'yyyymmdd')>=to_date('2018-12-12', 'yyyy-mm-dd')
   and to_date(t1.FLIGHT_DATE,'yyyymmdd') <=to_date('2019-03-01', 'yyyy-mm-dd')))
and t1.flight_no like '9C%'
group by to_date(t1.FLIGHT_DATE,'yyyymmdd')
     




