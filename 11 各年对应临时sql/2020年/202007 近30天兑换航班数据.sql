select h1.flight_date,h1.flight_no,h1.route_name,
sum(h1.oversale) oversale,h2.limit,sum(h1.superseat_num) superseat_num,
sum(h1.ticketnum) ticketnum,sum(h1.sult_num) sult_num,
sum(h1.sup_sult_num) sup_sult_num
from(
select t2.flights_id,t2.flight_date,t2.flight_no,t2.route_name,t1.segment_head_id,t2.oversale,t2.superseat_num,count(1) ticketnum,
count(t3.flights_order_head_id) sult_num,
sum(case when t1.EX_CFD2='S' and t3.flights_order_head_id is not null then 1 else 0 end) sup_sult_num
from cqsale.cq_order_head@to_air t1
join dw.da_flight t2 on t2.segment_head_id=t1.segment_head_id
left join dw.fact_combo_ticket t3 on t1.flights_order_head_id=t3.flights_order_head_id and t3.payflag=1
where t1.r_flights_date>=trunc(sysdate)+8
  and t1.r_flights_date<=trunc(sysdate)+30+8
  and t2.nationflag='¹úÄÚ'
  and t1.whole_flight like '9C%'
  and t1.flag_id in(3,5,40,41)
  and t1.seats_name is not null
group by t2.flights_id,t2.flight_date,t2.route_name,t1.segment_head_id,t2.oversale,t2.superseat_num,t2.flight_no)h1
left join YHQ.CQ_SUIT_TICKET_LIMIT_RULE@to_air h2 on h1.flight_date>=to_date(h2.flight_date_s,'yyyy-mm-dd')
and h1.flight_date<=to_date(h2.flight_date_e,'yyyy-mm-dd')
group by h1.flight_date,h1.flight_no,h1.route_name,h2.limit
