
---1、数据查询通用SQL

select to_char(t1.flights_date,'yyyymm'),
       t1.channel,
       count(1) ticketnum,
       sum(count(1))over(partition by 1)
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  where t1.flights_date>=to_date('2019-01-01','yyyy-mm-dd')
    and t1.flights_date< to_date('2020-01-01','yyyy-mm-dd')
    and t2.flag<>2
    and t1.whole_flight like '9C%'
    and t1.seats_name is not null
    and t1.seats_name not in('B','G','G1','G2','O')
    and t1.flag_id in(3,5,40)
    group by t1.channel;


--涉及原始数据
select orderyear,
         case
         when getage(order_day, birthday) > 0 and
              getage(order_day, birthday) <= 12 then
          '0~12'
         when getage(order_day, birthday) > 12 and
              getage(order_day, birthday) <= 18 then
          '13~18'
         when getage(order_day, birthday) > 18 and
              getage(order_day, birthday) <= 23 then
          '19~23'
         when getage(order_day, birthday) > 23 and
              getage(order_day, birthday) <= 30 then
          '24~30'
         when getage(order_day, birthday)> 30 and
              getage(order_day, birthday) <= 40 then
          '31~40'
         when getage(order_day, birthday) > 40 and
              getage(order_day, birthday) <= 50 then
          '41~50'
         when getage(order_day, birthday) > 50 and
              getage(order_day, birthday) <= 60 then
          '51~60'
         when getage(order_day, birthday) > 60 and
              getage(order_day, birthday) <= 70 then
          '61~70'
         when getage(order_day, birthday) > 70 and
              getage(order_day, birthday) <= 120 then
          '70+'
         else
          '-'
       end 年龄段,
       count(1) 乘机人数
  from (select to_char(t1.r_order_date, 'yyyy') orderyear,
               trunc(t1.r_order_date) order_day,
               case
                 when t1.codetype = 1 AND getcardno('ID', t1.codeno) <> '-' then
                  getbirthday(t1.codeno)
                 else
                  case
                 when nvl(t7.birthday, t1.birthday) is not null then
                  nvl(t7.birthday, t1.birthday)
                 else
                  null
               end end  birthday              
          from stg.s_cq_order_head t1
          join dw.da_flight t2 on t1.segment_head_id = t2.segment_head_id
          left join stg.s_cq_traveller_info t7 on t1.flights_order_head_id =
                                                  t7.flights_order_head_id
         where t1.whole_flight like '9C%'
           and t1.flag_id in(3,5,40)
           and t2.flag <> 2
           and t1.seats_name is not null         
           )
 group by orderyear,
         case
         when getage(order_day, birthday) > 0 and
              getage(order_day, birthday) <= 12 then
          '0~12'
         when getage(order_day, birthday) > 12 and
              getage(order_day, birthday) <= 18 then
          '13~18'
         when getage(order_day, birthday) > 18 and
              getage(order_day, birthday) <= 23 then
          '19~23'
         when getage(order_day, birthday) > 23 and
              getage(order_day, birthday) <= 30 then
          '24~30'
         when getage(order_day, birthday)> 30 and
              getage(order_day, birthday) <= 40 then
          '31~40'
         when getage(order_day, birthday) > 40 and
              getage(order_day, birthday) <= 50 then
          '41~50'
         when getage(order_day, birthday) > 50 and
              getage(order_day, birthday) <= 60 then
          '51~60'
         when getage(order_day, birthday) > 60 and
              getage(order_day, birthday) <= 70 then
          '61~70'
         when getage(order_day, birthday) > 70 and
              getage(order_day, birthday) <= 120 then
          '70+'
         else
          '-'
       end


select case when t1.order_day>=to_date('20160903','yyyymmdd') then '本周'
            else '上周' end, case when t1.ahead_days<=3 then '00~03'
            when t1.ahead_days<=7 then '04~07'
            when t1.ahead_days<=14 then '08~14'
            when t1.ahead_days<=21 then '15~21'            
            when t1.ahead_days<=28 then '22~28'
            when t1.ahead_days<=35 then '29~35'
            when t1.ahead_days<=42 then '36~42'
            when t1.ahead_days<=49 then '43~49'
            when t1.ahead_days<=56 then '50~56'
            when t1.ahead_days<=63 then '57~63'
            when t1.ahead_days<=70 then '64~70'
            when t1.ahead_days<=77 then '71~77'
            when t1.ahead_days<=84 then '78~84'
            when t1.ahead_days<=91 then '85~91'
            when t1.ahead_days<=98 then '92~98'
            else '98+' end,  
            case when t1.channel='手机' and t1.station_id =2 then 'M网站'
            when t1.channel='手机' and t1.station_id in(5,10) then '微信'
            when t1.channel='手机' and t1.station_id in(3,8) then 'IOS'
            when t1.channel='手机' and t1.station_id in(4,9) then 'Andriod'
            else t1.channel end,t2.originairport_name,t2.destairport_name,
            t2.segment_country,t2.flights_segment_name,
            t6.wf_city_name,
            case when t1.channel in('手机','网站') and t5.users_id is not null then '代理'
            else '非代理' end  是否代理,
            count(1) 销量,
            sum(t1.ticket_price),
            sum(t1.price)
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  left join dw.da_restrict_userinfo t5 on t1.client_id=t5.users_id
  left join dw.adt_wf_segment t6 on t2.route_id=t6.route_id
  where t1.order_day>=to_date('2016-08-27','yyyy-mm-dd')
    and t1.order_day< to_date('2016-09-10','yyyy-mm-dd')
    and t2.flag<>2
    and t1.whole_flight like '9C%'
    and t1.seats_name is not null
    and t1.seats_name not in('B','G','G1','G2','O')
    group by case when t1.order_day>=to_date('20160903','yyyymmdd') then '本周'
            else '上周' end,case when t1.ahead_days<=3 then '00~03'
            when t1.ahead_days<=7 then '04~07'
            when t1.ahead_days<=14 then '08~14'
            when t1.ahead_days<=21 then '15~21'            
            when t1.ahead_days<=28 then '22~28'
            when t1.ahead_days<=35 then '29~35'
            when t1.ahead_days<=42 then '36~42'
            when t1.ahead_days<=49 then '43~49'
            when t1.ahead_days<=56 then '50~56'
            when t1.ahead_days<=63 then '57~63'
            when t1.ahead_days<=70 then '64~70'
            when t1.ahead_days<=77 then '71~77'
            when t1.ahead_days<=84 then '78~84'
            when t1.ahead_days<=91 then '85~91'
            when t1.ahead_days<=98 then '92~98'
            else '98+' end,
            case when t1.channel='手机' and t1.station_id =2 then 'M网站'
            when t1.channel='手机' and t1.station_id in(5,10) then '微信'
            when t1.channel='手机' and t1.station_id in(3,8) then 'IOS'
            when t1.channel='手机' and t1.station_id in(4,9) then 'Andriod'
            else t1.channel end,t2.originairport_name,t2.destairport_name,
            t2.segment_country,t2.flights_segment_name,
            t6.wf_city_name,
            case when t1.channel in('手机','网站') and t5.users_id is not null then '代理'
            else '非代理' end


select distinct  t2.flights_segment_name,t1.ticket_price
from dw.fact_order_detail t1
join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
where t1.seats_name='P2'
and t1.order_day=to_date('2017-03-09','yyyy-mm-dd')
and t1.company_id=0
and t2.flag<>2
and t2.flights_segment_name like '乌鲁木齐%'
and t2.flights_city_name like '%上海';



