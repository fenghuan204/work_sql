--查询表备注
select t.owner,t.table_name,t.table_type,t.comments,t1.column_name,t1.comments
 from dba_tab_comments t
 join dba_col_comments t1 on t.owner=t1.owner and t.table_name=t1.table_name
 where t1.comments like '%备注%'

 ---航季数据
select season,min(fdate),max(fdate)
from(
select to_date('2005-07-18','yyyy-mm-dd')+rownum-1 fdate, hdb.getseason(to_date('2005-07-18','yyyy-mm-dd')+rownum-1) season
 from dual
 connect by rownum<=30000)
 group by season;



-------------------------渠道占比-----------------------------------------

select '订单日期含退票' 类型,
to_char(t1.order_day,'yyyymm'),
       case when t1.channel in('网站','手机') then '线上自有渠道'
            when t1.channel in('OTA','旗舰店') then 'OTA'
            when t1.sub_channel = 'CAACSC' then  'GP' 
            when t1.channel = 'B2G机构客户' then 'TMCB2G'
            else t1.channel end,
       count(1),
       sum(count(1))over(partition by to_char(t1.order_day,'yyyymm'))
 from dw.fact_recent_order_detail t1
 join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
 where t1.order_day>=date'2020-11-01'
   and t1.order_day< date'2022-01-12'
   and t1.seats_name is not null 
   and t1.seats_name not in('B','G1','G','G2')
   group by to_char(t1.order_day,'yyyymm'), case when t1.channel in('网站','手机') then '线上自有渠道'
            when t1.channel in('OTA','旗舰店') then 'OTA'
            when t1.sub_channel = 'CAACSC' then  'GP' 
            when t1.channel = 'B2G机构客户' then 'TMCB2G'
            else t1.channel end
   
   
 union all
 
 
 select '航班日期已乘机' 类型,to_char(t1.flights_date,'yyyymm'),
       case when t1.channel in('网站','手机') then '线上自有渠道'
            when t1.channel in('OTA','旗舰店') then 'OTA'
            when t1.sub_channel = 'CAACSC' then  'GP' 
            when t1.channel = 'B2G机构客户' then 'TMCB2G'
            else t1.channel end,
       count(1),
       sum(count(1))over(partition by to_char(t1.flights_date,'yyyymm'))
 from dw.fact_recent_order_detail t1
 join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
 where t1.flights_date>=date'2020-11-01'
   and t1.flights_date< date'2022-01-12'
   and t1.seats_name is not null 
   and t1.flag_id=40
   and t1.seats_name not in('B','G1','G','G2')
   group by to_char(t1.flights_date,'yyyymm'), case when t1.channel in('网站','手机') then '线上自有渠道'
            when t1.channel in('OTA','旗舰店') then 'OTA'
            when t1.sub_channel = 'CAACSC' then  'GP' 
            when t1.channel = 'B2G机构客户' then 'TMCB2G'
            else t1.channel end;
   


 ---客座率查询

 select sum(t1.checkin_mile)/sum(t1.checkin_s_mile) 值机客座率
 from dw.bi_tbl_plf t1
 where t1.flight_date>=to_date('2021-01-01','yyyy-mm-dd')
   and t1.flight_date< to_date('2022-01-01','yyyy-mm-dd');

--渠道占比
select t1.order_day,
case when t1.channel in('网站','手机') and t3.users_id is not null  then '代理'
     when t1.channel in('网站','手机') and t1.pay_gate in(15,29,31)  then '易宝商旅卡'
     when t1.channel in('OTA','旗舰店') then 'OTA'
     elee t1.channel end,count(1)   
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id = t2.segment_head_id
  left join dw.da_restrict_userinfo@to_ods t3 on t1.client_id = t3.users_id
  left join dw.dim_segment_type t4 on t2.route_Id = t4.route_Id and t2.h_route_id = t4.h_route_id
 where t2.flag <> 2
   and t1.order_day >= TRUNC(SYSDATE-30)
   and t1.order_day <= trunc(sysdate)
   and t1.seats_name is not NULL
   and t1.seats_name not in('B','G','G1','G2','O')
   and t1.company_id=0
   group by t1.order_day,
