select trunc(t.order_date) 订单日期,
case when t1.identify like 'troy' then 'troy'||'-'||t1.feature
  when t1.identify like '%特征%' and feature ='其他' then '算法'||'-'||t1.feature_value
  when t1.identify like '%特征%' and feature <>'其他' then '系统'||'-'||nvl(t1.feature_value,t2.feature_value)
  end 识别类型,t.client_id,t1.identify,t1.feature,t1.feature_value,t1.mobile,t1.email,t2.cust_id
from cqsale.cq_order@to_air t
join cqsale.cq_order_head@to_air tt1 on t.flights_Order_id=tt1.flights_order_id
join dw.da_restrict_userinfo t1 on t.client_id=t1.users_id
left join dw.da_lyuser t2 on t.client_Id=t2.users_id_fk
left join cqsale.CQ_BLACK_FEATURE_RULE_DETAIL@to_air t2  on t2.feature_rule_id=regexp_substr(t1.feature,'[0-9]')
where t.terminal_id=-1
and t.web_id=0
and tt1.whole_flight like '9C%'
and not regexp_like(t1.identify,'(troy)|(特征)')
and tt1.flag_id in(3,5,40,7,11,12)
and t.order_date>=trunc(sysdate-7)
and t.client_id not in(4108997,3474386,20625985,42276852);


/*select trunc(t.order_date) 订单日期,
case when t1.identify like '%troy%' then 'troy-'||t1.feature
 when t1.identify like '%特征%' then '特征-'||t1.feature_value
 else '其他-'||t1.feature_value end,
count(1)
from cqsale.cq_order@to_air t 
join cqsale.cq_order_head@to_air tt1 on t.flights_Order_id=tt1.flights_order_id
join dw.da_restrict_userinfo t1 on t.client_id=t1.users_id
left join cqsale.cq_user_restrict@to_air t2 on t.client_id=t2.user_id
where t.terminal_id=-1
and t.web_id=0
and tt1.whole_flight like '9C%'
and tt1.flag_id in(3,5,40,7,11,12)
and t.order_date>=trunc(sysdate)
group by trunc(t.order_date),
case when t1.identify like '%troy%' then 'troy-'||t1.feature
 when t1.identify like '%特征%' then '特征-'||t1.feature_value
 else '其他-'||t1.feature_value end
*/