select distinct  t2.flights_segment_name,t1.ticket_price
from dw.fact_order_detail t1
join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
where t1.order_day>=to_date('2017-03-09','yyyy-mm-dd')
and t1.order_day< to_date('2017-03-09','yyyy-mm-dd')
and t1.company_id=0
and t2.flag<>2
and t1.seats_name not in('B','G','G1','G2','O')
and t2.flights_segment_name like '乌鲁木齐%'
and t2.flights_city_name like '%上海';



select /*+parallel(8) */
count(1)
from dw.fact_order_detail  t1
join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
where t1.flights_date>=to_date('2015-01-01','yyyy_mm-dd')
and t2.segment_country in('韩国')
and t2.dest_country_id>0
and t1.flag_id=40
and t1.company_id=0
and t1.seats_name is not null



---2、原始数据表--渠道占比通用SQL

select to_char(t.order_date,'yyyy-mm-dd') order_day,
case
           when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and t.ex_nfd1 > 1 then
            '手机'
           when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and t.ex_nfd1 <= 1 then
            '网站'
           when t.order_date >= to_date('2017-06-01', 'yyyy-mm-dd') and
                t.terminal_id < 0 and t.web_id = 2185 then
            '旗舰店'
           when t.order_date >= to_date('2016-11-01', 'yyyy-mm-dd') and
                t.terminal_id < 0 and t.web_id = 2185 then
            '网站'
           when t.order_date >= to_date('2016-11-23', 'yyyy-mm-dd') and
                t.web_id = 435 then
            '旗舰店'
           when t.web_id > 0 and
                regexp_like(t4.abrv, '(CAACSC)|(95524)|(机构客户)|(集团客户)') then
            'B2G机构客户'
           when nvl(t.web_id, 0) > 0 and t4.agent_type is not null then
            decode(t4.agent_type,
                   1,
                   'OTA',
                   2,
                   'B2B代理',
                   4,
                   'CPS',
                   5,
                   'B2G机构客户')
           when nvl(t.web_id, 0) > 0 and t4.agent_type is null then
            'B2B'
           when t.terminal_id in
                (300, 1233, 1309, 1330, 1400, 1401, 1516, 1571, 1801, 1802, 1803, 1805, 1806, 1807, 1808) then
            '呼叫中心'
           when t.terminal_id not in
                (-1, -11, 300, 1233, 1309, 1330, 1400, 1401, 1516, 1571, 1801, 1802, 1803, 1805, 1806, 1807, 1808) and
                nvl(t.web_id, 0) = 0 and
                not regexp_like(t3.terminal, '(95524)|(机构客户)|(集团客户)') then
            'B2B'
           when t.terminal_id > 0 AND nvl(t.web_id, 0) = 0 and
                regexp_like(t3.terminal, '(95524)|(机构客户)|(集团客户)') then
            'B2G机构客户'
         end channel,
	   count(1) 
	   from stg.s_cq_order t
	   join stg.s_cq_order_head t1  on t.flights_order_id=t1.flights_order_id
	   join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
	   left join stg.s_cq_terminal t3 on t.terminal_id=t3.terminal_id
	   left join stg.s_cq_agent_info t4 on t.web_id=t4.agent_id
	   where t.order_date>=to_date('2016-01-01','yyyy-mm-dd')
         and t.order_date< to_date('2017-01-01','yyyy-mm-dd')
         and t2.flag<>2
         and t1.seats_name not in('B','G','G1','G2','O')
         and t1.whole_flight like '9C%'	 
group by to_char(t.order_date,'yyyy-mm-dd') order_day,
case
         when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and t.ex_nfd1 > 1 then
          '手机'
         when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and t.ex_nfd1 <= 1 then
          '网站'
         when t.order_date >= to_date('2016-11-01', 'yyyy-mm-dd') and
              t.web_id = 2185 then
          '网站'
         when t.order_date >= to_date('2016-11-23', 'yyyy-mm-dd') and
              t.web_id = 435 then
          '旗舰店'
         when t.web_id > 0 and
              regexp_like(t4.abrv, '(CAACSC)|(95524)|(机构客户)|(集团客户)') then
          'B2G机构客户'
         when nvl(t.web_id, 0) > 0 and t4.agent_type is not null then
          decode(t4.agent_type,
                 1,
                 'OTA',
                 2,
                 'B2B代理',
                 4,
                 'CPS',
                 5,
                 'B2G机构客户')
         when nvl(t.web_id, 0) > 0 and t4.agent_type is null then
          'B2B'
         when t.terminal_id in
              (300, 1233, 1309, 1330, 1400, 1401, 1516, 1571, 1801, 1802, 1803, 1805, 1806, 1807, 1808) then
          '呼叫中心'
         when t.terminal_id not in
              (-1, -11, 300, 1233, 1309, 1330, 1400, 1401, 1516, 1571, 1801, 1802, 1803, 1805, 1806, 1807, 1808) and
              nvl(t.web_id, 0) = 0 and
              not regexp_like(t3.terminal, '(95524)|(机构客户)|(集团客户)') then
          'B2B'
         when t.terminal_id > 0 AND nvl(t.web_id, 0) = 0 and
              regexp_like(t3.terminal, '(95524)|(机构客户)|(集团客户)') then
          'B2G机构客户'
       end
	   
	   
	   
	   
	   
	   ====活跃会员数据
	   
	   
	   
	  select case
         when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and t.ex_nfd1 =2 then
          'M网站'
         when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and t.ex_nfd1  in(5,10) then
          '微信'
          when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and t.ex_nfd1 > 1 then
          'APP'
         when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and t.ex_nfd1 <= 1  then
          '网站'
         when t.order_date >= to_date('2016-11-01', 'yyyy-mm-dd') and
              t.web_id = 2185 then
          '网站'
         when t.order_date >= to_date('2016-11-23', 'yyyy-mm-dd') and
              t.web_id = 435 then
          '旗舰店'
         when t.web_id > 0 and
              regexp_like(t4.abrv, '(CAACSC)|(95524)|(机构客户)|(集团客户)') then
          'B2G机构客户'
         when nvl(t.web_id, 0) > 0 and t4.agent_type is not null then
          decode(t4.agent_type,
                 1,
                 'OTA',
                 2,
                 'B2B代理',
                 4,
                 'CPS',
                 5,
                 'B2G机构客户')
         when nvl(t.web_id, 0) > 0 and t4.agent_type is null then
          'B2B'
         when t.terminal_id in
              (300, 1233, 1309, 1330, 1400, 1401, 1516, 1571, 1801, 1802, 1803, 1805, 1806, 1807, 1808) then
          '呼叫中心'
         when t.terminal_id not in
              (-1, -11, 300, 1233, 1309, 1330, 1400, 1401, 1516, 1571, 1801, 1802, 1803, 1805, 1806, 1807, 1808) and
              nvl(t.web_id, 0) = 0 and
              not regexp_like(t3.terminal, '(95524)|(机构客户)|(集团客户)') then
          'B2B'
         when t.terminal_id > 0 AND nvl(t.web_id, 0) = 0 and
              regexp_like(t3.terminal, '(95524)|(机构客户)|(集团客户)') then
          'B2G机构客户'
       end channel,
     count(distinct t.client_id) 
     from stg.s_cq_order t
     join stg.s_cq_order_head t1  on t.flights_order_id=t1.flights_order_id
     join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
     left join stg.s_cq_terminal t3 on t.terminal_id=t3.terminal_id
     left join stg.s_cq_agent_info t4 on t.web_id=t4.agent_id
     where t.order_date>=to_date('2017-03-01','yyyy-mm-dd')
         and t.order_date< to_date('2017-04-01','yyyy-mm-dd')
         and t2.flag<>2
         and t1.flag_id in(3,5,40,41,7,11,12)
         and t1.seats_name not in('B','G','G1','G2','O')
         and t1.whole_flight like '9C%'
         and t.terminal_id=-1
         group by case
         when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and t.ex_nfd1 =2 then
          'M网站'
         when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and t.ex_nfd1  in(5,10) then
          '微信'
          when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and t.ex_nfd1 > 1 then
          'APP'
         when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and t.ex_nfd1 <= 1  then
          '网站'
         when t.order_date >= to_date('2016-11-01', 'yyyy-mm-dd') and
              t.web_id = 2185 then
          '网站'
         when t.order_date >= to_date('2016-11-23', 'yyyy-mm-dd') and
              t.web_id = 435 then
          '旗舰店'
         when t.web_id > 0 and
              regexp_like(t4.abrv, '(CAACSC)|(95524)|(机构客户)|(集团客户)') then
          'B2G机构客户'
         when nvl(t.web_id, 0) > 0 and t4.agent_type is not null then
          decode(t4.agent_type,
                 1,
                 'OTA',
                 2,
                 'B2B代理',
                 4,
                 'CPS',
                 5,
                 'B2G机构客户')
         when nvl(t.web_id, 0) > 0 and t4.agent_type is null then
          'B2B'
         when t.terminal_id in
              (300, 1233, 1309, 1330, 1400, 1401, 1516, 1571, 1801, 1802, 1803, 1805, 1806, 1807, 1808) then
          '呼叫中心'
         when t.terminal_id not in
              (-1, -11, 300, 1233, 1309, 1330, 1400, 1401, 1516, 1571, 1801, 1802, 1803, 1805, 1806, 1807, 1808) and
              nvl(t.web_id, 0) = 0 and
              not regexp_like(t3.terminal, '(95524)|(机构客户)|(集团客户)') then
          'B2B'
         when t.terminal_id > 0 AND nvl(t.web_id, 0) = 0 and
              regexp_like(t3.terminal, '(95524)|(机构客户)|(集团客户)') then
          'B2G机构客户'
       end
	   
	   
	   =====注册归属地数据统计
	   
	   
	   
	 select case when  t1.reg_country ='中国' or t1.reg_country is null then '中国'
