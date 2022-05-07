----1、总体分析

select to_char(t.order_date,'yyyymmdd') 订单日期,to_char(t.order_date,'hh24') 订单时刻,
count(distinct  t.flights_order_id) 订单数,
count(1) 机票数,count(distinct t1.segment_head_id) 机票航班数,count(distinct t1.whole_segment) 机票航段数,
sum(case when t1.r_flights_date>=trunc(t.order_date)
and t1.r_flights_date<=trunc(t.order_date)+2 then 1 else 0 end) 未来2天机票数,
count(distinct case when t1.r_flights_date>=trunc(t.order_date)
and t1.r_flights_date<=trunc(t.order_date)+2 then t1.segment_head_id else null end) 未来2天的航班数,
count(distinct case when t1.r_flights_date>=trunc(t.order_date)
and t1.r_flights_date<=trunc(t.order_date)+2 then t1.whole_segment else null end) 未来2天的航段数
from cqsale.cq_order@to_air t
join cqsale.cq_order_head@to_air t1 on t.flights_order_id=t1.flights_order_id
left join cust.cq_flights_users@to_air t2 on t.client_id=t2.users_id
left join cqsale.cq_user_restrict@to_air t3 on t.client_id=t3.user_id
left join dw.da_flight t4 on t1.segment_head_id=t4.segment_head_id
where t.order_date>=to_date('2019-06-25','yyyy-mm-dd')
and t.order_date< to_date('2019-07-03','yyyy-mm-dd')
and t.order_date< trunc(sysdate)
and t.terminal_id=-1
and trunc(t.order_date) in(to_date('2019-07-02','yyyy-mm-dd'),to_date('2018-07-02','yyyy-mm-dd'),to_date('2019-06-25','yyyy-mm-dd'))
and t.web_id=0
and t1.whole_flight like '9C%'
and t1.flag_id in(8,9,10)
group by to_char(t.order_date,'yyyymmdd'),to_char(t.order_date,'hh24')

union all


select to_char(t.order_date,'yyyymmdd'),to_char(t.order_date,'hh24'),count(distinct  t.flights_order_id),
count(1),count(distinct t1.segment_head_id),count(distinct t1.whole_segment),sum(case when t1.r_flights_date>=trunc(t.order_date)
and t1.r_flights_date<=trunc(t.order_date)+2 then 1 else 0 end),
count(distinct case when t1.r_flights_date>=trunc(t.order_date)
and t1.r_flights_date<=trunc(t.order_date)+2 then t1.segment_head_id else null end),
count(distinct case when t1.r_flights_date>=trunc(t.order_date)
and t1.r_flights_date<=trunc(t.order_date)+2 then t1.whole_segment else null end)
from cqsale.cq_order@to_air t
join cqsale.cq_order_head@to_air t1 on t.flights_order_id=t1.flights_order_id
left join cust.cq_flights_users@to_air t2 on t.client_id=t2.users_id
left join cqsale.cq_user_restrict@to_air t3 on t.client_id=t3.user_id
left join dw.da_flight t4 on t1.segment_head_id=t4.segment_head_id
where t.order_date>=to_date('2018-07-02','yyyy-mm-dd')
and t.order_date< to_date('2018-07-03','yyyy-mm-dd')
and t.order_date< trunc(sysdate)
and t.terminal_id=-1
and trunc(t.order_date) in(to_date('2019-07-02','yyyy-mm-dd'),to_date('2018-07-02','yyyy-mm-dd'),to_date('2019-06-25','yyyy-mm-dd'))
and t.web_id=0
and t1.whole_flight like '9C%'
and t1.flag_id in(8,9,10)
group by to_char(t.order_date,'yyyymmdd'),to_char(t.order_date,'hh24');

-----2、细化分析


