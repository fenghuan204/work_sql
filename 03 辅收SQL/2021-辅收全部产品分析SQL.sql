select to_char(t.flights_date, 'yyyymm') 航班月,
       t2.nationflag 航线性质,
       case
         when t.seats_name in ('B', 'G', 'G1', 'G2', 'O') then
          'BGO'
         else
          'notBGO'
       end 团散,
       case
         when t.channel in ('手机', '网站') then
          '线上自有'
         when t.channel in ('OTA', '旗舰店') then
          'OTA'
         else
          'B2B'
       end 机票渠道,
       case
         when t.channel in ('网站', '手机') and r.users_id is not null then
          '代理'
         when t.channel in ('网站', '手机') and
              t.pay_gate in (15, 29, 31, 64, 71, 74) then
          '代理'
         else
          '非代理'
       end 是否代理,
       case
         when pp.part like '%旅行%' then
          '旅行'
         when pp.part = '商务' then
          '商务'
         else
          '其他'
       end 出行目的,
       case
         when t1.book_type = 1 then
          '保险'
         when t1.xtype_id = 3 then
          '线上选座'
         when t1.xtype_id in (6, 10, 17) then
          '线上行李'
         when t1.xtype_id = 7 then
          '线上餐食'
         when t1.xtype_id = 16 then
          '接送机'
         when t1.xtype_id = 20 then
          '贵宾室服务'
         when t1.xtype_id = 21 and
              regexp_like(upper(t1.xproduct_name),
                          '(WIFI)|(WF)|(4G)|(上网卡)') then
          'WIFI'
         when t1.xtype_id = 23 then
          '升级手提行李'
         else
          '其他'
       end 辅收大类,
       case
         when t1.channel in ('手机', '网站') then
          '线上自有'
         when t1.channel in ('OTA', '旗舰店') then
          'OTA'
         when t1.channel = '呼叫中心' then
          '呼叫中心'
         else
          'B2B'
       end 辅收购买渠道,
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
       end 辅收购买提前期,
       decode(t1.pay_together, 0, '一次', 1, '二次') 辅收购买场景,
       sum(t1.book_num) 辅收数量,
       sum(t1.book_fee) 辅收金额,
       0 机票数
  from dw.fact_other_order_detail t1
  join dw.fact_order_detail t on t.flights_order_head_id =
                                 t1.flights_order_head_id
  left join dw.fact_orderhead_trippurpose@to_ods pp on pp.flights_order_head_id =
                                                       t1.flights_order_head_id
  left join dw.da_flight t2 on t2.segment_head_id = t1.segment_head_id
  left join dw.da_restrict_userinfo r on r.users_id = t.client_id
 where t1.company_id = 0
   and t1.flights_date >= to_date('2018-11-01', 'yyyy-mm-dd')
   and t1.flights_date < to_date('2020-01-01', 'yyyy-mm-dd')
   and t1.xtype_id not in (24, 25)
 group by to_char(t.flights_date, 'yyyymm'),
          t2.nationflag,
          case
            when t.seats_name in ('B', 'G', 'G1', 'G2', 'O') then
             'BGO'
            else
             'notBGO'
          end,
          case
            when t.channel in ('手机', '网站') then
             '线上自有'
            when t.channel in ('OTA', '旗舰店') then
             'OTA'
            else
             'B2B'
          end,
          case
            when t.channel in ('网站', '手机') and r.users_id is not null then
             '代理'
            when t.channel in ('网站', '手机') and
                 t.pay_gate in (15, 29, 31, 64, 71, 74) then
             '代理'
            else
             '非代理'
          end,
          case
            when pp.part like '%旅行%' then
             '旅行'
            when pp.part = '商务' then
             '商务'
            else
             '其他'
          end,
          case
            when t1.book_type = 1 then
             '保险'
            when t1.xtype_id = 3 then
             '线上选座'
            when t1.xtype_id in (6, 10, 17) then
             '线上行李'
            when t1.xtype_id = 7 then
             '线上餐食'
            when t1.xtype_id = 16 then
             '接送机'
            when t1.xtype_id = 20 then
             '贵宾室服务'
            when t1.xtype_id = 21 and
                 regexp_like(upper(t1.xproduct_name),
                             '(WIFI)|(WF)|(4G)|(上网卡)') then
             'WIFI'
            when t1.xtype_id = 23 then
             '升级手提行李'
            else
             '其他'
          end,
          case
         when t1.channel in ('手机', '网站') then
          '线上自有'
         when t1.channel in ('OTA', '旗舰店') then
          'OTA'
         when t1.channel = '呼叫中心' then
          '呼叫中心'
         else
          'B2B'
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
          decode(t1.pay_together, 0, '一次', 1, '二次')
