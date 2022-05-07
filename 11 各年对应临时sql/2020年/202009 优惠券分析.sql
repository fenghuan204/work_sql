select to_char(h1.create_date,'yyyy') 年,to_char(h1.create_date,'mm') 月,
       h1.batch_id 批次号,
       h1.act_name 券名称,
       decode(h1.status,1,'已审核',2,'作废','未审核') 状态,
       case
         when regexp_like(h1.act_name, '(点评)') then
          '点评'
         when regexp_like(h1.act_name, '(服管部)|(服务)') then
          '服务赔偿券'
         else '运营营销券'  end 券类型,
       h1.MONEY_TYPE 优惠类型,      
       h1.user_type 是否限制绿翼,
       h1.if_same_name 是否限制本人,
       sum(h1.total_num) 发送量,
       sum(h1.total_num*h1.money_var) 发送金额,
       sum(h2.atv_num) 领券量,
       sum(h2.atv_money) 领券金额,
       sum(h2.use_qnum) 用券量,
       sum(h2.use_money) 用券金额
  from  dw.bi_yhq_batch h1
 left join(
 select batch_id,sum(atv_num) atv_num,sum(atv_money) atv_money,
                 sum(use_qnum) use_qnum,sum(use_money) use_money
 from (select t1.batch_id,
               sum(t1.atv_num) atv_num,
               sum(t1.atv_num*t2.money_var) atv_money,
               null use_qnum,
               null use_money
          from dw.bi_yhq_atv t1
          join dw.bi_yhq_batch t2 on t1.version=t2.version and t1.batch_id=t2.batch_id
         where t1.atv_day >= to_date('2017-01-01', 'yyyy-mm-dd')
           and t1.company_id = 0
           and t1.version = 2
         group by  t1.batch_id

        union all

        select t1.batch_id,
               null,
               null atv_num,
               count(distinct t1.yhq_id) use_qnum,
               sum(t1.use_money) use_money
          from dw.bi_yhq_use t1
         where t1.company_id = 0
           and trunc(use_date) >= to_date('2017-01-01', 'yyyy-mm-dd')
           and t1.version = 2
           and t1.flag = 1
         group by t1.batch_id)
         group by batch_id)h2 on h1.batch_id=h2.batch_id
         where h1.version=2
         and h1.create_date>=to_date('2017-01-01','yyyy-mm-dd')
         and h2.atv_num>0
         and not regexp_like(h1.act_name,'(套票)|(免票)|(test)|(测试)')
         and h1.batch_id not in('1127', '1128', '1129', '1130','1134','1135','1136','1137','1138','9933','9948',
         '9949','9971','10009','10010')
         group by to_char(h1.create_date,'yyyy'),to_char(h1.create_date,'mm'),
       h1.batch_id ,
       h1.act_name ,
       case
         when regexp_like(h1.act_name, '(点评)') then
          '点评'
         when regexp_like(h1.act_name, '(服管部)|(服务)') then
          '服务赔偿券'
         else '运营营销券'  end ,
       h1.MONEY_TYPE ,
       h1.user_type ,
       h1.if_same_name,
       decode(h1.status,1,'已审核',2,'作废','未审核');
       
    
 
---使用优惠券的数据


select to_char(h2.use_date,'yyyy') 年,to_char(h2.use_date,'mm') 月,
       h1.batch_id 批次号,
       h1.act_name 券名称,
       decode(h1.status,1,'已审核',2,'作废','未审核') 状态,
       case
         when regexp_like(h1.act_name, '(点评)') then
          '点评'
         when regexp_like(h1.act_name, '(服管部)|(服务)') then
          '服务赔偿券'
         else '运营营销券'  end 券类型,
       h1.MONEY_TYPE 优惠类型,
       h1.user_type 是否限制绿翼,
       h1.if_same_name 是否限制本人,      
       sum(h2.use_qnum) 用券量,
       sum(h2.use_money) 用券金额
  from  dw.bi_yhq_batch h1                          
  join( select trunc(t1.use_date) use_date,
        t1.batch_id,
               null,
               null atv_num,
               count(distinct t1.yhq_id) use_qnum,
               sum(t1.use_money) use_money
          from dw.bi_yhq_use t1
         where t1.company_id = 0
           and trunc(use_date) >= to_date('2017-01-01', 'yyyy-mm-dd')
           and t1.version = 2
           and t1.flag = 1
         group by trunc(t1.use_date),t1.batch_id)h2 on h1.batch_id=h2.batch_id
         where h1.version=2
         and h1.create_date>=to_date('2017-01-01','yyyy-mm-dd')
         --and h2.atv_num>0
         and not regexp_like(h1.act_name,'(套票)|(免票)|(test)|(测试)')
         and h1.batch_id not in('1127', '1128', '1129', '1130','1134','1135','1136','1137','1138','9933','9948',
         '9949','9971','10009','10010')
         group by to_char(h2.use_date,'yyyy'),to_char(h2.use_date,'mm'),
       h1.batch_id ,
       h1.act_name ,
       case
         when regexp_like(h1.act_name, '(点评)') then
          '点评'
         when regexp_like(h1.act_name, '(服管部)|(服务)') then
          '服务赔偿券'
         else '运营营销券'  end ,
       h1.MONEY_TYPE ,
       h1.user_type ,
       h1.if_same_name,
       decode(h1.status,1,'已审核',2,'作废','未审核');
       
      
  
       
