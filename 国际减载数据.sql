--订单号 VRWAJG  机票流水号 239806132

select p.*,
       sum(p.票数) over(partition by p.航班号, p.航班日期, p.航段 order by p.操作时间, p.机票流水号) 当时总数
  from (
        --订票非改签入
        select '订票' 分类,
                --t1.r_order_date 订单日期,
                t2.flight_no 航班号,
                t2.flight_date 航班日期,
                t2.segment_code 航段,
                t1.flights_order_id 订单号,
                t1.flights_order_head_id 机票流水号,
                t1.r_order_date 操作时间,
                t1.name || '****' 旅客姓名,
                substr(t1.r_tel, -4, 4) 紧急联系电话尾数,
                decode(t1.sex, 1, '成人', 2, '儿童', 3, '婴儿') 类型,
                f.flag_name 状态,
                t1.ticket_price * nvl(t1.r_com_rate, 1) 票价,
                t1.ad_fy * nvl(t1.r_com_rate, 1) 燃油,
                nvl(t1.ex_cfd2, replace(t1.ex_cfd10, '1', 'PC')) 座位类型,
                case when t1.flag_id in (3,5,41) then 0 else 1 end  票数
          from dw.da_flight t2
          join stg.s_cq_order_head t1 on t1.segment_head_id =
                                         t2.segment_head_id
          join stg.s_cq_order_head_flag f on f.flag = t1.flag_id
         where t2.company_id = 0
         and t1.seats_name is not null 
           and t2.flight_no = '9C6218'
           and t2.flight_date =to_date('2020-07-19', 'yyyy-mm-dd')
           and t1.flag_id in (3, 5, 40, 41,7,11,12)
           and not exists
         (select 1
                  from (select flights_order_head_id,
                               modify_date,
                               old_segment_id,
                               nvl(lead(old_segment_id, 1)
                                   over(partition by flights_order_head_id
                                        order by modify_date),
                                   new_segment_id) new_segment_id
                          from dw.da_order_change) c
                 where c.flights_order_head_id = t1.flights_order_head_id
                   and c.new_segment_id = t1.segment_head_id)
        
        union all
        
        --改签入
        select '改签入' 分类,
               --t1.r_order_date 订单日期,
               t2.flight_no 航班号,
               t2.flight_date 航班日期,
               t2.segment_code 航段,
               t1.flights_order_id 订单号,
               t1.flights_order_head_id 机票流水号,
               c.modify_date 操作时间,
               t1.name || '****' 旅客姓名,
               substr(t1.r_tel, -4, 4) 紧急联系电话尾数,
               decode(t1.sex, 1, '成人', 2, '儿童', 3, '婴儿') 类型,
               f.flag_name 状态,
               t1.ticket_price * nvl(t1.r_com_rate, 1) 票价,
               t1.ad_fy * nvl(t1.r_com_rate, 1) 燃油,
               nvl(t1.ex_cfd2, replace(t1.ex_cfd10, '1', 'PC')) 座位类型,
               1 票数
          from dw.da_flight t2
          join (select flights_order_head_id,
                       modify_date,
                       old_segment_id,
                       nvl(lead(old_segment_id, 1)
                           over(partition by flights_order_head_id order by
                                modify_date),
                           new_segment_id) new_segment_id
                  from dw.da_order_change) c on c.new_segment_id =
                                                t2.segment_head_id
          join stg.s_cq_order_head t1 on t1.flights_order_head_id =
                                         c.flights_order_head_id  
          join stg.s_cq_order_head_flag f on f.flag = t1.flag_id
         where t2.company_id = 0
           and t2.flight_no = '9C6218'
           and t1.seats_name is not null 
           and t2.flight_date=to_date('2020-07-19', 'yyyy-mm-dd')
           and t1.flag_id in (3, 5, 40, 41, 7, 11, 12)
        
        union all
        
        --改签出
        select '改签出' 分类,
               --t1.r_order_date,
               t2.flight_no 航班号,
               t2.flight_date 航班日期,
               t2.segment_code 航段,
               t1.flights_order_id 订单号,
               t1.flights_order_head_id 机票流水号,
               c.modify_date 操作时间,
               t1.name || '****' 旅客姓名,
               substr(t1.r_tel, -4, 4) 紧急联系电话尾数,
               decode(t1.sex, 1, '成人', 2, '儿童', 3, '婴儿') 类型,
               f.flag_name 状态,
               t1.ticket_price * nvl(t1.r_com_rate, 1) 票价,
               t1.ad_fy * nvl(t1.r_com_rate, 1) 燃油,
               nvl(t1.ex_cfd2, replace(t1.ex_cfd10, '1', 'PC')) 座位类型,
               -1 票数
          from dw.da_flight t2
          join dw.da_order_change c on c.old_segment_id = t2.segment_head_id
          join stg.s_cq_order_head t1 on t1.flights_order_head_id =
                                         c.flights_order_head_id 
          join stg.s_cq_order_head_flag f on f.flag = t1.flag_id
         where t2.company_id = 0
           and t2.flight_no = '9C6218'
           and t1.seats_name is not null 
           and t2.flight_date=to_date('2020-07-19', 'yyyy-mm-dd')
           and t1.flag_id in (3, 5, 40, 41, 7, 11, 12)
        
        union all
        
       
        
        select '订票' 分类,
               --t1.r_order_date,
               t2.flight_no 航班号,
               t2.flight_date 航班日期,
               t2.segment_code 航段,
               t1.flights_order_id 订单号,
               t1.flights_order_head_id 机票流水号,
               t1.r_order_date 操作时间,
               t1.name || '****' 旅客姓名,
               substr(t1.r_tel, -4, 4) 紧急联系电话尾数,
               decode(t1.sex, 1, '成人', 2, '儿童', 3, '婴儿') 类型,
               f.flag_name 状态,
               t1.ticket_price * nvl(t1.r_com_rate, 1) 票价,
               t1.ad_fy * nvl(t1.r_com_rate, 1) 燃油,
               nvl(t1.ex_cfd2, replace(t1.ex_cfd10, '1', 'PC')) 座位类型,
               1 票数
          from dw.da_flight t2
          join dw.da_order_change c on c.old_segment_id = t2.segment_head_id
          join stg.s_cq_order_head t1 on t1.flights_order_head_id =
                                         c.flights_order_head_id 
          join stg.s_cq_order_head_flag f on f.flag = t1.flag_id
         where t2.company_id = 0
         and t1.seats_name is not null 
           and t2.flight_no = '9C6218'
           and t2.flight_date=to_date('2020-07-19', 'yyyy-mm-dd')
           and t1.flag_id in (3, 5, 40, 41, 7, 11, 12)
           and   not exists
         (select 1
                  from (select flights_order_head_id,
                               modify_date,
                               old_segment_id,
                               nvl(lead(old_segment_id, 1)
                                   over(partition by flights_order_head_id
                                        order by modify_date),
                                   new_segment_id) new_segment_id
                          from dw.da_order_change) c1
                 where c1.flights_order_head_id = t1.flights_order_head_id
                   and c1.new_segment_id = t2.segment_head_id)
           
           
           union all
        
        
        --退票
        select '退票' 分类,
               --t1.r_order_date 订单日期,
               t2.flight_no 航班号,
               t2.flight_date 航班日期,
               t2.segment_code 航段,
               t1.flights_order_id 订单号,
               t1.flights_order_head_id 机票流水号,
               d.money_date 操作时间,
               t1.name || '****' 旅客姓名,       
               substr(t1.r_tel, -4, 4) 紧急联系电话尾数,
               decode(t1.sex, 1, '成人', 2, '儿童', 3, '婴儿') 类型,
               f.flag_name 状态,
               t1.ticket_price * nvl(t1.r_com_rate, 1) 票价,
               t1.ad_fy * nvl(t1.r_com_rate, 1) 燃油,
               nvl(t1.ex_cfd2, replace(t1.ex_cfd10, '1', 'PC')) 座位类型,
               -1 票数
          from dw.da_flight t2
          join dw.da_order_drawback d on d.segment_head_id =
                                         t2.segment_head_id
          join stg.s_cq_order_head t1 on t1.flights_order_head_id =
                                         d.flights_order_head_id
          join stg.s_cq_order_head_flag f on f.flag = t1.flag_id
         where t2.company_id = 0
           and t2.flight_no = '9C6218'
           and t2.flight_date=to_date('2020-07-19', 'yyyy-mm-dd')
           and t1.flag_id in (7, 11, 12)) p;