else t1.reg_country end,
            case when t1.reg_country ='中国' or t1.reg_country is null then   
case when t1.tel_province is not null and t1.tel_city is not null then t1.tel_province
            when t1.reg_province is not null and t1.reg_city is not null then t1.reg_province
            when t1.card_province is not null and t1.card_city is not null then t1.card_province
            else null end
            else null end ,
           case when t1.reg_country ='中国' or t1.reg_country is null then
     case when t1.tel_province is not null and t1.tel_city is not null then t1.tel_city
          when t1.reg_province is not null and t1.reg_city is not null then t1.reg_city
            when t1.card_province is not null and t1.card_city is not null then t1.card_city
            else null end
            else null end,
            count(1)                 
            
 from dw.da_b2c_user t1
 where t1.reg_day>=to_date('2017-01-01','yyyy-mm-dd')
   and t1.reg_day< trunc(sysdate)
 group by case when  t1.reg_country ='中国' or t1.reg_country is null then '中国'
else t1.reg_country end,
            case when t1.reg_country ='中国' or t1.reg_country is null then   
case when t1.tel_province is not null and t1.tel_city is not null then t1.tel_province
            when t1.reg_province is not null and t1.reg_city is not null then t1.reg_province
            when t1.card_province is not null and t1.card_city is not null then t1.card_province
            else null end
            else null end ,
           case when t1.reg_country ='中国' or t1.reg_country is null then
     case when t1.tel_province is not null and t1.tel_city is not null then t1.tel_city
          when t1.reg_province is not null and t1.reg_city is not null then t1.reg_city
            when t1.card_province is not null and t1.card_city is not null then t1.card_city
            else null end
            else null end
			
			
			
====值机柜台行李购买政策


select h1.flightmonth,h1.country,sum(case when h1.ba_af>0 and h1.country='日本' and h1.ba_af/(h1.price*0.015)<=15 then 300
when h1.ba_af>0 and h1.country='日本' and h1.ba_af/(h1.price*0.015)>15 then 300+ceil(h1.ba_af/(h1.price*0.015)-15)*100
when h1.ba_af>0 and h1.country='韩国' and h1.ba_af/(h1.price*0.015)<=15 then 300
when h1.ba_af>0 and h1.country='韩国' and h1.ba_af/(h1.price*0.015)>15 then 300+ceil(h1.ba_af/(h1.price*0.015)-15)*50
when h1.ba_af>0 and h1.country='其他' and h1.ba_af/(h1.price*0.015)<=10 then 300
when h1.ba_af>0 and h1.country='其他' and h1.ba_af/(h1.price*0.015)>10 then 300+ceil(h1.ba_af/(h1.price*0.015)-15)*50
when h1.ba_af>0 and h1.country='港澳台' and h1.ba_af/(h1.price*0.015)<=10 then 300
when h1.ba_af>0 and h1.country='港澳台' and h1.ba_af/(h1.price*0.015)>10 then 300+ceil(h1.ba_af/(h1.price*0.015)-15)*50
else 0 end
),sum(h1.ba_af)

from(
select case when greatest(t2.country_id,t3.country_id)=2 then '日本'
when greatest(t2.country_id,t3.country_id)=169 then '韩国'
when greatest(t2.country_id,t3.country_id) in(198,199,200) then '港澳台'
else '其他' end country,
t1.flights_no,to_char(t1.flights_date,'yyyymm') flightmonth,t1.flights_segment,t1.BA_AF,
t1.POS_BA,t1.BAGA,t1.bagw,t1.DCS_RL,t4.segment_head_id,t4.price
from stg.s_cq_dcs_money_h t1
join hdb.cq_airport t2 on substr(t1.flights_segment,1,3)=t2.threecodeforcity
join hdb.cq_airport t3 on substr(t1.flights_segment,4,3)=t3.threecodeforcity
join dw.da_flight t4 on t1.flights_no=t4.flight_no and t1.flights_date=t4.flight_date and t1.flights_segment=t4.segment_code
where FLIGHTS_DATE>=to_date('2016-01-01','yyyy-mm-dd')
  and FLIGHTS_DATE< to_date('2017-01-01','yyyy-mm-dd')
  and greatest(t2.country_id,t3.country_id)>0
  and t1.flights_No like '9C%')h1
  group by h1.flightmonth,h1.country


  
  ==================近期新加坡航线的同环比数据=======================================
  
  
  
  select '近期' 类型,count(1) 机票数
 from dw.fact_order_detail t
 join dw.da_flight t1 on t.segment_head_id=t1.segment_head_id
 left join dw.da_restrict_userinfo t2 on t.client_id=t2.users_id
 where t1.flights_segment_name in('新加坡－浦东','浦东－新加坡')
   and t.order_day>=to_date('2016-11-01','yyyy-mm-dd')
   and t.order_day< trunc(sysdate)
   and t.channel='网站'
   and t2.users_id is null
   
   
   union all 
   
  select '同比' 类型,count(1)
 from dw.fact_order_detail t
 join dw.da_flight t1 on t.segment_head_id=t1.segment_head_id
 left join dw.da_restrict_userinfo t2 on t.client_id=t2.users_id
 where t1.flights_segment_name in('新加坡－浦东','浦东－新加坡')
   and t.order_day>=to_date('2015-11-01','yyyy-mm-dd')
   and t.order_day< to_date('2016-04-20','yyyy-mm-dd')
   and t.channel='网站'
      and t2.users_id is null
      
      
      union all
      
       select '环比' 类型,count(1)
 from dw.fact_order_detail t
 join dw.da_flight t1 on t.segment_head_id=t1.segment_head_id
 left join dw.da_restrict_userinfo t2 on t.client_id=t2.users_id
 where t1.flights_segment_name in('新加坡－浦东','浦东－新加坡')
   and t.order_day>=to_date('2016-05-15','yyyy-mm-dd')
   and t.order_day< to_date('2016-11-01','yyyy-mm-dd')
   and t.channel='网站'
      and t2.users_id is null
	  
	  
