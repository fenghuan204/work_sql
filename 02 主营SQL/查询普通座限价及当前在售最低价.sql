select hb1.flight_date,hb1.flights_segment,min(cabin_price)
from(
select h1.segment_head_id,
       h1.seats_name ,
       h1.money ,
       h2.remnant ,
       trunc(h3.origin_std) flight_date ,
       h3.flights_segment ,
       h3.r_flights_no flight_no ,
       h4.flights_segment_name,
       h7.sub_cabin,
       case when h7.sub_cabin is not null then h7.sub_cabin
       else h1.money end cabin_price
  from (select *
          from (select segment_head_id,
                       MONEY_E,
MONEY_H,
MONEY_I,
MONEY_K,
MONEY_L,
MONEY_M,
MONEY_N,
MONEY_P,
MONEY_P1,
MONEY_P2,
MONEY_P3,
MONEY_P4,
MONEY_P5,
MONEY_Q,
MONEY_R1,
MONEY_R2,
MONEY_R3,
MONEY_R4,
MONEY_S,
MONEY_T,
MONEY_U,
MONEY_V,
MONEY_X,
MONEY_Y                       
from cqsale.cq_flights_segment_head@to_air) unpivot(money for seats_name in (MONEY_E as 'E',
MONEY_H as 'H',
MONEY_I as 'I',
MONEY_K as 'K',
MONEY_L as 'L',
MONEY_M as 'M',
MONEY_N as 'N',
MONEY_P as 'P',
MONEY_P1 as 'P1',
MONEY_P2 as 'P2',
MONEY_P3 as 'P3',
MONEY_P4 as 'P4',
MONEY_P5 as 'P5',
MONEY_Q as 'Q',
MONEY_R1 as 'R1',
MONEY_R2 as 'R2',
MONEY_R3 as 'R3',
MONEY_R4 as 'R4',
MONEY_S as 'S',
MONEY_T as 'T',
MONEY_U as 'U',
MONEY_V as 'V',
MONEY_X as 'X',
MONEY_Y as 'Y'
))
                  ) h1
  join (select *
          from (select segment_head_id,
                       REMNANT_E,
REMNANT_H,
REMNANT_I,
REMNANT_K,
REMNANT_L,
REMNANT_M,
REMNANT_N,
REMNANT_P,
REMNANT_P1,
REMNANT_P2,
REMNANT_P3,
REMNANT_P4,
REMNANT_P5,
REMNANT_Q,
REMNANT_R1,
REMNANT_R2,
REMNANT_R3,
REMNANT_R4,
REMNANT_S,
REMNANT_T,
REMNANT_U,
REMNANT_V,
REMNANT_X,
REMNANT_Y
from cqsale.cq_flights_seats_amount@to_air) unpivot(remnant for seats_name in (REMNANT_E AS 'E',
REMNANT_H AS 'H',
REMNANT_I AS 'I',
REMNANT_K AS 'K',
REMNANT_L AS 'L',
REMNANT_M AS 'M',
REMNANT_N AS 'N',
REMNANT_P AS 'P',
REMNANT_P1 AS 'P1',
REMNANT_P2 AS 'P2',
REMNANT_P3 AS 'P3',
REMNANT_P4 AS 'P4',
REMNANT_P5 AS 'P5',
REMNANT_Q AS 'Q',
REMNANT_R1 AS 'R1',
REMNANT_R2 AS 'R2',
REMNANT_R3 AS 'R3',
REMNANT_R4 AS 'R4',
REMNANT_S AS 'S',
REMNANT_T AS 'T',
REMNANT_U AS 'U',
REMNANT_V AS 'V',
REMNANT_X AS 'X',
REMNANT_Y AS 'Y'))) h2 on h1.segment_head_id =  h2.segment_head_id    and h1.seats_name = h2.seats_name
  join cqsale.cq_flights_segment_head@to_air h3 on h1.segment_head_id =  h3.segment_head_id
  join cqsale.cq_flights_seats_amount@to_air h5 on h1.segment_head_id=h5.segment_head_id
  left join dw.da_flight h4 on h1.segment_head_id = h4.segment_head_id
  left join (
  select h6.segment_head_id,h6.main_cabin,max(h6.sub_cabin_price) sub_cabin
from stg.s_CQ_SUB_CABIN_SEGMENT_HEAD h6
where h6.state=1
group by h6.segment_head_id,h6.main_cabin)h7 on h1.segment_head_id=h7.segment_head_id and h1.seats_name=h7.main_cabin
 where h3.origin_std >= trunc(sysdate)+1
   and h3.origin_std< trunc(sysdate)+2
   and h2.remnant > 0
   and h3.flag <> 2
   --and h1.segment_head_id =1438884
   and h3.r_flights_no like '9C%'
   and h1.seats_name not in('P2','P5','P3','P4'))hb1
   group by hb1.flight_date,hb1.flights_segment;





