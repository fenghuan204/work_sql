
---绿翼注册数据

select /*+parallel(4) */
case when t3.cust_id is not null then '绿翼立减'
when t2.cust_id is not null then 'OTA同价'
else '其他' end type1,count(1)
from dw.da_lyuser t1
left join dw.da_ota_lyuser@to_ods t2 on t1.cust_id=t2.cust_id
left join dw.da_lyuser_lylj@to_ods t3 on t1.cust_id=t3.cust_id
where t1.reg_date>=to_date('2019-08-01','yyyy-mm-dd')
group by case when t3.cust_id is not null then '绿翼立减'
when t2.cust_id is not null then 'OTA同价'
else '其他' end 


--绿翼注册后购票数据
select h2.type1,count(distinct h2.cust_id)
 from (select t1.cust_id,t1.users_id_fk,
case when t3.cust_id is not null then '绿翼立减'
when t2.cust_id is not null then 'OTA同价'
else '其他' end type1,t1.reg_date,t1.codeno,t1.codetype
from dw.da_lyuser t1
left join dw.da_ota_lyuser@to_ods t2 on t1.cust_id=t2.cust_id
left join dw.da_lyuser_lylj@to_ods t3 on t1.cust_id=t3.cust_id
where t1.reg_date>=to_date('2019-08-01','yyyy-mm-dd'))h2
 join dw.fact_order_detail h1 on h1.client_id=h2.users_id_fk and h1.order_date> h2.reg_date
 group by h2.type1

 
 ---订单中有自己的人数
 
 select /*+parallel(4) */
h2.type1,count(distinct h2.cust_id)
 from (select t1.cust_id,t1.users_id_fk,
case when t3.cust_id is not null then '绿翼立减'
when t2.cust_id is not null then 'OTA同价'
else '其他' end type1,t1.reg_date,t1.codeno,t1.codetype
from dw.da_lyuser t1
left join dw.da_ota_lyuser@to_ods t2 on t1.cust_id=t2.cust_id
left join dw.da_lyuser_lylj@to_ods t3 on t1.cust_id=t3.cust_id
where t1.reg_date>=to_date('2019-08-01','yyyy-mm-dd'))h2
 join dw.fact_order_detail h1 on  h1.order_date> h2.reg_date and h1.client_id=h2.users_Id_fk
 where exists(select 1
                 from dw.fact_order_detail h3
                 where h3.order_day>=to_date('2019-08-01','yyyy-mm-dd')
                 and h3.flights_order_id=h1.flights_order_id
                 and h3.codeno=h2.codeno) 
                 and h1.order_day>=to_date('2019-08-01','yyyy-mm-dd')            
         group by h2.type1 ；
		 

---订票中没有自己		 
		 
select /*+parallel(4) */
h2.type1,count(distinct h2.cust_id)
 from (select t1.cust_id,t1.users_id_fk,
case when t3.cust_id is not null then '绿翼立减'
when t2.cust_id is not null then 'OTA同价'
else '其他' end type1,t1.reg_date,t1.codeno,t1.codetype
from dw.da_lyuser t1
left join dw.da_ota_lyuser@to_ods t2 on t1.cust_id=t2.cust_id
left join dw.da_lyuser_lylj@to_ods t3 on t1.cust_id=t3.cust_id
where t1.reg_date>=to_date('2019-08-01','yyyy-mm-dd'))h2
 join dw.fact_order_detail h1 on  h1.order_date> h2.reg_date and h1.client_id=h2.users_Id_fk
 where not exists(select 1
                 from dw.fact_order_detail h3
                 where h3.order_day>=to_date('2019-08-01','yyyy-mm-dd')
                 and h3.flights_order_id=h1.flights_order_id
                 and h3.codeno=h2.codeno) 
                 and h1.order_day>=to_date('2019-08-01','yyyy-mm-dd')            
         group by h2.type1        
                 
				 
				 
-------------------------



select /*+parallel(4) */
h3.type1,count(distinct h2.cust_id)
 from 
 dw.fact_order_detail h1
 join (select t1.cust_id,t1.users_id_fk,
case when t3.cust_id is not null then '绿翼立减'
when t2.cust_id is not null then 'OTA同价'
else '其他' end type1,t1.reg_date,t1.codeno,t1.codetype
from dw.da_lyuser t1
left join dw.da_ota_lyuser@to_ods t2 on t1.cust_id=t2.cust_id
left join dw.da_lyuser_lylj@to_ods t3 on t1.cust_id=t3.cust_id
where t1.reg_date>=to_date('2019-08-01','yyyy-mm-dd'))h3 on h1.codeno=h3.codeno and h1.order_date> h3.reg_date
 left join (select t1.cust_id,t1.users_id_fk,
case when t3.cust_id is not null then '绿翼立减'
when t2.cust_id is not null then 'OTA同价'
else '其他' end type1,t1.reg_date,t1.codeno,t1.codetype
from dw.da_lyuser t1
left join dw.da_ota_lyuser@to_ods t2 on t1.cust_id=t2.cust_id
left join dw.da_lyuser_lylj@to_ods t3 on t1.cust_id=t3.cust_id
where t1.reg_date>=to_date('2019-08-01','yyyy-mm-dd'))h2 on h1.client_id=h2.users_id_fk and h1.order_date> h2.reg_date
where h1.order_day>=to_date('2019-08-01','yyyy-mm-dd')
and h2.cust_id is  null
and h3.cust_id is not null
group by h3.type1

