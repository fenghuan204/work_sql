select trunc(t.order_date) 订单日期,c.terminal 渠道,/*case when t1.flag_id in(3,5,40,41) then 1
when t1.flag_id in(7,11,12) then 2
else 0 end 机票状态,*/count(distinct t1.flights_order_head_id) 机票量,sum(t2.DISCOUNT_AMOUNT) 优惠金额,sum(t2.PRICE_DISCOUNT_AMOUNT) 机票立减额
from cqsale.cq_order@to_air t
join cqsale.cq_Order_head@to_air t1 on t.flights_Order_id=t1.flights_Order_id
join cqsale.CQ_INSURANCE_DISCOUNT_HISTORY@to_air t2 on t1.flights_order_head_id=t2.order_head_id 
 left join dw.da_channel_part c on c.terminal_id = t.terminal_id
                                and c.web_id = nvl(t.web_id, 0)
                                and c.station_id =
                                    (case when t.terminal_id < 0 and
                                     nvl(t.ex_nfd1, 0) <= 1 then 1 else
                                     nvl(t.ex_nfd1, 0) end)
                                and t.order_date >= c.sdate
                                and t.order_date < c.edate + 2
where t.order_date>=trunc(sysdate-1)
and t2.type=1
and t1.flag_id in(3,5,40,41)
group by trunc(t.order_date),c.terminal/*,case when t1.flag_id in(3,5,40,41) then 1
when t1.flag_id in(7,11,12) then 2
else 0 end
*/




select h1.orderday,h1.booknum1,h1.firstnum,h1.booknum,h2.num1,h2.ticketnum,h3.num,h3.fee
from(
select trunc(t1.order_date) orderday,sum(case when t1.PAY_TOGETHER=0 then t2.book_num
else 0 end) firstnum,sum(case when t1.PAY_TOGETHER=0 and t3.EX_CFD10 is not null then 0
when t1.PAY_TOGETHER=0 and t3.ex_nfd3 is not null and t3.ex_cfd2 is not null then 0 
when t1.PAY_TOGETHER=0 then  t2.book_num 
else 0 end) booknum1, 
count(1) booknum
from cqsale.cq_other_order@to_air t1
JOIN cqsale.cq_other_order_head@to_air t2 on t1.order_id=t2.order_id
left join cqsale.cq_order_head@to_air t3 on t2.order_head_id=t3.flights_order_head_id
where t1.order_date>=trunc(sysdate-3)
and t2.ex_nfd1=1
and t2.flag_id in(3,5,40,41)
and t1.terminal_id=-1
and t1.ext_1=0
--and t1.ex_nfd1=5
group by trunc(t1.order_date))h1
left join(select trunc(t1.order_date) orderday,
sum(case when t2.EX_CFD10 is not null then 0
when t2.ex_nfd3 is not null and t2.ex_cfd2 is not null then 0 
else 1 end) num1, 
count(1) ticketnum
from cqsale.cq_order@to_air t1
JOIN cqsale.cq_order_head@to_air t2 on t1.flights_order_id=t2.flights_order_id
where t1.order_date>=trunc(sysdate-3)
and t2.flag_id in(3,5,40,41)
and t1.terminal_id=-1
and t1.web_id=0
and t1.ex_nfd1=5
and t2.whole_flight like '9C%'
group by trunc(t1.order_date))h2 on h1.orderday=h2.orderday

left join(
select trunc(t.order_date) orderday,count(distinct t1.flights_order_head_id) num,sum(t2.DISCOUNT_AMOUNT) fee
from cqsale.cq_order@to_air t
join cqsale.cq_Order_head@to_air t1 on t.flights_Order_id=t1.flights_Order_id
join cqsale.CQ_INSURANCE_DISCOUNT_HISTORY@to_air t2 on t1.flights_order_head_id=t2.order_head_id 
where t.order_date>=trunc(sysdate-2)
and t2.type=1
and t1.flag_id in(3,5,40,41)
and t.terminal_id=-1
and t.web_id=0
and t.ex_nfd1=5
group by trunc(t.order_date))h3 on h1.orderday=h3.orderday;




