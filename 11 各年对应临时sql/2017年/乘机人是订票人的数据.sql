/*
订票人是乘机人的判断标准：在自有渠道订票的乘机人
1、订票人的注册信息和乘机人信息一致
１）订票人的证件号和乘机人证件号一致
２）订票人的姓名和乘机人姓名一致
3）订票人的注册手机号和乘机人联系电话一致且订票人注册姓名和乘机人姓名一致
3）订票人的注册手机号和乘机人联系电话一致且订票人预留姓名和乘机人姓名一致
2、 



*/


select 
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  left join dw.da_b2c_user t3 on t1.client_id=t3.users_id
  left join dw.da_lyuser t4 on t3.users_id=t4.users_id_fk
  where t1.flights_date>=to_date('2016-11-01','yyyy-mm-dd')
    and t1.flights_date< to_date('2017-11-01','yyyy-mm-dd')
    and t2.flag<>2
    and t1.company_id=0
    