-----限价数据

select hh2.segment_head_id,hh3.flight_date,hh3.flight_no,hh3.segment_code,hh1.RESULT_CABIN_PRICE,hh1.LIMIT_CABIN_PRICE,hh2.money
from cqrm.bi_segment_result@to_cqrm hh1
left join (
select segment_head_id,min(money) money
from(
select h1.segment_head_id,
       h1.seats_name ,
       h1.money ,
       h2.remnant ,
       h3.flights_segment ,
       h3.r_flights_no 
  from (select *
          from (select segment_head_id,
                       MONEY_E,
MONEY_H,
MONEY_I,
MONEY_K,
MONEY_L,
MONEY_M,
MONEY_N,
MONEY_P,
MONEY_P1,
MONEY_P2,
MONEY_P3,
MONEY_P4,
MONEY_P5,
MONEY_Q,
MONEY_R1,
MONEY_R2,
MONEY_R3,
MONEY_R4,
MONEY_S,
MONEY_T,
MONEY_U,
MONEY_V,
MONEY_X,
MONEY_Y                       
from stg.s_cq_flights_segment_head) unpivot(money for seats_name in (MONEY_E as 'E',
MONEY_H as 'H',
MONEY_I as 'I',
MONEY_K as 'K',
MONEY_L as 'L',
MONEY_M as 'M',
MONEY_N as 'N',
MONEY_P as 'P',
MONEY_P1 as 'P1',
MONEY_P2 as 'P2',
MONEY_P3 as 'P3',
MONEY_P4 as 'P4',
MONEY_P5 as 'P5',
MONEY_Q as 'Q',
MONEY_R1 as 'R1',
MONEY_R2 as 'R2',
MONEY_R3 as 'R3',
MONEY_R4 as 'R4',
MONEY_S as 'S',
MONEY_T as 'T',
MONEY_U as 'U',
MONEY_V as 'V',
MONEY_X as 'X',
MONEY_Y as 'Y'
))
                  ) h1
  join (select *
          from (select segment_head_id,
                       REMNANT_E,
REMNANT_H,
REMNANT_I,
REMNANT_K,
REMNANT_L,
REMNANT_M,
REMNANT_N,
REMNANT_P,
REMNANT_P1,
REMNANT_P2,
REMNANT_P3,
REMNANT_P4,
REMNANT_P5,
REMNANT_Q,
REMNANT_R1,
REMNANT_R2,
REMNANT_R3,
REMNANT_R4,
REMNANT_S,
REMNANT_T,
REMNANT_U,
REMNANT_V,
REMNANT_X,
REMNANT_Y
from stg.s_cq_flights_seats_amount) unpivot(remnant for seats_name in (REMNANT_E AS 'E',
REMNANT_H AS 'H',
REMNANT_I AS 'I',
REMNANT_K AS 'K',
REMNANT_L AS 'L',
REMNANT_M AS 'M',
REMNANT_N AS 'N',
REMNANT_P AS 'P',
REMNANT_P1 AS 'P1',
REMNANT_P2 AS 'P2',
REMNANT_P3 AS 'P3',
REMNANT_P4 AS 'P4',
REMNANT_P5 AS 'P5',
REMNANT_Q AS 'Q',
REMNANT_R1 AS 'R1',
REMNANT_R2 AS 'R2',
REMNANT_R3 AS 'R3',
REMNANT_R4 AS 'R4',
REMNANT_S AS 'S',
REMNANT_T AS 'T',
REMNANT_U AS 'U',
REMNANT_V AS 'V',
REMNANT_X AS 'X',
REMNANT_Y AS 'Y'))) h2 on h1.segment_head_id =  h2.segment_head_id    and h1.seats_name = h2.seats_name
  join stg.s_cq_flights_segment_head h3 on h1.segment_head_id =  h3.segment_head_id
  join stg.s_cq_flights_seats_amount h5 on h1.segment_head_id=h5.segment_head_id
  left join dw.da_flight h4 on h1.segment_head_id = h4.segment_head_id
 where h3.origin_std >= to_date('2019-10-27','yyyy-mm-dd')
   and h2.remnant > 0
   and h3.flag <> 2
   and h3.r_flights_no like '9C%'
   and h1.seats_name not in('P2','P5','P3','P4','A','D','Z','I','J')
   and h3.flights_segment like '%HKT%')
   group by segment_head_id)hh2 on hh1.segment_head_id=hh2.segment_head_id
   left join dw.da_flight hh3 on hh1.segment_head_id=hh3.segment_head_id
   where hh3.segment_code like '%HKT%'
   and hh3.segment_code like '%PVG%'
   and hh3.flight_date>= to_date('2019-10-27','yyyy-mm-dd')
   and hh3.flight_date<= to_date('2020-03-28','yyyy-mm-dd')
   and hh1.RULE_TYPE=1;


