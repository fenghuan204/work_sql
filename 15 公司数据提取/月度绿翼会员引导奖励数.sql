select h1.*,h2.cards_reward,h2.tickets_reward
from(
select  to_char(t1.check_date,'yyyymm') ÔÂ·Ý,
t1.check_origin,
       decode(t1.check_origin,1,'ÖÇ»Û¿Í²Õ',2,'HCC',3,'ÂÃ¿ÍË¢µÇ»úÅÆ',4,'B2B'),
--t1.users_id,
       SUBSTR(t1.air_crew, 1, INSTR(t1.air_crew, '/') - 1) V_USERS_ID,
       SUBSTR(air_crew,
              INSTR(air_crew, '/') + 1,
              INSTR(air_crew, '/', 1, 2) - INSTR(air_crew, '/', 1, 1) - 1) V_FIRST_DEPARTMENT,
       SUBSTR(air_crew,
              INSTR(air_crew, '/', 1, 2) + 1,
              INSTR(air_crew, '/', 1, 3) - INSTR(air_crew, '/', 1, 2) - 1) V_SECOND_DEPARTMENT,
       case
         when t1.CHECK_ORIGIN = 4 then
          SUBSTR(air_crew, INSTR(air_crew, '/', 1, 3) + 1)
         else
          SUBSTR(air_crew, INSTR(air_crew, '/', 1, 4) + 1)
       end V_USERS_NAME,  
       count(1) clientnum,
       sum(case when t4.users_id is not null then 1
      else 0 end) agentnum,
      0 ticketnum,
      0 agentticketnum
  from cust.cq_apply_lyhy@to_air t1
  left join dw.da_restrict_userinfo t4 on t1.users_id=t4.users_id
 where t1.check_date >= to_date('2019-07-01', 'yyyy-mm-dd')
   and t1.check_date <  to_date('2019-08-01', 'yyyy-mm-dd')
   and t1.flag = 2
   group by to_char(t1.check_date,'yyyymm'),
t1.check_origin,
       decode(t1.check_origin,1,'ÖÇ»Û¿Í²Õ',2,'HCC',3,'ÂÃ¿ÍË¢µÇ»úÅÆ',4,'B2B'),
--t1.users_id,
       SUBSTR(t1.air_crew, 1, INSTR(t1.air_crew, '/') - 1) ,
       SUBSTR(air_crew,
              INSTR(air_crew, '/') + 1,
              INSTR(air_crew, '/', 1, 2) - INSTR(air_crew, '/', 1, 1) - 1) ,
       SUBSTR(air_crew,
              INSTR(air_crew, '/', 1, 2) + 1,
              INSTR(air_crew, '/', 1, 3) - INSTR(air_crew, '/', 1, 2) - 1) ,
       case
         when t1.CHECK_ORIGIN = 4 then
          SUBSTR(air_crew, INSTR(air_crew, '/', 1, 3) + 1)
         else
          SUBSTR(air_crew, INSTR(air_crew, '/', 1, 4) + 1)
       end 
 
                    
     union all
                   
         




select  to_char(t1.order_date,'yyyymm'),
t1.check_origin,
       decode(t1.check_origin,1,'ÖÇ»Û¿Í²Õ',2,'HCC',3,'ÂÃ¿ÍË¢µÇ»úÅÆ',4,'B2B'),
--t1.users_id,
       SUBSTR(t1.air_crew, 1, INSTR(t1.air_crew, '/') - 1) V_USERS_ID,
       SUBSTR(air_crew,
              INSTR(air_crew, '/') + 1,
              INSTR(air_crew, '/', 1, 2) - INSTR(air_crew, '/', 1, 1) - 1) V_FIRST_DEPARTMENT,
       SUBSTR(air_crew,
              INSTR(air_crew, '/', 1, 2) + 1,
              INSTR(air_crew, '/', 1, 3) - INSTR(air_crew, '/', 1, 2) - 1) V_SECOND_DEPARTMENT,
       case
         when t1.CHECK_ORIGIN = 4 then
          SUBSTR(air_crew, INSTR(air_crew, '/', 1, 3) + 1)
         else
          SUBSTR(air_crew, INSTR(air_crew, '/', 1, 4) + 1)
       end V_USERS_NAME,
       --t1.order_date,
       --t1.check_date,
       --t1.check_card_type,
       --t1.check_card_no,  
       0,
       0,    
       count(1) Æ±Á¿,
       sum(case when t4.users_id is not null then 1
      else 0 end) ´úÀí¹ºÆ±Á¿
  from cust.cq_apply_lyhy@to_air t1
  join cqsale.cq_order_head@to_air t3 on t1.check_card_type = t3.codetype
                                     and t1.check_card_no = t3.codeno
  left join dw.da_restrict_userinfo t4 on t1.users_id=t4.users_id
 where t1.order_date >= to_date('2019-07-01', 'yyyy-mm-dd')
   and t1.order_date <  to_date('2019-08-01', 'yyyy-mm-dd')
   and t3.r_order_date > t1.check_date
   and t3.flag_Id  in(3,5,40)
   and t1.flag = 2
   and t1.order_flag = 1
   and trunc(t1.order_date) = trunc(t3.r_order_date)
 group by to_char(t1.order_date,'yyyymm'),
  t1.check_origin,
       decode(t1.check_origin,1,'ÖÇ»Û¿Í²Õ',2,'HCC',3,'ÂÃ¿ÍË¢µÇ»úÅÆ',4,'B2B'),
       SUBSTR(t1.air_crew, 1, INSTR(t1.air_crew, '/') - 1) ,
       SUBSTR(air_crew,
              INSTR(air_crew, '/') + 1,
              INSTR(air_crew, '/', 1, 2) - INSTR(air_crew, '/', 1, 1) - 1) ,
       SUBSTR(air_crew,
              INSTR(air_crew, '/', 1, 2) + 1,
              INSTR(air_crew, '/', 1, 3) - INSTR(air_crew, '/', 1, 2) - 1) ,
       case
         when t1.CHECK_ORIGIN = 4 then
          SUBSTR(air_crew, INSTR(air_crew, '/', 1, 3) + 1)
         else
          SUBSTR(air_crew, INSTR(air_crew, '/', 1, 4) + 1)
       end )h1
       left join stg.c_cq_lyhy_reward_rules h2 on h2.flag=1 and h1.check_origin=h2.check_origin
                    