case when t1.channel in('网站','手机') and t3.users_id is not null  then '代理'
     when t1.channel in('网站','手机') and t1.pay_gate in(15,29,31)  then '易宝商旅卡'
     when t1.channel in('OTA','旗舰店') then 'OTA'
     elee t1.channel end;


---航班日期
select *
 from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id = t2.segment_head_id
  left join dw.da_restrict_userinfo@to_ods t3 on t1.client_id = t3.users_id
  left join dw.dim_segment_type t4 on t2.route_Id = t4.route_Id and t2.h_route_id = t4.h_route_id
 where t2.flag <> 2
   and t1.flights_date >= to_date('2018-01-01', 'yyyy-mm-dd')
   and t1.flights_date <= to_date('2018-01-01', 'yyyy-mm-dd')
   and t1.company_id = 0
   and t1.seats_name is not NULL
   and t1.seats_name not in('B','G','G1','G2','O');

---实时数据

select t1.r_flights_date,t1.whole_flight,t1.whole_segment,t1.name||' '||t1.second_name,t.work_tel,t.email,t1.r_tel
 from cqsale.cq_order@to_air t
 join cqsale.cq_order_head@to_air t1 on t.flights_order_id=t1.flights_order_id
 join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
 where t1.r_flights_date=to_date('2021-07-03','yyyy-mm-dd')
   and t2.flights_city_name like '%%'
   and t1.flag_id in(3,5,40,41,7,11,12);


 select sum(h1.ticketnum),sum(splan)
from(
select t1.segment_head_id,t2.oversale-t2.bgo_plan+t2.o_plan splan,count(1) ticketnum
 from cqsale.cq_order_head@to_air t1
 join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
 where t1.r_flights_date>=to_date('2019-04-01','yyyy-mm-dd')
   and t1.r_flights_date<=to_date('2019-04-30','yyyy-mm-dd')
   and t1.seats_name not in('B','G','G1','G2')
   and t2.nationflag='??'
   and t1.seats_name is not null
   and t1.flag_id =40
   and t1.r_order_date<=to_date('2019-03-31 ','yyyy-mm-dd')
 group by t1.segment_head_id,t2.oversale-t2.bgo_plan+t2.o_plan)h1;

----------------------------提前期/机票类型/-------------------------------------

