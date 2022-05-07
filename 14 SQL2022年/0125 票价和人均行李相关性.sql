select /*+parallel(4)*/
 m1.ymd 航班日,
 m1.origincity_name 始发城市,
 m1.destcity_name 抵达城市,
 sum(nvl(m1.avgticket, 0)) / sum(nvl(m1.ticknum, 0)) 平均票价,
 sum(nvl(m1.onlinefee, 0)) / sum(nvl(m1.ticknum, 0)) 线上行李人均,
 sum(nvl(m1.onlinenum, 0)) / sum(nvl(m1.ticknum, 0)) 线上行李购买率,
 sum(nvl(m1.bagfee, 0)) / sum(nvl(m1.ticknum, 0)) 地面行李人均,
 sum(nvl(m1.bagnum, 0)) / sum(nvl(m1.ticknum, 0)) 地面行李购买率,
 (sum(nvl(m1.onlinefee, 0)) + sum(nvl(m1.bagfee, 0))) /
 sum(nvl(m1.ticknum, 0)) 总行李人均,
 (sum(nvl(m1.onlinenum, 0)) + sum(nvl(m1.bagnum, 0))) /
 sum(nvl(m1.ticknum, 0)) 总行李购买率,
 (sum(nvl(m1.onlinefee, 0)) + sum(nvl(m1.bagfee, 0)) +
 sum(nvl(m1.combotickprice, 0))) / sum(nvl(m1.ticknum, 0)) 总行李含组合商务座人均,
 (sum(nvl(m1.onlinenum, 0)) + sum(nvl(m1.bagnum, 0)) +
 sum(nvl(m1.comboticknum, 0))) / sum(nvl(m1.ticknum, 0)) 总行李含组合商务座购买率,
 sum(m1.ticknum) 机票总数,
 sum(nvl(m1.onlinefee, 0)) 线上行李金额,
 sum(nvl(m1.onlinenum, 0)) 线上行李数量,
 sum(nvl(m1.bagfee, 0)) 地面行李金额,
 sum(nvl(m1.bagnum, 0)) 地面行李数量,
 sum(nvl(m1.combotickprice, 0)) 商务组合价差,
 sum(nvl(m1.comboticknum, 0)) 商务组合数量,
sum(nvl(m1.ticknum, 0))/sum(m1.oversale) 客座率,
 sum(nvl(m1.bagnum, 0))+ sum(nvl(m1.onlinenum, 0)) 行李购买数量,
 sum(nvl(m1.online_weight,0)+nvl(m1.offline_weight,0)) weightnum,
(sum(nvl(m1.bagnum, 0))+ sum(nvl(m1.onlinenum, 0)))/sum(nvl(m1.ticknum, 0)) 行李购买率,
(sum(nvl(m1.onlinefee, 0)) + sum(nvl(m1.bagfee, 0))) / sum(nvl(m1.ticknum, 0)) 行李人均,
sum(nvl(m1.online_num,0)) 线上销售量
  from (select to_char(t.flights_date, 'yyyymmdd') ymd,
               tt.origincity_name,
               tt.destcity_name,
               tt.segment_head_id,
               tt.flights_city_name,
               tt.oversale,
               sum(case
                     when t.is_swj > 0 then
                      1
                     when t.ex_cfd6 is not null and cp.id = 1 then
                      1
                     else
                      0
                   end) comboticknum,
               sum(case
                     when t.is_swj > 0 and sp.upgrade_type >= 0 then
                      nvl(sp.upgrade_fee, 0)
                     when t.is_swj > 0 and sp.upgrade_type < 0 then
                      nvl((t.ticket_price -
                          nvl(t.min_seat_price * t.rcd_rate, t.ticket_price)),
                          0)
                     when t.is_swj = 0 and t.ex_cfd6 is not null and cp.id = 1 then
                      nvl(cb.comb_fee, 0)
                     else
                      0
                   end) combotickprice,
               sum(nvl(t.ticket_price, 0)) avgticket,
               sum(nvl(h1.onlinenum, 0)) onlinenum,
               sum(nvl(h1.onlinefee, 0)) onlinefee,
               sum(nvl(h2.bagnum, 0)) bagnum,
               sum(nvl(h2.bagfee, 0)) bagfee,
               sum(nvl(h2.offline_weight,0)) offline_weight,
               sum(nvl(h1.online_weight,0)) online_weight,
               count(1) ticknum,
               sum(case when t.channel in('网站','手机') then 1 else 0 end ) online_num
          from dw.fact_order_detail t
          join dw.da_flight tt on t.segment_head_id = tt.segment_head_id
          left join dw.dim_comb_product cp on cp.type_id = t.ex_cfd6
                                          and cp.id = nvl(t.ex_nfd4, 1)
          left join dw.bi_superseat_detail sp on t.flights_order_head_id =
                                                 sp.flights_order_head_id
          left join dw.fact_comb_price cb on cb.flights_order_head_id =
                                             t.flights_order_head_id
          left join (select t1.flights_order_head_id,
                           sum(t1.book_num) onlinenum,
                           sum(t1.book_fee) onlinefee,
                           sum(case when t1.xtype_id=23 then 10  else 
                           t1.luggage_weight end) online_weight                       
                      from dw.fact_other_order_detail t1
                     where t1.xtype_id in (6, 10, 17, 23)
                       and t1.nationflag = '国内'
                       and t1.company_id = 0
                       and t1.flag_id = 40
                       and t1.flights_date >=
                           to_date('2021-01-01', 'yyyy-mm-dd')
                       and t1.flights_date < to_date('2022-01-25', 'yyyy-mm-dd') 
                     group by t1.flights_order_head_id) h1 on h1.flights_order_head_id =
                                                              t.flights_order_head_id
          left join (select d.flights_order_head_id,
                           sum(d.fee_bag + nvl(d.bg_fee, 0)) bagfee,
                           count(1) bagnum,
                           sum(d.pay_weight) offline_weight 
                      from dw.fact_dcs_money_detail d
                     where nvl(d.fee_bag, 0) + nvl(d.bg_fee, 0) <> 0
                       and d.nationflag = '国内'
                       and d.company_id = 0
                       and d.flights_date >=
                           to_date('2021-01-01', 'yyyy-mm-dd')
                       and d.flights_date < to_date('2022-01-25', 'yyyy-mm-dd') 
                     group by d.flights_order_head_id) h2 on h2.flights_order_head_id =
                                                             t.flights_order_head_id
         where t.company_id = 0
           and t.flights_date >= to_date('2021-01-01', 'yyyy-mm-dd')
           and t.flights_date < to_date('2022-01-25', 'yyyy-mm-dd') 
           and t.nationflag = '国内'
           and t.flag_id = 40
           and tt.flights_city_name in('上海－哈尔滨','哈尔滨－上海','上海－十堰（武当山）','十堰（武当山）－上海','喀什－兰州','兰州－喀什')
           and t.seats_name is not null
         group by to_char(t.flights_date, 'yyyymmdd'),
               tt.origincity_name,
               tt.destcity_name,
               tt.segment_head_id,
               tt.flights_city_name,
               tt.oversale) m1
 group by m1.ymd, m1.origincity_name, m1.destcity_name