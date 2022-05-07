--领取优惠券人群画像

--领取优惠券人群画像

select /*+parallel(4) */
yhqnum,money_var,gender,case 
when age< 0 then '-'
when age<12 and age>0 then '<12'
when age< 18 then '12~17'
when age< 24 then '18~23'
when age< 30 then '24~29'
when age< 40 then '30~39'
when age< 50 then '40~49'
when age< 60 then '50~59'
when age< 70 then '60~69'
when age>=70 then '70+' end age,province,new_type,type2,count(1)


from(
select h1.users_id,h1.yhqnum,case when h1.money_var<=10 then '(0,10]'
when h1.money_var<=20 then '(10,20]'
when h1.money_var<=30 then '(20,30]'
when h1.money_var<=40 then '(30,40]'
when h1.money_var<=50 then '(40,50]'
when h1.money_var<=100 then '(50,100]'
when h1.money_var>=100 then '100+' end money_var,nvl(h3.gender,h2.gender) gender,nvl(h3.age,getage(sysdate,h2.birthday)) age,
nvl(h3.province,nvl(h2.tel_province,h2.reg_province)) province,
case when h2.reg_day>=h1.create_date-60
      and h2.reg_day<=h1.create_date then '新用户'
     when h2.reg_day< h1.create_date-60 then '老用户' end new_type,
case when h4.order_day is null then '未购票'
     when h1.create_date> h4.order_day then  '购票后领取优惠券'
     when h1.create_date<= h4.order_day  then '领取优惠券后购票' end type2
from(
select users_id,min(trunc(t1.create_date)) create_date,count(1) yhqnum,avg(t2.money_var) money_var
 from YHQ.CQ_NEW_YHQ_RELATION@to_air t1
 left join dw.bi_yhq_batch t2 on to_char(t1.create_id)=t2.batch_id
 where t2.create_date>=to_date('2019-01-01','yyyy-mm-dd')
   and t2.create_date< to_date('2020-01-01','yyyy-mm-dd')
     and not regexp_like(t2.act_name,'(套票)|(免票)|(test)|(测试)')
         and t2.batch_id not in('1127', '1128', '1129', '1130','1134','1135','1136','1137','1138','9933','9948',
         '9949','9971','10009','10010')
   
   group by users_id)h1
 join dw.da_b2c_user h2 on h1.users_id=h2.users_id
 left join (select users_id_fk,max(t3.gender) gender,max(getage(sysdate,t3.birthday)) age,
                  max(nvl(t3.tel_province,t3.reg_province)) province
               from dw.da_lyuser t3
               group by users_id_fk)h3 on h1.users_id=h3.users_id_fk
               
left join( select tb1.client_id,min(tb1.order_day) order_day,count(distinct tb1.flights_order_id) ordernum
              from dw.fact_order_detail tb1
              where tb1.order_day>=to_date('2019-01-01','yyyy-mm-dd')
                and tb1.client_id>0
                and tb1.order_day< to_date('2020-01-01','yyyy-mm-dd')
                and tb1.company_id=0
                and tb1.channel in('网站','手机')
                group by tb1.client_id)h4 on h1.users_id=h4.client_id)hh1
                group by yhqnum,money_var,gender,case 
                when age< 0 then '-'
                when age<12 and age>0 then '<12'
when age< 18 then '12~17'
when age< 24 then '18~23'
when age< 30 then '24~29'
when age< 40 then '30~39'
when age< 50 then '40~49'
when age< 60 then '50~59'
when age< 70 then '60~69'
when age>=70 then '70+' end ,province,new_type,type2;




-----使用优惠券的人群特征


select /*+parallel(4) */
yhqnum,money_var,gender,
case
when age< 0 then '-'
 when age<12 and age>0 then '<12'