select t1.order_day,
       case
         when t1.ahead_days <= 3 then
          '00~03'
         when t1.ahead_days <= 7 then
          '04~07'
         when t1.ahead_days <= 15 then
          '08~15'
         when t1.ahead_days <= 30 then
          '15~30'
         when t1.ahead_days <= 60 then
          '31~60'
         when t1.ahead_days <= 90 then
          '61~90'
         when t1.ahead_days > 90 then
          '90+'
       end,
       case
         when t1.is_swj >= 1 then
          '尊享飞'
         when t1.EX_CFD6 is not null then
          cp.set_name
         else
          '惠选飞'
       end,
       t2.segment_type,
       t2.flights_segment_name,
       t2.flights_city_name,
       t2.route_name,
       t9.wf_segment_name,
       t9.wf_city_name,
       t9.wf_segment,
       replace(replace(replace(t9.wf_segment, '虹桥', '上海'),
                       '浦东',
                       '上海'),
               '茅台',
               '遵义') wf_city,
       case
         when t1.channel in ('网站', '手机') and t8.users_id is not null then
          '代理'
         when t1.channel in ('网站', '手机') and
              regexp_like(t1.gate_name, '易宝|商旅卡') then
          '易宝商旅卡'
         when t1.channel in ('OTA', '旗舰店') then
          'OTA'
         else
          t1.channel
       end,
       case
         when t1.channel in ('网站', '手机') and t1.station_id <= 1 then
          '网站'
         when t1.channel in ('网站', '手机') and t1.station_id = 2 then
          'M站'
         when t1.channel in ('网站', '手机') and t1.station_id in (3, 8) then
          'IOS'
         when t1.channel in ('网站', '手机') and t1.station_id in (4, 9) then
          'Android'
         when t1.channel in ('网站', '手机') and t1.station_id in (5, 10, 6) then
          '小程序'
         else
          t1.sub_channel
       end,
       case
         when t4.flights_order_head_id is not null and
              nvl(t4.is_beneficiary, 0) = 1 then
          '亲友立减'
         when t4.flights_order_head_id is not null and
              nvl(t4.is_beneficiary, 0) = 0 then
          '绿翼立减'
         else
          '非绿翼立减'
       end 绿翼立减类型,
       case
         when t7.flights_order_head_id is not null then
          '套票'
         else
          '非套票'
       end 是否套票,
       case
         when t1.seats_name in ('P2', 'P5') and
              nvl(t3.cabin_name, '-') in ('P2', 'P5') and t.card_type = 1 then
          '省钱卡'
         when t1.seats_name in ('P2', 'P5') and nvl(t3.CARD_TYPE, 1) = 1 and
              t1.channel in ('网站', '手机') then
          '省钱卡'
         else
          '非省钱卡'
       end 是否省钱卡购票,
       case
         when tb1.age < 12 then
          '<12'
         when tb1.age < 18 then
          '12~17'
         when tb1.age < 24 then
          '18~23'
         when tb1.age <= 30 then
          '24~30'
         when tb1.age <= 40 then
          '31~40'
         when tb1.age <= 50 then
          '41~50'
         when tb1.age <= 60 then
          '51~60'
         when tb1.age <= 70 then
          '61~70'
         when tb1.age > 70 then
          '70+'
       end age,
       decode(tb1.gender, 0, '-', 1, '男', 2, '女') gender,
       count(1),
       sum(t1.ticket_price),
       sum(t1.price)
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id = t2.segment_head_id
  left join dw.dim_comb_product cp on cp.type_id = t1.ex_cfd6
                                  and cp.id = nvl(t1.ex_nfd4, 1) --组合产品维表
  left join cqsale.cq_card99_order_record@to_air t3 on t3.order_head_id =
                                                       t1.flights_order_head_id --省钱卡
  left join dw.fact_combo_ticket t7 on t1.flights_order_head_id =
                                       t7.flights_order_head_id --套票
  left join dw.da_restrict_userinfo@to_ods t8 on t1.client_id = t8.users_id --黑代识别
  left join dw.dim_segment_type t9 on t2.h_route_id = t9.h_route_id
                                  and t2.route_id = t9.route_id --往返航线维表
  left join dw.bi_order_region tb1 on t1.flights_order_head_id =
                                      tb1.flights_order_head_id --归属地判断
  left join (select t1.flights_order_head_id,
                    nvl(t1.is_beneficiary, 0) is_beneficiary,
                    t1.youhui_result
               from stg.c_cq_order_youhui_detail t1 --绿翼立减
               join stg.c_cq_youhui_policy_main t2 on t1.youhui_id = t2.id
              where t1.product_type = 0
                and t1.yh_ret_time is null
                and t1.youhui_result is not null
                and t2.YH_STYLE = 2
                and t1.create_date >= trunc(sysdate) - 7) t4 on t1.flights_order_head_id =
                                                                t4.flights_order_head_id
 where t1.order_day >= trunc(sysdate) - 1
   and t1.order_day < trunc(sysdate)
   and t1.seats_name not in ('B', 'G', 'G1', 'G2', 'O')
   and t2.flag <> 2
   and t1.flag_id in (3, 5, 40, 41)
   and t1.seats_name is not null
   and t1.whole_flight like '9C%'
 group by t1.order_day,
          case
            when t1.ahead_days <= 3 then
             '00~03'
            when t1.ahead_days <= 7 then
             '04~07'
            when t1.ahead_days <= 15 then
             '08~15'
            when t1.ahead_days <= 30 then
             '15~30'
            when t1.ahead_days <= 60 then
             '31~60'
            when t1.ahead_days <= 90 then
             '61~90'
            when t1.ahead_days > 90 then
             '90+'
          end,
          case
            when t1.is_swj >= 1 then
             '尊享飞'
            when t1.EX_CFD6 is not null then
             cp.set_name
            else
             '惠选飞'
          end,
          t2.segment_type,
          t2.flights_segment_name,
          t2.flights_city_name,
          t2.route_name,
          t9.wf_segment_name,
          t9.wf_city_name,
          t9.wf_segment,
          replace(replace(replace(t9.wf_segment, '虹桥', '上海'),
                          '浦东',
                          '上海'),
                  '茅台',
                  '遵义'),
          case
            when t1.channel in ('网站', '手机') and t8.users_id is not null then
             '代理'
            when t1.channel in ('网站', '手机') and
                 regexp_like(t1.gate_name, '易宝|商旅卡') then
             '易宝商旅卡'
            when t1.channel in ('OTA', '旗舰店') then
             'OTA'
            else
             t1.channel
          end,
          case
            when t1.channel in ('网站', '手机') and t1.station_id <= 1 then
             '网站'
            when t1.channel in ('网站', '手机') and t1.station_id = 2 then
             'M站'
            when t1.channel in ('网站', '手机') and t1.station_id in (3, 8) then
             'IOS'
            when t1.channel in ('网站', '手机') and t1.station_id in (4, 9) then
             'Android'
            when t1.channel in ('网站', '手机') and t1.station_id in (5, 10, 6) then
             '小程序'
            else
             t1.sub_channel
          end,
          case
            when t4.flights_order_head_id is not null and
                 nvl(t4.is_beneficiary, 0) = 1 then
             '亲友立减'
            when t4.flights_order_head_id is not null and
                 nvl(t4.is_beneficiary, 0) = 0 then
             '绿翼立减'
            else
             '非绿翼立减'
          end,
          case
            when t7.flights_order_head_id is not null then
             '套票'
            else
             '非套票'
          end,
          case
            when tb1.age < 12 then
             '<12'
            when tb1.age < 18 then
             '12~17'
            when tb1.age < 24 then
             '18~23'
            when tb1.age <= 30 then
             '24~30'
            when tb1.age <= 40 then
             '31~40'
            when tb1.age <= 50 then
             '41~50'
            when tb1.age <= 60 then
             '51~60'
            when tb1.age <= 70 then
             '61~70'
            when tb1.age > 70 then
             '70+'
          end,
          decode(tb1.gender, 0, '-', 1, '男', 2, '女'),
          case
            when t1.seats_name in ('P2', 'P5') and
                 nvl(t3.cabin_name, '-') in ('P2', 'P5') and t.card_type = 1 then
             '省钱卡'
            when t1.seats_name in ('P2', 'P5') and nvl(t3.CARD_TYPE, 1) = 1 and
                 t1.channel in ('网站', '手机') then
             '省钱卡'
            else
             '非省钱卡'
          end;






