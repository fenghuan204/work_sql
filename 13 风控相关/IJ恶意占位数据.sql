select t1.flights_order_id ������,t1.order_date ��������,t1.client_id||',' ��ԱID,
t3.login_id,t1.work_tel ��Ʊ����ϵ��ʽ,t3.login_id �˺�ע���ֻ���,
t1.email ��Ʊ������ ,t1.order_linkman ��Ʊ������,t1.remote_ip �µ�IP,t2.name �˿�����,t2.second_name,t2.r_flights_date ��������,t2.whole_flight �����,
t2.whole_segment ����,t2.ticket_price*t2.r_com_rate Ʊ����,t2.r_tel �˻�����ϵ��ʽ,t3.reg_date �˺�ע������,t3.email �˺�������Ϣ,
t3.register_ip ע��IP,t3.last_login_ip �����¼IP,t3.login_pwd,t1.EX_CFD4 ����
from cqsale.cq_order@to_air t1
join cqsale.cq_order_head@to_air t2 on t1.flights_order_id=t2.flights_order_id
left join cust.cq_flights_users@to_air t3 on t1.client_id=t3.users_id
where t1.order_date>=trunc(sysdate)-1
--and t1.email in('hshbdjj@163.com','588546697@qq.com','hebdbsj@163.com','fvjkmng@163.com','haolinjia@163.com')
and t1.flights_order_id in('XCSTGJ','XCSTID','XCTBTH','XCTBYB','XCTIBG')
