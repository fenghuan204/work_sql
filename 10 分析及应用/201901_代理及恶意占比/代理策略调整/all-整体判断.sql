账号、注册时间、注册手机、注册邮箱、截止目前支付成功的机票数、支付成功的去重乘机人数、取消机票量、是否本人乘机记录、本人购票乘机数量、
第一次购票成功的时间，最近一次购票时间，购票信息中出现次数最多的订票人联系方式、购票信息中出现次数最多的邮箱、 购票信息中出现次数最多的乘机人联系方式、各联系方式对应成功机票量及取消机票量、
账号被识别的方式 (troy、特征库、其他）、识别方式对应的值


--找到目前所有的代理账号

/*账号、注册时间、注册手机、注册邮箱、截止目前支付成功的机票数、支付成功的去重乘机人数、取消机票量、是否本人乘机记录、本人购票乘机数量、
第一次购票成功的时间，最近一次购票时间，购票信息中出现次数最多的订票人联系方式、购票信息中出现次数最多的邮箱、 购票信息中出现次数最多的乘机人联系方式、各联系方式对应成功机票量及取消机票量、
账号被识别的方式 (troy、特征库、其他）、识别方式对应的值
*/

select
from(
select t1.users_id,t4.reg_date,t4.login_id,t4.email,t4.login_times,
       case when t6.cust_id is not null then 1
            else 0 end is_ly,
       t6.cust_id,
       t6.ly_login,
       t6.ly_email,
       t6.ly_codetype,
       t6.ly_codeno,
       t6.source_flag,
       t6.lydate,
       case when t1.identify like '%troy%' then 'troy'
            when t2.memo like '%troy%' then 'troy'
            when t1.identify like '%特征%' then '特征库'
            when t2.memo like '特征库' then '特征库'
            else t1.identify end 识别类型,
      case when t1.identify like '%troy%' then t1.feature
            when t2.memo like '%troy%' then split_part(split_part(t2.memo,',',2),'=',2)
            when t1.identify like '%特征%' then t1.feature_value
            when t2.memo like '特征库' then t7.feature_value
            else t1.feature end 识别值,
       case when t2.flag=4 then 4
       when t5.client_id is not null then 8
       else 6 end flag        
  from dw.da_restrict_userinfo t1
  left join cqsale.cq_user_restrict@to_air t2 on t1.users_id = t2.user_id
  left join (select client_id, memo
               from (select client_Id,
                            memo,
                            row_number() over(partition by client_id order by create_date desc) xid
                       from cqsale.cq_agent_banlist@to_air t3 where  t3.STATUS = 1)
              where xid = 1) t5 on t1.users_id = t5.client_id
  left join dw.da_b2c_user t4 on t1.users_id = t4.users_id
  left join (select *
  from
  (select  users_id_fk,cust_id,login_id ly_login,email ly_email,codetype ly_codetype,codeno ly_codeno,decode(source_flag,0,'线上',1,'线下') source_flag,reg_date lydate,
                      row_number()over(partition by users_id_fk order by reg_date desc) xid       
  	              from dw.da_lyuser)
  where xid=1)t6  on t1.users_id=t6.users_id_fk
  left join (select *
from(
select feature_rule_id,
       feature_id,
       feature_value,
       row_number() over(partition by feature_rule_id order by feature_id) xid
  from cqsale.CQ_BLACK_FEATURE_RULE_DETAIL@to_air)
  where xid=1) t7 on t2.memo like '%特征库%' and to_number(regexp_substr(split_part(t2.memo,',',2),'[1-9]+'))=t7.feature_rule_id)h1
left join (select client_id)


