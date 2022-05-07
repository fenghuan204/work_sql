select /*+parallel(4) */
hh1.syear 年,hh1.squar 季度,hh1.rank 月度集,
hh1.月度所线上交易额 "01月度所线上交易额",
hh1.月度移动交易额 "02月度移动交易额",
hh1.月度所线上交易额 "07月度网上交易额",
hh1.月度自营交易额 "08月度自营交易额",
hh1.月度线上代理交易额 "09月度线上代理交易额",
hh1.月度B2B交易额 "10月度B2B交易额",
hh1.月度B2C交易额 "11月度B2C交易额",
hh1.月度所线上交易额 "32服务类金额",
hh1.月度主营收入 "34月度主营收入",
hh1.月度辅收收入 "38月度辅收收入",
hh1.月度市内交易额 "39月度市内交易额",
hh1.月度总订单数 "B01-1月度总订单数",
hh1.月度移动订单数 "B01-2月度移动订单数",
hh1.月度所线上交易额/hh2.月度交易额 "B02月度网上交易额占比",
hh1.季度所线上交易额 "01季度所线上交易额",
hh1.季度移动交易额 "02季度移动交易额",
hh1.季度所线上交易额 "07季度网上交易额",
hh1.季度自营交易额 "08季度自营交易额",
hh1.季度线上代理交易额 "09季度线上代理交易额",
hh1.季度B2B交易额 "10季度B2B交易额",
hh1.季度B2C交易额 "11季度B2C交易额",
hh1.季度所线上交易额 "32服务类金额",
hh1.季度主营收入 "34季度主营收入",
hh1.季度辅收收入 "38季度辅收收入",
hh1.季度市内交易额 "39季度市内交易额",
hh1.季度总订单数 "B01-1季度总订单数",
hh1.季度移动订单数 "B01-2季度移动订单数",
hh1.季度所线上交易额/hh2.季度交易额 "B02季度网上交易额占比"
from(
select 
h2.syear,h2.squar,h2.rank,
avg(所有线上交易) 月度所线上交易额,
avg(移动交易) 月度移动交易额,
avg(自营交易额) 月度自营交易额,
avg(线上代理交易额) 月度线上代理交易额,
avg(B2G交易额) 月度B2B交易额,
avg(B2C交易额) 月度B2C交易额,
avg(主营收入) 月度主营收入,
avg(辅收收入) 月度辅收收入,
avg(市内交易额) 月度市内交易额,
avg(总交易订单数) 月度总订单数,
avg(移动交易订单数) 月度移动订单数,

sum(所有线上交易) 季度所线上交易额,
sum(移动交易) 季度移动交易额,
sum(自营交易额) 季度自营交易额,
sum(线上代理交易额) 季度线上代理交易额,
sum(B2G交易额) 季度B2B交易额,
sum(B2C交易额) 季度B2C交易额,
sum(主营收入) 季度主营收入,
sum(辅收收入) 季度辅收收入,
sum(市内交易额) 季度市内交易额,
sum(总交易订单数) 季度总订单数,
sum(移动交易订单数) 季度移动订单数

from(
select h1.*,listagg(smonth,',') within GROUP (order by smonth) over (partition by h1.syear,h1.squar) rank
from(
SELECT to_char(t1.flights_date,'yyyy') syear,
TO_CHAR (t1.flights_date, 'q') squar,TO_CHAR (t1.flights_date, 'yyyymm') smonth,
sum(t1.ticket_price+t1.ad_fy+t1.port_pay+t1.insurce_fee+t1.other_fee+t1.other_fy+t1.sx_fy) 所有线上交易,
sum(case when t1.station_id>1 then t1.ticket_price+t1.ad_fy+t1.port_pay+t1.insurce_fee+t1.other_fee+t1.other_fy+t1.sx_fy else 0 end) 移动交易,
sum(case when t1.channel in('网站','手机','B2G机构客户','B2B代理')
 then t1.ticket_price+t1.ad_fy+t1.port_pay+t1.insurce_fee+t1.other_fee+t1.other_fy+t1.sx_fy else 0 end) 自营交易额,
sum(case when t1.channel in('旗舰店','OTA')
 then t1.ticket_price+t1.ad_fy+t1.port_pay+t1.insurce_fee+t1.other_fee+t1.other_fy+t1.sx_fy else 0 end) 线上代理交易额,
 sum(case when t1.channel in('B2G机构客户','B2B代理')
 then t1.ticket_price+t1.ad_fy+t1.port_pay+t1.insurce_fee+t1.other_fee+t1.other_fy+t1.sx_fy else 0 end) B2G交易额,
sum(case when t1.channel in('旗舰店','OTA','网站','手机')
 then t1.ticket_price+t1.ad_fy+t1.port_pay+t1.insurce_fee+t1.other_fee+t1.other_fy+t1.sx_fy else 0 end) B2C交易额,
 sum(t1.ticket_price+t1.ad_fy+t1.port_pay+t1.other_fy+t1.sx_fy) 主营收入,
 sum(t1.insurce_fee+t1.other_fee) 辅收收入,
 sum(case when t2.flights_city_name like '%上海%' then t1.ticket_price+t1.ad_fy+t1.port_pay+t1.insurce_fee+t1.other_fee+t1.other_fy+t1.sx_fy
 else 0 end) 市内交易额,
 count(distinct t1.flights_order_id) 总交易订单数,
 count( distinct case when t1.station_id>1 then t1.flights_order_id else null end) 移动交易订单数,
 sum(case when t1.channel='网站' then  t1.ticket_price+t1.ad_fy+t1.port_pay+t1.insurce_fee+t1.other_fee+t1.other_fy+t1.sx_fy else 0 end) 网站交易额

  FROM DW.FACT_ORDER_DETAIL T1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  WHERE T1.FLIGHTS_DATE>=TO_DATE('2015-01-01','yyyy-mm-dd')
  and t1.flights_date< to_date('2018-10-01','yyyy-mm-dd')
  and t1.company_id=0
  and t2.flag<>2
  and t1.terminal_id<0  
  group by to_char(t1.flights_date,'yyyy'),
TO_CHAR (t1.flights_date, 'q'),TO_CHAR (t1.flights_date, 'yyyymm'))h1)h2
group by h2.syear,h2.squar,h2.rank)hh1
left join(

select 
h2.syear,h2.squar,h2.rank,
avg(总交易额) 月度交易额,
sum(总交易额) 季度交易额
from(
select h1.*,listagg(smonth,',') within GROUP (order by smonth) over (partition by h1.syear,h1.squar) rank
from(
SELECT to_char(t1.flights_date,'yyyy') syear,
TO_CHAR (t1.flights_date, 'q') squar,TO_CHAR (t1.flights_date, 'yyyymm') smonth,
sum(t1.ticket_price+t1.ad_fy+t1.port_pay+t1.insurce_fee+t1.other_fee+t1.other_fy+t1.sx_fy) 总交易额
  FROM DW.FACT_ORDER_DETAIL T1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  WHERE T1.FLIGHTS_DATE>=TO_DATE('2015-01-01','yyyy-mm-dd')
  and t1.flights_date< to_date('2018-10-01','yyyy-mm-dd')
  and t1.company_id=0
  and t2.flag<>2
  group by to_char(t1.flights_date,'yyyy'),
TO_CHAR (t1.flights_date, 'q'),TO_CHAR (t1.flights_date, 'yyyymm'))h1)h2
group by h2.syear,h2.squar,h2.rank
)hh2 on hh1.syear=hh2.syear and hh1.squar=hh2.squar and hh1.rank=hh2.rank
