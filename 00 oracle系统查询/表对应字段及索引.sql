 SELECT
rownum ���,
t.COLUMN_NAME ����,
t.DATA_TYPE ����,
t.DATA_LENGTH ����,
t.NULLABLE ��Ϊ��,
t.DATA_DEFAULT ȱʡֵ,
cmt.comments ����
FROM USER_TAB_COLUMNS@to_air T
inner join user_col_comments@to_air cmt
on t.TABLE_NAME=cmt.table_name
and t.COLUMN_NAME=cmt.column_name
WHERE T.TABLE_NAME=upper('CQ_OTHER_ORDER');



select * from user_indexes@to_air where table_name=upper('CQ_OTHER_ORDER');


select a.uniqueness ��������,b.index_name ��������,b.column_name �ֶ� 
from user_indexes@to_air a ,user_ind_columns@to_air b
where a.table_name=b.table_name and a.index_name = b.index_name 
--and a.table_owner=upper('ETL') 
and  a.table_name='CQ_OTHER_ORDER' order by a.uniqueness desc;
