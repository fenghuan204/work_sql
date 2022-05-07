select t1.cust_Id,trunc(create_date) 日期,case when t1.authentication_scenario='wxMP' then '平台实名认证通道'
else authentication_scenario end  场景,
decode(t1.AUTHENTICATION_METHODS,'2','支付宝','3','微信') 认证方式 ,
decode(t1.change_from,1,'网站',2,'M网站',3,'IOS',4,'Android',5,'微信公众号',10,'微信小程序',11,'机上wifi')  转化渠道
from cqsale.cq_users_huiyuan_change@to_air t1
where t1.cust_id in('998644532024','998644532658')
