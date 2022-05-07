currentTime
code_no
orderNo
flightsOrderHeadId


select t.order_date 机票销售日期,t1.r_flights_date 航班日期,t7.flights_segment_name 航段,t7.nationflag 航线性质,
case when t1.flag_id in(3,5,41,40) then '已销售'
else '已退票' end 机票状态,
case when t.terminal_id=-1 and t.web_id=0 then '线上自有'
when t.terminal_id=-1 and t.web_id>0 then 'OTA'
when t.terminal_id in
                (300, 1233, 1309, 1330, 1400, 1401, 1516, 1571, 1801, 1802, 1803, 1805, 1806, 1807, 1808, 3505) then '呼叫中心'
else ' 线下其他' end 机票销售渠道,
t.client_id 订单账号,t.users_id 订票操作人,t4.order_date 辅收购买日期,
case when t4.terminal_id in
                      (300, 1233, 1309, 1330, 1400, 1401, 1516, 1571, 1801, 1802, 1803, 1805, 1806, 1807, 1808, 3505) then '呼叫中心'
   when t4.terminal_id>0 then '线下其他'
   when t4.terminal_id<0 and t4.ext_1 >0 then 'OTA'
   when t4.terminal_id<0 and t4.ext_1 =0 then '线上自有' end 辅收购买渠道,
t5.users_id 辅收操作人号,t5.users_work_id 操作人姓名,
t4.pay_together+1 几次购买,
t6.xtype_name 产品名称, t3.book_price*t3.r_com_rate 价格         
 from cqsale.cq_order@to_air t
 join cqsale.cq_order_head@to_air t1 on t.flights_order_id=t1.flights_Order_id
 join cqsale.cq_flights_segment_head@to_air t2 on t1.segment_head_id=t2.segment_head_id
 join cqsale.cq_other_order_head@to_air t3 on t1.flights_order_head_id=t3.order_head_id
 join cqsale.cq_other_order@to_air t4 on t3.order_id=t4.order_id
 left join cqsale.cq_user@to_air  t5 on t4.users_id=t5.users_id 
 left join cqsale.cq_xtype@to_air t6 on t3.ex_nfd1=t6.xtype_id
 left join dw.da_flight t7 on t1.segment_head_id=t7.segment_head_id
 where  t1.r_flights_date>= to_date('2020-01-09','yyyy-mm-dd')
 and t1.flag_id in(3,5,40,41,7,11,12)
 and t1.whole_flight like '9C%'
 and t3.ex_nfd1 in(6,10,17)
and t1.name||coalesce(t1.second_name,'') like '吴%忠';
