select case when t1.order_day >= to_date('2020-02-14','yyyy-mm-dd')
   and t1.order_day <=to_date('2020-02-20', 'yyyy-mm-dd') then '上周'
   when t1.order_day >= to_date('2020-02-21','yyyy-mm-dd')
   and t1.order_day <=to_date('2020-02-27', 'yyyy-mm-dd') then '本周' end 周类型, 
   '02'||to_char(t1.order_day,'dd'),
   case when t2.flights_segment_name like '%曼谷%' then '曼谷'
   when t2.flights_segment_name like '%普吉%' then '普吉'
   else '其他' end 航站类型,
   case when t2.origin_country_id>0 then '入境'
   else '出境' end 出入境类型,
   case when t1.IS_QU_HUI in(1,2) then '往返机票'
   else '单程'  end 往返程类型,
   case when t1.IS_QU_HUI in(1,2) and t6.flights_order_head_id is not null  then abs(t1.flights_date-t6.flights_date)
   else null end  往返天数,
case when t1.channel in('网站','手机') then '线上自有'
when t1.channel in('OTA','旗舰店') then 'OTA'
else '线下其他' end,
case
         when t1.ahead_days <= 3 then
          '00~03'
         when t1.ahead_days <= 7 then
          '04~07'
         when t1.ahead_days <= 15 then
          '08~15'
         when t1.ahead_days <= 30 then
          '15~30'
         when t1.ahead_days <= 60 then
          '31~60'
         when t1.ahead_days <= 90 then
          '61~90'
         when t1.ahead_days > 90 then
          '90+'
       end 提前期,
        t1.seat_type,
       t3.wf_segment,       
       case when t5.nationality like '%中国%' then '中国'
       when t5.nationality like '%泰国%' then '泰国'
       else '其他' end 国籍,       
       t1.gender 性别, 
       case when getage(t1.flights_date,t1.birthday)<12 then '<12'
            when getage(t1.flights_date,t1.birthday)<18 then '12~17'
            when getage(t1.flights_date,t1.birthday)<24 then '18~23'
            when getage(t1.flights_date,t1.birthday)<30 then '24~29'
            when getage(t1.flights_date,t1.birthday)<40 then '30~39'
            when getage(t1.flights_date,t1.birthday)<50 then '40~49'
            when getage(t1.flights_date,t1.birthday)<60 then '50~59'
            when getage(t1.flights_date,t1.birthday)<70 then '60~69'
            when getage(t1.flights_date,t1.birthday)>=70 then '70+' 
            else '-' end age,     
       count(1) 销量,
       sum(t1.ticket_price) 机票金额
  from dw.fact_recent_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id = t2.segment_head_id
  left  join dw.fact_recent_order_detail t6  on t1.WF_FLIGHTS_ORDER_HEAD_ID=t6.flights_order_head_id
  left join dw.dim_segment_type t3 on t2.h_route_id = t3.h_route_id
                                  and t2.route_id = t3.route_id
  left join dw.bi_order_region t5 on t1.flights_order_head_id=t5.flights_order_head_id
 where t1.order_day >= to_date('2020-02-14','yyyy-mm-dd')
   and t1.order_day <=to_date('2020-02-27', 'yyyy-mm-dd')
   and t1.whole_flight like '9C%'
   and t1.flag_id in(3,5,40,41)
   and t1.seats_name is not null
   and t2.segment_country='泰国'
   and t1.seats_name not in ('B', 'G', 'G1', 'G2', 'O')
 group by case when t1.order_day >= to_date('2020-02-14','yyyy-mm-dd')
   and t1.order_day <=to_date('2020-02-20', 'yyyy-mm-dd') then '上周'
   when t1.order_day >= to_date('2020-02-21','yyyy-mm-dd')
   and t1.order_day <=to_date('2020-02-27', 'yyyy-mm-dd') then '本周' end,
   case when t2.flights_segment_name like '%曼谷%' then '曼谷'
   when t2.flights_segment_name like '%普吉%' then '普吉'
   else '其他' end ,
   case when t2.origin_country_id>0 then '入境'
   else '出境' end ,
   case when t1.IS_QU_HUI in(1,2) then '往返机票'
   else '单程'  end ,
   case when t1.IS_QU_HUI in(1,2) and t6.flights_order_head_id is not null  then abs(t1.flights_date-t6.flights_date)
   else null end  ,
