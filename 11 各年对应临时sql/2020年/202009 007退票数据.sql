select to_char(t1.origin_std,'yyyymm'),case when t1.money_terminal< 0 then '线上自有渠道'
else '线下' end,
case when t1.terminal_id<0 and t1.web_id=0 then '线上自有渠道'
when t1.terminal_id<0 and t1.web_id>0 then 'OTA'
else '其他' end,sum(case when t1.seats_name is not null then 1 else 0 end) num,
       sum(t1.money_fy),sum(t1.ticketprice)
from dw.da_order_drawback t1
join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
where t1.origin_std>=to_date('2019-01-01','yyyy-mm-dd')
  and t1.origin_std< to_date('2020-01-01','yyyy-mm-dd')
  and t1.money_fy>0
  group by  to_char(t1.origin_std,'yyyymm'),case when t1.money_terminal< 0 then '线上自有渠道'
else '线下' end,
case when t1.terminal_id<0 and t1.web_id=0 then '线上自有渠道'
when t1.terminal_id<0 and t1.web_id>0 then 'OTA'
else '其他' end



select to_char(t1.flights_date,'yyyymm'),sum(t1.boardnum)
 from dw.da_main_order t1
 where t1.flights_date>=to_date('2019-01-01','yyyy-mm-dd')
   and t1.flights_date< to_date('2020-01-01','yyyy-mm-dd')
   and t1.flights_no like '9C%'
   

  ======================================退票数据======
  
  
  
  select to_char(t1.origin_std,'yyyymm') 航班月,case when t1.money_terminal< 0 then '线上自有渠道'
else '线下' end 退票渠道,
case when t1.terminal_id<0 and t1.web_id=0 then '线上自有渠道'
when t1.terminal_id<0 and t1.web_id>0 then 'OTA'
else '其他' end 机票渠道,sum(case when t1.seats_name is not null then 1 else 0 end) 退票量,
       sum(t1.money_fy) 手续费,sum(t1.ticketprice) 机票票价,null ticketnum
from dw.da_order_drawback t1
join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
where t1.origin_std>=to_date('2019-01-01','yyyy-mm-dd')
  and t1.origin_std< to_date('2020-09-01','yyyy-mm-dd')
  and t1.money_fy>0
  and t1.terminal_id<0
  and t1.web_id=0
  group by  to_char(t1.origin_std,'yyyymm'),case when t1.money_terminal< 0 then '线上自有渠道'
else '线下' end,
case when t1.terminal_id<0 and t1.web_id=0 then '线上自有渠道'
when t1.terminal_id<0 and t1.web_id>0 then 'OTA'
else '其他' end
union all
select to_char(t1.flights_date,'yyyymm') 航班月,'','线上自有渠道',null,null,sum(t1.ticket_price),count(1) ticketnum 
 from dw.fact_order_detail t1
 where t1.flights_date>=to_date('2019-01-01','yyyy-mm-dd')
  and t1.flights_date< to_date('2020-09-01','yyyy-mm-dd')
  and t1.channel in('手机','网站')
  and t1.seats_name is not null
  and t1.ticket_price>0
  and t1.company_id=0
  group by to_char(t1.flights_date,'yyyymm');
  
  
  select case when t1.money_fy<=99 then '0-99元'
when t1.money_fy<=199 then '100-199元'
when t1.money_fy<=299 then '200-299元'
when t1.money_fy<=399 then '300-399元'
when t1.money_fy<=499 then '400-499元'
when t1.money_fy<=999 then '500-999元'
when t1.money_fy>=1000 then '1000+' end ,count(1)
from dw.da_order_drawback t1
join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
where t1.origin_std>=to_date('2019-01-01','yyyy-mm-dd')
  and t1.origin_std< to_date('2020-01-01','yyyy-mm-dd')
  and t1.money_fy>0
  and t1.terminal_id<0
  and t1.web_id=0
  group by  case when t1.money_fy<=99 then '0-99元'
when t1.money_fy<=199 then '100-199元'
when t1.money_fy<=299 then '200-299元'
when t1.money_fy<=399 then '300-399元'
when t1.money_fy<=499 then '400-499元'
when t1.money_fy<=999 then '500-999元'
when t1.money_fy>=1000 then '1000+' end

