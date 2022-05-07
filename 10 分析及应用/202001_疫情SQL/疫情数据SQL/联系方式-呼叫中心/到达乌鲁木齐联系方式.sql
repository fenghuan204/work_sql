--麻烦提取一下明日乌鲁木齐到达所有航班的外籍旅客和中国籍港澳台旅客信息以及对应的联系方式（包括旅客本人和订单联系人）

select distinct case when getmobile(t1.r_tel)='-' then t1.r_tel
else getmobile(t1.r_tel) end 联系方式,t4.nationality,t5.codetype_name,t1.name||' '||coalesce(t1.second_name,'') 姓名
from cqsale.cq_order@to_air t
join  cqsale.cq_order_head@to_air  t1 on t.flights_order_id=t1.flights_order_Id
join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
join cqsale.cq_flights_segment_head@to_air t3 on t1.segment_head_id=t3.segment_head_id
left join cqsale.cq_traveller_info@to_air t4 on t1.flights_order_head_id=t4.flights_order_head_id
left join stg.s_cq_codetype t5 on t1.codetype=t5.codetype
left join stg.s_cq_country_area t6 on t4.nationality=t6.country_code
where t1.r_flights_date=trunc(sysdate)+1
and t3.flag<>2
and t1.flag_id in(3,5,40,41)
and t1.whole_flight like '9C%'
--and nvl(t4.nationality,'CHN')<>'CHN'
and t2.destairport_name='乌鲁木齐'


union

select   distinct case when getmobile(t.work_tel)='-' then t.work_tel
else getmobile(t.work_tel) end,t4.nationality,t5.codetype_name,t1.name||' '||coalesce(t1.second_name,'')
from cqsale.cq_order@to_air t
join  cqsale.cq_order_head@to_air  t1 on t.flights_order_id=t1.flights_order_Id
join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
join cqsale.cq_flights_segment_head@to_air t3 on t1.segment_head_id=t3.segment_head_id
left join cqsale.cq_traveller_info@to_air t4 on t1.flights_order_head_id=t4.flights_order_head_id
left join stg.s_cq_codetype t5 on t1.codetype=t5.codetype
left join stg.s_cq_country_area t6 on t4.nationality=t6.country_code
where t1.r_flights_date=trunc(sysdate)+1
and t3.flag<>2
and t1.flag_id in(3,5,40,41)
and t1.whole_flight like '9C%'
--and nvl(t4.nationality,'CHN')<>'CHN'
and t2.destairport_name='乌鲁木齐'
