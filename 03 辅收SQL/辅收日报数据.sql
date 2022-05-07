select     case when t1.flights_date>=to_date('2018-06-01','yyyy-mm-dd') 
                and t1.flights_date< to_date('2018-11-01','yyyy-mm-dd') then '201806~201810'
                else to_char(t1.flights_date,'yyyymm') end flightmonth,
                
 case
         when t1.channel = '手机' and t1.station_id in (2, 6) then
          'M网站'
         when t1.channel = '手机' and t1.station_id in (3, 8) then
          'IOS'
         when t1.channel = '手机' and t1.station_id in (4, 9) then
          '安卓'
         when t1.channel = '手机' and t1.station_id in (5, 10) then
          '微信'
         else
          t1.channel
       end 渠道,
       decode(t1.pay_together, 0, '一次', 1, '二次') 购买场景,
       case
         when t.channel in ('网站', '手机') and r.users_id is not null then
          '代理'
         else
          '非代理'
       end 是否代理,
       t1.nationflag 航线性质,
        case
         when t1.seats_name in ('B', 'G', 'G1', 'G2') then
          'BG'
         else
          'notBG'
       end 团散,
       case
         when s.s_id > 50 then
          '五折以上'
         else
          '五折及以下'
       end 舱位分类,
       case
         when t.is_swj = 1 then
          '商务座'
         when t.ex_cfd6 is not null then
          '经济座'
         else
          '官网专享'
       end 机票类型,
       case
         when t1.pay_together = 0 then
          '00h'
         when (t1.order_date - t.order_date) * 24 <= 2 then
          '(00,02]h'
         when (t1.order_date - t.order_date) * 24 <= 3 then
          '(02,03]h'
         when (t1.order_date - t.order_date) * 24 <= 18 then
          '(03,18]h'
         when (t1.order_date - t.order_date) * 24 <= 24 then
          '(18,24]h'
         when (t1.order_date - t.order_date) * 24 <= 36 then
          '(24,36]h'
         else
          '(36,+)h'
       end 购买间隔,
       case
         when t2.origin_std <= t1.order_date then
          '00h'
         when (t2.origin_std - t1.order_date) * 24 <= 2 then
          '(00,02]h'
         when (t2.origin_std - t1.order_date) * 24 <= 3 then
          '(02,03]h'
         when (t2.origin_std - t1.order_date) * 24 <= 18 then
          '(03,18]h'
         when (t2.origin_std - t1.order_date) * 24 <= 24 then
          '(18,24]h'
         when (t2.origin_std - t1.order_date) * 24 <= 36 then
          '(24,36]h'
         when (t2.origin_std - t1.order_date) * 24 <= 48 then
          '(36,48]h'
         when t2.origin_std - t1.order_date <= 3 then
          '(2,3]d'
         when t2.origin_std - t1.order_date <= 5 then
          '(3,5]d'
         when t2.origin_std - t1.order_date <= 7 then
          '(5,7]d'
         else
          '(7,+)d'
       end 辅收提前期,
       case
         when e.flights_order_id is not null then
          '含7岁及以下儿童'
         else
          '不含7岁及以下儿童'
       end 是否含儿童,
       case
         when t1.xtype_id in (1, 2, 4, 11) then
          '保险'
         when t1.xtype_id = 3 then
          '线上选座'
         when t1.xtype_id in (6, 10, 17) then
          '线上行李'
         when t1.xtype_id = 7 then
          '线上餐食'
         when t1.xtype_id = 16 then
          '接送机'
         when t1.xtype_id = 18 then
          '快递'
         when t1.xtype_id = 20 then
          '贵宾室服务'
         when t1.xtype_id = 21 and
              regexp_like(upper(t1.xproduct_name),
                          '(WIFI)|(WF)|(4G)|(上网卡)') then
          'WIFI'
         when t1.xtype_id = 21 and t1.xproduct_name like '%代办登机牌%' then
          '代办登机牌'
         else
          '其他'
       end 辅收大类,
       case
         when t1.xtype_id in (6, 10, 17) then
          t1.luggage_weight
         else
          null
       end 行李重量,
       case
         when t1.xtype_id = 3 then
          to_number(regexp_substr(t1.seat_no, '[0-9]+'))
         else
          null
       end 选座排数,
       0 机票数,
       sum(t1.book_num) 辅收数量,
       sum(t1.book_fee) 辅收金额
  from dw.fact_other_order_detail t1
  join dw.da_flight t2 on t2.segment_head_id = t1.segment_head_id
  join dw.fact_order_detail t on t.flights_order_head_id =
                                 t1.flights_order_head_id
  left join (select distinct flights_order_id
               from dw.fact_order_detail
              where flights_date >= to_date('2018-06-01','yyyy-mm-dd')
                and getage(flights_date, birthday) >= 0
                and getage(flights_date, birthday) < 7) e on e.flights_order_id =
                                                             t1.flights_order_id
  left join dw.da_restrict_userinfo r on r.users_id = t.client_id
  left join stg.s_cq_flights_seats_sequence s on s.if_open = 1
                                             and s.seats_name =
                                                 t1.seats_name
 where t1.company_id = 0
   and t1.flights_date >= to_date('2018-06-01','yyyy-mm-dd')
   and t1.flights_date < to_date('2019-04-01','yyyy-mm-dd')
   and t1.xtype_id not in (24, 25)
 group by case when t1.flights_date>=to_date('2018-06-01','yyyy-mm-dd') 
                and t1.flights_date< to_date('2018-11-01','yyyy-mm-dd') then '201806~201810'
                else to_char(t1.flights_date,'yyyymm') end,
          case
            when t1.channel = '手机' and t1.station_id in (2, 6) then
             'M网站'
            when t1.channel = '手机' and t1.station_id in (3, 8) then
             'IOS'
            when t1.channel = '手机' and t1.station_id in (4, 9) then
             '安卓'
            when t1.channel = '手机' and t1.station_id in (5, 10) then
             '微信'
            else
             t1.channel
          end,
          decode(t1.pay_together, 0, '一次', 1, '二次'),
          case
            when t.channel in ('网站', '手机') and r.users_id is not null then
             '代理'
            else
             '非代理'
          end,
          t1.nationflag,
          case
            when t1.seats_name in ('B', 'G', 'G1', 'G2') then
             'BG'
            else
             'notBG'
          end,
          case
            when s.s_id > 50 then
             '五折以上'
            else
             '五折及以下'
          end,
          case
            when t.is_swj = 1 then
             '商务座'
            when t.ex_cfd6 is not null then
             '经济座'
            else
             '官网专享'
          end,
          case
            when t1.pay_together = 0 then
             '00h'
            when (t1.order_date - t.order_date) * 24 <= 2 then
             '(00,02]h'
            when (t1.order_date - t.order_date) * 24 <= 3 then
             '(02,03]h'
            when (t1.order_date - t.order_date) * 24 <= 18 then
             '(03,18]h'
            when (t1.order_date - t.order_date) * 24 <= 24 then
             '(18,24]h'
            when (t1.order_date - t.order_date) * 24 <= 36 then
             '(24,36]h'
            else
             '(36,+)h'
          end,
          case
            when t2.origin_std <= t1.order_date then
             '00h'
            when (t2.origin_std - t1.order_date) * 24 <= 2 then
             '(00,02]h'
            when (t2.origin_std - t1.order_date) * 24 <= 3 then
             '(02,03]h'
            when (t2.origin_std - t1.order_date) * 24 <= 18 then
             '(03,18]h'
            when (t2.origin_std - t1.order_date) * 24 <= 24 then
             '(18,24]h'
            when (t2.origin_std - t1.order_date) * 24 <= 36 then
             '(24,36]h'
            when (t2.origin_std - t1.order_date) * 24 <= 48 then
             '(36,48]h'
            when t2.origin_std - t1.order_date <= 3 then
             '(2,3]d'
            when t2.origin_std - t1.order_date <= 5 then
             '(3,5]d'
            when t2.origin_std - t1.order_date <= 7 then
             '(5,7]d'
            else
             '(7,+)d'
          end,
          case
            when e.flights_order_id is not null then
             '含7岁及以下儿童'
            else
             '不含7岁及以下儿童'
          end,
          case
            when t1.xtype_id in (1, 2, 4, 11) then
             '保险'
            when t1.xtype_id = 3 then
             '线上选座'
            when t1.xtype_id in (6, 10, 17) then
             '线上行李'
            when t1.xtype_id = 7 then
             '线上餐食'
            when t1.xtype_id = 16 then
             '接送机'
            when t1.xtype_id = 18 then
             '快递'
            when t1.xtype_id = 20 then
             '贵宾室服务'
            when t1.xtype_id = 21 and
                 regexp_like(upper(t1.xproduct_name),
                             '(WIFI)|(WF)|(4G)|(上网卡)') then
             'WIFI'
            when t1.xtype_id = 21 and t1.xproduct_name like '%代办登机牌%' then
             '代办登机牌'
            else
             '其他'
          end,
          case
            when t1.xtype_id in (6, 10, 17) then
             t1.luggage_weight
            else
             null
          end,
          case
            when t1.xtype_id = 3 then
             to_number(regexp_substr(t1.seat_no, '[0-9]+'))
            else
             null
          end

