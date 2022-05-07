 SELECT
rownum 序号,
t.COLUMN_NAME 名称,
t.DATA_TYPE 类型,
t.DATA_LENGTH 长度,
t.NULLABLE 可为空,
t.DATA_DEFAULT 缺省值,
cmt.comments 描述
FROM USER_TAB_COLUMNS@to_air T
inner join user_col_comments@to_air cmt
on t.TABLE_NAME=cmt.table_name
and t.COLUMN_NAME=cmt.column_name
WHERE T.TABLE_NAME=upper('CQ_OTHER_ORDER');



select * from user_indexes@to_air where table_name=upper('CQ_OTHER_ORDER');


select a.uniqueness 索引类型,b.index_name 索引名称,b.column_name 字段 
from user_indexes@to_air a ,user_ind_columns@to_air b
where a.table_name=b.table_name and a.index_name = b.index_name 
--and a.table_owner=upper('ETL') 
and  a.table_name='CQ_OTHER_ORDER' order by a.uniqueness desc;
