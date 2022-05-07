
---最近一段时间新用户量购票激增（以前没有购买行为的用户占比激增，从14%上升至40%）
select t1.order_day,case when t1.order_DAY-t2.reg_day <=0 then '00'
when t1.order_day-t2.reg_day<=7 then '01~07'
when t1.order_day-t2.reg_day<=15 then '08~15'
when t1.order_day-t2.reg_day<=30 then '16~30'
when t1.order_day-t2.reg_day<=90 then '31~90'
when t1.order_day-t2.reg_day<=180 then '91~180'
when t1.order_day-t2.reg_day<=365 then '181~365'
else '365+' end 注册提前期,case when t1.order_day=nvl(trunc(t3.first_orderdate),t1.order_day) then '首次下单'
when t1.order_day> nvl(trunc(t3.first_orderdate),t1.order_day+1) then '复购' end,
case when t1.gate_name like '%商旅卡%' then '春秋商旅卡'
when t1.gate_name like '%易宝%' then '易宝'
else '其他' end 支付方式,
count(1)
 from dw.fact_order_detail t1
 join dw.da_b2c_user t2 on t1.client_Id=t2.users_id
 left join dw.da_user_purchase t3 on t1.client_Id=t3.users_id
  where t1.order_day>=to_date('2021-01-01','yyyy-mm-dd')
   and t1.order_day< trunc(sysdate)
   and t1.company_id=0
   and t1.channel in('网站','手机')
   group by t1.order_day,case when t1.order_DAY-t2.reg_day <=0 then '00'
when t1.order_day-t2.reg_day<=7 then '01~07'
when t1.order_day-t2.reg_day<=15 then '08~15'
when t1.order_day-t2.reg_day<=30 then '16~30'
when t1.order_day-t2.reg_day<=90 then '31~90'
when t1.order_day-t2.reg_day<=180 then '91~180'
when t1.order_day-t2.reg_day<=365 then '181~365'
else '365+' end,case when t1.order_day=nvl(trunc(t3.first_orderdate),t1.order_day) then '首次下单'
when t1.order_day> nvl(trunc(t3.first_orderdate),t1.order_day+1) then '复购' end,case when t1.gate_name like '%商旅卡%' then '春秋商旅卡'
when t1.gate_name like '%易宝%' then '易宝'
else '其他' end;


