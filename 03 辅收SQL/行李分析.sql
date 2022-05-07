---行李分析
select /*+parallel(4) */
to_char(t1.flights_date, 'yyyy') 年,
       to_char(t1.flights_date, 'mm') 月,
       to_char(t1.flights_date-1,'iw') 星期,
       case
         when t1.channel in ('网站', '手机') and b.users_id is not null then
          '代理'
         when t1.channel in ('网站', '手机') and
              t1.pay_gate in (15, 29, 31, 64, 71, 74) then
          '易宝商旅卡'
         when t1.channel in ('网站', '手机') then
          '线上纯量'
         when t1.channel in ('OTA', '旗舰店') then
          'OTA'
         else
          '其他'
       end 购票渠道,
       t1.seat_type 产品类型,
       t1.nationflag 航线性质,
       t2.originairport_name 始发站,
   --    t2.flights_segment_name 航段,
       case
         when t1.seats_name in ('B', 'G', 'G1', 'G2', 'O') then
          'BGO'
         else
          '非BGO'
       end 舱位类型,
         case
         when nvl(l.bagw, 0) <= 0 then
          '0'
         when nvl(l.bagw, 0) < 10 then
          '(0, 10)'
         when nvl(l.bagw, 0) = 10 then
          '10'
         when nvl(l.bagw, 0) < 20 then
          '(10, 20)'
         when nvl(l.bagw, 0) = 20 then
          '20'
         when nvl(l.bagw, 0) < 30 then
          '(20, 30)'
         when nvl(l.bagw, 0) = 30 then
          '30'
         when nvl(l.bagw, 0) > 30 then
          '30+'
         else
          '0'
       end 托运行李重量,
       t1.weight_free 免费托运行李额度,
       p.part 出行目的,           
       sum( case when greatest(nvl(t8.luggage_weight, 0), 0)>0 then 1 else 0 end)  线上购买行李量,
       sum(case when greatest(nvl(t8.luggage_fee_1, 0), 0)>0 then 1 else 0 end) 线上一次购买行李量,
       sum(case when greatest(nvl(t8.luggage_fee_2, 0), 0)>0 then 1 else 0 end) 线上二次购买行李量,
       sum( case when greatest(nvl(l.weight_gt, 0), 0) + greatest(nvl(l.weight_zz, 0), 0)  >0 then 1 else 0 end) 线下购买行李量,
       sum( case when t9.flights_order_head_id is not null then t9.st_num else 0 end) 购买手提行李量,
       sum( case when t9.flights_order_head_id is not null then t9.minst_num else 0 end) 当天小程序购买手提量,
       sum(case when t1.weight_free >= l.bagw then 1 else 0 end) 需要购买行李量,       
    count(1) 机票量,
    sum(greatest(nvl(t8.luggage_fee_1, 0), 0)) 线上一次购买行李金额,
    sum(greatest(nvl(t8.luggage_fee_2, 0), 0)) 线上二次购买行李金额,
    sum(greatest(nvl(t8.luggage_fee, 0), 0)) 线上购买行李金额,
    sum(greatest(nvl(l.fee_gt, 0), 0) + greatest(nvl(l.fee_zz, 0), 0)) 线下购买行李金额,
    sum(greatest(nvl(t8.luggage_fee, 0), 0) +
           greatest(nvl(l.fee_gt, 0), 0) + greatest(nvl(l.fee_zz, 0), 0)) 合计购买行李金额,
     sum(case when  t9.flights_order_head_id is not null then t9.st_fee
       else 0 end) 手提费,
     sum(case when  t9.flights_order_head_id is not null then t9.minst_fee
       else 0 end) 当天小程序购买手提费, 
     sum(minonlie1_num) 小程序一次购买量,
     sum(minonlie1_fee) 小程序一次购买金额,
     sum(minonlie_num)  小程序购买量,
     sum(minonlie_fee) 小程序购买金额,
     sum(case when tp1.upgrade_type>=0 and l.bagw>0 then 1 else 0 end) 行李升舱量,
     sum(case when tp1.upgrade_type>=0 and l.bagw>0 then tp1.upgrade_fee else 0 end) 行李升舱金额,
     sum(case when tp1.upgrade_type>=0  then 1 else 0 end) 总升舱量,
     sum(case when tp1.upgrade_type>=0  then t1.upgrade_fee else 0 end) 总升舱金额
  from dw.fact_recent_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id = t2.segment_head_id
  left join dw.fact_orderhead_trippurpose@to_ods p on t1.flights_order_head_id = p.flights_order_head_id
  left join dw.fact_luggage_detail l on t1.flights_order_head_id = l.flights_order_head_id
  left join dw.da_restrict_userinfo b on t1.client_id = b.users_id
  left join dw.bi_superseat_detail tp1 on tp1.flights_order_head_id=t1.flights_order_head_id
  left join (select t.flights_order_head_id,
                    sum(case
                          when t.pay_together = 0 then
                           t.luggage_weight
                          else
                           0
                        end) luggage_weight_1,
                    sum(case
                          when t.pay_together = 1 then
                           t.luggage_weight
                          else
                           0
                        end) luggage_weight_2,
                    sum(case
                          when t.pay_together = 0 then
                           t.book_fee
                          else
                           0
                        end) luggage_fee_1,
                    sum(case
                          when t.pay_together = 1 then
                           t.book_fee
                          else
                           0
                        end) luggage_fee_2,
                    sum(t.luggage_weight) luggage_weight,
                    sum(t.book_fee) luggage_fee,
                     sum(case when t.channel in('手机','网站') and t.station_id in(5,10,6) and t.pay_together = 0 then t.book_num
                     else 0 end) minonlie1_num,
                      sum(case when t.channel in('手机','网站') and t.station_id in(5,10,6) and t.pay_together = 0 then t.book_fee
                     else 0 end) minonlie1_fee,
                    sum(case when t.channel in('手机','网站') and t.station_id in(5,10,6) then t.book_num
                     else 0 end) minonlie_num,
                   sum(case when t.channel in('手机','网站') and t.station_id in(5,10,6) then t.book_fee
                     else 0 end) minonlie_fee 
               from dw.fact_other_order_detail t
              where t.flights_date >= to_date('2021-03-30', 'yyyy-mm-dd')
                and t.flights_date < to_date('2021-08-17', 'yyyy-mm-dd')
                and t.company_id = 0
                and t.xtype_id in (6, 10, 17)
              group by t.flights_order_head_id) t8 on t1.flights_order_head_id = t8.flights_order_head_id
 /* left join (select t1.*,
                    case
                      when mileage < 1000 then
                       '0~1000'
                      when mileage < 2000 then
                       '1000~2000'
                      when mileage < 3000 then
                       '2000~3000'
                      when mileage >= 3000 then
                       '3000+'
                    end mile
               from (select t2.flights_segment_name,
                            t1.mileage,
                            t1.last_update_time,
                            row_number() over(partition by t2.flights_segment_name order by t1.last_update_time desc) xid
                       from stg.s_cq_flights_pub_mileage t1
                       join dw.da_flight t2 on t1.start_city || t1.end_city = t2.segment_code
                      group by t2.flights_segment_name,t1.mileage,t1.last_update_time) t1
              where xid = 1) m on t2.flights_segment_name =m.flights_segment_name*/
   left join (select t.flights_order_head_id,
                    max(case when t.channel in('网站','手机') and t.station_id<=1 then '网站'
                    when t.channel in('网站','手机') and t.station_id=2 then 'M网站'
                    when t.channel in('网站','手机') and t.station_id in(3,8) then 'IOS'
                    when t.channel in('网站','手机') and t.station_id in(4,9) then 'Andriod'
                    when t.channel in('网站','手机') and t.station_id in(5,10,6) then '小程序'
                    when t.channel in('OTA','旗舰店') then 'OTA'
                    when t.channel ='呼叫中心' then '呼叫中心'
                    else '其他' end) st_channel,                     
                    sum(t.book_num) st_num,
                    sum(t.book_fee) st_fee,
                    sum(case when t.channel in('网站','手机') and t.station_id in(5,10,6) and t.order_day=t.flights_date 
                    then 1 else 0 end) minst_num, 
                    sum(case when t.channel in('网站','手机') and t.station_id in(5,10,6) and t.order_day=t.flights_date 
                    then t.book_fee else 0 end) minst_fee 
                 
               from dw.fact_other_order_detail t
              where t.flights_date >= to_date('2021-06-29', 'yyyy-mm-dd')
                and t.flights_date < to_date('2021-08-17', 'yyyy-mm-dd')
                and t.company_id = 0
                and t.xtype_id= 23
              group by t.flights_order_head_id) t9 on t1.flights_order_head_id = t9.flights_order_head_id
 where t1.whole_flight like '9C%'
   and t1.flights_date >= to_date('2021-06-29', 'yyyy-mm-dd')
   and t1.flights_date < to_date('2021-08-17', 'yyyy-mm-dd')
   and t1.flag_id in (3, 5, 40, 41)
   and t1.seats_name is not null
 group by to_char(t1.flights_date, 'yyyy') ,
       to_char(t1.flights_date, 'mm') ,
       to_char(t1.flights_date-1,'iw') ,
       case
         when t1.channel in ('网站', '手机') and b.users_id is not null then
          '代理'
         when t1.channel in ('网站', '手机') and
              t1.pay_gate in (15, 29, 31, 64, 71, 74) then
          '易宝商旅卡'
         when t1.channel in ('网站', '手机') then
          '线上纯量'
         when t1.channel in ('OTA', '旗舰店') then
          'OTA'
         else
          '其他'
       end ,
       t1.seat_type ,
       t1.nationflag ,
       t2.originairport_name ,
      -- t2.flights_segment_name ,
       case
         when t1.seats_name in ('B', 'G', 'G1', 'G2', 'O') then
          'BGO'
         else
          '非BGO'
       end ,
         case
         when nvl(l.bagw, 0) <= 0 then
          '0'
         when nvl(l.bagw, 0) < 10 then
          '(0, 10)'
         when nvl(l.bagw, 0) = 10 then
          '10'
         when nvl(l.bagw, 0) < 20 then
          '(10, 20)'
         when nvl(l.bagw, 0) = 20 then
          '20'
         when nvl(l.bagw, 0) < 30 then
          '(20, 30)'
         when nvl(l.bagw, 0) = 30 then
          '30'
         when nvl(l.bagw, 0) > 30 then
          '30+'
         else
          '0'
       end ,
       t1.weight_free ,
       p.part;
