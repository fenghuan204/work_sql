--IJ符合相关规则
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
  and regexp_like(t1.name,'^[A-Z]{5}$')
