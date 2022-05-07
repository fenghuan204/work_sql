#2019年人均辅收指标测算

数据说明：航班日期

一次线上人均辅收计算：

1、线上人均辅收（含代理）：一次线上人均辅收金额/线上机票销量

2、线上人均辅收（不含代理）：一次线上人均辅收金额/线上不含代理销量


二次线上人均辅收计算：

1、二次线上人均辅收：二次购买的辅收金额(利润)/所有机票(含BGO)



select '辅收' 数据类型,to_char(t1.flights_date, 'yyyymm') 航班月,
       to_char(t1.pay_together + 1) 类型,
       t1.channel 渠道,
       case
         when t1.channel = '手机' and t1.station_id = 2 then
          'M网站'
         when t1.channel = '手机' and t1.station_id in (5, 10) then
          '微信'
         when t1.channel = '手机' then
          'APP'
         else
          t1.channel
       end 渠道小类,
       sum(t1.book_num) 产品数量,
       sum(t1.book_fee) 产品金额,
       0 机票数量
  from dw.fact_other_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id = t2.segment_head_id
 where t1.flights_date >= to_date('2016-11-01', 'yyyy-mm-dd')
   and t1.flights_date < to_date('2018-11-01', 'yyyy-mm-dd')
   and t1.company_id = 0
   and t1.flag_id in (3, 5, 40, 41)
   and t1.channel in ('手机', '网站')
   and t2.flag <> 2
 group by to_char(t1.flights_date, 'yyyymm') ,
          t1.pay_together + 1,
          t1.channel,
          case
            when t1.channel = '手机' and t1.station_id = 2 then
             'M网站'
            when t1.channel = '手机' and t1.station_id in (5, 10) then
             '微信'
            when t1.channel = '手机' then
             'APP'
            else
             t1.channel
          end

union all

select '机票',to_char(t1.flights_date, 'yyyymm') flightmonth,
       '线上非代理' type,
       t1.channel,
       case
         when t1.channel = '手机' and t1.station_id = 2 then
          'M网站'
         when t1.channel = '手机' and t1.station_id in (5, 10) then
          '微信'
         when t1.channel = '手机' then
          'APP'
         else
          t1.channel
       end sub_channel,
       0,
       0,
       suM(case
             when t1.seats_name is not null then
              1
             else
              0
           end) ticketnum
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id = t2.segment_head_id
  left join dw.da_restrict_userinfo t3 on t1.client_id = t3.users_id
 where t1.flights_date >= to_date('2016-11-01', 'yyyy-mm-dd')
   and t1.flights_date < to_date('2018-11-01', 'yyyy-mm-dd')
   and t1.company_id = 0
   and t1.flag_id in (3, 5, 40, 41)
   and t1.channel in ('手机', '网站')
   and t2.flag <> 2
   and t3.users_id is  null
 group by to_char(t1.flights_date, 'yyyymm'),
          t1.channel,
          case
            when t1.channel = '手机' and t1.station_id = 2 then
             'M网站'
            when t1.channel = '手机' and t1.station_id in (5, 10) then
             '微信'
            when t1.channel = '手机' then
             'APP'
            else
             t1.channel
          end

union all
select '机票',to_char(t1.flights_date, 'yyyymm') flightmonth,
       '线上总体' type,
       t1.channel,
       case
         when t1.channel = '手机' and t1.station_id = 2 then
          'M网站'
         when t1.channel = '手机' and t1.station_id in (5, 10) then
          '微信'
         when t1.channel = '手机' then
          'APP'
         else
          t1.channel
       end sub_channel,
       0,
       0,
       suM(case
             when t1.seats_name is not null then
              1
             else
              0
           end) ticketnum
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id = t2.segment_head_id
 where t1.flights_date >= to_date('2016-11-01', 'yyyy-mm-dd')
   and t1.flights_date < to_date('2018-11-01', 'yyyy-mm-dd')
   and t1.company_id = 0
   and t2.flag <> 2
   and t1.flag_id in (3, 5, 40, 41)
   and t1.channel in ('手机', '网站')
 group by to_char(t1.flights_date, 'yyyymm'),
          t1.channel,
          case
            when t1.channel = '手机' and t1.station_id = 2 then
             'M网站'
            when t1.channel = '手机' and t1.station_id in (5, 10) then
             '微信'
            when t1.channel = '手机' then
             'APP'
            else
             t1.channel
          end

union all

select '机票',to_char(t1.flights_date, 'yyyymm') flightmonth,
       '全渠道' type,
       null,
       null,
       0,
       0,
       suM(case
             when t1.seats_name is not null then
              1
             else
              0
           end) ticketnum
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id = t2.segment_head_id
 where t1.flights_date >= to_date('2016-11-01', 'yyyy-mm-dd')
   and t1.flights_date < to_date('2018-11-01', 'yyyy-mm-dd')
   and t1.company_id = 0
   and t1.flag_id in (3, 5, 40, 41)
 group by to_char(t1.flights_date, 'yyyymm'),
          t1.channel,
          case
            when t1.channel = '手机' and t1.station_id = 2 then
             'M网站'
            when t1.channel = '手机' and t1.station_id in (5, 10) then
             '微信'
            when t1.channel = '手机' then
             'APP'
            else
             t1.channel
          end;

