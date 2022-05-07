select trunc(t1.create_time) 绿翼亲友添加日期,count(1) 添加数,count(distinct t1.users_id) 对应会员数
      from cust.cq_flights_benefic_users@to_air t1
      left join cust.cq_benefic_users_codes@to_air t2 on t2.benefic_users_id = t1.crm_favoree_id
      where t1.status = 1
      and t2.flag = 1
      and trunc(t1.create_time) >= to_date('2020-03-01', 'yyyy-mm-dd')
      and trunc(t1.create_time) < trunc(sysdate)
      group by trunc(t1.create_time)
    