====================年龄、性别分布=============================


select to_char(t.flights_date, 'yyyy') 航班年,
         case
         when t.sex > 1 then
          '00~12'
         when t.birthday is null then
          '无法判断'
         when getage(t.order_day, t.birthday) < 0 or
              getage(t.order_day, t.birthday) > 120 then
          '无法判断'
         when getage(t.order_day, t.birthday) <= 12 then
          '00~12'
         when getage(t.order_day, t.birthday) <= 22 then
          '13~22'
         when getage(t.order_day, t.birthday) <= 60 then
          '23~60'
         else
          '60+'
       end 年龄,
       count(1) 票数
  from dw.fact_order_detail t
  join dw.da_flight t2 on t2.segment_head_id = t.segment_head_id
 where t.company_id = 0
   and t.flights_date < to_date('2017-01-01', 'yyyy-mm-dd')
   and t.seats_name not in ('B', 'G', 'G1', 'G2')
   and t2.is_bsale = 0
 group by to_char(t.flights_date, 'yyyy'),
          to_char(t.flights_date, 'mm'),
          case
            when t.sex > 1 then
             '00~12'
            when t.birthday is null then
             '无法判断'
            when getage(t.order_day, t.birthday) < 0 or
                 getage(t.order_day, t.birthday) > 120 then
             '无法判断'
            when getage(t.order_day, t.birthday) <= 12 then
             '00~12'
            when getage(t.order_day, t.birthday) <= 22 then
             '13~22'
            when getage(t.order_day, t.birthday) <= 60 then
             '23~60'
            else
             '60+'
          end
		  
		  
=========================各舱位价格各舱位计划数============================================



select h1.seats_name 舱位,
       h1.money 金额,
       h2.remnant 剩余数,
       trunc(h3.origin_std) 起飞时间,
       h3.flights_segment 航段,
       h3.r_flights_no 航班号,
       h4.flights_segment_name 中文航段,
  from (select *
          from (select segment_head_id,
                       MONEY_E,
MONEY_H,
MONEY_I,
MONEY_K,
MONEY_L,
MONEY_M,
MONEY_N,
MONEY_P,
MONEY_P1,
MONEY_P2,
MONEY_P3,
MONEY_P4,
MONEY_P5,
MONEY_Q,
MONEY_R1,
MONEY_R2,
MONEY_R3,
MONEY_R4,
MONEY_S,
MONEY_T,
MONEY_U,
MONEY_V,
MONEY_X,
MONEY_Y                       
from cqsale.cq_flights_segment_head@to_air) unpivot(money for seats_name in (MONEY_E as 'E',
MONEY_H as 'H',
MONEY_I as 'I',
MONEY_K as 'K',
MONEY_L as 'L',
MONEY_M as 'M',
MONEY_N as 'N',
MONEY_P as 'P',
MONEY_P1 as 'P1',
MONEY_P2 as 'P2',
MONEY_P3 as 'P3',
MONEY_P4 as 'P4',
MONEY_P5 as 'P5',
MONEY_Q as 'Q',
MONEY_R1 as 'R1',
MONEY_R2 as 'R2',
MONEY_R3 as 'R3',
MONEY_R4 as 'R4',
MONEY_S as 'S',
MONEY_T as 'T',
MONEY_U as 'U',
MONEY_V as 'V',
MONEY_X as 'X',
MONEY_Y as 'Y'
))
                  ) h1
  join (select *
          from (select segment_head_id,
REMNANT_E,
REMNANT_H,
REMNANT_I,
REMNANT_K,
REMNANT_L,
REMNANT_M,
REMNANT_N,
REMNANT_P,
REMNANT_P1,
REMNANT_P2,
REMNANT_P3,
REMNANT_P4,
REMNANT_P5,
REMNANT_Q,
REMNANT_R1,
REMNANT_R2,
REMNANT_R3,
REMNANT_R4,
REMNANT_S,
REMNANT_T,
REMNANT_U,
REMNANT_V,
REMNANT_X,
REMNANT_Y
from cqsale.cq_flights_seats_amount@to_air) unpivot(remnant for seats_name in (
REMNANT_E AS 'E',
REMNANT_H AS 'H',
REMNANT_I AS 'I',
REMNANT_K AS 'K',
REMNANT_L AS 'L',
REMNANT_M AS 'M',
REMNANT_N AS 'N',
REMNANT_P AS 'P',
REMNANT_P1 AS 'P1',
REMNANT_P2 AS 'P2',
REMNANT_P3 AS 'P3',
REMNANT_P4 AS 'P4',
REMNANT_P5 AS 'P5',
REMNANT_Q AS 'Q',
REMNANT_R1 AS 'R1',
REMNANT_R2 AS 'R2',
REMNANT_R3 AS 'R3',
REMNANT_R4 AS 'R4',
REMNANT_S AS 'S',
REMNANT_T AS 'T',
REMNANT_U AS 'U',
REMNANT_V AS 'V',
REMNANT_X AS 'X',
REMNANT_Y AS 'Y'))) h2 on h1.segment_head_id =h2.segment_head_id and h1.seats_name =h2.seats_name
  join cqsale.cq_flights_segment_head@to_air h3 on h1.segment_head_id =
                                                   h3.segment_head_id
  join cqsale.cq_flights_seats_amount@to_air h5 on h1.segment_head_id=h5.segment_head_id
  left join dw.da_flight h4 on h3.segment_head_id = h4.segment_head_id
 where h3.origin_std >= trunc(sysdate)
   and h2.remnant > 0
   and h3.flag <> 2
   and h1.money>0
   and h3.r_flights_no like '9C%'
   
   
   
   
   
   
   