case when t1.channel in('网站','手机') then '线上自有'
when t1.channel in('OTA','旗舰店') then 'OTA'
else '线下其他' end,
case
         when t1.ahead_days <= 3 then
          '00~03'
         when t1.ahead_days <= 7 then
          '04~07'
         when t1.ahead_days <= 15 then
          '08~15'
         when t1.ahead_days <= 30 then
          '15~30'
         when t1.ahead_days <= 60 then
          '31~60'
         when t1.ahead_days <= 90 then
          '61~90'
         when t1.ahead_days > 90 then
          '90+'
       end ,
       t1.seat_type,
       t3.wf_segment,       
       case when t5.nationality like '%中国%' then '中国'
       when t5.nationality like '%泰国%' then '泰国'
       else '其他' end ,       
       t1.gender , 
       case when getage(t1.flights_date,t1.birthday)<12 then '<12'
            when getage(t1.flights_date,t1.birthday)<18 then '12~17'
            when getage(t1.flights_date,t1.birthday)<24 then '18~23'
            when getage(t1.flights_date,t1.birthday)<30 then '24~29'
            when getage(t1.flights_date,t1.birthday)<40 then '30~39'
            when getage(t1.flights_date,t1.birthday)<50 then '40~49'
            when getage(t1.flights_date,t1.birthday)<60 then '50~59'
            when getage(t1.flights_date,t1.birthday)<70 then '60~69'
            when getage(t1.flights_date,t1.birthday)>=70 then '70+' 
            else '-' end,  '02'||to_char(t1.order_day,'dd') 
      
union all




select case when t1.order_day >= to_date('2020-02-15','yyyy-mm-dd')
   and t1.order_day <=to_date('2020-02-21', 'yyyy-mm-dd') then '去年上周'
   when t1.order_day >= to_date('2020-02-22','yyyy-mm-dd')
   and t1.order_day <=to_date('2020-02-28', 'yyyy-mm-dd') then '去年本周' end 周类型, 
   '02'|| to_char(to_number(to_char(t1.order_day,'dd'))-1) 日期,
   case when t2.flights_segment_name like '%曼谷%' then '曼谷'
   when t2.flights_segment_name like '%普吉%' then '普吉'
   else '其他' end 航站类型,
   case when t2.origin_country_id>0 then '入境'
   else '出境' end 出入境类型,
   case when t1.IS_QU_HUI in(1,2) then '往返机票'
   else '单程'  end 往返程类型,
   case when t1.IS_QU_HUI in(1,2) and t6.flights_order_head_id is not null  then abs(t1.flights_date-t6.flights_date)
   else null end  往返天数,
case when t1.channel in('网站','手机') then '线上自有'
when t1.channel in('OTA','旗舰店') then 'OTA'
else '线下其他' end,
case
         when t1.ahead_days <= 3 then
          '00~03'
         when t1.ahead_days <= 7 then
          '04~07'
         when t1.ahead_days <= 15 then
          '08~15'
         when t1.ahead_days <= 30 then
          '15~30'
         when t1.ahead_days <= 60 then
          '31~60'
         when t1.ahead_days <= 90 then
          '61~90'
         when t1.ahead_days > 90 then
          '90+'
       end 提前期,
         t1.seat_type,
       t3.wf_segment,       
       case when t5.nationality like '%中国%' then '中国'
       when t5.nationality like '%泰国%' then '泰国'
       else '其他' end 国籍,       
       t1.gender 性别, 
       case when getage(t1.flights_date,t1.birthday)<12 then '<12'
            when getage(t1.flights_date,t1.birthday)<18 then '12~17'
            when getage(t1.flights_date,t1.birthday)<24 then '18~23'
            when getage(t1.flights_date,t1.birthday)<30 then '24~29'
            when getage(t1.flights_date,t1.birthday)<40 then '30~39'
            when getage(t1.flights_date,t1.birthday)<50 then '40~49'
            when getage(t1.flights_date,t1.birthday)<60 then '50~59'
            when getage(t1.flights_date,t1.birthday)<70 then '60~69'
            when getage(t1.flights_date,t1.birthday)>=70 then '70+' 
            else '-' end age,     
       count(1) 销量,
       sum(t1.ticket_price) 机票金额
  from dw.fact_recent_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id = t2.segment_head_id
  left  join dw.fact_recent_order_detail t6  on t1.WF_FLIGHTS_ORDER_HEAD_ID=t6.flights_order_head_id
  left join dw.dim_segment_type t3 on t2.h_route_id = t3.h_route_id
                                  and t2.route_id = t3.route_id
  left join dw.bi_order_region t5 on t1.flights_order_head_id=t5.flights_order_head_id
 where t1.order_day >= to_date('2019-02-15','yyyy-mm-dd')
   and t1.order_day <=to_date('2019-02-28', 'yyyy-mm-dd')
   and t1.whole_flight like '9C%'
   and t1.flag_id in(3,5,40,41)
   and t1.seats_name is not null
   and t2.segment_country='泰国'
   and t1.seats_name not in ('B', 'G', 'G1', 'G2', 'O')
 group by case when t1.order_day >= to_date('2020-02-15','yyyy-mm-dd')
   and t1.order_day <=to_date('2020-02-21', 'yyyy-mm-dd') then '去年上周'
   when t1.order_day >= to_date('2020-02-22','yyyy-mm-dd')
   and t1.order_day <=to_date('2020-02-28', 'yyyy-mm-dd') then '去年本周' end,  
   '02'|| to_char(to_number(to_char(t1.order_day,'dd'))-1) ,
   case when t2.flights_segment_name like '%曼谷%' then '曼谷'
   when t2.flights_segment_name like '%普吉%' then '普吉'
   else '其他' end ,
   case when t2.origin_country_id>0 then '入境'
   else '出境' end ,
   case when t1.IS_QU_HUI in(1,2) then '往返机票'
   else '单程'  end ,
   case when t1.IS_QU_HUI in(1,2) and t6.flights_order_head_id is not null  then abs(t1.flights_date-t6.flights_date)
   else null end  ,
