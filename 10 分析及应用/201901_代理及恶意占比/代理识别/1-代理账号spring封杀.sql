select * from hdb.temp_feng_0425 t1
where rownum<=2000;



select * 
from hdb.wb_agent_rcd_factor t1
where rownum<=2000;



select distinct t.client_id||','
from cqsale.cq_order@to_air  t
join cqsale.cq_order_head@to_air t1 on t.flights_order_id=t1.flights_order_id
left join cqsale.cq_user_restrict@to_air t2 on t.client_id=t2.user_id
where t1.r_tel in('15641132016')
and nvl(t2.flag,6)>=6
and t.client_id>0
and t.order_date>=trunc(sysdate-3)
and t.terminal_id=-1
and t.web_id=0
AND ROWNUM<=3000;



select distinct t.client_id||','
from cqsale.cq_order@to_air  t
join cqsale.cq_order_head@to_air t1 on t.flights_order_id=t1.flights_order_id
left join cqsale.cq_user_restrict@to_air t2 on t.client_id=t2.user_id
where t.work_tel in('15641132016')
and nvl(t2.flag,6)>=6
and t.client_id>0
and t.order_date>=trunc(sysdate-3)
and t.terminal_id=-1
and t.web_id=0
AND ROWNUM<=3000;



---??ѯ????ɱ?˺? (????δʶ?𵽵?????ֵ)

select t1.work_tel,t1.flag,t1.agentflag,case when t3.user_id is not null then '??ɱ'
else 'δ??ɱ' end banned,
case when t2.feature_id is not null then 1 else 0 end ?Ƿ?????,count(1)
from hdb.mid_agent_select_cancel t1
left join cqsale.CQ_BLACK_FEATURE_RULE_DETAIL@to_air t2 on t1.work_tel=t2.feature_value
left join cqsale.cq_user_restrict@to_air t3 on t1.client_id=t3.user_id and t3.flag in(4,5)
where t1.feature is null
group by t1.work_tel,t1.flag,t1.agentflag,case when t3.user_id is not null then '??ɱ'
else 'δ??ɱ' end,case when t2.feature_id is not null then 1 else 0 end;

--?????????˺? memo:cancel-batch

select distinct t1.client_id||','
from hdb.mid_agent_select_cancel t1
