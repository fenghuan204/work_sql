--麻烦提供订票日期在今日12点前所有泰国曼谷，韩国济州出发的旅客联系方式和邮箱@冯喜欢

select  case when getmobile(t1.r_tel)='-' then t1.r_tel
else getmobile(t1.r_tel) end 联系方式
from cqsale.cq_order@to_air t
join  cqsale.cq_order_head@to_air  t1 on t.flights_order_id=t1.flights_order_Id
join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
join cqsale.cq_flights_segment_head@to_air t3 on t1.segment_head_id=t3.segment_head_id
where t.order_date>=trunc(sysdate)-1+12/24
and t.order_date<trunc(sysdate)+12/24
and t3.flag<>2
and t1.r_flights_date>=trunc(sysdate)
and t1.r_flights_date< to_date('2020-05-01','yyyy-mm-dd')
and t3.origin_std>sysdate
and t1.flag_id in(3,5,41)
and t1.whole_flight like '9C%'
and t1.r_tel is not null
and t2.origin_country_id>0
and regexp_like(t2.originairport_name,'(曼谷)|(济州)')


union 
select  
 case when getmobile(t.work_tel)='-' then t.work_tel
else getmobile(t.work_tel) end
from cqsale.cq_order@to_air t
join  cqsale.cq_order_head@to_air  t1 on t.flights_order_id=t1.flights_order_Id
join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
join cqsale.cq_flights_segment_head@to_air t3 on t1.segment_head_id=t3.segment_head_id
where t.order_date>=trunc(sysdate)-1+12/24
and t.order_date<trunc(sysdate)+12/24
and t3.flag<>2
and t1.r_flights_date>=trunc(sysdate)
and t1.r_flights_date< to_date('2020-05-01','yyyy-mm-dd')
and t3.origin_std>sysdate
and t1.flag_id in(3,5,41)
and t1.whole_flight like '9C%'
and t2.origin_country_id>0
and t.work_tel is not null
and regexp_like(t2.originairport_name,'(曼谷)|(济州)')