---会员注册来源

select t1.cust_typename,
       decode(t1.source_flag, 0, '线上', 1, '线下') 线上线下,
       decode(t2.AUTHENTICATION_METHODS,
              1,
              '线下审核',
              2,
              '支付宝',
              3,
              '微信',
              4,
              '联名卡',
              5,
              '值机',
              6,
              '京东认证',
              7,
              '金银卡认证',
              8,
              '扫脸认证',
              9,
              '白花花认证',
              10,
              '四要素',
              11,
              '钱包认证'),
       
       count(1) 注册量,
       min(t1.reg_date),
       max(t1.reg_date)
  from dw.da_lyuser t1
  left join cqsale.cq_users_huiyuan_change@to_air t2 on t1.CUST_ID =
                                                        t2.cust_id
 where t1.birthday >= to_date('2009-07-16', 'yyyy-mm-dd')
   and t1.codetype = 1
   and length(t1.codeno) = 18
 group by t1.cust_typename,
          decode(t1.source_flag, 0, '线上', 1, '线下'),
          decode(t2.AUTHENTICATION_METHODS,
                 1,
                 '线下审核',
                 2,
                 '支付宝',
                 3,
                 '微信',
                 4,
                 '联名卡',
                 5,
                 '值机',
                 6,
                 '京东认证',
                 7,
                 '金银卡认证',
                 8,
                 '扫脸认证',
                 9,
                 '白花花认证',
                 10,
                 '四要素',
                 11,
                 '钱包认证');




