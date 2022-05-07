truncate table dw.adt_yhq_batchtoji;
    
insert into dw.adt_yhq_batchtoji
        select /*+parallel(4) */
        t.batch_id, --批次号,
               t.user_flag, ---是否代理,
               tt.all_users, ---领取人数,
               tt.atv_num2 atv_num, --发放券量,
               sum(t.yhq_NUM) yhq_NUM, --使用优惠券数量,
               sum(t.yhq_money) yhq_money, --优惠券总面值,
               sum(t.use_money) use_money, --实际优惠金额,
               sum(t.tickets) tickets, --机票量,
               sum(t.clients) clients, --用券会员数,
               sum(t.orders) orders, --订单量,
               sum(t.ticketfee) ticketfee, --机票金额,
               sum(t.xfee) xfee, --辅收金额,
               sum(t.allsale) allsale, --总营收
               sysdate
          from (select t3.batch_id,
                       null ATV_NUM,
                       case
                         when t6.users_id is not null then
                          '代理'
                         else
                          '非代理'
                       end user_flag,
                       count(distinct t3.yhq_id) yhq_NUM ,
                       sum(t3.yhq_money) yhq_money,
                       sum(t3.use_money) use_money,
                       count(distinct t3.flights_order_head_id) tickets,
                       count(distinct t3.USERS_ID) clients,
                       count(distinct t3.FLIGHTS_ORDER_ID) orders,
                       sum(nvl(t4.ticket_price,0)+nvl(t5.book_fee,0)) ticketfee,
                       sum(nvl(t4.other_fee,0) +nvl(t4.insurce_fee,0)+nvl(t5.book_fee,0)) xfee,
                       sum(nvl(t4.ticket_price,0) + nvl(t4.ad_fy,0) + nvl(t4.port_pay,0) +
                           nvl(t4.other_fy,0) + nvl(t4.other_fee,0) + nvl(t4.insurce_fee,0)+nvl(t5.book_fee,0)) allsale
                  from  dw.bi_yhq_use t3
                  left join  dw.fact_order_detail t4 on t3.flights_order_head_id =t4.flights_order_head_id and t3.flights_Order_id=t4.flights_Order_id
                  left join  dw.fact_other_order_detail t5  on t3.flights_order_head_id=t5.flights_Order_head_id and t3.flights_order_id=t5.order_id
                  and t5.other_order_head_id=t3.other_order_head_id
                  left join dw.da_b2c_user t5 on t5.users_id = t3.USERS_ID
                  left join dw.da_lyuser t7 on t7.users_id_fk = t3.USERS_ID
                  left join if.v_da_restrict_userinfo t6 on t6.users_id =t3.USERS_ID
                 where t4.order_day >= to_date('2018-01-01', 'yyyy-mm-dd')
                   and t4.order_day < trunc(sysdate)
                   and t4.flights_date >=  to_date('2018-01-01', 'yyyy-mm-dd') - 7
                   and t3.use_date >= to_date('2018-01-01', 'yyyy-mm-dd')
                   and t3.use_date < trunc(sysdate)
                   and t3.FLAG = 1 --已使用
                   and t3.company_id = 0
                   and t3.version = 2
                 group by t3.batch_id,
                          case
                         when t6.users_id is not null then
                          '代理'
                         else
                          '非代理'
                       end) t
          left join (select batch_id,
                            batch_name,
                            create_date,
                            CREATE_TYPE,
                            CREATE_USER,
                            MONEY_TYPE,
                            IF_SAME_NAME,
                            FULL_MONEY,
                            yh_type,
                            MONEY_VAR,
                            MAX_GET,
                            atv_startdate,
                            atv_enddate,
                            user_flag,
                            sum(all_users) all_users,
                            sum(atv_num2) atv_num2
                       from (select t1.create_id batch_id,
                                    t2.resource_memo1 batch_name,
                                    trunc(t2.create_date) create_date,
                                    case
                                      when t3.CREATE_USER in
                                           ('106506', '106505', '103012',
                                            '106500') then
                                       '营销'
                                      when t3.CREATE_USER in
                                           ('106603', '106791', '102982' ，
                                            '98095', '104641', '104774',
                                            '104932', '106401') then
                                       '运营'
                                      else
                                       '其他'
                                    end CREATE_TYPE,
                                    nvl(u.users_work_id, t3.CREATE_USER) CREATE_USER,
                                    case
                                      when t3.MONEY_TYPE = 1 then
                                       '订单总额'
                                      when t3.MONEY_TYPE = 2 then
                                       '机票'
                                      when t3.MONEY_TYPE = 3 then
                                       '辅收'
                                      else
                                       null
                                    end MONEY_TYPE,
                                    case
                                      when t3.IF_SAME_NAME = 1 then
                                       '本人使用'
                                      else
                                       '可非本人使用'
                                    end IF_SAME_NAME,
                                    t3.FULL_MONEY,
                                    case
                                      when t3.TYPE = 1 then
                                       '满减'
                                      when t3.TYPE = 2 then
                                       '折扣'
                                      else
                                       null
                                    end yh_type,
                                    t3.MONEY_VAR,
                                    t3.MAX_GET,
                                    min(trunc(t1.create_date)) over(partition by t1.create_id) atv_startdate,
                                    max(trunc(t1.create_date)) over(partition by t1.create_id) atv_enddate,
                                    case
                                      when t5.users_id is not null then
                                       '代理'
                                      else
                                       '非代理'
                                    end user_flag,
                                    count(distinct t1.users_id) all_users,
                                    count(1) atv_num2
                               from YHQ.CQ_NEW_YHQ_RELATION@to_air t1
                               join YHQ.CQ_NEW_YHQ_RULE_CREATE@to_air t2 on t2.id =
                                                                            t1.create_id
                               join YHQ.CQ_NEW_YHQ_RULE_MAIN@to_air t3 on t3.id =
                                                                          t2.rule_id
                               left join dw.da_b2c_user t4 on t4.users_id =
                                                              t1.users_id
                               left join dw.da_restrict_userinfo t5 on t5.users_id =
                                                                       t1.users_id
                               left join stg.s_cq_user u on u.users_id =
                                                            t3.CREATE_USER
                              where t2.resource_memo1 not like '%测试%'
                                and t2.resource_memo1 not like '%test%'
                                and trunc(t1.create_date) >=
                                    to_date('2018-01-01', 'yyyy-mm-dd')
                                and trunc(t2.create_date) >=
                                    to_date('2018-01-01', 'yyyy-mm-dd')
                                and t2.company_id = 0
                              group by t1.create_id,
                                       t2.resource_memo1,
                                       trunc(t2.create_date),
                                       case
                                         when t3.CREATE_USER in
                                              ('106506', '106505', '103012',
                                               '106500') then
                                          '营销'
                                         when t3.CREATE_USER in
                                              ('106603', '106791', '102982' ，
                                               '98095', '104641', '104774',
                                               '104932', '106401') then
                                          '运营'
                                         else
                                          '其他'
                                       end,
                                       nvl(u.users_work_id, t3.CREATE_USER),
                                       case
                                         when t3.MONEY_TYPE = 1 then
                                          '订单总额'
                                         when t3.MONEY_TYPE = 2 then
                                          '机票'
                                         when t3.MONEY_TYPE = 3 then
                                          '辅收'
                                         else
                                          null
                                       end,
                                       case
                                         when t3.IF_SAME_NAME = 1 then
                                          '本人使用'
                                         else
                                          '可非本人使用'
                                       end,
                                       t3.FULL_MONEY,
                                       case
                                         when t3.TYPE = 1 then
                                          '满减'
                                         when t3.TYPE = 2 then
                                          '折扣'
                                         else
                                          null
                                       end,
                                       t3.MONEY_VAR,
                                       t3.MAX_GET,
                                       trunc(t1.create_date),
                                       case
                                         when t5.users_id is not null then
                                          '代理'
                                         else
                                          '非代理'
                                       end)
                      group by batch_id,
                               batch_name,
                               create_date,
                               CREATE_TYPE,
                               CREATE_USER,
                               MONEY_TYPE,
                               IF_SAME_NAME,
                               FULL_MONEY,
                               yh_type,
                               MONEY_VAR,
                               MAX_GET,
                               atv_startdate,
                               atv_enddate,
                               user_flag) tt on tt.batch_id = t.batch_id
                                            and tt.user_flag = t.user_flag
         group by t.batch_id,
                  tt.batch_name,
                  tt.CREATE_type,
                  tt.CREATE_USER,
                  tt.MONEY_TYPE,
                  tt.create_date,
                  tt.FULL_MONEY,
                  tt.yh_type,
                  tt.MONEY_VAR,
                  tt.MAX_GET,
                  tt.atv_startdate,
                  tt.atv_enddate,
                  tt.atv_enddate - tt.atv_startdate,
                  t.user_flag,
                  tt.all_users,
                  tt.atv_num2;
      commit;
   

  /*
  表名：dw.adt_yhq_daily   
  用途：优惠券每日效果统计表
  数据：优惠券每日领用趋势
  时效：增量更新最近30天的数据,由于代理识别延后的特性，按当时状态作为判断依据，无法回溯数据
  存储过程创建时间：2019-04-08,job1265
  */

