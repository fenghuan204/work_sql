select sdate,sum(unnormalnum1),sum(normalnum1),sum(num2),sum(money)
from(
select h1.sdate,h1.userid,unnormalnum1,normalnum1,num2,money
from(
select  t1.userid,trunc(created) sdate,
sum(case when t1.remark ='很好很好很好' then 1 else 0 end) unnormalnum1,
sum(case when t1.remark ='很好很好很好' then 0 else 1 end) normalnum1
from hdb.cms_ch_remark t1
where /*t1.remark ='很好很好很好'
and*/ t1.created>=to_date('2019-07-01','yyyy-mm-dd')
group by userid,trunc(created)
)h1
left join (
select to_char(users_id) usersid,trunc(t2.create_date) sdate,count(1) num2,sum(t3.money_var) money
from YHQ.CQ_NEW_YHQ_RELATION@to_air t2 
left join dw.bi_yhq_batch t3 on to_char(t2.create_id)=t3.batch_id
where t2.create_id in('6849','6811','5111','5112')
and t2.create_date>=to_date('2019-07-01','yyyy-mm-dd')
group by to_char(users_id) ,trunc(t2.create_date) )h2 on h1.userid=h2.usersid and h1.sdate=h2.sdate)
left join (
group by sdate;


select t1.batch_id,count(1),sum(t1.use_money)
from dw.bi_yhq_use t1
join dw.fact_other_order_detail t2 on t1.other_order_head_id=t2.other_order_head_id
where t1.batch_id in('6849','6811','5111','5112')
and t1.order_type=0
and t2.client_id in(select  distinct to_number(t1.userid) usersid
from hdb.cms_ch_remark t1
where t1.remark ='很好很好很好' 
and t1.created>=to_date('2019-01-01','yyyy-mm-dd')
)group by t1.batch_id;


select t1.batch_id,count(1),sum(t1.use_money)
from dw.bi_yhq_use t1
join dw.fact_other_order_detail t2 on t1.other_order_head_id=t2.other_order_head_id
join (select  distinct t1.userid
from hdb.cms_ch_remark t1
where t1.remark ='很好很好很好'  
and t1.created>=to_date('2019-01-01','yyyy-mm-dd'))t3 on to_char(t2.client_id)=t3.userid
where t1.batch_id in('6849','6811','5111','5112')
and t1.order_type=0
group by t1.batch_id




select t1.batch_id,count(1),sum(t1.use_money)
from dw.bi_yhq_use t1
join dw.fact_other_order_detail t2 on t1.other_order_head_id=t2.other_order_head_id
where t1.batch_id in('6849','6811','5111','5112')
and t1.order_type=0
)group by t1.batch_id