union all

select case when t1.flights_date>=to_date('2018-06-01','yyyy-mm-dd')
                and t1.flights_date< to_date('2018-11-01','yyyy-mm-dd') then '201806~201810'
                else to_char(t1.flights_date,'yyyymm') end,
       case
         when t1.channel = '手机' and t1.station_id in (2, 6) then
          'M网站'
         when t1.channel = '手机' and t1.station_id in (3, 8) then
          'IOS'
         when t1.channel = '手机' and t1.station_id in (4, 9) then
          '安卓'
         when t1.channel = '手机' and t1.station_id in (5, 10) then
          '微信'
         else
          t1.channel
       end 渠道,
       '机票' 购买场景,
       case
         when t1.channel in ('网站', '手机') and r.users_id is not null then
          '代理'
         else
          '非代理'
       end 是否代理,
       t1.nationflag 航线性质,
       case
         when t1.seats_name in ('B', 'G', 'G1', 'G2') then
          'BG'
         else
          'notBG'
       end 团散,
       case
         when s.s_id > 50 then
          '五折以上'
         else
          '五折及以下'
       end 舱位分类,
       case
         when t1.is_swj = 1 then
          '商务座'
         when t1.ex_cfd6 is not null then
          '经济座'
         else
          '官网专享'
       end 机票类型,
       null 购买间隔,
       null 辅收提前期,
       case
         when e.flights_order_id is not null then
          '含7岁及以下儿童'
         else
          '不含7岁及以下儿童'
       end 是否含儿童,
       '机票' 辅收大类,
       null 行李重量,
       null 选座排数,
       sum(case
             when t1.seats_name is not null then
              1
             else
              0
           end) 机票数,
       0 辅收数量,
       0 辅收金额
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t2.segment_head_id = t1.segment_head_id
  left join (select distinct flights_order_id
               from dw.fact_order_detail
              where flights_date >= to_date('2018-06-01','yyyy-mm-dd') - 30
                and getage(flights_date, birthday) >= 0
                and getage(flights_date, birthday) < 7) e on e.flights_order_id =
                                                             t1.flights_order_id
  left join dw.da_restrict_userinfo r on r.users_id = t1.client_id
  left join stg.s_cq_flights_seats_sequence s on s.if_open = 1
                                             and s.seats_name =
                                                 t1.seats_name
 where t1.company_id = 0
     and t1.flights_date >= to_date('2018-06-01','yyyy-mm-dd')
   and t1.flights_date <    to_date('2019-04-01','yyyy-mm-dd')
 group by case when t1.flights_date>=to_date('2018-06-01','yyyy-mm-dd')
                and t1.flights_date< to_date('2018-11-01','yyyy-mm-dd') then '201806~201810'
                else to_char(t1.flights_date,'yyyymm') end,
          case
            when t1.channel = '手机' and t1.station_id in (2, 6) then
             'M网站'
            when t1.channel = '手机' and t1.station_id in (3, 8) then
             'IOS'
            when t1.channel = '手机' and t1.station_id in (4, 9) then
             '安卓'
            when t1.channel = '手机' and t1.station_id in (5, 10) then
             '微信'
            else
             t1.channel
          end,
          case
            when t1.channel in ('网站', '手机') and r.users_id is not null then
             '代理'
            else
             '非代理'
          end,
          t1.nationflag,
          case
            when t1.seats_name in ('B', 'G', 'G1', 'G2') then
             'BG'
            else
             'notBG'
          end,
          case
            when s.s_id > 50 then
             '五折以上'
            else
             '五折及以下'
          end,
          case
            when t1.is_swj = 1 then
             '商务座'
            when t1.ex_cfd6 is not null then
             '经济座'
            else
             '官网专享'
          end,
          case
            when e.flights_order_id is not null then
             '含7岁及以下儿童'
            else
             '不含7岁及以下儿童'
          end