when age< 18 then '12~17'
when age< 24 then '18~23'
when age< 30 then '24~29'
when age< 40 then '30~39'
when age< 50 then '40~49'
when age< 60 then '50~59'
when age< 70 then '60~69'
when age>=70 then '70+' end age,province,new_type,type2,count(1)
from(
select h1.users_id,h1.yhqnum,case when h1.money_var<=10 then '(0,10]'
when h1.money_var<=20 then '(10,20]'
when h1.money_var<=30 then '(20,30]'
when h1.money_var<=40 then '(30,40]'
when h1.money_var<=50 then '(40,50]'
when h1.money_var<=100 then '(50,100]'
when h1.money_var>=100 then '100+' end money_var,nvl(h3.gender,h2.gender) gender,nvl(h3.age,getage(sysdate,h2.birthday)) age,
nvl(h3.province,nvl(h2.tel_province,h2.reg_province)) province,
case when h2.reg_day>=h1.create_date-60
      and h2.reg_day<=h1.create_date then '新用户'
     when h2.reg_day< h1.create_date-60 then '老用户' end new_type,
case when h4.order_day is null then '未购票'
     when h1.create_date> h4.order_day then  '购票后领取优惠券'
     when h1.create_date<= h4.order_day  then '领取优惠券后购票' end type2
from(
select t1.users_id,min(trunc(t2.create_date)) create_date,count(1) yhqnum,avg(t3.YHQ_MONEY) money_var
  from YHQ.CQ_NEW_YHQ_RELATION@to_air t1
  join YHQ.CQ_NEW_YHQ_HISTORY@to_air t2 on t1.id = t2.yhq_id
  join YHQ.CQ_NEW_YHQ_HISTORY_DETAIL@to_air t3 on t3.history_id = t2.id
  join dw.bi_yhq_batch t4 on t1.create_id = t4.batch_id
                         and t4.version = 2
 where t2.flag = 1
   and not regexp_like(t4.act_name, '(套票)|(免票)|(test)|(测试)')
   and t4.batch_id not in
       ('1127', '1128', '1129', '1130', '1134', '1135', '1136', '1137',
        '1138', '9933', '9948', '9949', '9971', '10009', '10010')
   and t4.create_date>=to_date('2019-01-01','yyyy-mm-dd')
   and t4.create_date< to_date('2020-01-01','yyyy-mm-dd')
   group by t1.users_id)h1
 join dw.da_b2c_user h2 on h1.users_id=h2.users_id
 left join (select users_id_fk,max(t3.gender) gender,max(getage(sysdate,t3.birthday)) age,
                  max(nvl(t3.tel_province,t3.reg_province)) province
               from dw.da_lyuser t3
               group by users_id_fk)h3 on h1.users_id=h3.users_id_fk
               
left join( select tb1.client_id,min(tb1.order_day) order_day,count(distinct tb1.flights_order_id) ordernum
              from dw.fact_order_detail tb1
              where tb1.order_day>=to_date('2019-01-01','yyyy-mm-dd')
                and tb1.client_id>0
                and tb1.order_day< to_date('2020-01-01','yyyy-mm-dd')
                and tb1.company_id=0
                and tb1.channel in('网站','手机')
                group by tb1.client_id)h4 on h1.users_id=h4.client_id)hh1
                group by yhqnum,money_var,gender,
                case 
                when age< 0 then '-'
                when age<12  and age>0 then '<12'
when age< 18 then '12~17'
when age< 24 then '18~23'
when age< 30 then '24~29'
when age< 40 then '30~39'
when age< 50 then '40~49'
when age< 60 then '50~59'
when age< 70 then '60~69'
when age>=70 then '70+' end ,province,new_type,type2;


---兑换机票的时间间隔

