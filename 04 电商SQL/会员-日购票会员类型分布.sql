--昨日下单会员在过去一年的购票情况（半年内购票、半年~1年内购票、首购、1年前购票）

select case when t4.users_id is not null and trunc(t4.first_orderdate)=t1.order_day then '首购'
when t4.users_id is null and t3.client_id is not null and t3.max_day>=trunc(sysdate)-365-1
and t3.max_day< trunc(sysdate)-180-1 then '1年内购票会员'
when t4.users_id is null and t3.client_id is not null and t3.max_day>=trunc(sysdate)-180-1
and t3.max_day< trunc(sysdate)-1 then '半年内购票会员'
when t4.users_id is not null and t3.client_id is not null and t3.max_day>=trunc(sysdate)-365-1
and t3.max_day< trunc(sysdate)-180-1 then '1年内购票会员'
when t4.users_id is not null and t3.client_id is not null 
and t3.max_day>=trunc(sysdate)-180-1
and t3.max_day< trunc(sysdate)-1 then '半年内购票会员'
when t4.users_id is null and t3.client_id is null then '首购'
else '1年前购票会员' end,count(distinct t1.client_id) 
 from dw.fact_order_detail t1
 join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
 left join (select tt1.client_id,count(distinct tt1.flights_order_Id) ordernum,
 max(tt1.order_day) max_day
 from dw.fact_order_detail tt1
 join dw.da_flight tt2 on tt1.segment_head_id=tt2.segment_head_id
 where tt1.order_day>=trunc(sysdate)-365-1
   and tt1.order_day< trunc(sysdate)-1
   and tt1.channel in('网站','手机')
   and tt1.company_id=0
   group by tt1.client_id) t3 on t1.client_id=t3.client_id
    left join dw.da_user_purchase t4 on t1.client_id=t4.users_id
  where t1.order_day>=trunc(sysdate)-1
   and t1.order_day< trunc(sysdate)
   and t1.channel in('网站','手机')
   and t1.company_id=0
   group by case when t4.users_id is not null and trunc(t4.first_orderdate)=t1.order_day then '首购'
when t4.users_id is null and t3.client_id is not null and t3.max_day>=trunc(sysdate)-365-1
and t3.max_day< trunc(sysdate)-180-1 then '1年内购票会员'
when t4.users_id is null and t3.client_id is not null and t3.max_day>=trunc(sysdate)-180-1
and t3.max_day< trunc(sysdate)-1 then '半年内购票会员'
when t4.users_id is not null and t3.client_id is not null and t3.max_day>=trunc(sysdate)-365-1
and t3.max_day< trunc(sysdate)-180-1 then '1年内购票会员'
when t4.users_id is not null and t3.client_id is not null 
and t3.max_day>=trunc(sysdate)-180-1
and t3.max_day< trunc(sysdate)-1 then '半年内购票会员'
when t4.users_id is null and t3.client_id is null then '首购'
else '1年前购票会员' end;



--上一年的购票会员在下一年的表现（1年内复购、1年~2年内复购、未复购）

select case when hh2.client_id is not null and hh2.max_day-hh1.min_day<=365 then '1年内复购'
when hh2.client_id is not null and hh2.max_day-hh1.min_day>=365 then '1年~2年复购'
else '未复购' end,count(1)
from(
select tt1.client_id,count(distinct tt1.flights_order_Id) ordernum,
 min(tt1.order_day) min_day
 from dw.fact_order_detail tt1
 join dw.da_flight tt2 on tt1.segment_head_id=tt2.segment_head_id
 where tt1.order_day>=trunc(sysdate)-365-365
   and tt1.order_day< trunc(sysdate)-365
   and tt1.channel in('网站','手机')
   and tt1.company_id=0
   group by tt1.client_id)hh1
   left join(
select tt1.client_id,count(distinct tt1.flights_order_Id) ordernum,
 max(tt1.order_day) max_day
 from dw.fact_order_detail tt1
 join dw.da_flight tt2 on tt1.segment_head_id=tt2.segment_head_id
 where tt1.order_day>=trunc(sysdate)-365
   and tt1.order_day< trunc(sysdate)
   and tt1.channel in('网站','手机')
   and tt1.company_id=0
   group by tt1.client_id)hh2 on hh1.client_id=hh2.client_id
   group by case when hh2.client_id is not null and hh2.max_day-hh1.min_day<=365 then '1年内复购'
when hh2.client_id is not null and hh2.max_day-hh1.min_day>=365 then '1年~2年复购'
else '未复购' end;



---月度复购数据

select case when hh2.client_id is not null and hh2.max_day-hh1.min_day<=365 then '1年内复购'
when hh2.client_id is not null and hh2.max_day-hh1.min_day>=365 then '1年~2年复购'
else '未复购' end,count(1)
from(
select tt1.client_id,count(distinct tt1.flights_order_Id) ordernum,
 min(tt1.order_day) min_day
 from dw.fact_order_detail tt1
 join dw.da_flight tt2 on tt1.segment_head_id=tt2.segment_head_id
 where tt1.order_day>=add_months(last_day(trunc(sysdate))+1,-14)
   and tt1.order_day< add_months(last_day(trunc(sysdate))+1,-2)
   and tt1.channel in('网站','手机')
   and tt1.company_id=0
   group by tt1.client_id)hh1
   left join(
select tt1.client_id,count(distinct tt1.flights_order_Id) ordernum,
 max(tt1.order_day) max_day
 from dw.fact_order_detail tt1
 join dw.da_flight tt2 on tt1.segment_head_id=tt2.segment_head_id
 where tt1.order_day>=add_months(last_day(trunc(sysdate))+1,-2)
   and tt1.order_day< add_months(last_day(trunc(sysdate))+1,-1)
   and tt1.channel in('网站','手机')
   and tt1.company_id=0
   group by tt1.client_id)hh2 on hh1.client_id=hh2.client_id
   group by case when hh2.client_id is not null and hh2.max_day-hh1.min_day<=365 then '1年内复购'
when hh2.client_id is not null and hh2.max_day-hh1.min_day>=365 then '1年~2年复购'
else '未复购' end;


