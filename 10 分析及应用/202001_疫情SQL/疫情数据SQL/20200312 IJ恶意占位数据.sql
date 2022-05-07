--IJ恶意占位

涉及范围：IJ航班、线上自有平台(APP\网站\微信\M网站)     
    规则1: 预留订票邮箱是qq.com,邮箱名为6位大写字母
    规则2：预订人姓名是9位大写字母
    规则3：预订人联系方式是小于等于8位纯数字,目前观察到（6-8位）
    规则4：乘机人姓名name 是5位大写字母

select t5.flag,t.client_id,t.work_tel,t.email,t.order_date,t1.flag_id,t1.r_tel,case when t.terminal_id<0 and t.web_id=0 then '线上自有'
when t.terminal_id<0 and t.web_id>0 then 'OTA'
else '其他' end 渠道,t4.email,t4.login_id,t4.reg_date,t4.EX_NFD2,t.remote_ip,t4.register_ip,t.ex_nfd1,t4.memo,
t4.login_pwd,t.order_linkman,t1.name
  from cqsale.cq_order@to_air t
  join cqsale.cq_order_head@to_air t1 on t1.flights_order_id=t.flights_Order_Id
    left join cust.cq_flights_users@to_air t4 on t.client_id=t4.users_id
    left join cqsale.cq_user_restrict@to_air t5 on t.client_Id=t5.user_id
  where t1.flights_order_id in('VKSSJU','VKSSIT','VKSSIK','VKSSGX','VKSSGF','VKSSFT','VKSSET','VKSNVH',
'VKSNUB','VKSNRM','VKSNRB','VKSNQW','VKSNOH','VKSNNZ','VKSNNP','VKSNNG',
 'VKSNMW','VKSNMG','VKSNLZ','VKSNLA','VKSNKT','VKSNKM',
 'VKSNJB','VKSNIX','VKSNIP','VKSNGW','VKSNEC','VKSNDQ','VKSNDL',
 'VKTAZR','VKTAZN','VKTBAN','VKTBAS','VKTBBH','VKTBBI','VKTBBX','VKTBBS','VKTBCD','VKTBCX','VKTBDO',     'VKTBDV',    'VKTBDR',    'VKTBEA',
    'VKTBEV',    'VKTBFB',    'VKTBFG',    'VKTBFW',    'VKTBGB',    'VKTBGP',    'VKTBGV',    'VKTBHY',    'VKTBIB',   'VKTBIW',
 'VKTBJI',   'VKTBJR',    'VKTBJT',    'VKTBKG',
 'VKTBKV',    'VKTBLP',    'VKTBLR',    'VKTBMF',
  'VKTBMS',    'VKTBOM',    'VKTBOV',    'VKTBOZ',  'VKTBSL',
  
  'VKTKSE','VKTKMB','VKTKLI','VKTKLF','VKTKKQ','VKTKKL','VKTKJF','VKTKHB','VKTKHA','VKTKGM','VKTKGA','VKTKEN','VKTKEC','VKTKDO',
'VKTKDN','VKTJYS','VKTJXV','VKTJXQ','VKTJWU','VKTJWG','VKTJWE','VKTJVD','VKUDVA','VKUDVD','VKUDVF','VKUDVL','VKUDVN','VKUDVP',
'VKUDVT','VKUDWC','VKUDWN','VKUDYG','VKUDYK','VKUDYT','VKUDZE','VKUEBA','VKUDZI','VKUEBA','VKUEBB','VKUEBC','VKUEBN','VKUEBI',
'VKUEBO','VKUEBS','VKUEBV','VKUEDR','VKUEDU','VKUEED','VKUEEA','VKUEEJ','VKUEEQ','VKUEEZ','VKUEGK','VKUEGU','VKUEGP','VKUEGX',
'VKUEHE','VKUEHL','VKUEIS','VKUEJA','VKUEJO','VKUEJU','VKUELM','VKUEMP','VKUENW','VKUEMQ','VKUEOA','VKUEOE','VKUEOS',
'VKUVNA','VKUVNS','VKUVOD','VKUVOW',
'VKUVWT','VKUWNB',
'VKUWUX','VKUWVS',
'VKUWYT','VKUXAB',
'VKUXIN','VKUXIT',
'VKUXJX','VKUXOW','VKUXRD',
'VKUXWV','VKUXXC','VKUXZC',
'VKUYFB','VKUYWH',
'VKUYYY','VKUZMT'

'VKXWRE','VKXWQF','VKXWHI','VKYAFS','VKYAEL','VKYABG','VKYAAE','VKXZWZ','VKXZVP');



===================是否符合相关规则============



涉及范围：IJ航班、线上自有平台(APP\网站\微信\M网站)     
    规则1: 预留订票邮箱是qq.com,邮箱名为6位大写字母
    规则2：预订人姓名是9位大写字母
    规则3：预订人联系方式是小于等于8位纯数字,目前观察到（6-8位）
    规则4：乘机人姓名name 是5位大写字母

select distinct t.flights_order_id,split_part(t.email,'@',1) 邮箱名,length(split_part(t.email,'@',1)) 邮箱名长度,
split_part(t.email,'@',2) 邮箱域名,t.order_linkman 订票人姓名,length(t.order_linkman) 订票人姓名长度,
t.work_tel 订票人联系方式,length(t.work_tel) 订票人联系方式长度,t1.name 乘机人,length(t1.name) 乘机人姓名长度
  from cqsale.cq_order@to_air t
  join cqsale.cq_order_head@to_air t1 on t1.flights_order_id=t.flights_Order_Id
  left join cust.cq_flights_users@to_air t4 on t.client_id=t4.users_id
  left join cqsale.cq_user_restrict@to_air t5 on t.client_Id=t5.user_id
  where t.order_date>=trunc(sysdate)
  and t.flights_order_id in('VKYAFS','VKYAEL','VKYABG','VKYAAE','VKXZWZ','VKXZVP')
  and split_part(t.email,'@',2)='qq.com'
  and regexp_like(split_part(t.email,'@',1),'^[A-Z]{6}$')
  and length(split_part(t.email,'@',1))=6
  and regexp_like(t.order_linkman,'^[A-Z]{9}$')
  and regexp_like(t.work_tel,'^[0-9]{1,8}$')
  and regexp_like(t1.name,'^[A-Z]{5}$');
  
  
  
 =======查询代理
 
 
 select t.flights_order_id,t5.flag,t.client_id,t.work_tel,t.email,t.order_date,t1.flag_id,t1.r_tel,case when t.terminal_id<0 and t.web_id=0 then '线上自有'
when t.terminal_id<0 and t.web_id>0 then 'OTA'
else '其他' end 渠道,t4.email 注册邮箱,t4.login_id,t4.reg_date,t4.EX_NFD2,t.remote_ip,t4.register_ip,t.ex_nfd1,t4.memo,
t4.login_pwd,t.order_linkman,t1.name
  from cqsale.cq_order@to_air t
  join cqsale.cq_order_head@to_air t1 on t1.flights_order_id=t.flights_Order_Id
    left join cust.cq_flights_users@to_air t4 on t.client_id=t4.users_id
    left join cqsale.cq_user_restrict@to_air t5 on t.client_Id=t5.user_id
  where t1.flights_order_id in('VKYAFS','VKYAEL','VKYABG','VKYAAE','VKXZWZ','VKXZVP');
  
  