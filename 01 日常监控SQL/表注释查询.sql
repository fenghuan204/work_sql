select *
 from dba_tab_comments t1
 join dba_col_comments t2 on t1.owner=t2.owner and t1.table_name=t2.table_name
 where 
