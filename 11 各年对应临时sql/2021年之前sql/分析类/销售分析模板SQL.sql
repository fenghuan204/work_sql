#销售分析模板
select t1.order_day,
    case when t1.channel in('网站','手机') then '线上自有渠道'
    when t1.channel in('OTA','旗舰店') then 'OTA'
    else '线下渠道' end 渠道,    
   case  when t1.channel in('手机','网站') then t1.sub_channel
   when t1.channel in('OTA','旗舰店') and t1.sub_channel in('同程','去哪儿','携程','淘宝') then t1.sub_channel
   when t1.channel in('OTA','旗舰店') then '其他OTA'
   else t1.channel end 渠道小类, 
       case when t1.channel in('手机','网站')
    and t4.users_id is not null then '代理'
    else '非代理' end 是否代理,
    to_char(t1.flights_date,'yyyymm') 航班月,
   case when t1.ahead_days<=3 then '00~03'
         when t1.ahead_days<=7 then '04~07'
       when t1.ahead_days<=15 then '08~15'
       when t1.ahead_days<=30 then '15~30'
       when t1.ahead_days<=60 then '31~60'
       when t1.ahead_days<=90 then '61~90'
       when t1.ahead_days> 90 then '90+' end 提前期,
       t1.seat_type 产品类型,
       case
         when t1.MIN_SEAT_NAME is null then
          '当前在售最低价'
         when t1.min_seat_price is null then
          '当前在售最低价'
         when round(t1.ticket_price,0)  = round(t1.min_seat_price * t1.rcd_rate,0) then
          '当前在售最低价'
         when round(t1.ticket_price,0)  > round(t1.min_seat_price * t1.rcd_rate,0) then
          '跳舱'
          when round(t1.ticket_price,0) < round(t1.min_seat_price * t1.rcd_rate,0) then '当前在售最低价'
       end 价格类型,
       t1.nationflag,t2.segment_country,t3.income_type,
       case when t2.flight_no in('9C6103','9C6104','9C6107','9C6108','9C6111','9C6112','9C6131','9C6132','9C6135','9C6136',
'9C6139','9C6140','9C8591','9C8592','9C8627','9C8628','9C8689','9C8690','9C8699','9C8700','9C8705','9C8706','9C8719','9C8720','9C8825','9C8826') then '加班航班'
else '正常航班' end 航班类型,
    case when instr(t3.wf_segment,'＝',1,2)>0 then split_part(t3.wf_segment,'＝',1)||'＝'||split_part(t3.wf_segment,'＝',3)
else t3.wf_segment end wf_segment,
t2.flights_segment_name,
 case when t1.sex=3 then '特殊舱位'
            when t1.seats_name in('P2','P3','P4','P5') then '活动舱'
            when t1.seats_name in('P','P1','R1','R2','R3','R4') then 'PR舱'
            when t1.seats_name in('E','U','X') then 'EUX舱'
            when t1.seats_name in('A','D','Z','I','J','O','W') then '特殊舱位'
            else '5折以上舱位' end  舱位,
      count(1) 机票数,
      sum(t1.ticket_price) 金额,
      sum(t1.insurce_fee+t1.other_fee) 辅收金额
 from dw.fact_recent_order_detail t1
 join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
 left join dw.da_restrict_userinfo t4 on t1.client_id=t4.users_id
 left join dw.dim_segment_type t3 on t2.h_route_id=t3.h_route_id and t2.route_id=t3.route_id
 where t2.flag<>2
   and t1.order_day>=trunc(sysdate-8)
   and t1.order_day< trunc(sysdate)   
   and t1.seats_name not in('B','G1','G2','G','O')
   and t1.flag_id in(3,5,40,41)
   and to_char(t1.order_day,'day') ='星期一'
   group by t1.order_day,
   case when t1.channel in('网站','手机') then '线上自有渠道'
    when t1.channel in('OTA','旗舰店') then 'OTA'
    else '线下渠道' end ,    
   case  when t1.channel in('手机','网站') then t1.sub_channel
   when t1.channel in('OTA','旗舰店') and t1.sub_channel in('同程','去哪儿','携程','淘宝') then t1.sub_channel
   when t1.channel in('OTA','旗舰店') then '其他OTA'
   else t1.channel end , 
       case when t1.channel in('手机','网站')
    and t4.users_id is not null then '代理'
    else '非代理' end ,   
   case when t1.ahead_days<=3 then '00~03'
         when t1.ahead_days<=7 then '04~07'
       when t1.ahead_days<=15 then '08~15'
       when t1.ahead_days<=30 then '15~30'
       when t1.ahead_days<=60 then '31~60'
       when t1.ahead_days<=90 then '61~90'
       when t1.ahead_days> 90 then '90+' end ,
       t1.nationflag,     
    case when instr(t3.wf_segment,'＝',1,2)>0 then split_part(t3.wf_segment,'＝',1)||'＝'||split_part(t3.wf_segment,'＝',3)
else t3.wf_segment end ,
t2.flights_segment_name,
 case when t1.sex=3 then '特殊舱位'
            when t1.seats_name in('P2','P3','P4','P5') then '活动舱'
            when t1.seats_name in('P','P1','R1','R2','R3','R4') then 'PR舱'
            when t1.seats_name in('E','U','X') then 'EUX舱'
            when t1.seats_name in('A','D','Z','I','J','O','W') then '特殊舱位'
            else '5折以上舱位' end,
            to_char(t1.flights_date,'yyyymm'),t2.segment_country,t3.income_type,
            t1.seat_type,
       case
         when t1.MIN_SEAT_NAME is null then
          '当前在售最低价'
         when t1.min_seat_price is null then
          '当前在售最低价'
         when round(t1.ticket_price,0)  = round(t1.min_seat_price * t1.rcd_rate,0) then
          '当前在售最低价'
         when round(t1.ticket_price,0)  > round(t1.min_seat_price * t1.rcd_rate,0) then
          '跳舱'
          when round(t1.ticket_price,0) < round(t1.min_seat_price * t1.rcd_rate,0) then '当前在售最低价'
       end ,
       case when t2.flight_no in('9C6103','9C6104','9C6107','9C6108','9C6111','9C6112','9C6131','9C6132','9C6135','9C6136',
'9C6139','9C6140','9C8591','9C8592','9C8627','9C8628','9C8689','9C8690','9C8699','9C8700','9C8705','9C8706','9C8719','9C8720','9C8825','9C8826') then '加班航班'
else '正常航班' end;