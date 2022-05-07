select case
          when t1.order_day >= to_date('2018-09-24', 'yyyy-mm-dd')
          and t1.order_day <  to_date('2018-10-01', 'yyyy-mm-dd') then
          '0924~0930'
         when t1.order_day >= to_date('2018-10-01', 'yyyy-mm-dd')
          and t1.order_day <  to_date('2018-10-08', 'yyyy-mm-dd') then
          '1001~1008'
         when t1.order_day >= to_date('2018-10-08', 'yyyy-mm-dd')
          and t1.order_day <  to_date('2018-10-15', 'yyyy-mm-dd') then
          '1008~1014'       
       end 对比日期,       
       case
         when t1.channel in ('手机', '网站') and t3.users_id is not null then
          '线上黑代'
         when t1.channel in ('手机', '网站') then '线上直销'
         when t1.channel in('B2B', '呼叫中心', 'B2G机构客户') then '线下直销'
         when t1.channel in ('OTA', '旗舰店') then
          'OTA旗舰店'
         when t1.channel in ('B2B代理') then
          'B2B代理'
       end 渠道大类,
       case
         when t1.channel = '手机' and t1.station_id = 2 then
          'M网站'
         when t1.channel = '手机' and t1.station_id in (5, 10) then
          '微信'
         when t1.channel = '手机' and t1.station_id in (3, 8) then
          'IOS'
         when t1.channel = '手机' and t1.station_id in (4, 9) then
          'Andriod'
         else
          t1.channel
       end 渠道,
       t2.nationflag 航线性质,
       case
         when t1.seats_name in ('B', 'G', 'G1', 'O') then
          'BGO'
         else
          '非BGO'
       end 舱位类型,
       t2.flights_segment_name,
       count(1) 销量,
       sum(t1.ticket_price) 机票金额,
       sum(t1.price) 民航公布价和
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id = t2.segment_head_id
  left join dw.da_restrict_userinfo t3 on t1.client_id = t3.users_id
 where t1.order_day >= to_date('2018-09-24', 'yyyy-mm-dd')
   and t1.order_day < to_date('2018-10-15', 'yyyy-mm-dd')
   and t2.flag <> 2
   and t1.whole_flight like '9C%'
   and t1.seats_name is not null
 group by case
          when t1.order_day >= to_date('2018-09-24', 'yyyy-mm-dd')
          and t1.order_day <  to_date('2018-10-01', 'yyyy-mm-dd') then
          '0924~0930'
         when t1.order_day >= to_date('2018-10-01', 'yyyy-mm-dd')
          and t1.order_day <  to_date('2018-10-08', 'yyyy-mm-dd') then
          '1001~1008'
         when t1.order_day >= to_date('2018-10-08', 'yyyy-mm-dd')
          and t1.order_day <  to_date('2018-10-15', 'yyyy-mm-dd') then
          '1008~1014'       
       end ,       
       case
         when t1.channel in ('手机', '网站') and t3.users_id is not null then
          '线上黑代'
         when t1.channel in ('手机', '网站') then '线上直销'
         when t1.channel in('B2B', '呼叫中心', 'B2G机构客户') then '线下直销'
         when t1.channel in ('OTA', '旗舰店') then
          'OTA旗舰店'
         when t1.channel in ('B2B代理') then
          'B2B代理'
       end ,
       case
         when t1.channel = '手机' and t1.station_id = 2 then
          'M网站'
         when t1.channel = '手机' and t1.station_id in (5, 10) then
          '微信'
         when t1.channel = '手机' and t1.station_id in (3, 8) then
          'IOS'
         when t1.channel = '手机' and t1.station_id in (4, 9) then
          'Andriod'
         else
          t1.channel
       end ,
       t2.nationflag ,
       case
         when t1.seats_name in ('B', 'G', 'G1', 'O') then
          'BGO'
         else
          '非BGO'
       end ,
       t2.flights_segment_name
