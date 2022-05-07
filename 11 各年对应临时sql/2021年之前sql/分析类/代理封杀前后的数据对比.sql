===================================================以下为代理筛选机制============================================

 新代理账号筛选机制

create table hdb.wb_agent_rcd_factor as
select h2.*, case when h2.tnum/h2.totalnum<=0.2 then 0.2
when h2.tnum/h2.totalnum<=0.4 then 0.4
when h2.tnum/h2.totalnum<=0.6 then 0.6
when h2.tnum/h2.totalnum<=0.8 then 0.8
when h2.tnum/h2.totalnum<=1 then 1 end factor,
trunc(sysdate) create_date,
null factor_flag
from(
select h1.client_id,h1.feature,h1.feature_id,h1.feature_value,h1.ticketnum,h1.totalnum1,h3.pnum,
sum(h1.ticketnum)over(partition by h1.feature,h1.feature_value order by h1.ticketnum desc) tnum,
sum(h1.ticketnum)over(partition by h1.feature,h1.feature_value) totalnum
from(
select t1.client_id,case when t2.identify='troy' then 'troy'||'--'||t2.feature
else t2.identify end feature,t2.feature_id,t2.feature_value,count(1) ticketnum,
sum(count(1))over(partition by case when t2.identify='troy' then 'troy'||'--'||t2.feature
else t2.identify end,t2.feature_id,t2.feature_value) totalnum1
  from dw.fact_order_detail t1
  left join dw.da_restrict_userinfo t2 on t1.client_id=t2.users_id
  where t1.channel in('网站','手机')
    and t1.company_id=0
    and t1.order_day>=trunc(sysdate-60)
    and t1.seats_name is not null
    and t2.users_id is not null 
    and t1.seats_name <>'O'
    group by t1.client_id,case when t2.identify='troy' then 'troy'||'--'||t2.feature
else t2.identify end,t2.feature_value,t2.feature_id
)h1
left join (
select case when t2.identify='troy' then 'troy'||'--'||t2.feature
else t2.identify end feature,t2.feature_id,t2.feature_value,count(distinct t1.traveller_name||t1.codeno) pnum
  from dw.fact_order_detail t1
  left join dw.da_restrict_userinfo t2 on t1.client_id=t2.users_id
  where t1.channel in('网站','手机')
    and t1.company_id=0
    and t1.order_day>=trunc(sysdate-60)
    and t1.seats_name is not null
    and t2.users_id is not null 
    and t1.seats_name <>'O'
    group by case when t2.identify='troy' then 'troy'||'--'||t2.feature
else t2.identify end ,t2.feature_id,t2.feature_value
)h3 on h1.feature=h3.feature and nvl(h1.feature_value,'-')=nvl(h3.feature_value,'-') and nvl(h1.feature_id,0)=nvl(h3.feature_id,0)
where not exists (select 1 from hdb.wb_agent_rcd tt1
where tt1.client_id=h1.client_id)
and not exists(select 1 from dw.da_lyuser tt2
where tt2.users_id_fk is not null
and tt2.users_id_fk=h1.client_id)
and regexp_like(h1.feature,'(troy)|(去哪儿)|(金翔达商旅)|(特征库)')
)h2
where (h2.feature like '%troy%' or (h2.feature not like '%troy%' and h2.totalnum1>60))
and h2.pnum/h2.totalnum> 0.2;



  update  hdb.wb_agent_rcd_factor
 set factor_flag=1
 where client_Id in(
 select client_id
 from(
 select t1.client_id,t1.factor,t1.ticketnum,row_number()over(partition by t1.factor order by t1.ticketnum) srow
 from hdb.wb_agent_rcd_factor t1
 where  t1.factor=1
 group by t1.client_id,t1.factor,t1.ticketnum)h1
 where h1.srow<=4496);
 
 update  hdb.wb_agent_rcd_factor t1
 set factor_flag=1
 where  t1.factor=0.2;
 
 commit;
 
 
 update  hdb.wb_agent_rcd_factor
 set factor_flag=2
 where client_Id in(
 select client_id
 from(
 select t1.client_id,t1.factor,t1.ticketnum,row_number()over(partition by t1.factor order by t1.ticketnum) srow
 from hdb.wb_agent_rcd_factor t1
 where t1.factor=1
 group by t1.client_id,t1.factor,t1.ticketnum)h1
 where h1.srow>4496
 and h1.srow<=4496+3530);
 
 update  hdb.wb_agent_rcd_factor t1
 set factor_flag=2
 where  t1.factor=0.4;
 
 commit;
 
 
 
