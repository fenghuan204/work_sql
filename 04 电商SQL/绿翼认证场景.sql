select t1.cust_Id,trunc(create_date) ����,case when t1.authentication_scenario='wxMP' then 'ƽ̨ʵ����֤ͨ��'
else authentication_scenario end  ����,
decode(t1.AUTHENTICATION_METHODS,'2','֧����','3','΢��') ��֤��ʽ ,
decode(t1.change_from,1,'��վ',2,'M��վ',3,'IOS',4,'Android',5,'΢�Ź��ں�',10,'΢��С����',11,'����wifi')  ת������
from cqsale.cq_users_huiyuan_change@to_air t1
where t1.cust_id in('998644532024','998644532658')
