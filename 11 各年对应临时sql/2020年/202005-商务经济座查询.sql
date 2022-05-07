select t1.is_swj,t1.flights_order_head_id||',',t1.flights_order_id,t1.ticket_price,t1.change_flag,t2.segment_head_id,t1.SUB_SEAT,t1.seat_type,
t1.COMB_FEE,t2.flag
 from dw.fact_recent_order_detail t1
 join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
 where t1.flights_order_id ='TQRFPU'

 
 t1.flights_order_id ='VNJCRC'
 and t1.is_swj=1;
 
 select *
  from dw.da_order_change t1
  where t1.flights_order_id='VNJCRC'
 
 
 
 select t1.*
 from cqsale.cq_super_seat_upgrade_record@to_air t1
 --join dw.fact_recent_order_detail t2 on t1.flights_order_head_id=t2.flights_order_head_id 
 where t1.flights_order_head_id in(201588886,
201588887,
201588888,
201588922,
201588923,
201588885)


select decode(t1.SALE_TYPE,0,'购票旅客',1,'赠送旅客',2,'VIP旅客',3,'包销升级',4,'普通升级',5,'其他升级',6,
'航班变更') 商务座类型,t1.*
  from cqsale.CQ_SS_SALE_STATIC@to_air t1
  where flights_order_id ='TQRFPU'
  
  -- SALE_TYPE
  0购票旅客,1赠送旅客,2VIP旅客,3包销升级,4普通升级,5其他升级,6航班变更
  
  

  
 
select *
 from cqsale.cq_flights_segment_head@to_air
 where segment_head_id ='1407189'
 
 
 select *
  from cqsale.cq_flights_modify_history@to_air t1
  where flights_id_old=1225844
  
 select
  
  
  select *
   from cqsale.CQ_SUB_CABIN_SEGMENT_HEAD@to_air t2
   where segment_head_id =1407189
   and main_cabin='P1'
   
   
   select tt1.order_date,tt1.main_order_date,tt1.channel,tt1.pay_together,tt1.seats_name,tt1.book_fee,tt2.channel
    from dw.fact_other_order_detail tt1
    join dw.fact_order_detail tt2 on tt1.flights_order_head_id=tt2.flights_order_head_id
    where tt1.flights_order_head_id in(201588886,
201588887,
201588888,
201588922,
201588923,
201588885)
