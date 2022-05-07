select * from dw.job_197_input t1
where jid='Job20190108100908';



select * from dw.job_103_input t1
where jid='Job20190108100908';


select t1.*,t2.comments
from dba_col_comments t1
join dba_tab_comments t2 on t1.owner||t1.table_name=t2.owner||t2.table_name
where t1.comments like '%Ö¤¼þ%'
and t1.owner IN('CQSALE','CQRM','CUST')
