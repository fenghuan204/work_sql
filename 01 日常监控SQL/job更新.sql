select *
from(
select id,
       sql_code,
       sql_errm,
       sql_text,
      /* sql_full,*/
       creation_date,
       (nvl(lag(creation_date, 1) over (partition by  model_name order by id desc), SYSDATE) - creation_date) * 24 * 60 * 60 EXECUTE_TIME,
       levels,
       model_name
  from if.if_log_message
 where creation_date >= trunc(sysdate)-1
  and creation_date< trunc(sysdate)
  and model_name <>'if_common_pkg.insert_sql_hist'
  AND LEVELS > =1
  --and model_name ='pro_everyday_fact_table'
 --and lower(model_name)  like '%if_common_pkg%' 
  --and lower(sql_text) like '%da_b2c_user%'
   /* and lower(model_name) not in('dw_bi_seckill','pro_dw_bi_call_center','bi_monitor_15mi','bi_monitor_perhour','bi_monitor_10mi',
   'dw_bi_secmonitor','pro_dw_bi_aftertoday_kucun','pro_bi_message_alter','pro_dw_realtime_sale_kuncun')
   and model_name not in('bi_monitor_halfhour','pro_bi_cancel_today','pro_hdb_wb_flightinfo_all','dw_fr_tables.pro_fr_segment_income_predict2',
   'dw_fr_tables.pro_fr_sy_monitor','pro_comb_price','pro_bi_black_monitor','pro_bi_segment_id_plan_remnant','if_framework_rebuild.if_char_modify_detail',
   'if_regular_pkg.cqsale_to_stg','pro_wb_flight_subsidy','pro_everyday_fact_table','bi_luggage_detail','pro_dw_crm_xproduct_marketing',
   'hdb.mid_insur_combine')*/
   --and sql_text like '%bi_week_sales%'
   --and model_name in('pro_dw_bi_route_summary_1')
 order by id)
 where EXECUTE_TIME>=500
 and  sql_text not like '%OK%'
 and  sql_text not like '%END%'
 and sql_text not like '%START%'
 and model_name ='dw_da_user';
 
select id,
       sql_code,
       sql_errm,
       sql_text,
      /* sql_full,*/
       creation_date,
       (nvl(lag(creation_date, 1) over (partition by  model_name order by id desc), SYSDATE) - creation_date) * 24 * 60 * 60 EXECUTE_TIME,
       levels,
       model_name
  from if.if_log_message
 where creation_date >= trunc(sysdate)
  and creation_date< trunc(sysdate)+1
  and model_name <>'if_common_pkg.insert_sql_hist'
  AND LEVELS > =1
  --and model_name like '%dw_da_user%'
  order by id desc;
  
  
  
  
  SELECT b.sid oracleID,  
       b.username 登录Oracle用户名,  
       b.serial#,  
       spid 操作系统ID,  
       paddr,  
       sql_text 正在执行的SQL,  
       b.machine 计算机名  
FROM v$process a, v$session b, v$sqlarea c  
WHERE a.addr = b.paddr  
   AND b.sql_hash_value = c.hash_value;