-----机票--

union all

select to_char(t.flights_date, 'yyyymm') 航班月,
       t2.nationflag 航线性质,
       case
         when t.seats_name in ('B', 'G', 'G1', 'G2', 'O') then
          'BGO'
         else
          'notBGO'
       end 团散,
       case
         when t.channel in ('手机', '网站') then
          '线上自有'
         when t.channel in ('OTA', '旗舰店') then
          'OTA'
         else
          'B2B'
       end 机票渠道,
       case
         when t.channel in ('网站', '手机') and r.users_id is not null then
          '代理'
         when t.channel in ('网站', '手机') and
              t.pay_gate in (15, 29, 31, 64, 71, 74) then
          '代理'
         else
          '非代理'
       end 是否代理,
       case
         when pp.part like '%旅行%' then
          '旅行'
         when pp.part = '商务' then
          '商务'
         else
          '其他'
       end 出行目的,
       '机票' 辅收大类,
       null 辅收购买渠道,
       null 辅收购买提前期,
       null 辅收购买场景,
       0 辅收数量,
       0 辅收金额,
       sum(case
             when t.seats_name is not null then
              1
             else
              0
           end) 机票数
  from dw.fact_order_detail t
  join dw.da_flight t2 on t2.segment_head_id = t.segment_head_id
  left join dw.fact_orderhead_trippurpose@to_ods pp on pp.flights_order_head_id =
                                                       t.flights_order_head_id
  left join dw.da_restrict_userinfo r on r.users_id = t.client_id
 where t.company_id = 0
   and t.flights_date >= to_date('2018-11-01', 'yyyy-mm-dd')
   and t.flights_date < to_date('2020-01-01', 'yyyy-mm-dd')
 group by to_char(t.flights_date, 'yyyymm'),
          t2.nationflag,
          case
            when t.seats_name in ('B', 'G', 'G1', 'G2', 'O') then
             'BGO'
            else
             'notBGO'
          end,
          case
            when t.channel in ('手机', '网站') then
             '线上自有'
            when t.channel in ('OTA', '旗舰店') then
             'OTA'
            else
             'B2B'
          end,
          case
            when t.channel in ('网站', '手机') and r.users_id is not null then
             '代理'
            when t.channel in ('网站', '手机') and
                 t.pay_gate in (15, 29, 31, 64, 71, 74) then
             '代理'
            else
             '非代理'
          end,
          case
            when pp.part like '%旅行%' then
             '旅行'
            when pp.part = '商务' then
             '商务'
            else
             '其他'
          end

-----线下行李----       
union all