union all

select case when nvl(to_date(l.flight_date, 'yyyymmdd'), l.order_day)>=to_date('2018-06-01','yyyy-mm-dd')
and nvl(to_date(l.flight_date, 'yyyymmdd'), l.order_day)< to_date('2018-11-01','yyyy-mm-dd') then '201806~201810'
else to_char(nvl(to_date(l.flight_date, 'yyyymmdd'), l.order_day),'yyyymm') end flightmonth,

      
       '客舱' 渠道,
       '二次' 购买场景,
       null 是否代理,
       t2.nationflag 航线性质,
       null 团散,
       null 舱位分类,
       null 机票类型,
       null 购买间隔,
       '起飞后' 辅收提前期,
       null 是否含儿童,
       case
         when l.category = 3 then
          '机上跨境'
         when l.merchant_name = '上海春秋中免免税品有限公司' then
          '机上免税品'
         when l.type_name in ('餐食', '小吃', '饮料') then
          '机上' || l.type_name
         else
          '机上其他'
       end 辅收大类,
       null 行李重量,
       null 选座排数,
       0 机票数,
       sum(l.booknum) 辅收数量,
       sum(l.bookfee) 辅收金额
  from dw.fact_prt_order_detail l
  left join stg.s_cq_foc_landfee f on f.day_flight_id = l.day_flight_id
  left join dw.da_flight t2 on t2.flight_no = substr(f.flights_no, 1, 6)
                           and trunc(t2.origin_std) = f.flights_date
                           and t2.segment_code = f.flights_segment
 where l.order_day >= to_date('2018-06-01','yyyy-mm-dd')-30
   and nvl(to_date(l.flight_date, 'yyyymmdd'), l.order_day) >=
       to_date('2018-06-01','yyyy-mm-dd')
   and nvl(to_date(l.flight_date, 'yyyymmdd'), l.order_day) <
       to_date('2019-04-01','yyyy-mm-dd')
   and l.flight_no like '9C%'
   and l.status in ('200', '300', '301', '400', '500')
 group by case when nvl(to_date(l.flight_date, 'yyyymmdd'), l.order_day)>=to_date('2018-06-01','yyyy-mm-dd')
