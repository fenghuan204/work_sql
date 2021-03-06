select to_char(t1.flights_date,'yyyymm') flightmonth,
case when t1.seats_name in('B','G','G1','G2') then 'BG'
else '非BG' end,
  case when t1.channel in('手机','网站') and t3.users_id is null then '线上自有'
  when t1.channel in('手机','网站') and t3.users_id is not null then '黑代理'
    else '其他' end 渠道, 
   count(1) 机票数
 from dw.fact_order_detail t1
 join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
 left join dw.da_restrict_userinfo t3 on t1.client_id=t3.users_id
 where t2.flag<>2
   and t1.flights_date>=to_date('2020-09-01','yyyy-mm-dd')
   and t1.flights_date< to_date('2020-10-01','yyyy-mm-dd')
   AND T1.SEATS_NAME IS NOT NULL
      and t1.company_id=0
      group by to_char(t1.flights_date,'yyyymm'),
case when t1.seats_name in('B','G','G1','G2') then 'BG'
else '非BG' end,
  case when t1.channel in('手机','网站') and t3.users_id is null then '线上自有'
  when t1.channel in('手机','网站') and t3.users_id is not null then '黑代理'
    else '其他' end 
  
