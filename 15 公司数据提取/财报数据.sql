1、	线上自有渠道的 交易量、交易额、以及线上自有渠道占所有B2C渠道的比例
2、	主营业务的比例是多少？电商业务的比例是多少？
3、	这个平台的营收占比是多少？
4、	企业营收增长多少？电商营收增长多少？
5、	线下门店有多少家？分布在多少城市？

select /*+parallel(4) */ 
to_char(t1.flights_date,'yyyy') 航年,
case when t1.channel in('网站','手机')   then '线上自有渠道'
when t1.channel in('OTA','旗舰店')  then 'OTA'
else '其他' end 渠道,count(distinct t1.flights_order_id)  订单量,
sum(case when t1.seats_name is not null then 1 else 0 end) 乘机人次,
sum(t1.ticket_price+t1.ad_fy) 机票收入,
sum(t1.ticket_price+t1.ad_fy+t1.port_pay+t1.other_fy+t1.sx_fy) 机票交易额,
sum(t1.insurce_fee+t1.other_fee) 辅收收入
  from  dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  where t1.flights_date>=to_date('20170101','yyyymmdd')
  and t1.flights_date< to_date('20190101','yyyymmdd')
  and t1.company_id=0
  and t1.flag_id =40
  group by to_char(t1.flights_date,'yyyy'),
case when t1.channel in('网站','手机')   then '线上自有渠道'
when t1.channel in('OTA','旗舰店')  then 'OTA'
else '其他' end 
  
  
  
  select 
t1.channel,count(1),sum(count(1))over(partition by 1)
 from dw.fact_order_detail t1
 join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
 where t1.flights_date>=to_date('2018-01-01','yyyy-mm-dd')
   and t1.flights_date< to_date('2019-01-01','yyyy-mm-dd')
   and t1.flag_id=40
   and t1.seats_name is not null
   and t1.seats_name not in('B','G','G1','G2','O')
   and t1.company_id=0
   group by t1.channel
   
   
   
   select 
t1.channel,count(1)
 from dw.fact_order_detail t1
 join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
 where t1.flights_date>=to_date('2018-01-01','yyyy-mm-dd')
   and t1.flights_date< to_date('2019-01-01','yyyy-mm-dd')
   and t1.flag_id=40
   and t1.seats_name is not null
   and t1.channel='手机'
   and t1.station_id in(5,10)
   and t1.seats_name not in('B','G','G1','G2','O')
   and t1.company_id=0
   group by t1.channel
