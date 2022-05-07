
--1、创建表
create table anl.wb_ctrip_agent 
(flights_order_id varchar2(200),
 mobile varchar2(100),
 send_date date
)


--2、更新flag状态
update anl.wb_ctrip_agent  t
set flag=0
where not regexp_like(t.flights_order_id,'^[a-zA-Z]{6}$');


update anl.wb_ctrip_agent  t
set flag=0
where length(mobile)<>11;


update anl.wb_ctrip_agent  t
set flag=1
where flag is null;


update wb_ctrip_agent t
set t.flag=2
where rowid in(
select rowid
from(
select flights_Order_id,mobile,send_date,rowid,
row_number()over(partition by flights_order_id order by send_date desc) srow
 from wb_ctrip_agent
 where flag=1)
 where srow>=2
);


---3、验证

select *
 from wb_ctrip_agent
 where flights_order_id in(select flights_order_id
 from wb_ctrip_agent
 where flag=1
 group by flights_order_id
 having count(1)>1);
 
 
 
 
 ---4、分析数据
 
 select t1.*,t2.flights_order_id,t2.web_id,t2.work_tel,t2.order_date,t3.users_id,t3.feature
 from hdb.wb_ctrip_agent_tel t1
 left join stg.s_cq_order t2 on t1.flights_order_id=t2.flights_order_id
 left join dw.da_restrict_userinfo t3 on t2.client_id=t3.users_id
 where  t1.flag=1
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 


 
