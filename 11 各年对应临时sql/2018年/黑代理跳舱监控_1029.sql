select trunc(t.order_date) ��������,
       case
         when t1.ex_cfd2 = 'S' and t1.ex_nfd3 is not null then
          '���񾭼���'
         when t1.ex_nfd10 is not null then
          '������'
         else
          'ר����'
       end ��λ���� ,
       t1.seats_name ��λ,
       t3.min_seat_name ������Ͳ�λ,
       t1.ticket_price Ʊ��,
       t1.r_com_rate ����,
       t3.min_seat_price ������ͼ۸�,
       t3.rate ��ͼ۸����,
       case
         when t3.MIN_SEAT_NAME is null then
          '��ǰ������ͼ�'
         when t3.min_seat_price is null then
          '��ǰ������ͼ�'
         when t3.MIN_SEAT_NAME = t1.seats_name and
              t1.ticket_price * t1.r_com_rate = t3.min_seat_price * t3.RATE then
          '��ǰ������ͼ�'
         when t1.ticket_price * t1.r_com_rate >= t3.min_seat_price * t3.RATE then
          '����'
          when t1.ticket_price*t1.r_com_rate< t3.min_seat_price*t3.RATE and t1.seats_name in('P2','P5')  then 'P���'
       end �۸�����,
       count(1) Ʊ��
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
             '���񾭼���'
            when t1.ex_nfd10 is not null then
             '������'
            else
             'ר����'
          end,
          case
            when t3.MIN_SEAT_NAME is null then
             '��ǰ������ͼ�'
            when t3.min_seat_price is null then
             '��ǰ������ͼ�'
            when t3.MIN_SEAT_NAME = t1.seats_name and
                 t1.ticket_price * t1.r_com_rate =
                 t3.min_seat_price * t3.RATE then
             '��ǰ������ͼ�'
            when t1.ticket_price * t1.r_com_rate >=
                 t3.min_seat_price * t3.RATE then
             '����'
             when t1.ticket_price*t1.r_com_rate< t3.min_seat_price*t3.RATE and t1.seats_name in('P2','P5')  then 'P���'
          end,
          t1.seats_name,
          t3.min_seat_name,
          t1.ticket_price,
          t1.r_com_rate,
          t3.min_seat_price,
          t3.rate