---当前在售最低价、组合产品价差
   select hb2.*,hb3.comb_fee
from(
select hb1.flight_date,hb1.flights_segment,hb1.flight_no,hb1.price,min(cabin_price)
from(
select h1.segment_head_id,
       h1.seats_name ,
       h1.money ,
       h2.remnant ,
       trunc(h3.origin_std) flight_date ,
       h3.flights_segment ,
       h3.r_flights_no flight_no ,
       h4.flights_segment_name,
       h3.price,
       h7.sub_cabin,
       case when h7.sub_cabin is not null then h7.sub_cabin
       else h1.money end cabin_price
  from (select *
          from (select segment_head_id,
                       MONEY_E,
MONEY_H,
MONEY_I,
MONEY_K,
MONEY_L,
MONEY_M,
MONEY_N,
MONEY_P,
MONEY_P1,
MONEY_P2,
MONEY_P3,
MONEY_P4,
MONEY_P5,
MONEY_Q,
MONEY_R1,
MONEY_R2,
MONEY_R3,
MONEY_R4,
MONEY_S,
MONEY_T,
MONEY_U,
MONEY_V,
MONEY_X,
MONEY_Y                       
from cqsale.cq_flights_segment_head@to_air) unpivot(money for seats_name in (MONEY_E as 'E',
MONEY_H as 'H',
MONEY_I as 'I',
MONEY_K as 'K',
MONEY_L as 'L',
MONEY_M as 'M',
MONEY_N as 'N',
MONEY_P as 'P',
MONEY_P1 as 'P1',
MONEY_P2 as 'P2',
MONEY_P3 as 'P3',
MONEY_P4 as 'P4',
MONEY_P5 as 'P5',
MONEY_Q as 'Q',
MONEY_R1 as 'R1',
MONEY_R2 as 'R2',
MONEY_R3 as 'R3',
MONEY_R4 as 'R4',
MONEY_S as 'S',
MONEY_T as 'T',
MONEY_U as 'U',
MONEY_V as 'V',
MONEY_X as 'X',
MONEY_Y as 'Y'
))
                  ) h1
  join (select *
          from (select segment_head_id,
                       REMNANT_E,
REMNANT_H,
REMNANT_I,
REMNANT_K,
REMNANT_L,
REMNANT_M,
REMNANT_N,
REMNANT_P,
REMNANT_P1,
REMNANT_P2,
REMNANT_P3,
REMNANT_P4,
REMNANT_P5,
REMNANT_Q,
REMNANT_R1,
REMNANT_R2,
REMNANT_R3,
REMNANT_R4,
REMNANT_S,
REMNANT_T,
REMNANT_U,
REMNANT_V,
REMNANT_X,
REMNANT_Y
from cqsale.cq_flights_seats_amount@to_air) unpivot(remnant for seats_name in (REMNANT_E AS 'E',
REMNANT_H AS 'H',
REMNANT_I AS 'I',
REMNANT_K AS 'K',
REMNANT_L AS 'L',
REMNANT_M AS 'M',
REMNANT_N AS 'N',
REMNANT_P AS 'P',
REMNANT_P1 AS 'P1',
REMNANT_P2 AS 'P2',
REMNANT_P3 AS 'P3',
REMNANT_P4 AS 'P4',
REMNANT_P5 AS 'P5',
REMNANT_Q AS 'Q',
REMNANT_R1 AS 'R1',
REMNANT_R2 AS 'R2',
REMNANT_R3 AS 'R3',
REMNANT_R4 AS 'R4',
REMNANT_S AS 'S',
REMNANT_T AS 'T',
REMNANT_U AS 'U',
REMNANT_V AS 'V',
REMNANT_X AS 'X',
REMNANT_Y AS 'Y'))) h2 on h1.segment_head_id =  h2.segment_head_id    and h1.seats_name = h2.seats_name
  join cqsale.cq_flights_segment_head@to_air h3 on h1.segment_head_id =  h3.segment_head_id
  join cqsale.cq_flights_seats_amount@to_air h5 on h1.segment_head_id=h5.segment_head_id
  left join dw.da_flight h4 on h1.segment_head_id = h4.segment_head_id
  left join (
  select h6.segment_head_id,h6.main_cabin,max(h6.sub_cabin_price) sub_cabin
from stg.s_CQ_SUB_CABIN_SEGMENT_HEAD h6
where h6.state=1
group by h6.segment_head_id,h6.main_cabin)h7 on h1.segment_head_id=h7.segment_head_id and h1.seats_name=h7.main_cabin
 where h3.origin_std >= to_date('2021-03-28','yyyy-mm-dd')
   and h3.origin_std< to_date('2021-10-31','yyyy-mm-dd')
   and h2.remnant > 0
   and h3.flag <> 2
   --and h1.segment_head_id =1438884
   and h3.r_flights_no like '9C%'
   and h1.seats_name not in('P2','P5','P3','P4'))hb1
   group by hb1.flight_date,hb1.flights_segment,hb1.flight_no,hb1.price)hb2 
   left join(select *
from(
select h1.segment_code,h1.comb_fee,h1.num,row_number()over(partition by h1.segment_code order by h1.num desc) xid
from(
select t2.segment_code,t1.comb_fee,count(1) num
 from dw.fact_recent_order_detail t1
 join dw.da_flight t2 on t2.segment_head_id=t1.segment_head_id
 where t1.flights_date>=to_date('2021-03-28','yyyy-mm-dd')
 and t1.flights_date< to_date('2021-10-24','yyyy-mm-dd')
 and t1.comb_fee is not null
 and t1.comb_fee>0
 group by t2.segment_code,t1.comb_fee)h1
 )
 where xid=1)hb3 on hb2.flights_segment=hb3.segment_code
   
   
   
