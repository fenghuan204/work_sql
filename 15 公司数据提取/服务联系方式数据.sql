
---麻烦老师提取8月2日-16日所有乌鲁木齐始发（乌鲁木齐西安单独拉取）旅客订单号 姓名 紧急联系电话/联系电话/邮箱@冯喜欢 
--谢谢 之后每天12点发12点至次日12点新增旅客信息 

select distinct t.flights_order_id 订单号,t1.name||' '||coalesce(t1.second_name,'') 姓名,
t.work_tel 联系电话,t1.r_tel 紧急联系电话,t.email 邮箱
from cqsale.cq_order@to_air t
join cqsale.cq_order_head@to_air t1 on t.flights_order_id=t1.flights_order_id
join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
where t1.r_flights_date>=to_date('2020-08-02','yyyy-mm-dd')
and t1.r_flights_date<=to_date('2020-08-16','yyyy-mm-dd')
--and to_char(t1.r_flights_date,'yyyymmdd') in('20200811','20200818','20200825')
 --and t1.whole_flight='9C8580'
 and t2.originairport_name='乌鲁木齐'
 and t2.destairport_name<>'西安'
 and t1.flag_id in(3,5,40,41)
 and t1.whole_flight like '9C%'
  
  
  ---乌鲁木齐出港及进港数据
  ---麻烦老师提取8月2日-16日所有乌鲁木齐西安段旅客订单号 姓名 紧急联系电话/联系电话/邮箱@冯喜欢 
  --谢谢 之后每天12点发12点至次日12点新增旅客信息 
  
select distinct t.flights_order_id 订单号,t1.name||' '||coalesce(t1.second_name,'') 姓名,
t.work_tel 联系电话,t1.r_tel 紧急联系电话,t.email 邮箱
from cqsale.cq_order@to_air t
join cqsale.cq_order_head@to_air t1 on t.flights_order_id=t1.flights_order_id
join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
where t1.r_flights_date>=to_date('2020-08-02','yyyy-mm-dd')
and t1.r_flights_date<=to_date('2020-08-16','yyyy-mm-dd')
--and to_char(t1.r_flights_date,'yyyymmdd') in('20200811','20200818','20200825')
 --and t1.whole_flight='9C8580'
 and t2.originairport_name='乌鲁木齐'
 and t2.destairport_name='西安'
 and t1.flag_id in(3,5,40,41)
 and t1.whole_flight like '9C%';
 
 
 
 ---麻烦老师提取8月2日-16日所有乌鲁木齐始发（乌鲁木齐西安单独拉取）旅客订单号 姓名 紧急联系电话/联系电话/邮箱@冯喜欢 
--谢谢 之后每天12点发12点至次日12点新增旅客信息 

select distinct t.flights_order_id 订单号,t1.name||' '||coalesce(t1.second_name,'') 姓名,
t.work_tel 联系电话,t1.r_tel 紧急联系电话,t.email 邮箱
from cqsale.cq_order@to_air t
join cqsale.cq_order_head@to_air t1 on t.flights_order_id=t1.flights_order_id
join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
where t1.r_flights_date>=to_date('2020-07-25','yyyy-mm-dd')
and t1.r_flights_date<=to_date('2020-08-09','yyyy-mm-dd')
--and to_char(t1.r_flights_date,'yyyymmdd') in('20200811','20200818','20200825')
 --and t1.whole_flight='9C8580'
 and t2.destairport_name='乌鲁木齐'
 and t1.flag_id in(3,5,40,41)
 and t1.whole_flight like '9C%'