select 
       trunc(h3.origin_std) 起飞时间,
       h3.flights_segment 航段,
       h3.r_flights_no 航班号,
       h4.flights_segment_name 中文航段,
	   h1.seats_name 舱位,
       h1.money 金额,
  from (select *
          from (select segment_head_id,
                       MONEY_E,
MONEY_H,
MONEY_I,
MONEY_K,
MONEY_L,
MONEY_M,
MONEY_N,
MONEY_P,
MONEY_P1,
MONEY_P2,
MONEY_P3,
MONEY_P4,
MONEY_P5,
MONEY_Q,
MONEY_R1,
MONEY_R2,
MONEY_R3,
MONEY_R4,
MONEY_S,
MONEY_T,
MONEY_U,
MONEY_V,
MONEY_X,
MONEY_Y                       
from cqsale.cq_flights_segment_head@to_air) unpivot(money for seats_name in (MONEY_E as 'E',
MONEY_H as 'H',
MONEY_I as 'I',
MONEY_K as 'K',
MONEY_L as 'L',
MONEY_M as 'M',
MONEY_N as 'N',
MONEY_P as 'P',
MONEY_P1 as 'P1',
MONEY_P2 as 'P2',
MONEY_P3 as 'P3',
MONEY_P4 as 'P4',
MONEY_P5 as 'P5',
MONEY_Q as 'Q',
MONEY_R1 as 'R1',
MONEY_R2 as 'R2',
MONEY_R3 as 'R3',
MONEY_R4 as 'R4',
MONEY_S as 'S',
MONEY_T as 'T',
MONEY_U as 'U',
MONEY_V as 'V',
MONEY_X as 'X',
MONEY_Y as 'Y'
))
                  ) h1
  join (select *
          from (select segment_head_id,
                       plan_E,
plan_H,
plan_I,
plan_K,
plan_L,
plan_M,
plan_N,
plan_P,
plan_P1,
plan_P2,
plan_P3,
plan_P4,
plan_P5,
plan_Q,
plan_R1,
plan_R2,
plan_R3,
plan_R4,
plan_S,
plan_T,
plan_U,
plan_V,
plan_X,
plan_Y
from cqsale.cq_flights_seats_amount_plan@to_air) unpivot(plan for seats_name in (plan_E AS 'E',
plan_H AS 'H',
plan_I AS 'I',
plan_K AS 'K',
plan_L AS 'L',
plan_M AS 'M',
plan_N AS 'N',
plan_P AS 'P',
plan_P1 AS 'P1',
plan_P2 AS 'P2',
plan_P3 AS 'P3',
plan_P4 AS 'P4',
plan_P5 AS 'P5',
plan_Q AS 'Q',
plan_R1 AS 'R1',
plan_R2 AS 'R2',
plan_R3 AS 'R3',
plan_R4 AS 'R4',
plan_S AS 'S',
plan_T AS 'T',
plan_U AS 'U',
plan_V AS 'V',
plan_X AS 'X',
plan_Y AS 'Y'))) h2 on h1.segment_head_id =
                                                                                                                                                                                         h2.segment_head_id
                                                                                                                                                                                     and h1.seats_name =
                                                                                                                                                                                         h2.seats_name
  join cqsale.cq_flights_segment_head@to_air h3 on h1.segment_head_id =
                                                   h3.segment_head_id
  left join dw.da_flight h4 on h3.segment_head_id = h4.segment_head_id
 where h3.origin_std >= to_date('2016-07-01','yyyy-mm-dd')
   and h3.origin_std <  to_date('2017-09-01','yyyy-mm-dd')
   and h2.plan > 0
   and h3.flag <> 2
   and h1.money>0
   and h3.r_flights_no like '9C%'
   and to_char(h3.origin_std,'mm') in('07','08')
   
   
   
======================自采集数据项目========================================================


select date1,M.trmnl_tp,
       M.lang,
       M.channel1,
       M.channel2,
       case when M.lang = '简体中文' and split_part(M.cmpid, '_', 4) is not null then
          substr(M.cmpid, 1, instr(M.cmpid, '_', 1, 3) - 1)
         else
          M.cmpid
       end cmpid,
       sum(M.UV) UV,
       sum(M.PV) PV,
       sum(M.allorders) 提交订单数,
       sum(M.orders) 支付订单数,
       sum(M.tickets) 机票量,
       sum(M.ticketsale) 机票销售,
       sum(M.feesale) 辅收,
       sum(M.allsale) 总营收,
       sum(M.clients) 提交订单会员数,
       sum(M.pay_clients) 支付订单会员数,
       sum(M.first_clients) 首购会员数
  from (select trunc(visit_date) date1,
  trmnl_tp,
               case
                 when upper(lang) like '%CN%' then
                  '简体中文'
                 when upper(lang) like '%EN%' then
                  '英文'
                 when upper(lang) like '%HK%' then
                  '繁体中文'
                 when upper(lang) like '%JP%' then
                  '日文'
                 when upper(lang) like '%KR%' then
                  '韩文'
                 when upper(lang) like '%TH%' then
                  '泰文'
                 else
                  '简体中文'
               end lang,
               case
                 when trmnl_tp = '微信' then
                  '微信渠道'
                 when trmnl_tp = 'Android' then
                  '安卓渠道'
                 when trmnl_tp = 'IOS' then
                  'IOS渠道'
                 when trmnl_tp in ('网站', 'M站') and channel1 = '非广告流量' then
                  '直接流量'
                 else
                  channel1
               end channel1,
               case
                 when trmnl_tp = '微信' then
                  '微信渠道'
                 when trmnl_tp = 'Android' then
                  '安卓渠道'
                 when trmnl_tp = 'IOS' then
                  'IOS渠道'
                 when trmnl_tp in ('网站', 'M站') and channel2 = '非广告流量' then
                  '直接流量'
                 else
                  channel2
               end channel2,
               case when trmnl_tp in('IOS','Android') then '-' else cmpid end cmpid,
               sum(UV) UV,
               sum(PV) PV,
               0 allorders,
               0 orders,
               0 tickets,
               0 ticketsale,
               0 feesale,
               0 allsale，
               0 clients,
               0 pay_clients,
               0 first_clients  
          from dw.cj_sdaily_cmpid@to_ods
         where visit_date >= trunc(sysdate-8)
           and visit_date < trunc(sysdate)
           and trunc(visit_date) in(trunc(sysdate-1),trunc(sysdate-1-7),trunc(sysdate-2))
         group by trunc(visit_date),trmnl_tp,
                  case
                    when upper(lang) like '%CN%' then
                     '简体中文'
                    when upper(lang) like '%EN%' then
                     '英文'
                    when upper(lang) like '%HK%' then
                     '繁体中文'
                    when upper(lang) like '%JP%' then
                     '日文'
                    when upper(lang) like '%KR%' then
                     '韩文'
                    when upper(lang) like '%TH%' then
                     '泰文'
                    else
                     '简体中文'
                  end,
                  case
                    when trmnl_tp = '微信' then
                     '微信渠道'
                    when trmnl_tp = 'Android' then
                     '安卓渠道'
                    when trmnl_tp = 'IOS' then
                     'IOS渠道'
                    when trmnl_tp in ('网站', 'M站') and channel1 = '非广告流量' then
                     '直接流量'
                    else
                     channel1
                  end,
                  case
                    when trmnl_tp = '微信' then
                     '微信渠道'
                    when trmnl_tp = 'Android' then
                     '安卓渠道'
                    when trmnl_tp = 'IOS' then
                     'IOS渠道'
                    when trmnl_tp in ('网站', 'M站') and channel2 = '非广告流量' then
                     '直接流量'
                    else
                     channel2
                  end,
                  case when trmnl_tp in('IOS','Android') then '-' else cmpid end
     union
        select date2,roi.terminal,roi.lang,roi.channel1,roi.channel2,roi.cmpid,0 UV,0 PV,
        sum(roi.allorders) allorders,
        sum(roi.orders) orders,
        sum(roi.tickets) tickets,
        sum(case when roi.company_id=6 then roi.ticketsale/16 else roi.ticketsale end) ticketsale,
        sum(case when roi.company_id=6 then roi.valuesale/16 else roi.valuesale end) valuesale,
        sum(case when roi.company_id=6 then roi.allsale/16 else roi.allsale end) allsale,
        sum(roi.clients) clients,
        sum(roi.pay_clients) pay_clients,
        sum(roi.first_clients) first_clients   
from               
(select trunc(order_date) date2,r.terminal,r.order_language lang,
               case
                 when r.terminal = '微信' then
                  '微信渠道'
                 when r.terminal = 'Android' then
                  '安卓渠道'
                 when r.terminal = 'IOS' then
                  'IOS渠道'
                 when r.terminal in ('网站', 'M站') and r.ch1 = '非广告流量' then
                  '直接流量'
                 else ch1
               end channel1,
               case
                 when r.terminal = '微信' then
                  '微信渠道'
                 when r.terminal = 'Android' then
                  '安卓渠道'
                 when r.terminal = 'IOS' then
                  'IOS渠道'
                 when r.terminal in ('网站', 'M站') and r.ch2 = '非广告流量' then
                  '直接流量'
                 else ch2
               end channel2,
               nvl(r.cmpid,'-') cmpid,
               r.company_id,
               case when t5.users_id is not null then '代理' else '非代理' end client_flag,
               case when t6.users_id is not null then '首购' else '复购' end first_flag,
               count(distinct r.ordernum) allorders,
               count(distinct case
                       when r.flag_id = '已支付' then
                        r.ordernum
                       else
                        null
                     end) orders,
               sum(case
                     when r.flag_id = '已支付' then
                      r.tickets
                     else
                      0
                   end) tickets,
               sum(case
                     when r.flag_id = '已支付' then
                      r.ticketsale
                     else
                      0
                   end) ticketsale,
               sum(case
                     when r.flag_id = '已支付' then
                      r.valuesale
                     else
                      0
                   end) valuesale,
               sum(case
                     when r.flag_id = '已支付' then
                      r.allsale
                     else
                      0
                   end) allsale,
                count(distinct client_id) clients,
                count(distinct case when r.flag_id = '已支付' then r.client_id else null end) pay_clients,
                count(distinct case when t6.users_id is not null then r.client_id else null end) first_clients   
          from dw.cj_roi_order r
      join(select distinct t.flights_Order_id
 from stg.s_cq_order t
 join stg.s_cq_order_head t1 on t.flights_Order_id=t1.flights_order_id
 where t1.whole_segment like '%YTY%'
 and t.order_date>=trunc(sysdate-8)
 and t1.r_flights_date>=trunc(sysdate-30))ttt1 on r.ordernum=ttt1.flights_Order_id
          left join dw.da_restrict_userinfo t5 on t5.users_id=r.client_id
          left join dw.da_user_purchase t6 on t6.users_id= r.client_id and trunc(t6.first_orderdate)=r.order_date
      
         where order_date >= trunc(sysdate-8)
           and order_date < trunc(sysdate)
           and trunc(order_date) in(trunc(sysdate-1),trunc(sysdate-1-7),trunc(sysdate-2))
           and company_id=0
         group by trunc(order_date),terminal,
                  order_language,
                  case
                    when terminal = '微信' then
                     '微信渠道'
                    when terminal = 'Android' then
                     '安卓渠道'
                    when terminal = 'IOS' then
                     'IOS渠道'
                    when terminal in ('网站', 'M站') and ch1 = '非广告流量' then
                     '直接流量'
                    else
                     ch1
                  end,
                  case
                    when terminal = '微信' then
                     '微信渠道'
                    when terminal = 'Android' then
                     '安卓渠道'
                    when terminal = 'IOS' then
                     'IOS渠道'
                    when terminal in ('网站', 'M站') and ch2 = '非广告流量' then
                     '直接流量'
                    else
                     ch2
                  end,
                  cmpid,
                  company_id,
                  case when t5.users_id is not null then '代理' else '非代理' end,
                  case when t6.users_id is not null then '首购' else '复购' end)roi
    group by date2,roi.terminal,roi.lang,roi.channel1,roi.channel2,roi.cmpid
                  ) M
 group by date1,M.trmnl_tp,
       M.lang,
       M.channel1,
       M.channel2,
       case when M.lang = '简体中文' and split_part(M.cmpid, '_', 4) is not null then
          substr(M.cmpid, 1, instr(M.cmpid, '_', 1, 3) - 1)
         else
          M.cmpid
       end 
 order by M.trmnl_tp, M.lang


 
 
