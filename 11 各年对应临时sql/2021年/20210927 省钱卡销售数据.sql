select trunc(to_date(t1.CREATE_TIME,'yyyy-mm-dd hh24:mi:ss')) order_day, to_char(to_date(t1.CREATE_TIME,'yyyy-mm-dd hh24:mi:ss'),'hh24') ordertime,
decode(t1.ORDER_STATUS,401,'已预定',402,'已售', 403,'已完成',404,'已取消',405,'超时取消',406,'申请退款',407,'退款中',408,'已退款') orderstatus,
decode(t1.pay_id,44,'微信',25,'支付宝',58,'春秋白花花') 支付方式,
sum(sales_num) sales_num,sum(order_price/100) price
 from  hdb.ec_order_goods t1
 where t1.goods_id=11
 and to_date(t1.CREATE_TIME,'yyyy-mm-dd hh24:mi:ss')>=trunc(sysdate)
 and t1.create_time>='2021-09-27 09:40:00'
 group by trunc(to_date(t1.CREATE_TIME,'yyyy-mm-dd hh24:mi:ss')) , to_char(to_date(t1.CREATE_TIME,'yyyy-mm-dd hh24:mi:ss'),'hh24') ,
decode(t1.ORDER_STATUS,401,'已预定',402,'已售', 403,'已完成',404,'已取消',405,'超时取消',406,'申请退款',407,'退款中',408,'已退款') ,
decode(t1.pay_id,44,'微信',25,'支付宝',58,'春秋白花花')
order by 1,2