select case when day1<=7 then to_char(day1)
when day1<=15 then '8~15'
when day1<=30 then '16~30'
when day1<=60 then '31~60'
when day1<=180 then '61~180'
when day1<=365 then '181~365' 
when day1>365 then '365+' end day1, 
case when day2<=7 then to_char(day2)
when day2<=15 then '8~15'
when day2<=30 then '16~30'
when day2<=60 then '31~60'
when day2<=180 then '61~180'
when day2<=365 then '181~365' 
when day2>365 then '365+' end day2,
yhqnum,
case when yhq_money<=200 then to_char(yhq_money)
else '200+' end,
count(1)
from(
select t1.users_id,trunc(avg(trunc(t2.create_date-t1.create_date))) day1,
trunc(avg(trunc(t4.flights_date_e1-t2.create_date))) day2,count(1) yhqnum,
sum(t3.yhq_money) yhq_money
  from YHQ.CQ_NEW_YHQ_RELATION@to_air t1
  join YHQ.CQ_NEW_YHQ_HISTORY@to_air t2 on t1.id = t2.yhq_id
  join YHQ.CQ_NEW_YHQ_HISTORY_DETAIL@to_air t3 on t3.history_id = t2.id
  join dw.bi_yhq_batch t4 on t1.create_id = t4.batch_id
                         and t4.version = 2
 where t2.flag = 1
   and not regexp_like(t4.act_name, '(套票)|(免票)|(test)|(测试)')
   and t4.batch_id not in
       ('1127', '1128', '1129', '1130', '1134', '1135', '1136', '1137',
        '1138', '9933', '9948', '9949', '9971', '10009', '10010')
   and t4.create_date>=to_date('2019-01-01','yyyy-mm-dd')
   and t4.create_date< to_date('2020-01-01','yyyy-mm-dd')
   group by t1.users_id)h1
   group by case when day1<=7 then to_char(day1)
when day1<=15 then '8~15'
when day1<=30 then '16~30'
when day1<=60 then '31~60'
when day1<=180 then '61~180'
when day1<=365 then '181~365' 
when day1>365 then '365+' end , 
case when day2<=7 then to_char(day2)
when day2<=15 then '8~15'
when day2<=30 then '16~30'
when day2<=60 then '31~60'
when day2<=180 then '61~180'
when day2<=365 then '181~365' 
when day2>365 then '365+' end ,
yhqnum,
case when yhq_money<=200 then to_char(yhq_money)
else '200+' end;






==================================================20200921=======================================

---出行目的数据判断

select h2.part ,count(1)
from(
select nvl(t5.flights_order_head_id,t6.flights_order_head_id) flights_order_head_id
  from dw.bi_yhq_use t1
  join dw.bi_yhq_batch t4 on t1.batch_id = t4.batch_id   and t4.version = 2 
  left join dw.fact_order_detail t5 on t1.flights_order_head_id=t5.flights_order_head_id
  left join dw.fact_other_order_detail t6 on t1.other_order_head_id=t6.other_order_head_id
 where not regexp_like(t4.act_name, '(套票)|(免票)|(test)|(测试)')
   and t4.batch_id not in
       ('1127', '1128', '1129', '1130', '1134', '1135', '1136', '1137',
        '1138', '9933', '9948', '9949', '9971', '10009', '10010')
   and t4.create_date>=to_date('2019-01-01','yyyy-mm-dd')
   and t4.create_date< to_date('2020-01-01','yyyy-mm-dd')
   and t1.order_type in(0,1))h1
   join dw.fact_orderhead_trippurpose@to_ods h2 on h1.flights_order_head_id=h2.flights_order_head_id
   group by h2.part；
   
   
   --------复购数据

   select /*+parallel(4) */
 h2.ordernum 购票频次,
case when h1.minday<=h2.first_orderdate then '首单'
when h1.minday> h2.first_orderdate and h1.maxday>=trunc(h2.last_orderdate) then '使用优惠券后未再次购票'
when h1.minday> h2.first_orderdate and h1.maxday<=trunc(h2.last_orderdate) then '使用优惠券后再次购票'
end,count(distinct client_id)

from(
select  t5.client_id,min(nvl(t5.order_day,t6.order_day)) minday,max(nvl(t5.order_day,t6.order_day)) maxday       
  from dw.bi_yhq_use t1
  join dw.bi_yhq_batch t4 on t1.batch_id = t4.batch_id   and t4.version = 2 
  left join dw.fact_order_detail t5 on t1.flights_order_head_id=t5.flights_order_head_id
  left join dw.fact_other_order_detail t6 on t1.other_order_head_id=t6.other_order_head_id
 where not regexp_like(t4.act_name, '(套票)|(免票)|(test)|(测试)')
   and t4.batch_id not in
       ('1127', '1128', '1129', '1130', '1134', '1135', '1136', '1137',
        '1138', '9933', '9948', '9949', '9971', '10009', '10010')
   and t1.use_date>=to_date('2017-01-01','yyyy-mm-dd')
   and t1.use_date< to_date('2018-01-01','yyyy-mm-dd')
   and t1.order_type in(0,1)
   group by t5.client_id)h1
   left join dw.da_user_purchase h2 on h1.client_id=h2.users_id
   group by h2.ordernum ,