truncate table if.if_adt_yhq_daily;
    
      insert into if.if_adt_yhq_daily
        select /*+parallel(4) */
        t.days,
               t.batch_id, --批次号,
               t.user_flag, ---是否代理,
               tt.all_users, ---领取人数,
               tt.atv_num2 atv_num, --发放券量,
               sum(t.yhq_NUM) yhq_NUM, --使用优惠券数量,
               sum(t.yhq_money) yhq_money, --优惠券总面值,
               sum(t.use_money) use_money, --实际优惠金额,
               sum(t.tickets) tickets, --机票量,
               sum(t.clients) clients, --用券会员数,
               sum(t.orders) orders, --订单量,
               sum(t.ticketfee) ticketfee, --机票金额,
               sum(t.xfee) xfee, --辅收金额,
               sum(t.allsale) allsale, --总营收
               sum(t.new_user) new_user,
               sum(t.newuser_use) newuser_use,
               sum(t.new_lyuser) new_lyuser,
               sum(t.newly_use) newly_use,
               sysdate
          from (select t4.order_day days,
                       t3.batch_id,
                       0 all_users, ---领取人数,
                       0 atv_num,
                       case
                         when t6.users_id is not null then
                          '代理'
                         else
                          '非代理'
                       end user_flag,
                       count(distinct t3.yhq_id) yhq_NUM ,
                       sum(t3.yhq_money) yhq_money,
                       sum(t3.use_money) use_money,
                       count(distinct t3.flights_order_head_id) tickets,
                       count(distinct t3.USERS_ID) clients,
                       count(distinct t3.FLIGHTS_ORDER_ID) orders,
                       sum(nvl(t4.ticket_price,0)+nvl(t5.book_fee,0)) ticketfee,
                       sum(nvl(t4.other_fee,0) +nvl(t4.insurce_fee,0)+nvl(t5.book_fee,0)) xfee,
                       sum(nvl(t4.ticket_price,0) + nvl(t4.ad_fy,0) + nvl(t4.port_pay,0) +
                           nvl(t4.other_fy,0) + nvl(t4.other_fee,0) + nvl(t4.insurce_fee,0)+nvl(t5.book_fee,0)) allsale
                       count(distinct case
                               when t4.order_day = t5.reg_day then
                                t4.client_id
                               else
                                null
                             end) new_user,
                       count(distinct case
                               when t4.order_day = t5.reg_day then
                                t3.yhq_id
                               else
                                null
                             end) newuser_use,
                       count(distinct case
                               when t7.users_id_fk is not null and
                                    t4.order_day = t7.reg_day then
                                t7.users_id_fk
                               else
                                null
                             end) new_lyuser,
                       count(distinct case
                               when t7.users_id_fk is not null and
                                    t4.order_day = t7.reg_day then
                                t3.yhq_id
                               else
                                null
                             end) newly_use                
                   from  dw.bi_yhq_use t3
                  left join  dw.fact_order_detail t4 on t3.flights_order_head_id =t4.flights_order_head_id and t3.flights_Order_id=t4.flights_Order_id
                  left join  dw.fact_other_order_detail t5  on t3.flights_order_head_id=t5.flights_Order_head_id and t3.flights_order_id=t5.order_id
                  and t5.other_order_head_id=t3.other_order_head_id
                  left join dw.da_b2c_user t5 on t5.users_id = t3.USERS_ID
                  left join dw.da_lyuser t7 on t7.users_id_fk = t3.USERS_ID
                  left join if.v_da_restrict_userinfo t6 on t6.users_id =t3.USERS_ID
                 where t4.order_day >= to_date('2018-01-01', 'yyyy-mm-dd')
                   and t4.order_day < trunc(sysdate)
                   and t4.flights_date >=  to_date('2018-01-01', 'yyyy-mm-dd') - 7
                   and t3.use_date >= to_date('2018-01-01', 'yyyy-mm-dd')
                   and t3.use_date < trunc(sysdate)
                   and t3.FLAG = 1 --已使用
                   and t3.company_id = 0
                   and t3.version = 2
                 group by t4.order_day,
                          t3.batch_id,
                          case
                            when t6.users_id is not null then
                             '代理'
                            else
                             '非代理'
                          end
                union all
                select trunc(t1.create_date) days,
                       to_char(t1.create_id) batch_id,
                       count(distinct t1.users_id) all_users, --计算领取量
                       count(1) atv_num,
                       case
                         when t5.users_id is not null then
                          '代理'
                         else
                          '非代理'
                       end user_flag,
                       0 yhq_NUM,
                       0 yhq_money,
                       0 use_money,
                       0 tickets,
                       0 clients,
                       0 orders,
                       0 ticketfee,
                       0 xfee,
                       0 allsale,
                       0 new_user,
                       0 newuser_use,
                       0 new_lyuser,
                       0 newly_use
                  from YHQ.CQ_NEW_YHQ_RELATION@to_air t1
                  join YHQ.CQ_NEW_YHQ_RULE_CREATE@to_air t2 on t2.id =
                                                               t1.create_id
                  join YHQ.CQ_NEW_YHQ_RULE_MAIN@to_air t3 on t3.id =
                                                             t2.rule_id
                  left join dw.da_b2c_user t4 on t4.users_id = t1.users_id
                  left join dw.da_restrict_userinfo t5 on t5.users_id =
                                                          t1.users_id
                 where t2.resource_memo1 not like '%测试%'
                   and t2.resource_memo1 not like '%test%'
                   and trunc(t1.create_date) >=
                       to_date('2018-01-01', 'yyyy-mm-dd')
                   and trunc(t2.create_date) >=
                       to_date('2018-01-01', 'yyyy-mm-dd')
                   and t2.company_id = 0
          group by trunc(t1.create_date),
                          t1.create_id,
                          case
                            when t5.users_id is not null then
                             '代理'
                            else
                             '非代理'
                          end) t
          left join (select days,
                            batch_id,
                            batch_name,
                            create_date,
                            CREATE_TYPE,
                            CREATE_USER,
                            MONEY_TYPE,
                            IF_SAME_NAME,
                            FULL_MONEY,
                            yh_type,
                            MONEY_VAR,
                            MAX_GET,
                            atv_startdate,
                            atv_enddate,
                            user_flag,
                            sum(all_users) all_users,
                            sum(atv_num2) atv_num2
                       from (select trunc(t1.create_date) days,
                                    t1.create_id batch_id,
                                    t2.resource_memo1 batch_name,
                                    trunc(t2.create_date) create_date,
                                    case
                                      when t3.CREATE_USER in
                                           ('106506', '106505', '103012',
                                            '106500', '104361') then
                                       '营销'
                                      when t3.CREATE_USER in
                                           ('106603', '106791', '102982' ，
                                            '98095', '104641', '104774',
                                            '104932', '106401', '101779') then
                                       '运营'
                                      else
                                       '其他'
                                    end CREATE_TYPE,
                                    nvl(u.users_work_id, t3.CREATE_USER) CREATE_USER,
                                    case
                                      when t3.MONEY_TYPE = 1 then
                                       '订单总额'
                                      when t3.MONEY_TYPE = 2 then
                                       '机票'
                                      when t3.MONEY_TYPE = 3 then
                                       '辅收'
                                      else
                                       null
                                    end MONEY_TYPE,
                                    case
                                      when t3.IF_SAME_NAME = 1 then
                                       '本人使用'
                                      else
                                       '可非本人使用'
                                    end IF_SAME_NAME,
                                    t3.FULL_MONEY,
                                    case
                                      when t3.TYPE = 1 then
                                       '满减'
                                      when t3.TYPE = 2 then
                                       '折扣'
                                      else
                                       null
                                    end yh_type,
                                    t3.MONEY_VAR,
                                    t3.MAX_GET,
                                    min(trunc(t1.create_date)) over(partition by t1.create_id) atv_startdate,
                                    max(trunc(t1.create_date)) over(partition by t1.create_id) atv_enddate,
                                    case
                                      when t5.users_id is not null then
                                       '代理'
                                      else
                                       '非代理'
                                    end user_flag,
                                    count(distinct t1.users_id) all_users,
                                    count(1) atv_num2
                               from YHQ.CQ_NEW_YHQ_RELATION@to_air t1
                               join YHQ.CQ_NEW_YHQ_RULE_CREATE@to_air t2 on t2.id =
                                                                            t1.create_id
                               join YHQ.CQ_NEW_YHQ_RULE_MAIN@to_air t3 on t3.id =
                                                                          t2.rule_id
                               left join dw.da_b2c_user t4 on t4.users_id =
                                                              t1.users_id
                               left join dw.da_restrict_userinfo t5 on t5.users_id =
                                                                       t1.users_id
                               left join stg.s_cq_user u on u.users_id =
                                                            t3.CREATE_USER
                              where t2.resource_memo1 not like '%测试%'
                                and t2.resource_memo1 not like '%test%'
                                and trunc(t1.create_date) >=
                                    to_date('2018-01-01', 'yyyy-mm-dd')
                                and trunc(t2.create_date) >=
                                    to_date('2018-01-01', 'yyyy-mm-dd')
                                and t2.company_id = 0
                      group by trunc(t1.create_date),
                                       t1.create_id,
                                       t2.resource_memo1,
                                       trunc(t2.create_date),
                                       case
                                         when t3.CREATE_USER in
                                              ('106506', '106505', '103012',
                                               '106500', '104361') then
                                          '营销'
                                         when t3.CREATE_USER in
                                              ('106603', '106791', '102982' ，
                                               '98095', '104641', '104774',
                                               '104932', '106401', '101779') then
                                          '运营'
                                         else
                                          '其他'
                                       end,
                                       nvl(u.users_work_id, t3.CREATE_USER),
                                       case
                                         when t3.MONEY_TYPE = 1 then
                                          '订单总额'
                                         when t3.MONEY_TYPE = 2 then
                                          '机票'
                                         when t3.MONEY_TYPE = 3 then
                                          '辅收'
                                         else
                                          null
                                       end,
                                       case
                                         when t3.IF_SAME_NAME = 1 then
                                          '本人使用'
                                         else
                                          '可非本人使用'
                                       end,
                                       t3.FULL_MONEY,
                                       case
                                         when t3.TYPE = 1 then
                                          '满减'
                                         when t3.TYPE = 2 then
                                          '折扣'
                                         else
                                          null
                                       end,
                                       t3.MONEY_VAR,
                                       t3.MAX_GET,
                                       trunc(t1.create_date),
                                       case
                                         when t5.users_id is not null then
                                          '代理'
                                         else
                                          '非代理'
                                       end)
                      group by days,
                               batch_id,
                               batch_name,
                               create_date,
                               CREATE_TYPE,
                               CREATE_USER,
                               MONEY_TYPE,
                               IF_SAME_NAME,
                               FULL_MONEY,
                               yh_type,
                               MONEY_VAR,
                               MAX_GET,
                               atv_startdate,
                               atv_enddate,
                               user_flag) tt on tt.batch_id = t.batch_id
                                            and tt.user_flag = t.user_flag
                                            and tt.days = t.days
         group by t.days,
                  t.batch_id,
                  tt.batch_name,
                  tt.CREATE_type,
                  tt.CREATE_USER,
                  tt.MONEY_TYPE,
                  tt.create_date,
                  tt.FULL_MONEY,
                  tt.yh_type,
                  tt.MONEY_VAR,
                  tt.MAX_GET,
                  tt.atv_startdate,
                  tt.atv_enddate,
                  tt.atv_enddate - tt.atv_startdate,
                  t.user_flag,
                  tt.all_users,
                  tt.atv_num2;
      commit;
    
   /*   delete from dw.adt_yhq_daily t1
      
       where exists
       (select 1 from if.if_adt_yhq_daily t2 where t2.days = t1.days);
      commit;*/
    /*  
      truncate table dw.adt_yhq_daily;
    
      insert into dw.adt_yhq_daily
        select * from if.if_adt_yhq_daily t2;
      commit;*/