select  t1.identify,t1.feature,t1.feature_value,t4.memo,count(1)
from dw.da_restrict_userinfo t1
left join dw.da_b2c_user t2 on t1.users_id=t2.users_id
left join dw.da_user_purchase t3 on t1.users_id=t3.users_id
left join dw.da_user_restrict t4 on t1.users_id=t4.users_id
where t1.create_date>=trunc(sysdate-1)
  and t1.identify not like '%特征%'
group by t1.identify,t1.feature,t1.feature_value,t4.memo;


select t1.client_id,t2.identify,t2.feature,t2.feature_id,t2.feature_value,trunc(t2.create_date),t4.memo,count(1)
from dw.fact_order_detail t1
join dw.da_restrict_userinfo t2 on t1.client_id=t2.users_id
left join dw.da_user_restrict t4 on t2.users_id=t4.users_id
where t1.order_day>=trunc(sysdate-1)
  and t1.channel in('网站','手机')
  and t2.identify not like '%特征%'
  and t2.identify not like '%troy%'
  group by t1.client_id,t2.identify,t2.feature,t2.feature_id,t2.feature_value,trunc(t2.create_date),t4.memo;
  
  
  select h1.*
  from(
  select t1.order_day,t2.identify,t2.feature,t2.feature_id,t2.feature_value,count(1),count(distinct t1.client_id),
  sum(count(1))over(partition by t2.identify,t2.feature,t2.feature_id,t2.feature_value) totnum
from dw.fact_order_detail t1
join dw.da_restrict_userinfo t2 on t1.client_id=t2.users_id
left join dw.da_user_restrict t4 on t2.users_id=t4.users_id
where t1.order_day>=trunc(sysdate-30)
  and t1.channel in('网站','手机')
  and t2.identify like '%特征%'
  -and t2.identify not like '%其他%'
  group by t1.order_day,t2.identify,t2.feature,t2.feature_id,t2.feature_value)h1;
  
  
 
---实时数据调整
 
select trunc(t.order_date) 订单日期,
case when t1.identify like 'troy' then 'troy'||'-'||t1.feature
  when t1.identify like '%特征%' and feature ='其他' then '算法'||'-'||t1.feature_value
  when t1.identify like '%特征%' and feature <>'其他' then '系统'||'-'||nvl(t1.feature_value,t2.feature_value)
  end,count(1),sum(count(1))over(partition by case when t1.identify like 'troy' then 'troy'||'-'||t1.feature
  when t1.identify like '%特征%' and feature ='其他' then '算法'||'-'||t1.feature_value
  when t1.identify like '%特征%' and feature <>'其他' then '系统'||'-'||nvl(t1.feature_value,t2.feature_value)
  end) tonum
from cqsale.cq_order@to_air t 
join cqsale.cq_order_head@to_air tt1 on t.flights_Order_id=tt1.flights_order_id
join dw.da_restrict_userinfo t1 on t.client_id=t1.users_id
left join cqsale.CQ_BLACK_FEATURE_RULE_DETAIL@to_air t2  on t2.feature_rule_id=regexp_substr(t1.feature,'[0-9]')
where t.terminal_id=-1
and t.web_id=0
and tt1.flag_id in(3,5,40,7,11,12)
and t.order_date>=trunc(sysdate-3)
/*and t1.identify not like '%特征%'
and t1.identify not like '%troy%'*/
group by trunc(t.order_date), case when t1.identify like 'troy' then 'troy'||'-'||t1.feature
  when t1.identify like '%特征%' and feature ='其他' then '算法'||'-'||t1.feature_value
  when t1.identify like '%特征%' and feature <>'其他' then '系统'||'-'||nvl(t1.feature_value,t2.feature_value)
  end

  
