select t1.dt,decode(t1.event,1,'注册',2,'登录',3,'领券',4,'下单',5,'取消订单',6,'完成订单',7,'查询航班动态',8,'查询航班',9,'浏览搜索页',10,'评论',11,'短信通道保护',12,'二次辅收自动注册',
13,'浏览航班详情',14,'绿翼亲友接入',15,'绿翼亲友下单',16,'发起邀请',17,'做任务') 事件,
decode(t1.risklevel,0,'PASS',1,'review',2,'reject',3,'verify') risklevel,
  decode(t1.risktype,0,'未知',1,'虚假账号',2,'盗号撞库',3,'积分墙账号',4,'正常',6,'积分墙',7,'机器控制',8,
  '恶意占座',9,'套利') 风控标签, decode(t1.handle,0,'不处理',1,'消息弹框',2,'验证码',3,'二次实名认证') 处理措施
  ,decode(t2.ifsuccess,1,'拦截成功','未拦截成功') 拦截与否,
  decode(t1.terminal,0,'PC',1,'PC',2,'M网站',3,'安卓',4,'IOS',6,'小程序') 渠道,
  count(distinct t1.id) 事件量
 from hdb.hive_log_shumei_record t1
 left join hdb.hive_log_shumei_record t2 on t1.id=t2.id and t2.event is null and t2.ifsuccess=1
 where t1.event is not null
 group by   t1.dt,decode(t1.event,1,'注册',2,'登录',3,'领券',4,'下单',5,'取消订单',6,'完成订单',7,'查询航班动态',8,'查询航班',9,'浏览搜索页',10,'评论',11,'短信通道保护',12,'二次辅收自动注册',
13,'浏览航班详情',14,'绿翼亲友接入',15,'绿翼亲友下单',16,'发起邀请',17,'做任务') ,
 t1.risklevel,t1.risktype,t1.handle,t2.ifsuccess,decode(t1.terminal,0,'PC',1,'PC',2,'M网站',3,'安卓',4,'IOS',6,'小程序');
  
 select t1.dt,decode(t1.event,1,'注册',2,'登录',3,'领券',4,'下单',5,'取消订单',6,'完成订单',7,'查询航班动态',8,'查询航班',9,'浏览搜索页',10,'评论',11,'短信通道保护',12,'二次辅收自动注册',
13,'浏览航班详情',14,'绿翼亲友接入',15,'绿翼亲友下单',16,'发起邀请',17,'做任务')  事件,
 decode(t1.risklevel,0,'PASS',1,'review',2,'reject',3,'verify') risklevel,
  decode(t1.risktype,0,'未知',1,'虚假账号',2,'盗号撞库',3,'积分墙账号',4,'正常',6,'积分墙',7,'机器控制',8,
  '恶意占座',9,'套利') 风控标签, decode(t1.handle,0,'不处理',1,'消息弹框',2,'验证码',3,'二次实名认证') 处理措施,decode(t2.ifsuccess,1,'拦截成功','未拦截') 拦截与否,
  decode(t1.terminal,0,'PC',1,'PC',2,'M网站',3,'安卓',4,'IOS',6,'小程序') 渠道,
  count(distinct t1.id) 事件量
 from hdb.hive_log_shumei_record t1
 left join hdb.hive_log_shumei_record t2 on t1.id=t2.id and t2.event is null and t2.ifsuccess=1
 where t1.event is not null
 and t1.event=4
 and t1.createtime>='2022-05-13 10:30:00'
 and t1.createtime<='2022-05-14 18:00:00'
 group by   t1.dt,decode(t1.event,1,'注册',2,'登录',3,'领券',4,'下单',5,'取消订单',6,'完成订单',7,'查询航班动态',8,'查询航班',9,'浏览搜索页',10,'评论',11,'短信通道保护',12,'二次辅收自动注册',
13,'浏览航班详情',14,'绿翼亲友接入',15,'绿翼亲友下单',16,'发起邀请',17,'做任务') ,
 t1.risklevel,t1.risktype,t1.handle,t2.ifsuccess,decode(t1.terminal,0,'PC',1,'PC',2,'M网站',3,'安卓',4,'IOS',6,'小程序') 
 
 
 