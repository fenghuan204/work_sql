select distinct id||','
  from dw.bi_sms_batch t1
  where name like '%718��Ʊ%'
   and createtime>=to_date('2020-07-15','yyyy-mm-dd')
 union all
  select distinct id||','
  from dw.bi_sms_batch t1
  where name like '%��Ա����-OTA�����%'
   and createtime>=to_date('2020-07-15','yyyy-mm-dd')
  