select h2.orderday 订单日期,
       decode(h2.ex_nfd1,1,'网站',2,'M站',3,'IOS',4,'Andriod',5,'微信') 渠道,
       h2.num1 普通座销量,
       h2.ticketnum 总体销量,
       h2.num2 纯量普通座销量,
       h2.ticketnum2 纯量销量,
       h1.booknum1  普通座一次数量,
       h1.firstnum  一次数量,
       h1.booknum  总购险数量,
       h3.num 保险立减数量,
       h3.fee 保险立减金额
  from (select trunc(t1.order_date) orderday,t1.ex_nfd1,
                    sum(case
                          when t2.EX_CFD10 is not null then
                           0
                          when t2.ex_nfd3 is not null and t2.ex_cfd2 is not null then
                           0
                          else
                           1
                        end) num1,                    
                    count(1) ticketnum,
                    sum(case
                          when t2.EX_CFD10 is not null then
                           0
                          when t2.ex_nfd3 is not null and t2.ex_cfd2 is not null then
                           0
                          when t3.users_id is null then 1
                          else 0                                                   
                        end) num2,                    
                    sum(case when t3.users_id is not null then 0 else 1 end) ticketnum2                 
                   
               from cqsale.cq_order@to_air t1
               JOIN cqsale.cq_order_head@to_air t2 on t1.flights_order_id =
                                                      t2.flights_order_id
              left join dw.da_restrict_userinfo t3 on t1.client_id=t3.users_id
              where t1.order_date >= trunc(sysdate - 3)
                and t2.flag_id in (3, 5, 40, 41)
                and t1.terminal_id = -1
                and t1.web_id = 0
               -- and t1.ex_nfd1 = 5
                and t2.whole_flight like '9C%'
              group by trunc(t1.order_date),t1.ex_nfd1) h2 
  left join (select trunc(t1.order_date) orderday,t1.ex_nfd1,
               sum(case
                     when t1.PAY_TOGETHER = 0 then
                      t2.book_num
                     else
                      0
                   end) firstnum,
               sum(case
                     when t1.PAY_TOGETHER = 0 and t3.EX_CFD10 is not null then
                      0
                     when t1.PAY_TOGETHER = 0 and t3.ex_nfd3 is not null and
                          t3.ex_cfd2 is not null then
                      0
                     when t1.PAY_TOGETHER = 0 then
                      t2.book_num
                     else
                      0
                   end) booknum1,
               count(1) booknum
          from cqsale.cq_other_order@to_air t1
          JOIN cqsale.cq_other_order_head@to_air t2 on t1.order_id =
                                                       t2.order_id
          left join cqsale.cq_order_head@to_air t3 on t2.order_head_id =
                                                      t3.flights_order_head_id
         where t1.order_date >= trunc(sysdate - 3)
           and t2.ex_nfd1 = 1
           and t2.flag_id in (3, 5, 40, 41)
           and t1.terminal_id = -1
           and t1.ext_1 = 0
        --and t1.ex_nfd1=5
         group by trunc(t1.order_date),t1.ex_nfd1) h1  on h1.orderday = h2.orderday and h1.ex_nfd1=h2.ex_nfd1
  left join (select trunc(t.order_date) orderday,t.ex_nfd1,
                    count(distinct t1.flights_order_head_id) num,
                    sum(t2.DISCOUNT_AMOUNT) fee
               from cqsale.cq_order@to_air t
               join cqsale.cq_Order_head@to_air t1 on t.flights_Order_id =
                                                      t1.flights_Order_id
               join cqsale.CQ_INSURANCE_DISCOUNT_HISTORY@to_air t2 on t1.flights_order_head_id =
                                                                      t2.order_head_id
              where t.order_date >= trunc(sysdate - 3)
                and t2.type = 1
                and t1.flag_id in (3, 5, 40, 41)
                and t.terminal_id = -1
                and t.web_id = 0
               -- and t.ex_nfd1 = 5
              group by trunc(t.order_date),t.ex_nfd1) h3 on h1.orderday = h3.orderday and h1.ex_nfd1=h3.ex_nfd1



