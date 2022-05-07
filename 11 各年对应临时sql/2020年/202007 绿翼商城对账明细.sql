select order_date,
       pay_time,
       order_id,
       serial_number,
       out_trade_no,
       merchant,
       pay_type_name,
       order_amount,
       ys_amount,
       ss_amount,
       result_status
  from (select d.order_date,
               d.pay_time,
               d.order_id,
               d.serial_number,
               d.out_trade_no,
               h.merchant,
               d.pay_type_name,
               d.order_amount,
               d.ys_amount,
               d.ss_amount,
               case
                 when d.trade_status = '-1' then
                  '核销成功'
                 when d.pay_status = d.trade_status and
                      d.pay_amount = d.yingjie_amount then
                  '核销成功'
                 when d.pay_status = d.trade_status and
                      d.pay_amount <> d.yingjie_amount then
                  '金额差异'
                 when d.pay_status <> d.trade_status and
                      d.pay_amount = d.yingjie_amount then
                  '核销失败'
                 else
                  '其他'
               end result_status
          from (select o.ct order_date,
                       nvl(p.pay_time, p.ct) pay_time,
                       p.order_id,
                       p.serial_number,
                       p.out_trade_no,
                       p.pay_type_name,
                       sum(p.pay_amount) over(partition by p.out_trade_no) pay_amount,
                       replace(p.pay_status, '3', '1') pay_status,
                       w.yingjie_amount,
                       case
                         when p.serial_number is not null and
                              w.trade_time is null then
                          '-1'
                         when w.trade_status = 'SUCCESS' then
                          '1'
                         else
                          '2'
                       end trade_status,
                       p.pay_amount order_amount,
                       case
                         when p.pay_status in ('1', '3') then
                          p.pay_amount
                         else
                          0
                       end ys_amount,
                       case
                         when w.trade_status = 'SUCCESS' then
                          w.yingjie_amount * p.pay_amount / sum(p.pay_amount)
                          over(partition by p.out_trade_no) --按金额比例分拆实收账款
                         else
                          0
                       end ss_amount
                  from stg.prt_eshop_order_payment p
                  join stg.prt_eshop_order o on o.id = p.order_id
                  left join hdb.lvyi_paycheck_wechat w on w.wechat_order =
                                                          p.out_trade_no
                 where p.pay_type_name = '腾讯支付分'
                   and p.pay_time >= to_date('2020-07-15', 'yyyy-mm-dd')
                   and p.pay_time < to_date('2020-07-15', 'yyyy-mm-dd') + 1
      
                
                union all
                
                select o.ct order_date,
                       nvl(p.pay_time, p.ct) pay_time,
                       p.order_id,
                       p.serial_number,
                       p.out_trade_no,
                       p.pay_type_name,
                       p.pay_amount,
                       replace(p.pay_status, '3', '1') pay_status,
                       w.yingjie_amount,
                       case
                         when p.serial_number is not null and
                              w.trade_time is null then
                          '-1'
                         when w.trade_status = 'SUCCESS' then
                          '1'
                         else
                          '2'
                       end trade_status,
                       p.pay_amount order_amount,
                       case
                         when p.pay_status in ('1', '3') then
                          p.pay_amount
                         else
                          0
                       end ys_amount,
                       case
                         when w.trade_status = 'SUCCESS' then
                          w.yingjie_amount
                         else
                          0
                       end ss_amount
                  from stg.prt_eshop_order_payment p
                  join stg.prt_eshop_order o on o.id = p.order_id
                  left join hdb.lvyi_paycheck_wechat w on w.merchant_order =
                                                          p.serial_number
                 where p.pay_type_name in('微信支付','扫码支付')
                   and p.pay_time >= to_date('2020-07-15', 'yyyy-mm-dd')
                   and p.pay_time < to_date('2020-07-15', 'yyyy-mm-dd') + 1
              
                
                union all
                
                select o.ct order_date,
                       nvl(p.pay_time, p.ct) pay_time,
                       p.order_id,
                       p.serial_number,
                       p.out_trade_no,
                       p.pay_type_name,
                       p.pay_amount,
                       replace(p.pay_status, '3', '1') pay_status,
                       b.real_pay_amount yingjie_amount,
                       case
                         when p.serial_number is not null and
                              b.system_trade_no is null then
                          '-1'
                         when b.trade_status = '成功' then
                          '1'
                         else
                          '2'
                       end trade_status,
                       p.pay_amount order_amount,
                       case
                         when p.pay_status in ('1', '3') then
                          p.pay_amount
                         else
                          0
                       end ys_amount,
                       case
                         when b.trade_status = '成功' then
                          b.real_pay_amount
                         else
                          0
                       end ss_amount
                  from stg.prt_eshop_order_payment p
                  join stg.prt_eshop_order o on o.id = p.order_id
                  left join hdb.lvyi_paycheck_baihuahua b on b.m2p_request_number =
                                                             p.serial_number
                 where p.pay_type_name = '白花花'
                   and p.pay_time >= to_date('2020-07-15', 'yyyy-mm-dd')
                   and p.pay_time < to_date('2020-07-15', 'yyyy-mm-dd') + 1
               ) d
          left join (select order_id, listagg(name, ';') within
                     group(
                     order by name) merchant
                      from (select distinct od.order_id, m.name
                              from (select distinct order_id
                                      from stg.prt_eshop_order_payment p
                                     where pay_time >=
                                           to_date('2020-07-15', 'yyyy-mm-dd')
                                       and pay_time <
                                           to_date('2020-07-15', 'yyyy-mm-dd') + 1) o
                              join stg.prt_eshop_order_detail od on od.ordeR_id =
                                                                    o.order_id
                              join stg.prt_eshop_product p on p.id =
                                                              od.pro_id
                              join stg.prt_eshop_sys_merchant m on m.id =
                                                                   p.merchant_id)
                     group by order_id) h on h.order_id = d.order_id
         where 1 = 1
       )
 where 1 = 1

 order by pay_time, out_trade_no, serial_number
