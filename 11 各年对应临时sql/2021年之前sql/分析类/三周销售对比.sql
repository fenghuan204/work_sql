select case
         when t1.order_day >= to_date('2018-10-22', 'yyyy-mm-dd') and
              t1.order_day <= to_date('2018-10-28', 'yyyy-mm-dd') then
          '上上周'       
         when t1.order_day >= to_date('2018-10-29', 'yyyy-mm-dd') and
              t1.order_day <= to_date('2018-11-04', 'yyyy-mm-dd') then
          '上周'       
         when t1.order_day >= to_date('2018-11-05', 'yyyy-mm-dd') and
              t1.order_day <= to_date('2018-11-11', 'yyyy-mm-dd') then
          '本周'
       end 周类型,
       
       case
         when t1.channel = '手机' and t1.station_id = 2 then
          'M网站'
         when t1.channel = '手机' and t1.station_id in (5, 10) then
          '微信'
         else
          channel
       end 渠道,
       case
         when t1.channel in ('网站', '手机') and t3.users_id is not null then
          '代理'
         else
          '非代理'
       end 是否代理,
       
       case
         when t1.ahead_days <= 3 then
          '00-03'
         when t1.ahead_days <= 7 then
          '04-07'
         when t1.ahead_days <= 15 then
          '08-15'
         when t1.ahead_days <= 30 then
          '15-30'
         when t1.ahead_days <= 60 then
          '31-60'
         when t1.ahead_days <= 90 then
          '61-90'
         when t1.ahead_days > 90 then
          '90+'
       end 提前期,
       t2.area_type 航线性质,
       case
         when instr(t4.wf_segment, '＝', 1, 2) > 0 then
          split_part(t4.wf_segment, '＝', 1) || '＝' ||
          split_part(t4.wf_segment, '＝', 3)
         else
          t4.wf_segment
       end wf_segment,
       t2.flights_segment_name 航线,
       case
         when t2.flights_city_name like '上海%' then
          '上海出港'
         when t2.flights_city_name like '%上海' then
          '上海进港'
         else
          '其他'
       end 上海进出港,
       t1.seat_type,
       case when t1.seats_name ='P2' then '双十一活动舱'
         when t1.seats_name in ('P2', 'P3', 'P4', 'P5') then
          '其他活动舱'
         when t1.seats_name in ('P', 'P1', 'R1', 'R2', 'R3', 'R4') then
          'PR舱'
         when t1.seats_name in ('E', 'U', 'X') then
          'EUX舱'
         when t1.sex = 3 then
          '特殊舱位'
         when t1.seats_name in ('A', 'D', 'Z', 'I', 'J', 'O', 'W') then
          '特殊舱位'
         else
          '5折以上舱位'
       end 舱位,
       count(1) 机票数,
       sum(t1.ticket_price) 金额
  from dw.fact_recent_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id = t2.segment_head_id
  left join dw.da_restrict_userinfo t3 on t1.client_id = t3.users_id
  left join dw.dim_segment_type t4 on t2.h_route_id = t4.h_route_id
                                  and t2.route_id = t4.route_id
 where t2.flag <> 2
   and t1.order_day >= to_date('2018-10-22', 'yyyy-mm-dd')
   and t1.order_day <= to_date('2018-11-11', 'yyyy-mm-dd')
   AND T1.SEATS_NAME IS NOT NULL
   and t1.flag_Id in (3, 5, 40)
   and t1.seats_name not in ('B', 'G', 'G1', 'G2', 'O')
 group by case
            when t1.order_day >= to_date('2018-10-22', 'yyyy-mm-dd') and
                 t1.order_day <= to_date('2018-10-28', 'yyyy-mm-dd') then
             '上上周'
          
            when t1.order_day >= to_date('2018-10-29', 'yyyy-mm-dd') and
                 t1.order_day <= to_date('2018-11-04', 'yyyy-mm-dd') then
             '上周'
          
            when t1.order_day >= to_date('2018-11-05', 'yyyy-mm-dd') and
                 t1.order_day <= to_date('2018-11-11', 'yyyy-mm-dd') then
             '本周'
          end ,          
          case
            when t1.channel = '手机' and t1.station_id = 2 then
             'M网站'
            when t1.channel = '手机' and t1.station_id in (5, 10) then
             '微信'
            else
             channel
          end ,
          case
            when t1.channel in ('网站', '手机') and t3.users_id is not null then
             '代理'
            else
             '非代理'
          end,          
          case
            when t1.ahead_days <= 3 then
             '00-03'
            when t1.ahead_days <= 7 then
             '04-07'
            when t1.ahead_days <= 15 then
             '08-15'
            when t1.ahead_days <= 30 then
             '15-30'
            when t1.ahead_days <= 60 then
             '31-60'
            when t1.ahead_days <= 90 then
             '61-90'
            when t1.ahead_days > 90 then
             '90+'
          end,
          t2.area_type,
          case
            when instr(t4.wf_segment, '＝', 1, 2) > 0 then
             split_part(t4.wf_segment, '＝', 1) || '＝' ||
             split_part(t4.wf_segment, '＝', 3)
            else
             t4.wf_segment
          end ,
          t2.flights_segment_name,
          case
            when t2.flights_city_name like '上海%' then
             '上海出港'
            when t2.flights_city_name like '%上海' then
             '上海进港'
            else
             '其他'
          end,
          t1.seat_type,
          case when t1.seats_name ='P2' then '双十一活动舱'
         when t1.seats_name in ('P2', 'P3', 'P4', 'P5') then
          '其他活动舱'
            when t1.seats_name in ('P', 'P1', 'R1', 'R2', 'R3', 'R4') then
             'PR舱'
            when t1.seats_name in ('E', 'U', 'X') then
             'EUX舱'
            when t1.sex = 3 then
             '特殊舱位'
            when t1.seats_name in ('A', 'D', 'Z', 'I', 'J', 'O', 'W') then
             '特殊舱位'
            else
             '5折以上舱位'
          end
