select count(distinct t1.flights_order_id)
from dw.fact_order_detail t1
left join dw.da_restrict_userinfo t2 on t1.client_id=t2.users_id
where t1.company_id=0
and t1.order_day>=trunc(sysdate-7)
and t1.order_day< trunc(sysdate)
and t1.channel in('网站','手机')
and t2.users_id is null
and t1.is_swj=0
and t1.ex_cfd2 is null

----3092

---69117

select count(distinct t1.flights_order_id),sum(t1.book_num),sum(t1.book_fee)
from dw.fact_other_order_detail t1
left join dw.da_restrict_userinfo t2 on t1.client_id=t2.users_id
where t1.company_id=0
and t1.order_day>=trunc(sysdate-7)
and t1.order_day< trunc(sysdate)
and t1.xtype_id in(6,10,17,7)
and t1.channel in('网站','手机')
and t1.pay_together=0
and t2.users_id is null
and t1.is_swj=0
and t1.ex_cfd2 is null 

--and t1.seats_name not in('B','G','G1','G2')
--and t2.users_id is null
--and t1.pay_together=0


