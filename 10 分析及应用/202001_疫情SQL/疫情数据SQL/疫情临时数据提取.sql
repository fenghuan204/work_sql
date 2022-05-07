
--上海两场到达旅客量
select /*+parallel(4) */
t1.flights_date,t2.destairport,count(1),count(distinct t2.segment_head_id)
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  where t2.flag<>2
  and t1.flights_date>=to_date('2020-01-29','yyyy-mm-dd')
  and t1.flights_date< to_date('2020-02-11','yyyy-mm-dd')
  and t1.company_id=0
  and t1.seats_name is not null
  and t2.destairport in('SHA','PVG')
  group by t1.flights_date,t2.destairport;
  
  
  
  ----航班日期每日退票量
  
select t1.r_flights_date,sum(case when t1.flag_id in(3,5,40,41) then 1 else 0 end) 已支付机票 ,
sum(case when t1.flag_id=40 then 1 else 0 end) 已乘机机票 ,
suM(case when t1.flag_id in(7,11,12) then 1 else 0 end) 退票机票
from cqsale.cq_order@to_air t
join cqsale.cq_order_head@to_air t1 on t.flights_order_id=t1.flights_order_id
where t1.r_flights_date>=trunc(sysdate-7)
and t1.r_flights_date< trunc(sysdate)+12
and t1.whole_flight like '9C%'
and t1.seats_name is not null
and t1.flag_id in(3,5,40,41,7,11,12)
group by  t1.r_flights_date;



---临时提取：徐州=曼谷旅客明细数据

select t1.r_flights_date,t1.whole_flight,t1.whole_segment,case when t1.seats_name in('B','G','G1','G2') then '团队'
    else '非团队' end,t1.name||' '||coalesce(t1.second_name,'')  姓名,t1.codeno, t1.r_tel,t5.sub_channel,t6.nationality,
	t3.province,t3.city
 from cqsale.cq_order@to_air t
 join cqsale.cq_order_head@to_air t1 on t.flights_order_id=t1.flights_order_id
 join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
 left join dw.adt_mobile_list t3 on substr(getmobile(t1.r_tel),1,7) =t3.mobilenumber
 left join dw.fact_order_detail t5 on t1.flights_order_head_id=t5.flights_order_head_id
 left  join cqsale.cq_traveller_info@to_air t6 on t1.flights_order_head_id=t6.flights_order_head_id
  where t1.r_flights_date=trunc(sysdate)+1
  and t1.flag_id in(3,5,40,41)
  and t2.flag<>2
  and t1.whole_flight ='9C6205'
  and t1.whole_flight like '9C%';
  
  
  ---十堰、恩施数据
  select /*+parallel(4) */
t1.flights_date,t2.flights_segment_name,t2.flight_no,count(1)
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  where regexp_like(t2.flights_segment_name, '(十堰)|(恩施)')
  and t1.flights_date>=trunc(sysdate)
  and t1.seats_name is not null
  group by t1.flights_date,t2.flights_segment_name,t2.flight_no;
  
  
  
  select '昨天全部' type,t1.new_seat_price-t1.old_seat_price,t1.differ_price,count(1)
from dw.da_order_change t1
where t1.modify_date>=trunc(sysdate-1)
group by t1.new_seat_price-t1.old_seat_price,t1.differ_price

union all


select '今日' type,t1.new_seat_price-t1.old_seat_price,t1.differ_price,
count(1)
from hdb.temp_feng_modify t1
where t1.modify_date>=trunc(sysdate)
group by t1.new_seat_price-t1.old_seat_price,t1.differ_price

union all

select '昨天截止相同时刻' type,t1.new_seat_price-t1.old_seat_price,t1.differ_price,
count(1)
from dw.da_order_change t1
where t1.modify_date>=trunc(sysdate-1)
and to_char(t1.modify_date,'hh24:mi')< to_char(sysdate,'hh24:mi')
group by t1.new_seat_price-t1.old_seat_price,t1.differ_price;



--------------退票重购票价

select /*+parallel(4) */
'昨天',
case when t3.r_flights_date is not null then t3.r_flights_date-trunc(t1.origin_std) 
else null end ,
case when t3.r_flights_date is not null then  t3.ticket_price*nvl(t3.r_com_rate,1) -t1.ticketprice
else null end ,
count(distinct t1.flights_order_head_id),count(distinct t3.flights_order_head_id)
from dw.da_order_drawback t1
left join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
left join cqsale.cq_order_head@to_air  t3 on t1.codeno=t3.codeno and t1.sname=t3.name||coalesce(t3.second_name,'') and t3.r_flights_date<>trunc(t1.origin_std) and 
t3.r_order_date> t1.money_date and t3.flag_id in(3,5,40) and t3.r_order_date>=trunc(sysdate)-1 and t3.r_flights_date>=trunc(sysdate)-1
where t1.money_date>=trunc(sysdate)-1
and t1.seats_name is not null
group by case when t3.r_flights_date is not null then t3.r_flights_date-trunc(t1.origin_std) 
else null end ,
case when t3.r_flights_date is not null then  t3.ticket_price*nvl(t3.r_com_rate,1) -t1.ticketprice
else null end


