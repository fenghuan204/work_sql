select trunc(t.order_date) 订单日期,
       case
         when t1.ex_cfd2 = 'S' and t1.ex_nfd3 is not null then
          '商务经济座'
         when t1.ex_nfd10 is not null then
          '经济座'
         else
          '专享座'
       end 座位类型 ,
       t1.seats_name 舱位,
       t3.min_seat_name 在售最低舱位,
       t1.ticket_price 票价,
       t1.r_com_rate 汇率,
       t3.min_seat_price 在售最低价格,
       t3.rate 最低价格汇率,
       case
         when t3.MIN_SEAT_NAME is null then
          '当前在售最低价'
         when t3.min_seat_price is null then
          '当前在售最低价'
         when t3.MIN_SEAT_NAME = t1.seats_name and
              t1.ticket_price * t1.r_com_rate = t3.min_seat_price * t3.RATE then
          '当前在售最低价'
         when t1.ticket_price * t1.r_com_rate >= t3.min_seat_price * t3.RATE then
          '跳舱'
          when t1.ticket_price*t1.r_com_rate< t3.min_seat_price*t3.RATE and t1.seats_name in('P2','P5')  then 'P活动价'
       end 价格类型,
       count(1) 票量
  from cqsale.cq_order@to_air t
  join cqsale.cq_order_head@to_air t1 on t.flights_order_id =
                                         t1.flights_order_id
  join hdb.wb_agent_rcd t2 on t.client_id = t2.CLIENT_ID
  left join cqsale.cq_min_price_rcd@to_air t3 on t3.ORDER_HEAD_ID =
                                                 t1.flights_order_head_id
 where t1.flag_id in (3, 5, 40)
   and t.order_date >= trunc(sysdate - 3)
 group by trunc(t.order_date),
          case
            when t1.ex_cfd2 = 'S' and t1.ex_nfd3 is not null then
             '商务经济座'
            when t1.ex_nfd10 is not null then
             '经济座'
            else
             '专享座'
          end,
          case
            when t3.MIN_SEAT_NAME is null then
             '当前在售最低价'
            when t3.min_seat_price is null then
             '当前在售最低价'
            when t3.MIN_SEAT_NAME = t1.seats_name and
                 t1.ticket_price * t1.r_com_rate =
                 t3.min_seat_price * t3.RATE then
             '当前在售最低价'
            when t1.ticket_price * t1.r_com_rate >=
                 t3.min_seat_price * t3.RATE then
             '跳舱'
             when t1.ticket_price*t1.r_com_rate< t3.min_seat_price*t3.RATE and t1.seats_name in('P2','P5')  then 'P活动价'
          end,
          t1.seats_name,
          t3.min_seat_name,
          t1.ticket_price,
          t1.r_com_rate,
          t3.min_seat_price,
          t3.rate