and nvl(to_date(l.flight_date, 'yyyymmdd'), l.order_day)< to_date('2018-11-01','yyyy-mm-dd') then '201806~201810'
else to_char(nvl(to_date(l.flight_date, 'yyyymmdd'), l.order_day),'yyyymm') end,
          t2.nationflag,
           case
            when l.category = 3 then
             '机上跨境'
            when l.merchant_name = '上海春秋中免免税品有限公司' then
             '机上免税品'
            when l.type_name in ('餐食', '小吃', '饮料') then
             '机上' || l.type_name
            else
             '机上其他'
          end

union all

select case when t1.flights_date>=to_date('2018-06-01','yyyy-mm-dd')
                and t1.flights_date< to_date('2018-11-01','yyyy-mm-dd') then '201806~201810'
                else to_char(t1.flights_date,'yyyymm') end,
       
       '地面' 渠道,
       '二次' 购买场景,
       case
         when t1.channel in ('网站', '手机') and r.users_id is not null then
          '代理'
         else
          '非代理'
       end 是否代理,
       t1.nationflag 航线性质,
       case
         when t1.seats_name in ('B', 'G', 'G1', 'G2') then
          'BG'
         else
          'notBG'
       end 团散,
       case
         when s.s_id > 50 then
          '五折以上'
         else
          '五折及以下'
       end 舱位分类,
       case
         when t1.is_swj = 1 then
          '商务座'
         when t1.ex_cfd6 is not null then
          '经济座'
         else
          '官网专享'
       end 机票类型,
       null 购买间隔,
       '起飞前' 辅收提前期,
       case
         when e.flights_order_id is not null then
          '含7岁及以下儿童'
         else
          '不含7岁及以下儿童'
       end 是否含儿童,
       '线下行李' 辅收大类,
       b.pay_weight 行李重量,
       null 选座排数,
       0 机票数,
       count(1) 辅收数量,
       sum(b.feebag) 辅收金额
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t2.segment_head_id = t1.segment_head_id
  join (select flights_order_head_id,
               sum(pay_weight) pay_weight,
               sum(fee_bag) feebag
          from dw.fact_dcs_money_detail
         where flights_date >= to_date('2018-06-01','yyyy-mm-dd') - 7
           and fee_bag <> 0
         group by flights_order_head_id) b on b.flights_order_head_id =
                                              t1.flights_order_head_id
  left join (select distinct flights_order_id
               from dw.fact_order_detail
              where flights_date >=to_date('2018-06-01','yyyy-mm-dd') - 30
                and getage(flights_date, birthday) >= 0
                and getage(flights_date, birthday) < 7) e on e.flights_order_id =
                                                             t1.flights_order_id
  left join dw.da_restrict_userinfo r on r.users_id = t1.client_id
  left join stg.s_cq_flights_seats_sequence s on s.if_open = 1
                                             and s.seats_name =
                                                 t1.seats_name
 where t1.company_id = 0
   and t1.flights_date >= to_date('2018-06-01','yyyy-mm-dd')
   and t1.flights_date <  to_date('2019-04-01','yyyy-mm-dd')
 group by case when t1.flights_date>=to_date('2018-06-01','yyyy-mm-dd')
                and t1.flights_date< to_date('2018-11-01','yyyy-mm-dd') then '201806~201810'
                else to_char(t1.flights_date,'yyyymm') end,
          case
            when t1.channel in ('网站', '手机') and r.users_id is not null then
             '代理'
            else
             '非代理'
          end,
          t1.nationflag,
          case
            when t1.seats_name in ('B', 'G', 'G1', 'G2') then
             'BG'
            else
             'notBG'
          end,
          case
            when s.s_id > 50 then
             '五折以上'
            else
             '五折及以下'
          end,
          case
            when t1.is_swj = 1 then
             '商务座'
            when t1.ex_cfd6 is not null then
             '经济座'
            else
             '官网专享'
          end,
          case
            when e.flights_order_id is not null then
             '含7岁及以下儿童'
            else
             '不含7岁及以下儿童'
          end,
          b.pay_weight