case when t1.channel in('网站','手机') then '线上自有'
when t1.channel in('OTA','旗舰店') then 'OTA'
else '线下其他' end,
case
         when t1.ahead_days <= 3 then
          '00~03'
         when t1.ahead_days <= 7 then
          '04~07'
         when t1.ahead_days <= 15 then
          '08~15'
         when t1.ahead_days <= 30 then
          '15~30'
         when t1.ahead_days <= 60 then
          '31~60'
         when t1.ahead_days <= 90 then
          '61~90'
         when t1.ahead_days > 90 then
          '90+'
       end ,
         t1.seat_type,
       t3.wf_segment,       
       case when t5.nationality like '%中国%' then '中国'
       when t5.nationality like '%泰国%' then '泰国'
       else '其他' end ,       
       t1.gender , 
       case when getage(t1.flights_date,t1.birthday)<12 then '<12'
            when getage(t1.flights_date,t1.birthday)<18 then '12~17'
            when getage(t1.flights_date,t1.birthday)<24 then '18~23'
            when getage(t1.flights_date,t1.birthday)<30 then '24~29'
            when getage(t1.flights_date,t1.birthday)<40 then '30~39'
            when getage(t1.flights_date,t1.birthday)<50 then '40~49'
            when getage(t1.flights_date,t1.birthday)<60 then '50~59'
            when getage(t1.flights_date,t1.birthday)<70 then '60~69'
            when getage(t1.flights_date,t1.birthday)>=70 then '70+' 
            else '-' end;
			
	
select to_char(t2.flight_date,'yyyy') 年,to_char(t2.flight_date,'mmdd') 日期,
   case when t2.flights_segment_name like '%曼谷%' then '曼谷'
   when t2.flights_segment_name like '%普吉%' then '普吉'
   else '其他' end 航站类型,
   case when t2.origin_country_id>0 then '入境'
   else '出境' end 出入境类型,   
       t3.wf_segment,sum(t2.oversale) 座位数,      
       count(1) 航班量
  from  dw.da_flight t2 
  left join dw.dim_segment_type t3 on t2.h_route_id = t3.h_route_id
                                  and t2.route_id = t3.route_id
 where t2.flight_date >= to_date('2020-02-14','yyyy-mm-dd')
   and t2.flight_date <=to_date('2020-05-31', 'yyyy-mm-dd')
   and t2.flag<>2
   and t2.segment_country='泰国'
   group by to_char(t2.flight_date,'yyyy'),to_char(t2.flight_date,'mmdd'),
   case when t2.flights_segment_name like '%曼谷%' then '曼谷'
   when t2.flights_segment_name like '%普吉%' then '普吉'
   else '其他' end ,
   case when t2.origin_country_id>0 then '入境'
   else '出境' end ,   
       t3.wf_segment


      
union all