case when age<12 then '<12'
     when age<18 then '12~17'
     when age<24 then '18~23'
     when age<=30 then '24~30'
     when age<=40 then '31~40'
     when age<=50 then '41~50'
     when age<=60 then '51~60'
     when age>=60 then '60+' end age



select t.order_date 订单日期,t.order_linkman 订票联系人,t.work_tel 订票联系方式, t.email 订票人邮箱,
c.channel 渠道大类,c.terminal 终端,CASE WHEN t.terminal_id<=0 and t.web_id=0 and t5.users_id is  not null then '黑代'
else '非黑代' end 是否黑代,
t1.r_flights_date 航班日期,t1.whole_flight 航班号,t1.whole_segment 航段,
t1.name||coalesce(t1.second_name,'') 旅客姓名 ,t1.codetype 证件类型,t1.codeno 证件号,
decode(t1.sex,1,'成人',2,'儿童',3,'婴儿') 乘机人类型,
getage(t1.r_flights_date,t1.birthday) 年龄,
case when getage(t1.r_flights_date,t1.birthday)<12 then '<12'
            when getage(t1.r_flights_date,t1.birthday)<18 then '12~17'
            when getage(t1.r_flights_date,t1.birthday)<24 then '18~23'
            when getage(t1.r_flights_date,t1.birthday)<30 then '24~29'
            when getage(t1.r_flights_date,t1.birthday)<40 then '30~39'
            when getage(t1.r_flights_date,t1.birthday)<50 then '40~49'
            when getage(t1.r_flights_date,t1.birthday)<60 then '50~59'
            when getage(t1.r_flights_date,t1.birthday)< 70 then '60~69'
            when getage(t1.r_flights_date,t1.birthday)>=70 then '70+' end 年龄分层,
   CASE WHEN t3.nationality='CHN' THEN '中国'
          WHEN t3.nationality IS NULL THEN '中国'
          ELSE t6.country_name END 国籍,
     CASE WHEN (CASE WHEN t3.nationality='CHN' THEN '中国'
          WHEN t3.nationality IS NULL THEN '中国'
          ELSE t6.country_name END) like '%中国%' THEN      
          CASE WHEN t.terminal_id<=0 and t.web_id=0 and t5.users_id is  not null 
          and tt1.province is not null then tt1.province
          when  t8.province IS NOT NULL THEN t8.province
               WHEN t8.province IS NULL AND tt1.province IS NOT NULL THEN tt1.province
               ELSE NULL END 
          ELSE NULL END 省份,
      CASE WHEN ((CASE WHEN t3.nationality='CHN' THEN '中国'
          WHEN t3.nationality IS NULL THEN '中国'
          ELSE t6.country_name END)) like '%中国%' THEN 
      CASE WHEN t.terminal_id<=0 and t.web_id=0 and t5.users_id is  not null 
          and tt1.province is not null then tt1.city
           WHEN t8.province IS NOT NULL THEN t8.city
               WHEN t8.province IS NULL AND tt1.province IS NOT NULL THEN tt1.city
               ELSE NULL END 
          ELSE NULL END 城市
from cqsale.cq_order@to_air t
join cqsale.cq_order_head@to_air t1 on t.flights_order_id=t1.flights_order_id
left join dw.da_restrict_userinfo t5 on t.client_id=t5.users_id
left join dw.adt_mobile_list t8 on regexp_like(t1.r_tel, '^1[0-9]{10}$')
                          and substr(t1.r_tel, 1, 7) = t8.mobilenumber
