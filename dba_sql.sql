--新增密码

select random_password('ulnasn') from dual;

--表注释查询
select * from dba_tab_comments  t1
where t1.comments like '%商务经济座%';

--表字段注释查询
SELECT * from dba_col_comments t2
where t2.comments like '%跳舱系数%'


--查找存储过程
select *
  from dba_source t1
  where lower(t1.text) like '%%';

--查找job

select *
   from dba_jobs
  where lower(what) like '%%';


---表注释/字段注释
select  *
   from dba_tab_comments t1
   join dba_col_comments  t2 on t1.table_name=t2.table_name
   where t1.comments like '%%'  ---表注释
   and t2.comments like '%%'  ---字段注释
   and t1.table_name like '%%';


---锁表

SELECT object_name, machine, s.sid, s.serial# ,s.SADDR,s.PADDR
FROM gv$locked_object l, dba_objects o, gv$session s
WHERE l.object_id= o.object_id 
AND l.session_id = s.sid;

---解锁相应的表

alter system kill session '24,111'; (其中24,111分别是上面查询出的sid,serial#)


---查询正在执行的sql

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