select to_char(t2.flight_date,'yyyy'),to_char(t2.flight_date,'mmdd'),
   case when t2.flights_segment_name like '%曼谷%' then '曼谷'
   when t2.flights_segment_name like '%普吉%' then '普吉'
   else '其他' end 航站类型,
   case when t2.origin_country_id>0 then '入境'
   else '出境' end 出入境类型,   
       t3.wf_segment,sum(t2.oversale),      
       count(1) 销量
  from  dw.da_flight t2 
  left join dw.dim_segment_type t3 on t2.h_route_id = t3.h_route_id
                                  and t2.route_id = t3.route_id
 where t2.flight_date >= to_date('2019-02-14','yyyy-mm-dd')
   and t2.flight_date <=to_date('2019-05-31', 'yyyy-mm-dd')
   and t2.flag<>2
   and t2.segment_country='泰国'
   group by to_char(t2.flight_date,'yyyy'),to_char(t2.flight_date,'mmdd'),
   case when t2.flights_segment_name like '%曼谷%' then '曼谷'
   when t2.flights_segment_name like '%普吉%' then '普吉'
   else '其他' end ,
   case when t2.origin_country_id>0 then '入境'
   else '出境' end ,   
       t3.wf_segment;
	   
	   
	   
	   
	   
	   
select /*+parallel(4) */
case when t1.order_day >= to_date('2020-02-14','yyyy-mm-dd')
   and t1.order_day <=to_date('2020-02-20', 'yyyy-mm-dd') then '上周'
   when t1.order_day >= to_date('2020-02-21','yyyy-mm-dd')
   and t1.order_day <=to_date('2020-02-27', 'yyyy-mm-dd') then '本周' end 周类型, 
   '02'||to_char(t1.order_day,'dd') 日期,
   case when t2.flights_segment_name like '%曼谷%' then '曼谷'
   when t2.flights_segment_name like '%普吉%' then '普吉'
   else '其他' end 航站类型,
   case when t2.origin_country_id>0 then '入境'
   else '出境' end 出入境类型,
   case when t1.IS_QU_HUI =1 then '去程'
   when t1.IS_QU_HUI =2 then '回程'
   else '单程'  end 往返程类型,
   case when t1.IS_QU_HUI in(1,2) and t6.flights_order_head_id is not null  then abs(t1.flights_date-t6.flights_date)
   else null end  往返天数,
case when t1.channel in('网站','手机') then '线上自有'
when t1.channel in('OTA','旗舰店') then 'OTA'
else '线下其他' end 渠道,
case
         when t1.ahead_days <= 3 then
          '00~03'
         when t1.ahead_days <= 7 then
          '04~07'
         when t1.ahead_days <= 15 then
          '08~15'
         when t1.ahead_days <= 30 then
          '15~30'
         when t1.ahead_days <= 60 then
          '31~60'
         when t1.ahead_days <= 90 then
          '61~90'
         when t1.ahead_days > 90 then
          '90+'
       end 提前期,
        t1.seat_type 座位类型,
       t3.wf_segment 往返航线,       
       case when t5.nationality like '%中国%' then '中国'
       when t5.nationality like '%泰国%' then '泰国'
       else '其他' end 国籍,       
       t1.gender 性别, 
       case when getage(t1.flights_date,t1.birthday)<12 then '<12'
            when getage(t1.flights_date,t1.birthday)<18 then '12~17'
            when getage(t1.flights_date,t1.birthday)<24 then '18~23'
            when getage(t1.flights_date,t1.birthday)<30 then '24~29'
            when getage(t1.flights_date,t1.birthday)<40 then '30~39'
            when getage(t1.flights_date,t1.birthday)<50 then '40~49'
            when getage(t1.flights_date,t1.birthday)<60 then '50~59'
            when getage(t1.flights_date,t1.birthday)<70 then '60~69'
            when getage(t1.flights_date,t1.birthday)>=70 then '70+' 
            else '-' end age,     
       count(1) 销量,
       sum(t1.ticket_price) 机票金额
  from dw.fact_recent_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id = t2.segment_head_id
  left  join dw.fact_recent_order_detail t6  on t1.WF_FLIGHTS_ORDER_HEAD_ID=t6.flights_order_head_id
  left join dw.dim_segment_type t3 on t2.h_route_id = t3.h_route_id
                                  and t2.route_id = t3.route_id
  left join dw.bi_order_region t5 on t1.flights_order_head_id=t5.flights_order_head_id
 where t1.order_day >= to_date('2020-02-14','yyyy-mm-dd')
   and t1.order_day <=to_date('2020-02-27', 'yyyy-mm-dd')
   and t1.whole_flight like '9C%'
   and t1.flag_id in(3,5,40,41)
   and t2.flag<>2
   and t1.seats_name is not null
   and t2.segment_country='泰国'
   and t1.seats_name not in ('B', 'G', 'G1', 'G2', 'O')
 group by case when t1.order_day >= to_date('2020-02-14','yyyy-mm-dd')
   and t1.order_day <=to_date('2020-02-20', 'yyyy-mm-dd') then '上周'
   when t1.order_day >= to_date('2020-02-21','yyyy-mm-dd')
   and t1.order_day <=to_date('2020-02-27', 'yyyy-mm-dd') then '本周' end,
   case when t2.flights_segment_name like '%曼谷%' then '曼谷'
   when t2.flights_segment_name like '%普吉%' then '普吉'
   else '其他' end ,
   case when t2.origin_country_id>0 then '入境'
   else '出境' end ,
   case when t1.IS_QU_HUI =1 then '去程'
   when t1.IS_QU_HUI =2 then '回程'
   else '单程'  end,
   case when t1.IS_QU_HUI in(1,2) and t6.flights_order_head_id is not null  then abs(t1.flights_date-t6.flights_date)
   else null end  ,