left join dw.adt_region_code tt1 on t1.codetype = 1
                        and tt1.regioncode=substr(t1.codeno, 1, 6)
   left join cqsale.cq_traveller_info@to_air t3 on t1.flights_order_head_id=t3.flights_order_head_id
   left join stg.s_cq_country_area t6 on t3.nationality=t6.country_code  
    left join dw.da_channel_part c on c.terminal_id = t.terminal_id
                                and c.web_id = nvl(t.web_id, 0)
                                and c.station_id =
                                    (case when t.terminal_id < 0 and
                                     nvl(t.ex_nfd1, 0) <= 1 then 1 else
                                     nvl(t.ex_nfd1, 0) end)
                                and t.order_date >= c.sdate
                                and t.order_date < c.edate + 1
where t1.whole_flight in('9C8532','9C8531')
and t1.r_flights_date=trunc(sysdate)+1
and t1.flag_id in(3,5,40,41);


   

--================运营商号码判断===============================================================================

select split_part(timestamp, ' ', 1),
       case
         when substr(t1.phone, 1, 4) in ('1708', '1704', '1709', '1707') then
          '联通'
         when substr(t1.phone, 1, 4) in ('1703', '1705', '1706') then
          '移动'
         when substr(t1.phone, 1, 4) in ('1701', '1702', '1349') then
          '电信'
         when substr(t1.phone, 1, 3) in ('133',
                                         '153',
                                         '162',
                                         '168',
                                         '169',
                                         '173',
                                         '174',
                                         '177',
                                         '179',
                                         '180',
                                         '181',
                                         '189',
                                         '189',
                                         '191',
                                         '196',
                                         '197',
                                         '199') then
          '电信'
         when substr(t1.phone, 1, 3) in ('130',
                                         '131',
                                         '132',
                                         '140',
                                         '146',
                                         '155',
                                         '156',
                                         '163',
                                         '166',
                                         '167',
                                         '171',
                                         '175',
                                         '176',
                                         '185',
                                         '186',
                                         '192',
                                         '193') then
          '联通'
         when substr(t1.phone, 1, 3) in ('134',
                                         '135',
                                         '136',
                                         '137',
                                         '138',
                                         '139',
                                         '144',
                                         '147',
                                         '148',
                                         '150',
                                         '151',
                                         '152',
                                         '157',
                                         '158',
                                         '159',
                                         '165',
                                         '172',
                                         '178',
                                         '182',
                                         '183',
                                         '184',
                                         '187',
                                         '188',
                                         '195',
                                         '198') then
          '移动'
       end
       
      , 
       count(1)
  from dw.fact_threevaild_detail t1
 where t1.respcode in
       ('P300', 'P301', 'P305', 'P306', 'P307', 'SJ', 'NM', 'ID')
 group by split_part(timestamp, ' ', 1),
       case
         when substr(t1.phone, 1, 4) in ('1708', '1704', '1709', '1707') then
          '联通'
         when substr(t1.phone, 1, 4) in ('1703', '1705', '1706') then
          '移动'
         when substr(t1.phone, 1, 4) in ('1701', '1702', '1349') then
          '电信'
         when substr(t1.phone, 1, 3) in ('133',
                                         '153',
                                         '162',
                                         '168',
                                         '169',
                                         '173',
                                         '174',
                                         '177',
                                         '179',
                                         '180',
                                         '181',
                                         '189',
                                         '189',
                                         '191',
                                         '196',
                                         '197',
                                         '199') then
          '电信'
         when substr(t1.phone, 1, 3) in ('130',
                                         '131',
                                         '132',
                                         '140',
                                         '146',
                                         '155',
                                         '156',
                                         '163',
                                         '166',
                                         '167',
                                         '171',
                                         '175',
                                         '176',
                                         '185',
                                         '186',
                                         '192',
                                         '193') then
          '联通'
         when substr(t1.phone, 1, 3) in ('134',
                                         '135',
                                         '136',
                                         '137',
                                         '138',
                                         '139',
                                         '144',
                                         '147',
                                         '148',
                                         '150',
                                         '151',
                                         '152',
                                         '157',
                                         '158',
                                         '159',
                                         '165',
                                         '172',
                                         '178',
                                         '182',
                                         '183',
                                         '184',
                                         '187',
                                         '188',
                                         '195',
                                         '198') then
          '移动'
       end;






