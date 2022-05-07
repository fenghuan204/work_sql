--免费行李额，线上行李和线下行李购买
--免费行李额，线上行李和线下行李购买
select '本期'  类型,
       t.whole_segment,
       sum(case
             when t8.flights_order_head_id is not null then
              book_fee
             else
              0
           end) web_book_fee,
       sum(case
             when f.flights_order_head_id is not null then
              f.feebag
             else
              0
           end) ground_book_fee    
  from dw.fact_recent_order_detail t
  join dw.da_flight t2 on t.segment_head_id = t2.segment_head_id
  left join (select h1.flights_order_head_id,
                    sum(h1.book_fee) book_fee,
                    sum(h1.book_num) book_num
               from dw.fact_other_order_detail h1
              where h1.flights_date >= trunc(sysdate) - 14 - 10
                and h1.xtype_id in (6, 10, 17)
                and h1.flag_id IN (3, 5, 40, 41)
              group by h1.flights_order_head_id) t8 on t.flights_order_head_id =
                                                       t8.flights_order_head_id
  left join (select flights_order_head_id, sum(fee_bag) feebag
               from dw.fact_dcs_money_detail
              where flights_date >= trunc(sysdate) - 14 - 10
                and fee_bag <> 0
              group by flights_order_head_id) f on t.flights_order_head_id =
                                                   f.flights_order_head_id
 where t.flights_date >= to_date('2019-11-08','yyyy-mm-dd')
   and t.flights_date <=to_date('2019-11-14','yyyy-mm-dd')
   and t.flag_id =40
   and t.whole_flight like '9C%'
   and t.whole_segment in('NGBNGO',
'NGONGB',
'PVGSIN',
'SINPVG')
   group by t.whole_segment
   
   
   
   union all
   
   
  
 --免费行李额，线上行李和线下行李购买
select '环比'  类型,
       t.whole_segment,
       sum(case
             when t8.flights_order_head_id is not null then
              book_fee
             else
              0
           end) web_book_fee,
       sum(case
             when f.flights_order_head_id is not null then
              f.feebag
             else
              0
           end) ground_book_fee    
  from dw.fact_recent_order_detail t
  join dw.da_flight t2 on t.segment_head_id = t2.segment_head_id
  left join (select h1.flights_order_head_id,
                    sum(h1.book_fee) book_fee,
                    sum(h1.book_num) book_num
               from dw.fact_other_order_detail h1
              where  h1.xtype_id in (6, 10, 17)
                and h1.flag_id IN (3, 5, 40, 41)
              group by h1.flights_order_head_id) t8 on t.flights_order_head_id =
                                                       t8.flights_order_head_id
  left join (select flights_order_head_id, sum(fee_bag) feebag
               from dw.fact_dcs_money_detail
              where  fee_bag <> 0
              group by flights_order_head_id) f on t.flights_order_head_id =
                                                   f.flights_order_head_id
 where t.flights_date >= to_date('2019-10-18','yyyy-mm-dd')
   and t.flights_date <=to_date('2019-10-24','yyyy-mm-dd')
   and t.flag_id =40
   and t.whole_flight like '9C%'
   and t.whole_segment in('NGBNGO',
'NGONGB',
'PVGSIN',
'SINPVG')
   group by t.whole_segment
   
   
   
   union all
   
   
   select '同比'  类型,
       t.whole_segment,
       sum(case
             when t8.flights_order_head_id is not null then
              book_fee
             else
              0
           end) web_book_fee,
       sum(case
             when f.flights_order_head_id is not null then
              f.feebag
             else
              0
           end) ground_book_fee    
  from dw.fact_recent_order_detail t
  join dw.da_flight t2 on t.segment_head_id = t2.segment_head_id
  left join (select h1.flights_order_head_id,
                    sum(h1.book_fee) book_fee,
                    sum(h1.book_num) book_num
               from dw.fact_other_order_detail h1
              where h1.xtype_id in (6, 10, 17)
                and h1.flag_id IN (3, 5, 40, 41)
              group by h1.flights_order_head_id) t8 on t.flights_order_head_id =
                                                       t8.flights_order_head_id
  left join (select flights_order_head_id, sum(fee_bag) feebag
               from dw.fact_dcs_money_detail
              where fee_bag <> 0
              group by flights_order_head_id) f on t.flights_order_head_id =
                                                   f.flights_order_head_id
 where t.flights_date >= to_date('2018-11-09','yyyy-mm-dd')
   and t.flights_date <=to_date('2018-11-15','yyyy-mm-dd')
   and t.flag_id =40
   and t.whole_flight like '9C%'
   and t.whole_segment in('NGBNGO',
'NGONGB',
'PVGSIN',
'SINPVG')
   group by t.whole_segment
   

   
 
   
 
   
   
    select  '同比',t1.flights_segment,sum(t1.checkin_num) 乘机人数,suM(t1.bx_cabin_arr) 包销人数,sum(t1.total_income) 机票燃油收入,
   sum(t1.it_ticket_income) 散客机票收入,suM(t1.bj_ticket_income) 包销机票收入,sum(t1.checkin_s_mile) 座公里
     from hdb.recent_flights_cost t1
     where t1.flights_segment in('NGBNGO',
'NGONGB',
'PVGSIN',
'SINPVG')
     and t1.flight_date>=to_date('2018-11-09','yyyy-mm-dd')
     and t1.flight_date<=to_date('2018-11-15','yyyy-mm-dd')
     and t1.total_cost>0
     group by t1.flights_segment
     
     union all
     
        select  '本期',t1.flights_segment,sum(t1.checkin_num),suM(t1.bx_cabin_arr),sum(t1.total_income),
   sum(t1.it_ticket_income),suM(t1.bj_ticket_income),sum(t1.checkin_s_mile) 
     from hdb.recent_flights_cost t1
     where t1.flights_segment in('NGBNGO',
'NGONGB',
'PVGSIN',
'SINPVG')
     and t1.flight_date>=to_date('2019-11-08','yyyy-mm-dd')
     and t1.flight_date<=to_date('2019-11-14','yyyy-mm-dd')
     and t1.total_cost>0
     group by t1.flights_segment
     
     
     union all
     
     select  '环比',t1.flights_segment,sum(t1.checkin_num),suM(t1.bx_cabin_arr),sum(t1.total_income),
   sum(t1.it_ticket_income),suM(t1.bj_ticket_income),sum(t1.checkin_s_mile) 
     from hdb.recent_flights_cost t1
     where t1.flights_segment in('NGBNGO',
'NGONGB',
'PVGSIN',
'SINPVG')
     and t1.flight_date>=to_date('2019-10-18','yyyy-mm-dd')
     and t1.flight_date<=to_date('2019-10-24','yyyy-mm-dd')
     and t1.total_cost>0
     group by t1.flights_segment
   
 
   
 