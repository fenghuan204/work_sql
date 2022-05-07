select /*+parallel(2) */
h1.flights_date,case when h1.flag_id in(3,5,40,41) then '已支付'
when h1.flag_id in(7,11,12) then '已退票' end 机票状态,
case when h2.flag=2 then '取消航班'
when h2.flag=0 then '正常航班'
else '保护航班' end flighttype,
case when h1.seats_name in('B','G','G1','G2','O') then 'BGO'
else '非BGO' end seattype,
case when h4.flights_order_id is not null then '套票'
else '其他'  end tickettype,
case when h5.province||h6.province  like '%河北%' then '河北'
when h5.province||h6.province  like '%辽宁%' then '辽宁'
when h5.province||h6.province  like '%黑龙江%' then '黑龙江'
when h5.province||h6.province  like '%山西%' then '山西'
else '其他地区' end region,
replace(replace(h3.wf_segment,'浦东','上海'),'虹桥','上海') 往返航线,
case when  h1.flights_date< to_date('2021-01-28','yyyy-mm-dd') then '春运前'
when h1.flights_date>=to_date('2021-02-09','yyyy-mm-dd')
      and h1.flights_date<=to_date('2021-02-19','yyyy-mm-dd') then '春节0209~0219'
when h1.flights_date>=to_date('2021-01-28','yyyy-mm-dd')
      and h1.flights_date<=to_date('2021-03-08','yyyy-mm-dd') then '春运其他日期'
