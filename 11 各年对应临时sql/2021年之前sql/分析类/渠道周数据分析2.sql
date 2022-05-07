select case when t1.order_day>=to_date('2017-08-25','yyyy-mm-dd')
             and t1.order_day< to_date('2017-08-27','yyyy-mm-dd') then '上周'
       when t1.order_day>=to_date('2017-09-01','yyyy-mm-dd')
             and t1.order_day< to_date('2017-09-03','yyyy-mm-dd') then '本周' end,
        case when t1.ahead_days<=3 then '00-03'
         when t1.ahead_days<=7 then '04-07'
       when t1.ahead_days<=15 then '08-15'
       when t1.ahead_days<=30 then '15-30'
       when t1.ahead_days<=60 then '31-60'
       when t1.ahead_days<=90 then '61-90'
       when t1.ahead_days> 90 then '90+' end,
       case when t1.flights_date>=to_date('2017-09-29','yyyy-mm-dd')
       and t1.flights_date< to_date('2017-10-09','yyyy-mm-dd') then '十一期间'
       else '其他时间' end,
    t2.flights_segment_name,
    t1.channel,
    case when t1.channel in('手机','网站')
    and t3.users_id is not null then '代理'
    else '非代理' end,
    count(1),
    sum(t1.ticket_price)

  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  left join dw.da_restrict_userinfo t3 on t1.client_id=t3.users_id
  where t1.order_day>=to_date('2017-08-25','yyyy-mm-dd')
    and t1.order_day< to_date('2017-09-03','yyyy-mm-dd')
  and t1.seats_name not in('B','G','G1','G2','O')
  and t1.company_id=0
  and t2.flag<>2
  and to_char(t1.order_day,'day') in('星期五','星期六')
  group by case when t1.order_day>=to_date('2017-08-25','yyyy-mm-dd')
             and t1.order_day< to_date('2017-08-27','yyyy-mm-dd') then '上周'
       when t1.order_day>=to_date('2017-09-01','yyyy-mm-dd')
             and t1.order_day< to_date('2017-09-03','yyyy-mm-dd') then '本周' end,
        case when t1.ahead_days<=3 then '00-03'
         when t1.ahead_days<=7 then '04-07'
       when t1.ahead_days<=15 then '08-15'
       when t1.ahead_days<=30 then '15-30'
       when t1.ahead_days<=60 then '31-60'
       when t1.ahead_days<=90 then '61-90'
       when t1.ahead_days> 90 then '90+' end,
       case when t1.flights_date>=to_date('2017-09-29','yyyy-mm-dd')
       and t1.flights_date< to_date('2017-10-09','yyyy-mm-dd') then '十一期间'
       else '其他时间' end,
    t2.flights_segment_name,
    t1.channel,
    case when t1.channel in('手机','网站')
    and t3.users_id is not null then '代理'
    else '非代理' end
