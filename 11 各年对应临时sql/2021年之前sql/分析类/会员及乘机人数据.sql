select to_char(t1.flights_date,'yyyymm') 航班月,
case when t1.channel in('网站','手机') and t4.users_id is not null then '代理'
when t1.channel in('网站','手机')  then '线上自有渠道'
    when t1.channel in('OTA','旗舰店') then 'OTA'
    else '线下渠道' end 渠道,
     case when t1.ahead_days<=3 then '00~03'
         when t1.ahead_days<=7 then '04~07'
       when t1.ahead_days<=15 then '08~15'
       when t1.ahead_days<=30 then '15~30'
       when t1.ahead_days<=60 then '31~60'
       when t1.ahead_days<=90 then '61~90'
       when t1.ahead_days<=120 then '91~120'
       when t1.ahead_days<=150 then '121~150'
       when t1.ahead_days<=180 then '151~180'
       when t1.ahead_days<=240 then '181~240'
       when t1.ahead_days<=360 then '241~360'
       when t1.ahead_days> 361 then '360+'
       end ,
       case when t1.channel in('网站','手机') and  t5.reg_date is not null and  t7.cust_id is not null and trunc(t1.order_day)=trunc(nvl(t8.first_orderdate,t1.order_day)) then  '首购用户-绿翼会员'
       when t1.channel in('网站','手机') and t5.reg_date is not null and  t7.cust_id is  null and trunc(t1.order_day)=trunc(nvl(t8.first_orderdate,t1.order_day)) then  '首购用户-普通会员'
       when t1.channel in('网站','手机') and t5.reg_date is not null and trunc(t1.order_day)<>trunc(nvl(t8.first_orderdate,t1.order_day)) and t7.cust_id is not null then '老用户-绿翼会员'
       when t1.channel in('网站','手机') and t5.reg_date is not null and trunc(t1.order_day)<>trunc(nvl(t8.first_orderdate,t1.order_day)) and t7.cust_id is null then '老用户-普通会员'  
       else '非自有渠道购买' end 用户类型,
       case when t1.ex_cfd1 is not null and  t9.codeno is not null 
       and t9.min_flightdate=t1.flights_date then '首次乘机绿翼会员'
       when t1.ex_cfd1 is not null and  t9.codeno is not null 
       and t9.min_flightdate<>t1.flights_date then '再次乘机绿翼会员'
       when t1.ex_cfd1 is null and t6.users_id is not null and t9.min_flightdate=t1.flights_date then '首次乘机普通会员'
       when t1.ex_cfd1 is null and t6.users_id is not null and t9.min_flightdate<>t1.flights_date then '再次乘机普通会员'
       else '其他乘机人' end 乘机人类型, 
      count(1) 机票量
 from dw.fact_order_detail t1
 join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
 left join dw.da_restrict_userinfo t4 on t1.client_id=t4.users_id
 left join dw.da_b2c_user t5 on t1.client_id=t5.users_id
 left join dw.da_b2c_user t6 on length(t6.codeno)>=6 and t1.codeno=t6.codeno and t1.traveller_name=t6.realname
 left join dw.da_lyuser t7 on t1.cust_id=t7.cust_id
 left join dw.da_user_purchase t8 on t1.client_id=t8.users_id
  left join dw.fact_idno_statistics t9 on t1.codeno=t9.codeno and t1.codetype=t9.codetype
 where t2.flag<>2
   and t1.flights_date>=to_date('2018-01-01','yyyy-mm-dd')
   and t1.flights_date< to_date('2019-01-01','yyyy-mm-dd')
   and t2.flag<>2
   and t1.sex=1
   and t1.flag_id in(3,5,40,41)
   and t1.seats_name not in('B','G1','G2','G','O')
   group by to_char(t1.flights_date,'yyyymm') ,
case when t1.channel in('网站','手机') and t4.users_id is not null then '代理'
when t1.channel in('网站','手机')  then '线上自有渠道'
    when t1.channel in('OTA','旗舰店') then 'OTA'
    else '线下渠道' end ,
     case when t1.ahead_days<=3 then '00~03'
         when t1.ahead_days<=7 then '04~07'
       when t1.ahead_days<=15 then '08~15'
       when t1.ahead_days<=30 then '15~30'
       when t1.ahead_days<=60 then '31~60'
       when t1.ahead_days<=90 then '61~90'
       when t1.ahead_days<=120 then '91~120'
       when t1.ahead_days<=150 then '121~150'
       when t1.ahead_days<=180 then '151~180'
       when t1.ahead_days<=240 then '181~240'
       when t1.ahead_days<=360 then '241~360'
       when t1.ahead_days> 361 then '360+'
       end ,
       case when t1.channel in('网站','手机') and t5.reg_date is not null and  t7.cust_id is not null and trunc(t1.order_day)=trunc(nvl(t8.first_orderdate,t1.order_day)) then  '首购用户-绿翼会员'
       when t1.channel in('网站','手机') and t5.reg_date is not null and  t7.cust_id is  null and trunc(t1.order_day)=trunc(nvl(t8.first_orderdate,t1.order_day)) then  '首购用户-普通会员'
       when t1.channel in('网站','手机') and t5.reg_date is not null and trunc(t1.order_day)<>trunc(nvl(t8.first_orderdate,t1.order_day)) and t7.cust_id is not null then '老用户-绿翼会员'
       when t1.channel in('网站','手机') and t5.reg_date is not null and trunc(t1.order_day)<>trunc(nvl(t8.first_orderdate,t1.order_day)) and t7.cust_id is null then '老用户-普通会员'  
       else '非自有渠道购买' end ,
       case when t1.ex_cfd1 is not null and  t9.codeno is not null 
       and t9.min_flightdate=t1.flights_date then '首次乘机绿翼会员'
       when t1.ex_cfd1 is not null and  t9.codeno is not null 
       and t9.min_flightdate<>t1.flights_date then '再次乘机绿翼会员'
       when t1.ex_cfd1 is null and t6.users_id is not null and t9.min_flightdate=t1.flights_date then '首次乘机普通会员'
       when t1.ex_cfd1 is null and t6.users_id is not null and t9.min_flightdate<>t1.flights_date then '再次乘机普通会员'
       else '其他乘机人' end;