select to_char(t.flights_date, 'yyyymm') 航班月,
       t2.nationflag 航线性质,
       case
         when t.seats_name in ('B', 'G', 'G1', 'G2', 'O') then
          'BGO'
         else
          'notBGO'
       end 团散,
       case
         when t.channel in ('手机', '网站') then
          '线上自有'
         when t.channel in ('OTA', '旗舰店') then
          'OTA'
         else
          'B2B'
       end 机票渠道,
       case
         when t.channel in ('网站', '手机') and r.users_id is not null then
          '代理'
         when t.channel in ('网站', '手机') and
              t.pay_gate in (15, 29, 31, 64, 71, 74) then
          '代理'
         else
          '非代理'
       end 是否代理,
       case
         when pp.part like '%旅行%' then
          '旅行'
         when pp.part = '商务' then
          '商务'
         else
          '其他'
       end 出行目的,
       '线下行李' 辅收大类,
       '地面' 辅收购买渠道,
       null 辅收购买提前期,
       '二次' 辅收购买场景,
       count(1) 辅收数量,
       sum(b.feebag) 辅收金额,
       0 机票数
  from dw.fact_order_detail t
  join (select flights_order_head_id,
               sum(pay_weight) pay_weight,
               sum(fee_bag) feebag
          from dw.fact_dcs_money_detail
         where flights_date >= to_date('2018-11-01', 'yyyy-mm-dd')
           and flights_date < to_date('2020-01-01', 'yyyy-mm-dd')
           and fee_bag <> 0
         group by flights_order_head_id) b on b.flights_order_head_id =
                                              t.flights_order_head_id
  join dw.da_flight t2 on t2.segment_head_id = t.segment_head_id
  left join dw.da_restrict_userinfo r on r.users_id = t.client_id
  left join dw.fact_orderhead_trippurpose@to_ods pp on pp.flights_order_head_id =
                                                       t.flights_order_head_id
 where t.company_id = 0
   and t.flights_date >= to_date('2018-11-01', 'yyyy-mm-dd')
   and t.flights_date < to_date('2020-01-01', 'yyyy-mm-dd')
 group by to_char(t.flights_date, 'yyyymm'),
          t2.nationflag,
          case
            when t.seats_name in ('B', 'G', 'G1', 'G2', 'O') then
             'BGO'
            else
             'notBGO'
          end,
          case
            when t.channel in ('手机', '网站') then
             '线上自有'
            when t.channel in ('OTA', '旗舰店') then
             'OTA'
            else
             'B2B'
          end,
          case
            when t.channel in ('网站', '手机') and r.users_id is not null then
             '代理'
            when t.channel in ('网站', '手机') and
                 t.pay_gate in (15, 29, 31, 64, 71, 74) then
             '代理'
            else
             '非代理'
          end,
          case
            when pp.part like '%旅行%' then
             '旅行'
            when pp.part = '商务' then
             '商务'
            else
             '其他'
          end

--------线下选座-----

union all

