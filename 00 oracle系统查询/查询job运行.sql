--查询job运行

--1、存储过程运行问题

select id,
       sql_code,
       sql_errm,
       sql_text,
      /* sql_full,*/
       creation_date,
       (nvl(lag(creation_date, 1) over (order by id desc), SYSDATE) - creation_date) * 24 * 60 * 60 "EXECUTE_TIME(S)",
       levels,
       model_name
  from if.if_log_message
 where creation_date >= trunc(sysdate)
  and model_name <>'if_common_pkg.insert_sql_hist'
   AND LEVELS > 1
   AND lower(model_name)  LIKE '%pro_jianke_data%'
   and model_name not in('dw_bi_seckill','pro_dw_bi_call_center','BI_MONITOR_15MI','BI_MONITOR_PERHOUR','BI_MONITOR_10MI')
 order by id DESC;
 
 
 
 --2、系统中查询
 
 select * from dba_source
where lower(text) like '%pro_dw_bi_bigscreen_accudata%';