when h1.flights_date> to_date('2021-03-08','yyyy-mm-dd')
and h1.flights_date<=to_date('2021-03-31','yyyy-mm-dd')
then '春运后3月'
when h1.flights_date>=to_date('2021-04-01','yyyy-mm-dd')
and h1.flights_date< =to_date('2021-04-30','yyyy-mm-dd')
then '2021年4月'
when h1.flights_date> to_date('2021-04-30','yyyy-mm-dd')
then '2021年4月以后' end datetype,
case when h1.ahead_days<=0 then '00'
when h1.ahead_days<=3 then '01~03'
when h1.ahead_days<=7 then '04~07'
when h1.ahead_days<=15 then '08~15'
when h1.ahead_days<=30 then '16~30' 
when h1.ahead_days<=60 then '31~60' 
when h1.ahead_days> 60 then '60+' end aheadys,
h7.flighttype flighttype2,
h7.tuitype,
h7.region region2,
h7.datetype datetype2,
h7.priodtype,
case when h8.flights_order_head_id is not null then '重购机票'
else '非重购机票' end 是否重购机票,
count(1) ticketnum,
sum(h1.ticket_price) ticket_price,
sum(h7.tuinum) tuinum,
sum(h7.tuiprice) tuiprice
  from dw.fact_recent_order_detail h1
  join dw.da_flight h2 on h1.segment_head_id=h2.segment_Head_id
  left join dw.dim_segment_type h3 on h2.route_Id=h3.route_Id and h2.h_route_id=h3.h_route_id
  left join dw.fact_combo_ticket h4 on h1.flights_order_head_Id=h4.flights_order_head_Id
  left join hdb.cq_airport h5 on h2.originairport=h5.threecodeforcity
  left join hdb.cq_airport h6 on h2.destairport=h6.threecodeforcity
  left join(
select t1.flights_order_head_id,
trunc(t1.money_date),case when t2.flag=2 then '取消航班'
when t2.flag=0 then '正常航班'
else '保护航班' end flighttype,
case when t1.seats_name in('B','G','G1','G2','O') then 'BGO'
else '非BGO' end seattype,
case when t3.flights_order_id is not null then '套票'
when t1.money_fy = 0 then '0元退票'
when t1.money_fy > 0 then '正常退票' end tuitype,
case when t4.province||t5.province  like '%河北%' then '河北'
when t4.province||t5.province  like '%辽宁%' then '辽宁'
when t4.province||t5.province  like '%黑龙江%' then '黑龙江'
when t4.province||t5.province  like '%山西%' then '山西'
else '其他地区' end region,
case when  trunc(t1.origin_std) < to_date('2021-01-28','yyyy-mm-dd') then '春运前'
when trunc(t1.origin_std) >=to_date('2021-02-09','yyyy-mm-dd')
      and trunc(t1.origin_std) <=to_date('2021-02-19','yyyy-mm-dd') then '春节0209~0219'
when trunc(t1.origin_std) >=to_date('2021-01-28','yyyy-mm-dd')
      and trunc(t1.origin_std) <=to_date('2021-03-08','yyyy-mm-dd') then '春运其他日期'
when trunc(t1.origin_std) > to_date('2021-03-08','yyyy-mm-dd')
and trunc(t1.origin_std) <=to_date('2021-03-31','yyyy-mm-dd')
then '春运后3月'
when trunc(t1.origin_std) >=to_date('2021-04-01','yyyy-mm-dd')
and trunc(t1.origin_std) < =to_date('2021-04-30','yyyy-mm-dd')
then '2021年4月'
when trunc(t1.origin_std) > to_date('2021-04-30','yyyy-mm-dd')
then '2021年4月以后' end datetype,
case when t1.origin_std-t1.money_date < =0 then '离站后'
when t1.origin_std-t1.money_date <=0.5 then '（0,12H]'
when t1.origin_std-t1.money_date <=1 then '（12,24H]'
when t1.origin_std-t1.money_date <=3 then '（1,3D]'
when t1.origin_std-t1.money_date <=7 then '（3,7D]'
when t1.origin_std-t1.money_date <=15 then '（7,15D]'
when t1.origin_std-t1.money_date <=30 then '（15,30D]'
when t1.origin_std-t1.money_date <=60 then '（30,60D]'
when t1.origin_std-t1.money_date > 60 then '60+' end priodtype,
count(1) tuinum,
sum(t1.money_fy) tuiprice
  from dw.da_order_drawback t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  left join dw.fact_combo_ticket t3 on t1.flights_order_head_Id=t3.flights_order_head_Id
  left join hdb.cq_airport t4 on t2.originairport=t4.threecodeforcity
  left join hdb.cq_airport t5 on t2.destairport=t5.threecodeforcity
  where t1.money_date>=to_date('2020-12-01','yyyy-mm-dd')
    and t1.money_date< to_date('2021-01-21','yyyy-mm-dd')
    and t1.seats_name is not null
  group by t1.flights_order_head_id,trunc(t1.money_date),case when t2.flag=2 then '取消航班'
when t2.flag=0 then '正常航班'
else '保护航班' end ,
case when t1.seats_name in('B','G','G1','G2','O') then 'BGO'
else '非BGO' end ,
case when t3.flights_order_id is not null then '套票'
when t1.money_fy = 0 then '0元退票'
when t1.money_fy > 0 then '正常退票' end ,
case when t4.province||t5.province  like '%河北%' then '河北'
when t4.province||t5.province  like '%辽宁%' then '辽宁'
when t4.province||t5.province  like '%黑龙江%' then '黑龙江'
when t4.province||t5.province  like '%山西%' then '山西'
else '其他地区' end ,
case when  trunc(t1.origin_std) < to_date('2021-01-28','yyyy-mm-dd') then '春运前'
when trunc(t1.origin_std) >=to_date('2021-02-09','yyyy-mm-dd')
      and trunc(t1.origin_std) <=to_date('2021-02-19','yyyy-mm-dd') then '春节0209~0219'
when trunc(t1.origin_std) >=to_date('2021-01-28','yyyy-mm-dd')
      and trunc(t1.origin_std) <=to_date('2021-03-08','yyyy-mm-dd') then '春运其他日期'
when trunc(t1.origin_std) > to_date('2021-03-08','yyyy-mm-dd')
and trunc(t1.origin_std) <=to_date('2021-03-31','yyyy-mm-dd')
then '春运后3月'
when trunc(t1.origin_std) >=to_date('2021-04-01','yyyy-mm-dd')
and trunc(t1.origin_std) < =to_date('2021-04-30','yyyy-mm-dd')
then '2021年4月'
when trunc(t1.origin_std) > to_date('2021-04-30','yyyy-mm-dd')
then '2021年4月以后' end ,
case when t1.origin_std-t1.money_date < =0 then '离站后'
when t1.origin_std-t1.money_date <=0.5 then '（0,12H]'
when t1.origin_std-t1.money_date <=1 then '（12,24H]'
when t1.origin_std-t1.money_date <=3 then '（1,3D]'
when t1.origin_std-t1.money_date <=7 then '（3,7D]'
when t1.origin_std-t1.money_date <=15 then '（7,15D]'
when t1.origin_std-t1.money_date <=30 then '（15,30D]'
when t1.origin_std-t1.money_date <=60 then '（30,60D]'
when t1.origin_std-t1.money_date > 60 then '60+' end)h7 on h1.flights_order_head_id=h7.flights_order_head_id
left  join(SELECT t1.flights_order_head_id,count(1)
  from dw.fact_order_detail t1,
   dw.da_order_drawback t2,
   dw.da_flight t3
   where t1.codeno=t2.codeno
   and t1.traveller_name=t2.sname
   and t2.segment_head_id=t3.segment_head_id
   and t1.whole_segment=t3.segment_code
   and t1.order_date>=t2.money_date
   and t1.flights_date>=trunc(t2.origin_std)-7
   and t1.flights_date<=trunc(t2.origin_std)+7
   and t1.flights_date>=to_date('2021-01-01','yyyy-mm-dd')
   and t1.flights_date< to_date('2021-04-30','yyyy-mm-dd')
   group by t1.flights_order_head_id)h8 on h1.flights_order_head_id=h8.flights_order_head_id