select to_char(t.flights_date, 'yyyymm') 航班月,
       t2.nationflag 航线性质,
       case
         when t.seats_name in ('B', 'G', 'G1', 'G2', 'O') then
          'BGO'
         else
          'notBGO'
       end 团散,
       case
         when t.channel in ('手机', '网站') then
          '线上自有'
         when t.channel in ('OTA', '旗舰店') then
          'OTA'
         else
          'B2B'
       end 机票渠道,
       case
         when t.channel in ('网站', '手机') and r.users_id is not null then
          '代理'
         when t.channel in ('网站', '手机') and
              t.pay_gate in (15, 29, 31, 64, 71, 74) then
          '代理'
         else
          '非代理'
       end 是否代理,
       case
         when pp.part like '%旅行%' then
          '旅行'
         when pp.part = '商务' then
          '商务'
         else
          '其他'
       end 出行目的,
       '线下选座' 辅收大类,
       '地面' 辅收购买渠道,
       null 辅收购买提前期,
       '二次' 辅收购买场景,
       count(1) 辅收数量,
       sum(b.feekdj) 辅收金额,
       0 机票数
  from dw.fact_order_detail t
  join (select flights_order_head_id, sum(fee_kdj) feekdj
          from dw.fact_dcs_money_detail
         where flights_date >= to_date('2018-11-01', 'yyyy-mm-dd')
           and fee_kdj <> 0
         group by flights_order_head_id) b on b.flights_order_head_id =
                                              t.flights_order_head_id
  join dw.da_flight t2 on t2.segment_head_id = t.segment_head_id
  left join dw.fact_orderhead_trippurpose@to_ods pp on pp.flights_order_head_id =
                                                       t.flights_order_head_id
  left join dw.da_restrict_userinfo r on r.users_id = t.client_id
 where t.company_id = 0
   and t.flights_date >= to_date('2018-11-01', 'yyyy-mm-dd')
   and t.flights_date < to_date('2020-01-01', 'yyyy-mm-dd')
 group by to_char(t.flights_date, 'yyyymm'),
          t2.nationflag,
          case
            when t.seats_name in ('B', 'G', 'G1', 'G2', 'O') then
             'BGO'
            else
             'notBGO'
          end,
          case
            when t.channel in ('手机', '网站') then
             '线上自有'
            when t.channel in ('OTA', '旗舰店') then
             'OTA'
            else
             'B2B'
          end,
          case
            when t.channel in ('网站', '手机') and r.users_id is not null then
             '代理'
            when t.channel in ('网站', '手机') and
                 t.pay_gate in (15, 29, 31, 64, 71, 74) then
             '代理'
            else
             '非代理'
          end,
          case
            when pp.part like '%旅行%' then
             '旅行'
            when pp.part = '商务' then
             '商务'
            else
             '其他'
          end

------机上产品----

union all

select nvl(substr(l.flight_date,1,6), to_char(l.order_day, 'yyyymm')) 航班月,
       nvl(t2.nationflag, '无法判断') 航线性质,
       '无法判断' 团散,
       '无法判断' 机票渠道,
       '无法判断' 是否代理,
       '无法判断' 出行目的,
       case
         when l.category = 3 then
          '机上跨境'
         when l.merchant_name = '上海春秋中免免税品有限公司' then
          '机上免税品'
         when l.type_name in ('餐食', '小吃', '饮料') then
          '机上' || l.type_name
         else
          '机上纪念品'
       end 辅收大类,
       '零售-' || decode(l.terminal_type,
                       '2',
                       'wifi航班',
                       '3',
                       '网站',
                       '4',
                       '机上销售',
                       '5',
                       '绿翼微信商城',
                       '6',
                       'M网站',
                       '7',
                       '有赞',
                       '8',
                       '小程序') 辅收购买渠道,
       null 辅收购买提前期,
       '二次' 辅收购买场景,
       sum(l.booknum) 辅收数量,
       sum(l.bookfee) 辅收金额,
       0 机票数
  from dw.fact_prt_order_detail l
  join stg.prt_eshop_product p on p.id = l.product_id
  left join dw.da_foc_order t1 on t1.flights_date =
                                  to_date(l.flight_date, 'yyyymmdd')
                              and t1.flights_no =
                                  (case when length(l.flight_no) < 6 then
                                   '9C' || substr(l.flight_no, 1, 5) else
                                   substr(l.flight_no, 1, 7) end)

  left join dw.da_flight t2 on t1.flights_id = t2.flights_id
                           and t1.segment_code = t2.segment_code
 where nvl(to_date(l.flight_date, 'yyyymmdd'), l.order_day) >=
       to_date('2018-11-01', 'yyyy-mm-dd')
   and nvl(to_date(l.flight_date, 'yyyymmdd'), l.order_day) <
       to_date('2020-01-01', 'yyyy-mm-dd')
   and nvl(l.flight_no, '9C') like '9C%'
   and length(l.flight_date) in(0,8)
   and l.status in ('200', '300', '301', '400', '500')
   and (case when
        p.merchant_id = 10220 and regexp_like(p.name, '想飞就飞|补差价') then 0 else 1 end) = 1
 group by nvl(substr(l.flight_date,1,6),
              to_char(l.order_day, 'yyyymm')),
          nvl(t2.nationflag, '无法判断'),
          
          case
            when l.category = 3 then
             '机上跨境'
            when l.merchant_name = '上海春秋中免免税品有限公司' then
             '机上免税品'
            when l.type_name in ('餐食', '小吃', '饮料') then
             '机上' || l.type_name
            else
             '机上纪念品'
          end,
          '零售-' || decode(l.terminal_type,
                          '2',
                          'wifi航班',
                          '3',
                          '网站',
                          '4',
                          '机上销售',
                          '5',
                          '绿翼微信商城',
                          '6',
                          'M网站',
                          '7',
                          '有赞',
                          '8',
                          '小程序')
                          
                          
