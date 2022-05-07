/*年、月、日期、购票渠道（黑代、易宝商旅卡、线上纯量、OTA、其他）、产品类型（普通座、经济座、商务经济座）、航线性质、始发站、航段、
舱位类型（BG、非BG）、免费托运行李额度、线上购买行李重量、线上购买行李金额、线下购买行李重量、线下购买行李金额、
实际托运行李重量(0、(0,10),10,(10,20),20,(20,30),30,30+)、机票量
20210101~20210330*/

select to_char(t1.flights_date, 'yyyy') 年,
       to_char(t1.flights_date, 'mm') 月,
       t1.flights_date 航班日期,
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
       t2.flights_segment_name 航段,
       case
         when t1.seats_name in ('B', 'G', 'G1', 'G2', 'O') then
          'BGO'
         else
          '非BGO'
       end 舱位类型,
       /*case
         when c.flights_order_head_id is not null then
          '套票'
         else
          '非套票'
       end 是否套票,*/
       /*nvl(l.weight_free, t1.weight_free) 免费托运行李额度,*/
       t1.weight_free 免费托运行李额度,
       greatest(nvl(l.weight_web, 0), 0) 线上购买行李重量,
       greatest(nvl(l.fee_web, 0), 0) 线上购买行李金额,
       greatest(nvl(l.weight_gt, 0), 0) + greatest(nvl(l.weight_zz, 0), 0) +
       greatest(nvl(l.weight_xc, 0), 0) 线下购买行李重量,
       greatest(nvl(l.fee_gt, 0), 0) + greatest(nvl(l.fee_zz, 0), 0) +
       greatest(nvl(l.fee_xc, 0), 0) 线下购买行李金额,
       greatest(nvl(l.weight_web, 0), 0) + greatest(nvl(l.weight_gt, 0), 0) +
       greatest(nvl(l.weight_zz, 0), 0) + greatest(nvl(l.weight_xc, 0), 0) 合计购买行李重量,
       greatest(nvl(l.fee_web, 0), 0) + greatest(nvl(l.fee_gt, 0), 0) +
       greatest(nvl(l.fee_zz, 0), 0) + greatest(nvl(l.fee_xc, 0), 0) 合计购买行李金额,
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
          null
       end 托运行李重量,
       count(1) 机票量,
       case
         when t1.weight_free >= l.bagw then
          '不需要'
         else
          '需要'
       end 是否需要购买行李
  from dw.fact_recent_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id = t2.segment_head_id
/*left join dw.fact_combo_ticket c on t1.flights_order_head_id =
                                      c.flights_order_head_id*/
  left join dw.fact_luggage_detail l on t1.flights_order_head_id =
                                        l.flights_order_head_id
  left join dw.da_restrict_userinfo b on t1.client_id = b.users_id
 where t1.whole_flight like '9C%'
   and t1.flights_date >= to_date('2021-01-01', 'yyyy-mm-dd')
   and t1.flights_date < to_date('2021-03-27', 'yyyy-mm-dd')
   and t1.flag_id in (3, 5, 40, 41)
   and t1.seats_name is not null
 group by to_char(t1.flights_date, 'yyyy'),
          to_char(t1.flights_date, 'mm'),
          t1.flights_date,
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
          end,
          t1.seat_type,
          t1.nationflag,
          t2.originairport_name,
          t2.flights_segment_name,
          case
            when t1.seats_name in ('B', 'G', 'G1', 'G2', 'O') then
             'BGO'
            else
             '非BGO'
          end,
          /*case
            when c.flights_order_head_id is not null then
             '套票'
            else
             '非套票'
          end,*/
          t1.weight_free,
       greatest(nvl(l.weight_web, 0), 0),
       greatest(nvl(l.fee_web, 0), 0),
       greatest(nvl(l.weight_gt, 0), 0) + greatest(nvl(l.weight_zz, 0), 0) +
       greatest(nvl(l.weight_xc, 0), 0),
       greatest(nvl(l.fee_gt, 0), 0) + greatest(nvl(l.fee_zz, 0), 0) +
       greatest(nvl(l.fee_xc, 0), 0),
       greatest(nvl(l.weight_web, 0), 0) + greatest(nvl(l.weight_gt, 0), 0) +
       greatest(nvl(l.weight_zz, 0), 0) + greatest(nvl(l.weight_xc, 0), 0),
       greatest(nvl(l.fee_web, 0), 0) + greatest(nvl(l.fee_gt, 0), 0) +
       greatest(nvl(l.fee_zz, 0), 0) + greatest(nvl(l.fee_xc, 0), 0),
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
          null
       end,
       case
         when t1.weight_free >= l.bagw then
          '不需要'
         else
          '需要'
       end;


