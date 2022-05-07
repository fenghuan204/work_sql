 select t.order_date,t.flights_order_id,t.client_id,t2.login_id,t2.realname,t.work_tel,t.order_linkman,t1.flag_id,
          t.terminal_id,t.web_id,t.ex_nfd1,t1.name||coalesce(t1.second_name,'') name,t1.seats_name,t1.r_tel
   from stg.s_cq_order t
   join stg.s_cq_order_head t1 on t.flights_order_id=t1.flights_order_id
   join dw.da_b2c_user t2 on t.client_id=t2.users_id
   where t.client_id in(159747358,165706903)
   and t2.users_id in(159747358,165706903)
   and t.order_date>=t2.reg_date;
 
 
 select * from dw.da_b2c_user t1
 where t1.login_id ='13142548669'
 or t1.email='774659778@qq.com';
 

 
 --1、特殊手机号以及其他特征代理识别数据
 
    select /*+parallel(8) */
 t1.order_day,to_char(t1.order_day,'yyyymm') month,t1.flights_date,t2.flights_segment_name,t1.order_linkman,t1.email,t1.work_tel,
            t1.traveller_name,t1.r_tel,
   case when t1.channel='手机' and t1.station_id =2 then 'M网站'
            when t1.channel='手机' and t1.station_id in(5,10) then '微信'
            when t1.channel='手机' and t1.station_id in(3,8) then 'IOS'
            when t1.channel='手机' and t1.station_id in(4,9) then 'Andriod'
else t1.channel end,t1.sub_channel,t3.feature,t1.gate_name,t1.client_id,
to_char(t4.reg_day,'yyyymm') regmonth,t1.order_day-t4.reg_day
     from dw.fact_order_detail  t1
     join dw.da_flight t2 on t2.segment_head_id=t1.segment_head_id
   left join dw.da_restrict_userinfo t3 on t1.client_id=t3.users_id
   left join dw.da_b2c_user t4 on t1.client_id=t4.users_id
     where t1.order_day>=to_date('2016-01-01','yyyy-mm-dd')
       and (t1.r_tel ='15221541674'
       or t1.work_tel='15221541674'
       or lower(t1.email)='962781160@qq.com');



---2、恶意占位


 select t.order_date,t.client_id,t5.feature,t.work_tel,t.order_linkman,t.email,t1.whole_segment,t1.whole_flight,t1.r_flights_date,t1.name,t7.flag_name,r_tel 
from cqsale.cq_order@to_air t
join cqsale.cq_order_head@to_air t1 on t.flights_order_id=t1.flights_order_id
left join stg.s_cq_terminal t3 on t.terminal_Id=t3.terminal_id
left join stg.s_cq_agent_info t4 on t.web_id=t4.agent_id
left join dw.da_restrict_userinfo t5 on t.client_id=t5.users_id
left join dw.da_flight t6 on t1.segment_head_id=t6.segment_head_id
left join stg.s_cq_order_head_flag t7 on t1.flag_id=t7.flag
where t.order_date>=trunc(sysdate)
and( t1.name ='成人三十一'
or t1.r_tel ='13210000001'
or t.work_tel='15736123431'
and t.email='277762121@qq.com')
and t1.r_flights_date>=trunc(sysdate-1);
 
