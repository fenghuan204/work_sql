select h1.source,case when h3.users_id is not null then '1'
else '0' end,count(1),COUNT(DISTINCT H2.FLIGHTS_ORDER_id)
from(
select distinct t2.userid,t2.orderid,t2.SOURCE
 from dw.fact_cms_ch_item_remark t1
 join dw.fact_cms_remark t2 on t1.remarkid=t2.remarkid
 where t1.created>=trunc(sysdate)-30
 and t1.channel in('0','6'))h1
 left join DW.FACT_OTHER_ORDER_DETAIL H2 ON H1.ORDERID=H2.FLIGHTS_ORDER_ID AND H2.XTYPE_ID=7
 left join dw.da_restrict_userinfo@to_ods h3 on h1.userid=to_char(h3.users_id)
 group by h1.source,case when h3.users_id is not null then '1'
else '0' end

 

 