---=================================================================================================


select h1.*
from(
select trunc(t1.modify_date) sdate,
case when t1.old_seat_name like 'P%' then 'P'
when t1.old_seat_name like 'R%' then 'R'
when regexp_like(t1.old_seat_name,'^(E|U|X|T|Q|N)') then 'EUXTQN'
when regexp_like(t1.old_seat_name,'^(Y|S|H|V|K|L|M)') then 'YSHVKLM'
else 'other' end seattype,
case when t1.old_seat_name is null then 'YE' 
when regexp_like(t1.old_seat_name,'^(P1|P2|P3|P4|P5)') then substr(t1.old_seat_name,1,2)
when regexp_like(t1.old_seat_name,'^(R1|R2|R3|R4)') then substr(t1.old_seat_name,1,2)
when t1.old_seat_name like 'P%' then 'P'
else substr(t1.old_seat_name,1,1) end old_seat_name,
case when t1.old_origin_std-t1.modify_date<0 then '???'
when (t1.old_origin_std-t1.modify_date)*24<2 then '[0,2H)'
when (t1.old_origin_std-t1.modify_date)*24<24 then '[2H,24H)'
when (t1.old_origin_std-t1.modify_date)<3 then '[24H,3D)'
when (t1.old_origin_std-t1.modify_date)<7 then '[3D,7D)'
when (t1.old_origin_std-t1.modify_date)>=7 then '7D+' end priod,
count(1) ticketnum,suM(t1.money_fy*t1.rate) myfy
from dw.da_order_change t1
join dw.da_flight t2 on t1.old_segment_id=t2.segment_head_id
where t1.modify_date>= trunc(sysdate-1)
  and t1.modify_date<= trunc(sysdate)
  group by trunc(t1.modify_date) ,
case when t1.old_seat_name like 'P%' then 'P'
when t1.old_seat_name like 'R%' then 'R'
when regexp_like(t1.old_seat_name,'^(E|U|X|T|Q|N)') then 'EUXTQN'
when regexp_like(t1.old_seat_name,'^(Y|S|H|V|K|L|M)') then 'YSHVKLM'
else '??' end ,case when t1.old_seat_name is null then 'YE' 
when regexp_like(t1.old_seat_name,'^(P1|P2|P3|P4|P5)') then substr(t1.old_seat_name,1,2)
when regexp_like(t1.old_seat_name,'^(R1|R2|R3|R4)') then substr(t1.old_seat_name,1,2)
when t1.old_seat_name like 'P%' then 'P'
else substr(t1.old_seat_name,1,1) end,case when t1.old_origin_std-t1.modify_date<0 then '???'
when (t1.old_origin_std-t1.modify_date)*24<2 then '[0,2H)'
when (t1.old_origin_std-t1.modify_date)*24<24 then '[2H,24H)'
when (t1.old_origin_std-t1.modify_date)<3 then '[24H,3D)'
when (t1.old_origin_std-t1.modify_date)<7 then '[3D,7D)'
when (t1.old_origin_std-t1.modify_date)>=7 then '7D+' end)h1
where h1.sdate>=trunc(sysdate-1)
  and h1.sdate<=trunc(sysdate)
  order by 1,decode(seattype,'YSHVKLM',1,'EUXTQN',2,'R',3,'P',4,'other',5),
  decode(old_seat_name,'Y',1,'S',2,'H',3,'V',4,'K',5,'L',6,'M',7,'N',8,'Q',9,'T',10,'X',11,'U',12,'E',13,'R1',14,'R2',15,'R3',16,'R4',17,'P',18,19),
  decode(priod,'???',1,'[0,2H)',2,'[2H,24H)',3,'[24H,3D)',4,'[3D,7D)',5,'7D+',6);



