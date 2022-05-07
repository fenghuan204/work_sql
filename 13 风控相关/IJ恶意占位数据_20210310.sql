

select split_part(t.email,'@',1),split_part(t.email,'@',2),t.order_linkman,t.work_tel,t1.name
  from cqsale.cq_order@to_air t
  join cqsale.cq_order_head@to_air t1 on t1.flights_order_id=t.flights_Order_Id
  left join cust.cq_flights_users@to_air t4 on t.client_id=t4.users_id
  left join cqsale.cq_user_restrict@to_air t5 on t.client_Id=t5.user_id
  where t.order_date>=trunc(sysdate)
    and lower(t.email) like '%@qq.com'
    and regexp_like(split_part(t.email,'@',1),'[a-zA-Z]+')
    and getmobile(t.work_tel)='-'
    and t1.whole_flight like 'IJ%'
    and nvl(t5.flag,0)=0
    and t.terminal_id<0
    and t.web_id=0
    
/*    涉及范围：IJ航班、线上自有平台(APP\网站\微信\M网站)     
    规则1: 预留订票邮箱是qq.com,邮箱名为6位大写字母
    规则2：预订人姓名是9位大写字母
    规则3：预订人联系方式是小于等于8位纯数字,目前观察到（6-8位）
    规则4：乘机人姓名name 是5位大写字母
    
*/
    


    