union all

select /*+parallel(4) */
'今日' type,
case when t3.r_flights_date is not null then t3.r_flights_date-trunc(t1.origin_std) 
else null end ,
case when t3.r_flights_date is not null then  t3.ticket_price*nvl(t3.r_com_rate,1) -t1.ticketprice
else null end ,
count(distinct t1.flights_order_head_id),count(distinct t3.flights_order_head_id)
from hdb.temp_feng_back_today t1
left join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
left join cqsale.cq_order_head@to_air  t3 on t1.codeno=t3.codeno and t1.sname=t3.name||coalesce(t3.second_name,'') and t3.r_flights_date<>trunc(t1.origin_std) and 
t3.r_order_date> t1.money_date and t3.flag_id in(3,5,40) and t3.r_order_date>=trunc(sysdate) and t3.r_flights_date>=trunc(sysdate)
where t1.money_date>=trunc(sysdate)
and t1.seats_name is not null
group by case when t3.r_flights_date is not null then t3.r_flights_date-trunc(t1.origin_std) 
else null end ,
case when t3.r_flights_date is not null then  t3.ticket_price*nvl(t3.r_com_rate,1) -t1.ticketprice
else null end

union all

select /*+parallel(4) */
'昨天相同时刻',
case when t3.r_flights_date is not null then t3.r_flights_date-trunc(t1.origin_std) 
else null end ,
case when t3.r_flights_date is not null then  t3.ticket_price*nvl(t3.r_com_rate,1) -t1.ticketprice
else null end ,
count(distinct t1.flights_order_head_id),count(distinct t3.flights_order_head_id)
from dw.da_order_drawback t1
left join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
left join cqsale.cq_order_head@to_air  t3 on t1.codeno=t3.codeno and t1.sname=t3.name||coalesce(t3.second_name,'') and t3.r_flights_date<>trunc(t1.origin_std) and 
t3.r_order_date> t1.money_date and t3.flag_id in(3,5,40) and t3.r_order_date>=trunc(sysdate)-1 and t3.r_flights_date>=trunc(sysdate)-1
where t1.money_date>=trunc(sysdate)-1
and to_char(t1.money_date,'hh24:mi')< to_char(sysdate,'hh24:mi')
and t1.seats_name is not null
group by case when t3.r_flights_date is not null then t3.r_flights_date-trunc(t1.origin_std) 
else null end ,
case when t3.r_flights_date is not null then  t3.ticket_price*nvl(t3.r_com_rate,1) -t1.ticketprice
else null end;



------销售查询

select  /*+parallel(4) */
t1.segment_head_id, t1.flights_date,t1.whole_flight,t2.flights_segment_name,t3.wf_segment_name,t2.nationflag,
t2.segment_type,t2.oversale,
case when t1.seats_name in('B','G','G1','G2') then 'BG'
else '非BG' end bgtype,
count(1) ticketnum,
sum(case when t1.order_day< to_date('2020-01-24','yyyy-mm-dd') then 1 else 0 end) "24号之前销售"
from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  left join dw.dim_segment_type t3 on t2.route_id=t3.route_id and t2.h_route_id=t3.h_route_id
  where t1.flights_date>=to_date('2020-01-23','yyyy-mm-dd')
      and t1.flights_date<= to_date('2020-02-16','yyyy-mm-dd')
    and t1.seats_name is not null
    and t1.company_id=0
    and t2.flag<>2
    group by t1.segment_head_id, t1.flights_date,t1.whole_flight,t2.flights_segment_name,t3.wf_segment_name,t2.nationflag,
t2.segment_type,t2.oversale ,case when t1.seats_name in('B','G','G1','G2') then 'BG'
else '非BG' end



-----0211-0224每天取消航班的销售进度