SELECT to_char(t1.flight_date,'yyyy') ,to_char(t1.flight_date,'yyyy-mm') ,
 CASE WHEN t1.qr_flag=1 THEN replace(replace(t4.wf_segment_name,'虹桥','上海'),'浦东','上海')
      WHEN t1.qr_flag IS NULL THEN replace(replace(t3.wf_segment_name,'虹桥','上海'),'浦东','上海') END,
      t1.flight_no,
      SUM(t1.flight_time),
      SUM(t1.day_income)
 FROM hdb.recent_flights_cost t1
 LEFT JOIN dw.da_flight t2 ON t1.qr_flag IS NULL AND t1.segment_head_id=t2.segment_head_id
 LEFT JOIN dw.adt_wf_segment t3 ON t2.h_route_id=t3.route_id
 LEFT JOIN dw.adt_wf_segment t4 ON t1.qr_flag=1 AND t1.flights_id=t4.route_id
 WHERE t1.flight_date>=to_date('2014-03-30','yyyy-mm-dd')
  and t1.flight_date< to_date('2016-10-30','yyyy-mm-dd')
   AND t1.total_cost> 0
   and t1.flight_time>0
   and ((t1.flight_date>=to_date('2014-03-30','yyyy-mm-dd')
  and t1.flight_date< to_date('2014-10-26','yyyy-mm-dd'))
  or (t1.flight_date>=to_date('2015-03-29','yyyy-mm-dd')
  and t1.flight_date< to_date('2015-10-25','yyyy-mm-dd'))
  or (t1.flight_date>=to_date('2016-03-27','yyyy-mm-dd')
  and t1.flight_date< to_date('2016-10-30','yyyy-mm-dd')))
   and t1.flight_no like '9C%'
 GROUP BY to_char(t1.flight_date,'yyyy') ,to_char(t1.flight_date,'yyyy-mm') ,
 CASE WHEN t1.qr_flag=1 THEN replace(replace(t4.wf_segment_name,'虹桥','上海'),'浦东','上海')
      WHEN t1.qr_flag IS NULL THEN replace(replace(t3.wf_segment_name,'虹桥','上海'),'浦东','上海') END,
      t1.flight_no

 
 ---------------------------------------------------实时渠道筛选--------------------------------------------------------------

cqsale.cq_order cqor
cqsale.cq_termial cqte
cqsale.cq_agent_info cqai 

 case
 when cqor.terminal_id < 0 and nvl(cqor.web_id, 0) = 0 and cqor.ex_nfd1 <=2 then '网站'
 when cqor.terminal_id < 0 and nvl(cqor.web_id, 0) = 0 and cqor.ex_nfd1 in(5,6,10) then '小程序'
 when cqor.terminal_id < 0 and nvl(cqor.web_id, 0) = 0 and cqor.ex_nfd1 in(3,8,4,9) then 'APP'
 when cqor.terminal_id in(300, 1233, 1309, 1330, 1400, 1401, 1516, 1571, 1801, 1802, 1803, 1805, 1806, 1807, 1808, 3505) then
            '呼叫中心'
 when cqor.terminal_id > 0 and regexp_like(cqte.terminal,'CAACSC|阿斯兰|宝钢国旅|95524|机构客户|集团客户|特航商旅|杭州万途|上海趣卫|华油阳光商旅') then
            'B2G机构客户'
 when regexp_like(cqai.abrv,'TMC|CAACSC|阿斯兰|宝钢国旅|95524|机构客户|集团客户|特航商旅|杭州万途|上海趣卫|华油阳光商旅') then 'B2G机构客户'
 when cqor.web_id > 0 and cqai.abrv like '%航信%' then 'B2B代理'
 when cqor.web_id in (240, 242, 312, 375, 1810, 2505, 3334) then 'B2B代理'
 when nvl(cqor.web_id, 0) > 0 and cqai.agent_type is null then  'B2B'
 when cqai.agent_id is not null then  decode(cqai.agent_type,1,'OTA', 2,'B2B代理', 4,'CPS', 5, 'B2G机构客户')
  end channel
        