=================================================机票+辅助产品===============================



select  /*+parallel(8) */
to_char(t1.r_flights_date,'yyyy/mm'),case when t1.flag_id =40 then '已乘机'
when t1.flag_id in(7,11,12) then '退票' end,
case
         when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and t.ex_nfd1 =2 then
          'M网站'
          when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and t.ex_nfd1>2 then
          'APP'
         when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and t.ex_nfd1 <= 1 then
            '网站'
           when t.order_date >= to_date('2017-06-01', 'yyyy-mm-dd') and
                t.terminal_id < 0 and t.web_id = 2185 then
            '旗舰店'
           when t.order_date >= to_date('2016-11-01', 'yyyy-mm-dd') and
                t.terminal_id < 0 and t.web_id = 2185 then
            '网站'
           when t.order_date >= to_date('2016-11-23', 'yyyy-mm-dd') and
                t.web_id = 435 then
            '旗舰店'
           when t.web_id > 0 and
                regexp_like(t4.abrv, '(CAACSC)|(95524)|(机构客户)|(集团客户)') then
            'B2G机构客户'
           when nvl(t.web_id, 0) > 0 and t4.agent_type is not null then
            decode(t4.agent_type,
                   1,
                   'OTA',
                   2,
                   'B2B代理',
                   4,
                   'CPS',
                   5,
                   'B2G机构客户')
           when nvl(t.web_id, 0) > 0 and t4.agent_type is null then
            'B2B'
           when t.terminal_id in
                (300, 1233, 1309, 1330, 1400, 1401, 1516, 1571, 1801, 1802, 1803, 1805, 1806, 1807, 1808) then
            '呼叫中心'
           when t.terminal_id not in
                (-1, -11, 300, 1233, 1309, 1330, 1400, 1401, 1516, 1571, 1801, 1802, 1803, 1805, 1806, 1807, 1808) and
                nvl(t.web_id, 0) = 0 and
                not regexp_like(t3.terminal, '(95524)|(机构客户)|(集团客户)') then
            'B2B'
           when t.terminal_id > 0 AND nvl(t.web_id, 0) = 0 and
                regexp_like(t3.terminal, '(95524)|(机构客户)|(集团客户)') then
            'B2G机构客户'
         end channel,
     case when nvl(t1.seats_name,'-') in('B','G','G1','G2') then 'BG'
     else '非BG' end 是否BG,
     case when t.terminal_id=-1 and t.web_id=0 and t5.users_id is not null then '代理'
     else '非代理' end 是否代理,
     t2.nationflag,
     t2.segment_type,
     t2.segment_country,
     t2.originairport_name,
     t2.destairport_name,
     count(1) 机票销量,
     sum(h1.booknum) 选座数量,
     sum(h1.bookprice) 选座金额 

  from stg.s_cq_order t
  join stg.s_cq_order_head t1 on t.flights_order_id=t1.flights_order_id
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  left join (select h.order_head_id,sum(h.book_num) booknum,sum(h.book_price*h.r_com_rate) bookprice
                from stg.s_cq_other_order_head h
               where h.ex_nfd1=3
               and h.r_flights_date>=to_date('2017-05-01','yyyy-mm-dd')
               and h.r_flights_date< to_date('2017-07-01','yyyy-mm-dd') 
               and h.flag_id in(40,7,11,12)
               and h.whole_flight like '9C%'
               group by h.order_head_id)h1 on t1.flights_order_head_id=h1.order_head_id
   left join stg.s_cq_terminal t3 on t.terminal_id=t3.terminal_id
   left join stg.s_cq_agent_info t4 on t.web_id=t4.agent_id
   left join dw.da_restrict_userinfo t5 on t.client_id=t5.users_id
   where t1.r_flights_date>=to_date('2017-05-01','yyyy-mm-dd')
     and t1.r_flights_date< to_date('2017-07-01','yyyy-mm-dd') 
     and t1.flag_id in(40,7,11,12)
     and t1.whole_flight like '9C%'
     and t1.seats_name is not null
     and t2.flag<>2
     group by to_char(t1.r_flights_date,'yyyy/mm'),case when t1.flag_id =40 then '已乘机'
