select case   when TRUNC(t1.PROCESS_TIME)>=to_date('2016-11-01','yyyy-mm-dd')
  and TRUNC(t1.PROCESS_TIME)< to_date('2017-11-01','yyyy-mm-dd') then '2017����'
   when TRUNC(t1.PROCESS_TIME)>=to_date('2017-11-01','yyyy-mm-dd')
  and TRUNC(t1.PROCESS_TIME)< to_date('2018-11-01','yyyy-mm-dd') then '2018����' end ���,
  to_char(t1.PROCESS_TIME,'yyyymm') �·�,
  
t2.name �ڲ�ϵͳ,t3.name ��������,decode(t1.SMS_PLATFORM,1,'��������',2,'����ͨ',5,'����',6,'ѶԽ',
7,'����',8,'��Ѷ',9,'����ͨ',t1.SMS_PLATFORM) ����ƽ̨,count(1) ������,nvl(sum(t1.fact_sms_count),count(1)) ��������
  from stg.s_tb_sms_down_his t1
  LEFT JOIN STG.S_TB_SMS_SYS_FLAG T2 ON T1.SYS_FLAG=T2.ID
  LEFT JOIN STG.S_TB_SMS_TYPE T3 ON T1.REF_ID1=T3.ID
  WHERE TRUNC(t1.PROCESS_TIME)>=to_date('2016-11-01','yyyy-mm-dd')
  and TRUNC(t1.PROCESS_TIME)< to_date('2018-11-01','yyyy-mm-dd')
  and t1.STATUS=3
  group by case   when TRUNC(t1.PROCESS_TIME)>=to_date('2016-11-01','yyyy-mm-dd')
  and TRUNC(t1.PROCESS_TIME)< to_date('2017-11-01','yyyy-mm-dd') then '2017����'
   when TRUNC(t1.PROCESS_TIME)>=to_date('2017-11-01','yyyy-mm-dd')
  and TRUNC(t1.PROCESS_TIME)< to_date('2018-11-01','yyyy-mm-dd') then '2018����' end ,
  to_char(t1.PROCESS_TIME,'yyyymm'),t2.name,t3.name,decode(t1.SMS_PLATFORM,1,'��������',2,'����ͨ',5,'����',6,'ѶԽ',
7,'����',8,'��Ѷ',9,'����ͨ',t1.SMS_PLATFORM);
