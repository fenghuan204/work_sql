/*
��Ʊ���ǳ˻��˵��жϱ�׼��������������Ʊ�ĳ˻���
1����Ʊ�˵�ע����Ϣ�ͳ˻�����Ϣһ��
������Ʊ�˵�֤���źͳ˻���֤����һ��
������Ʊ�˵������ͳ˻�������һ��
3����Ʊ�˵�ע���ֻ��źͳ˻�����ϵ�绰һ���Ҷ�Ʊ��ע�������ͳ˻�������һ��
3����Ʊ�˵�ע���ֻ��źͳ˻�����ϵ�绰һ���Ҷ�Ʊ��Ԥ�������ͳ˻�������һ��
2�� 



*/


select 
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  left join dw.da_b2c_user t3 on t1.client_id=t3.users_id
  left join dw.da_lyuser t4 on t3.users_id=t4.users_id_fk
  where t1.flights_date>=to_date('2016-11-01','yyyy-mm-dd')
    and t1.flights_date< to_date('2017-11-01','yyyy-mm-dd')
    and t2.flag<>2
    and t1.company_id=0
    
