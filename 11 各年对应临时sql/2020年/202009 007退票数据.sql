select to_char(t1.origin_std,'yyyymm'),case when t1.money_terminal< 0 then '������������'
else '����' end,
case when t1.terminal_id<0 and t1.web_id=0 then '������������'
when t1.terminal_id<0 and t1.web_id>0 then 'OTA'
else '����' end,sum(case when t1.seats_name is not null then 1 else 0 end) num,
       sum(t1.money_fy),sum(t1.ticketprice)
from dw.da_order_drawback t1
join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
where t1.origin_std>=to_date('2019-01-01','yyyy-mm-dd')
  and t1.origin_std< to_date('2020-01-01','yyyy-mm-dd')
  and t1.money_fy>0
  group by  to_char(t1.origin_std,'yyyymm'),case when t1.money_terminal< 0 then '������������'
else '����' end,
case when t1.terminal_id<0 and t1.web_id=0 then '������������'
when t1.terminal_id<0 and t1.web_id>0 then 'OTA'
else '����' end



select to_char(t1.flights_date,'yyyymm'),sum(t1.boardnum)
 from dw.da_main_order t1
 where t1.flights_date>=to_date('2019-01-01','yyyy-mm-dd')
   and t1.flights_date< to_date('2020-01-01','yyyy-mm-dd')
   and t1.flights_no like '9C%'
   

  ======================================��Ʊ����======
  
  
  
  select to_char(t1.origin_std,'yyyymm') ������,case when t1.money_terminal< 0 then '������������'
else '����' end ��Ʊ����,
case when t1.terminal_id<0 and t1.web_id=0 then '������������'
when t1.terminal_id<0 and t1.web_id>0 then 'OTA'
else '����' end ��Ʊ����,sum(case when t1.seats_name is not null then 1 else 0 end) ��Ʊ��,
       sum(t1.money_fy) ������,sum(t1.ticketprice) ��ƱƱ��,null ticketnum
from dw.da_order_drawback t1
join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
where t1.origin_std>=to_date('2019-01-01','yyyy-mm-dd')
  and t1.origin_std< to_date('2020-09-01','yyyy-mm-dd')
  and t1.money_fy>0
  and t1.terminal_id<0
  and t1.web_id=0
  group by  to_char(t1.origin_std,'yyyymm'),case when t1.money_terminal< 0 then '������������'
else '����' end,
case when t1.terminal_id<0 and t1.web_id=0 then '������������'
when t1.terminal_id<0 and t1.web_id>0 then 'OTA'
else '����' end
union all
select to_char(t1.flights_date,'yyyymm') ������,'','������������',null,null,sum(t1.ticket_price),count(1) ticketnum 
 from dw.fact_order_detail t1
 where t1.flights_date>=to_date('2019-01-01','yyyy-mm-dd')
  and t1.flights_date< to_date('2020-09-01','yyyy-mm-dd')
  and t1.channel in('�ֻ�','��վ')
  and t1.seats_name is not null
  and t1.ticket_price>0
  and t1.company_id=0
  group by to_char(t1.flights_date,'yyyymm');
  
  
  select case when t1.money_fy<=99 then '0-99Ԫ'
when t1.money_fy<=199 then '100-199Ԫ'
when t1.money_fy<=299 then '200-299Ԫ'
when t1.money_fy<=399 then '300-399Ԫ'
when t1.money_fy<=499 then '400-499Ԫ'
when t1.money_fy<=999 then '500-999Ԫ'
when t1.money_fy>=1000 then '1000+' end ,count(1)
from dw.da_order_drawback t1
join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
where t1.origin_std>=to_date('2019-01-01','yyyy-mm-dd')
  and t1.origin_std< to_date('2020-01-01','yyyy-mm-dd')
  and t1.money_fy>0
  and t1.terminal_id<0
  and t1.web_id=0
  group by  case when t1.money_fy<=99 then '0-99Ԫ'
when t1.money_fy<=199 then '100-199Ԫ'
when t1.money_fy<=299 then '200-299Ԫ'
when t1.money_fy<=399 then '300-399Ԫ'
when t1.money_fy<=499 then '400-499Ԫ'
when t1.money_fy<=999 then '500-999Ԫ'
when t1.money_fy>=1000 then '1000+' end

