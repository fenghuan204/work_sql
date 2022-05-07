----1���������

select to_char(t.order_date,'yyyymmdd') ��������,to_char(t.order_date,'hh24') ����ʱ��,
count(distinct  t.flights_order_id) ������,
count(1) ��Ʊ��,count(distinct t1.segment_head_id) ��Ʊ������,count(distinct t1.whole_segment) ��Ʊ������,
sum(case when t1.r_flights_date>=trunc(t.order_date)
and t1.r_flights_date<=trunc(t.order_date)+2 then 1 else 0 end) δ��2���Ʊ��,
count(distinct case when t1.r_flights_date>=trunc(t.order_date)
and t1.r_flights_date<=trunc(t.order_date)+2 then t1.segment_head_id else null end) δ��2��ĺ�����,
count(distinct case when t1.r_flights_date>=trunc(t.order_date)
and t1.r_flights_date<=trunc(t.order_date)+2 then t1.whole_segment else null end) δ��2��ĺ�����
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

-----2��ϸ������


select h1.*,h2.��Ʊ��,h2.δ��1���Ʊ��
from(
select to_char(t.order_date,'yyyymmdd') ��������,to_char(t.order_date,'hh24') ����ʱ��,
t1.r_flights_date-trunc(t.order_date) ��ǰ��,
t1.r_flights_date,t1.whole_segment,t1.segment_head_id,count(distinct  t.flights_order_id) ������,
count(1) ��Ʊ��,sum(case when t1.r_flights_date>=trunc(t.order_date)
and t1.r_flights_date<=trunc(t.order_date)+1 then 1 else 0 end) δ��1���Ʊ��
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
left join (select to_char(t.order_date,'yyyymmdd') ��������,to_char(t.order_date,'hh24') ����ʱ��,
t1.r_flights_date,t1.whole_segment,t1.segment_head_id,count(distinct  t.flights_order_id) ������,
count(1) ��Ʊ��,sum(case when t1.r_flights_date>=trunc(t.order_date)
and t1.r_flights_date<=trunc(t.order_date)+1 then 1 else 0 end) δ��1���Ʊ��
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
t1.r_flights_date,t1.whole_segment,t1.segment_head_id)h2 on h1.��������=h2.�������� and h1.����ʱ��=h2.����ʱ�� 
and h1.r_flights_date=h2.r_flights_date and h1.whole_segment=h2.whole_segment and h1.segment_head_id=h2.segment_head_id


--ȥ��ͬ�ڵ����

select h1.*,h2.��Ʊ��,h2.δ��1���Ʊ��
from(
select to_char(t.order_date,'yyyymmdd') ��������,to_char(t.order_date,'hh24') ����ʱ��,
t1.r_flights_date-trunc(t.order_date) ��ǰ��,
t1.r_flights_date,t1.whole_segment,t1.segment_head_id,count(distinct  t.flights_order_id) ������,
count(1) ��Ʊ��,sum(case when t1.r_flights_date>=trunc(t.order_date)
and t1.r_flights_date<=trunc(t.order_date)+1 then 1 else 0 end) δ��1���Ʊ��
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
left join (select to_char(t.order_date,'yyyymmdd') ��������,to_char(t.order_date,'hh24') ����ʱ��,
t1.r_flights_date,t1.whole_segment,t1.segment_head_id,count(distinct  t.flights_order_id) ������,
count(1) ��Ʊ��,sum(case when t1.r_flights_date>=trunc(t.order_date)
and t1.r_flights_date<=trunc(t.order_date)+1 then 1 else 0 end) δ��1���Ʊ��
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
t1.r_flights_date,t1.whole_segment,t1.segment_head_id)h2 on h1.��������=h2.�������� and h1.����ʱ��=h2.����ʱ�� 
and h1.r_flights_date=h2.r_flights_date and h1.whole_segment=h2.whole_segment and h1.segment_head_id=h2.segment_head_id





