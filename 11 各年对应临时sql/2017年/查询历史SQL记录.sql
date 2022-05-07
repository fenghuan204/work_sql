  SELECT c.username,
         a.program,
         a.machine,
         b.sql_text,
         b.command_type,
         a.sample_time
    FROM dba_hist_active_sess_history a
         JOIN dba_hist_sqltext b
            ON a.sql_id = b.sql_id
         JOIN dba_users c
            ON a.user_id = c.user_id
   WHERE     a.sample_time BETWEEN SYSDATE - 3 AND SYSDATE
         AND b.command_type =3
         and sql_text like '%dba_hist_active_sess_history%'
ORDER BY a.sample_time DESC;



select * from v$sqlarea t 
where sql_fulltext like '%dba_hist_active_sess_history%'
 order by t.LAST_ACTIVE_TIME desc;
