select *
  from CQSALE.CQ_CARD99_ORDER_RECORD@to_air r
  right join hdb.ec_order_goods t1 on r.card_id = t1.goods_order_num
 --where r.if_usable = 1
 
 
 select *
  from CQSALE.CQ_CARD99_ORDER_RECORD@to_air r
 --- where r.if_use


select t1.combo_order_no,t1.combo_name,t1.combo_id,t1.status,t1.combo_price,t1.OBTAIN_GATE,trunc(t1.ORDER_DATE) order_day,
t2.*
from yhq.CQ_TJK_COMBO@to_air t1
right join hdb.ec_order_goods t2 on t1.combo_order_no=t2.goods_order_num and t2.goods_id=11 and t2.order_status in(401,402,403)
and t2.create_time>='2021-09-27 09:40:00'
where --t2.goods_order_num is null 
t1.combo_order_no is null
and t2.goods_id=11


1538241129348

select *
 from dba_tab_comments@to_air
 where comments like '%ÌØ¼Û¿¨%'
 
 
 select distinct goods_id
  from hdb.ec_order_goods  t1
  

  