select h1.*,h2.机票数,h2.未来1天机票数
from(
select to_char(t.order_date,'yyyymmdd') 订单日期,to_char(t.order_date,'hh24') 订单时刻,
t1.r_flights_date-trunc(t.order_date) 提前期,
t1.r_flights_date,t1.whole_segment,t1.segment_head_id,count(distinct  t.flights_order_id) 订单数,
count(1) 机票数,sum(case when t1.r_flights_date>=trunc(t.order_date)
and t1.r_flights_date<=trunc(t.order_date)+1 then 1 else 0 end) 未来1天机票数
from cqsale.cq_order@to_air t
join cqsale.cq_order_head@to_air t1 on t.flights_order_id=t1.flights_order_id
left join cust.cq_flights_users@to_air t2 on t.client_id=t2.users_id
left join cqsale.cq_user_restrict@to_air t3 on t.client_id=t3.user_id
left join dw.da_flight t4 on t1.segment_head_id=t4.segment_head_id
left join dw.da_main_order t5 on t1.segment_head_id=t5.segment_head_id
where t.order_date>=to_date('2019-06-25','yyyy-mm-dd')
and t.order_date< to_date('2019-07-03','yyyy-mm-dd')
and t.order_date< trunc(sysdate)
and to_char(t.order_date,'hh24') in('21','22','23')
and t.terminal_id=-1
and trunc(t.order_date) in(to_date('2019-07-02','yyyy-mm-dd'),to_date('2018-07-02','yyyy-mm-dd'),to_date('2019-06-25','yyyy-mm-dd'))
and t.web_id=0
and t1.whole_flight like '9C%'
and t1.flag_id in(8,9,10)
group by to_char(t.order_date,'yyyymmdd'),to_char(t.order_date,'hh24'),t1.r_flights_date-trunc(t.order_date),
t1.r_flights_date,t1.whole_segment,t1.segment_head_id)h1
left join (select to_char(t.order_date,'yyyymmdd') 订单日期,to_char(t.order_date,'hh24') 订单时刻,
t1.r_flights_date,t1.whole_segment,t1.segment_head_id,count(distinct  t.flights_order_id) 订单数,
count(1) 机票数,sum(case when t1.r_flights_date>=trunc(t.order_date)
and t1.r_flights_date<=trunc(t.order_date)+1 then 1 else 0 end) 未来1天机票数
from cqsale.cq_order@to_air t
join cqsale.cq_order_head@to_air t1 on t.flights_order_id=t1.flights_order_id
left join cust.cq_flights_users@to_air t2 on t.client_id=t2.users_id
left join cqsale.cq_user_restrict@to_air t3 on t.client_id=t3.user_id
left join dw.da_flight t4 on t1.segment_head_id=t4.segment_head_id
left join dw.da_main_order t5 on t1.segment_head_id=t5.segment_head_id
where t.order_date>=to_date('2019-06-25','yyyy-mm-dd')
and t.order_date< to_date('2019-07-03','yyyy-mm-dd')
and t.order_date< trunc(sysdate)
and to_char(t.order_date,'hh24') in('21','22','23')
and t.terminal_id=-1
and trunc(t.order_date) in(to_date('2019-07-02','yyyy-mm-dd'),to_date('2018-07-02','yyyy-mm-dd'),to_date('2019-06-25','yyyy-mm-dd'))
and t.web_id=0
and t1.whole_flight like '9C%'
and t1.flag_id in(3,5,40,7,11,12)
group by to_char(t.order_date,'yyyymmdd'),to_char(t.order_date,'hh24'),t1.r_flights_date-trunc(t.order_date),
t1.r_flights_date,t1.whole_segment,t1.segment_head_id)h2 on h1.订单日期=h2.订单日期 and h1.订单时刻=h2.订单时刻 
and h1.r_flights_date=h2.r_flights_date and h1.whole_segment=h2.whole_segment and h1.segment_head_id=h2.segment_head_id


--去年同期的情况

