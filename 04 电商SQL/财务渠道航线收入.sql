select to_char(t.flights_date, 'yyyymm') 航班月,
       t2.nationflag 航线性质,
       t3.wf_segment_name 往返航线,
       t2.route_name 航线,
       case
         when t.seats_name in ('B', 'G', 'G1', 'G2') then
          '包销'
         when t.channel in ('OTA', '旗舰店') then
          'OTA+旗舰店'
         else
          '直销'
       end channel,
       t.channel,
       sum(case
             when t.seats_name is not null then
1
             else
0
           end) 销售机票数,
       sum(t.ticket_price) 票面价和,
       sum(t.ticket_price + t.ad_fy) 票面价和燃油费,
       sum(t.ticket_price + t.ad_fy + t.port_pay + t.sx_fy + t.other_fy +
           t.insurce_fee + t.other_fee) 总收入
  from dw.fact_order_detail t
  join dw.da_flight t2 on t.segment_head_id = t2.segment_head_id
 left join dw.adt_wf_segment t3 on t2.h_route_id = t3.route_id
 where t.flights_date >= to_date('2017-12-01', 'yyyy-mm-dd')
   and t.flights_date < to_date('2019-01-01', 'yyyy-mm-dd')
   and to_char(t.flights_date, 'mm') = '12'
   and t.flag_id in (3, 5, 40, 41)
   and t.whole_flight like '9C%'
 group by to_char(t.flights_date, 'yyyymm'),
          t2.nationflag,
          t3.wf_segment_name,
          t2.route_name,
          case
            when t.seats_name in ('B', 'G', 'G1', 'G2') then
             '包销'
            when t.channel in ('OTA', '旗舰店') then
             'OTA+旗舰店'
            else
             '直销'
          end,
          t.channel
