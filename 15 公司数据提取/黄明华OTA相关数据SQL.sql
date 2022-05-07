/*
--国际航线OTA、非OTA机票数量、金额、平均票价

select \*+parallel(4) *\
trunc(t1.flights_date,'mm') 月份,case when t1.channel in('OTA','旗舰店') then 'OTA'
else '非OTA' end 渠道,
count(1) 国际数量,sum(t1.ticket_price) 国际金额
 from dw.fact_order_detail t1
 where  t1.flights_date>=to_date('2018-01-01','yyyy-mm-dd')
 and t1.flights_date< to_date('2018-05-01','yyyy-mm-dd')
 and t1.company_id=0
 and t1.flag_id=40
 and t1.seats_name not in('B','G','G1','G2','O')
 and t1.nationflag in('区域','国际')
 group by trunc(t1.flights_date,'mm'),case when t1.channel in('OTA','旗舰店') then 'OTA'
else '非OTA' end;
 
 

 --国内航线OTA、非OTA机票数量、金额、平均票价
 
 select \*+parallel(4) *\
trunc(t1.flights_date,'mm') 月份,case when t1.channel in('OTA','旗舰店') then 'OTA'
else '非OTA' end 渠道,
count(1) 国内数量,sum(t1.ticket_price) 国内金额,sum(t1.price) 国内民航公布价
 from dw.fact_order_detail t1
 where  t1.flights_date>=to_date('2018-01-01','yyyy-mm-dd')
 and t1.flights_date< to_date('2018-05-01','yyyy-mm-dd')
 and t1.company_id=0
  and t1.seats_name not in('B','G','G1','G2','O')
  and t1.nationflag='国内'
  and t1.flag_id=40
 group by trunc(t1.flights_date,'mm') ,case when t1.channel in('OTA','旗舰店') then 'OTA'
else '非OTA' end;
 

---所有数据

select \*+parallel(4) *\
trunc(t1.flights_date,'mm') 月份,case when t1.channel in('OTA','旗舰店') then 'OTA'
else '非OTA' end 渠道,
count(1) 数量,sum(t1.ticket_price) 金额
 from dw.fact_order_detail t1
 where t1.flights_date>=to_date('2018-01-01','yyyy-mm-dd')
 and t1.flights_date< to_date('2018-05-01','yyyy-mm-dd')
 and t1.company_id=0
 and t1.flag_id=40
  and t1.seats_name not in('B','G','G1','G2','O')
 group by trunc(t1.flights_date,'mm'),case when t1.channel in('OTA','旗舰店') then 'OTA'
else '非OTA' end;*/


----- 累计数据

select /*+parallel(4) */ *
from 
(select 
case when t1.nationflag in('区域','国际') then '国际'
else '国内' end nationflag,trunc(t1.flights_date,'mm') month,
sum(case when t1.channel in('OTA','旗舰店') then 1 else 0 end) ota_num,
sum(case when t1.channel in('OTA','旗舰店') then 0 else 1 end) nota_num,
count(1) totalnum,
sum(case when t1.channel in('OTA','旗舰店') then t1.ticket_price else 0 end) ota_price,
sum(case when t1.channel in('OTA','旗舰店') then 0 else t1.ticket_price end) nota_price,
sum(t1.ticket_price) totalprice,
sum(case when t1.channel in('OTA','旗舰店') then t1.price else 0 end) ota_all,
sum(case when t1.channel in('OTA','旗舰店') then 0 else t1.price end) nota_all,
sum(t1.price) totalall
 from dw.fact_order_detail t1
 where t1.flights_date>=to_date('2020-01-01','yyyy-mm-dd')
 and t1.flights_date< trunc(sysdate,'mm')
 and t1.company_id=0
 and t1.flag_id=40
  and t1.seats_name not in('B','G','G1','G2','O')
 group by rollup(case when t1.nationflag in('区域','国际') then '国际'
else '国内' end ,trunc(t1.flights_date,'mm')))h1
where month=trunc(trunc(sysdate,'mm')-1,'mm')
or month is null
order by nationflag,month


