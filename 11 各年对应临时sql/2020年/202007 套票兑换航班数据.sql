select h3.flight_date,h3.route_name,sum(oversale) oversale,sum(h3.limit) limit,sum(h3.ticketnum) ticketnum,
sum(h3.ticketprice) ticketprice ,sum(h3.predict_num) predict_num,sum(h3.predict_price) predict_price,
sum(h3.sult_num) sult_num,sum(h3.yhq_money) yhq_money,
case when h4.route_name is not null then 1 else 0 end 是否兑换航线,
case when sum(h3.sult_num)>0 then 1 else 0 end  是否兑换机票
from(
select h1.flights_id,h1.flight_date,h1.route_name,sum(h1.oversale) oversale,h2.limit,sum(h1.ticketnum) ticketnum,
sum(nvl(tp1.CORR_PREDICT_TICKET_NUM,h1.ticketnum)) predict_num,
sum(h1.ticketprice) ticketprice,sum(nvl(tp1.corr_predict_ticket_price,h1.ticketprice)) predict_price,
sum(h1.sult_num) sult_num,sum(h1.yhq_money) yhq_money
from(
select t2.flights_id,t2.flight_date,t2.route_name,t1.segment_head_id,t2.oversale,count(1) ticketnum,
sum(t1.ticket_price*t1.r_com_rate) ticketprice,
count(t3.flights_order_head_id) sult_num,
sum(t3.yhq_money) yhq_money
from cqsale.cq_order_head@to_air t1
join dw.da_flight t2 on t2.segment_head_id=t1.segment_head_id
left join dw.fact_combo_ticket t3 on t1.flights_order_head_id=t3.flights_order_head_id
where t1.r_flights_date>=to_date('2020-07-01','yyyy-mm-dd')
  and t1.r_flights_date<=to_date('2020-07-27','yyyy-mm-dd')
  and t2.nationflag='国内'
  and t1.whole_flight like '9C%'
  and t1.flag_id in(3,5,40,41)
  and t1.seats_name is not null
group by t2.flights_id,t2.flight_date,t2.route_name,t1.segment_head_id,t2.oversale)h1
left join YHQ.CQ_SUIT_TICKET_LIMIT_RULE@to_air h2 on h1.flight_date>=to_date(h2.flight_date_s,'yyyy-mm-dd')
and h1.flight_date<=to_date(h2.flight_date_e,'yyyy-mm-dd')
left join dw.fr_segment_income_predict3 tp1 on tp1.segment_head_id=h1.segment_head_id
group by h1.flights_id,h1.flight_date,h1.route_name,h2.limit)h3
left join (select distinct tt2.route_name
              from dw.fact_combo_ticket tt1
              join dw.da_flight tt2 on tt1.segment_head_id=tt2.segment_head_id
              where tt2.flag<>2)h4 on h3.route_name=h4.route_name
group by h3.flight_date,h3.route_name,case when h4.route_name is not null then 1 else 0 end
