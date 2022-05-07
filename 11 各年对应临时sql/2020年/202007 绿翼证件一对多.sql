---多证件一对多关系
select distinct h1.user_id,h1.sname,h1.code_no,h2.code_no codeno2
     from (
      select t3.user_id,t3.custid,t3.fam_name_en||coalesce(t3.per_name_en,'') sname,code_no
      from  stg.c_cq_cust_code t3 
      where t3.status =9
    )h1
      left join( select t3.user_id,t3.custid,t3.fam_name_en||coalesce(t3.per_name_en,'') sname,code_no
      from  stg.c_cq_cust_code t3 
      where t3.status in(1,9)
   )h2 on h1.user_id=h2.user_id and h1.custid=h2.custid and h1.sname=h2.sname