#11月份数据


select '辅收' 数据类型,to_char(t1.flights_date, 'yyyymm') 航班月,
       to_char(t1.pay_together + 1) 类型,
       t1.channel 渠道,
       case
         when t1.channel = '手机' and t1.station_id = 2 then
          'M网站'
         when t1.channel = '手机' and t1.station_id in (5, 10) then
          '微信'
         when t1.channel = '手机' then
          'APP'
         else
          t1.channel
       end 渠道小类,
       sum(t1.book_num) 产品数量,
       sum(t1.book_fee) 产品金额,
       0 机票数量
  from dw.fact_other_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id = t2.segment_head_id
 where t1.flights_date >= to_date('2018-11-01', 'yyyy-mm-dd')
   and t1.flights_date < to_date('2018-11-20', 'yyyy-mm-dd')
   and t1.company_id = 0
   and t1.flag_id in (3, 5, 40, 41)
   and t1.channel in ('手机', '网站')
   and t2.flag <> 2
 group by to_char(t1.flights_date, 'yyyymm') ,
          t1.pay_together + 1,
          t1.channel,
          case
            when t1.channel = '手机' and t1.station_id = 2 then
             'M网站'
            when t1.channel = '手机' and t1.station_id in (5, 10) then
             '微信'
            when t1.channel = '手机' then
             'APP'
            else
             t1.channel
          end

union all

select '机票',to_char(t1.flights_date, 'yyyymm') flightmonth,
       '线上非代理' type,
       t1.channel,
       case
         when t1.channel = '手机' and t1.station_id = 2 then
          'M网站'
         when t1.channel = '手机' and t1.station_id in (5, 10) then
          '微信'
         when t1.channel = '手机' then
          'APP'
         else
          t1.channel
       end sub_channel,
       0,
       0,
       suM(case
             when t1.seats_name is not null then
              1
             else
              0
           end) ticketnum
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id = t2.segment_head_id
  left join dw.da_restrict_userinfo t3 on t1.client_id = t3.users_id
 where t1.flights_date >= to_date('2018-11-01', 'yyyy-mm-dd')
   and t1.flights_date < to_date('2018-11-20', 'yyyy-mm-dd')
   and t1.company_id = 0
   and t1.flag_id in (3, 5, 40, 41)
   and t1.channel in ('手机', '网站')
   and t2.flag <> 2
   and t3.users_id is  null
 group by to_char(t1.flights_date, 'yyyymm'),
          t1.channel,
          case
            when t1.channel = '手机' and t1.station_id = 2 then
             'M网站'
            when t1.channel = '手机' and t1.station_id in (5, 10) then
             '微信'
            when t1.channel = '手机' then
             'APP'
            else
             t1.channel
          end

union all
select '机票',to_char(t1.flights_date, 'yyyymm') flightmonth,
       '线上总体' type,
       t1.channel,
       case
         when t1.channel = '手机' and t1.station_id = 2 then
          'M网站'
         when t1.channel = '手机' and t1.station_id in (5, 10) then
          '微信'
         when t1.channel = '手机' then
          'APP'
         else
          t1.channel
       end sub_channel,
       0,
       0,
       suM(case
             when t1.seats_name is not null then
              1
             else
              0
           end) ticketnum
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id = t2.segment_head_id
 where t1.flights_date >= to_date('2018-11-01', 'yyyy-mm-dd')
   and t1.flights_date < to_date('2018-11-20', 'yyyy-mm-dd')
   and t1.company_id = 0
   and t2.flag <> 2
   and t1.flag_id in (3, 5, 40, 41)
   and t1.channel in ('手机', '网站')
 group by to_char(t1.flights_date, 'yyyymm'),
          t1.channel,
          case
            when t1.channel = '手机' and t1.station_id = 2 then
             'M网站'
            when t1.channel = '手机' and t1.station_id in (5, 10) then
             '微信'
            when t1.channel = '手机' then
             'APP'
            else
             t1.channel
          end

union all

select '机票',to_char(t1.flights_date, 'yyyymm') flightmonth,
       '全渠道' type,
       null,
       null,
       0,
       0,
       suM(case
             when t1.seats_name is not null then
              1
             else
              0
           end) ticketnum
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id = t2.segment_head_id
 where t1.flights_date >= to_date('2018-11-01', 'yyyy-mm-dd')
   and t1.flights_date < to_date('2018-11-20', 'yyyy-mm-dd')
   and t1.company_id = 0
   and t1.flag_id in (3, 5, 40, 41)
 group by to_char(t1.flights_date, 'yyyymm'),
          t1.channel,
          case
            when t1.channel = '手机' and t1.station_id = 2 then
             'M网站'
            when t1.channel = '手机' and t1.station_id in (5, 10) then
             '微信'
            when t1.channel = '手机' then
             'APP'
            else
             t1.channel
          end;