case when h1.minday<=h2.first_orderdate then '首单'
when h1.minday> h2.first_orderdate and h1.maxday>=trunc(h2.last_orderdate) then '使用优惠券后未再次购票'
when h1.minday> h2.first_orderdate and h1.maxday<=trunc(h2.last_orderdate) then '使用优惠券后再次购票'
end

====================================================赔偿优惠券======================================

--领券
select /*+parallel(4) */
yhqnum,money_var,gender,case 
when age< 0 then '-'
when age<12 and age>0 then '<12'
when age< 18 then '12~17'
when age< 24 then '18~23'
when age< 30 then '24~29'
when age< 40 then '30~39'
when age< 50 then '40~49'
when age< 60 then '50~59'
when age< 70 then '60~69'
when age>=70 then '70+' end age,province,new_type,type2,count(1)

from(
select h1.users_id,h1.yhqnum,case when h1.money_var<=10 then '(0,10]'
when h1.money_var<=20 then '(10,20]'
when h1.money_var<=30 then '(20,30]'
when h1.money_var<=40 then '(30,40]'
when h1.money_var<=50 then '(40,50]'
when h1.money_var<=100 then '(50,100]'
when h1.money_var>=100 then '100+' end money_var,nvl(h3.gender,h2.gender) gender,nvl(h3.age,getage(sysdate,h2.birthday)) age,
nvl(h3.province,nvl(h2.tel_province,h2.reg_province)) province,
case when h2.reg_day>=h1.create_date-60
      and h2.reg_day<=h1.create_date then '新用户'
     when h2.reg_day< h1.create_date-60 then '老用户' end new_type,
case when h4.order_day is null then '未购票'
     when h1.create_date> h4.order_day then  '购票后领取优惠券'
     when h1.create_date<= h4.order_day  then '领取优惠券后购票' end type2
from(
select users_id,min(trunc(t1.create_date)) create_date,count(1) yhqnum,avg(t2.money_var) money_var
 from YHQ.CQ_NEW_YHQ_RELATION@to_air t1
 left join dw.bi_yhq_batch t2 on to_char(t1.create_id)=t2.batch_id
 where t2.create_date>=to_date('2019-01-01','yyyy-mm-dd')
   and t2.create_date< to_date('2020-01-01','yyyy-mm-dd')
     and not regexp_like(t2.act_name,'(套票)|(免票)|(test)|(测试)')
     and regexp_like(t2.act_name, '(服管部)|(服务)')
         and t2.batch_id not in('1127', '1128', '1129', '1130','1134','1135','1136','1137','1138','9933','9948',
         '9949','9971','10009','10010')
   
   group by users_id)h1
 join dw.da_b2c_user h2 on h1.users_id=h2.users_id
 left join (select users_id_fk,max(t3.gender) gender,max(getage(sysdate,t3.birthday)) age,
                  max(nvl(t3.tel_province,t3.reg_province)) province
               from dw.da_lyuser t3
               group by users_id_fk)h3 on h1.users_id=h3.users_id_fk
               
left join( select tb1.client_id,min(tb1.order_day) order_day,count(distinct tb1.flights_order_id) ordernum
              from dw.fact_order_detail tb1
              where tb1.order_day>=to_date('2019-01-01','yyyy-mm-dd')
                and tb1.client_id>0
                and tb1.order_day< to_date('2020-01-01','yyyy-mm-dd')
                and tb1.company_id=0
                and tb1.channel in('网站','手机')
                group by tb1.client_id)h4 on h1.users_id=h4.client_id)hh1
                group by yhqnum,money_var,gender,case 
                when age< 0 then '-'
                when age<12 and age>0 then '<12'