select h1.*,h2.机票数,h2.未来1天机票数
from(
select to_char(t.order_date,'yyyymmdd') 订单日期,to_char(t.order_date,'hh24') 订单时刻,
t1.r_flights_date-trunc(t.order_date) 提前期,
t1.r_flights_date,t1.whole_segment,t1.segment_head_id,count(distinct  t.flights_order_id) 订单数,
count(1) 机票数,sum(case when t1.r_flights_date>=trunc(t.order_date)
and t1.r_flights_date<=trunc(t.order_date)+1 then 1 else 0 end) 未来1天机票数
from cqsale.cq_order@to_air t
join cqsale.cq_order_head@to_air t1 on t.flights_order_id=t1.flights_order_id
left join cust.cq_flights_users@to_air t2 on t.client_id=t2.users_id
left join cqsale.cq_user_restrict@to_air t3 on t.client_id=t3.user_id
left join dw.da_flight t4 on t1.segment_head_id=t4.segment_head_id
left join dw.da_main_order t5 on t1.segment_head_id=t5.segment_head_id
where t.order_date>=to_date('2018-06-25','yyyy-mm-dd')
and t.order_date< to_date('2018-07-03','yyyy-mm-dd')
and t.order_date< trunc(sysdate)
and to_char(t.order_date,'hh24') in('21','22','23')
and t.terminal_id=-1
and trunc(t.order_date) in(to_date('2018-07-02','yyyy-mm-dd'),to_date('2018-07-02','yyyy-mm-dd'),to_date('2018-06-25','yyyy-mm-dd'))
and t.web_id=0
and t1.whole_flight like '9C%'
and t1.flag_id in(8,9,10)
group by to_char(t.order_date,'yyyymmdd'),to_char(t.order_date,'hh24'),t1.r_flights_date-trunc(t.order_date),
t1.r_flights_date,t1.whole_segment,t1.segment_head_id)h1
left join (select to_char(t.order_date,'yyyymmdd') 订单日期,to_char(t.order_date,'hh24') 订单时刻,
t1.r_flights_date,t1.whole_segment,t1.segment_head_id,count(distinct  t.flights_order_id) 订单数,
count(1) 机票数,sum(case when t1.r_flights_date>=trunc(t.order_date)
and t1.r_flights_date<=trunc(t.order_date)+1 then 1 else 0 end) 未来1天机票数
from cqsale.cq_order@to_air t
join cqsale.cq_order_head@to_air t1 on t.flights_order_id=t1.flights_order_id
left join cust.cq_flights_users@to_air t2 on t.client_id=t2.users_id
left join cqsale.cq_user_restrict@to_air t3 on t.client_id=t3.user_id
left join dw.da_flight t4 on t1.segment_head_id=t4.segment_head_id
left join dw.da_main_order t5 on t1.segment_head_id=t5.segment_head_id
where t.order_date>=to_date('2018-06-25','yyyy-mm-dd')
and t.order_date< to_date('2018-07-03','yyyy-mm-dd')
and t.order_date< trunc(sysdate)
and to_char(t.order_date,'hh24') in('21','22','23')
and t.terminal_id=-1
and trunc(t.order_date) in(to_date('2018-07-02','yyyy-mm-dd'),to_date('2018-07-02','yyyy-mm-dd'),to_date('2018-06-25','yyyy-mm-dd'))
and t.web_id=0
and t1.whole_flight like '9C%'
and t1.flag_id in(3,5,40,7,11,12)
group by to_char(t.order_date,'yyyymmdd'),to_char(t.order_date,'hh24'),t1.r_flights_date-trunc(t.order_date),
t1.r_flights_date,t1.whole_segment,t1.segment_head_id)h2 on h1.订单日期=h2.订单日期 and h1.订单时刻=h2.订单时刻 
and h1.r_flights_date=h2.r_flights_date and h1.whole_segment=h2.whole_segment and h1.segment_head_id=h2.segment_head_id





