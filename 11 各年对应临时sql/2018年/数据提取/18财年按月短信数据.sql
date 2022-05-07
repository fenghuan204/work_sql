select case   when TRUNC(t1.PROCESS_TIME)>=to_date('2016-11-01','yyyy-mm-dd')
  and TRUNC(t1.PROCESS_TIME)< to_date('2017-11-01','yyyy-mm-dd') then '2017财年'
   when TRUNC(t1.PROCESS_TIME)>=to_date('2017-11-01','yyyy-mm-dd')
  and TRUNC(t1.PROCESS_TIME)< to_date('2018-11-01','yyyy-mm-dd') then '2018财年' end 年度,
  to_char(t1.PROCESS_TIME,'yyyymm') 月份,
  
t2.name 内部系统,t3.name 发送类型,decode(t1.SMS_PLATFORM,1,'东方般若',2,'满意通',5,'哈朵',6,'讯越',
7,'亿美',8,'佳讯',9,'大汉三通',t1.SMS_PLATFORM) 发送平台,count(1) 发送数,nvl(sum(t1.fact_sms_count),count(1)) 发送条数
  from stg.s_tb_sms_down_his t1
  LEFT JOIN STG.S_TB_SMS_SYS_FLAG T2 ON T1.SYS_FLAG=T2.ID
  LEFT JOIN STG.S_TB_SMS_TYPE T3 ON T1.REF_ID1=T3.ID
  WHERE TRUNC(t1.PROCESS_TIME)>=to_date('2016-11-01','yyyy-mm-dd')
  and TRUNC(t1.PROCESS_TIME)< to_date('2018-11-01','yyyy-mm-dd')
  and t1.STATUS=3
  group by case   when TRUNC(t1.PROCESS_TIME)>=to_date('2016-11-01','yyyy-mm-dd')
  and TRUNC(t1.PROCESS_TIME)< to_date('2017-11-01','yyyy-mm-dd') then '2017财年'
   when TRUNC(t1.PROCESS_TIME)>=to_date('2017-11-01','yyyy-mm-dd')
  and TRUNC(t1.PROCESS_TIME)< to_date('2018-11-01','yyyy-mm-dd') then '2018财年' end ,
  to_char(t1.PROCESS_TIME,'yyyymm'),t2.name,t3.name,decode(t1.SMS_PLATFORM,1,'东方般若',2,'满意通',5,'哈朵',6,'讯越',
7,'亿美',8,'佳讯',9,'大汉三通',t1.SMS_PLATFORM);