----增加优惠金额


select to_char(h1.create_date,'yyyy') 年,to_char(h1.create_date,'mm') 月,
       h1.batch_id 批次号,
       h1.act_name 券名称,
       h1.money_var,
       h1.flights_date_e1-h1.flights_date_b1 有效期,
       h1.yh_type,
       decode(h1.status,1,'已审核',2,'作废','未审核') 状态,
       case
         when regexp_like(h1.act_name, '(点评)') then
          '点评'
         when regexp_like(h1.act_name, '(服管部)|(服务)') then
          '服务赔偿券'
         else '运营营销券'  end 券类型,
       h1.MONEY_TYPE 优惠类型,
       case when h1.money_var/h1.full_money<=0.1 then '满足金额减少于10%'
            when h1.money_var/h1.full_money>=0.9 then '无门槛'
            else '条件适当' end  优惠幅度,
       h1.user_type 是否限制绿翼,
       h1.if_same_name 是否限制本人,
       sum(h1.total_num) 发送量,
       sum(h1.total_num*h1.money_var) 发送金额,
       sum(h2.atv_num) 领券量,
       sum(h2.atv_money) 领券金额,
       sum(h2.use_qnum) 用券量,
       sum(h2.use_money) 用券金额
  from  dw.bi_yhq_batch h1
 left join(
 select batch_id,sum(atv_num) atv_num,sum(atv_money) atv_money,
                 sum(use_qnum) use_qnum,sum(use_money) use_money
 from (select t1.batch_id,
               sum(t1.atv_num) atv_num,
               sum(t1.atv_num*t2.money_var) atv_money,
               null use_qnum,
               null use_money
          from dw.bi_yhq_atv t1
          join dw.bi_yhq_batch t2 on t1.version=t2.version and t1.batch_id=t2.batch_id
         where t1.atv_day >= to_date('2017-01-01', 'yyyy-mm-dd')
           and t1.company_id = 0
           and t1.version = 2
         group by  t1.batch_id

        union all

        select t1.batch_id,
               null,
               null atv_num,
               count(distinct t1.yhq_id) use_qnum,
               sum(t1.use_money) use_money
          from dw.bi_yhq_use t1
         where t1.company_id = 0
           and trunc(use_date) >= to_date('2017-01-01', 'yyyy-mm-dd')
           and t1.version = 2
           and t1.flag = 1
         group by t1.batch_id)
         group by batch_id)h2 on h1.batch_id=h2.batch_id
         where h1.version=2
         and h1.create_date>=to_date('2017-01-01','yyyy-mm-dd')
         and h2.atv_num>0
         and not regexp_like(h1.act_name,'(套票)|(免票)|(test)|(测试)')
         and h1.batch_id not in('1127', '1128', '1129', '1130','1134','1135','1136','1137','1138','9933','9948',
         '9949','9971','10009','10010')
         group by to_char(h1.create_date,'yyyy'),to_char(h1.create_date,'mm'),
       h1.batch_id ,
       h1.act_name ,
       h1.money_var,
       case
         when regexp_like(h1.act_name, '(点评)') then
          '点评'
         when regexp_like(h1.act_name, '(服管部)|(服务)') then
          '服务赔偿券'
         else '运营营销券'  end ,
       h1.MONEY_TYPE ,
       h1.user_type ,
       h1.if_same_name,
       decode(h1.status,1,'已审核',2,'作废','未审核'),
       h1.flights_date_e1-h1.flights_date_b1,
        h1.yh_type;
        
        
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
											
