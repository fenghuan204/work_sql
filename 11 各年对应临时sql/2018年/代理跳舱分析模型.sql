
#1\代理跳舱分析模型

select h1.reg_day 日期,h1.agentnum  注册代理账号数,h1.regnum 注册总数,h2.clientnum 代理下单账号
from(
select t1.reg_day,sum(case when t2.users_id is not null then 1
else 0 end) agentnum,count(1) regnum
from dw.da_b2c_user t1
left join dw.da_restrict_userinfo t2 on t1.users_id=t2.users_id
where t1.reg_day>=trunc(sysdate-30)
group by t1.reg_day)h1
join(
select t1.order_day,count(distinct t1.client_id) clientnum
from dw.fact_order_detail t1
join dw.da_restrict_userinfo t2 on t1.client_id=t2.users_id
where t1.order_day>=trunc(sysdate-30)
group by t1.order_day )h2 on h1.reg_day=h2.order_day;


#2\ 代理跳舱数据

select trunc(t.order_date) 订单日期,
       case
         when t1.ex_cfd2 = 'S' and t1.ex_nfd3 is not null then
          '商务经济座'
         when t1.ex_nfd10 is not null then
          '经济座'
         else
          '专享座'
       end 座位类型 ,
 /*      t1.seats_name 舱位,
       t3.min_seat_name 在售最低舱位,
       t1.ticket_price 票价,
       t1.r_com_rate 汇率,
       t3.min_seat_price 在售最低价格,
       t3.rate 最低价格汇率,*/
       case
         when t3.MIN_SEAT_NAME is null then
          '当前在售最低价'
         when t3.min_seat_price is null then
          '当前在售最低价'
         when t3.MIN_SEAT_NAME = t1.seats_name and
              t1.ticket_price * t1.r_com_rate = t3.min_seat_price * t3.RATE then
          '当前在售最低价'
         when t1.ticket_price * t1.r_com_rate >= t3.min_seat_price * t3.RATE then
          '跳舱'
          when t1.ticket_price*t1.r_com_rate< t3.min_seat_price*t3.RATE and t1.seats_name in('P2','P5')  then 'P活动价'
       end 价格类型,
       count(1) 票量
  from cqsale.cq_order@to_air t
  join cqsale.cq_order_head@to_air t1 on t.flights_order_id =
                                         t1.flights_order_id
  join hdb.wb_agent_rcd t2 on t.client_id = t2.CLIENT_ID
  left join cqsale.cq_min_price_rcd@to_air t3 on t3.ORDER_HEAD_ID =
                                                 t1.flights_order_head_id
 where t1.flag_id in (3, 5, 40)
   and t.order_date >= to_date('2018-10-25','yyyy-mm-dd')
   and t2.create_date< trunc(sysdate)  --需要修改成相对应批次
 group by trunc(t.order_date),
          case
            when t1.ex_cfd2 = 'S' and t1.ex_nfd3 is not null then
             '商务经济座'
            when t1.ex_nfd10 is not null then
             '经济座'
            else
             '专享座'
          end,
          case
            when t3.MIN_SEAT_NAME is null then
             '当前在售最低价'
            when t3.min_seat_price is null then
             '当前在售最低价'
            when t3.MIN_SEAT_NAME = t1.seats_name and
                 t1.ticket_price * t1.r_com_rate =
                 t3.min_seat_price * t3.RATE then
             '当前在售最低价'
            when t1.ticket_price * t1.r_com_rate >=
                 t3.min_seat_price * t3.RATE then
             '跳舱'
             when t1.ticket_price*t1.r_com_rate< t3.min_seat_price*t3.RATE and t1.seats_name in('P2','P5')  then 'P活动价'
          end/*,
          t1.seats_name,
          t3.min_seat_name,
          t1.ticket_price,
          t1.r_com_rate,
          t3.min_seat_price,
          t3.rate
*/;


封杀代理和未封杀代理、其他代理的票量

select t1.order_day,case when t3.users_id is not null then '代理' 
else '非代理' end,case when t3.users_id is not null and t2.client_id is not null then '封杀'
when t3.users_id is not null  then '未封杀代理' 
else '非代理' end,count(1)
from dw.fact_order_detail t1
left join hdb.wb_agent_rcd t2 on t1.client_id=t2.client_id
left join dw.da_restrict_userinfo t3 on t1.client_id=t3.users_id
where t1.order_day>=trunc(sysdate)-60
and t1.channel in('网站','手机')
and t1.company_id=0
group by t1.order_day,case when t3.users_id is not null then '代理' 
else '非代理' end,case when t3.users_id is not null and t2.client_id is not null then '封杀'
when t3.users_id is not null  then '未封杀代理' 
else '非代理' end;



=====================================================代理识别==========================================================================================


select count(1)
from hdb.wb_agent_rcd t1
join(
select h1.users_id
from(
select h1.users_id,h1.identify||h1.feature_value from dw.da_restrict_userinfo h1
where h1.feature_value in('15036620537','18439513330','18923780956')

union 

select h1.client_id,h1.feature||h1.feature_value
from hdb.wb_agent_rcd h1
where h1.feature_value in('15036620537','18439513330','18923780956')

union 

select  user_id,t1.memo
from cqsale.cq_user_restrict@to_air t1
where memo like '%深圳市汇鹏商务有限公司%'

union 

select t1.users_id,t1.feature
 from dw.da_restrict_userinfo t1
 where t1.feature like '%汇鹏商务%'

union 

select  t.client_id,null
from cqsale.cq_order@to_air  t
join cqsale.cq_Order_head@to_air t1 on t.flights_order_id=t1.flights_order_id 
where t.work_tel in('15036620537','18439513330','18923780956')
and t.client_id>0

union 


select  t.client_id,null
from cqsale.cq_order@to_air  t
join cqsale.cq_Order_head@to_air t1 on t.flights_order_id=t1.flights_order_id 
where t.email='huipengshangwu@163.com'
and t.client_id>0
)h1)h2 on t1.client_id=h2.users_id;


