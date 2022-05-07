---短信梳理
select t2.name 内部系统,t3.name 发送类型,decode(t1.SMS_PLATFORM,1,'东方般若',2,'满意通',5,'哈朵',6,'讯越',
7,'亿美',8,'佳讯',9,'大汉三通',t1.SMS_PLATFORM) 发送平台,count(1),nvl(sum(t1.fact_sms_count),count(1))
  from stg.s_tb_sms_down_his t1
  LEFT JOIN STG.S_TB_SMS_SYS_FLAG T2 ON T1.SYS_FLAG=T2.ID
  LEFT JOIN STG.S_TB_SMS_TYPE T3 ON T1.REF_ID1=T3.ID
  WHERE TRUNC(t1.PROCESS_TIME)>=to_date('2018-11-01','yyyy-mm-dd')
  and TRUNC(t1.PROCESS_TIME)< to_date('2018-12-01','yyyy-mm-dd')
  and t1.STATUS=3 
  group by t2.name ,t3.name ,decode(t1.SMS_PLATFORM,1,'东方般若',2,'满意通',5,'哈朵',6,'讯越',
7,'亿美',8,'佳讯',9,'大汉三通',t1.SMS_PLATFORM) 



select 
t2.name 内部系统,t3.name 发送类型,decode(t1.SMS_PLATFORM,1,'东方般若',2,'满意通',5,'哈朵',6,'讯越',
7,'亿美',8,'佳讯',9,'大汉三通',t1.SMS_PLATFORM) 发送平台,t1.content,t1.fact_sms_count
--count(1),sum(t1.fact_sms_count)
  from stg.s_tb_sms_down_his t1
  LEFT JOIN STG.S_TB_SMS_SYS_FLAG T2 ON T1.SYS_FLAG=T2.ID
  LEFT JOIN STG.S_TB_SMS_TYPE T3 ON T1.REF_ID1=T3.ID
  WHERE TRUNC(t1.PROCESS_TIME)>=to_date('2018-11-01','yyyy-mm-dd')
  and TRUNC(t1.PROCESS_TIME)< to_date('2018-12-01','yyyy-mm-dd')
  and t1.STATUS=3 
  and t2.name ='航空销售业务系统'
  and t3.name='促销短信'
  and t1.content  not  like '%停止办理登机牌%'
  and t1.content not like '%无免费托运行李额%'
  and t1.content not like '%机票退改%'
  and t1.content not like '%停止办理值机手续%'
  and t1.content not like '%航班已出票%'
  and t1.content not like '%行李%'
  and t1.content not like '%办理值机%'
  and t1.content not like '%办理登机%'；
  
  
  
  
select 
t2.name 内部系统,t3.name 发送类型,decode(t1.SMS_PLATFORM,1,'东方般若',2,'满意通',5,'哈朵',6,'讯越',
7,'亿美',8,'佳讯',9,'大汉三通',t1.SMS_PLATFORM) 发送平台,t1.content,t1.fact_sms_count

--count(1),sum(t1.fact_sms_count)
  from stg.s_tb_sms_down_his t1
  LEFT JOIN STG.S_TB_SMS_SYS_FLAG T2 ON T1.SYS_FLAG=T2.ID
  LEFT JOIN STG.S_TB_SMS_TYPE T3 ON T1.REF_ID1=T3.ID
  WHERE TRUNC(t1.PROCESS_TIME)>=to_date('2018-11-01','yyyy-mm-dd')
  and TRUNC(t1.PROCESS_TIME)< to_date('2018-12-01','yyyy-mm-dd')
  and t1.STATUS=3 
  and t2.name ='航空B2C'
  and t3.name='不正常航班提醒'
  and t1.content  not  like '%春秋很抱歉通知您,因公司计划原因,您乘坐%'
and t1.content  not like '%尊敬的旅客:因冬春时刻调整,您乘坐的%'
and t1.content not like '%航班因机场关闭预计延误至当地时间%'
and t1.content not like '%尊敬的旅客:因机场关闭,您乘坐的%'
and t1.content not like '%尊敬的旅客:因天气原因,您乘坐的%'




select 
t2.name 内部系统,t3.name 发送类型,decode(t1.SMS_PLATFORM,1,'东方般若',2,'满意通',5,'哈朵',6,'讯越',
7,'亿美',8,'佳讯',9,'大汉三通',t1.SMS_PLATFORM) 发送平台,t1.content,t1.fact_sms_count

select count(1),sum(t1.fact_sms_count)
  from stg.s_tb_sms_down_his t1
  LEFT JOIN STG.S_TB_SMS_SYS_FLAG T2 ON T1.SYS_FLAG=T2.ID
  LEFT JOIN STG.S_TB_SMS_TYPE T3 ON T1.REF_ID1=T3.ID
  WHERE TRUNC(t1.PROCESS_TIME)>=to_date('2018-11-01','yyyy-mm-dd')
  and TRUNC(t1.PROCESS_TIME)< to_date('2018-12-01','yyyy-mm-dd')
  and t1.STATUS=3 
  and t2.name ='航空销售业务系统'
  and t3.name is null
  and t1.content    not like '%办理值机，请提前至%'
  and t1.content not like '%请尽快办理登机牌立即排队过安检%'
    and t1.content   not  like '%春秋航空服务总监邀您在此%'
 and t1.content   like '%给您造成的不便深表歉意%'
  and t1.content not like '%航班登机口变更至%';
  
  
  
  
  
