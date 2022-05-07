select t1.order_day,case when t1.channel in('手机','网站') and t3.users_id is not null  then '线上自有平台代理'
when t1.channel in('手机','网站') and t2.flag in(4,5) then '线上自有平台代理'
when t1.channel in('手机','网站') and t3.users_id is not null   then '线上自有平台代理'
     when t1.channel in('手机','网站')  then '线上自有平台纯量'
     when t1.channel in('OTA','旗舰店') then 'OTA旗舰店'
     when t1.channel ='B2B代理' then 'B2B代理'
     else '线下自有平台' end,count(1)
from dw.fact_order_detail t1
left join dw.da_restrict_userinfo t3 on t1.client_id=t3.users_id
left join cqsale.cq_user_restrict@TO_AIR T2 ON T1.CLIENT_ID=T2.USER_ID
WHERE t1.order_day>=trunc(sysdate-7)
 and t1.order_day< trunc(sysdate)
 and t1.company_id=0
 and t1.seats_name is not NULL
   and t1.seats_name not in('B','G','G1','G2','O')
   and t1.company_id=0
   group by t1.order_day,case when t1.channel in('手机','网站') and t3.users_id is not null  then '线上自有平台代理'
when t1.channel in('手机','网站') and t2.flag in(4,5) then '线上自有平台代理'
when t1.channel in('手机','网站') and t3.users_id is not null   then '线上自有平台代理'
     when t1.channel in('手机','网站')  then '线上自有平台纯量'
     when t1.channel in('OTA','旗舰店') then 'OTA旗舰店'
     when t1.channel ='B2B代理' then 'B2B代理'
     else '线下自有平台' end
