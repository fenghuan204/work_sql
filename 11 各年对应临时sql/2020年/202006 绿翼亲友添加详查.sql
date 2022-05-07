select t1.flights_order_head_id,t1.flights_order_id,t1.order_date 日期,
t1.remote_ip 下单IP,
t1.work_tel 联系方式,
t1.r_tel 乘机人联系方式,
t1.flights_date 航班日期,
t1.client_id 注册ID,
t9.reg_date 普通注册日期,
t9.register_ip 普通注册IP,
t9.reg_city 普通注册城市,
t8.realname 绿翼姓名,
t8.reg_date 绿翼注册日期,
t8.register_ip 绿翼注册IP,
t8.reg_city 绿翼注册城市,
t8.login_id 绿翼注册手机号,
t7.create_date 添加亲友日期,
t7.mobile 添加亲友手机号,
t1.traveller_name,
t1.codetype,
t1.codeno,
t77.codtype,
t77.last_time,
t77.flag,
--lower(md5(t8.login_Id)) 注册手机号MD5加密，
        case when t1.channel in('网站','手机') then '线上自有'
            else '其他' end 渠道,
     /*   case
         when t1.channel in('网站','手机') and t5.users_id is not null then
          'ods识别'
          when t1.channel in('网站','手机') then '线上其他'
          else '其他' end ods识别,*/
        case
         when t1.channel in('网站','手机') and t6.users_id is not null then
          'dw识别'
          when t1.channel in('网站','手机') then '线上其他'
          else '其他' end dw识别,
          
       case when t1.channel in('网站','手机') and
              t1.pay_gate in (15, 29, 31) then
          '线上自有易宝商旅卡'
         when t1.channel in('网站','手机') then '线上其他'
          else '其他' end 支付方式,  
          case
         when t4.flights_order_head_id is not null and t4.is_beneficiary = 1 then
          '受益人立减'
         when t4.flights_order_head_id is not null and t4.is_beneficiary = 0 then
          '绿翼立减'
         else
          '普通购买'
       end 立减类型,
       case when t1.channel in('网站','手机') and t6.users_id is not null then 1
       when t1.channel in('网站','手机') and t1.pay_gate in (15, 29, 31) then 1
            when t1.channel in('网站','手机') and t6.users_id is not null then 1
         else 0 end 识别整合
         
  from dw.fact_order_detail t1
   join dw.da_flight t2 on t1.segment_head_id = t2.segment_head_id
  --left join dw.da_restrict_userinfo@to_ods t5 on t1.client_id = t5.users_id
  left join dw.da_restrict_userinfo t6 on t1.client_id=t6.users_id
  left join (select flights_order_head_id,
                    nvl(is_beneficiary, 0) is_beneficiary,
                    youhui_result
               from stg.c_cq_order_youhui_detail
              where product_type = 0
                and yh_ret_time is null
                and youhui_result is not null
                and youhui_id in (1129,1130, 1137,1138)
                and trunc(create_date) >= trunc(sysdate) - 60) t4 on t1.flights_order_head_id =
                                                              t4.flights_order_head_id
 left join (select t1.users_id,t2.code_no,min(t1.create_time) create_date,max(t1.mobile) mobile 
      from cust.cq_flights_benefic_users@to_air t1
      left join cust.cq_benefic_users_codes@to_air t2 on t2.benefic_users_id = t1.crm_favoree_id
      where t1.status = 1
      and t2.flag = 1
      and trunc(t1.create_time) >= to_date('2020-03-01', 'yyyy-mm-dd')
      and trunc(t1.create_time) < trunc(sysdate)
      group by t1.users_id,t2.code_no)t7 on t1.client_id=t7.users_id and t1.codeno=t7.code_no
  left join (select t1.users_id,t2.code_no,min(t1.create_time) create_date,max(t1.mobile) mobile,max(t2.code_type) codtype,
  max(t2.last_update_time) last_time,max(t2.flag) flag
      from cust.cq_flights_benefic_users@to_air t1
      left join cust.cq_benefic_users_codes@to_air t2 on t2.benefic_users_id = t1.crm_favoree_id
      where  trunc(t1.create_time) >= to_date('2020-03-01', 'yyyy-mm-dd')
      and trunc(t1.create_time) <=trunc(sysdate)
      group by t1.users_id,t2.code_no)t77 on t1.client_id=t77.users_id and t1.codeno=t77.code_no  
      
    
 left join dw.da_lyuser t8 on t1.client_id=t8.users_id_fk
 left join dw.da_b2c_user t9 on t1.client_id=t9.users_id
 where t1.order_day >= trunc(sysdate) - 7
   and t1.order_day < sysdate
   and t1.flights_date >= trunc(sysdate - 1) - 7
   and t2.flag <> 2
   --and t1.flights_order_head_id=241409791
   and t1.flag_id in (3, 5, 40, 41)
   and t1.seats_name is not null
    and t4.is_beneficiary = 1
   and t1.whole_flight like '9C%'
   and t1.channel in('网站','手机')
   and t4.flights_order_head_id is not null
   and (t6.users_id is not null or t1.pay_gate in(15, 29, 31))
   --and t7.users_id is null   --针对证件号的漏洞进行匹配
   --and t1.client_id=189220474  --案例介绍
   
   
   
