

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
    
/*    �漰��Χ��IJ���ࡢ��������ƽ̨(APP\��վ\΢��\M��վ)     
    ����1: Ԥ����Ʊ������qq.com,������Ϊ6λ��д��ĸ
    ����2��Ԥ����������9λ��д��ĸ
    ����3��Ԥ������ϵ��ʽ��С�ڵ���8λ������,Ŀǰ�۲쵽��6-8λ��
    ����4���˻�������name ��5λ��д��ĸ
    
*/
    


    
