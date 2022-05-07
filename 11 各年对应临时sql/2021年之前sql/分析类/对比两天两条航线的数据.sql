select 
T1.ORDER_DAY,case when t1.channel='手机' and t1.station_id=2 then 'M网站'
    when t1.channel='手机' and t1.station_id in(5,10) then '微信'
    else channel end 渠道,
      t1.sub_channel,   
/*   case when t1.ahead_days<=3 then '00-03'
         when t1.ahead_days<=7 then '04-07'
       when t1.ahead_days<=15 then '08-15'
       when t1.ahead_days<=30 then '15-30'
       when t1.ahead_days<=60 then '31-60'
       when t1.ahead_days<=90 then '61-90'
       when t1.ahead_days> 90 then '90+' end 提前期,*/
       t1.nationflag,
t2.flights_segment_name,
 case when t1.is_swj=1 then '商务座'
 when t1.EX_CFD6 is not null then '经济座'
 when t1.sex=3 then 'YE'
            when t1.seats_name in('P2','P3','P4','P5') then '活动舱'
            when t1.seats_name in('P','P1','R1','R2','R3','R4') then 'PR舱'
            when t1.seats_name in('E','U','X') then 'EUX舱'
            when t1.seats_name in('A','D','Z','I','J','O') then '特殊舱位'
            else '5折以上舱位' end  舱位,
      count(1) 机票数,
      sum(t1.ticket_price) 金额,
      sum(t1.insurce_fee+t1.other_fee) 辅收金额
 from dw.fact_order_detail t1
 join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
 left join dw.da_restrict_userinfo t4 on t1.client_id=t4.users_id
 left join dw.dim_segment_type t3 on t2.h_route_id=t3.h_route_id and t2.route_id=t3.route_id
 where t2.flag<>2
   and t1.order_day>=trunc(SYSDATE-8)
   and t1.order_day<=trunc(SYSDATE-1)
   AND T1.SEATS_NAME IS NOT NULL
   and t1.company_id=0
   and t1.channel in('OTA','旗舰店')
   and t1.seats_name not in('B','G','G1','G2','O')
   and to_char(t1.order_day,'day') in('星期二')
   group by T1.ORDER_DAY,case when t1.channel='手机' and t1.station_id=2 then 'M网站'
    when t1.channel='手机' and t1.station_id in(5,10) then '微信'
    else channel end ,
      t1.sub_channel,   
/*   case when t1.ahead_days<=3 then '00-03'
         when t1.ahead_days<=7 then '04-07'
       when t1.ahead_days<=15 then '08-15'
       when t1.ahead_days<=30 then '15-30'
       when t1.ahead_days<=60 then '31-60'
       when t1.ahead_days<=90 then '61-90'
       when t1.ahead_days> 90 then '90+' end ,*/
        t1.nationflag,
t2.flights_segment_name,
 case when t1.is_swj=1 then '商务座'
 when t1.EX_CFD6 is not null then '经济座'
 when t1.sex=3 then 'YE'
            when t1.seats_name in('P2','P3','P4','P5') then '活动舱'
            when t1.seats_name in('P','P1','R1','R2','R3','R4') then 'PR舱'
            when t1.seats_name in('E','U','X') then 'EUX舱'
            when t1.seats_name in('A','D','Z','I','J','O') then '特殊舱位'
            else '5折以上舱位' end
  
  