所有关联账号


select h1.users_id
from dw.da_restrict_userinfo h1
where h1.feature_value in('15036620537','18439513330','18923780956')

union 

select h1.client_id
from hdb.wb_agent_rcd h1
where h1.feature_value in('15036620537','18439513330','18923780956')

union 

select  user_id
from cqsale.cq_user_restrict@to_air t1
where memo like '%深圳市汇鹏商务有限公司%'

union 

select t1.users_id
 from dw.da_restrict_userinfo t1
 where t1.feature like '%汇鹏商务%'

union 

select  t.client_id
from cqsale.cq_order@to_air  t
join cqsale.cq_Order_head@to_air t1 on t.flights_order_id=t1.flights_order_id 
where t.work_tel in('15036620537','18439513330','18923780956')
and t.client_id>0

union 


select  t.client_id
from cqsale.cq_order@to_air  t
join cqsale.cq_Order_head@to_air t1 on t.flights_order_id=t1.flights_order_id 
where t.email='huipengshangwu@163.com'
and t.client_id>0

=====================================================20181126 代理跳舱数据分析==================================================================


select t1.order_day,
case when t1.channel in('手机','网站') then 
case when t3.users_id is not null then '线上自营代理' 
else '线上自营纯量' end
when t1.channel in('OTA','旗舰店') then 'OTA+旗舰店'
else '其他渠道' end,
case when t1.channel in('手机','网站') then 
case when t3.users_id is not null and t2.client_id is not null and t1.order_day>t2.create_date then '封杀后'
when t3.users_id is not null and t2.client_id is not null and t1.order_day<=t2.create_date then '封杀前'
when t3.users_id is not null  then '未封杀代理' 
else '非代理' end
else '其他' end,
case
         when t1.MIN_SEAT_NAME is null then
          '当前在售最低价'
         when t1.min_seat_price is null then
          '当前在售最低价'
         when t1.MIN_SEAT_NAME = t1.seats_name and
              t1.ticket_price  = t1.min_seat_price * t1.rcd_rate then
          '当前在售最低价'
         when t1.ticket_price  >= t1.min_seat_price * t1.rcd_rate then
          '跳舱'
          when t1.ticket_price < t1.min_seat_price * t1.rcd_rate and t1.seats_name in('P2','P5')  then '当前在售最低价'
       end 价格类型,
count(1)
from dw.fact_order_detail t1
join dw.da_flight t4 on t1.segment_head_id=t4.segment_head_id
left join hdb.wb_agent_rcd t2 on t1.client_id=t2.client_id
left join dw.da_restrict_userinfo t3 on t1.client_id=t3.users_id
where t1.order_day>=to_date('2018-10-01','yyyy-mm-dd')
and t1.seats_name is not NULL
and t1.seats_name not in('B','G','G1','G2','O')
and t1.company_id=0
and t4.flag<>2
group by t1.order_day,
case when t1.channel in('手机','网站') then 
case when t3.users_id is not null then '线上自营代理' 
else '线上自营纯量' end
when t1.channel in('OTA','旗舰店') then 'OTA+旗舰店'
else '其他渠道' end,
case when t1.channel in('手机','网站') then 
case when t3.users_id is not null and t2.client_id is not null and t1.order_day>t2.create_date then '封杀后'
when t3.users_id is not null and t2.client_id is not null and t1.order_day<=t2.create_date then '封杀前'
when t3.users_id is not null  then '未封杀代理' 
else '非代理' end
else '其他' end,
case
         when t1.MIN_SEAT_NAME is null then
          '当前在售最低价'
         when t1.min_seat_price is null then
          '当前在售最低价'
         when t1.MIN_SEAT_NAME = t1.seats_name and
              t1.ticket_price  = t1.min_seat_price * t1.rcd_rate then
          '当前在售最低价'
         when t1.ticket_price  >= t1.min_seat_price * t1.rcd_rate then
          '跳舱'
          when t1.ticket_price < t1.min_seat_price * t1.rcd_rate and t1.seats_name in('P2','P5')  then '当前在售最低价'
       end;


##  跳舱账号后续情况

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


#后续账号代理账号变化
select h1.reg_day,h1.type,case when h2.client_id is not null then '是'
else '否' end,count(1),suM(h2.ticketnum)
from(
select t1.reg_day,t1.reg_date,case when t2.users_id is not null then 1
else 0 end type,t1.users_id
from dw.da_b2c_user t1
left join dw.da_restrict_userinfo t2 on t1.users_id=t2.users_id
where t1.reg_day>=to_date('2018-10-01','yyyy-mm-dd'))h1
left join (select t3.client_id,count(1) ticketnum
              from dw.fact_order_detail t3
                     where t3.channel in('网站','手机')
              and t3.order_day>=to_date('2018-10-01','yyyy-mm-dd')
              and t3.seats_name is not null
              group by t3.client_id)h2 on h1.users_id=h2.client_id
              group by h1.reg_day,h1.type,case when h2.client_id is not null then '是'
else '否' end;