when t1.flag_id in(7,11,12) then '退票' end,
case
         when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and t.ex_nfd1 =2 then
          'M网站'
          when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and t.ex_nfd1>2 then
          'APP'
         when t.terminal_id < 0 and nvl(t.web_id, 0) = 0 and t.ex_nfd1 <= 1 then
            '网站'
           when t.order_date >= to_date('2017-06-01', 'yyyy-mm-dd') and
                t.terminal_id < 0 and t.web_id = 2185 then
            '旗舰店'
           when t.order_date >= to_date('2016-11-01', 'yyyy-mm-dd') and
                t.terminal_id < 0 and t.web_id = 2185 then
            '网站'
           when t.order_date >= to_date('2016-11-23', 'yyyy-mm-dd') and
                t.web_id = 435 then
            '旗舰店'
           when t.web_id > 0 and
                regexp_like(t4.abrv, '(CAACSC)|(95524)|(机构客户)|(集团客户)') then
            'B2G机构客户'
           when nvl(t.web_id, 0) > 0 and t4.agent_type is not null then
            decode(t4.agent_type,
                   1,
                   'OTA',
                   2,
                   'B2B代理',
                   4,
                   'CPS',
                   5,
                   'B2G机构客户')
           when nvl(t.web_id, 0) > 0 and t4.agent_type is null then
            'B2B'
           when t.terminal_id in
                (300, 1233, 1309, 1330, 1400, 1401, 1516, 1571, 1801, 1802, 1803, 1805, 1806, 1807, 1808) then
            '呼叫中心'
           when t.terminal_id not in
                (-1, -11, 300, 1233, 1309, 1330, 1400, 1401, 1516, 1571, 1801, 1802, 1803, 1805, 1806, 1807, 1808) and
                nvl(t.web_id, 0) = 0 and
                not regexp_like(t3.terminal, '(95524)|(机构客户)|(集团客户)') then
            'B2B'
           when t.terminal_id > 0 AND nvl(t.web_id, 0) = 0 and
                regexp_like(t3.terminal, '(95524)|(机构客户)|(集团客户)') then
            'B2G机构客户'
         end ,
     case when nvl(t1.seats_name,'-') in('B','G','G1','G2') then 'BG'
     else '非BG' end ,
     case when t.terminal_id=-1 and t.web_id=0 and t5.users_id is not null then '代理'
     else '非代理' end ,
     t2.nationflag,
     t2.segment_type,
     t2.segment_country,
     t2.originairport_name,
     t2.destairport_namE
     
	 
	 
	==============================================选座数据SQL==============================================================================
	
	
	
	select to_char(t1.flights_date,'yyyy') syear,to_char(t1.flights_date,'yyyymm') smonth,
       t1.nationflag,t2.segment_type,case when t1.is_swj>=1 then '是'
       else '否' end is_swj,t1.seats_name,
       case when t1.channel ='手机' and t1.station_id=2 then 'M网站'
            when t1.channel ='手机' and t1.station_id in(5,10) then '微信'
            when t1.channel ='手机'  then 'APP'
            else t1.channel end channel,
            case when t4.flights_order_head_id is not null then '有选座'
            else '无选座' end,
      case when getage(t1.flights_date,t1.birthday)>=0 and getage(t1.flights_date,t1.birthday)<=6 then '0~6'
        when getage(t1.flights_date,t1.birthday)>=7 and getage(t1.flights_date,t1.birthday)<=12 then '7~12'
        when getage(t1.flights_date,t1.birthday)>12 and getage(t1.flights_date,t1.birthday)<=18 then '13~18'
        when getage(t1.flights_date,t1.birthday)>18 and getage(t1.flights_date,t1.birthday)<=23 then '19~23'
        when getage(t1.flights_date,t1.birthday)>23 and getage(t1.flights_date,t1.birthday)<=30 then '23~30'
        when getage(t1.flights_date,t1.birthday)>30 and getage(t1.flights_date,t1.birthday)<=40 then '31~40'
        when getage(t1.flights_date,t1.birthday)>40 and getage(t1.flights_date,t1.birthday)<=50 then '41~50'
        when getage(t1.flights_date,t1.birthday)>50 and getage(t1.flights_date,t1.birthday)<=60 then '51~60'
        when getage(t1.flights_date,t1.birthday)>60 and getage(t1.flights_date,t1.birthday)<=60 then '61~70'
        when getage(t1.flights_date,t1.birthday)>70 then '70+'
        else '-' end age,
        t1.gender,
        t4.seats_no,
        count(1),
        sum(t4.firstnum),
        sum(t4.secondnum),
        sum(firstfee),
        sum(secondfee)               
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  left  join(select t3.flights_order_head_id,max(to_number(regexp_substr(t3.seat_no,'[0-9]+'))) seats_no,
                    sum(case when t3.pay_together=0 then t3.book_num else 0 end) firstnum,
                    sum(case when t3.pay_together=1 then t3.book_num else 0 end) secondnum,
                    sum(case when t3.pay_together=0 then t3.book_fee else 0 end) firstfee,
                    sum(case when t3.pay_together=1 then t3.book_fee else 0 end) secondfee
              from dw.fact_other_order_detail t3
              where t3.flights_date>=to_date('2015-01-01','yyyy-mm-dd')
                and t3.flights_date< to_date('2017-08-01','yyyy-mm-dd')
                and to_char(t3.flights_date,'mm') in('01','02','03','04','05','06','07')
                and t3.company_id=0
                and t3.xtype_id=3
                group by t3.flights_order_head_id)t4 on t1.flights_order_head_id=t4.flights_order_head_id

  where t1.flights_date>=to_date('2015-01-01','yyyy-mm-dd')
    and t1.flights_date< to_date('2017-08-01','yyyy-mm-dd')
    and t2.flag<>2
    and to_char(t1.flights_date,'mm') in('01','02','03','04','05','06','07')
    and t1.whole_flight like '9C%'
    and t1.seats_name is not null
    group by to_char(t1.flights_date,'yyyy') ,to_char(t1.flights_date,'yyyymm') ,
       t1.nationflag,t2.segment_type,case when t1.is_swj>=1 then '是'
       else '否' end ,t1.seats_name,
       case when t1.channel ='手机' and t1.station_id=2 then 'M网站'
            when t1.channel ='手机' and t1.station_id in(5,10) then '微信'
            when t1.channel ='手机'  then 'APP'
            else t1.channel end ,
            case when t4.flights_order_head_id is not null then '有选座'
            else '无选座' end,
      case when getage(t1.flights_date,t1.birthday)>=0 and getage(t1.flights_date,t1.birthday)<=6 then '0~6'
        when getage(t1.flights_date,t1.birthday)>=7 and getage(t1.flights_date,t1.birthday)<=12 then '7~12'
        when getage(t1.flights_date,t1.birthday)>12 and getage(t1.flights_date,t1.birthday)<=18 then '13~18'
        when getage(t1.flights_date,t1.birthday)>18 and getage(t1.flights_date,t1.birthday)<=23 then '19~23'
        when getage(t1.flights_date,t1.birthday)>23 and getage(t1.flights_date,t1.birthday)<=30 then '23~30'
        when getage(t1.flights_date,t1.birthday)>30 and getage(t1.flights_date,t1.birthday)<=40 then '31~40'
        when getage(t1.flights_date,t1.birthday)>40 and getage(t1.flights_date,t1.birthday)<=50 then '41~50'
        when getage(t1.flights_date,t1.birthday)>50 and getage(t1.flights_date,t1.birthday)<=60 then '51~60'
        when getage(t1.flights_date,t1.birthday)>60 and getage(t1.flights_date,t1.birthday)<=60 then '61~70'
        when getage(t1.flights_date,t1.birthday)>70 then '70+'
        else '-' end ,
        t1.gender,
        t4.seats_no
		
		
