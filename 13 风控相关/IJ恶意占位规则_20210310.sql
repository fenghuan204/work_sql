--IJ������ع���
�漰��Χ��IJ���ࡢ��������ƽ̨(APP\��վ\΢��\M��վ)     
    ����1: Ԥ����Ʊ������qq.com,������Ϊ6λ��д��ĸ
    ����2��Ԥ����������9λ��д��ĸ
    ����3��Ԥ������ϵ��ʽ��С�ڵ���8λ������,Ŀǰ�۲쵽��6-8λ��
    ����4���˻�������name ��5λ��д��ĸ

select distinct t.flights_order_id,split_part(t.email,'@',1) ������,length(split_part(t.email,'@',1)) ����������,
split_part(t.email,'@',2) ��������,t.order_linkman ��Ʊ������,length(t.order_linkman) ��Ʊ����������,
t.work_tel ��Ʊ����ϵ��ʽ,length(t.work_tel) ��Ʊ����ϵ��ʽ����,t1.name �˻���,length(t1.name) �˻�����������
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