------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*年、月、日期、购票渠道（黑代、易宝商旅卡、线上纯量、OTA、其他）、产品类型（普通座、经济座、商务经济座）、航线性质、始发站、航段、
舱位类型（BG、非BG）、免费托运行李额度、线上购买行李重量、线上购买行李金额、线下购买行李重量、线下购买行李金额、
实际托运行李重量(0、(0,10),10,(10,20),20,(20,30),30,30+)、机票量
20190101~20190330*/

select to_char(t1.flights_date, 'yyyy') 年,
       to_char(t1.flights_date, 'mm') 月,
       t1.flights_date 航班日期,
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
       t2.flights_segment_name 航段,
       case
         when t1.seats_name in ('B', 'G', 'G1', 'G2', 'O') then
          'BGO'
         else
          '非BGO'
       end 舱位类型,
       /*case
         when c.flights_order_head_id is not null then
          '套票'
         else
          '非套票'
       end 是否套票,*/
       /*nvl(l.weight_free, t1.weight_free) 免费托运行李额度,*/
       t1.weight_free 免费托运行李额度,
       greatest(nvl(l.weight_web, 0), 0) 线上购买行李重量,
       greatest(nvl(l.fee_web, 0), 0) 线上购买行李金额,
       greatest(nvl(l.weight_gt, 0), 0) + greatest(nvl(l.weight_zz, 0), 0) +
       greatest(nvl(l.weight_xc, 0), 0) 线下购买行李重量,
       greatest(nvl(l.fee_gt, 0), 0) + greatest(nvl(l.fee_zz, 0), 0) +
       greatest(nvl(l.fee_xc, 0), 0) 线下购买行李金额,
       greatest(nvl(l.weight_web, 0), 0) + greatest(nvl(l.weight_gt, 0), 0) +
       greatest(nvl(l.weight_zz, 0), 0) + greatest(nvl(l.weight_xc, 0), 0) 合计购买行李重量,
       greatest(nvl(l.fee_web, 0), 0) + greatest(nvl(l.fee_gt, 0), 0) +
       greatest(nvl(l.fee_zz, 0), 0) + greatest(nvl(l.fee_xc, 0), 0) 合计购买行李金额,
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
          null
       end 托运行李重量,
       count(1) 机票量,
       case
         when t1.weight_free >= l.bagw then
          '不需要'
         else
          '需要'
       end 是否需要购买行李
  from dw.fact_recent_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id = t2.segment_head_id
/*left join dw.fact_combo_ticket c on t1.flights_order_head_id =
                                      c.flights_order_head_id*/
  left join dw.fact_luggage_detail l on t1.flights_order_head_id =
                                        l.flights_order_head_id
  left join dw.da_restrict_userinfo b on t1.client_id = b.users_id
 where t1.whole_flight like '9C%'
   and t1.flights_date >= to_date('2019-01-01', 'yyyy-mm-dd')
   and t1.flights_date < to_date('2019-03-27', 'yyyy-mm-dd')
   and t1.flag_id in (3, 5, 40, 41)
   and t1.seats_name is not null
 group by to_char(t1.flights_date, 'yyyy'),
          to_char(t1.flights_date, 'mm'),
          t1.flights_date,
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
          end,
          t1.seat_type,
          t1.nationflag,
          t2.originairport_name,
          t2.flights_segment_name,
          case
            when t1.seats_name in ('B', 'G', 'G1', 'G2', 'O') then
             'BGO'
            else
             '非BGO'
          end,
          /*case
            when c.flights_order_head_id is not null then
             '套票'
            else
             '非套票'
          end,*/
          t1.weight_free,
       greatest(nvl(l.weight_web, 0), 0),
       greatest(nvl(l.fee_web, 0), 0),
       greatest(nvl(l.weight_gt, 0), 0) + greatest(nvl(l.weight_zz, 0), 0) +
       greatest(nvl(l.weight_xc, 0), 0),
       greatest(nvl(l.fee_gt, 0), 0) + greatest(nvl(l.fee_zz, 0), 0) +
       greatest(nvl(l.fee_xc, 0), 0),
       greatest(nvl(l.weight_web, 0), 0) + greatest(nvl(l.weight_gt, 0), 0) +
       greatest(nvl(l.weight_zz, 0), 0) + greatest(nvl(l.weight_xc, 0), 0),
       greatest(nvl(l.fee_web, 0), 0) + greatest(nvl(l.fee_gt, 0), 0) +
       greatest(nvl(l.fee_zz, 0), 0) + greatest(nvl(l.fee_xc, 0), 0),
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
          null
       end,
       case
         when t1.weight_free >= l.bagw then
          '不需要'
         else
          '需要'
       end;


----------------------------------------------------------------------------------------------------------------------------------------------------------------------


/*年、月、日期、航线性质、始发站、航段、线上购买行李金额、线下购买行李金额、线上购买行李重量、
线下行李重量、实际托运行李重量、航班量、机票量
*/ /*20210101~20210327*/