select to_char(t1.flights_date,'yyyy') syear,to_char(t1.flights_date,'yyyymm') smonth,
       t1.nationflag,t2.segment_type,
       case when t1.channel ='手机' and t1.station_id=2 then 'M网站'
            when t1.channel ='手机' and t1.station_id in(5,10) then '微信'
            when t1.channel ='手机'  then 'APP'
            else t1.channel end channel,
         count(1),
         sum(case when t5.flights_order_id is not null then 1 else 0 end) limitnum,
        sum(t4.firstnum),
        sum(t4.secondnum),
        sum(firstfee),
        sum(secondfee)               
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  left  join(select t3.flights_order_head_id,max(to_number(regexp_substr(t3.seat_no,'[0-9]+'))) seats_no,
                    sum(case when t3.pay_together=0 then t3.book_num else 0 end) firstnum,
                    sum(case when t3.pay_together=1 then t3.book_num else 0 end) secondnum,
                    sum(case when t3.pay_together=0 then t3.book_fee else 0 end) firstfee,
                    sum(case when t3.pay_together=1 then t3.book_fee else 0 end) secondfee
              from dw.fact_other_order_detail t3
              where t3.flights_date>=to_date('2015-01-01','yyyy-mm-dd')
                and t3.flights_date< to_date('2017-08-01','yyyy-mm-dd')
                and to_char(t3.flights_date,'mm') in('01','02','03','04','05','06','07')
                and t3.company_id=0
                and t3.xtype_id=3
                group by t3.flights_order_head_id)t4 on t1.flights_order_head_id=t4.flights_order_head_id
  left join(select distinct h1.flights_orde_id 
              from dw.fact_order_detail h1
              where  h1.flights_date>=to_date('2015-01-01','yyyy-mm-dd')
                and h1.flights_date< to_date('2017-08-01','yyyy-mm-dd')
                and h1.company_id=0
                and to_char(h1.flights_date,'mm') in('01','02','03','04','05','06','07')
                and h1.seats_name is not null
                and getage(h1.flights_date,h1.birthday)>=0
                and getage(h1.flights_date,h1.birthday)<=6)t5 on t1.flights_order_id=t5.flights_order_id
  where t1.flights_date>=to_date('2015-01-01','yyyy-mm-dd')
    and t1.flights_date< to_date('2017-08-01','yyyy-mm-dd')
    and t2.flag<>2
    and to_char(t1.flights_date,'mm') in('01','02','03','04','05','06','07')
    and t1.whole_flight like '9C%'
    and t1.seats_name is not null
    group by to_char(t1.flights_date,'yyyy') ,to_char(t1.flights_date,'yyyymm') ,
       t1.nationflag,t2.segment_type,
       case when t1.channel ='手机' and t1.station_id=2 then 'M网站'
            when t1.channel ='手机' and t1.station_id in(5,10) then '微信'
            when t1.channel ='手机'  then 'APP'
            else t1.channel end 
			
			
			
			select case when t1.order_day>=to_date('2017-01-25','yyyy-mm-dd') and t1.order_day<=to_date('2017-03-25','yyyy-mm-dd')
            then '维度一'
            when t1.order_day>=to_date('2017-03-26','yyyy-mm-dd') and t1.order_day<=to_date('2017-05-25','yyyy-mm-dd')
            then '维度二' end,
         count(1),
         sum(firstinsurcefee),
                sum(secondinsurcefee),
                sum(firstfoodfee),
                sum(secondfoodfee),
                sum(firstlugfee),
               sum( secondlugfee),
               sum( firstseatfee),
                sum(secondseatfee),
                sum(firstseatnum),
               sum( secondseatnum)
                
                   
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  left  join(select t3.flights_order_head_id,
                    sum(case when t3.pay_together=0 and t3.xtype_id in(1,2,4,11) then t3.book_fee else 0 end) firstinsurcefee,
                    sum(case when t3.pay_together=1 and t3.xtype_id in(1,2,4,11) then t3.book_fee else 0 end) secondinsurcefee,
                    sum(case when t3.pay_together=0 and t3.xtype_id=7 then t3.book_fee else 0 end) firstfoodfee,
                    sum(case when t3.pay_together=1 and t3.xtype_id=7 then t3.book_fee else 0 end) secondfoodfee,
                    sum(case when t3.pay_together=0 and t3.xtype_id in(6,10,17,24) then t3.book_fee else 0 end) firstlugfee,
                    sum(case when t3.pay_together=1 and t3.xtype_id in(6,10,17,24) then t3.book_fee else 0 end) secondlugfee,
                    sum(case when t3.pay_together=0 and t3.xtype_id =3 then t3.book_fee else 0 end) firstseatfee,
                    sum(case when t3.pay_together=1 and t3.xtype_id =3 then t3.book_fee else 0 end) secondseatfee,
                    sum(case when t3.pay_together=0 and t3.xtype_id =3 then t3.book_num else 0 end) firstseatnum,
                    sum(case when t3.pay_together=1 and t3.xtype_id =3 then t3.book_num else 0 end) secondseatnum                    
              from dw.fact_other_order_detail t3
              where t3.main_order_date>=to_date('2015-01-01','yyyy-mm-dd')
                and t3.main_order_date< to_date('2017-08-01','yyyy-mm-dd')
                 and t3.company_id=0
                group by t3.flights_order_head_id)t4 on t1.flights_order_head_id=t4.flights_order_head_id 
  where t1.order_day>=to_date('2017-01-25','yyyy-mm-dd')
    and t1.order_day< to_date('2017-05-26','yyyy-mm-dd')
    and t2.flag<>2
    and t1.nationflag='国内'
    and t1.channel='网站'
    and t1.whole_flight like '9C%'
    group by case when t1.order_day>=to_date('2017-01-25','yyyy-mm-dd') and t1.order_day<=to_date('2017-03-25','yyyy-mm-dd')
            then '维度一'
            when t1.order_day>=to_date('2017-03-26','yyyy-mm-dd') and t1.order_day<=to_date('2017-05-25','yyyy-mm-dd')
            then '维度二' end
