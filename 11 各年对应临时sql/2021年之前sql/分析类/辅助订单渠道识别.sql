select trunc(t.order_date) 辅助订单日期,t.channel_id,t.terminal_id,t.ext_1,t.ex_nfd1,sum(t1.book_num) 数量,sum(t1.book_num*t1.book_price*t1.r_com_rate) 金额
from cqsale.cq_other_order@to_air t
join cqsale.cq_other_order_head@to_air t1 on t.order_id=t1.order_id
where t.pay_together=1
and t.r_company_id=0
and t1.flag_id in(3,5,40)
and t.terminal_id=-1
and t.ext_1=0
and t.ex_nfd1 in(0,3)
and t.order_date>=to_date('2017-08-01','yyyy-mm-dd')
and t.order_date< to_date('2017-08-02','yyyy-mm-dd')
group by trunc(t.order_date) ,t.channel_id,t.terminal_id,t.ext_1,t.ex_nfd1;


select trunc(t.order_date),t.ex_nfd1,case when t3.terminal_id>0 then 'B2B'
when t3.web_id>0 then '代理'
when t3.terminal_id<0 and t3.ex_nfd1=1 then '网站'
when t3.terminal_id<0 and t3.ex_nfd1=2 then 'M网站'
when t3.terminal_id<0 and t3.ex_nfd1=3 then 'IOS'
when t3.terminal_id<0 and t3.ex_nfd1=4 then 'Andriod'
when t3.terminal_id<0 and t3.ex_nfd1=5 then '微信' end,sum(t1.book_num)
from cqsale.cq_other_order@to_air t
join cqsale.cq_other_order_head@to_air t1 on t.order_id=t1.order_id
join cqsale.cq_order@to_air t3 on t.flights_order_id=t3.flights_Order_id
join cqsale.cq_terminal@to_air t4 on t3.terminal_id=t4.terminal_id
where t.pay_together=1
and t.r_company_id=0
and t1.flag_id in(3,5,40)
and t.terminal_id=-1
and t.ext_1=0
and t.ex_nfd1 in(0,3)
and t.order_date>=to_date('2017-08-01','yyyy-mm-dd')
and t.order_date< to_date('2017-08-30','yyyy-mm-dd')
group by trunc(t.order_date),t.ex_nfd1,case when t3.terminal_id>0 then 'B2B'
when t3.web_id>0 then '代理'
when t3.terminal_id<0 and t3.ex_nfd1=1 then '网站'
when t3.terminal_id<0 and t3.ex_nfd1=2 then 'M网站'
when t3.terminal_id<0 and t3.ex_nfd1=3 then 'IOS'
when t3.terminal_id<0 and t3.ex_nfd1=4 then 'Andriod'
when t3.terminal_id<0 and t3.ex_nfd1=5 then '微信' end
