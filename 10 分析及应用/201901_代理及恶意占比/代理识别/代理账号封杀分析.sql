select t1.order_day,
       case
         when t3.users_id is not null then
          '代理'
         else
          '非代理'
       end 是否代理,
       case
         when t3.users_id is not null and t2.client_id is not null and
              t1.order_day <= t2.create_date then
          '封杀前'
         when t3.users_id is not null and t2.client_id is not null and
              t1.order_day > t2.create_date then
          '封杀后'
         when t3.users_id is not null and t2.client_id is null and
              t4.reg_day >= trunc(sysdate - 60) then
          '新注册代理账号'
         when t3.users_id is not null and t2.client_id is null and
              t4.reg_day < trunc(sysdate - 60) and
              t4.reg_day >= trunc(sysdate - 365) then
          '1年内注册账号'
         when t3.users_id is not null and t2.client_id is null and
              t4.reg_day < trunc(sysdate - 365) then
          '1年前注册账号'
       end 注册类型,
       count(1) 票量,
       count(distinct t1.client_id) 账号数
  from dw.fact_order_detail t1
  join dw.da_flight t5 on t1.segment_head_id = t5.segment_head_id
  left join hdb.wb_agent_rcd t2 on t1.client_id = t2.client_id
  left join dw.da_restrict_userinfo t3 on t1.client_id = t3.users_id
  left join dw.da_b2c_user t4 on t3.users_id = t4.users_id
 where t1.order_day >= trunc(sysdate) - 60
   and t1.channel in ('网站', '手机')
   and t1.company_id = 0
   and t1.seats_name is not null
   and t5.flag <> 2
 group by t1.order_day,
          case
            when t3.users_id is not null then
             '代理'
            else
             '非代理'
          end,
          case
            when t3.users_id is not null and t2.client_id is not null and
                 t1.order_day <= t2.create_date then
             '封杀前'
            when t3.users_id is not null and t2.client_id is not null and
                 t1.order_day > t2.create_date then
             '封杀后'
            when t3.users_id is not null and t2.client_id is null and
                 t4.reg_day >= trunc(sysdate - 60) then
             '新注册代理账号'
            when t3.users_id is not null and t2.client_id is null and
                 t4.reg_day < trunc(sysdate - 60) and
                 t4.reg_day >= trunc(sysdate - 365) then
             '1年内注册账号'
            when t3.users_id is not null and t2.client_id is null and
                 t4.reg_day < trunc(sysdate - 365) then
             '1年前注册账号'
          end;
