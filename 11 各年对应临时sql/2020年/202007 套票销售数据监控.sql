select h1.createdate,h1.hour,h1.stype,h1.status,sum(ticketnum)
from(
select trunc(t1.create_date) createdate,
to_char(t1.create_date,'hh24') hour,
case when t1.COMBO_NAME='想飞就飞惠选礼包' then '普通座2999套票'
when t1.COMBO_NAME='想飞就飞精选礼包' then '经济座3499套票'
when t1.COMBO_NAME='想飞就飞优选礼包' then '商务座3999套票'
end stype,decode(t1.STATUS,0,'未兑换',1,'已兑换',2,'已退',3,'取消套票权益') status,
count(1) ticketnum
 from yhq.cq_yhq_unlimited_combo@to_air t1
 where t1.CREATE_DATE>=to_DATE('2020-07-15 18:00:00','yyyy-mm-dd hh24:mi:ss')
 and t1.combo_name in('想飞就飞惠选礼包','想飞就飞精选礼包','想飞就飞优选礼包')
 group by trunc(t1.create_date) ,
to_char(t1.create_date,'hh24') ,
case when t1.COMBO_NAME='想飞就飞惠选礼包' then '普通座2999套票'
when t1.COMBO_NAME='想飞就飞精选礼包' then '经济座3499套票'
when t1.COMBO_NAME='想飞就飞优选礼包' then '商务座3999套票'
end,decode(t1.STATUS,0,'未兑换',1,'已兑换',2,'已退',3,'取消套票权益'))h1
group by createdate,h1.hour,h1.stype,h1.status
 
select trunc(t1.r_order_date) 订单日期,
       t1.r_flights_date 航班日期,
       t2.flights_city_name 航线,
       t2.flight_no 航班好,
       h5.YHQ_MONEY 优惠金额,
       t1.flights_order_head_id 订单编号,
       case when t1.flag_id in(3,5,40,41) then '成功购票'
            when t1.flag_id in(7,11,12) then '退票' end 机票状态
  from yhq.cq_yhq_unlimited_combo@to_air t
  join yhq.cq_new_yhq_relation@to_air h3 on t.yhq_batch_id = h3.create_id and t.USER_ID=h3.USERS_ID  --这个关联，少条件
  join yhq.cq_new_yhq_history@to_air h4 on h4.yhq_id = h3.id
  join yhq.cq_new_yhq_history_detail@to_air h5 on h4.id = h5.history_id
  join cqsale.cq_order_head@to_air t1 on h5.order_head_id =t1.flights_order_head_id
  join dw.da_flight t2 on t1.segment_head_id = t2.segment_head_id 
 where t1.flag_id in (3, 5, 40, 41,7,11,12)
   and t1.r_order_date >= to_date('2020-07-15', 'yyyy-mm-dd')
   and t1.r_flights_date >= to_date('2020-07-15', 'yyyy-mm-dd')
   and t.create_date>=to_date('2020-07-15 18:00:00','yyyy-mm-dd hh24:mi:ss');
 
