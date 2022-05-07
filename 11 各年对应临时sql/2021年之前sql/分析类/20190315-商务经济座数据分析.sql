---商务经济座数据分析

select t1.flights_order_id,
       t2.flights_segment_name,
       t2.flight_no,
       t1.flight_date,
       t2.week_num,
       to_char(t2.origin_std, 'hh24:mi'),
       to_char(t2.dest_sta, 'hh24:mi'),
       case
         when t1.seats_name in ('B', 'G', 'G1', 'G2') then
          'BG'
         else
          '非BG'
       end,
       case when t1.main_channel in('网站','手机') and t4.users_id is not null then '代理'
       else '非代理' end 是否代理,
       t2.superseat_num,
       case when t1.UPGRADE_TYPE=-1 then '1'
       else '2' end "一次/二次",
       t1.main_channel,
       t1.main_sub_channel,
       case when t1.UPGRADE_TYPE=-1 then null
       else  t1.channel end channel,
       case when t1.UPGRADE_TYPE=-1 then null
       else  t1.sub_channel end,
       t1.flight_date-trunc(t1.main_order_date),
       t1.ahead_days,
       t1.ticket_price,
       t1.price,
       t1.ticket_price-t1.min_seat_price*t1.rcd_rate,
       t3.ticketnum,
       t1.gender,
       t1.age,
       tb1.nationnum,
       tb1.tonum
 from dw.bi_superseat_detail t1
  join dw.da_flight t2 on t1.segment_head_id = t2.segment_head_id
  left join dw.da_main_order t3 on t1.segment_head_id=t3.segment_head_id
  left join dw.da_restrict_userinfo t4 on t1.client_id=t4.users_id
  left join (select  tt1.traveller_name,tt1.codeno,sum(case when tt1.nationflag='国内' then 1 else 0 end) nationnum,count(1) tonum
                from dw.fact_order_detail tt1
                where tt1.flights_date>=to_date('2018-03-01','yyyy-mm-dd')
                 and tt1.flights_date< to_date('2019-03-01','yyyy-mm-dd')
                 and tt1.flag_id=40
                 group by tt1.traveller_name,tt1.codeno)tb1 on t1.traveller_name=tb1.traveller_name and t1.codeno=tb1.codeno 
  
  where t1.flight_date>=to_date('2018-03-01','yyyy-mm-dd')
   and t1.flight_date< to_date('2019-03-01','yyyy-mm-dd')
   and t2.flag<>2
   and t2.company_id=0