case when t1.channel in('网站','手机') then '线上自有'
when t1.channel in('OTA','旗舰店') then 'OTA'
else '线下其他' end,
case
         when t1.ahead_days <= 3 then
          '00~03'
         when t1.ahead_days <= 7 then
          '04~07'
         when t1.ahead_days <= 15 then
          '08~15'
         when t1.ahead_days <= 30 then
          '15~30'
         when t1.ahead_days <= 60 then
          '31~60'
         when t1.ahead_days <= 90 then
          '61~90'
         when t1.ahead_days > 90 then
          '90+'
       end ,
       t1.seat_type,
       t3.wf_segment,       
       case when t5.nationality like '%中国%' then '中国'
       when t5.nationality like '%泰国%' then '泰国'
       else '其他' end ,       
       t1.gender , 
       case when getage(t1.flights_date,t1.birthday)<12 then '<12'
            when getage(t1.flights_date,t1.birthday)<18 then '12~17'
            when getage(t1.flights_date,t1.birthday)<24 then '18~23'
            when getage(t1.flights_date,t1.birthday)<30 then '24~29'
            when getage(t1.flights_date,t1.birthday)<40 then '30~39'
            when getage(t1.flights_date,t1.birthday)<50 then '40~49'
            when getage(t1.flights_date,t1.birthday)<60 then '50~59'
            when getage(t1.flights_date,t1.birthday)<70 then '60~69'
            when getage(t1.flights_date,t1.birthday)>=70 then '70+' 
            else '-' end,  '02'||to_char(t1.order_day,'dd') 
      
union all




select case when t1.order_day >= to_date('2019-02-15','yyyy-mm-dd')
   and t1.order_day <=to_date('2019-02-21', 'yyyy-mm-dd') then '去年上周'
   when t1.order_day >= to_date('2019-02-22','yyyy-mm-dd')
   and t1.order_day <=to_date('2019-02-28', 'yyyy-mm-dd') then '去年本周' end 周类型, 
   '02'|| to_char(to_number(to_char(t1.order_day,'dd'))-1) 日期,
   case when t2.flights_segment_name like '%曼谷%' then '曼谷'
   when t2.flights_segment_name like '%普吉%' then '普吉'
   else '其他' end 航站类型,
   case when t2.origin_country_id>0 then '入境'
   else '出境' end 出入境类型,
   case when t1.IS_QU_HUI =1 then '去程'
   when t1.IS_QU_HUI =2 then '回程'
   else '单程'  end,
   case when t1.IS_QU_HUI in(1,2) and t6.flights_order_head_id is not null  then abs(t1.flights_date-t6.flights_date)
   else null end  往返天数,
