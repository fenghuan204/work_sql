select *
 from dba_tab_comments@to_air
 where comments like '%ºÚÃûµ¥%'
 
 select *
  from cqsale.CQ_BLACK_AGENT_PHONE@to_air
  where tel='13636326467';
  
 
 select *
  from cqsale.CQ_MOBILE_NO_SMS@to_air
  where mobile='13636326467';
  
  
  select *
   from cust.CQ_PHONE_BLACKLIST@to_air
   where phone_no='13636326467';
  
  
 select t1.*
  from stg.s_cq_user_restrict t1
  left join dw.da_b2c_user t2 on t1.user_id=t2.users_id
  where t2.login_id='13636326467'
   
   select *
    from dw.fact_mobile_statistics t1
    where mobile='13636326467'