union all

select case when t1.flights_date>=to_date('2018-06-01','yyyy-mm-dd')
                and t1.flights_date< to_date('2018-11-01','yyyy-mm-dd') then '201806~201810'
                else to_char(t1.flights_date,'yyyymm') end,
      
       '地面' 渠道,
       '二次' 购买场景,
       case
         when t1.channel in ('网站', '手机') and r.users_id is not null then
          '代理'
         else
          '非代理'
       end 是否代理,
       t1.nationflag 航线性质,
       case
         when t1.seats_name in ('B', 'G', 'G1', 'G2') then
          'BG'
         else
          'notBG'
       end 团散,
       case
         when s.s_id > 50 then
          '五折以上'
         else
          '五折及以下'
       end 舱位分类,
       case
         when t1.is_swj = 1 then
          '商务座'
         when t1.ex_cfd6 is not null then
          '经济座'
         else
          '官网专享'
       end 机票类型,
       null 购买间隔,
       '起飞前' 辅收提前期,
       case
         when e.flights_order_id is not null then
          '含7岁及以下儿童'
         else
          '不含7岁及以下儿童'
       end 是否含儿童,
       '线下选座' 辅收大类,
       null 行李重量,
       k.rr 选座排数,
       0 机票数,
       count(1) 辅收数量,
       sum(k.feekdj) 辅收金额
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t2.segment_head_id = t1.segment_head_id
  join (select flights_order_head_id,
               max(to_number(regexp_substr(seat_no, '[0-9]+'))) rr,
               sum(fee_kdj) feekdj
          from dw.fact_dcs_money_detail
         where flights_date >= to_date('2018-06-01','yyyy-mm-dd') - 7
           and fee_kdj <> 0
         group by flights_order_head_id) k on k.flights_order_head_id =
                                              t1.flights_order_head_id
  left join (select distinct flights_order_id
               from dw.fact_order_detail
              where flights_date >= to_date('2018-06-01','yyyy-mm-dd') - 30
                and getage(flights_date, birthday) >= 0
                and getage(flights_date, birthday) < 7) e on e.flights_order_id =
                                                             t1.flights_order_id
  left join dw.da_restrict_userinfo r on r.users_id = t1.client_id
  left join stg.s_cq_flights_seats_sequence s on s.if_open = 1
                                             and s.seats_name =
                                                 t1.seats_name
 where t1.company_id = 0
   and t1.flights_date >= to_date('2018-06-01','yyyy-mm-dd')
   and t1.flights_date < to_date('2019-04-01','yyyy-mm-dd')
 group by case when t1.flights_date>=to_date('2018-06-01','yyyy-mm-dd')
                and t1.flights_date< to_date('2018-11-01','yyyy-mm-dd') then '201806~201810'
                else to_char(t1.flights_date,'yyyymm') end,
         
          case
            when t1.channel in ('网站', '手机') and r.users_id is not null then
             '代理'
            else
             '非代理'
          end,
          t1.nationflag,
          case
            when t1.seats_name in ('B', 'G', 'G1', 'G2') then
             'BG'
            else
             'notBG'
          end,
          case
            when s.s_id > 50 then
             '五折以上'
            else
             '五折及以下'
          end,
          case
            when t1.is_swj = 1 then
             '商务座'
            when t1.ex_cfd6 is not null then
             '经济座'
            else
             '官网专享'
          end,
          case
            when e.flights_order_id is not null then
             '含7岁及以下儿童'
            else
             '不含7岁及以下儿童'
          end,
          k.rr