update  hdb.wb_agent_rcd_factor
 set factor_flag=3
 where client_Id in(
 select client_id
 from(
 select t1.client_id,t1.factor,t1.ticketnum,row_number()over(partition by t1.factor order by t1.ticketnum) srow
 from hdb.wb_agent_rcd_factor t1
 where  t1.factor=1
 group by t1.client_id,t1.factor,t1.ticketnum)h1
 where h1.srow>4496+3530
 and h1.srow<=4496+3530+2715);
 
    update  hdb.wb_agent_rcd_factor t1
 set factor_flag=3
 where  t1.factor=0.6;
 
 commit;
 
 
 update  hdb.wb_agent_rcd_factor
 set factor_flag=4
 where client_Id in(
 select client_id
 from(
 select t1.client_id,t1.factor,t1.ticketnum,row_number()over(partition by t1.factor order by t1.ticketnum) srow
 from hdb.wb_agent_rcd_factor t1
 where  t1.factor=1
 group by t1.client_id,t1.factor,t1.ticketnum)h1
 where h1.srow>4496+3530+2715
 and h1.srow<=4496+3530+2715+619);
 
 
     update  hdb.wb_agent_rcd_factor t1
 set factor_flag=4
 where  t1.factor=0.8;
 
 commit;
 
 
  update  hdb.wb_agent_rcd_factor
 set factor_flag=5
 where client_Id in(
 select client_id
 from(
 select t1.client_id,t1.factor,t1.ticketnum,row_number()over(partition by t1.factor order by t1.ticketnum) srow
 from hdb.wb_agent_rcd_factor t1
 where  t1.factor=1
 group by t1.client_id,t1.factor,t1.ticketnum)h1
 where h1.srow>4496+3530+2715+619
);

  update  hdb.wb_agent_rcd_factor t1
 set factor_flag=5
 where  t1.factor=1
 and t1.factor_flag is null;
 
 commit ;

 

=====================================以上为账号筛选机制=================================================





============================================代理跳舱数据分析========================================================================


select t1.order_day,case when t3.users_id is not null then '代理' 
else '非代理' end,
case when t3.users_id is not null and t2.client_id is not null and t1.order_day<=t2.create_date then '封杀前'
when t3.users_id is not null and t2.client_id is not null and t1.order_day> t2.create_date then '封杀后'
when t3.users_id is not null and t2.client_id is  null and t4.reg_day>=trunc(sysdate-60) then '新注册代理账号'
when t3.users_id is not null and t2.client_id is  null and t4.reg_day< trunc(sysdate-60) then '以前注册未使用账号'
end ,count(1)
from dw.fact_order_detail t1
join dw.da_flight t5 on t1.segment_head_id=t5.segment_head_id
left join hdb.wb_agent_rcd t2 on t1.client_id=t2.client_id
left join dw.da_restrict_userinfo t3 on t1.client_id=t3.users_id
left join dw.da_b2c_user t4 on t3.users_id=t4.users_id
where t1.order_day>=trunc(sysdate)-60
and t1.channel in('网站','手机')
and t1.company_id=0
and t1.seats_name is not null
and t5.flag<>2
group by t1.order_day,case when t3.users_id is not null then '代理' 
else '非代理' end,
case when t3.users_id is not null and t2.client_id is not null and t1.order_day<=t2.create_date then '封杀前'
when t3.users_id is not null and t2.client_id is not null and t1.order_day> t2.create_date then '封杀后'
when t3.users_id is not null and t2.client_id is  null and t4.reg_day>=trunc(sysdate-60) then '新注册代理账号'
when t3.users_id is not null and t2.client_id is  null and t4.reg_day< trunc(sysdate-60) then '以前注册未使用账号'
end;


select t2.batch_id,t2.create_date,
case when t3.users_id is not null and t2.client_id is not null and t1.order_day>t2.create_date then '封杀后'
when t3.users_id is not null and t2.client_id is not null and t1.order_day<=t2.create_date then '封杀前'
when t3.users_id is not null  then '未封杀代理' 
else '非代理' end,
case
         when t1.MIN_SEAT_NAME is null then
          '当前在售最低价'
         when t1.min_seat_price is null then
          '当前在售最低价'
         when round(t1.ticket_price,0)  = round(t1.min_seat_price * t1.rcd_rate,0) then
          '当前在售最低价'
         when round(t1.ticket_price,0)  > round(t1.min_seat_price * t1.rcd_rate,0) then
          '跳舱'
          when round(t1.ticket_price,0) < round(t1.min_seat_price * t1.rcd_rate,0) then '当前在售最低价'
       end 价格类型,
count(1),count(distinct t1.client_id),
sum(t1.ticket_price-t1.min_seat_price*t1.rcd_rate)
from dw.fact_order_detail t1
join dw.da_flight t4 on t1.segment_head_id=t4.segment_head_id
join hdb.wb_agent_rcd t2 on t1.client_id=t2.client_id
left join dw.da_restrict_userinfo t3 on t1.client_id=t3.users_id
where t1.order_day>=to_date('2018-10-23','yyyy-mm-dd')
and t1.seats_name is not NULL
and t1.seats_name not in('B','G','G1','G2','O')
and t1.company_id=0
and t4.flag<>2
group by  t2.batch_id,t2.create_date,
case when t3.users_id is not null and t2.client_id is not null and t1.order_day>t2.create_date then '封杀后'
when t3.users_id is not null and t2.client_id is not null and t1.order_day<=t2.create_date then '封杀前'
when t3.users_id is not null  then '未封杀代理' 
else '非代理' end,
case
         when t1.MIN_SEAT_NAME is null then
          '当前在售最低价'
         when t1.min_seat_price is null then
          '当前在售最低价'
         when round(t1.ticket_price,0)  = round(t1.min_seat_price * t1.rcd_rate,0) then
          '当前在售最低价'
         when round(t1.ticket_price,0)  > round(t1.min_seat_price * t1.rcd_rate,0) then
          '跳舱'
          when round(t1.ticket_price,0) < round(t1.min_seat_price * t1.rcd_rate,0) then '当前在售最低价'
       end;