when age< 18 then '12~17'
when age< 24 then '18~23'
when age< 30 then '24~29'
when age< 40 then '30~39'
when age< 50 then '40~49'
when age< 60 then '50~59'
when age< 70 then '60~69'
when age>=70 then '70+' end ,province,new_type,type2;


---用券

select /*+parallel(4) */
yhqnum,money_var,gender,
case
when age< 0 then '-'
 when age<12 and age>0 then '<12'
when age< 18 then '12~17'
when age< 24 then '18~23'
when age< 30 then '24~29'
when age< 40 then '30~39'
when age< 50 then '40~49'
when age< 60 then '50~59'
when age< 70 then '60~69'
when age>=70 then '70+' end age,province,new_type,type2,count(1)
from(
select h1.users_id,h1.yhqnum,case when h1.money_var<=10 then '(0,10]'
when h1.money_var<=20 then '(10,20]'
when h1.money_var<=30 then '(20,30]'
when h1.money_var<=40 then '(30,40]'
when h1.money_var<=50 then '(40,50]'
when h1.money_var<=100 then '(50,100]'
when h1.money_var>=100 then '100+' end money_var,nvl(h3.gender,h2.gender) gender,nvl(h3.age,getage(sysdate,h2.birthday)) age,
nvl(h3.province,nvl(h2.tel_province,h2.reg_province)) province,
case when h2.reg_day>=h1.create_date-60
      and h2.reg_day<=h1.create_date then '新用户'
     when h2.reg_day< h1.create_date-60 then '老用户' end new_type,
case when h4.order_day is null then '未购票'
     when h1.create_date> h4.order_day then  '购票后领取优惠券'
     when h1.create_date<= h4.order_day  then '领取优惠券后购票' end type2
from(
select t1.users_id,min(trunc(t2.create_date)) create_date,count(1) yhqnum,avg(t3.YHQ_MONEY) money_var
  from YHQ.CQ_NEW_YHQ_RELATION@to_air t1
  join YHQ.CQ_NEW_YHQ_HISTORY@to_air t2 on t1.id = t2.yhq_id
  join YHQ.CQ_NEW_YHQ_HISTORY_DETAIL@to_air t3 on t3.history_id = t2.id
  join dw.bi_yhq_batch t4 on t1.create_id = t4.batch_id
                         and t4.version = 2
 where t2.flag = 1
   and not regexp_like(t4.act_name, '(套票)|(免票)|(test)|(测试)')
   and regexp_like(t4.act_name, '(服管部)|(服务)')
   and t4.batch_id not in
       ('1127', '1128', '1129', '1130', '1134', '1135', '1136', '1137',
        '1138', '9933', '9948', '9949', '9971', '10009', '10010')
   and t4.create_date>=to_date('2019-01-01','yyyy-mm-dd')
   and t4.create_date< to_date('2020-01-01','yyyy-mm-dd')
   group by t1.users_id)h1
 join dw.da_b2c_user h2 on h1.users_id=h2.users_id
 left join (select users_id_fk,max(t3.gender) gender,max(getage(sysdate,t3.birthday)) age,
                  max(nvl(t3.tel_province,t3.reg_province)) province
               from dw.da_lyuser t3
               group by users_id_fk)h3 on h1.users_id=h3.users_id_fk
               
left join( select tb1.client_id,min(tb1.order_day) order_day,count(distinct tb1.flights_order_id) ordernum
              from dw.fact_order_detail tb1
              where tb1.order_day>=to_date('2019-01-01','yyyy-mm-dd')
                and tb1.client_id>0
                and tb1.order_day< to_date('2020-01-01','yyyy-mm-dd')
                and tb1.company_id=0
                and tb1.channel in('网站','手机')
                group by tb1.client_id)h4 on h1.users_id=h4.client_id)hh1
                group by yhqnum,money_var,gender,
                case 
                when age< 0 then '-'
                when age<12  and age>0 then '<12'
when age< 18 then '12~17'
when age< 24 then '18~23'
when age< 30 then '24~29'
when age< 40 then '30~39'
when age< 50 then '40~49'
when age< 60 then '50~59'
when age< 70 then '60~69'
when age>=70 then '70+' end ,province,new_type,type2;



----领券使用间隔