select flight_date,whole_flight,route_Name,wf_segment_name,sum(oversale) oversale,sum(ticketnum)
from(
select t1.segment_head_id,t2.flight_date,t1.whole_flight,t2.route_name,t3.wf_segment_name,
t2.oversale,t2.flag,
sum(case when t1.seats_name is not null then 1 else 0 end) ticketnum,
    sum(t1.ticket_price) ticketprice,sum(case when t1.seats_name is not null then t1.price else 0 end） allprice
   from dw.fact_order_detail t1
   join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
   left join dw.dim_segment_type t3 on t2.route_id=t3.route_id and t2.h_route_id=t3.h_route_id
   where t1.flights_date>=to_date('2020-02-11','yyyy-mm-dd')
     and t1.flights_date<=to_date('2020-02-24','yyyy-mm-dd')
   and t1.company_id=0
   and t2.flag=2
   and t1.order_day< trunc(sysdate)
   and t1.seats_name is  not null
   t1.segment_head_id,t2.flight_date,t1.whole_flight,t2.route_name,t3.wf_segment_name,
t2.oversale,t2.flag)h1
group by  flight_date,whole_flight,route_Name,wf_segment_name；




-----退票提前期数据

select /*+parallel(4) */
trunc(t2.origin_std),
case when t2.money_date> t2.origin_std then '离站后'
when (t2.origin_std-t2.money_date) *24< 2 then '[0~2h)'
when (t2.origin_std-t2.money_date) *24< 6 then '[2~6h)'
when (t2.origin_std-t2.money_date) *24< 8 then '[6~8h)'
when (t2.origin_std-t2.money_date) *24< 12 then '[8~12h)'
when (t2.origin_std-t2.money_date) *24< 24 then '[12~24h)'
when (t2.origin_std-t2.money_date) *24< 48 then '[24~48h)'
when (t2.origin_std-t2.money_date) *24>= 48 then '48h+' end hourtype,
count(1)
from dw.da_order_drawback t2 
left join dw.da_flight t4 on t2.segment_head_id=t4.segment_head_id
where t2.origin_std>=to_date('2020-01-29','yyyy-mm-dd')
and t2.origin_std< to_date('2020-01-31','yyyy-mm-dd')
and t2.money_date>=to_date('2020-01-27','yyyy-mm-dd')
and t2.seats_name is not null
group by trunc(t2.origin_std),
case when t2.money_date> t2.origin_std then '离站后'
when (t2.origin_std-t2.money_date) *24< 2 then '[0~2h)'
when (t2.origin_std-t2.money_date) *24< 6 then '[2~6h)'
when (t2.origin_std-t2.money_date) *24< 8 then '[6~8h)'
when (t2.origin_std-t2.money_date) *24< 12 then '[8~12h)'
when (t2.origin_std-t2.money_date) *24< 24 then '[12~24h)'
when (t2.origin_std-t2.money_date) *24< 48 then '[24~48h)'
when (t2.origin_std-t2.money_date) *24>= 48 then '48h+' end;


===============================================20200204==============================================


select t1.r_flights_date,t1.whole_flight,t1.whole_segment,
       count(1),sum(case when t1.sex=1 then 1 else 0 end),
       sum(case when t1.sex=2 then 1 else 0 end),
       sum(case when t1.sex=3 then 1 else 0 end)
  from cqsale.cq_order_head@to_air t1
  join cqsale.cq_flights_segment_head@to_air t2 on t1.segment_head_id=t2.segment_head_id
  where t2.flag<>2
  and t1.r_flights_date>=to_date('2020-02-04','yyyy-mm-dd')
  and t1.r_flights_date< to_date('2020-02-07','yyyy-mm-dd')
  and t1.whole_segment like '%CJU%'
  and t1.flag_Id in(3,5,40,41)
  group by t1.r_flights_date,t1.whole_flight,t1.whole_segment;
  
  
  
  --------------------------------------------------------------------------20200204-----------------------------------
  
  
  
  select t.flight_date,count(1)
from dw.da_flight t
join hdb.cq_airport t1 on t.originairport=t1.threecodeforcity
where t1.province like '%浙江%'
and t.flight_date>=trunc(sysdate)
and t.flag<>2
and regexp_like(t.segment_code,'(WNZ)|(JIX)|(TOX)|(HYN)|(HGH)|(HSN)|(NGB)|(SHX)')
group by t.flight_date

select * from hdb.cq_airport 
where province like '%浙江%'


select  t1.r_flights_date 航班日期,t1.whole_flight 航班号,
          case when t2.ORIGIN_AIRPORT in('WNZ',
'JIX',
'TOX',
'HYN',
'HGH',
'HSN',
'NGB',
'SHX',
'YIW',
'LHA'
) then '出港'
when t2.dest_AIRPORT in('WNZ',
'JIX',
'TOX',
'HYN',
'HGH',
'HSN',
'NGB',
'SHX',
'YIW',
'LHA') then  '进港' end 进出港, decode(t1.sex,1,'成人',2,'儿童',3,'婴儿') 旅客类型,
t1.name||' '||coalesce(t1.second_name,'') 姓名,
t1.codeno 证件号码,t1.r_tel 手机号码
 from cqsale.cq_order_head@to_air t1
 join cqsale.cq_flights_segment_head@to_air t2 on t1.segment_head_id=t2.segment_head_id
 where  t1.flag_id iN(3,5,40,41)
 and t1.whole_flight like '9C%'
 and (t2.ORIGIN_AIRPORT in('WNZ',
'JIX',
'TOX',
'HYN',
'HGH',
'HSN',
'NGB',
'SHX',
'YIW',
'LHA'
)   or   t2.dest_AIRPORT in('WNZ',
'JIX',
'TOX',
'HYN',
'HGH',
'HSN',
'NGB',
'SHX',
'YIW',
'LHA')  )
 and t2.flag<>2
 and t1.r_flights_date=trunc(sysdate+1)

 

 
