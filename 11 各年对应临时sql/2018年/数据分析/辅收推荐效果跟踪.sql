#辅收立减优化

select order_day,station_id,sum(产品数) 产品数,sum(产品金额) 产品金额,sum(机票量)
from(
select t1.order_day ,t1.station_id ,suM(t1.book_num) 产品数,sum(t1.book_price) 产品金额,0 机票量
  from dw.fact_other_order_detail t1
 where t1.order_day >= to_date('2018-09-01', 'yyyy-mm-dd')
   and t1.order_day <  to_date('2018-11-26', 'yyyy-mm-dd')
   and t1.company_id = 0
   and t1.flag_id in (3, 5, 40, 41)
   and t1.xtype_id in(1,2,4,11,6,7,10,17,21)
   and t1.is_swj=0 
   and t1.EX_CFD3 is  null
   and t1.channel='手机'
   and t1.station_id not in(2,5)
   and t1.pay_together=0
   group by t1.order_day,t1.station_id   
  
 union all 
 
 select t1.order_day,t1.station_id,0,0,count(1) ticketnum
  from dw.fact_order_detail t1
  left join dw.da_restrict_userinfo t2 on t1.client_id=t2.users_id
 where t1.order_day >= to_date('2018-09-01', 'yyyy-mm-dd')
   and t1.order_day <  to_date('2018-11-26', 'yyyy-mm-dd')
   and t1.company_id = 0
   and t1.flag_id in (3, 5, 40, 41)
   and t1.is_swj=0 
   and t1.EX_CFD6 is  null
   and t1.seats_name is not null
   and t1.channel='手机'
   and t1.station_id not in(2,5)
   and t2.users_id is not null
   group by t1.order_day,t1.station_id)
   group by order_day,station_id;



  select order_day,sum(产品数) 产品数,sum(产品金额) 产品金额,sum(x1num),sum(x1price),
sum(x2num),sum(x2price),
sum(x3num),sum(x3price),sum(机票量)
from(
select t1.order_day ,suM(t1.book_num) 产品数,sum(t1.book_price) 产品金额,
suM(case when t1.xtype_id in(1,2,4,11) then t1.book_num else 0 end) x1num,
suM(case when t1.xtype_id in(6,10,17) then t1.book_num else 0 end) x2num,
suM(case when t1.xtype_id in(7,21) then t1.book_num else 0 end) x3num,
suM(case when t1.xtype_id in(1,2,4,11) then t1.book_price else 0 end) x1price,
suM(case when t1.xtype_id in(6,10,17) then t1.book_price else 0 end) x2price,
suM(case when t1.xtype_id in(7,21) then t1.book_price else 0 end) x3price,
0 机票量
  from dw.fact_other_order_detail t1
 where t1.order_day >= to_date('2018-09-01', 'yyyy-mm-dd')
   and t1.order_day <  to_date('2018-11-26', 'yyyy-mm-dd')
   and t1.company_id = 0
   and t1.flag_id in (3, 5, 40, 41)
   and t1.xtype_id in(1,2,4,11,6,7,10,17,21)
   and t1.xtype_id not in(6,10,17)
   and t1.is_swj=0 
   and t1.EX_CFD3 is  null
   and t1.channel='手机'
   and t1.station_id not in(2,5)
   and t1.pay_together=0
   group by t1.order_day  
  
 union all 
 
 select t1.order_day,0,0,0,0,0,0,0,0,count(1) ticketnum
  from dw.fact_order_detail t1
  left join dw.da_restrict_userinfo t2 on t1.client_id=t2.users_id
 where t1.order_day >= to_date('2018-09-01', 'yyyy-mm-dd')
   and t1.order_day <  to_date('2018-11-26', 'yyyy-mm-dd')
   and t1.company_id = 0
   and t1.flag_id in (3, 5, 40, 41)
   and t1.is_swj=0 
   and t1.EX_CFD6 is  null
   and t1.seats_name is not null
   and t1.channel='手机'
   and t1.station_id not in(2,5)
   and t2.users_id is not null
   group by t1.order_day)
   group by order_day;



   