select case when day1<=7 then to_char(day1)
when day1<=15 then '8~15'
when day1<=30 then '16~30'
when day1<=60 then '31~60'
when day1<=180 then '61~180'
when day1<=365 then '181~365' 
when day1>365 then '365+' end day1, 
case when day2<=7 then to_char(day2)
when day2<=15 then '8~15'
when day2<=30 then '16~30'
when day2<=60 then '31~60'
when day2<=180 then '61~180'
when day2<=365 then '181~365' 
when day2>365 then '365+' end day2,
yhqnum,
case when yhq_money<=200 then to_char(yhq_money)
else '200+' end,
count(1)
from(
select t1.users_id,trunc(avg(trunc(t2.create_date-t1.create_date))) day1,
trunc(avg(trunc(t4.flights_date_e1-t2.create_date))) day2,count(1) yhqnum,
sum(t3.yhq_money) yhq_money
  from YHQ.CQ_NEW_YHQ_RELATION@to_air t1
  join YHQ.CQ_NEW_YHQ_HISTORY@to_air t2 on t1.id = t2.yhq_id
  join YHQ.CQ_NEW_YHQ_HISTORY_DETAIL@to_air t3 on t3.history_id = t2.id
  join dw.bi_yhq_batch t4 on t1.create_id = t4.batch_id
                         and t4.version = 2
 where t2.flag = 1
   and not regexp_like(t4.act_name, '(套票)|(免票)|(test)|(测试)')
    and regexp_like(t4.act_name, '(服管部)|(服务)')
   and t4.batch_id not in
       ('1127', '1128', '1129', '1130', '1134', '1135', '1136', '1137',
        '1138', '9933', '9948', '9949', '9971', '10009', '10010')
   and t4.create_date>=to_date('2019-01-01','yyyy-mm-dd')
   and t4.create_date< to_date('2020-01-01','yyyy-mm-dd')
   group by t1.users_id)h1
   group by case when day1<=7 then to_char(day1)
when day1<=15 then '8~15'
when day1<=30 then '16~30'
when day1<=60 then '31~60'
when day1<=180 then '61~180'
when day1<=365 then '181~365' 
when day1>365 then '365+' end , 
case when day2<=7 then to_char(day2)
when day2<=15 then '8~15'
when day2<=30 then '16~30'
when day2<=60 then '31~60'
when day2<=180 then '61~180'
when day2<=365 then '181~365' 
when day2>365 then '365+' end ,
yhqnum,
case when yhq_money<=200 then to_char(yhq_money)
else '200+' end;



==============================赔偿券人群特征



select /*+parallel(4) */
h2.ordernum,case when h2.users_id is  null then '无购票记录'
 when h1.create_date= trunc(h2.first_orderdate) then '首单'
 when h1.create_date> trunc(h2.first_orderdate) then '领券前有购票记录'
 when h1.create_date<  h2.first_orderdate then '领券后有购票记录'
 end ,count(1)
 
from(
select users_id,min(trunc(t1.create_date)) create_date,count(1) yhqnum,avg(t2.money_var) money_var
 from YHQ.CQ_NEW_YHQ_RELATION@to_air t1
 join dw.bi_yhq_batch t2 on to_char(t1.create_id)=t2.batch_id
 where t2.create_date>=to_date('2018-01-01','yyyy-mm-dd')
   and t2.create_date< to_date('2019-01-01','yyyy-mm-dd')
     and not regexp_like(t2.act_name,'(套票)|(免票)|(test)|(测试)|(点评)')
     and regexp_like(t2.act_name, '(服管部)|(服务)')
         and t2.batch_id not in('1127', '1128', '1129', '1130','1134','1135','1136','1137','1138','9933','9948',
         '9949','9971','10009','10010')
   group by users_id)h1
 left join dw.da_user_purchase h2 on h1.users_id=h2.users_id
 group by h2.ordernum,case when h2.users_id is  null then '无购票记录'
 when h1.create_date= trunc(h2.first_orderdate) then '首单'
 when h1.create_date> trunc(h2.first_orderdate) then '领券前有购票记录'
 when h1.create_date<  h2.first_orderdate then '领券后有购票记录'
 end
