select case when t1.combo_name like '%惠选%' then '惠选'
when t1.combo_name like '%精选%' then '精选'
when t1.combo_name like '%优选%' then '优选'
when t1.combo_name like '%儿童%' then '儿童' end,count(1),
sum(t1.combo_price)
 from dw.fact_unlimited_combo t1
 where combo_vision in('V2','V2.1')
 and STATUS in(0,1)
 group by case when t1.combo_name like '%惠选%' then '惠选'
when t1.combo_name like '%精选%' then '精选'
when t1.combo_name like '%优选%' then '优选'
when t1.combo_name like '%儿童%' then '儿童' end;




select  t3.xtype_name,sum(t3.book_num),sum(t3.book_fee),0
 from dw.fact_combo_ticket t1
 join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
 join dw.fact_other_order_detail t3 on t1.flights_order_head_id=t3.flights_order_head_id
 where t1.combo_vision ='套票2.0'
  and t1.r_flights_date>=to_date('2020-11-11','yyyy-mm-dd')
  and t1.r_flights_date< to_date('2021-01-14','yyyy-mm-dd')
  and t1.flag_id in(3,5,40,41)
  group by t3.xtype_name
  
  union all
  
  
  select  null,0,0,count(1)
 from dw.fact_combo_ticket t1
 join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
 where t1.combo_vision ='套票2.0'
  and t1.r_flights_date>=to_date('2020-11-11','yyyy-mm-dd')
  and t1.r_flights_date< to_date('2021-01-14','yyyy-mm-dd')
  and t1.flag_id in(3,5,40,41);
  

  
  
  
 select  t3.xtype_name,sum(t3.book_num),sum(t3.book_fee),0
 from dw.fact_order_detail t1
 join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
 join dw.fact_other_order_detail t3 on t1.flights_order_head_id=t3.flights_order_head_id
 where  t1.flights_date>=to_date('2020-11-11','yyyy-mm-dd')
  and t1.flights_date< to_date('2021-01-14','yyyy-mm-dd')
  and t1.flag_id in(3,5,40,41)
  and t1.company_id=0
  group by t3.xtype_name
  
  union all
  
  
  select  null,0,0,count(1)
 from dw.fact_order_detail t1
 join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
 where t1.flights_date>=to_date('2020-11-11','yyyy-mm-dd')
  and t1.flights_date< to_date('2021-01-14','yyyy-mm-dd')
  and t1.flag_id in(3,5,40,41)
  and t1.company_id=0;
  
  
  
  select  case when t3.flights_order_head_id_1 is not null then '中转'
  when t4.flights_order_head_id_2 is not null then '中转'
  when t5.flights_order_head_id1 is not null then '往返'
   when t6.flights_order_head_id2 is not null then '往返'
   else '单程' end,count(1)  
 from dw.fact_combo_ticket t1
 join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
 left join dw.bi_connect_segment t3 on t1.flights_order_head_id=t3.flights_order_head_id_1
 left join dw.bi_connect_segment t4 on t1.flights_order_head_id=t4.flights_order_head_id_2
 left join dw.fact_wf_segment t5 on t1.flights_order_head_id =t5.flights_order_head_id1
  left join dw.fact_wf_segment t6 on t1.flights_order_head_id =t6.flights_order_head_id2
 where t1.combo_vision ='套票2.0'
  and t1.r_flights_date>=to_date('2020-11-11','yyyy-mm-dd')
  and t1.r_flights_date< to_date('2021-01-14','yyyy-mm-dd')
  group by case when t3.flights_order_head_id_1 is not null then '中转'
  when t4.flights_order_head_id_2 is not null then '中转'
  when t5.flights_order_head_id1 is not null then '往返'
   when t6.flights_order_head_id2 is not null then '往返'
   else '单程' end;
   
  
  
  
  
    select  split_part(t3.flights_city_name_1,'－',2),count(1)
 from dw.fact_combo_ticket t1
 join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
 left join dw.bi_connect_segment t3 on t1.flights_order_head_id=t3.flights_order_head_id_1
 left join dw.bi_connect_segment t4 on t1.flights_order_head_id=t4.flights_order_head_id_2 
 where t1.combo_vision ='套票2.0'
  and t1.r_flights_date>=to_date('2020-11-11','yyyy-mm-dd')
  and t1.r_flights_date< to_date('2021-01-14','yyyy-mm-dd')
  and nvl(t3.codeno,t4.codeno) is not null
  group by  split_part(t3.flights_city_name_1,'－',2)
 
   
  
  

  