case when t1.channel in('网站','手机') then '线上自有'
when t1.channel in('OTA','旗舰店') then 'OTA'
else '线下其他' end,
case
         when t1.ahead_days <= 3 then
          '00~03'
         when t1.ahead_days <= 7 then
          '04~07'
         when t1.ahead_days <= 15 then
          '08~15'
         when t1.ahead_days <= 30 then
          '15~30'
         when t1.ahead_days <= 60 then
          '31~60'
         when t1.ahead_days <= 90 then
          '61~90'
         when t1.ahead_days > 90 then
          '90+'
       end 提前期,
         t1.seat_type,
       t3.wf_segment,       
       case when t5.nationality like '%中国%' then '中国'
       when t5.nationality like '%泰国%' then '泰国'
       else '其他' end 国籍,       
       t1.gender 性别, 
       case when getage(t1.flights_date,t1.birthday)<12 then '<12'
            when getage(t1.flights_date,t1.birthday)<18 then '12~17'
            when getage(t1.flights_date,t1.birthday)<24 then '18~23'
            when getage(t1.flights_date,t1.birthday)<30 then '24~29'
            when getage(t1.flights_date,t1.birthday)<40 then '30~39'
            when getage(t1.flights_date,t1.birthday)<50 then '40~49'
            when getage(t1.flights_date,t1.birthday)<60 then '50~59'
            when getage(t1.flights_date,t1.birthday)<70 then '60~69'
            when getage(t1.flights_date,t1.birthday)>=70 then '70+' 
            else '-' end age,     
       count(1) 销量,
       sum(t1.ticket_price) 机票金额
  from dw.fact_recent_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id = t2.segment_head_id
  left  join dw.fact_recent_order_detail t6  on t1.WF_FLIGHTS_ORDER_HEAD_ID=t6.flights_order_head_id
  left join dw.dim_segment_type t3 on t2.h_route_id = t3.h_route_id
                                  and t2.route_id = t3.route_id
  left join dw.bi_order_region t5 on t1.flights_order_head_id=t5.flights_order_head_id
 where t1.order_day >= to_date('2019-02-15','yyyy-mm-dd')
   and t1.order_day <=to_date('2019-02-28', 'yyyy-mm-dd')
   and t1.whole_flight like '9C%'
   and t1.flag_id in(3,5,40,41)
  and t2.flag<>2
   and t1.seats_name is not null
   and t2.segment_country='泰国'
   and t1.seats_name not in ('B', 'G', 'G1', 'G2', 'O')
 group by case when t1.order_day >= to_date('2019-02-15','yyyy-mm-dd')
   and t1.order_day <=to_date('2019-02-21', 'yyyy-mm-dd') then '去年上周'
   when t1.order_day >= to_date('2019-02-22','yyyy-mm-dd')
   and t1.order_day <=to_date('2019-02-28', 'yyyy-mm-dd') then '去年本周' end,  
   '02'|| to_char(to_number(to_char(t1.order_day,'dd'))-1) ,
   case when t2.flights_segment_name like '%曼谷%' then '曼谷'
   when t2.flights_segment_name like '%普吉%' then '普吉'
   else '其他' end ,
   case when t2.origin_country_id>0 then '入境'
   else '出境' end ,
  case when t1.IS_QU_HUI =1 then '去程'
   when t1.IS_QU_HUI =2 then '回程'
   else '单程'  end,
   case when t1.IS_QU_HUI in(1,2) and t6.flights_order_head_id is not null  then abs(t1.flights_date-t6.flights_date)
   else null end  ,
case when t1.channel in('网站','手机') then '线上自有'
when t1.channel in('OTA','旗舰店') then 'OTA'
else '线下其他' end,
case
         when t1.ahead_days <= 3 then
          '00~03'
         when t1.ahead_days <= 7 then
          '04~07'
         when t1.ahead_days <= 15 then
          '08~15'
         when t1.ahead_days <= 30 then
          '15~30'
         when t1.ahead_days <= 60 then
          '31~60'
         when t1.ahead_days <= 90 then
          '61~90'
         when t1.ahead_days > 90 then
          '90+'
       end ,
         t1.seat_type,
       t3.wf_segment,       
       case when t5.nationality like '%中国%' then '中国'
       when t5.nationality like '%泰国%' then '泰国'
       else '其他' end ,       
       t1.gender , 
       case when getage(t1.flights_date,t1.birthday)<12 then '<12'
            when getage(t1.flights_date,t1.birthday)<18 then '12~17'
            when getage(t1.flights_date,t1.birthday)<24 then '18~23'
            when getage(t1.flights_date,t1.birthday)<30 then '24~29'
            when getage(t1.flights_date,t1.birthday)<40 then '30~39'
            when getage(t1.flights_date,t1.birthday)<50 then '40~49'
            when getage(t1.flights_date,t1.birthday)<60 then '50~59'
            when getage(t1.flights_date,t1.birthday)<70 then '60~69'
            when getage(t1.flights_date,t1.birthday)>=70 then '70+' 
            else '-' end