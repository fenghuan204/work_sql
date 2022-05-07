select distinct id||','
  from dw.bi_sms_batch t1
  where name like '%718套票%'
   and createtime>=to_date('2020-07-15','yyyy-mm-dd')
 union all
  select distinct id||','
  from dw.bi_sms_batch t1
  where name like '%会员短信-OTA绿翼会%'
   and createtime>=to_date('2020-07-15','yyyy-mm-dd')
  
