select t2.flights_order_head_id,
       t7.youhui_result �Żݹ���_�Żݽ��,
       t8.youhui_result �Żݹ���_��������,
       t9.yhq_money �Ż�ȯ���ý��,
       t10.discount_count �����Ƽ��������,
       t11.point_money ����֧�����
  from cqsale.cq_order_head@to_air t2
--��Ʊ��Ʒ�Żݹ���
  left join (select t6.flights_order_head_id,
                    sum(YOUHUI_RESULT) youhui_result
               from cust.cq_order_youhui_detail@to_air t6
              where t6.product_type = 0
              group by t6.flights_order_head_id) t7 on t7.flights_order_head_id =
                                                       t2.flights_order_head_id
---�������������������Ǽ��ڻ�Ʊ��Ʒ�ϣ�
  left join (select t6.order_head_id, sum(DISCOUNT_AMOUNT) youhui_result
               from cqsale.CQ_INSURANCE_DISCOUNT_HISTORY@to_air t6
              where t6.type = 1
                and DISCOUNT_TYPE = 0
              group by t6.order_head_id) t8 on t8.order_head_id =
                                               t2.flights_order_head_id
---�Ż�ȯ����
  left join (select ORDER_HEAD_ID, sum(yhq_money) yhq_money
               from yhq.cq_new_yhq_history_detail@to_air
              group by ORDER_HEAD_ID) t9 on t9.order_head_id =
                                            t2.flights_order_head_id
---�����Ƽ�����
  left join (select tb2.order_head_id,
                    suM(tb1.discount_count) discount_count
               from cqsale.cq_order_xprod_discount@to_air tb1
               join cqsale.cq_other_order_head@to_air tb2 on tb1.other_order_head_id =
                                                     tb2.other_order_head_id
              where tb2.flag_id in (3, 5, 40, 7, 11, 12)
              group by tb2.order_head_id) t10 on t10.order_head_id =
                                                 t2.flights_order_head_id
--����֧��
  left join (select flights_order_head_id, sum(h1.ticket_price) point_money
               from cqsale.cq_btc_order_head@to_air h1
              where h1.pay_gate = '35' --����֧��
                and h1.order_type in ('0', '1', '2')
              group by flights_order_head_id) t11 on t11.flights_order_head_id =
                                                     t2.flights_order_head_id
 where t2.r_order_date>=trunc(sysdate)
