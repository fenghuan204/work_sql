select '2018��' ��,'0508' ��ֹ����,
h1.seats_name ��λ,
case when h4.discount<=30 then '3�ۼ�����'
when h4.discount>30 then '3������' end seattype,

sum(h1.plan) plan,
sum(h2.remnant) remnant
  from (select *
          from (select segment_head_id,        
        
plan_E,
plan_H,
plan_I,
plan_K,
plan_L,
plan_M,
plan_N,
plan_P,
plan_P1,
plan_P2,
plan_P3,
plan_P4,
plan_P5,
plan_Q,
plan_R1,
plan_R2,
plan_R3,
plan_R4,
plan_S,
plan_T,
plan_U,
plan_V,
plan_X,
plan_Y                       
from dw.bi_segment_id_plan_remnant
 where create_time>= to_date('2018-05-09','yyyy-mm-dd')
  and create_time<  to_date('2018-05-10','yyyy-mm-dd')) unpivot(plan for seats_name in (
plan_E as 'E',
plan_H as 'H',
plan_I as 'I',
plan_K as 'K',
plan_L as 'L',
plan_M as 'M',
plan_N as 'N',
plan_P as 'P',
plan_P1 as 'P1',
plan_P2 as 'P2',
plan_P3 as 'P3',
plan_P4 as 'P4',
plan_P5 as 'P5',
plan_Q as 'Q',
plan_R1 as 'R1',
plan_R2 as 'R2',
plan_R3 as 'R3',
plan_R4 as 'R4',
plan_S as 'S',
plan_T as 'T',
plan_U as 'U',
plan_V as 'V',
plan_X as 'X',
plan_Y as 'Y'
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
from dw.bi_segment_id_plan_remnant
 where create_time>= to_date('2018-05-09','yyyy-mm-dd')
  and create_time<   to_date('2018-05-10','yyyy-mm-dd')) unpivot(remnant for seats_name in (
REMNANT_E AS 'E',
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
  join dw.da_flight h3 on h1.segment_head_id =  h3.segment_head_id
  left join dw.dim_cabin_type h4 on h1.seats_name=h4.seats_name
 where h3.origin_std >= to_date('2018-05-09','yyyy-mm-dd')
   and h3.origin_std <   to_date('2018-10-28','yyyy-mm-dd')
   and h3.flag <> 2
   and h3.company_id =0
   group by h1.seats_name,case when h4.discount<=30 then '3�ۼ�����'
when h4.discount>30 then '3������' end
   
union all

select '2019��' ��,'0508' ��ֹ����,
h1.seats_name ��λ,
case when h4.discount<=30 then '3�ۼ�����'
when h4.discount>30 then '3������' end seattype,

sum(h1.plan) plan,
sum(h2.remnant) remnant
  from (select *
          from (select segment_head_id,        
        
plan_E,
plan_H,
plan_I,
plan_K,
plan_L,
plan_M,
plan_N,
plan_P,
plan_P1,
plan_P2,
plan_P3,
plan_P4,
plan_P5,
plan_Q,
plan_R1,
plan_R2,
plan_R3,
plan_R4,
plan_S,
plan_T,
plan_U,
plan_V,
plan_X,
plan_Y                       
from dw.bi_segment_id_plan_remnant
 where create_time>= to_date('2019-05-09','yyyy-mm-dd')
  and create_time<  to_date('2019-05-10','yyyy-mm-dd')) unpivot(plan for seats_name in (
plan_E as 'E',
plan_H as 'H',
plan_I as 'I',
plan_K as 'K',
plan_L as 'L',
plan_M as 'M',
plan_N as 'N',
plan_P as 'P',
plan_P1 as 'P1',
plan_P2 as 'P2',
plan_P3 as 'P3',
plan_P4 as 'P4',
plan_P5 as 'P5',
plan_Q as 'Q',
plan_R1 as 'R1',
plan_R2 as 'R2',
plan_R3 as 'R3',
plan_R4 as 'R4',
plan_S as 'S',
plan_T as 'T',
plan_U as 'U',
plan_V as 'V',
plan_X as 'X',
plan_Y as 'Y'
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
from dw.bi_segment_id_plan_remnant
 where create_time>= to_date('2019-05-09','yyyy-mm-dd')
  and create_time<   to_date('2019-05-10','yyyy-mm-dd')) unpivot(remnant for seats_name in (
REMNANT_E AS 'E',
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
  join dw.da_flight h3 on h1.segment_head_id =  h3.segment_head_id
  left join dw.dim_cabin_type h4 on h1.seats_name=h4.seats_name
 where h3.origin_std >= to_date('2019-05-09','yyyy-mm-dd')
   and h3.origin_std <   to_date('2019-10-28','yyyy-mm-dd')
   and h3.flag <> 2
   and h3.company_id =0
   group by h1.seats_name,case when h4.discount<=30 then '3�ۼ�����'
when h4.discount>30 then '3������' end
 
