
SELECT t1.factor,count(1),sum(tb1.ticketnum)
FROM hdb.wb_agent_rcd_factor T1
LEFT JOIN (SELECT t2.CLIENT_ID,count(1) ticketnum
              FROM stg.s_cq_order t2
              join stg.s_cq_order_head T3 on t2.flights_order_id=t3.flights_Order_id
              WHERE t2.order_date>=trunc(sysdate-60)
                and t3.flag_id =8
                group by t2.CLIENT_ID
)tb1 on t1.client_id=tb1.client_id
group by t1.factor;


select client_id
from (
SELECT t1.*,tb1.ticketnum cancelnum
FROM hdb.wb_agent_rcd_factor T1
LEFT JOIN (SELECT t2.CLIENT_ID,count(1) ticketnum
              FROM stg.s_cq_order t2
              join stg.s_cq_order_head T3 on t2.flights_order_id=t3.flights_Order_id
              WHERE t2.order_date>=trunc(sysdate-60)
                and t3.flag_id =8
                group by t2.CLIENT_ID
)tb1 on t1.client_id=tb1.client_id
order by nvl(tb1.ticketnum,0) desc)
where rownum<=3000

union 

select h1.*,null
from (
SELECT t1.*
FROM hdb.wb_agent_rcd_factor T1
order by t1.ticketnum)h1
where rownum<=2000;
              
              
