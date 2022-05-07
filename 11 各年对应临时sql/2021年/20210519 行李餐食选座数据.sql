--行李

select '行李',to_char(t.r_flights_date,'yyyy'),sum(t1.book_price)  线上行李金额,
       sum(b.feebag) 线下行李金额
 from stg.s_cq_order_head t
left join( select order_head_id,sum(book_price*nvl(r_com_rate,1)) book_price
from   stg.s_cq_other_order_head
where flag_id in(3,5,40)
and ex_nfd1 in(6,10,17)
group by order_head_id)t1 on t.flights_order_head_id=t1.order_head_id
 left join (select flights_order_head_id, sum(fee_bag) feebag
          from dw.fact_dcs_money_detail
         where flights_date >= to_date('2005-01-01', 'yyyy-mm-dd')
           and fee_bag <> 0
         group by flights_order_head_id) b on b.flights_order_head_id =
                                              t.flights_order_head_id
 where t.r_flights_date>=to_date('2005-01-01','yyyy-mm-dd')
 and t.flag_id in(3,5,40)
 and t.r_flights_date< to_date('2021-05-01','yyyy-mm-dd')
 and t.whole_flight like '9C%'
  group by to_char(t.r_flights_date,'yyyy') 

---选座

select '选座',to_char(t.r_flights_date,'yyyy'),sum(t1.book_price)  线上行李金额,
       sum(b.feebag) 线下行李金额
 from stg.s_cq_order_head t
left join( select order_head_id,sum(book_price*nvl(r_com_rate,1)) book_price
from   stg.s_cq_other_order_head
where flag_id in(3,5,40)
and ex_nfd1 =3
group by order_head_id)t1 on t.flights_order_head_id=t1.order_head_id
 left join (select flights_order_head_id, sum(fee_kdj) fee_kdj
          from dw.fact_dcs_money_detail
         where flights_date >= to_date('2005-01-01', 'yyyy-mm-dd')
           and fee_kdj <> 0
         group by flights_order_head_id) b on b.flights_order_head_id =
                                              t.flights_order_head_id
 where t.r_flights_date>=to_date('2005-01-01','yyyy-mm-dd')
 and t.flag_id in(3,5,40)
 and t.r_flights_date< to_date('2021-05-01','yyyy-mm-dd')
 and t.whole_flight like '9C%'
  group by to_char(t.r_flights_date,'yyyy') 
 
 
 
  ---餐食
 
 select '餐食',to_char(t1.r_flights_date,'yyyy'),sum(t1.book_price*nvl(t1.R_COM_RATE,1))  线上选座金额,
       0 线下选座金额
 from stg.s_cq_other_order_head t1 
 where t1.r_flights_date>=to_date('2005-01-01','yyyy-mm-dd')
 and t1.r_flights_date< to_date('2021-05-01','yyyy-mm-dd')
 and t1.flag_id in(3,5,40)
 and t1.whole_flight like '9C%'
 and t1.ex_nfd1=7
 group by to_char(t1.r_flights_date,'yyyy')


union all


select '餐食',to_char(nvl(to_date(l.flight_date, 'yyyymmdd'), l.order_day),
               'yyyy') 航班年,  0,     
       sum(l.bookfee) 辅收金额
  from dw.fact_prt_order_detail l
  join stg.prt_eshop_product p on p.id = l.product_id
  left join dw.da_foc_order t1 on t1.flights_date =
                                  to_date(l.flight_date, 'yyyymmdd')
                              and t1.flights_no =
                                  (case when length(l.flight_no) < 6 then
                                   '9C' || substr(l.flight_no, 1, 5) else
                                   substr(l.flight_no, 1, 7) end)
  left join dw.da_flight t2 on t1.flights_id = t2.flights_id
                           and t1.segment_code = t2.segment_code
 where l.order_day >= to_date('2005-01-01', 'yyyy-mm-dd')
   and nvl(to_date(l.flight_date, 'yyyymmdd'), l.order_day) >=
       to_date('2005-01-01', 'yyyy-mm-dd')
       
     and nvl(to_date(l.flight_date, 'yyyymmdd'), l.order_day) < 
       to_date('2021-05-01', 'yyyy-mm-dd')
   and nvl(l.flight_no, '9C') like '9C%'
   and l.type_name in( '餐食','小吃','饮料')
   and l.status in ('200', '300', '301', '400', '500')
   and (case when l.product_name like '%想飞就飞%' then 0 when
        p.merchant_id = 10220 and l.product_name like '%补差价%' then 0 else 1 end) = 1 --排除套票
        group by to_char(nvl(to_date(l.flight_date, 'yyyymmdd'), l.order_day),
               'yyyy')
               
    union all
    
    
  select '餐食',to_char(t1.r_flights_date, 'yyyy'),sum(t.dinner_price * t.dinner_num) 辅收金额,0
  from stg.s_cq_group_dinner_detail t
  join stg.s_cq_order_head t1 on t.order_head_id = t1.flights_order_head_id
  join dw.da_flight t2 on t2.segment_head_id = t1.segment_head_id
  
 where t1.flag_id in (3, 5, 40, 41)
   and t1.whole_flight like '9C%'
   and t1.r_flights_date >= to_date('2005-01-01', 'yyyy-mm-dd')
   and t1.r_flights_date <  to_date('2021-01-01', 'yyyy-mm-dd')
   group by to_char(t1.r_flights_date, 'yyyy')