---团队餐---
union all 


select to_char(t.flights_date, 'yyyymm') 航班月,
       t2.nationflag 航线性质,
       case
         when t.seats_name in ('B', 'G', 'G1', 'G2', 'O') then
          'BGO'
         else
          'notBGO'
       end 团散,
       case
         when t.channel in ('手机', '网站') then
          '线上自有'
         when t.channel in ('OTA', '旗舰店') then
          'OTA'
         else
          'B2B'
       end 机票渠道,
       case
         when t.channel in ('网站', '手机') and r.users_id is not null then
          '代理'
         when t.channel in ('网站', '手机') and
              t.pay_gate in (15, 29, 31, 64, 71, 74) then
          '代理'
         else
          '非代理'
       end 是否代理,
       case
         when pp.part like '%旅行%' then
          '旅行'
         when pp.part = '商务' then
          '商务'
         else
          '其他'
       end 出行目的,
       '团队餐' 辅收大类,
       '团队订餐' 辅收购买渠道,
       null 辅收购买提前期,
       '二次' 辅收购买场景,
       sum(b.dinner_num) 辅收数量,
       sum(b.feekdj) 辅收金额,
       0 机票数
  from dw.fact_order_detail t
  join (select q.flights_order_head_id, sum(f.dinner_num)dinner_num, sum(f.dinner_price*f.dinner_num) feekdj
          from stg.s_cq_group_dinner_detail f
          join stg.s_cq_order_head q on f.order_head_id =q.flights_order_head_id
         where q.flag_id in (3, 5, 40, 41)
           and q.whole_flight like '9C%'
           and q.r_flights_date>=to_date('2018-11-01', 'yyyy-mm-dd')
           and q.r_flights_date< to_date('2020-01-01', 'yyyy-mm-dd')
         group by q.flights_order_head_id) b on b.flights_order_head_id =
                                              t.flights_order_head_id
  join dw.da_flight t2 on t2.segment_head_id = t.segment_head_id
  left join dw.fact_orderhead_trippurpose@to_ods pp on pp.flights_order_head_id =
                                                       t.flights_order_head_id
  left join dw.da_restrict_userinfo r on r.users_id = t.client_id
 where t.company_id = 0
   and t.flights_date >= to_date('2021-01-01', 'yyyy-mm-dd')
   and t.flights_date < to_date('2021-02-01', 'yyyy-mm-dd')
 group by to_char(t.flights_date, 'yyyymm'),
          t2.nationflag,
          case
            when t.seats_name in ('B', 'G', 'G1', 'G2', 'O') then
             'BGO'
            else
             'notBGO'
          end,
          case
            when t.channel in ('手机', '网站') then
             '线上自有'
            when t.channel in ('OTA', '旗舰店') then
             'OTA'
            else
             'B2B'
          end,
          case
            when t.channel in ('网站', '手机') and r.users_id is not null then
             '代理'
            when t.channel in ('网站', '手机') and
                 t.pay_gate in (15, 29, 31, 64, 71, 74) then
             '代理'
            else
             '非代理'
          end,
          case
            when pp.part like '%旅行%' then
             '旅行'
            when pp.part = '商务' then
             '商务'
            else
             '其他'
          end
          
          
          
