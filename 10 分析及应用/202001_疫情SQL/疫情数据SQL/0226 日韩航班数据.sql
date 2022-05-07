select /*+parallel(4) */
t1.r_flights_date 航班日期,t2.flight_no 航班号,t2.flights_segment_name 航段,
(t6.PLAN_Y + t6.PLAN_B + t6.PLAN_H + t6.PLAN_K + t6.PLAN_L +
                       t6.PLAN_M + t6.PLAN_N + t6.PLAN_Q + t6. PLAN_T + t6.
                        PLAN_X + t6.PLAN_U + t6.PLAN_E + t6.PLAN_W + t6.PLAN_P +
                        t6.PLAN_P1 + t6.PLAN_P2 + t6.PLAN_O + t6. PLAN_G + t6.
                        PLAN_G1 + t6.
                        PLAN_G2 + t6.PLAN_R1 + t6.PLAN_R2 + t6.PLAN_R3 + t6.PLAN_R4 +
                        NVL(t6.PLAN_F, 0) + NVL(t6.PLAN_F1, 0) + NVL(t6.PLAN_F2, 0) +
                        NVL(t6.PLAN_F3, 0) + NVL(t6.PLAN_F4, 0) + NVL(t6.PLAN_C, 0) +
                        NVL(t6.PLAN_C1, 0) + NVL(t6.PLAN_C2, 0) +
                        NVL(t6.PLAN_C3, 0) + NVL(t6.PLAN_C4, 0) + NVL(t6.PLAN_S, 0) +
                        NVL(t6.PLAN_V, 0) + NVL(t6.PLAN_A, 0) + NVL(t6.PLAN_D, 0) +
                        NVL(t6.PLAN_I, 0) + NVL(t6.PLAN_J, 0) + NVL(t6.PLAN_Z, 0) +
                        NVL(t6.PLAN_P3, 0) + NVL(t6.PLAN_P4, 0) +
                        NVL(t6.PLAN_P5, 0))  座位数,
count(1)  预约数,
sum(case when t4.nationality ='KOR' then 1
else 0 end) 韩国籍人数,
sum(case when t4.nationality ='JPN' then 1
else 0 end) 日本籍人数
from cqsale.cq_order_head@to_air t1
join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
join cqsale.cq_flights_segment_head@to_air t3 on t2.segment_head_id=t3.segment_head_id
left join cqsale.cq_traveller_info@to_air t4 on t1.flights_order_head_id=t4.flights_order_head_id
left join cqsale.cq_flights_seats_amount_plan@to_air t6 on t1.segment_Head_id=t6.segment_Head_id
where t1.r_flights_date>=trunc(sysdate-1)
and t1.r_flights_date<=to_date('2020-03-03','yyyy-mm-dd')+(trunc(sysdate)-to_date('2020-02-26','yyyy-mm-dd'))
and t1.flag_id in(3,5,40,41)
and t2.company_id=0
and t3.flag<>2
and t1.seats_name is not null
and t2.origin_country_id>0
and t2.destairport_name='浦东'
and t2.segment_country in('韩国','日本')
group by t1.r_flights_date ,t2.flight_no ,t2.flights_segment_name ,
(t6.PLAN_Y + t6.PLAN_B + t6.PLAN_H + t6.PLAN_K + t6.PLAN_L +
                       t6.PLAN_M + t6.PLAN_N + t6.PLAN_Q + t6. PLAN_T + t6.
                        PLAN_X + t6.PLAN_U + t6.PLAN_E + t6.PLAN_W + t6.PLAN_P +
                        t6.PLAN_P1 + t6.PLAN_P2 + t6.PLAN_O + t6. PLAN_G + t6.
                        PLAN_G1 + t6.
                        PLAN_G2 + t6.PLAN_R1 + t6.PLAN_R2 + t6.PLAN_R3 + t6.PLAN_R4 +
                        NVL(t6.PLAN_F, 0) + NVL(t6.PLAN_F1, 0) + NVL(t6.PLAN_F2, 0) +
                        NVL(t6.PLAN_F3, 0) + NVL(t6.PLAN_F4, 0) + NVL(t6.PLAN_C, 0) +
                        NVL(t6.PLAN_C1, 0) + NVL(t6.PLAN_C2, 0) +
                        NVL(t6.PLAN_C3, 0) + NVL(t6.PLAN_C4, 0) + NVL(t6.PLAN_S, 0) +
                        NVL(t6.PLAN_V, 0) + NVL(t6.PLAN_A, 0) + NVL(t6.PLAN_D, 0) +
                        NVL(t6.PLAN_I, 0) + NVL(t6.PLAN_J, 0) + NVL(t6.PLAN_Z, 0) +
                        NVL(t6.PLAN_P3, 0) + NVL(t6.PLAN_P4, 0) +
                        NVL(t6.PLAN_P5, 0)) 



