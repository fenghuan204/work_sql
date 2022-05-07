select t.flights_Order_id 订单号,t1.whole_flight 航班号,t1.r_flights_date 航班日期,t1.whole_segment 航段,
       t1.name||coalesce(t1.second_name,'') 姓名,t1.r_tel 紧急人联系方式,t.work_tel 联系电话,t.email 邮箱
 from cqsale.cq_order@to_air t 
 join cqsale.cq_order_head@to_air t1 on t.flights_order_id=t1.flights_order_id
 join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
 where t1.r_flights_date>=to_date('2021-09-05','yyyy-mm-dd')
   and t1.r_flights_date<=to_date('2021-09-10','yyyy-mm-dd')
   and t1.whole_flight like '9C%'
   and t2.flights_segment_name like '浦东%三亚'
   and t1.flag_id in(3,5,40)

