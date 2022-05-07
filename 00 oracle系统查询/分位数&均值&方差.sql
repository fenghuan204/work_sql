#退改签异常监控


#分位数&均值&方差

select h2.*,h3.move_avg
from(
select h1.sdate,h1.week,h1.ticketnum,h1.max_sal_0,h1.max_sal_25,h1.max_sal_50,h1.max_sal_75,h1.max_sal_100,
h1.medium,h1.max_sal_75+1.5*(h1.max_sal_75-h1.max_sal_25) TOP,h1.max_sal_25-1.5*(h1.max_sal_75-h1.max_sal_25) low,
h1.avgnum,h1.stdnum,h1.avgnum-3*h1.stdnum down,h1.avgnum+3*stdnum up
from(
select sdate,week,ticketnum,
PERCENTILE_CONT(0) within group(order by ticketnum)over(partition by week) as max_sal_0,
       PERCENTILE_CONT(0.25) within group(order by ticketnum)over(partition by week)as max_sal_25,
       PERCENTILE_CONT(0.5) within group(order by ticketnum)over(partition by week) as max_sal_50,
       PERCENTILE_CONT(0.75) within group(order by ticketnum)over(partition by week) as max_sal_75,
       PERCENTILE_CONT(1) within group(order by ticketnum)over(partition by week) as max_sal_100,
       MEDIAN(ticketnum)over(partition by week) medium,
       avg(ticketnum)over(partition by week) avgnum,
       STDDEV_SAMP (ticketnum) OVER (PARTITION BY week) stdnum 
from(
select trunc(t1.money_date) sdate,to_char(t1.money_date,'day') week,count(1) ticketnum
from dw.da_order_drawback t1
join dw.adt_corre_date t2 on trunc(t1.money_date)=t2.datetime
where t1.money_date>=to_date('2018-03-01','yyyy-mm-dd')
and t1.money_date< to_date('2018-10-19','yyyy-mm-dd')
and t2.memo is null
group by trunc(t1.money_date) ,to_char(t1.money_date,'day') ))h1)h2


join(select sdate,week,ticketnum,avg(ticketnum)over(partition by week order by sdate 
rows between 6 preceding and current row) move_avg
from(
select trunc(t1.money_date) sdate,to_char(t1.money_date,'day') week,count(1) ticketnum
from dw.da_order_drawback t1
join dw.adt_corre_date t2 on trunc(t1.money_date)=t2.datetime
where t1.money_date>=to_date('2018-03-01','yyyy-mm-dd')
and t2.memo is null
group by trunc(t1.money_date) ,to_char(t1.money_date,'day') )h1)h3  on h2.sdate=h3.sdate and h2.week=h3.week




##1 、历史参考值记录
insert into  hdb.da_drawback_his
select distinct h1.week,h1.type,h1.max_sal_0,h1.max_sal_25,h1.max_sal_50,h1.max_sal_75,h1.max_sal_100,
h1.medium,h1.max_sal_75+1.5*(h1.max_sal_75-h1.max_sal_25) TOP,greatest(h1.max_sal_25-1.5*(h1.max_sal_75-h1.max_sal_25),h1.max_sal_0) low,
h1.avgnum,h1.stdnum,h1.avgnum-3*h1.stdnum down,h1.avgnum+3*stdnum up
from(
select week,type,
PERCENTILE_CONT(0) within group(order by ticketnum)over(partition by week,type) as max_sal_0,
       PERCENTILE_CONT(0.25) within group(order by ticketnum)over(partition by week,type)as max_sal_25,
       PERCENTILE_CONT(0.5) within group(order by ticketnum)over(partition by week,type) as max_sal_50,
       PERCENTILE_CONT(0.75) within group(order by ticketnum)over(partition by week,type) as max_sal_75,
       PERCENTILE_CONT(1) within group(order by ticketnum)over(partition by week,type) as max_sal_100,
       MEDIAN(ticketnum)over(partition by week,type) medium,
       avg(ticketnum)over(partition by week,type) avgnum,
       STDDEV_SAMP (ticketnum) OVER (PARTITION BY week,type) stdnum 
from(
select trunc(t1.money_date) sdate,
case when t1.seats_name like 'P%' then 'P舱'
when t1.seats_name like 'R%' then 'R舱'
when t1.seats_name in('E','U','X','T','Q','N') then 'EUXTQN'
when t1.seats_name in('Y','S','H','V','K','L','M') then 'YSHVKLM'
else '其他' end type,to_char(t1.money_date,'day') week,count(1) ticketnum
from dw.da_order_drawback t1
join dw.adt_corre_date t2 on trunc(t1.money_date)=t2.datetime
where t1.money_date>=to_date('2018-03-01','yyyy-mm-dd')
and t2.memo is null
group by trunc(t1.money_date) ,
case when t1.seats_name like 'P%' then 'P舱'
when t1.seats_name like 'R%' then 'R舱'
when t1.seats_name in('E','U','X','T','Q','N') then 'EUXTQN'
when t1.seats_name in('Y','S','H','V','K','L','M') then 'YSHVKLM'
else '其他' end,to_char(t1.money_date,'day') ))h1;


##2 


select trunc(t1.money_date) sdate,t2.area_type,
case when t1.seats_name like 'P%' then 'P舱'
when t1.seats_name like 'R%' then 'R舱'
when t1.seats_name in('E','U','X','T','Q','N') then 'EUXTQN'
when t1.seats_name in('Y','S','H','V','K','L','M') then 'YSHVKLM'
else '其他' end seattype,nvl(t1.seats_name,'YE') seats_name,
case when t1.origin_std-t1.money_date<0 then '航班离站后'
when (t1.origin_std-t1.money_date)*24<2 then '[0-2H)'
when (t1.origin_std-t1.money_date)*24<24 then '[2H-24H)'
when (t1.origin_std-t1.money_date)<3 then '[24H-3D)'
when (t1.origin_std-t1.money_date)<7 then '[3D-7D)'
when (t1.origin_std-t1.money_date)>=7 then '7D+' end priod,
count(1) ticketnum,suM(t1.money_fy) myfy
from dw.da_order_drawback t1
join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
where t1.money_date>=trunc(sysdate)-7*14
  and t1.money_date<=trunc(sysdate)-7
  group by trunc(t1.money_date) ,t2.area_type,
case when t1.seats_name like 'P%' then 'P舱'
when t1.seats_name like 'R%' then 'R舱'
when t1.seats_name in('E','U','X','T','Q','N') then 'EUXTQN'
when t1.seats_name in('Y','S','H','V','K','L','M') then 'YSHVKLM'
else '其他' end ,nvl(t1.seats_name,'YE'),case when t1.origin_std-t1.money_date<0 then '航班离站后'
when (t1.origin_std-t1.money_date)*24<2 then '[0-2H)'
when (t1.origin_std-t1.money_date)*24<24 then '[2H-24H)'
when (t1.origin_std-t1.money_date)<3 then '[24H-3D)'
when (t1.origin_std-t1.money_date)<7 then '[3D-7D)'
when (t1.origin_std-t1.money_date)>=7 then '7D+' end;