select to_char(t1.flights_date, 'yyyy') 年,
       to_char(t1.flights_date, 'mm') 月,
       t1.flights_date 航班日期,
       t1.nationflag 航线性质,
       t2.originairport_name 始发站,
       t2.flights_segment_name 航段,
       sum(greatest(nvl(l.weight_web, 0), 0)) 线上购买行李重量,
       sum(greatest(nvl(l.fee_web, 0), 0)) 线上购买行李金额,
       sum(greatest(nvl(l.weight_gt, 0), 0) +
           greatest(nvl(l.weight_zz, 0), 0) +
           greatest(nvl(l.weight_xc, 0), 0)) 线下购买行李重量,
       sum(greatest(nvl(l.fee_gt, 0), 0) + greatest(nvl(l.fee_zz, 0), 0) +
           greatest(nvl(l.fee_xc, 0), 0)) 线下购买行李金额,
       sum(greatest(nvl(l.weight_web, 0), 0) +
           greatest(nvl(l.weight_gt, 0), 0) +
           greatest(nvl(l.weight_zz, 0), 0) +
           greatest(nvl(l.weight_xc, 0), 0)) 合计购买行李重量,
       sum(greatest(nvl(l.fee_web, 0), 0) + greatest(nvl(l.fee_gt, 0), 0) +
           greatest(nvl(l.fee_zz, 0), 0) + greatest(nvl(l.fee_xc, 0), 0)) 合计购买行李金额,
       sum(nvl(l.bagw, 0)) 实际托运行李重量,
       count(1) 机票量,
       count(distinct t2.flights_id) 航班量
  from dw.fact_recent_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id = t2.segment_head_id
  left join dw.fact_luggage_detail l on t1.flights_order_head_id =
                                        l.flights_order_head_id
 where t1.whole_flight like '9C%'
   and t1.flights_date >= to_date('2021-01-01', 'yyyy-mm-dd')
   and t1.flights_date < to_date('2021-03-27', 'yyyy-mm-dd')
   and t1.flag_id in (3, 5, 40, 41)
   and t1.seats_name is not null
 group by to_char(t1.flights_date, 'yyyy'),
          to_char(t1.flights_date, 'mm'),
          t1.flights_date,
          t1.nationflag,
          t2.originairport_name,
          t2.flights_segment_name;

----------------------------------------------------------------------------------------------------------------------------------------------------------------------



/*年、月、日期、航线性质、始发站、航段、线上购买行李金额、线下购买行李金额、线上购买行李重量、
线下行李重量、实际托运行李重量、航班量、机票量*//*20190101~20190327*/


select to_char(t1.flights_date, 'yyyy') 年,
       to_char(t1.flights_date, 'mm') 月,
       t1.flights_date 航班日期,
       t1.nationflag 航线性质,
       t2.originairport_name 始发站,
       t2.flights_segment_name 航段,
       sum(greatest(nvl(l.weight_web, 0), 0)) 线上购买行李重量,
       sum(greatest(nvl(l.fee_web, 0), 0)) 线上购买行李金额,
       sum(greatest(nvl(l.weight_gt, 0), 0) +
           greatest(nvl(l.weight_zz, 0), 0) +
           greatest(nvl(l.weight_xc, 0), 0)) 线下购买行李重量,
       sum(greatest(nvl(l.fee_gt, 0), 0) + greatest(nvl(l.fee_zz, 0), 0) +
           greatest(nvl(l.fee_xc, 0), 0)) 线下购买行李金额,
       sum(greatest(nvl(l.weight_web, 0), 0) +
           greatest(nvl(l.weight_gt, 0), 0) +
           greatest(nvl(l.weight_zz, 0), 0) +
           greatest(nvl(l.weight_xc, 0), 0)) 合计购买行李重量,
       sum(greatest(nvl(l.fee_web, 0), 0) + greatest(nvl(l.fee_gt, 0), 0) +
           greatest(nvl(l.fee_zz, 0), 0) + greatest(nvl(l.fee_xc, 0), 0)) 合计购买行李金额,
       sum(nvl(l.bagw, 0)) 实际托运行李重量,
       count(1) 机票量,
       count(distinct t2.flights_id) 航班量
  from dw.fact_recent_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id = t2.segment_head_id
  left join dw.fact_luggage_detail l on t1.flights_order_head_id =
                                        l.flights_order_head_id
 where t1.whole_flight like '9C%'
   and t1.flights_date >= to_date('2019-01-01', 'yyyy-mm-dd')
   and t1.flights_date < to_date('2019-03-27', 'yyyy-mm-dd')
   and t1.flag_id in (3, 5, 40, 41)
   and t1.seats_name is not null
 group by to_char(t1.flights_date, 'yyyy'),
          to_char(t1.flights_date, 'mm'),
          t1.flights_date,
          t1.nationflag,
          t2.originairport_name,
          t2.flights_segment_name;

