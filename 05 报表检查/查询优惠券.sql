--查询优惠券的使用数据

select distinct table_name from dba_tab_columns t1
where table_name like '%YHQ%';




select h1.*
from(
select t1.users_id,
       t1.create_date 创建时间,
       t1.status 是否使用,
       t1.effective_date 有效期,
       case
         when t2.users_id is not null then
          '代理'
         else
          '非代理'
       end 代理与否,
       case
         when t4.user_id is not null then
          '封杀'
         else
          '未封杀'
       end banned,
       case when t6.cust_id is not null then '绿翼'
       else '非绿翼' end 是否绿翼,
       t2.identify 识别方式,
       t2.feature_value 识别特征值,
       t4.memo 识别备注,
       t5.batch_id,
       t5.act_name 活动名称,
       t5.user_type 活动类型,
       t5.money_type 优惠类型,
       t5.if_same_name,
       t5.yh_type,
       sum(t5.money_var) 优惠金额
  from yhq.cq_new_yhq_relation@to_air t1
  left join cqsale.cq_user_restrict@to_air t4 on t1.users_id = t4.user_id
                                             and t4.flag in (4, 5, 0)
  left join dw.da_restrict_userinfo t2 on t1.users_id = t2.users_id
  left join dw.bi_yhq_batch t5 on to_char(t1.create_id) = t5.batch_id
  left join dw.da_lyuser t6 on t1.users_id=t6.users_id_fk
 where t1.create_date >= trunc(sysdate - 7)
   and t2.users_id is not null
 group by t1.users_id,
          t1.create_date,
          t1.status,
          t1.effective_date,
          case
            when t2.users_id is not null then
             '代理'
            else
             '非代理'
          end,
          case
            when t4.user_id is not null then
             '封杀'
            else
             '未封杀'
          end,
          t2.identify,
          t2.feature_value,
          t4.memo,
          t5.batch_id,
          t5.act_name,
          t5.user_type,
          t5.if_same_name,
          t5.yh_type,
          t5.money_type,
          case when t6.cust_id is not null then '绿翼'
       else '非绿翼' end)h1
       where h1.banned='未封杀'





select distinct t1.users_id,t1.create_date,t1.effective_date,case when t2.users_id is not null then '代理'
else '非代理' end,t2.identify,t2.feature_value,t3.login_pwd,t3.email,split_part(t3.email,'@',2) email2,
t3.login_id,
t3.reg_date,
t3.register_ip
from yhq.cq_new_yhq_relation@to_air t1
left join cqsale.cq_user_restrict@to_air t4 on t1.users_id=t4.user_id and t4.flag in(4,5)
left join dw.da_restrict_userinfo t2 on t1.users_id=t2.users_id
left join stg.c_cq_flights_users t3 on t1.users_id=t3.users_id
where  t1.create_id='5669'
and (t2.users_id is not null
and t4.user_id is not null)




select t.client_id,h1.batch_id,h1.use_date,trunc(h1.use_date),h1.use_money,case when t2.users_id is not null then '代理'
else '非代理' end/*,
case when t3.user_id is not null then '被封杀'
else '未被封杀' end*/
from dw.bi_yhq_use h1
join stg.s_cq_order t on h1.flights_order_id=t.flights_Order_id
left join dw.da_restrict_userinfo t2 on t.client_id=t2.users_id
--left join cqsale.cq_user_restrict@to_air t3 on t.client_id=t3.user_id and t3.flag in(4,5)
where h1.use_date>=trunc(sysdate-30)
and t.order_date>=trunc(sysdate-30)
and h1.batch_id='5669'



select count(distinct t1.users_id),count(distinct t4.user_id)
from yhq.cq_new_yhq_relation@to_air t1
left join cqsale.cq_user_restrict@to_air t4 on t1.users_id=t4.user_id and t4.flag in(4,5)
left join dw.da_restrict_userinfo t2 on t1.users_id=t2.users_id
left join stg.c_cq_flights_users t3 on t1.users_id=t3.users_id
where  t1.create_id='5669';