where h1.flights_date>=to_date('2021-01-01','yyyy-mm-dd')
 and h1.flights_date<=to_date('2021-04-30','yyyy-mm-dd')
 and h1.seats_name is not null
 and h1.whole_flight like '9C%'
 group by h1.flights_date,case when h2.flag=2 then '取消航班'
when h2.flag=0 then '正常航班'
else '保护航班' end ,
case when h1.seats_name in('B','G','G1','G2','O') then 'BGO'
else '非BGO' end ,
case when h4.flights_order_id is not null then '套票'
else '其他'  end ,
case when h5.province||h6.province  like '%河北%' then '河北'
when h5.province||h6.province  like '%辽宁%' then '辽宁'
when h5.province||h6.province  like '%黑龙江%' then '黑龙江'
when h5.province||h6.province  like '%山西%' then '山西'
else '其他地区' end ,
case when  h1.flights_date< to_date('2021-01-28','yyyy-mm-dd') then '春运前'
when h1.flights_date>=to_date('2021-02-09','yyyy-mm-dd')
      and h1.flights_date<=to_date('2021-02-19','yyyy-mm-dd') then '春节0209~0219'
when h1.flights_date>=to_date('2021-01-28','yyyy-mm-dd')
      and h1.flights_date<=to_date('2021-03-08','yyyy-mm-dd') then '春运其他日期'
when h1.flights_date> to_date('2021-03-08','yyyy-mm-dd')
and h1.flights_date<=to_date('2021-03-31','yyyy-mm-dd')
then '春运后3月'
when h1.flights_date>=to_date('2021-04-01','yyyy-mm-dd')
and h1.flights_date< =to_date('2021-04-30','yyyy-mm-dd')
then '2021年4月'
when h1.flights_date> to_date('2021-04-30','yyyy-mm-dd')
then '2021年4月以后' end ,
case when h1.ahead_days<=0 then '00'
when h1.ahead_days<=3 then '01~03'
when h1.ahead_days<=7 then '04~07'
when h1.ahead_days<=15 then '08~15'
when h1.ahead_days<=30 then '16~30' 
when h1.ahead_days<=60 then '31~60' 
when h1.ahead_days> 60 then '60+' end ,
h7.flighttype ,
h7.tuitype,
h7.region ,
h7.datetype ,
h7.priodtype,
case when h1.flag_id in(3,5,40,41) then '已支付'
when h1.flag_id in(7,11,12) then '已退票' end,
replace(replace(h3.wf_segment,'浦东','上海'),'虹桥','上海'),
case when h8.flights_order_head_id is not null then '重购机票'
else '非重购机票' end
