--优惠券状态 0 未兑换 1 已兑换 2 已作废 3 已过期

select tb1.*,tb2.crm_succ,tb2.crm_fail,tb2.crm_canc
from(
select 
case
         when t1.start_time >= to_date('2018-11-01', 'yyyy-mm-dd') and
              t1.start_time < to_date('2019-04-17', 'yyyy-mm-dd') then
          1
         when t1.start_time >= to_date('2019-04-17', 'yyyy-mm-dd') and
              t1.start_time < to_date('2019-11-15', 'yyyy-mm-dd') then
          2
       
         when t1.start_time >= to_date('2019-11-15', 'yyyy-mm-dd') then
          3
       end 时间,
       
       t1.batch_no,
       t2.act_name,
       t1.activity_name,
       t2.total_num,
       t2.create_user,
       t2.create_date,
       t2.money_var,
       count(1) 生成量,
       sum(case
             when t1.expand_feild is not null then
              1
             when t1.quan_status = '1' then
              1
             else
              0
           end) 兑换量,
       t2.money_var * sum(case
                            when t1.expand_feild is not null then
                             1
                            when t1.quan_status = '1' then
                             1
                            else
                             0
                          end) 优惠金额
  from hdb.cms_yhq_create t1
  left join dw.bi_yhq_batch t2 on to_char(t1.batch_no) = to_char(t2.batch_id)
 where t1.start_time >= to_date('2018-11-01', 'yyyy-mm-dd')
   and nvl(t2.act_name, '-') like '%服务%'
 group by case
            when t1.start_time >= to_date('2018-11-01', 'yyyy-mm-dd') and
                 t1.start_time < to_date('2019-04-17', 'yyyy-mm-dd') then
             1
            when t1.start_time >= to_date('2019-04-17', 'yyyy-mm-dd') and
                 t1.start_time < to_date('2019-11-15', 'yyyy-mm-dd') then
             2
          
            when t1.start_time >= to_date('2019-11-15', 'yyyy-mm-dd') then
             3
          end,
          t1.batch_no,
          t2.act_name,
          t1.activity_name,
          t2.money_var,
              t2.total_num,
       t2.create_user,
       t2.create_date)tb1
       left join(select --trunc(sd.sendtime) dd,
              -- b.serve_depart,
               b.batch_id,
               sum(case
                     when sd.sendstatus = 'SendSuccess' then
                      1
                     else
                      0
                   end) crm_succ,
               sum(case
                     when sd.sendstatus = 'SendFail' then
                      1
                     else
                      0
                   end) crm_fail,
               sum(case
                     when sd.sendstatus = 'Cancle' then
                      1
                     else
                      0
                   end) crm_canc,
               0 gds,
               0 use1,
               0 fee1,
               0 use2,
               0 fee2
          from dw.bi_yhq_batch b
          join hdb.crm_ts_send_coupon_detail sd on sd.couponno = b.batch_id
         where b.serve_depart is not null --服务类优惠券          
         group by /*trunc(sd.sendtime), b.serve_depart, */b.batch_id)tb2 on tb1.batch_no=tb2.batch_id
          
          
          
 /*
 select *
  from  hdb.cms_yhq_create t1
  where t1.start_time>=to_date('2018-11-01','yyyy-mm-dd')
   and (t1.activity_name not like '%套票%'
   and  t1.activity_name not like '%想飞就飞%')
   and t1.quan_status='1'
   and t1.expand_feild is  null
 
 
 select 
  from dw.bi_yhq_batch
 
 select t1.batch_id,sum(t1.atv_num)
  from dw.bi_yhq_atv t1
  where t1.version='2'
  group by t1.batch_id 
  
  
  select * from dw.bi_yhq_use t1
  where t1.flights_order_id='UKWFHT'
  
   
   select distinct couponbatchno
   from hdb.crm_coupon_grant_detail t1
   left join dw.bi_
   
   select * 
   from hdb.crm_oc_complaindetail
  
   select t1.*
   from hdb.crm_coupon_grant_detail t1
   left  join yhq.CQ_NEW_YHQ_RELATION@to_air t2  on t1.userid=t2.users_id and t1.couponbatchno =t2.create_id and t1.updatetime=t2.create_date
   where t2.users_id is not null


  */
