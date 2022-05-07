
=================================================202002============================

--1、投诉数据整理

create table hdb.temp_feng_02103 as
select h1.id,h1.flights_order_id,h1.sname,h1.codeno,h1.flight_date,h1.flag1,h1.flag2,h1.flag3,h1.tname,h1.flag_id,h1.r_order_date,
h1.money_date,h1.money_fy,h1.status,h1.r_flights_date,h1.flightdate,h1.flag,h1.type,h1.content,sum(count(1))over(partition by h1.id,h1.flights_order_id) idnum,
row_number()over(partition by h1.id,h1.flights_order_id order by flag desc) xid
from(
select t.id,t.flights_order_id,t.sname,t.codeno,t.flight_date,t.flag1,t.flag2,t.flag3,t1.name||' '||coalesce(t1.second_name,'') tname,
case when t1.flag_id in(7,11,12) then '退票'
when t1.flag_id in(3,5,41) then '已售'
when t1.flag_id =40 then '已乘机' end flag_id,
t1.r_order_date,t2.money_date,t2.money_fy,decode(t3.flag,2,'取消','正常') status,t1.r_flights_date,
to_char(t1.r_flights_date,'yyyy-mm-dd') flightdate,
case when t.sname is not null and t.flight_date is not null then 
case when trim(t.sname) =trim(t1.name||' '||coalesce(t1.second_name,'')) and to_date(t.flight_date,'yyyy-mm-dd')=t1.r_flights_date then 2
when trim(t.sname) =trim(t1.name||' '||coalesce(t1.second_name,''))  then -1
else -2 end 
else 1 end flag,
case when t1.r_order_date< to_date('2020-01-24','yyyy-mm-dd')
      and t1.r_flights_date>=to_date('2020-01-24','yyyy-mm-dd')   and t2.money_date< to_date('2020-01-24','yyyy-mm-dd')  
    then '符合24号规则但在24号之前退票'
    when t1.r_order_date< to_date('2020-01-24','yyyy-mm-dd')
      and t1.r_flights_date>=to_date('2020-01-24','yyyy-mm-dd')   and t2.money_date>=t3.origin_std
    then '符合24号规则但离站后退票'
     when t1.r_order_date< to_date('2020-01-28','yyyy-mm-dd')
      and t1.r_flights_date>=to_date('2020-01-28','yyyy-mm-dd')   and t2.money_date< to_date('2020-01-28','yyyy-mm-dd')  then '符合28号规则但在28号之前退票'
         when t1.r_order_date< to_date('2020-01-28','yyyy-mm-dd')
      and t1.r_flights_date>=to_date('2020-01-28','yyyy-mm-dd')   and t2.money_date>=t3.origin_std  then '符合28号规则但在离站后退票 '
when t1.r_order_date< to_date('2020-01-24','yyyy-mm-dd')
      and t1.r_flights_date>=to_date('2020-01-24','yyyy-mm-dd')  then '符合24号规则'
    when t1.r_order_date< to_date('2020-01-28','yyyy-mm-dd')
      and t1.r_flights_date>=to_date('2020-01-28','yyyy-mm-dd')  then '符合28号规则'
    else '其他' end type,
	t.content 
 from hdb.temp_feng_0210 t
left join cqsale.cq_order_head@to_air t1 on t.flights_order_id=t1.flights_order_id and t1.flag_id in(3,5,40,41,7,11,12)
left join dw.da_order_drawback t2 on t1.flights_order_head_id=t2.flights_order_head_id
left join dw.da_flight t3 on t1.segment_head_id=t3.segment_head_id)h1
group by h1.id,h1.flights_order_id,h1.sname,h1.codeno,h1.flight_date,h1.flag1,h1.flag2,h1.flag3,h1.tname,h1.flag_id,h1.r_order_date,
h1.money_date,h1.money_fy,h1.status,h1.r_flights_date,h1.flightdate,h1.flag,h1.type;



select * from hdb.temp_feng_02103 t1
where t1.idnum =1 
or (t1.idnum>=2 and t1.xid=1);


----2、退票数据

select /*+parallel(4) */
trunc(d.money_date) 退票日期,
       case
         when d.money_fy = 0 then
          '免费'
         else
          '收费'
       end 是否收费,
       case
         when t1.order_date < to_date('2020-01-24', 'yyyy-mm-dd') and
              d.origin_std >= to_date('2020-01-24', 'yyyy-mm-dd')               
              and d.money_date< to_date('2020-01-24', 'yyyy-mm-dd') 
              then
          '类型1但24号之前退'
         when t1.order_date < to_date('2020-01-24', 'yyyy-mm-dd') and
              d.origin_std >= to_date('2020-01-24', 'yyyy-mm-dd') 
              and d.money_date>d.origin_std 
              then
          '类型1但离站后退'
         when t1.order_date < to_date('2020-01-24', 'yyyy-mm-dd') and
              d.origin_std >= to_date('2020-01-24', 'yyyy-mm-dd') then
          '类型1' 
           when t1.order_date < to_date('2020-01-28', 'yyyy-mm-dd') and
              d.origin_std >= to_date('2020-01-28', 'yyyy-mm-dd') 
              and d.money_date< to_date('2020-01-28', 'yyyy-mm-dd')
                then  '类型2但28号前退'           
              
          when t1.order_date < to_date('2020-01-28', 'yyyy-mm-dd') and
              d.origin_std >= to_date('2020-01-28', 'yyyy-mm-dd') 
              and d.money_date>d.origin_std  then
          '类型2但离站后退'         
         when t1.order_date < to_date('2020-01-28', 'yyyy-mm-dd') and
              d.origin_std >= to_date('2020-01-28', 'yyyy-mm-dd') then
          '类型2'
         else
          '类型3'
       end 政策类型,
       sum(case when d.seats_name is not null then 1 else 0 end)  退票数,
       sum(d.money_fy) 退票手续费,
       sum(t1.ticket_price) 票价和,
       sum(t1.ad_fy) 燃油和
  from dw.da_order_drawback d
  left join dw.fact_recent_order_detail t1 on t1.flights_order_head_id =
                                 d.flights_order_head_id
 where d.money_date >= to_date('2020-01-20', 'yyyy-mm-dd')
   and d.money_date < to_date('2020-02-10', 'yyyy-mm-dd')
 group by trunc(d.money_date),
          case
            when d.money_fy = 0 then
             '免费'
            else
             '收费'
          end,
           case
         when t1.order_date < to_date('2020-01-24', 'yyyy-mm-dd') and
              d.origin_std >= to_date('2020-01-24', 'yyyy-mm-dd')               
              and d.money_date< to_date('2020-01-24', 'yyyy-mm-dd') 
              then
          '类型1但24号之前退'
         when t1.order_date < to_date('2020-01-24', 'yyyy-mm-dd') and
              d.origin_std >= to_date('2020-01-24', 'yyyy-mm-dd') 
              and d.money_date>d.origin_std 
              then
          '类型1但离站后退'
         when t1.order_date < to_date('2020-01-24', 'yyyy-mm-dd') and
              d.origin_std >= to_date('2020-01-24', 'yyyy-mm-dd') then
          '类型1' 
           when t1.order_date < to_date('2020-01-28', 'yyyy-mm-dd') and
              d.origin_std >= to_date('2020-01-28', 'yyyy-mm-dd') 
              and d.money_date< to_date('2020-01-28', 'yyyy-mm-dd')
                then  '类型2但28号前退'           
              
          when t1.order_date < to_date('2020-01-28', 'yyyy-mm-dd') and
              d.origin_std >= to_date('2020-01-28', 'yyyy-mm-dd') 
              and d.money_date>d.origin_std  then
          '类型2但离站后退'         
         when t1.order_date < to_date('2020-01-28', 'yyyy-mm-dd') and
              d.origin_std >= to_date('2020-01-28', 'yyyy-mm-dd') then
          '类型2'
         else
          '类型3'
       end;
	   
	   
	 ---3\\\李诚数据分析
	 
	 
	 select h1.flight_date 航班日期,h1.flight_no 航班号,h1.flights_segment_name 航段,h1.nationflag 航线性质,h1.sdate 操作日期,h1.sdatetype 操作周,sum(h1.ticketnum) 销售数,sum(h1.backnum) 退票数,sum(h1.orderprice) 订单机票燃油和,
sum(h1.backprice) 退票机票燃油和
from(
select t2.flight_date ,t2.flight_no ,t2.flights_segment_name ,t2.nationflag ,t3.order_day sdate,nvl(t3.ticketnum,0) ticketnum,0 backnum，
nvl(t3.allprice,0)  orderprice,0 backprice,
case  when t3.order_day>=trunc(sysdate)-7 then '本周'
when t3.order_day>=trunc(sysdate-14) and t3.order_day<=trunc(sysdate-8) then '上周' end sdatetype
   from  dw.da_flight t2
   left join (select  t1.segment_head_id,t1.order_day,sum(case when t1.seats_name is not null then 1 else 0 end) ticketnum,
                               sum(t1.ticket_price+t1.ad_fy) allprice
                       from dw.fact_order_detail t1
					   where t1.order_day>=trunc(sysdate-14)
					       and t1.order_day< trunc(sysdate)
						   and t1.flights_date>=trunc(sysdate)
						   and t1.flights_date<=trunc(sysdate+14)
						   and t1.company_id=0			       
            group by t1.segment_head_id,t1.order_day
             )t3  on t2.segment_head_id=t3.segment_head_id
   where t2.flight_date>=trunc(sysdate)
      and  t2.flight_date<= trunc(sysdate+14)
    and t2.flag<>2
    and t2.company_id=0
   
union all

select t2.flight_date,t2.flight_no,t2.flights_segment_name,t2.nationflag,t3.moneyday,0,nvl(t3.ticketnum,0) ticketnum,0 orderprice,
nvl(t3.allprice,0)  backprice,
case  when t3.moneyday>=trunc(sysdate)-7 then '本周'
when t3.moneyday>=trunc(sysdate-14) and t3.moneyday<=trunc(sysdate-8) then '上周' end 
   from  dw.da_flight t2
   left join (select  t1.segment_head_id,trunc(t1.money_date) moneyday,sum(case when t1.seats_name is not null then 1 else 0 end) ticketnum,
                               sum(t2.ticket_price+t2.ad_fy) allprice
                       from dw.da_order_drawback t1
             left join dw.fact_recent_order_detail t2 on t1.flights_order_head_id=t2.flights_order_head_id
             where t1.money_date>=trunc(sysdate-14)
                 and t1.money_date< trunc(sysdate)
               and t1.origin_std>=trunc(sysdate)
               and t1.origin_std< trunc(sysdate+15)           
            group by t1.segment_head_id,trunc(t1.money_date) 
             )t3  on t2.segment_head_id=t3.segment_head_id
   where t2.flight_date>=trunc(sysdate)
      and  t2.flight_date<= trunc(sysdate+14)
    and t2.flag<>2
    and t2.company_id=0)h1
  group by h1.flight_date,h1.flight_no,h1.flights_segment_name,h1.nationflag,h1.sdate,h1.sdatetype;
  
 
 ----4\ 统计局数据
 
 select /*+parallel(4) */
t1.flights_date,sum(case when t1.flag_id in(3,5,41,7,11,12) then 1 else 0 end),
sum(case when t1.flag_id in(3,5,41,7,11,12) then t1.ticket_price+t1.ad_fy+t1.port_pay+t1.other_fy+t1.insurce_fee+t1.other_fee+t1.sx_fy else 0 end),
sum(case when t1.flag_id =40 then 1 else 0 end),
sum(case when t1.flag_id =40 then t1.ticket_price+t1.ad_fy+t1.port_pay+t1.other_fy+t1.insurce_fee+t1.other_fee+t1.sx_fy else 0 end)
  from dw.fact_recent_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  where t1.flights_date>=to_date('2020-01-01','yyyy-mm-dd')
    and t1.flights_date< trunc(sysdate)
    and t1.whole_flight like '9C%'
    group by t1.flights_date;


	
---5\\ 投诉数据整理--投诉分析


select /*+parallel(4) */
 t1.flights_date,
       case when t1.order_date < to_date('2020-01-24','yyyy-mm-dd') and t2.origin_std>=to_date('2020-01-24','yyyy-mm-dd') 
               and t2.origin_std< sysdate  then '符合规则1但已离站'
         when t1.order_date < to_date('2020-01-24','yyyy-mm-dd') and t2.origin_std>=to_date('2020-01-24','yyyy-mm-dd') 
               and t2.origin_std> sysdate  then '符合免费退规则1'
         when t1.order_date < to_date('2020-01-28','yyyy-mm-dd') and t2.origin_std>=to_date('2020-01-28','yyyy-mm-dd') 
               and t2.origin_std< sysdate  then '符合规则2但已离站'
         when t1.order_date < to_date('2020-01-28','yyyy-mm-dd') and t2.origin_std>=to_date('2020-01-28','yyyy-mm-dd') 
               and t2.origin_std> sysdate  then '符合免费退规则2'
         when t1.order_date>=to_date('2020-01-24','yyyy-mm-dd') and t1.order_date< to_date('2020-01-28','yyyy-mm-dd')
         and t2.origin_std>=to_date('2020-01-24','yyyy-mm-dd')  and t2.origin_std< to_date('2020-01-28','yyyy-mm-dd')  then '规则1与2之间'
         else '其他' end,
         sum(t1.ticket_price),
         count(1)
 from dw.fact_order_detail t1
 join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
 left join dw.da_restrict_userinfo t3 on t1.client_id=t3.users_id
 where t1.flag_id in(3,5,41)
   and t1.flights_date>=to_date('2020-01-24','yyyy-mm-dd')
   and t1.company_id=0
   group by t1.flights_date,
       case when t1.order_date < to_date('2020-01-24','yyyy-mm-dd') and t2.origin_std>=to_date('2020-01-24','yyyy-mm-dd') 
               and t2.origin_std< sysdate  then '符合规则1但已离站'
         when t1.order_date < to_date('2020-01-24','yyyy-mm-dd') and t2.origin_std>=to_date('2020-01-24','yyyy-mm-dd') 
               and t2.origin_std> sysdate  then '符合免费退规则1'
         when t1.order_date < to_date('2020-01-28','yyyy-mm-dd') and t2.origin_std>=to_date('2020-01-28','yyyy-mm-dd') 
               and t2.origin_std< sysdate  then '符合规则2但已离站'
         when t1.order_date < to_date('2020-01-28','yyyy-mm-dd') and t2.origin_std>=to_date('2020-01-28','yyyy-mm-dd') 
               and t2.origin_std> sysdate  then '符合免费退规则2'
         when t1.order_date>=to_date('2020-01-24','yyyy-mm-dd') and t1.order_date< to_date('2020-01-28','yyyy-mm-dd')
         and t2.origin_std>=to_date('2020-01-24','yyyy-mm-dd')  and t2.origin_std< to_date('2020-01-28','yyyy-mm-dd')  then '规则1与2之间'
         else '其他' end;
		 
		 
		 
		 select trunc(d.money_date) 退票日期,
       case
         when d.money_fy = 0 then
          '免费'
         else
          '收费'
       end 是否收费,
       case
         when t1.order_date < to_date('2020-01-24', 'yyyy-mm-dd') and
              d.origin_std >= to_date('2020-01-24', 'yyyy-mm-dd') 
              and d.money_date>d.origin_std 
              then
          '类型1但离站后退'
         when t1.order_date < to_date('2020-01-24', 'yyyy-mm-dd') and
              d.origin_std >= to_date('2020-01-24', 'yyyy-mm-dd') then
          '类型1' 
          when t1.order_date < to_date('2020-01-28', 'yyyy-mm-dd') and
              d.origin_std >= to_date('2020-01-28', 'yyyy-mm-dd') 
              and d.money_date>d.origin_std  then
          '类型2但离站后退'         
         when t1.order_date < to_date('2020-01-28', 'yyyy-mm-dd') and
              d.origin_std >= to_date('2020-01-28', 'yyyy-mm-dd') then
          '类型2'
         else
          '类型3'
       end 政策类型,
       sum(case when d.seats_name is not null then 1 else 0 end)  退票数,
       sum(d.money_fy) 退票手续费,
       sum(t1.ticket_price) 票价和,
       sum(t1.ad_fy) 燃油和
  from dw.da_order_drawback d
  left join dw.fact_recent_order_detail t1 on t1.flights_order_head_id =
                                 d.flights_order_head_id
 where d.money_date >= to_date('2020-01-20', 'yyyy-mm-dd')
   and d.money_date < to_date('2020-02-10', 'yyyy-mm-dd')
 group by trunc(d.money_date),
          case
            when d.money_fy = 0 then
             '免费'
            else
             '收费'
          end,
           case
         when t1.order_date < to_date('2020-01-24', 'yyyy-mm-dd') and
              d.origin_std >= to_date('2020-01-24', 'yyyy-mm-dd') 
              and d.money_date>d.origin_std 
              then
          '类型1但离站后退'
         when t1.order_date < to_date('2020-01-24', 'yyyy-mm-dd') and
              d.origin_std >= to_date('2020-01-24', 'yyyy-mm-dd') then
          '类型1' 
          when t1.order_date < to_date('2020-01-28', 'yyyy-mm-dd') and
              d.origin_std >= to_date('2020-01-28', 'yyyy-mm-dd') 
              and d.money_date>d.origin_std  then
          '类型2但离站后退'         
         when t1.order_date < to_date('2020-01-28', 'yyyy-mm-dd') and
              d.origin_std >= to_date('2020-01-28', 'yyyy-mm-dd') then
          '类型2'
         else
          '类型3'
       end;
		 
		
---6\\ 绿翼会员引导奖励


select h1.*,h2.cards_reward,h2.tickets_reward
from(
select  to_char(t1.check_date,'yyyymm') 月份,
t1.check_origin,
       decode(t1.check_origin,1,'智慧客舱',2,'HCC',3,'旅客刷登机牌',4,'B2B'),
--t1.users_id,
       SUBSTR(t1.air_crew, 1, INSTR(t1.air_crew, '/') - 1) V_USERS_ID,
       SUBSTR(air_crew,
              INSTR(air_crew, '/') + 1,
              INSTR(air_crew, '/', 1, 2) - INSTR(air_crew, '/', 1, 1) - 1) V_FIRST_DEPARTMENT,
       SUBSTR(air_crew,
              INSTR(air_crew, '/', 1, 2) + 1,
              INSTR(air_crew, '/', 1, 3) - INSTR(air_crew, '/', 1, 2) - 1) V_SECOND_DEPARTMENT,
       case
         when t1.CHECK_ORIGIN = 4 then
          SUBSTR(air_crew, INSTR(air_crew, '/', 1, 3) + 1)
         else
          SUBSTR(air_crew, INSTR(air_crew, '/', 1, 4) + 1)
       end V_USERS_NAME,  
       count(1) clientnum,
       sum(case when t4.users_id is not null then 1
      else 0 end) agentnum,
      0 ticketnum,
      0 agentticketnum
  from cust.cq_apply_lyhy@to_air t1
  left join dw.da_restrict_userinfo t4 on t1.users_id=t4.users_id
 where t1.check_date >= to_date('2019-08-01', 'yyyy-mm-dd')
   and t1.check_date <  to_date('2020-02-01', 'yyyy-mm-dd')
   and t1.flag = 2
   group by to_char(t1.check_date,'yyyymm'),
t1.check_origin,
       decode(t1.check_origin,1,'智慧客舱',2,'HCC',3,'旅客刷登机牌',4,'B2B'),
--t1.users_id,
       SUBSTR(t1.air_crew, 1, INSTR(t1.air_crew, '/') - 1) ,
       SUBSTR(air_crew,
              INSTR(air_crew, '/') + 1,
              INSTR(air_crew, '/', 1, 2) - INSTR(air_crew, '/', 1, 1) - 1) ,
       SUBSTR(air_crew,
              INSTR(air_crew, '/', 1, 2) + 1,
              INSTR(air_crew, '/', 1, 3) - INSTR(air_crew, '/', 1, 2) - 1) ,
       case
         when t1.CHECK_ORIGIN = 4 then
          SUBSTR(air_crew, INSTR(air_crew, '/', 1, 3) + 1)
         else
          SUBSTR(air_crew, INSTR(air_crew, '/', 1, 4) + 1)
       end 
 
                    
     union all
                   
         


-

select  to_char(t1.order_date,'yyyymm'),
t1.check_origin,
       decode(t1.check_origin,1,'智慧客舱',2,'HCC',3,'旅客刷登机牌',4,'B2B'),
--t1.users_id,
       SUBSTR(t1.air_crew, 1, INSTR(t1.air_crew, '/') - 1) V_USERS_ID,
       SUBSTR(air_crew,
              INSTR(air_crew, '/') + 1,
              INSTR(air_crew, '/', 1, 2) - INSTR(air_crew, '/', 1, 1) - 1) V_FIRST_DEPARTMENT,
       SUBSTR(air_crew,
              INSTR(air_crew, '/', 1, 2) + 1,
              INSTR(air_crew, '/', 1, 3) - INSTR(air_crew, '/', 1, 2) - 1) V_SECOND_DEPARTMENT,
       case
         when t1.CHECK_ORIGIN = 4 then
          SUBSTR(air_crew, INSTR(air_crew, '/', 1, 3) + 1)
         else
          SUBSTR(air_crew, INSTR(air_crew, '/', 1, 4) + 1)
       end V_USERS_NAME,
       --t1.order_date,
       --t1.check_date,
       --t1.check_card_type,
       --t1.check_card_no,  
       0,
       0,    
       count(1) 票量,
       sum(case when t4.users_id is not null then 1
      else 0 end) 代理购票量
  from cust.cq_apply_lyhy@to_air t1
  join cqsale.cq_order_head@to_air t3 on t1.check_card_type = t3.codetype
                                     and t1.check_card_no = t3.codeno
  left join dw.da_restrict_userinfo t4 on t1.users_id=t4.users_id
 where t1.order_date >= to_date('2019-08-01', 'yyyy-mm-dd')
   and t1.order_date <  to_date('2020-02-01', 'yyyy-mm-dd')
   and t3.r_order_date > t1.check_date
   and t3.flag_Id  in(3,5,40)
   and t1.flag = 2
   and t1.order_flag = 1
   and trunc(t1.order_date) = trunc(t3.r_order_date)
 group by to_char(t1.order_date,'yyyymm'),
  t1.check_origin,
       decode(t1.check_origin,1,'智慧客舱',2,'HCC',3,'旅客刷登机牌',4,'B2B'),
       SUBSTR(t1.air_crew, 1, INSTR(t1.air_crew, '/') - 1) ,
       SUBSTR(air_crew,
              INSTR(air_crew, '/') + 1,
              INSTR(air_crew, '/', 1, 2) - INSTR(air_crew, '/', 1, 1) - 1) ,
       SUBSTR(air_crew,
              INSTR(air_crew, '/', 1, 2) + 1,
              INSTR(air_crew, '/', 1, 3) - INSTR(air_crew, '/', 1, 2) - 1) ,
       case
         when t1.CHECK_ORIGIN = 4 then
          SUBSTR(air_crew, INSTR(air_crew, '/', 1, 3) + 1)
         else
          SUBSTR(air_crew, INSTR(air_crew, '/', 1, 4) + 1)
       end )h1
       left join stg.c_cq_lyhy_reward_rules h2 on h2.flag=1 and h1.check_origin=h2.check_origin;
	   
	   
======================================20200211===============================================================

--7\\ 退票损失查找

  select /*+parallel(4) */
 t1.flights_date 航班日期, 
 case when t1.flag_id in(3,5,41) then '已售未乘机'
 when t1.flag_id in(7,11,12) then '已退票' end ,    
       case 
         when t1.order_date < to_date('2020-01-24', 'yyyy-mm-dd') and
              t2.origin_std >= to_date('2020-01-24', 'yyyy-mm-dd') 
              and d.money_date>d.origin_std 
              then '不符合规则'
         when t1.order_date < to_date('2020-01-24', 'yyyy-mm-dd') and
              t2.origin_std >= to_date('2020-01-24', 'yyyy-mm-dd') 
              and d.money_date< to_date('2020-01-24', 'yyyy-mm-dd') 
              then '不符合规则'
         when t1.order_date < to_date('2020-01-24', 'yyyy-mm-dd') and
              t2.origin_std >= to_date('2020-01-24', 'yyyy-mm-dd')
              and t2.origin_std< trunc(sysdate) and t1.flag_id in(3,5,41) then
          '不符合规则' 
           when t1.order_date < to_date('2020-01-24', 'yyyy-mm-dd') and
              t2.origin_std >= to_date('2020-01-24', 'yyyy-mm-dd') then
          '符合规则' 
          when t1.order_date < to_date('2020-01-28', 'yyyy-mm-dd') and
              t2.origin_std >= to_date('2020-01-28', 'yyyy-mm-dd') 
              and d.money_date>d.origin_std  then
          '不符合规则'
          when t1.order_date < to_date('2020-01-28', 'yyyy-mm-dd') and
              t2.origin_std >= to_date('2020-01-28', 'yyyy-mm-dd') 
              and d.money_date< to_date('2020-01-28', 'yyyy-mm-dd') then
          '不符合规则'   
           when t1.order_date < to_date('2020-01-28', 'yyyy-mm-dd') and
              t2.origin_std >= to_date('2020-01-28', 'yyyy-mm-dd') 
              and t2.origin_std< trunc(sysdate) and t1.flag_id in(3,5,41) then
          '不符合规则'        
         when t1.order_date < to_date('2020-01-28', 'yyyy-mm-dd') and
              t2.origin_std >= to_date('2020-01-28', 'yyyy-mm-dd') then
          '符合规则'
         else
          '不符合规则'
       end 政策类型,
       count(1)  退票数,
       sum(t1.ticket_price) 票价和
  from dw.fact_recent_order_detail t1
  left join dw.da_order_drawback d  on t1.flights_order_head_id =d.flights_order_head_id
  left join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
 where t1.flights_date >= to_date('2020-01-24', 'yyyy-mm-dd')
   and t1.flag_id in(3,5,41,7,11,12)    
 group by t1.flights_date ,     
       case when t1.flag_id in(3,5,41) then '已售未乘机'
 when t1.flag_id in(7,11,12) then '已退票' end ,    
       case 
         when t1.order_date < to_date('2020-01-24', 'yyyy-mm-dd') and
              t2.origin_std >= to_date('2020-01-24', 'yyyy-mm-dd') 
              and d.money_date>d.origin_std 
              then '不符合规则'
         when t1.order_date < to_date('2020-01-24', 'yyyy-mm-dd') and
              t2.origin_std >= to_date('2020-01-24', 'yyyy-mm-dd') 
              and d.money_date< to_date('2020-01-24', 'yyyy-mm-dd') 
              then '不符合规则'
         when t1.order_date < to_date('2020-01-24', 'yyyy-mm-dd') and
              t2.origin_std >= to_date('2020-01-24', 'yyyy-mm-dd')
              and t2.origin_std< trunc(sysdate) and t1.flag_id in(3,5,41) then
          '不符合规则' 
           when t1.order_date < to_date('2020-01-24', 'yyyy-mm-dd') and
              t2.origin_std >= to_date('2020-01-24', 'yyyy-mm-dd') then
          '符合规则' 
          when t1.order_date < to_date('2020-01-28', 'yyyy-mm-dd') and
              t2.origin_std >= to_date('2020-01-28', 'yyyy-mm-dd') 
              and d.money_date>d.origin_std  then
          '不符合规则'
          when t1.order_date < to_date('2020-01-28', 'yyyy-mm-dd') and
              t2.origin_std >= to_date('2020-01-28', 'yyyy-mm-dd') 
              and d.money_date< to_date('2020-01-28', 'yyyy-mm-dd') then
          '不符合规则'   
           when t1.order_date < to_date('2020-01-28', 'yyyy-mm-dd') and
              t2.origin_std >= to_date('2020-01-28', 'yyyy-mm-dd') 
              and t2.origin_std< trunc(sysdate) and t1.flag_id in(3,5,41) then
          '不符合规则'        
         when t1.order_date < to_date('2020-01-28', 'yyyy-mm-dd') and
              t2.origin_std >= to_date('2020-01-28', 'yyyy-mm-dd') then
          '符合规则'
         else
          '不符合规则'
       end;
	   
	   
----8、莫莹，1984年出生的，上海人
能否帮我找下这个人吗？ 大概2012年做的航班。

select /*+parallel(4) */
t1.flights_order_id 订单号,
t1.r_order_date 订单日期,t1.r_flights_date 航班日期,t1.whole_flight 航班号,t1.whole_segment 航段,
t1.name||coalesce(t1.second_name,'') 姓名,t1.codeno 证件号,t1.r_tel 联系方式
from stg.s_cq_order_head t1
where t1.flag_id=40
and t1.r_flights_date>=to_date('2012-01-01','yyyy-mm-dd')
and t1.r_flights_date< to_date('2013-01-01','yyyy-mm-dd')
and t1.name||coalesce(t1.second_name,'')='莫莹'
and t1.flights_order_head_id=49790784;





==========================================20200212===========================================

---9\\ 学生退改数据

select /*+parallel(6) */
t3.age,count(1),sum(t1.ticket_price)
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  join dw.bi_order_region t3 on t1.flights_order_head_id=t3.flights_order_head_id
  where t1.order_date< to_date('2020-02-11','yyyy-mm-dd')
    and t1.flights_date>=to_date('2020-02-11','yyyy-mm-dd')
    and t1.flights_date< to_date('2020-04-01','yyyy-mm-dd')
    and t1.company_id=0
    and t3.age<=24
    group by  t3.age;
    
    
    
    select /*+parallel(6) */
     t1.flights_date, case when t3.money_date< to_date('2020-01-24','yyyy-mm-dd') then '24号之前退票'
    when t3.money_date>= to_date('2020-01-24','yyyy-mm-dd') then '24号之后退票'
    else '未退票' end,count(1)    
  from dw.fact_recent_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  left join dw.da_order_drawback t3 on t1.flights_order_head_id=t3.flights_order_head_id
  where t1.flights_date>=to_date('2020-01-24','yyyy-mm-dd')
    and t1.flights_date< to_date('2020-04-01','yyyy-mm-dd')
    and t1.order_date< to_date('2020-01-24','yyyy-mm-dd')
    and t2.flag<>2
    group by t1.flights_date, case when t3.money_date< to_date('2020-01-24','yyyy-mm-dd') then '24号之前退票'
    when t3.money_date>= to_date('2020-01-24','yyyy-mm-dd') then '24号之后退票'
    else '未退票' end;
	
	
	select /*+parallel(4) */
t1.flights_date,t3.age,count(1),sum(t1.ticket_price)
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  join dw.bi_order_region t3 on t1.flights_order_head_id=t3.flights_order_head_id
  where t1.order_date< to_date('2020-02-11','yyyy-mm-dd')
    and t1.flights_date>=to_date('2020-02-11','yyyy-mm-dd')
    and t1.flights_date< to_date('2020-04-01','yyyy-mm-dd')
    and t1.company_id=0
    and t3.age<=24
    and t3.age>=3
    group by  t1.flights_date,t3.age;  
	
	
	select trunc(t1.origin_std),count(1)
 from hdb.temp_feng_back_today t1
where t1.apply_memo like '%学生%'
--and t1.money_fy=0
group by trunc(t1.origin_std)



----10\ 总办要求的退票量、退票机票的营收

 select trunc(d.money_date) 退票日期,
       case
         when d.money_fy = 0 then
          '免费'
         else
          '收费'
       end 是否收费,
       sum(case when d.seats_name is not null then 1 else 0 end)  退票数,
       sum((t1.ticket_price+t1.ad_fy+t1.port_pay+t1.sx_fy+t1.other_fy+t1.insurance_fee+t1.other_fee)*nvl(t1.r_com_rate,1)) 退票机票营收
  from dw.da_order_drawback d
  join cqsale.cq_order_head@to_air t1 on t1.flights_order_head_id = d.flights_order_head_id
 where d.money_date >= to_date('2020-01-01', 'yyyy-mm-dd')
   and d.money_date < to_date('2020-02-10', 'yyyy-mm-dd')
 group by trunc(d.money_date),
       case
         when d.money_fy = 0 then
          '免费'
         else
          '收费'
       end;
	   
	   
  select /*+parallel(4) */
 trunc(d.money_date) 退票日期,
       case
         when d.money_fy = 0 then
          '免费'
         else
          '收费'
       end 是否收费,
       sum(case when d.seats_name is not null then 1 else 0 end)  退票数,
       sum((t1.ticket_price+t1.ad_fy+t1.port_pay+t1.sx_fy+t1.other_fy+t1.insurce_fee+t1.other_fee)) 退票机票营收
  from dw.da_order_drawback d
  join dw.fact_recent_order_detail t1 on t1.flights_order_head_id = d.flights_order_head_id
 where d.money_date >= to_date('2020-01-01', 'yyyy-mm-dd')
   and d.money_date < trunc(sysdate)
 group by trunc(d.money_date),
       case
         when d.money_fy = 0 then
          '免费'
         else
          '收费'
       end;
	   
	   
---11\\ 运行要求的退票数据

select trunc(t1.origin_std) 航班日期,t2.area_type 航线性质,sum(case when t1.seats_name is not null then 1 else 0 end) 退票量
 from dw.da_order_drawback t1
 join cqsale.cq_flights_segment_head@to_air t3 on t1.segment_head_id=t3.segment_head_id
 join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
 where t1.seats_name is not null
 and t1.origin_std>=trunc(sysdate-1)
 and t1.origin_std< trunc(sysdate)
 and t3.flag<>2
 group by trunc(t1.origin_std),t2.area_type;
 
 
 
 ---12\\ 实时商务经济座数量
 
select t3.r_flights_date 航班日期,count(1) 销量
    from  cqsale.cq_order_head@to_air t3 
    join cqsale.cq_flights_segment_head@to_air t4 on t3.segment_head_id=t4.segment_head_id
  where t4.flag<>2
  and t3.r_flights_date>=trunc(sysdate)
  and t3.r_flights_date<=to_date('2020-02-29','yyyy-mm-dd')
  and t3.flag_id in(3,5)
  and t3.whole_flight like '9C%'
  and t3.EX_NFD3 is not null
  and t3.ex_cfd2='S'
  group by t3.r_flights_date;
  
  
  select t3.r_flights_date,case when t3.EX_CFD1 is not null then 'FFP'
else null end,
count(1)
    from  cqsale.cq_order_head@to_air t3 
    join cqsale.cq_flights_segment_head@to_air t4 on t3.segment_head_id=t4.segment_head_id   
  where t4.flag<>2
  and t3.r_flights_date>=trunc(sysdate)
  and t3.r_flights_date<=to_date('2020-02-29','yyyy-mm-dd')
  and t3.flag_id in(3,5)
  and t3.whole_flight like '9C%'
  and t3.EX_NFD3 is not null
  and t3.ex_cfd2='S'
  group by t3.r_flights_date,case when t3.EX_CFD1 is not null then 'FFP'
else null end;



  select t3.r_flights_date,t3.whole_segment,substr(t3.codeno,1,6),t5.province,t5.city,count(1)
    from  cqsale.cq_order_head@to_air t3 
    join cqsale.cq_flights_segment_head@to_air t4 on t3.segment_head_id=t4.segment_head_id
    left join dw.adt_region_code t5 on  substr(t3.codeno,1,6)=t5.regioncode
  where t4.flag<>2
  and t3.whole_segment  in('SZXXIY','XIYSZX')
  and t3.r_flights_date>=to_date('2020-02-14','yyyy-mm-dd')
  and t3.r_flights_date<=to_date('2020-02-24','yyyy-mm-dd')
  and t3.flag_id in(3,5,40)
  and t3.whole_flight like '9C%'
  group by t3.r_flights_date,t3.whole_segment,substr(t3.codeno,1,6),t5.province,t5.city


 ==================================================20200214================================================
 
 ---13\虹桥、浦东、石家庄出港人数
 select sum(t1.boardnum)
  from dw.da_main_order t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  where t1.flights_date>=to_date('2019-01-01','yyyy-mm-dd')
    and t1.flights_date< to_date('2020-01-01','yyyy-mm-dd')
    and t2.originairport_name in('虹桥','浦东','石家庄');
	
	--14、深圳-西安航班数据
	
	  select t3.r_flights_date,t3.whole_segment,substr(t3.codeno,1,6),t5.province,t5.city,count(1)
    from  cqsale.cq_order_head@to_air t3 
    join cqsale.cq_flights_segment_head@to_air t4 on t3.segment_head_id=t4.segment_head_id
    left join dw.adt_region_code t5 on  substr(t3.codeno,1,6)=t5.regioncode
  where t4.flag<>2
  and t3.whole_segment  in('SZXXIY','XIYSZX')
  and t3.r_flights_date>=to_date('2020-02-14','yyyy-mm-dd')
  and t3.r_flights_date<=to_date('2020-02-24','yyyy-mm-dd')
  and t3.flag_id in(3,5,40)
  and t3.whole_flight like '9C%'
  group by t3.r_flights_date,t3.whole_segment,substr(t3.codeno,1,6),t5.province,t5.city;
  
  
  ---15\风控策略调整
  
	
	---IS_MOBILE_REG  NUMBER  Y      注册方式分类 0-手机注册，1-其它注册，2-手机+会员号注册，3-email 注册，4-共享会员，5-email+会员号注册   6-非注册会员

select case when t2.is_mobile_reg in(0,2) then t2.login_id
when t2.is_mobile_reg in(3,5) then t2.email
else '-' end,md5(case when t2.is_mobile_reg in(0,2) then t2.login_id
when t2.is_mobile_reg in(3,5) then t2.email
else '-' end),
t2.login_id,t2.email,count(1)
  from cqsale.cq_order@to_air t1
  join dw.da_b2c_user t2 on t1.client_id=t2.users_id
  where t1.order_date>=to_date('2020-02-02','yyyy-mm-dd')
    and t1.order_date< to_date('2020-02-05','yyyy-mm-dd')
    group by case when t2.is_mobile_reg in(0,2) then t2.login_id
when t2.is_mobile_reg in(3,5) then t2.email
else '-' end,t2.login_id,t2.email,md5(case when t2.is_mobile_reg in(0,2) then t2.login_id
when t2.is_mobile_reg in(3,5) then t2.email
else '-' end);

---直接从会员表中提取

select * 
from  dw.da_b2c_user t2 
  where md5(t2.login_id) in('CFCD208495D565EF66E7DFF9F98764DA',
'667DD6ED83514177225E4C76B5F1B73C',
'BE065006434A698F9FD41BA53299CE9F',
'1BFA029E5F34B575404D2C7AEC24B4B7',
'C0CAC832E35A887B7CDA0C36EBA55F4F',
'47CDEE9398E259C8A592292741128B85',
'C67C5D057D44E557C267FAA0A2FCBEFD',
'027B87E98A82F22A4E26E255BEF99847',
'37E3865FD8D63E87C02325311C1B3A6A',
'2C8E6168E76724E46DE5FA7A0B9840D5',
'30D2F1B07F4B0B9E13F2775B4E8B0179')
or md5(t2.email)   in('cfcd208495d565ef66e7dff9f98764da',
'667dd6ed83514177225e4c76b5f1b73c',
'be065006434a698f9fd41ba53299ce9f',
'1bfa029e5f34b575404d2c7aec24b4b7',
'c0cac832e35a887b7cda0c36eba55f4f',
'47cdee9398e259c8a592292741128b85',
'c67c5d057d44e557c267faa0a2fcbefd',
'027b87e98a82f22a4e26e255bef99847',
'37e3865fd8d63e87c02325311c1b3a6a',
'2c8e6168e76724e46de5fa7a0b9840d5',
'30d2f1b07f4b0b9e13f2775b4e8b0179')


md5不能针对空值进行加密，仅针对有值的情况进行加密



--15\

select case when t1.money_fy=0 then '免费'
else '非免费' end,case when t1.apply_memo like '%学生%' then '学生'
else '非学生' end,case when t2.flag=2 then '取消航班'
else '正常' end ,case when trunc(t1.origin_std)-trunc(t1.money_date)< 0 then '离站后'
when trunc(t1.origin_std)-trunc(t1.money_date)< 30 then to_char(trunc(t1.origin_std)-trunc(t1.money_date))
else '30+' end,case 
when t3.order_date< to_date('2020-01-24','yyyy-mm-dd') and t1.origin_std>=to_date('2020-01-24','yyyy-mm-dd')
then '免费政策'
when t3.order_date< to_date('2020-01-28','yyyy-mm-dd') and t1.origin_std>=to_date('2020-01-28','yyyy-mm-dd')
then '免费政策'
when t1.apply_memo like '%学生%' then '免费政策'
else '其他' end,
count(1)
from dw.da_order_drawback t1
join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
join cqsale.cq_order@to_air t3 on t1.flights_order_id=t3.flights_order_id
where t1.money_date>=trunc(sysdate)-1
and t1.seats_name is not null
group by case when t1.money_fy=0 then '免费'
else '非免费' end, case when t1.apply_memo like '%学生%' then '学生'
else '非学生' end,case when t2.flag=2 then '取消航班'
else '正常' end ,case when trunc(t1.origin_std)-trunc(t1.money_date)< 0 then '离站后'
when trunc(t1.origin_std)-trunc(t1.money_date)< 30 then to_char(trunc(t1.origin_std)-trunc(t1.money_date))
else '30+' end,case 
when t3.order_date< to_date('2020-01-24','yyyy-mm-dd') and t1.origin_std>=to_date('2020-01-24','yyyy-mm-dd')
then '免费政策'
when t3.order_date< to_date('2020-01-28','yyyy-mm-dd') and t1.origin_std>=to_date('2020-01-28','yyyy-mm-dd')
then '免费政策'
when t1.apply_memo like '%学生%' then '免费政策'
else '其他' end;

--16\退票损失

 ---免费退票损失
select money_date,count(1),sum(h4.money_fy),sum(h4.ticketprice*nvl(h4.fee_rate,0)),
sum((h5.ticket_price+h5.ad_fy+h5.port_pay+h5.other_fy+h5.insurance_fee+h5.other_fee)*nvl(h5.r_com_rate,1))
from(
select *
from(
select h1.*,h2.fee_rate
from(
select trunc(t1.money_date) money_date,t1.flights_order_head_id,
trunc(t1.origin_std) flightdate,case when t1.seattype='商务座' then '商务座'
else '非商务座' end seattype,
case when regexp_like(t1.seats_name ,'Y|W') then 'YW'
when regexp_like(t1.seats_name ,'S|H|V|K|L|M') then 'SHVKLM'
when regexp_like(t1.seats_name ,'N|Q|T|X|U|E') then 'NQTXUE'
when regexp_like(t1.seats_name ,'R1|R2|R3|R4') then 'R1R2R3R4'
when regexp_like(t1.seats_name ,'B|G|G1|G2|O') then 'BGO'
when regexp_like(t1.seats_name ,'P|P1|P2|P3|P4|P5') then 'PP1P2P3P4P5'
else '其他' end seatname,
case when t2.area_type='国内' then
case when (t1.origin_std-t1.money_date)*24< 2 then '2h-'
when (t1.origin_std-t1.money_date)*24>= 2
and (t1.origin_std-t1.money_date)*24< 24 then '[2h,1D)'
when (t1.origin_std-t1.money_date)>= 1
and (t1.origin_std-t1.money_date)< 3 then '[1D,3D)'
when (t1.origin_std-t1.money_date)>= 3
and (t1.origin_std-t1.money_date)< 7 then '[3D,7D)'
when (t1.origin_std-t1.money_date)>= 7
 then '7D+'
end
when t2.area_type='国际' then
case when (t1.origin_std-t1.money_date)*24< 0 then '离站后'
when (t1.origin_std-t1.money_date)*24>= 0
and (t1.origin_std-t1.money_date)*24< 24 then '[0,1D)'
when (t1.origin_std-t1.money_date)>= 1
and (t1.origin_std-t1.money_date)< 7 then '[1D,7D)'
when (t1.origin_std-t1.money_date)>= 7
and (t1.origin_std-t1.money_date)< 15 then '[7D,15D)'
when (t1.origin_std-t1.money_date)>= 15
and (t1.origin_std-t1.money_date)< 30 then '[15D,30D)'
when (t1.origin_std-t1.money_date)>= 30 then '30D+'
end
end priod_date,t2.flights_segment_name,
t2.area_type,
t1.money_fy,t1.ticketprice,
case when t1.ticketprice=0 then 0
else t1.money_fy/ t1.ticketprice end rate
from dw.da_order_drawback t1
join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  where t1.money_date>=to_date('2020-01-21','yyyy-mm-dd')
and t1.seats_name is not null)h1
left join dw.dim_tg_rule h2 on h2.seat_type=h1.seattype and h2.nationflag=h1.area_type and h2.priod_date=h1.priod_date and h1.seatname=h2.seats_name
)h3
)h4
left join cqsale.cq_order_head@to_air h5 on h4.flights_order_head_id=h5.flights_order_head_id
where h4.money_fy=0
group by money_date;



--17\学生退票

  select trunc(t1.origin_std),count(1),sum(t1.ticketprice)
 from hdb.temp_feng_back_today t1
where t1.apply_memo like '%学生%'
and t1.money_fy=0
group by trunc(t1.origin_std)

--18\ 退票符合规则

 select /*+parallel(4) */
 t1.flights_date 航班日期, 
 case when t1.flag_id in(3,5,41) then '已售未乘机'
 when t1.flag_id in(7,11,12) then '已退票' end ,    
       case 
         when t1.order_date < to_date('2020-01-24', 'yyyy-mm-dd') and
              t2.origin_std >= to_date('2020-01-24', 'yyyy-mm-dd') 
              and d.money_date>d.origin_std 
              then '不符合规则'
         when t1.order_date < to_date('2020-01-24', 'yyyy-mm-dd') and
              t2.origin_std >= to_date('2020-01-24', 'yyyy-mm-dd') 
              and d.money_date< to_date('2020-01-24', 'yyyy-mm-dd') 
              then '不符合规则'
         when t1.order_date < to_date('2020-01-24', 'yyyy-mm-dd') and
              t2.origin_std >= to_date('2020-01-24', 'yyyy-mm-dd')
              and t2.origin_std< trunc(sysdate) and t1.flag_id in(3,5,41) then
          '不符合规则' 
           when t1.order_date < to_date('2020-01-24', 'yyyy-mm-dd') and
              t2.origin_std >= to_date('2020-01-24', 'yyyy-mm-dd') then
          '符合规则' 
          when t1.order_date < to_date('2020-01-28', 'yyyy-mm-dd') and
              t2.origin_std >= to_date('2020-01-28', 'yyyy-mm-dd') 
              and d.money_date>d.origin_std  then
          '不符合规则'
          when t1.order_date < to_date('2020-01-28', 'yyyy-mm-dd') and
              t2.origin_std >= to_date('2020-01-28', 'yyyy-mm-dd') 
              and d.money_date< to_date('2020-01-28', 'yyyy-mm-dd') then
          '不符合规则'   
           when t1.order_date < to_date('2020-01-28', 'yyyy-mm-dd') and
              t2.origin_std >= to_date('2020-01-28', 'yyyy-mm-dd') 
              and t2.origin_std< trunc(sysdate) and t1.flag_id in(3,5,41) then
          '不符合规则'        
         when t1.order_date < to_date('2020-01-28', 'yyyy-mm-dd') and
              t2.origin_std >= to_date('2020-01-28', 'yyyy-mm-dd') then
          '符合规则'
         else
          '不符合规则'
       end 政策类型,
       count(1)  退票数,
       sum(t1.ticket_price) 票价和
  from dw.fact_recent_order_detail t1
  left join dw.da_order_drawback d  on t1.flights_order_head_id =d.flights_order_head_id
  left join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
 where t1.flights_date >= to_date('2020-01-24', 'yyyy-mm-dd')
   and t1.flag_id in(3,5,41,7,11,12)    
 group by t1.flights_date ,     
       case when t1.flag_id in(3,5,41) then '已售未乘机'
 when t1.flag_id in(7,11,12) then '已退票' end ,    
       case 
         when t1.order_date < to_date('2020-01-24', 'yyyy-mm-dd') and
              t2.origin_std >= to_date('2020-01-24', 'yyyy-mm-dd') 
              and d.money_date>d.origin_std 
              then '不符合规则'
         when t1.order_date < to_date('2020-01-24', 'yyyy-mm-dd') and
              t2.origin_std >= to_date('2020-01-24', 'yyyy-mm-dd') 
              and d.money_date< to_date('2020-01-24', 'yyyy-mm-dd') 
              then '不符合规则'
         when t1.order_date < to_date('2020-01-24', 'yyyy-mm-dd') and
              t2.origin_std >= to_date('2020-01-24', 'yyyy-mm-dd')
              and t2.origin_std< trunc(sysdate) and t1.flag_id in(3,5,41) then
          '不符合规则' 
           when t1.order_date < to_date('2020-01-24', 'yyyy-mm-dd') and
              t2.origin_std >= to_date('2020-01-24', 'yyyy-mm-dd') then
          '符合规则' 
          when t1.order_date < to_date('2020-01-28', 'yyyy-mm-dd') and
              t2.origin_std >= to_date('2020-01-28', 'yyyy-mm-dd') 
              and d.money_date>d.origin_std  then
          '不符合规则'
          when t1.order_date < to_date('2020-01-28', 'yyyy-mm-dd') and
              t2.origin_std >= to_date('2020-01-28', 'yyyy-mm-dd') 
              and d.money_date< to_date('2020-01-28', 'yyyy-mm-dd') then
          '不符合规则'   
           when t1.order_date < to_date('2020-01-28', 'yyyy-mm-dd') and
              t2.origin_std >= to_date('2020-01-28', 'yyyy-mm-dd') 
              and t2.origin_std< trunc(sysdate) and t1.flag_id in(3,5,41) then
          '不符合规则'        
         when t1.order_date < to_date('2020-01-28', 'yyyy-mm-dd') and
              t2.origin_std >= to_date('2020-01-28', 'yyyy-mm-dd') then
          '符合规则'
         else
          '不符合规则'
       end;

--19\

SELECT tb2.flights_order_head_id,
       tb2.segment_head_id,
       tb2.origin_std,
       tb2.sname,
       tb2.codetype,
       tb2.codeno,
       tb2.flights_order_id,
       tb2.valid_code,
       tb2.seats_name,
       tb2.ticketprice,
       tb2.apply_user,
       tb2.apply_memo,
       tb2.money_fy,
       tb2.money_date,
       tb2.money_terminal,
       tb2.terminal_id,
       tb2.web_id,
       tb2.ex_nfd1,
       tb2.flag,
       to_char(sysdate, 'yyyymm') load_month,
       tb2.sex,
       tb2.seattype
  FROM (---退现
        SELECT tb1.flights_order_head_id,
                tb1.segment_head_id,
                tb1.origin_std,
                tb1.sname,
                tb1.codetype,
                tb1.codeno,
                tb1.flights_order_id,
                tb1.valid_code,
                tb1.seats_name,
                tb1.ticketprice,
                tb1.apply_user,
                tb1.apply_memo,
                tb1.money_fy money_fy,
                MIN(tb1.money_date) over(PARTITION BY tb1.flights_order_head_id) money_date,
                row_number() over(PARTITION BY tb1.flights_order_head_id ORDER BY tb1.money_fy desc, tb1.money_date DESC) rownumber,
                tb1.money_terminal,
                tb1.terminal_id,
                tb1.web_id,
                tb1.ex_nfd1,
                tb1.flag,
                tb1.sex,
                tb1.seattype,
                tb1.adfy
          FROM (select t1.flights_order_head_id,
                        t7.segment_head_id,
                        t7.origin_std,
                        t1.name || COALESCE(t1.second_name, '') sname,
                        t1.codetype,
                        t1.codeno,
                        t1.flights_order_id,
                        t1.valid_code,
                        t4.money_fy * nvl(t4.rate, 1) money_fy,
                        t4.money_date,
                        t4.money_terminal,
                        t.terminal_id,
                        nvl(t.web_id, 0) web_id,
                        t.ex_nfd1,
                        1 flag,
                        t1.seats_name,
                        t1.ticket_price * nvl(nvl(t1.r_com_rate, t.rate), 1) ticketprice,
                        t4.money_users apply_user,
                        t4.memo apply_memo,
                        t1.sex,
                        case
                          when t1.EX_CFD2 = 'S' and t1.ex_nfd3 is not null then
                           '商务座'
                          when t1.EX_CFD10 = '1' then
                           '经济座'
                          else
                           '普通座'
                        end seattype,
                        t1.ad_fy*nvl(nvl(t1.r_com_rate, t.rate), 1) adfy
                   from cqsale.cq_order_head@to_air t1
                   JOIN cqsale.cq_order@to_air t ON t.flights_order_id =
                                                    t1.flights_order_id
                   join dw.da_flight t7 on t1.segment_head_id =
                                           t7.segment_head_id
                   join cqsale.cq_money_report@to_air t4 on t4.FLIGHTS_ORDER_HEAD_ID =
                                                            t1.flights_order_head_id
                                                        AND t4.flights_order_id =
                                                            t1.flights_order_id
                  WHERE t1.flag_id in (7, 11, 12)
                    and t4.money_flag = 2
                    and t4.money_date>= trunc(sysdate)
                    --and t4.money_date< trunc(sysdate)
                
                    AND t4.ex_nfd2 = 0 --首次退款为0，当为1时基本上单退产品，并且money_fy=0
                    and t7.company_id = 0
                 
                 ----退卡
                 union all
                 select t1.flights_order_head_id,
                        t7.segment_head_id,
                        t7.origin_std,
                        t1.name || COALESCE(t1.second_name, ''),
                        t1.codetype,
                        t1.codeno,
                        t1.flights_order_id,
                        t1.valid_code,
                        t4.RETURN_FY * nvl(nvl(t1.r_com_rate, t.rate), 1),
                        t4.apply_date,
                        t4.APPLY_TERMINAL,
                        t.terminal_id,
                        nvl(t.web_id, 0) web_id,
                        t.ex_nfd1,
                        2 flag,
                        t1.seats_name,
                        t1.ticket_price * nvl(nvl(t1.r_com_rate, t.rate), 1) ticketprice,
                        t4.apply_user,
                        case
                          when nvl(t4.apply_memo, t4.YS_MEMO) like '%批审核%' then
                           null
                          when nvl(t4.apply_memo, t4.YS_MEMO) like '%自动执行运输部审核%' then
                           null
                          else
                           nvl(t4.apply_memo, t4.YS_MEMO)
                        end apply_memo,
                        t1.sex,
                        case
                          when t1.EX_CFD2 = 'S' and t1.ex_nfd3 is not null then
                           '商务座'
                          when t1.EX_CFD10 = '1' then
                           '经济座'
                          else
                           '普通座'
                        end seattype,
                        t1.ad_fy*nvl(nvl(t1.r_com_rate, t.rate), 1) adfy
                        
                   from cqsale.cq_order_head@to_air t1
                   JOIN cqsale.cq_order@to_air t ON t.flights_order_id =
                                                    t1.flights_order_id
                   join dw.da_flight t7 on t1.segment_head_id =
                                           t7.segment_head_id
                   join pay.cq_order_drawback@to_air t4 on t4.ORDER_HEAD_ID =
                                                           t1.flights_order_head_id
                                                       AND t4.order_no =
                                                           t1.flights_order_id
                                                       AND t4.order_type = 0
                  WHERE t1.flag_id in (7, 11, 12)
                    AND t7.company_id = 0
                    and t4.apply_date >= trunc(sysdate)
                    --and t4.apply_date< trunc(sysdate)
                 
                 UNION ALL
                 
                 ---退票特殊处理时间范围：不正常航班退一律不做特殊处理
                 select t1.flights_order_head_id,
                        t7.segment_head_id,
                        t7.origin_std,
                        t1.name || COALESCE(t1.second_name, ''),
                        t1.codetype,
                        t1.codeno,
                        t1.flights_order_id,
                        t1.valid_code,
                        t4.RETURN_FY * nvl(nvl(t1.r_com_rate, t.rate), 1),
                        t4.apply_date,
                        t4.apply_terminal,
                        t.terminal_id,
                        nvl(t.web_id, 0) web_id,
                        t.ex_nfd1,
                        3 flag,
                        t1.seats_name,
                        t1.ticket_price * nvl(nvl(t1.r_com_rate, t.rate), 1) ticketprice,
                        t4.apply_user,
                        case
                          when nvl(t4.apply_memo, t4.YS_MEMO) like '%批审核%' then
                           null
                          when nvl(t4.apply_memo, t4.YS_MEMO) like '%自动执行运输部审核%' then
                           null
                          else
                           nvl(t4.apply_memo, t4.YS_MEMO)
                        end apply_memo,
                        t1.sex,
                        case
                          when t1.EX_CFD2 = 'S' and t1.ex_nfd3 is not null then
                           '商务座'
                          when t1.EX_CFD10 = '1' then
                           '经济座'
                          else
                           '普通座'
                        end seattype,
                        t1.ad_fy*nvl(nvl(t1.r_com_rate, t.rate), 1) adfy
                   from cqsale.cq_order_head@to_air t1
                   JOIN cqsale.cq_order@to_air t ON t.flights_order_id =
                                                    t1.flights_order_id
                   join dw.da_flight t7 on t1.segment_head_id =
                                           t7.segment_head_id
                   join cqsale.cq_drawback_app@to_air t4 on t4.ORDER_HEAD_ID =
                                                            t1.flights_order_head_id
                                                        AND t4.order_no =
                                                            t1.flights_order_id
                                                        AND t4.order_type = 0
                  WHERE t1.flag_id in (7, 11, 12)
                    AND t7.company_id = 0
                    and t4.apply_date >= trunc(sysdate)
                   -- and t4.apply_date< trunc(sysdate)                    
                    ) tb1) tb2
 WHERE tb2.rownumber = 1;


--20\ 河北省退票数据

select /*+parallel(4) */
sum(t1.boardnum)
 from dw.da_main_order t1
 join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  where t1.flights_date>=to_date('2020-01-20','yyyy-mm-dd')
 and t1.flights_date<   to_date('2020-02-15','yyyy-mm-dd')
 and t2.segment_code like '%SJW%'
 and (t2.originairport in('AGB',
'BAD',
'CDE',
'DZB',
'HDG',
'HSU',
'SHP',
'SJW',
'TVS',
'XJB',
'XNT',
'ZDE',
'ZQZ') or t2.destairport in('AGB',
'BAD',
'CDE',
'DZB',
'HDG',
'HSU',
'SHP',
'SJW',
'TVS',
'XJB',
'XNT',
'ZDE',
'ZQZ'));



select /*+parallel(4) */
trunc(t1.money_date),case when t1.money_fy=0 then '免费'
else '非免费' end,count(1),
sum((t4.ticket_price+t4.ad_fy+t4.port_pay+t4.other_fee+t4.other_fy+t4.insurance_fee+t4.sx_fy)*nvl(t4.r_com_rate,1))
 from dw.da_order_drawback t1
 join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
 left join hdb.cq_airport t3 on t2.originairport=t3.threecodeforcity
 left join stg.s_cq_order_head t4 on t1.flights_order_head_id=t4.flights_order_head_id
 where t1.money_date>=to_date('2020-01-20','yyyy-mm-dd')
 and t1.money_date<   to_date('2020-02-15','yyyy-mm-dd')
 and t1.money_fy=0
 and (t2.originairport in('AGB',
'BAD',
'CDE',
'DZB',
'HDG',
'HSU',
'SHP',
'SJW',
'TVS',
'XJB',
'XNT',
'ZDE',
'ZQZ') or t2.destairport in('AGB',
'BAD',
'CDE',
'DZB',
'HDG',
'HSU',
'SHP',
'SJW',
'TVS',
'XJB',
'XNT',
'ZDE',
'ZQZ'))
group by trunc(t1.money_date),case when t1.money_fy=0 then '免费'
else '非免费' end;

====================================================20200217========================================================
--21\

接到收益发短信需求，需要航线数据请求如下：
1、提取以下航班，航班日期：2.18-2.29 已退票、申请退票、取消（超时、主动取消）的旅客手机信息
扬州=南宁 9C6183/84
扬州=福州 9C8763/4
扬州=贵阳 9C8969/70
扬州=天津 9C8989/90
扬州=银川 9C6273/4

2、提取扬州=揭阳 9C6115/6航班日期：2.5-2.29已退票、申请退票、取消（超时、主动取消）的旅客手机信息

以上数据请分两个表


select  distinct getmobile(t1.r_tel) 需求数据1
   from cqsale.cq_order_head@to_air t1
   where t1.r_flights_date>=to_date('2020-02-18','yyyy-mm-dd')
      and t1.r_flights_date<=to_date('2020-02-29','yyyy-mm-dd')
    and t1.flag_id in(7,11,12,8,9)
      and t1.whole_flight in('9C6183','9C6184','9C8763','9C8764','9C8969','9C8970','9C8989','9C8990','9C6273','9C6274')
    and getmobile(t1.r_tel)<>'-';
	  
select getmobile(t1.r_tel) 需求数据2
   from cqsale.cq_order_head@to_air t1
   where t1.r_flights_date>=to_date('2020-02-05','yyyy-mm-dd')
      and t1.r_flights_date<=to_date('2020-02-29','yyyy-mm-dd')
    and t1.flag_id in(7,11,12,8,9)
      and t1.whole_flight in('9C6115','9C6116')
       and getmobile(t1.r_tel)<>'-';    

==================================================20200218======================================================
	   
--22\ 贵阳航线复航数据

select distinct getmobile(t1.r_tel)
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  where t1.flights_date>=to_date('2020-01-01','yyyy-mm-dd')
     and t1.flights_date< to_date('2020-02-01','yyyy-mm-dd')
     and t2.flights_segment_name like '%扬州%'
     and t2.flights_segment_name like '%贵阳%'
     and getmobile(t1.r_tel)<>'-'
     and exists(select * from cqsale.cq_order_head@to_air tt1
     where  tt1.flights_order_head_id=tt1.wf_lc_father_id
     and t1.flights_order_id=tt1.flights_order_id
     and tt1.r_flights_date>=to_date('2020-01-01','yyyy-mm-dd'));


--23\ 复航航线的营销航线

1、安顺到上海航线，主要是返程为主，建议2月份退票的整体人群+去年春运期间乘坐过上海=安顺航线的人群 ；2、宁波=昆明 双向航线，1、2月份退票的整体人群+去年春运期间乘坐过宁波=昆明，如果数量不够的话再真针对宁波、昆明两地仅30天的注册会员

select distinct getmobile(t1.r_tel) 安顺数据
  from cqsale.cq_order_head@to_air t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  where t1.r_flights_date>=to_date('2020-02-01','yyyy-mm-dd')
    -- and t1.r_flights_date< to_date('2020-02-01','yyyy-mm-dd')
     and t2.flights_city_name like '%安顺%'
     and t2.flights_city_name like '%上海%'
   and t1.flag_id in(7,11,12)
   and not exists(select 1
                 from cqsale.cq_order_head@to_air tt1
                 join dw.da_flight tt2 on tt1.segment_Head_id=tt2.segment_head_id
                 where tt1.r_flights_date>=to_date('2020-02-01','yyyy-mm-dd')
                   and tt1.flag_id=40
                   and t2.destcity=tt2.destcity
                   and t1.name||coalesce(t1.second_name,'')=tt1.name||coalesce(tt1.second_name,'')
                   and t1.codeno=tt1.codeno)                   
     and getmobile(t1.r_tel)<>'-'
   
union 

select distinct getmobile(t1.r_tel)
  from cqsale.cq_order_head@to_air t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  where t1.r_flights_date>=to_date('2019-01-12','yyyy-mm-dd')
     and t1.r_flights_date< to_date('2019-03-02','yyyy-mm-dd')
     and t2.flights_city_name like '%安顺%'
     and t2.flights_city_name like '%上海%'
     and t1.flag_id =40
     and getmobile(t1.r_tel)<>'-'
     and not exists(select 1
                 from cqsale.cq_order_head@to_air tt1
                 join dw.da_flight tt2 on tt1.SEGMENT_HEAD_ID=tt2.segment_head_id
                 where tt1.r_flights_date>=to_date('2020-02-01','yyyy-mm-dd')
                   and tt1.flag_id=40
                   --and t2.destcity=tt2.destcity
                   and t1.name||coalesce(t1.second_name,'')=tt1.name||coalesce(tt1.second_name,'')
                   and t1.codeno=tt1.codeno);


--24\ 关于上海日本1-2月份滚动调价的申请

select  /*+parallel(4) */
  case when instr(t6.wf_segment,'＝',1,2)>0 then split_part(t6.wf_segment,'＝',1)||'＝'||split_part(t6.wf_segment,'＝',3)
else t6.wf_segment end 往返航段,t2.segment_code 航段三字码,t2.flight_no 航班号,t2.flight_date 航班日期, t5.terminal 申请终端,t1.cabin 舱位,t1.plan_num 计划数,t1.price 系统包位价格,
h2.minprice 散客成人最低价,h2.ticketnum 散客成人最低价机票量
from cqsale.CQ_BSALE_FLIGHTS_APPLY@to_air t1
join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
join cqsale.cq_terminal@to_air t5 on t1.terminal_id=t5.terminal_id
left join dw.dim_segment_type t6 on t2.h_route_id=t6.h_route_id and t2.route_id=t6.route_id
left join(
select h1.*
from(
select  t1.segment_Head_id,t1.ticket_price,count(1) ticketnum,
min(min(t1.ticket_price))over(partition by t1.segment_Head_id) minprice
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  where t1.flights_date>=to_date('2020-01-01','yyyy-mm-dd')
and t1.flights_date< to_date('2020-02-01','yyyy-mm-dd')
and t1.seats_name not in('B','G','G1','G2','O','A','D','Z','I','J','P2','P5','P4','P3')
and t1.sex=1
and t1.company_id=0
and t2.flag<>2
and t1.change_flag='N'
and not exists(select  1
                         from stg.c_cq_order_youhui_detail t3
             where t1.flights_order_head_id=t3.flights_order_head_id
             and t3.YOUHUI_RESULT>0)
and not exists(select 1
                         from dw.bi_yhq_use t4
             where t1.flights_order_head_id=t4.flights_order_head_id
             and t4.USE_MONEY>0
             and t4.ORDER_TYPE=0)
  group by t1.segment_Head_id,t1.ticket_price)h1
  where h1.ticket_price=h1.minprice
)h2 on t1.segment_Head_id=h2.segment_Head_id
where t2.flag<>2

and t2.flight_date>=to_date('2020-01-01','yyyy-mm-dd')
and t2.flight_date< to_date('2020-02-01','yyyy-mm-dd')
and t5.terminal='出境电商产品组'
and t1.cabin='G2'
and t1.plan_num>0;




select h1.*
from(
select  t1.segment_Head_id,t1.ticket_price,count(1) ticketnum,
min(min(t1.ticket_price))over(partition by t1.segment_Head_id) minprice
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  where t1.flights_date>=to_date('2020-01-01','yyyy-mm-dd')
and t1.flights_date< to_date('2020-02-01','yyyy-mm-dd')
and t1.seats_name not in('B','G','G1','G2','O','A','D','Z','I','J')
and t1.sex=1
and t1.company_id=0
and t2.flag<>2
and t1.change_flag='N'
and not exists(select  1
                         from stg.c_cq_order_youhui_detail t3
             where t1.flights_order_head_id=t3.flights_order_head_id
             and t3.YOUHUI_RESULT>0)
and not exists(select 1
                         from dw.bi_yhq_use t4
             where t1.flights_order_head_id=t4.flights_order_head_id
             and t4.USE_MONEY>0
             and t4.ORDER_TYPE=0)
  group by t1.segment_Head_id,t1.ticket_price)h1
  where h1.ticket_price=h1.minprice;




--25\ 深圳=重庆的乘机人数据


select /*+parallel(4)*/
tel
from(
select distinct getmobile(t1.r_tel) tel
  from cqsale.cq_order_head@to_air t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  where t1.r_flights_date>=to_date('2019-01-01','yyyy-mm-dd')
    and t1.r_flights_date< to_date('2020-02-01','yyyy-mm-dd')
     and t2.flights_city_name like '%深圳%'
     and t2.flights_city_name like '%重庆%'
   and t1.flag_id in(7,11,12,3,5,40)
   and not exists(select 1
                 from cqsale.cq_order_head@to_air tt1
                 join dw.da_flight tt2 on tt1.segment_Head_id=tt2.segment_head_id
                 where tt1.r_flights_date>=to_date('2020-02-01','yyyy-mm-dd')
                   and tt1.flag_id in(3,5,40)
                   and t1.name||coalesce(t1.second_name,'')=tt1.name||coalesce(tt1.second_name,'')
                   and t1.codeno=tt1.codeno)                   
     and getmobile(t1.r_tel)<>'-')h1
     where rownum<=50000
   


--26\

select t1.ori_date 出发日期,t1.ori_station_name 始发站,t1.dest_station_name 目的站,t1.ori_time 始发时间,
t1.dest_time 到达时间,t1.schedule_no 车次号,t1.seat_type_name 座位等级,substr(t1.name,1,1)||'*****' 姓名,
t1.code_type 证件类型,substr(t1.code_no,1,4)||'******' 证件号,t1.ticket_price 票价
from cqsale.CQ_FLIGHT_TRAIN@to_air t1
where ori_date>=to_date('2018-01-01','yyyy-mm-dd')
and ori_date< to_date('2020-01-01','yyyy-mm-dd');


=======================================20200219=======================================
--27\ 深圳机场要求的数据

select t1.flight_date,count(distinct t1.flights_id) 航班量,
count(distinct case when t1.flights_segment_name like '%深圳%'  then t1.flights_id else null end) 深圳航班量
 from dw.da_flight t1
where t1.flight_date>=to_date('2020-01-20','yyyy-mm-dd')
  and t1.flight_date< to_date('2020-03-01','yyyy-mm-dd')
  and t1.flag<>2
  and t1.company_id=0
  group by t1.flight_date;
  
  
  select t1.flight_date,sum(t1.checkin_mile)/sum(t1.checkin_s_mile)
    from dw.bi_tbl_plf t1
    where t1.flight_date>=to_date('2020-01-20','yyyy-mm-dd')
  and t1.flight_date< to_date('2020-03-01','yyyy-mm-dd')
  and t1.flight_segment like '%深圳%'
  and t1.checkin_mile>0
  and t1.checkin_s_mile>0
  group by t1.flight_date;

--28\
年龄段：18-60
乘机时间：2019年-至今所有商务经济座乘机旅客
乘机时间2：2020年-至今所有乘机普通旅客
字段：已乘机、普通旅客、商务经济座旅客、购买过保险、没购买过
发送规则：
1)	（18-60岁）2019-2020年已乘机&商务经济座&购买过保险
根据提取的数据全量发。
2)	（18-60岁）2019-2020年已乘机 & 商务经济座未购买过保险；
3)	（18-60岁）2020年已乘机 & 普通旅客购买过保险
4)	（18-60岁）2020年已乘机  & 普通旅客没有购买过保险
2-4抽一部分发，建议发2-3万条
根据发送情况，再调取2019年旅客信息逐步扩大发

1)
select count(distinct getmobile(t1.r_tel))
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  left join dw.bi_order_region t3 on t1.flights_order_head_id=t3.flights_order_head_id
  where t1.flights_date>=to_date('2019-01-01','yyyy-mm-dd')
and t1.flights_date< trunc(sysdate)
and t3.age>=18
and t3.age< 60
and t1.flag_id=40
and t1.company_id=0
and t1.insurce_fee>0
and t1.is_swj=1
and getmobile(t1.r_tel)<>'-';

数据量：29652

2) 
select count(distinct getmobile(t1.r_tel))
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  left join dw.bi_order_region t3 on t1.flights_order_head_id=t3.flights_order_head_id
  where t1.flights_date>=to_date('2019-01-01','yyyy-mm-dd')
and t1.flights_date< trunc(sysdate)
and t3.age>=18
and t3.age< 60
and t1.flag_id=40
and t1.company_id=0
and t1.insurce_fee=0
and t1.is_swj=1
and getmobile(t1.r_tel)<>'-';

数据量：43403

3) 
select count(distinct getmobile(t1.r_tel))
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  left join dw.bi_order_region t3 on t1.flights_order_head_id=t3.flights_order_head_id
  where t1.flights_date>=to_date('2020-01-01','yyyy-mm-dd')
and t1.flights_date< trunc(sysdate)
and t3.age>=18
and t3.age< 60
and t1.flag_id=40
and t1.company_id=0
and t1.insurce_fee>0
and t1.is_swj=0
and getmobile(t1.r_tel)<>'-';

数据量：252729

4) 
select count(distinct getmobile(t1.r_tel))
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  left join dw.bi_order_region t3 on t1.flights_order_head_id=t3.flights_order_head_id
  where t1.flights_date>=to_date('2020-01-01','yyyy-mm-dd')
and t1.flights_date< trunc(sysdate)
and t3.age>=18
and t3.age< 60
and t1.flag_id=40
and t1.company_id=0
and t1.insurce_fee=0
and t1.is_swj=0
and getmobile(t1.r_tel)<>'-';

数据量：864417


--29\

select t1.flights_date,t1.sex,count(1)
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  left join dw.bi_order_region t3 on t1.flights_order_head_id=t3.flights_order_head_id
  where t1.flights_date>=to_date('2019-01-01','yyyy-mm-dd')
and t1.flights_date< to_date('2020-01-01','yyyy-mm-dd')
and t1.company_id=0
and t1.sex in(2,3)
and nvl(t1.seats_name,'YE') <>'W'
and not exists(select 1 
                 from dw.fact_order_detail h1
                 where t1.flights_order_id=h1.flights_order_id
                 and h1.sex =1
                 and h1.flights_date>=to_date('2019-01-01','yyyy-mm-dd')
and h1.flights_date< to_date('2020-01-01','yyyy-mm-dd'))
group by  t1.flights_date,t1.sex
                 


=================================================20200220=================================================
--30\
select t1.users_id,t1.login_id,lower(md5(t1.login_id)),case when t2.users_id is not null then '订票识别'
else '未识别' end,t4.cancelnum,
t4.sucessnum,t4.totalnum
 from dw.da_b2c_user t1
 left join dw.da_restrict_userinfo@to_ods t2 on t1.users_id=t2.users_id
 left join (select t3.client_id,sum(case when t3.pay_flag =2 then 1 else 0 end) cancelnum,
sum(case when t3.pay_flag  in(1,4) then 1 else 0 end) sucessnum,count(1) totalnum
                from stg.s_cq_order t3
                where t3.order_date>=to_date('2018-05-01','yyyy-mm-dd')
                and t3.order_date< trunc(sysdate)
                group by t3.client_id                
                )t4 on t1.users_id=t4.client_Id
 where t1.login_id in(
'15398847739',
'15552170160',
'13766195646',
'18615261921',
'13513466332',
'15230911412',
'18408259573',
'13766149409',
'17036182561',
'15032954843',
'18772407848',
'15196344404',
'15130502844',
'15227242058',
'13458638297',
'18744299549',
'18277673284',
'13694358584',
'15650526325',
'18711847238',
'18704357554',
'13251084068',
'15031542394',
'13039829749',
'15030928947',
'18383835545',
'18782041261',
'18303131054',
'18780040106',
'18284345909',
'15700413550',
'18482322076',
'13476579064',
'18349303217',
'18482312405',
'18200413169',
'13843592405',
'18780148626',
'18482335657',
'14708003478',
'18482353058',
'18200406305',
'15911714943',
'18771633840',
'13894584712',
'13098955094',
'13630760995',
'18404359438',
'18845858402',
'15911679141',
'18402875619',
'18224078676',
'18474677220',
'13438472922',
'18843580487',
'15114069763',
'15361484992',
'13438305901',
'15843514416',
'13408566884',
'13408674724',
'13438041139',
'15928430283',
'18328514773',
'15982148733',
'15886194592',
'18788446519',
'18780039431',
'15281048680',
'18780144858',
'18280141321',
'15322145104',
'15982944294',
'15844504014',
'15754497412',
'15297325581',
'15243482694',
'15144559740',
'17196152713',
'18443574992',
'15098034794',
'18860507614',
'15948005284',
'18860568451',
'13057800764',
'13473531202',
'15170340641',
'15033384796',
'18333359943',
'13597563671',
'15707114031',
'18781513968',
'13636129181',
'13597606496',
'18489864551',
'18843581484',
'15282983263',
'15834550084',
'13995934827',
'18845862047')


--31\ 1月份外站线上行李数据

select  t2.originairport_name,case when (t2.origin_std-t1.order_date)*24>=0
and (t2.origin_std-t1.order_date)*24<=2 then '(0,2]'
when (t2.origin_std-t1.order_date)*24>2
and (t2.origin_std-t1.order_date)*24<=3 then '(2,3]' 
else '其他' end ,sum(t1.book_num),sum(t1.book_fee)
from dw.fact_other_order_detail t1
  join dw.da_flight t2 on t1.segment_Head_id=t2.segment_Head_id
  where t1.flag_id=40
  and t1.xtype_id in(6,10,17,23)
  and t1.flights_date>=to_date('2020-01-01','yyyy-mm-dd')
  and t1.flights_date< to_date('2020-02-01','yyyy-mm-dd')
  group by t2.originairport_name,case when (t2.origin_std-t1.order_date)*24>=0
and (t2.origin_std-t1.order_date)*24<=2 then '(0,2]'
when (t2.origin_std-t1.order_date)*24>2
and (t2.origin_std-t1.order_date)*24<=3 then '(2,3]' 
else '其他' end
  
  


--32\ 接送机营销短信

9C8898 9C8996 重庆上海
9C8846 9C8948 西安上海
9C8672 哈尔滨深圳
9C8888 成都上海
9C8810 长春上海
 
以上航班2月客座率超过80%，存在一定的刚需。
计划发送的航班日期为2月24日-3月1日
提前3天发送   
去除已在精准营销名单中的旅客（商务座），以及同一订单中两位及两位以上男性出行的订单.


select distinct getmobile(t1.r_tel)
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  left join(
select tt1.flights_order_id,count(1)
  from dw.fact_order_detail tt1
  left join dw.bi_order_region tt3 on tt1.flights_order_head_id=tt3.flights_order_head_id
  where tt1.flights_date>=to_date('2020-02-24','yyyy-mm-dd')
and tt1.flights_date< to_date('2020-03-02','yyyy-mm-dd')
and tt1.company_id=0
and tt1.whole_flight in('9C8898','9C8996','9C8846','9C8948','9C8672','9C8888','9C8810')
and tt3.GENDER=1
group by tt1.flights_order_id
having count(1)>=2) t3 on t1.flights_order_id=t3.flights_order_id
  where t1.flights_date>=to_date('2020-02-24','yyyy-mm-dd')
and t1.flights_date< to_date('2020-03-02','yyyy-mm-dd')
and t1.company_id=0
and t1.is_swj=0
and t1.whole_flight in('9C8898','9C8996','9C8846','9C8948','9C8672','9C8888','9C8810')
and getmobile(t1.r_tel)<>'-'
and t3.flights_order_id is null;

--33\
提取系统：	销售系统			
提取路径：	基础管理=》销售基础管理=》商务经济座价格升级设置			
始发地目的地备注：	上海则为上海浦东、上海虹桥			
提取类型：	包销舱升级、普通舱升级、其他升级			
提取条件：	状态为有效，且如果有多条数据则取生效时间较晚的那条			
				
提取字段：			
				
始发地	目的地	升级产品类型	支持舱位	升级价格

select *
from(
select t1.origin_airport 始发站三字码,t2.airport_name 始发站,t1.dest_airport 目的站三字码,t3.airport_name 目的站,
decode(t1.UP_TYPE,0,'包销升级',1,'普通升级',2,'其他升级') 升级产品类型,t1.SEAT_NAMES 支持舱位,t1.UP_PRICE 升级价格,decode(t1.NATION_FLAG,
1,'国内',2,'区域',3,'国际') 航线性质,t1.FLIGHTS_DATE_START 开始航班日期,t1.FLIGHTS_DATE_END 结束航班日期,row_number()over(partition by 
t1.origin_airport,t2.airport_name,t1.dest_airport,t3.airport_name,
decode(t1.UP_TYPE,0,'包销升级',1,'普通升级',2,'其他升级'),t1.SEAT_NAMES ,decode(t1.NATION_FLAG,1,'国内',2,'区域',3,'国际'),t1.FLIGHTS_DATE_START,t1.FLIGHTS_DATE_END,t1.RULE_TYPE order by t1.LAST_UPDATE_TIME desc
) xid,t1.LAST_UPDATE_TIME 最后更新时间
from cqsale.CQ_SUPER_SEAT_UPGRADE_RULE@to_air t1
left join hdb.cq_airport t2 on t1.origin_airport=t2.threecodeforcity
left join hdb.cq_airport t3 on t1.dest_airport =t3.threecodeforcity
where t1.STATUS=1)
where xid=1;

======================================================20200221==========================================
--34\

select tb1.segment_head_id,
       tb1.flight_date 航班日期,
       tb1.nationflag 航线性质,
       tb1.flights_segment_name 航段,
       tb1.flight_no 航班号,
       
            case when (t6.PLAN_Y + t6.PLAN_B + t6.PLAN_H + t6.PLAN_K + t6.PLAN_L +
                       t6.PLAN_M + t6.PLAN_N + t6.PLAN_Q + t6. PLAN_T + t6.
                        PLAN_X + t6.PLAN_U + t6.PLAN_E + t6.PLAN_W + t6.PLAN_P +
                        t6.PLAN_P1 + t6.PLAN_P2 + t6.PLAN_O + t6. PLAN_G + t6.
                        PLAN_G1 + t6.
                        PLAN_G2 + t6.PLAN_R1 + t6.PLAN_R2 + t6.PLAN_R3 + t6.PLAN_R4 +
                        NVL(t6.PLAN_F, 0) + NVL(t6.PLAN_F1, 0) + NVL(t6.PLAN_F2, 0) +
                        NVL(t6.PLAN_F3, 0) + NVL(t6.PLAN_F4, 0) + NVL(t6.PLAN_C, 0) +
                        NVL(t6.PLAN_C1, 0) + NVL(t6.PLAN_C2, 0) +
                        NVL(t6.PLAN_C3, 0) + NVL(t6.PLAN_C4, 0) + NVL(t6.PLAN_S, 0) +
                        NVL(t6.PLAN_V, 0) + NVL(t6.PLAN_A, 0) + NVL(t6.PLAN_D, 0) +
                        NVL(t6.PLAN_I, 0) + NVL(t6.PLAN_J, 0) + NVL(t6.PLAN_Z, 0) +
                        NVL(t6.PLAN_P3, 0) + NVL(t6.PLAN_P4, 0) +
                        NVL(t6.PLAN_P5, 0))>0 then tb2.ticketnum / (t6.PLAN_Y + t6.PLAN_B + t6.PLAN_H + t6.PLAN_K + t6.PLAN_L +
                       t6.PLAN_M + t6.PLAN_N + t6.PLAN_Q + t6. PLAN_T + t6.
                        PLAN_X + t6.PLAN_U + t6.PLAN_E + t6.PLAN_W + t6.PLAN_P +
                        t6.PLAN_P1 + t6.PLAN_P2 + t6.PLAN_O + t6. PLAN_G + t6.
                        PLAN_G1 + t6.
                        PLAN_G2 + t6.PLAN_R1 + t6.PLAN_R2 + t6.PLAN_R3 + t6.PLAN_R4 +
                        NVL(t6.PLAN_F, 0) + NVL(t6.PLAN_F1, 0) + NVL(t6.PLAN_F2, 0) +
                        NVL(t6.PLAN_F3, 0) + NVL(t6.PLAN_F4, 0) + NVL(t6.PLAN_C, 0) +
                        NVL(t6.PLAN_C1, 0) + NVL(t6.PLAN_C2, 0) +
                        NVL(t6.PLAN_C3, 0) + NVL(t6.PLAN_C4, 0) + NVL(t6.PLAN_S, 0) +
                        NVL(t6.PLAN_V, 0) + NVL(t6.PLAN_A, 0) + NVL(t6.PLAN_D, 0) +
                        NVL(t6.PLAN_I, 0) + NVL(t6.PLAN_J, 0) + NVL(t6.PLAN_Z, 0) +
                        NVL(t6.PLAN_P3, 0) + NVL(t6.PLAN_P4, 0) +
                        NVL(t6.PLAN_P5, 0))
                  else null end 销售客座率,
       case when tb2.ticketnum is not null then  tb2.adprice / tb2.ticketnum
       else null end  含油均价,
       case when tb2.price is not null then tb2.ticketprice / tb2.price
        else null end     平均折扣
 from dw.da_flight tb1
  join cqsale.cq_flights_segment_head@to_air tb3 on tb1.segment_head_id=tb3.segment_head_id
  join cqsale.cq_flights_seats_amount_plan@to_air t6 on tb1.segment_head_id=t6.segment_head_id
  left join (select t1.segment_head_id,
                    t2.oversale,
                    t2.flight_date,
                    t2.nationflag,
                    t2.flights_segment_name,
                    t2.flight_no,
                    sum(case
                          when t1.seats_name is not null then
                           1
                          else
                           0
                        end) ticketnum,
                    sum(t1.ticket_price) ticketprice,
                    sum(t1.ticket_price +
                        t1.ad_fy) adprice,
                    sum(t1.price) price
               from dw.fact_order_detail t1
               join dw.da_flight t2 on t1.segment_head_id = t2.segment_head_id               
              where t1.flights_date >=trunc(sysdate)
                and t1.flights_date <=trunc(sysdate) + 3
                and t1.flag_id in (3, 5, 40)
                and t1.company_id = 0
                and t2.flag<>2
              group by t1.segment_head_id,
                       t2.oversale,
                       t2.flight_date,
                       t2.nationflag,
                       t2.flights_segment_name,
                       t2.flight_no) tb2 on tb1.segment_head_id = tb2.segment_head_id
                       where tb1.flag<>2
                       and tb1.flight_date >=trunc(sysdate)
                      and tb1.flight_date <=trunc(sysdate) + 3
                       and tb1.company_id = 0
                       and tb3.flag<>2;
          

--35\
数据要求：
航线：中泰往返航线
航班日期：1月24日-3月28日  
1、计划执行班次，实际执行班次
2、退票量、退票金额


select d2.flight_date,
d2.segment_code,d2.flights_segment_name,
       count(1)  退票数,
       sum((t1.ticket_price+t1.ad_fy+t1.port_pay+t1.sx_fy+t1.other_fy+t1.insurance_fee+t1.other_fee)*nvl(t1.r_com_rate,1)) 退票机票营收
  from dw.da_order_drawback d
  join dw.da_flight d2 on d.segment_head_id=d2.segment_head_id
  join cqsale.cq_order_head@to_air t1 on t1.flights_order_head_id = d.flights_order_head_id
 where d2.flight_date >= to_date('2020-01-24', 'yyyy-mm-dd')
   and d2.flight_date < to_date('2020-03-29', 'yyyy-mm-dd')
   and d2.segment_country='泰国'
   group by d2.flight_date,
d2.segment_code,d2.flights_segment_name;



select  d2.flight_date,d2.segment_code,d2.flights_segment_name,count(1),sum(case when d2.flag<>2 then 1 else 0 end)
   from dw.da_flight d2
   where d2.flight_date >= to_date('2020-01-24', 'yyyy-mm-dd')
   and d2.flight_date < to_date('2020-03-29', 'yyyy-mm-dd')
   and d2.segment_country='泰国'
   and d2.company_id=0
   group by  d2.flight_date,d2.segment_code,d2.flights_segment_name
   
  
 

  
 


--36\

取消班恢复机会监控								
±24小时内有取消状态的相同OD系统记录								
进度》大盘平均15%								
均价》0.4座收								
临近14天按航班日期排序								
								
航班日	航段	现进度	昨售进度	均价	临近取消的航班号	航班日期	座位数	


select h2.flight_date 航班日期,h2.segment_code 航段三字码,h2.flights_segment_name 航段,h2.oversale 计划数,h2.ticketnum/h2.oversale 销售进度,
h2.ticketnum1/h2.oversale 昨销售进度,h2.ticketprice/h2.smile 客收,h2.ticketprice/h2.ticketnum 含油均价,
h3.flight_date 临近取消航班日期,h3.flight_no 航班号,h3.oversale 计划数
from(
select h1.flight_date,h1.segment_code,h1.flights_segment_name,sum(h1.oversale) oversale,sum(smile) smile,sum(ticketnum) ticketnum,
       sum(ticketprice) ticketprice,sum(ticketnum1)  ticketnum1,sum(ticketprice1) ticketprice1,sum(smile1) smile1
from(
select t2.segment_head_id,t2.flight_date,t2.segment_code,t2.flights_segment_name,t2.oversale,t2.mile,count(t1.flights_order_head_id) ticketnum,
       sum(t1.ticket_price+t1.ad_fy) ticketprice,t2.mile*count(t1.flights_order_head_id) smile,
       sum(case when t1.order_day< trunc(sysdate)-1 then 1 else 0 end) ticketnum1,
       sum(case when t1.order_day< trunc(sysdate)-1 then t1.ticket_price+t1.ad_fy else 0 end)  ticketprice1,
       t2.mile*sum(case when t1.order_day< trunc(sysdate)-1 then 1 else 0 end) smile1
       
  from dw.da_flight t2 
  left join dw.fact_order_detail t1 on t1.segment_head_id =t2.segment_head_id
  where t2.flight_date >=trunc(sysdate)
  and t2.flight_date <=trunc(sysdate) + 14
  and t2.company_id = 0
  and t2.flag<>2
  and t2.oversale>0
  group by t2.segment_head_id,t2.flight_date,t2.segment_code,t2.flights_segment_name,t2.oversale,t2.mile)h1
  group by h1.flight_date,h1.segment_code,h1.flights_segment_name)h2   
  left join(  
  select t2.segment_head_id,t2.flight_date,t2.flight_no,t2.segment_code,t2.flights_segment_name,t2.oversale
  from dw.da_flight t2 
  where t2.flight_date >=trunc(sysdate)
  and t2.flight_date <=trunc(sysdate) + 14
  and t2.company_id = 0
  and t2.flag=2)h3 on h2.segment_code=h3.segment_code and h2.flight_date<=h3.flight_date
  where h2.smile>0  
  and  h2.ticketnum/h2.oversale>=0.15
  and h2.ticketprice/h2.smile>=0.4;
  
  
  
  昨日往前一周的订单中，提前期为T0--7的订单流量进行统计。								
按流量增幅排序								
	本周			上周				
航段	T0--7座位数	T0--7销售数	均价	T0--7座位数	T0--7销售数	均价	流量增幅	价格增幅



select h2.flights_segment_name 航段,h2.oversale 座位数,h2.ticketnum 销售数,h2.discount 含油均价,h3.oversale 上周座位数,h3.ticketnum 上周销售数,h3.discount 上周含油均价
from(
select h1.flights_segment_name,sum(h1.oversale) oversale,sum(h1.ticketnum) ticketnum,sum(h1.ticketprice)/sum(h1.ticketnum) discount
from(
select t2.flights_segment_name,t2.segment_head_id,t2.oversale,sum(case when t1.seats_name is not null then 1 else 0 end ) ticketnum, sum(t1.ticket_price+t1.ad_fy) ticketprice
  from  dw.fact_order_detail t1
   join dw.da_flight t2 on t1.segment_head_id =t2.segment_head_id
  where t1.order_day >=trunc(sysdate)-7
  and t1.order_day < trunc(sysdate)
  and t1.company_id = 0
  and t1.flights_date>=t1.order_day
  and t1.flights_date<  t1.order_day+7
  and t2.flag<>2
  and t2.oversale>0
  group by t2.flights_segment_name,t2.segment_head_id,t2.oversale)h1
  group by h1.flights_segment_name)h2  
 left join (
select h1.flights_segment_name,sum(h1.oversale) oversale,sum(h1.ticketnum) ticketnum,sum(h1.ticketprice)/sum(h1.ticketnum) discount
from(
select t2.flights_segment_name,t2.segment_head_id,t2.oversale,sum(case when t1.seats_name is not null then 1 else 0 end ) ticketnum, sum(t1.ticket_price+t1.ad_fy) ticketprice
  from  dw.fact_order_detail t1
   join dw.da_flight t2 on t1.segment_head_id =t2.segment_head_id
  where t1.order_day >=trunc(sysdate)-14
  and t1.order_day < trunc(sysdate)-7
  and t1.company_id = 0
  and t1.flights_date>=t1.order_day
  and t1.flights_date<  t1.order_day+7
  and t2.flag<>2
  and t2.oversale>0
  group by t2.flights_segment_name,t2.segment_head_id,t2.oversale)h1
  group by h1.flights_segment_name)h3 on h2.flights_segment_name=h3.flights_segment_name;
  
  
  

--37\

从1月23日-2月10日，原计划16108班，取消航班5576班，取消率34.62%。春运期间，原一天航班近400班，直线下滑到150班左右。

select t1.flight_date,count(distinct case when t1.flag=2 then t1.flights_id else null end),count(distinct t1.flights_id)
 from dw.da_flight t1
 where t1.flight_date>=to_date('2020-01-10','yyyy-mm-dd')
 and t1.flight_date< to_date('2020-02-19','yyyy-mm-dd')
 and t1.company_id=0
 group by t1.flight_date
 
 
 
 
 ======================================20200224========================================

--38\


汪华茂:
一、疫情前（1月21日前）基本情况：
（四）进出境航班载客情况。具体包括：
1.出境每班次平均载客量多少，旅客类别以什么为主（如：旅行团、务工人员、商务人员、留学生、散客游客等等）。
2.进境每班次平均载客量多少，旅客类别以什么为主（如：旅行团、务工人员、商务人员、留学生、散客游客等等）。


1.出境每班次平均载客量173人，其中旅行团占比26%，商务人员占比13%，其余散客占比61%；
2.进境每班次平均载客量165人，其中旅行团占比24.5%，商务人员占比19.2%，其余散客占比56.3%；



select case when t2.origin_country_Id=0 then '广州出境' 
when t2.origin_country_Id>0 then '广州进境' end,count(distinct t1.flights_id),count(1)
  from  dw.fact_order_detail t1
   join dw.da_flight t2 on t1.segment_head_id =t2.segment_head_id
  where t1.flights_date >=to_date('2020-01-10','yyyy-mm-dd')
  and t1.flights_date<= to_date('2020-01-20','yyyy-mm-dd')
  and t1.company_id = 0
  and t2.flights_segment_name like '%广州%'
   and t2.flag<>2
   and  t1.nationflag<>'国内'
   group by case when t2.origin_country_Id=0 then '广州出境' 
when t2.origin_country_Id>0 then '广州进境' end;




select  case when t2.origin_country_Id=0 then '广州出境' 
when t2.origin_country_Id>0 then '广州进境' end,t3.age,
case when t1.seats_name in('B','G','G1','G2') then '旅行团'
else '其他' end,t1.ahead_days,count(1)
  from  dw.fact_order_detail t1
   join dw.da_flight t2 on t1.segment_head_id =t2.segment_head_id
   left join dw.bi_order_region t3 on t1.flights_order_head_id=t3.flights_order_head_id
  where t1.flights_date >=to_date('2020-01-10','yyyy-mm-dd')
  and t1.flights_date<= to_date('2020-01-20','yyyy-mm-dd')
  and t1.company_id = 0
  and t2.flights_segment_name like '%广州%'
   and t2.flag<>2
   and  t1.nationflag<>'国内'
   group by  case when t2.origin_country_Id=0 then '广州出境' 
when t2.origin_country_Id>0 then '广州进境' end,t3.age,
case when t1.seats_name in('B','G','G1','G2') then '旅行团'
else '其他' end,t1.ahead_days;

二、目前基本情况
（三）进出境航班载客情况。具体包括：
1.出境每班次平均载客量多少，旅客类别以什么为主（如：旅行团、务工人员、商务人员、留学生、散客游客等等）
2.进境每班次平均载客量多少，旅客类别以什么为主（如：旅行团、务工人员、商务人员、留学生、散客游客等等）


1.出境每班次平均载客量140人，其中旅行团占比0.1%，散客游客占比44.5%，其他散客55.4%（因受疫情影响购票提前期在0-7天内机票大幅提升至80%以上，无法判断是商务、务工、留学生等);
2.进境每班次平均载客量110人，其中旅行团占比1.5%，商务人员占比43.1%，其余散客占比55.4%(因受疫情影响购票提前期在0-7天内机票大幅提升至80%以上，无法判断是商务、务工、留学生等);


select case when t2.origin_country_Id=0 then '广州出境' 
when t2.origin_country_Id>0 then '广州进境' end,count(distinct t1.flights_id),count(1)
  from  dw.fact_order_detail t1
   join dw.da_flight t2 on t1.segment_head_id =t2.segment_head_id
  where t1.flights_date >=trunc(sysdate-7)
  and t1.flights_date<= trunc(sysdate-1)
  and t1.company_id = 0
  and t2.flights_segment_name like '%广州%'
   and t2.flag<>2
   and  t1.nationflag<>'国内'
   group by case when t2.origin_country_Id=0 then '广州出境' 
when t2.origin_country_Id>0 then '广州进境' end;




select  case when t2.origin_country_Id=0 then '广州出境' 
when t2.origin_country_Id>0 then '广州进境' end,
 case when t3.age<12 then '<12'
            when t3.age<18 then '12~17'
            when t3.age<24 then '18~23'
            when t3.age<30 then '24~29'
            when t3.age<40 then '30~39'
            when t3.age<50 then '40~49'
            when t3.age<60 then '50~59'
            when t3.age<70 then '60~69'
            when t3.age>=70 then '70+' 
            else '-' end age, 
case when t1.seats_name in('B','G','G1','G2') then '旅行团'
else '其他' end,case
         when t1.ahead_days <= 3 then
          '00~03'
         when t1.ahead_days <= 7 then
          '04~07'
         when t1.ahead_days <= 15 then
          '08~15'
         when t1.ahead_days <= 30 then
          '15~30'
         when t1.ahead_days <= 60 then
          '31~60'
         when t1.ahead_days <= 90 then
          '61~90'
         when t1.ahead_days > 90 then
          '90+'
       end 提前期,count(1)
  from  dw.fact_order_detail t1
   join dw.da_flight t2 on t1.segment_head_id =t2.segment_head_id
   left join dw.bi_order_region t3 on t1.flights_order_head_id=t3.flights_order_head_id
  where t1.flights_date >=trunc(sysdate-7)
  and t1.flights_date<= trunc(sysdate-1)
  and t1.company_id = 0
  and t2.flights_segment_name like '%广州%'
   and t2.flag<>2
   and  t1.nationflag<>'国内'
   group by  case when t2.origin_country_Id=0 then '广州出境' 
when t2.origin_country_Id>0 then '广州进境' end,
case when t1.seats_name in('B','G','G1','G2') then '旅行团'
else '其他' end, case when t3.age<12 then '<12'
            when t3.age<18 then '12~17'
            when t3.age<24 then '18~23'
            when t3.age<30 then '24~29'
            when t3.age<40 then '30~39'
            when t3.age<50 then '40~49'
            when t3.age<60 then '50~59'
            when t3.age<70 then '60~69'
            when t3.age>=70 then '70+' 
            else '-' end , 
case when t1.seats_name in('B','G','G1','G2') then '旅行团'
else '其他' end,
         case
         when t1.ahead_days <= 3 then
          '00~03'
         when t1.ahead_days <= 7 then
          '04~07'
         when t1.ahead_days <= 15 then
          '08~15'
         when t1.ahead_days <= 30 then
          '15~30'
         when t1.ahead_days <= 60 then
          '31~60'
         when t1.ahead_days <= 90 then
          '61~90'
         when t1.ahead_days > 90 then
          '90+'
       end;



三、复航计划情况。
（三）目前机票销售总体情况，与非疫情期间比(下降、持平，增长），出境机票销售量总体情况、进境进境机票销售总体情况，是否有旅行团购票，是否出台优惠政策促销，
旅客主要购买哪个月份机票。


目前每日销售广州进出境机票838张，与非疫情期间日销售1831张，下降54.2%；出境每日销售459张，与非疫情期间日销售886张，下降48.2%；进境每日销售379张，与非疫情期间日销售945张，下降59.9%；
目前没有旅行团购票，旅客主要购买2、3月份的机票，2月份机票占比59.3%，3月份占比达39%；




select '疫情前' type,case when t2.origin_country_Id=0 then '广州出境' 
when t2.origin_country_Id>0 then '广州进境' end,case when t1.seats_name in('B','G','G1','G2') then '旅行团'
else '其他' end bgtype,to_char(t1.flights_date,'yyyymm') months,
count(1),sum(t1.ticket_price+t1.ad_fy),suM(t1.ticket_price+t1.ad_fy+t1.other_fy),sum(t1.ticket_price)
  from  dw.fact_order_detail t1
   join dw.da_flight t2 on t1.segment_head_id =t2.segment_head_id
  where t1.order_day >=to_date('2020-01-14','yyyy-mm-dd')
  and t1.order_day<= to_date('2020-01-20','yyyy-mm-dd')
  and t1.company_id = 0
  and t2.flights_segment_name like '%广州%'
   and t2.flag<>2
   and t1.nationflag<>'国内'
   group by case when t2.origin_country_Id=0 then '广州出境' 
when t2.origin_country_Id>0 then '广州进境' end,case when t1.seats_name in('B','G','G1','G2') then '旅行团'
else '其他' end ,to_char(t1.flights_date,'yyyymm') 


union all


select '目前' type, case when t2.origin_country_Id=0 then '广州出境' 
when t2.origin_country_Id>0 then '广州进境' end,case when t1.seats_name in('B','G','G1','G2') then '旅行团'
else '其他' end bgtype,to_char(t1.flights_date,'yyyymm') months,
count(1),sum(t1.ticket_price+t1.ad_fy),suM(t1.ticket_price+t1.ad_fy+t1.other_fy),sum(t1.ticket_price)
  from  dw.fact_order_detail t1
   join dw.da_flight t2 on t1.segment_head_id =t2.segment_head_id
  where t1.order_day >=trunc(sysdate-7)
  and t1.order_day<= trunc(sysdate-1)
  and t1.company_id = 0
  and t2.flights_segment_name like '%广州%'
   and t2.flag<>2
   and t1.nationflag<>'国内'
   group by case when t2.origin_country_Id=0 then '广州出境' 
when t2.origin_country_Id>0 then '广州进境' end,case when t1.seats_name in('B','G','G1','G2') then '旅行团'
else '其他' end ,to_char(t1.flights_date,'yyyymm') ;




select '疫情前' type,case when t2.origin_country_Id=0 then '广州出境' 
when t2.origin_country_Id>0 then '广州进境' end,case when t1.seats_name in('B','G','G1','G2') then '旅行团'
else '其他' end bgtype,to_char(t1.flights_date,'yyyymm') months,
count(1),sum(t1.ticket_price+t1.ad_fy),suM(t1.ticket_price+t1.ad_fy+t1.other_fy),sum(t1.ticket_price)
  from  dw.fact_recent_order_detail t1
   join dw.da_flight t2 on t1.segment_head_id =t2.segment_head_id
   left join dw.da_order_drawback t3 on t1.flights_order_head_id=t3.flights_Order_head_id
  where t1.order_day >=to_date('2020-01-14','yyyy-mm-dd')
  and t1.order_day<= to_date('2020-01-20','yyyy-mm-dd')
  and t2.flights_segment_name like '%广州%'
  and t1.nationflag<>'国内' 
  and not exists(select 1
  from dw.da_order_drawback t3 
  where t1.flights_order_head_id=t3.flights_Order_head_id
  and t3.money_date<= to_date('2020-01-20','yyyy-mm-dd')
  and t3.money_date>=to_date('2020-01-14','yyyy-mm-dd'))  
   group by case when t2.origin_country_Id=0 then '广州出境' 
when t2.origin_country_Id>0 then '广州进境' end,case when t1.seats_name in('B','G','G1','G2') then '旅行团'
else '其他' end ,to_char(t1.flights_date,'yyyymm') 


union all


select '目前' type, case when t2.origin_country_Id=0 then '广州出境' 
when t2.origin_country_Id>0 then '广州进境' end,case when t1.seats_name in('B','G','G1','G2') then '旅行团'
else '其他' end bgtype,to_char(t1.flights_date,'yyyymm') months,
count(1),sum(t1.ticket_price+t1.ad_fy),suM(t1.ticket_price+t1.ad_fy+t1.other_fy),sum(t1.ticket_price)
  from  dw.fact_order_detail t1
   join dw.da_flight t2 on t1.segment_head_id =t2.segment_head_id
  where t1.order_day >=trunc(sysdate-7)
  and t1.order_day<= trunc(sysdate-1)
  and t1.company_id = 0
  and t2.flights_segment_name like '%广州%'
   and t2.flag<>2
   and t1.nationflag<>'国内'
   group by case when t2.origin_country_Id=0 then '广州出境' 
when t2.origin_country_Id>0 then '广州进境' end,case when t1.seats_name in('B','G','G1','G2') then '旅行团'
else '其他' end ,to_char(t1.flights_date,'yyyymm') ;

--39\ 浦东/虹桥进出港乘机人数

select case when t2.flights_city_name like '上海%' then '出港'
when t2.flights_city_name like '%上海' then '进港' end,
 case when t2.flights_segment_name like '%浦东%' then '浦东'
when t2.flights_segment_name like '%虹桥%' then '虹桥' end,
t2.area_type,
sum(t1.boardnum)
  from dw.da_main_order t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  where t1.flights_date>=to_date('2019-01-01','yyyy-mm-dd')
  and t1.flights_date< to_date('2020-01-01','yyyy-mm-dd')
  and t2.flag<>2
  and t2.company_id=0
  and t2.flights_city_name like '%上海%'
  group by case when t2.flights_city_name like '上海%' then '出港'
when t2.flights_city_name like '%上海' then '进港' end,
 case when t2.flights_segment_name like '%浦东%' then '浦东'
when t2.flights_segment_name like '%虹桥%' then '虹桥' end,t2.area_type;

--40\ 泰国航线数据
select /*+parallel(4) */
d2.flight_date,
d2.segment_code,d2.flights_segment_name,
       count(1)  退票数,
       sum((t1.ticket_price+t1.ad_fy+t1.port_pay+t1.sx_fy+t1.other_fy+t1.insurance_fee+t1.other_fee)*nvl(t1.r_com_rate,1)) 退票机票营收
  from dw.da_order_drawback d
  join dw.da_flight d2 on d.segment_head_id=d2.segment_head_id
  join cqsale.cq_order_head@to_air t1 on t1.flights_order_head_id = d.flights_order_head_id
 where d2.flight_date >= to_date('2020-01-24', 'yyyy-mm-dd')
   and d2.flight_date < to_date('2020-03-29', 'yyyy-mm-dd')
   and d2.segment_country='泰国'
   group by d2.flight_date,
d2.segment_code,d2.flights_segment_name;



--41\ 订票时刻问题


select trunc(t1.r_order_date),to_char(r_order_date,'day'),to_char(r_order_date,'hh24'),count(1)
 from cqsale.cq_oRDER_HEAD@TO_AIR t1
 WHERE whole_flight LIKE '9C%'
 and r_order_date>=to_date('2019-11-30','yyyy-mm-dd')
 and r_order_date< to_date('2020-01-20','yyyy-mm-dd')
 and to_char(r_order_date,'day') in('星期六','星期日','星期一')
 and t1.flag_Id in(3,5,40,41,7,11,12)
/* and to_char(r_order_date,'hh24:mi')>='00:00'
 and to_char(r_order_date,'hh24:mi')<='02:00'*/
 group by trunc(t1.r_order_date),to_char(r_order_date,'day'),to_char(r_order_date,'hh24');
 
 
--42\ 韩国籍旅客人数

select *
from(
select t1.flight_date,t2.segment_code,t2.flights_segment_name,t2.flight_no,
sum(case when t1.nationality ='中国' then 1
when t1.nationality like '%香港%' then 1
when t1.nationality like '%澳门%' then 1
when t1.nationality like '%台湾%' then 1
else 0 end) num1,
sum(case when t1.nationality ='韩国' then 1
else 0 end) num2,
count(1) num3
from dw.bi_order_region t1
join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
join cqsale.cq_flights_segment_head@to_air t3 on t2.segment_head_id=t3.segment_head_id
where t1.flight_date>=to_date('2020-02-27','yyyy-mm-dd')
and t1.flight_date<=to_date('2020-03-01','yyyy-mm-dd')
and t1.flag_id in(3,5,40,41)
and t2.company_id=0
and t3.flag<>2
and t2.segment_country='韩国'
group by t1.flight_date,t2.segment_code,t2.flights_segment_name,t2.flight_no)h1
where h1.num2>0;



select *
from(
select t1.r_flights_date,t2.segment_code,t2.flights_segment_name,t2.flight_no,
sum(case when t4.nationality ='CHN' then 1
when t4.nationality ='HKG' then 1
when t4.nationality ='MFM' then 1
when t4.nationality ='TWN' then 1
else 0 end) num1,
sum(case when t4.nationality ='KOR' then 1
else 0 end) num2,
count(1) num3
from cqsale.cq_order_head@to_air t1
join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
join cqsale.cq_flights_segment_head@to_air t3 on t2.segment_head_id=t3.segment_head_id
left join stg.s_cq_traveller_info t4 on t1.flights_order_head_id=t4.flights_order_head_id
where t1.r_flights_date>=to_date('2020-02-27','yyyy-mm-dd')
and t1.r_flights_date<=to_date('2020-03-01','yyyy-mm-dd')
and t1.flag_id in(3,5,40,41)
and t2.company_id=0
and t3.flag<>2
and t2.segment_country='韩国'
group by t1.r_flights_date,t2.segment_code,t2.flights_segment_name,t2.flight_no)h1
where h1.num2>0;




--43\ 河北省免费退票损失

select /*+parallel(4) */
trunc(t1.money_date),case when t1.money_fy=0 then '免费'
else '非免费' end,count(1),
sum((t4.ticket_price+t4.ad_fy+t4.port_pay+t4.other_fee+t4.other_fy+t4.insurance_fee+t4.sx_fy)*nvl(t4.r_com_rate,1))
 from dw.da_order_drawback t1
 join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
 left join hdb.cq_airport t3 on t2.originairport=t3.threecodeforcity
 left join stg.s_cq_order_head t4 on t1.flights_order_head_id=t4.flights_order_head_id
 where t1.money_date>=to_date('2020-01-20','yyyy-mm-dd')
 and t1.money_date<   to_date('2020-02-24','yyyy-mm-dd')
 and t1.money_fy=0
 and (t2.originairport in('AGB',
'BAD',
'CDE',
'DZB',
'HDG',
'HSU',
'SHP',
'SJW',
'TVS',
'XJB',
'XNT',
'ZDE',
'ZQZ') or t2.destairport in('AGB',
'BAD',
'CDE',
'DZB',
'HDG',
'HSU',
'SHP',
'SJW',
'TVS',
'XJB',
'XNT',
'ZDE',
'ZQZ'))
group by trunc(t1.money_date),case when t1.money_fy=0 then '免费'
else '非免费' end;



--44\ 支付手续费

select /*+parallel(4) */
t1.gate_name,to_char(t1.flights_date,'yyyymm'),sum(t1.sx_fy)
 from dw.fact_order_detail t1
 where t1.flights_date>=to_date('2020-02-01','yyyy-mm-dd')
 and t1.flights_date< to_date('2020-04-01','yyyy-mm-dd')
 --and t1.money_class_id=0
 and t1.company_id=0
 and t1.sx_fy>0
 group by t1.gate_name,to_char(t1.flights_date,'yyyymm');

--45\

传达一下昨天周例会的一些事情，算是在群里面开下晨会：
1、人员安排：本周有部门已经进入全面复工，我们部门下周会根据公司要求以及部门情况安排全员复工或者大部分复工，另外来上班的人要进入上班状态，而不是值班状态；\
2、部门一些重点项目推进：线上精准营销、用户标签体系、辅收精准营销、品牌运价、零售数据仓库等等要开始积极推进，掌握相关进度，并每周在周报里面提交相关的进度；
3、因疫情的影响对现有的一些数据表现产生了很大的影响，各个业务分析模块的负责人要监控相关数据变化，及时上报异常并分析相关的影响，对应异常要分析原因；
4、部门的预算、19年底进行相关数据预测因疫情的影响，数据均有变化，这块后续要进行相应的更新；
4、本周、下周要针对数据能力建设方面提交十四五规划（2020~2025），也请

--46\  商务经济座积分补偿数据
select trunc(t1.r_order_date),t1.flights_order_id,t1.r_flights_date,to_char(t2.origin_std,'hh24'),t1.whole_flight,t1.name||' '||coalesce(t1.second_name,''),
t1.codeno,t1.r_tel
 from cqsale.cq_order_head@to_air t1
 join cqsale.cq_flights_segment_head@to_air t2 on t1.segment_head_id=t2.segment_head_id
 where t2.flag<>2
 and t1.r_flights_date>=to_date('2020-02-26','yyyy-mm-dd')
 and t1.r_order_date< to_date('2020-02-25 11:50:00','yyyy-mm-dd hh24:mi:ss')
 and t1.flag_id in(3,5,40,41)
 and t1.whole_flight like '9C%'
 and t1.EX_NFD3 is not null
 and t1.EX_CFD2='S';
 
--47\ 韩国入境数据
select t1.order_day,count(1)
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id = t2.segment_head_id
 where t2.flag <> 2
   --and t1.seats_name not in ('B', 'G1', 'G2', 'O')
   and t1.order_day >= trunc(sysdate-30)
   and t1.order_day <= trunc(sysdate)
   and t1.whole_flight like '9C%'
   and t2.segment_country='韩国'
   and t2.origin_country_id>0
   group by t1.order_day;
   
   
   


--48\IT 系统更新时间选择
select trunc(t1.r_order_date),to_char(r_order_date,'hh24'),to_char(t1.r_order_date,'day'),count(1)
 from cqsale.cq_oRDER_HEAD@TO_AIR t1
 WHERE whole_flight LIKE '9C%'
 and r_order_date>=to_date('2019-01-21','yyyy-mm-dd')
 and r_order_date< to_date('2020-01-21','yyyy-mm-dd')
 --and to_char(r_order_date,'day') in('星期六','星期日','星期一')
 and t1.flag_Id in(3,5,40,41,7,11,12)
 and to_char(r_order_date,'hh24:mi')>='00:00'
 and to_char(r_order_date,'hh24:mi')< '07:00'
 group by trunc(t1.r_order_date),to_char(r_order_date,'hh24'),to_char(t1.r_order_date,'day')

===========================================20200226================================
--49\ 取消座位数据占比

select t1.flight_date,case when t1.flag=2 then '取消' 
else '正常' end,t1.area_type,sum(t1.oversale) 
from dw.da_flight t1
where t1.flight_date>=to_date('2020-01-24','yyyy-mm-dd')
and t1.flight_date<=to_date('2020-02-29','yyyy-mm-dd')
and t1.company_id=0
group by t1.flight_date,case when t1.flag=2 then '取消' 
else '正常' end,t1.area_type;

--50\ 两周收益类型数据对比

select '本周' 周类型,t2.nationflag 航线性质,t4.income_type 收益类型,count(1) 机票量,sum(t1.ticket_price+t1.ad_fy) 含油票价
from dw.fact_order_detail t1
join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
join cqsale.cq_flights_segment_head@to_air t3 on t2.segment_head_id=t3.segment_head_id
left join dw.dim_segment_type t4 on t2.h_route_id=t4.h_route_id and t2.route_id=t3.route_id
where t1.order_day>=trunc(sysdate)-7
and t1.order_day< trunc(sysdate)
and t1.flag_id in(3,5,40,41)
and t2.company_id=0
and t3.flag<>2
group by t2.nationflag,t4.income_type


union all

select '上周',t2.nationflag,t4.income_type,count(1),sum(t1.ticket_price+t1.ad_fy)
from dw.fact_order_detail t1
join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
join cqsale.cq_flights_segment_head@to_air t3 on t2.segment_head_id=t3.segment_head_id
left join dw.dim_segment_type t4 on t2.h_route_id=t4.h_route_id and t2.route_id=t3.route_id
where t1.order_day>=trunc(sysdate)-7-7
and t1.order_day< trunc(sysdate)-7
and t1.flag_id in(3,5,40,41)
and t2.company_id=0
and t3.flag<>2
group by t2.nationflag,t4.income_type;


--51\ 0210~0225销售日期销售的航班提前期分布

select t1.order_day,to_char(t1.flights_date,'mmdd'),'全部' type,
case when t1.ahead_days<=60 then to_char(t1.ahead_days)
else '60+' end,t2.area_type,
count(1)
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  left join dw.dim_segment_type t4 on t2.route_id=t4.route_id and t2.h_route_id=t4.h_route_id
  where t2.flag<>2
  and t1.order_day>=to_date('2020-02-10','yyyy-mm-dd')
  and t1.order_day< to_date('2020-02-26','yyyy-mm-dd')
  and t1.company_id=0
  and t1.seats_name is not null
  group by t1.order_day,to_char(t1.flights_date,'mmdd'),case when t1.ahead_days<=60 then to_char(t1.ahead_days)
else '60+' end,t2.area_type
  
  union all
  
  select t1.order_day,to_char(t1.flights_date,'mmdd'),'上海' type,
  case when t1.ahead_days<=60 then to_char(t1.ahead_days)
else '60+' end,t2.area_type,count(1)
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  left join dw.dim_segment_type t4 on t2.route_id=t4.route_id and t2.h_route_id=t4.h_route_id
  where t2.flag<>2
  and t1.order_day>=to_date('2020-02-10','yyyy-mm-dd')
  and t1.order_day< to_date('2020-02-26','yyyy-mm-dd')
  and t1.company_id=0
  and t2.area_type='国内'
  and t1.seats_name is not null
  and t2.flights_city_name like '%上海%'
  group by t1.order_day,to_char(t1.flights_date,'mmdd'),case when t1.ahead_days<=60 then to_char(t1.ahead_days)
else '60+' end,t2.area_type;


--52\ 医护申请材料数据

select t1.*,case when t2.status=1 then 1 else 0 end
from hdb.wb_yh_data t1
left join cust.cq_flights_users_huiyuan@to_air t2 on t1.users_id=t2.users_id_fk;


https://pages.ch.com/jp/act/Spring2020SuperSale_Feb?cmpid=ydn_atl_ic1_s2ssale_2002

--53\

IJ 2020年2月促销数据提取

以下数据，只提取IJ机票销售数
机票状态：已售票，已出票，已乘机

1.	日文PC和M网站，2月12日~2月21日之间销售的机票数，分航线和日期，如下所示
	NRTHIJ	HIJNRT	。。。。。。
2/12	100	200	200
2/13	100	200	200
2/14	100	200	200
2/15	100	200	200


select  t1.order_day,t1.whole_segment,t1.whole_flight,count(1)
from dw.fact_order_detail_ij t1
join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
where t1.flag_id in(3,5,40,41)
and t1.order_day>=to_date('2020-02-12','yyyy-mm-dd')
and t1.order_day< to_date('2020-02-22','yyyy-mm-dd')
and t1.order_language='日文'
and t1.terminal_id<0
and t1.web_id=0
and t1.station_id<=2
and t1.company_id=6
group by  t1.order_day,t1.whole_segment,t1.whole_flight;


2.	日文PC和M网站，2月17日~2月21日之间销售的P2舱机票数，分航线和日期，如下所示
	NRTHIJ	HIJNRT	。。。。。。
2/17	100	200	200
2/18	100	200	200
2/19	100	200	200
2/20	100	200	200
2/21	100	200	200


select  t1.order_day 订单日期,t1.whole_segment 航段,t1.whole_flight 航班号,count(1) 销量
from dw.fact_order_detail_ij t1
join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
where t1.flag_id in(3,5,40,41)
and t1.order_day>=to_date('2020-02-17','yyyy-mm-dd')
and t1.order_day< to_date('2020-02-22','yyyy-mm-dd')
and t1.order_language='日文'
and t1.terminal_id<0
and t1.web_id=0
and t1.station_id<=2
and t1.company_id=6
and t1.seats_name ='P2'
group by  t1.order_day,t1.whole_segment,t1.whole_flight;

3.	日文PC和M网站，2月17日~2月21日之间销售的P2舱机票数，分乘机日（应该只有4-6月）
	4月	5月	6月
2/17	100	200	200
2/18	100	200	200
2/19	100	200	200
2/20	100	200	200
2/21	100	200	200


select  t1.order_day 订单日期,to_char(t1.flights_date,'yyyymm') 航班月,count(1) 销量
from dw.fact_order_detail_ij t1
join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
where t1.flag_id in(3,5,40,41)
and t1.order_day>=to_date('2020-02-17','yyyy-mm-dd')
and t1.order_day< to_date('2020-02-22','yyyy-mm-dd')
and t1.order_language='日文'
and t1.terminal_id<0
and t1.web_id=0
and t1.station_id<=2
and t1.company_id=6
and t1.seats_name ='P2'
group by   t1.order_day ,to_char(t1.flights_date,'yyyymm') ;

4.	日文PC和M网站，2月12日~2月21日之间的每天的新注册的会员数
select t1.reg_day,count(1)
from dw.da_b2c_user t1
where t1.reg_language='日文'
and t1.reg_day>=to_date('2020-02-12','yyyy-mm-dd')
and t1.reg_day< to_date('2020-02-22','yyyy-mm-dd')
and nvl(t1.ex_nfd1,1) <=2
group by t1.reg_day


5.	日文PC和M网站，2月12日~2月21日之间的新注册会员的每天的购票数（分所有舱位的机票数，和P2舱位的机票数，应该17日开始才有P2）


select t1.order_day,count(1),sum(case when t1.seats_name='P2' then 1 else 0 end)
from dw.fact_order_detail_ij t1
 join (
select t1.users_id
from dw.da_b2c_user t1
where t1.reg_language='日文'
and t1.reg_day>=to_date('2020-02-12','yyyy-mm-dd')
and t1.reg_day< to_date('2020-02-22','yyyy-mm-dd')
and nvl(t1.ex_nfd1,1) <=2) t2 on t1.client_id=t2.users_id
where t1.order_day>=to_date('2020-02-12','yyyy-mm-dd')
group by t1.order_day


6.	日文PC和M网站，非2月12日~2月21日之间新注册会员的每天的购票数（分所有舱位的机票数，和P2舱位的机票数，应该17日开始才有P2）


select t1.order_day,count(1),sum(case when t1.seats_name='P2' then 1 else 0 end)
from dw.fact_order_detail_ij t1
join dw.da_b2c_user t2 on t1.client_id=t2.users_id
where t1.order_day>=to_date('2020-02-12','yyyy-mm-dd')
and t2.reg_language='日文'
and t1.client_id>0
and t1.terminal_id<0
and t1.web_id=0
and nvl(t2.ex_nfd1,1)<=2
and not (t2.reg_day>=to_date('2020-02-12','yyyy-mm-dd')
and t2.reg_day< to_date('2020-02-22','yyyy-mm-dd'))
group by t1.order_day;

7.	所有语言网站及APP，非2月12日~2月21日之间新注册会员的每天的购票数（分所有舱位的机票数，和P2舱位的机票数，应该17日开始才有P2）



select t1.order_day,count(1),sum(case when t1.seats_name='P2' then 1 else 0 end)
from dw.fact_order_detail_ij t1
join dw.da_b2c_user t2 on t1.client_id=t2.users_id
where t1.order_day>=to_date('2020-02-12','yyyy-mm-dd')
and t1.client_id>0
and t1.terminal_id<0
and t1.web_id=0
and not (t2.reg_day>=to_date('2020-02-12','yyyy-mm-dd')
and t2.reg_day< to_date('2020-02-22','yyyy-mm-dd'))
group by t1.order_day;


--54\  韩国、日本到上海的人数数据

select /*+parallel(4) */
t1.r_flights_date 航班日期,t2.flight_no 航班号,t2.flights_segment_name 航段,
(t6.PLAN_Y + t6.PLAN_B + t6.PLAN_H + t6.PLAN_K + t6.PLAN_L +
                       t6.PLAN_M + t6.PLAN_N + t6.PLAN_Q + t6. PLAN_T + t6.
                        PLAN_X + t6.PLAN_U + t6.PLAN_E + t6.PLAN_W + t6.PLAN_P +
                        t6.PLAN_P1 + t6.PLAN_P2 + t6.PLAN_O + t6. PLAN_G + t6.
                        PLAN_G1 + t6.
                        PLAN_G2 + t6.PLAN_R1 + t6.PLAN_R2 + t6.PLAN_R3 + t6.PLAN_R4 +
                        NVL(t6.PLAN_F, 0) + NVL(t6.PLAN_F1, 0) + NVL(t6.PLAN_F2, 0) +
                        NVL(t6.PLAN_F3, 0) + NVL(t6.PLAN_F4, 0) + NVL(t6.PLAN_C, 0) +
                        NVL(t6.PLAN_C1, 0) + NVL(t6.PLAN_C2, 0) +
                        NVL(t6.PLAN_C3, 0) + NVL(t6.PLAN_C4, 0) + NVL(t6.PLAN_S, 0) +
                        NVL(t6.PLAN_V, 0) + NVL(t6.PLAN_A, 0) + NVL(t6.PLAN_D, 0) +
                        NVL(t6.PLAN_I, 0) + NVL(t6.PLAN_J, 0) + NVL(t6.PLAN_Z, 0) +
                        NVL(t6.PLAN_P3, 0) + NVL(t6.PLAN_P4, 0) +
                        NVL(t6.PLAN_P5, 0))  座位数,
count(1)  预约数,
sum(case when t4.nationality ='KOR' then 1
else 0 end) 韩国籍人数,
sum(case when t4.nationality ='JPN' then 1
else 0 end) 日本籍人数
from cqsale.cq_order_head@to_air t1
join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
join cqsale.cq_flights_segment_head@to_air t3 on t2.segment_head_id=t3.segment_head_id
left join cqsale.cq_traveller_info@to_air t4 on t1.flights_order_head_id=t4.flights_order_head_id
left join cqsale.cq_flights_seats_amount_plan@to_air t6 on t1.segment_Head_id=t6.segment_Head_id
where t1.r_flights_date>=to_date('2020-02-26','yyyy-mm-dd')
and t1.r_flights_date<=to_date('2020-03-03','yyyy-mm-dd')
and t1.flag_id in(3,5,40,41)
and t2.company_id=0
and t3.flag<>2
and t1.seats_name is not null
and t2.origin_country_id>0
and t2.destairport_name='浦东'
and t2.segment_country in('韩国','日本')
group by t1.r_flights_date ,t2.flight_no ,t2.flights_segment_name ,
(t6.PLAN_Y + t6.PLAN_B + t6.PLAN_H + t6.PLAN_K + t6.PLAN_L +
                       t6.PLAN_M + t6.PLAN_N + t6.PLAN_Q + t6. PLAN_T + t6.
                        PLAN_X + t6.PLAN_U + t6.PLAN_E + t6.PLAN_W + t6.PLAN_P +
                        t6.PLAN_P1 + t6.PLAN_P2 + t6.PLAN_O + t6. PLAN_G + t6.
                        PLAN_G1 + t6.
                        PLAN_G2 + t6.PLAN_R1 + t6.PLAN_R2 + t6.PLAN_R3 + t6.PLAN_R4 +
                        NVL(t6.PLAN_F, 0) + NVL(t6.PLAN_F1, 0) + NVL(t6.PLAN_F2, 0) +
                        NVL(t6.PLAN_F3, 0) + NVL(t6.PLAN_F4, 0) + NVL(t6.PLAN_C, 0) +
                        NVL(t6.PLAN_C1, 0) + NVL(t6.PLAN_C2, 0) +
                        NVL(t6.PLAN_C3, 0) + NVL(t6.PLAN_C4, 0) + NVL(t6.PLAN_S, 0) +
                        NVL(t6.PLAN_V, 0) + NVL(t6.PLAN_A, 0) + NVL(t6.PLAN_D, 0) +
                        NVL(t6.PLAN_I, 0) + NVL(t6.PLAN_J, 0) + NVL(t6.PLAN_Z, 0) +
                        NVL(t6.PLAN_P3, 0) + NVL(t6.PLAN_P4, 0) +
                        NVL(t6.PLAN_P5, 0)) 




--55\

select /*+parallel(4) */
to_char(t1.order_day,'yyyymm') 月份,t1.seat_type 座位类型,
       case when t1.channel in('网站','手机') and t3.users_id is not null then '代理'
       when t1.channel in('网站','手机') then '线上自有纯量'
       when t1.channel in('OTA','旗舰店') then 'OTA'
       else '线下其他' end 渠道,
     case when  tb4.segment_code is not null then '老航线'
     when  t4.segment_code is not null and tb4.segment_code is null then '复航'    
     else '新航线' end 航线类型,
     case when t1.channel in('网站','手机')  and t1.order_day-t5.reg_day>60 then '老会员'
     when t1.channel in('网站','手机')  and t1.order_day-t5.reg_day<=60 then '新会员'
     else '-' end 会员类型 ,t2.segment_country 航线国家,
	 case when t2.origin_country_id>0 then '入境'
	 else '出境' end 出入境类型,
	 t6.wf_segment 往返航线,
	 t2.flights_segment_name 航段,
     count(1) 票量
  from dw.Fact_recent_Order_Detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  left join dw.da_restrict_userinfo t3 on t1.client_id=t3.users_id
  left join (select distinct t1.segment_code
               from dw.da_flight t1
               where t1.flight_date<=to_date('2019-03-30','yyyy-mm-dd')
                     and t1.flag<>2
                  and t1.company_id=0
          and t1.area_type ='国际')t4 on t1.whole_segment=t4.segment_code 
   left join (select distinct t1.segment_code
               from dw.da_flight t1
               where t1.flight_date>=to_date('2019-03-31','yyyy-mm-dd')
          and t1.flight_date<=to_date('2019-10-26','yyyy-mm-dd')
                     and t1.flag<>2
                  and t1.company_id=0
          and t1.area_type ='国际')tb4 on t1.whole_segment=tb4.segment_code 
 left join dw.da_b2c_user t5 on t1.client_Id=t5.users_id
 left join dw.dim_segment_type t6 on t2.route_id=t6.route_id and t2.h_route_id=t6.h_route_id
  where t1.order_day>=to_date('2019-09-01','yyyy-mm-dd')
    and t1.order_day< trunc(sysdate)
    and t1.nationflag <>'国内'
    and t1.seats_name not in('B','G1','G2','O','G')
    and t1.flag_id in(3,5,40,41)
  and t1.seats_name is not null
  group by to_char(t1.order_day,'yyyymm'),t1.seat_type,
       case when t1.channel in('网站','手机') and t3.users_id is not null then '代理'
       when t1.channel in('网站','手机') then '线上自有纯量'
       when t1.channel in('OTA','旗舰店') then 'OTA'
       else '线下其他' end,
   case when  tb4.segment_code is not null then '老航线'
     when  t4.segment_code is not null and tb4.segment_code is null then '复航'    
     else '新航线' end,
     case when t1.channel in('网站','手机')  and t1.order_day-t5.reg_day>60 then '老会员'
     when t1.channel in('网站','手机')  and t1.order_day-t5.reg_day<=60 then '新会员'
     else '-' end ,t2.segment_country,
   case when t2.origin_country_id>0 then '入境'
   else '出境' end,
   t6.wf_segment,
   t2.flights_segment_name;

--56\ 浦东出港航班


select origin_std 起飞时间,r_flights_no 航班号,flights_segment 航段
from cqsale.cq_flights_segment_head@to_air
where trunc(origin_std)=trunc(sysdate+1)
and origin_std< to_date('2020-02-27 10:00','yyyy-mm-dd hh24:mi')
and flag<>2
and r_flights_no like '9C%'
and origin_airport ='PVG'

--57\

select distinct t1.r_tel,t.work_tel
from cqsale.cq_order@to_air t
join  cqsale.cq_order_head@to_air  t1 on t.flights_order_id=t1.flights_order_Id
join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
where t1.r_flights_date=to_date('2020-02-27','yyyy-mm-dd')
and t2.flag<>2
and t1.whole_flight in('9C6349','9C6280','9C8753')
and t1.flag_id in(3,5,40,41);



select distinct t1.r_tel,t.work_tel
from cqsale.cq_order@to_air t
join  cqsale.cq_order_head@to_air  t1 on t.flights_order_id=t1.flights_order_Id
join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
join cqsale.cq_flights_segment_head@to_air t3 on t1.segment_head_id=t3.segment_head_id
where t1.r_flights_date=to_date('2020-02-27','yyyy-mm-dd')
and t3.flag<>2
and t1.flag_id in(3,5,40,41)
and t3.origin_airport ='PVG'
and t1.whole_flight like '9C%'
and to_char(t3.origin_std,'hh24:mi')< '10:00'

--58\  浦东10点以前出港的旅客联系方式

select distinct getmobile(t1.r_tel)
from cqsale.cq_order@to_air t
join  cqsale.cq_order_head@to_air  t1 on t.flights_order_id=t1.flights_order_Id
join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
join cqsale.cq_flights_segment_head@to_air t3 on t1.segment_head_id=t3.segment_head_id
where t1.r_flights_date=to_date('2020-02-27','yyyy-mm-dd')
and t3.flag<>2
and t1.flag_id in(3,5,40,41)
and t1.whole_flight like '9C%'
and t3.origin_airport ='PVG'
and to_char(t3.origin_std,'hh24:mi')< '10:00'

union all

select distinct t.work_tel
from cqsale.cq_order@to_air t
join  cqsale.cq_order_head@to_air  t1 on t.flights_order_id=t1.flights_order_Id
join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
join cqsale.cq_flights_segment_head@to_air t3 on t1.segment_head_id=t3.segment_head_id
where t1.r_flights_date=to_date('2020-02-27','yyyy-mm-dd')
and t3.flag<>2
and t1.flag_id in(3,5,40,41)
and t1.whole_flight like '9C%'
and t3.origin_airport ='PVG'
and to_char(t3.origin_std,'hh24:mi')< '10:00';


--59\  广州进出港数据

涉及字段包括：日期（2020年1月1日起至2月26日，每天）、航班号、航段、人数（销售人数或者值机人数都可以），客座率

select t1.r_flights_date 航班日期,t2.flight_no 航班号,t2.segment_code 航段,t2.flights_segment_name 航段中文,
t2.nationflag 航线性质, case when t2.originairport='CAN' then '广州出港'
when t2.destairport='CAN' then '广州进港' end 广州进出港类型,
(t6.PLAN_Y + t6.PLAN_B + t6.PLAN_H + t6.PLAN_K + t6.PLAN_L +
                       t6.PLAN_M + t6.PLAN_N + t6.PLAN_Q + t6. PLAN_T + t6.
                        PLAN_X + t6.PLAN_U + t6.PLAN_E + t6.PLAN_W + t6.PLAN_P +
                        t6.PLAN_P1 + t6.PLAN_P2 + t6.PLAN_O + t6. PLAN_G + t6.
                        PLAN_G1 + t6.
                        PLAN_G2 + t6.PLAN_R1 + t6.PLAN_R2 + t6.PLAN_R3 + t6.PLAN_R4 +
                        NVL(t6.PLAN_F, 0) + NVL(t6.PLAN_F1, 0) + NVL(t6.PLAN_F2, 0) +
                        NVL(t6.PLAN_F3, 0) + NVL(t6.PLAN_F4, 0) + NVL(t6.PLAN_C, 0) +
                        NVL(t6.PLAN_C1, 0) + NVL(t6.PLAN_C2, 0) +
                        NVL(t6.PLAN_C3, 0) + NVL(t6.PLAN_C4, 0) + NVL(t6.PLAN_S, 0) +
                        NVL(t6.PLAN_V, 0) + NVL(t6.PLAN_A, 0) + NVL(t6.PLAN_D, 0) +
                        NVL(t6.PLAN_I, 0) + NVL(t6.PLAN_J, 0) + NVL(t6.PLAN_Z, 0) +
                        NVL(t6.PLAN_P3, 0) + NVL(t6.PLAN_P4, 0) +
                        NVL(t6.PLAN_P5, 0))  航班计划数,
count(1)  销售人数
from cqsale.cq_order_head@to_air t1
join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
join cqsale.cq_flights_segment_head@to_air t3 on t2.segment_head_id=t3.segment_head_id
left join cqsale.cq_flights_seats_amount_plan@to_air t6 on t1.segment_Head_id=t6.segment_Head_id
where t1.r_flights_date>=to_date('2020-01-01','yyyy-mm-dd')
and t1.r_flights_date<=to_date('2020-02-29','yyyy-mm-dd')
and t1.flag_id in(3,5,40,41)
and t2.company_id=0
and t3.flag<>2
and t1.seats_name is not null
and t1.whole_segment like '%CAN%'
group by t1.r_flights_date ,t2.flight_no ,t2.segment_code ,t2.flights_segment_name ,
t2.nationflag , case when t2.originairport='CAN' then '广州出港'
when t2.destairport='CAN' then '广州进港' end ,
(t6.PLAN_Y + t6.PLAN_B + t6.PLAN_H + t6.PLAN_K + t6.PLAN_L +
                       t6.PLAN_M + t6.PLAN_N + t6.PLAN_Q + t6. PLAN_T + t6.
                        PLAN_X + t6.PLAN_U + t6.PLAN_E + t6.PLAN_W + t6.PLAN_P +
                        t6.PLAN_P1 + t6.PLAN_P2 + t6.PLAN_O + t6. PLAN_G + t6.
                        PLAN_G1 + t6.
                        PLAN_G2 + t6.PLAN_R1 + t6.PLAN_R2 + t6.PLAN_R3 + t6.PLAN_R4 +
                        NVL(t6.PLAN_F, 0) + NVL(t6.PLAN_F1, 0) + NVL(t6.PLAN_F2, 0) +
                        NVL(t6.PLAN_F3, 0) + NVL(t6.PLAN_F4, 0) + NVL(t6.PLAN_C, 0) +
                        NVL(t6.PLAN_C1, 0) + NVL(t6.PLAN_C2, 0) +
                        NVL(t6.PLAN_C3, 0) + NVL(t6.PLAN_C4, 0) + NVL(t6.PLAN_S, 0) +
                        NVL(t6.PLAN_V, 0) + NVL(t6.PLAN_A, 0) + NVL(t6.PLAN_D, 0) +
                        NVL(t6.PLAN_I, 0) + NVL(t6.PLAN_J, 0) + NVL(t6.PLAN_Z, 0) +
                        NVL(t6.PLAN_P3, 0) + NVL(t6.PLAN_P4, 0) +
                        NVL(t6.PLAN_P5, 0));



--60\  线上自有渠道提升分析

select /*+parallel(4) */
to_char(t1.order_day,'yyyymm'),t1.seat_type,
       case when t1.channel in('网站','手机') and t3.users_id is not null then '代理'
       when t1.channel in('网站','手机') then '线上自有纯量'
       when t1.channel in('OTA','旗舰店') then 'OTA'
       else '线下其他' end,
     case when  tb4.segment_code is not null then '老航线'
     when  t4.segment_code is not null and tb4.segment_code is null then '复航'    
     else '新航线' end,
     case when t1.channel in('网站','手机')  and t1.order_day-t5.reg_day>60 then '老会员'
     when t1.channel in('网站','手机')  and t1.order_day-t5.reg_day<=60 then '新会员'
     else '-' end ,t2.segment_country,
	 case when t2.origin_country_id>0 then '入境'
	 else '出境' end,
	 t6.wf_segment,
	 t2.flights_segment_name,
     count(1)
  from dw.Fact_recent_Order_Detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  left join dw.da_restrict_userinfo t3 on t1.client_id=t3.users_id
  left join (select distinct t1.segment_code
               from dw.da_flight t1
               where t1.flight_date<=to_date('2019-03-30','yyyy-mm-dd')
                     and t1.flag<>2
                  and t1.company_id=0
          and t1.area_type ='国际')t4 on t1.whole_segment=t4.segment_code 
   left join (select distinct t1.segment_code
               from dw.da_flight t1
               where t1.flight_date>=to_date('2019-03-31','yyyy-mm-dd')
          and t1.flight_date<=to_date('2019-10-26','yyyy-mm-dd')
                     and t1.flag<>2
                  and t1.company_id=0
          and t1.area_type ='国际')tb4 on t1.whole_segment=tb4.segment_code 
 left join dw.da_b2c_user t5 on t1.client_Id=t5.users_id
 left join dw.dim_segment_type t6 on t2.route_id=t6.route_id and t2.h_route_id=t6.h_route_id
  where t1.order_day>=to_date('2019-09-01','yyyy-mm-dd')
    and t1.order_day< trunc(sysdate)
    and t1.nationflag <>'国内'
    and t1.seats_name not in('B','G1','G2','O','G')
    and t1.flag_id in(3,5,40,41)
  and t1.seats_name is not null
  group by to_char(t1.order_day,'yyyymm'),t1.seat_type,
       case when t1.channel in('网站','手机') and t3.users_id is not null then '代理'
       when t1.channel in('网站','手机') then '线上自有纯量'
       when t1.channel in('OTA','旗舰店') then 'OTA'
       else '线下其他' end,
   case when  tb4.segment_code is not null then '老航线'
     when  t4.segment_code is not null and tb4.segment_code is null then '复航'    
     else '新航线' end,
     case when t1.channel in('网站','手机')  and t1.order_day-t5.reg_day>60 then '老会员'
     when t1.channel in('网站','手机')  and t1.order_day-t5.reg_day<=60 then '新会员'
     else '-' end ,t2.segment_country,
   case when t2.origin_country_id>0 then '入境'
   else '出境' end,
   t6.wf_segment,
   t2.flights_segment_name;


======================================================20200227=====================================================
--61\

select /*+parallel(4) */
trunc(t1.money_date),case when t1.money_fy=0 then '免费'
else '非免费' end,count(1),
sum((t4.ticket_price+t4.ad_fy+t4.port_pay+t4.other_fee+t4.other_fy+t4.insurance_fee+t4.sx_fy)*nvl(t4.r_com_rate,1))
 from dw.da_order_drawback t1
 join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
 left join hdb.cq_airport t3 on t2.originairport=t3.threecodeforcity
 left join stg.s_cq_order_head t4 on t1.flights_order_head_id=t4.flights_order_head_id
 where t1.money_date>=to_date('2020-01-20','yyyy-mm-dd')
 and t1.money_date<   to_date('2020-02-27','yyyy-mm-dd')
 and t1.money_fy=0
 and (t2.originairport in('AGB',
'BAD',
'CDE',
'DZB',
'HDG',
'HSU',
'SHP',
'SJW',
'TVS',
'XJB',
'XNT',
'ZDE',
'ZQZ') or t2.destairport in('AGB',
'BAD',
'CDE',
'DZB',
'HDG',
'HSU',
'SHP',
'SJW',
'TVS',
'XJB',
'XNT',
'ZDE',
'ZQZ'))
group by trunc(t1.money_date),case when t1.money_fy=0 then '免费'
else '非免费' end;

--62\ 日韩数据

select /*+parallel(4) */
t1.r_flights_date 航班日期,t2.flight_no 航班号,t2.flights_segment_name 航段,
(t6.PLAN_Y + t6.PLAN_B + t6.PLAN_H + t6.PLAN_K + t6.PLAN_L +
                       t6.PLAN_M + t6.PLAN_N + t6.PLAN_Q + t6. PLAN_T + t6.
                        PLAN_X + t6.PLAN_U + t6.PLAN_E + t6.PLAN_W + t6.PLAN_P +
                        t6.PLAN_P1 + t6.PLAN_P2 + t6.PLAN_O + t6. PLAN_G + t6.
                        PLAN_G1 + t6.
                        PLAN_G2 + t6.PLAN_R1 + t6.PLAN_R2 + t6.PLAN_R3 + t6.PLAN_R4 +
                        NVL(t6.PLAN_F, 0) + NVL(t6.PLAN_F1, 0) + NVL(t6.PLAN_F2, 0) +
                        NVL(t6.PLAN_F3, 0) + NVL(t6.PLAN_F4, 0) + NVL(t6.PLAN_C, 0) +
                        NVL(t6.PLAN_C1, 0) + NVL(t6.PLAN_C2, 0) +
                        NVL(t6.PLAN_C3, 0) + NVL(t6.PLAN_C4, 0) + NVL(t6.PLAN_S, 0) +
                        NVL(t6.PLAN_V, 0) + NVL(t6.PLAN_A, 0) + NVL(t6.PLAN_D, 0) +
                        NVL(t6.PLAN_I, 0) + NVL(t6.PLAN_J, 0) + NVL(t6.PLAN_Z, 0) +
                        NVL(t6.PLAN_P3, 0) + NVL(t6.PLAN_P4, 0) +
                        NVL(t6.PLAN_P5, 0))  座位数,
count(1)  预约数,
sum(case when t4.nationality ='KOR' then 1
else 0 end) 韩国籍人数,
sum(case when t4.nationality ='JPN' then 1
else 0 end) 日本籍人数
from cqsale.cq_order_head@to_air t1
join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
join cqsale.cq_flights_segment_head@to_air t3 on t2.segment_head_id=t3.segment_head_id
left join cqsale.cq_traveller_info@to_air t4 on t1.flights_order_head_id=t4.flights_order_head_id
left join cqsale.cq_flights_seats_amount_plan@to_air t6 on t1.segment_Head_id=t6.segment_Head_id
where t1.r_flights_date>=to_date('2020-02-26','yyyy-mm-dd')
and t1.r_flights_date<=to_date('2020-03-03','yyyy-mm-dd')+(trunc(sysdate)-to_date('2020-02-26','yyyy-mm-dd'))
and t1.flag_id in(3,5,40,41)
and t2.company_id=0
and t3.flag<>2
and t1.seats_name is not null
and t2.origin_country_id>0
and t2.destairport_name='浦东'
and t2.segment_country in('韩国','日本')
group by t1.r_flights_date ,t2.flight_no ,t2.flights_segment_name ,
(t6.PLAN_Y + t6.PLAN_B + t6.PLAN_H + t6.PLAN_K + t6.PLAN_L +
                       t6.PLAN_M + t6.PLAN_N + t6.PLAN_Q + t6. PLAN_T + t6.
                        PLAN_X + t6.PLAN_U + t6.PLAN_E + t6.PLAN_W + t6.PLAN_P +
                        t6.PLAN_P1 + t6.PLAN_P2 + t6.PLAN_O + t6. PLAN_G + t6.
                        PLAN_G1 + t6.
                        PLAN_G2 + t6.PLAN_R1 + t6.PLAN_R2 + t6.PLAN_R3 + t6.PLAN_R4 +
                        NVL(t6.PLAN_F, 0) + NVL(t6.PLAN_F1, 0) + NVL(t6.PLAN_F2, 0) +
                        NVL(t6.PLAN_F3, 0) + NVL(t6.PLAN_F4, 0) + NVL(t6.PLAN_C, 0) +
                        NVL(t6.PLAN_C1, 0) + NVL(t6.PLAN_C2, 0) +
                        NVL(t6.PLAN_C3, 0) + NVL(t6.PLAN_C4, 0) + NVL(t6.PLAN_S, 0) +
                        NVL(t6.PLAN_V, 0) + NVL(t6.PLAN_A, 0) + NVL(t6.PLAN_D, 0) +
                        NVL(t6.PLAN_I, 0) + NVL(t6.PLAN_J, 0) + NVL(t6.PLAN_Z, 0) +
                        NVL(t6.PLAN_P3, 0) + NVL(t6.PLAN_P4, 0) +
                        NVL(t6.PLAN_P5, 0)) ;


--63\


select c.part,c.channel,c.terminal,t.terminal_id,t.web_id,t.ex_nfd1,t.work_tel,t1.r_nation_flag,t1.r_tel
 from cqsale.cq_order@to_air t
 join cqsale.cq_order_head@to_air t1 on t.flights_order_id=t1.flights_order_id
   left join dw.da_channel_part c on c.terminal_id = t.terminal_id
                                and c.web_id = nvl(t.web_id, 0)
                                and c.station_id =
                                    (case when t.terminal_id < 0 and
                                     nvl(t.ex_nfd1, 0) <= 1 then 1 else
                                     nvl(t.ex_nfd1, 0) end)
                                and t.order_date >= c.sdate
                                and t.order_date < c.edate + 1;
 where t.order_day>=trunc(sysdate)-7
   and t.order_day< trunc(sysdate)
   and t1.flag_id in(3,5,40,41,7,11,12)
   and substr(getmobile(t1.r_tel) not in('133','149','153','173','174','177','180','181','189','199','130','131','132','145','146','155','156','166','171','175','176','185',
'186','134','135','136','137','138','139','147','148','150','151','152','157','158','159','172','178','182','183','184','187','188','198','170','141','144');

--64\



时间段：3.15-4.15 ，4.16-5.30 ，需要两个时间段的航线明细，航线飞行的具体截止时间段范围（xx月xx日---xxx年xx月截止）。

提取城市航线：上海，石家庄，沈阳，扬州(泰州)，宁波，揭阳(潮汕)，兰州，西安，深圳，广州


航班号  航线  航班日期  班期  机票价格
9C8835/6  虹桥=广州  2.26-3.28  每日   ¥380 
9C8855/6  虹桥=广州  2.26-3.28  每日   ¥380 
9C8931/2  虹桥=广州  2.26-3.28  每日   ¥300 
9C6229/30  广州=绵阳  3.2-3.15  每日   ¥330 
9C8899/900  石家庄=广州  2.26-3.28  每日   ¥400 
9C6159/60  广州=大阪  3.1、3.4  不定期   ¥800 
9C8529/30  广州=金边  2.26-3.28  每日   ¥700 
9C8933/4  广州=清迈  2.26-3.15；3.17、3.20、3.22、3.24、3.27  每日   ¥500 
9C6129/30  广州=曼谷  2.26-3.28  每日   ¥600 
9C8771/2  广州=普吉  2.26-3.29  每日   ¥600 



select h4.wf_segment,case when substr(h4.flightno,4,3) in('999','000') then substr(h4.flightno,1,7)||substr(h4.flightno,10,4) 
when substr(h4.flightno,5,2) in('99','00') then substr(h4.flightno,1,7)||substr(h4.flightno,11,3) 
 when substr(h4.flightno,6,1) in('9','0') then substr(h4.flightno,1,7)||substr(h4.flightno,12,2)
else substr(h4.flightno,1,7)||substr(h4.flightno,12,2) end midno,h4.weeks,min(h4.mindate) mindate,max(h4.maxdate) maxdate,
min(h4.minmoney) minmoney
from(
select h3.wf_segment,listagg(h3.flight_no,'/')within group(order by h3.flight_no)over(partition by h3.midno,h3.wf_segment) flightno,
h3.weeks,h3.mindate,h3.maxdate,h3.minmoney

from(
select h2.flight_no,case when substr(h2.flight_no,5,2) in ('999','000') then substr(h2.flight_no,1,2)
 when substr(h2.flight_no,5,2) in('99','00') then substr(h2.flight_no,1,3)
 when substr(h2.flight_no,6,1) in('9','0') then substr(h2.flight_no,1,4)
else substr(h2.flight_no,1,5) end midno, h2.wf_segment,h2.weeks,min(h2.mindate) mindate,max(h2.maxdate) maxdate,
min(h2.minmoney) minmoney
from(
select h1.flight_no,wf_segment,'周'||listagg(h1.weeks,'/')within group(order by h1.weeks)over(partition by h1.flight_no,h1.wf_segment
) weeks,h1.mindate,h1.maxdate,h1.minmoney
from(
select t1.flight_no,t2.wf_segment,to_char(t1.flight_date-1,'d') weeks,
min(min(t1.flight_date))over(partition by t1.flight_no,t2.wf_segment) mindate
,max(max(t1.flight_date))over(partition by t1.flight_no,t2.wf_segment) maxdate,
min(min(tb1.money))over(partition by t1.flight_no,t2.wf_segment) minmoney
from dw.da_flight t1
 join (select h1.segment_head_id,
       min(h1.money) money      
  from (select *
          from (select segment_head_id,
                       MONEY_E,
MONEY_H,
MONEY_I,
MONEY_K,
MONEY_L,
MONEY_M,
MONEY_N,
MONEY_P,
MONEY_P1,
MONEY_P2,
MONEY_P3,
MONEY_P4,
MONEY_P5,
MONEY_Q,
MONEY_R1,
MONEY_R2,
MONEY_R3,
MONEY_R4,
MONEY_S,
MONEY_T,
MONEY_U,
MONEY_V,
MONEY_X,
MONEY_Y                       
from cqsale.cq_flights_segment_head@to_air) unpivot(money for seats_name in (MONEY_E as 'E',
MONEY_H as 'H',
MONEY_I as 'I',
MONEY_K as 'K',
MONEY_L as 'L',
MONEY_M as 'M',
MONEY_N as 'N',
MONEY_P as 'P',
MONEY_P1 as 'P1',
MONEY_P2 as 'P2',
MONEY_P3 as 'P3',
MONEY_P4 as 'P4',
MONEY_P5 as 'P5',
MONEY_Q as 'Q',
MONEY_R1 as 'R1',
MONEY_R2 as 'R2',
MONEY_R3 as 'R3',
MONEY_R4 as 'R4',
MONEY_S as 'S',
MONEY_T as 'T',
MONEY_U as 'U',
MONEY_V as 'V',
MONEY_X as 'X',
MONEY_Y as 'Y'
))
                  ) h1
  join (select *
          from (select segment_head_id,
                       REMNANT_E,
REMNANT_H,
REMNANT_I,
REMNANT_K,
REMNANT_L,
REMNANT_M,
REMNANT_N,
REMNANT_P,
REMNANT_P1,
REMNANT_P2,
REMNANT_P3,
REMNANT_P4,
REMNANT_P5,
REMNANT_Q,
REMNANT_R1,
REMNANT_R2,
REMNANT_R3,
REMNANT_R4,
REMNANT_S,
REMNANT_T,
REMNANT_U,
REMNANT_V,
REMNANT_X,
REMNANT_Y
from cqsale.cq_flights_seats_amount@to_air) unpivot(remnant for seats_name in (REMNANT_E AS 'E',
REMNANT_H AS 'H',
REMNANT_I AS 'I',
REMNANT_K AS 'K',
REMNANT_L AS 'L',
REMNANT_M AS 'M',
REMNANT_N AS 'N',
REMNANT_P AS 'P',
REMNANT_P1 AS 'P1',
REMNANT_P2 AS 'P2',
REMNANT_P3 AS 'P3',
REMNANT_P4 AS 'P4',
REMNANT_P5 AS 'P5',
REMNANT_Q AS 'Q',
REMNANT_R1 AS 'R1',
REMNANT_R2 AS 'R2',
REMNANT_R3 AS 'R3',
REMNANT_R4 AS 'R4',
REMNANT_S AS 'S',
REMNANT_T AS 'T',
REMNANT_U AS 'U',
REMNANT_V AS 'V',
REMNANT_X AS 'X',
REMNANT_Y AS 'Y'))) h2 on h1.segment_head_id =  h2.segment_head_id    and h1.seats_name = h2.seats_name
  join cqsale.cq_flights_segment_head@to_air h3 on h1.segment_head_id =  h3.segment_head_id
  join cqsale.cq_flights_seats_amount@to_air h5 on h1.segment_head_id=h5.segment_head_id
  left join dw.da_flight h4 on h1.segment_head_id = h4.segment_head_id
 where h3.origin_std >= to_date('2020-03-15','yyyy-mm-dd')
   and h3.origin_std <  to_date('2020-04-16','yyyy-mm-dd')
   and h2.remnant > 0
   and h3.flag <> 2
   and h3.r_flights_no like '9C%'
   and h1.seats_name not in('P2','P5','A','D','Z','I','J','O','W')
   group by h1.segment_head_id
   
)tb1  on t1.segment_Head_id=tb1.segment_Head_id
 left join dw.dim_segment_type t2 on t1.h_route_id=t2.h_route_id and t1.route_id=t2.route_id
where regexp_like(t1.flights_city_name,'(上海)|(石家庄)|(沈阳)|(扬州泰州)|(宁波)|(揭阳)|(兰州)|(西安)|(深圳)|广州')
and t1.flag<>2
and t1.flight_date>=to_date('2020-03-15','yyyy-mm-dd')
and t1.flight_date<=to_date('2020-04-15','yyyy-mm-dd')
and t1.company_id=0
group by t1.flight_no,t2.wf_segment,to_char(t1.flight_date-1,'d'))h1
)h2 
group by h2.flight_no,h2.wf_segment,h2.weeks)h3
)h4
group by h4.wf_segment,case when substr(h4.flightno,4,3) in('999','000') then substr(h4.flightno,1,7)||substr(h4.flightno,10,4) 
when substr(h4.flightno,5,2) in('99','00') then substr(h4.flightno,1,7)||substr(h4.flightno,11,3) 
 when substr(h4.flightno,6,1) in('9','0') then substr(h4.flightno,1,7)||substr(h4.flightno,12,2)
else substr(h4.flightno,1,7)||substr(h4.flightno,12,2) end,h4.weeks;











--65\

2月28日 6280 杭州西安，6349深圳西安，8753深圳西安， 麻烦拉取这三个航班旅客联系方式

select distinct getmobile(t1.r_tel)
from cqsale.cq_order@to_air t
join  cqsale.cq_order_head@to_air  t1 on t.flights_order_id=t1.flights_order_Id
join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
join cqsale.cq_flights_segment_head@to_air t3 on t1.segment_head_id=t3.segment_head_id
where t1.r_flights_date=to_date('2020-02-28','yyyy-mm-dd')
and t3.flag<>2
and t1.flag_id in(3,5,40,41)
and t1.whole_flight like '9C%'
and t1.whole_flight in('9C6280','9C6349','9C8753')

union 

select distinct t.work_tel
from cqsale.cq_order@to_air t
join  cqsale.cq_order_head@to_air  t1 on t.flights_order_id=t1.flights_order_Id
join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
join cqsale.cq_flights_segment_head@to_air t3 on t1.segment_head_id=t3.segment_head_id
where t1.r_flights_date=to_date('2020-02-28','yyyy-mm-dd')
and t3.flag<>2
and t1.flag_id in(3,5,40,41)
and t1.whole_flight like '9C%'
and t1.whole_flight in('9C6280','9C6349','9C8753');


流量监控
旅客属性
往返天数




--66\  民航数据查询
select t2.origin_std 航班起飞时间,t1.r_flights_date,t1.whole_flight,t1.whole_segment,t1.name||' '||coalesce(t1.second_name,'') 姓名,
t1.codeno,t1.r_tel,t1.flag_id
 from cqsale.cq_Order_head@to_air t1
 join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
 where codeno in('640222199710151911',
'E67075969',
'64032319931027261X',
'E09818347',
'64038119970410273X',
'E19164028',
'642222199412261014',
'E33804184',
'640382199512032956',
'E19160044',
'640302199503281115',
'E21112797',
'640324199706062615',
'E57814371',
'64022119900715361X',
'E14850354')
and t1.r_flights_date>=to_date('2020-02-01','yyyy-mm-dd')
and t1.flag_id in(3,5,40,41,2);


===============================================20200302===========================================
--67\ 西安呼叫中心提醒短信

--2月29日6280  杭州西安；6349 深圳西安；8753 深圳西安，以上航班麻烦提供下旅客联系方式@冯喜欢 
--3月1日6280杭州西安、8753深圳西安、6349深圳西安 旅客联系麻烦提供 谢谢@冯喜欢 

select distinct getmobile(t1.r_tel) 西安航线联系方式 
from cqsale.cq_order@to_air t
join  cqsale.cq_order_head@to_air  t1 on t.flights_order_id=t1.flights_order_Id
join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
join cqsale.cq_flights_segment_head@to_air t3 on t1.segment_head_id=t3.segment_head_id
where t1.r_flights_date=trunc(sysdate)+1
and t3.flag<>2
and t1.flag_id in(3,5,40,41)
and t1.whole_flight like '9C%'
and t1.whole_flight in('9C6349','9C6280','9C8753')
and t2.destairport_name='西安'
and getmobile(t1.r_tel)<>'-'

union 

select distinct t.work_tel
from cqsale.cq_order@to_air t
join  cqsale.cq_order_head@to_air  t1 on t.flights_order_id=t1.flights_order_Id
join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
join cqsale.cq_flights_segment_head@to_air t3 on t1.segment_head_id=t3.segment_head_id
where t1.r_flights_date=trunc(sysdate)+1
and t3.flag<>2
and t1.flag_id in(3,5,40,41)
and t1.whole_flight like '9C%'
and t1.whole_flight in('9C6349','9C6280','9C8753')
and t2.destairport_name='西安'
and getmobile(t.work_tel)<>'-' ;

--68\ 三亚出港联系方式


--麻烦提供3月1日8809、8843、8839、8635、8859、8569、8911、8951、8589、8755、8731浦东常德、浦东北海、8521 航班旅客联系方式@冯喜欢 谢谢

---8731 只要浦东出发的2段航班  不需要常德北海


--3月2日 8843 上海大连，8859 上海哈尔滨，8911 上海南宁 麻烦以上浦东出港三个航班旅客联系方式提供。


select distinct getmobile(t1.r_tel) 三亚出港联系方式
from cqsale.cq_order@to_air t
join  cqsale.cq_order_head@to_air  t1 on t.flights_order_id=t1.flights_order_Id
join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
join cqsale.cq_flights_segment_head@to_air t3 on t1.segment_head_id=t3.segment_head_id
where t1.r_flights_date=trunc(sysdate)+1
and t3.flag<>2
and t1.flag_id in(3,5,40,41)
and t1.whole_flight like '9C%'
and t2.originairport_name='三亚'
and getmobile(t1.r_tel)<>'-'

union 

select distinct t.work_tel
from cqsale.cq_order@to_air t
join  cqsale.cq_order_head@to_air  t1 on t.flights_order_id=t1.flights_order_Id
join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
join cqsale.cq_flights_segment_head@to_air t3 on t1.segment_head_id=t3.segment_head_id
where t1.r_flights_date=trunc(sysdate)+1
and t3.flag<>2
and t1.flag_id in(3,5,40,41)
and t1.whole_flight like '9C%'
and t2.originairport_name='三亚'
and getmobile(t1.r_tel)<>'-';

--69\ 上海浦东出港联系方式


--麻烦提供3月1日8809、8843、8839、8635、8859、8569、8911、8951、8589、8755、8731浦东常德、浦东北海、8521 航班旅客联系方式@冯喜欢 谢谢

---8731 只要浦东出发的2段航班  不需要常德北海


--3月2日 8843 上海大连，8859 上海哈尔滨，8911 上海南宁 麻烦以上浦东出港三个航班旅客联系方式提供。


select distinct getmobile(t1.r_tel) 浦东出港联系方式
from cqsale.cq_order@to_air t
join  cqsale.cq_order_head@to_air  t1 on t.flights_order_id=t1.flights_order_Id
join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
join cqsale.cq_flights_segment_head@to_air t3 on t1.segment_head_id=t3.segment_head_id
where t1.r_flights_date=trunc(sysdate)+1
and t3.flag<>2
and t1.flag_id in(3,5,40,41)
and t1.whole_flight like '9C%'
and t1.whole_flight in('9C8843','9C8859','9C8911')
and t2.originairport='PVG'
and getmobile(t1.r_tel)<>'-'

union 

select distinct t.work_tel
from cqsale.cq_order@to_air t
join  cqsale.cq_order_head@to_air  t1 on t.flights_order_id=t1.flights_order_Id
join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
join cqsale.cq_flights_segment_head@to_air t3 on t1.segment_head_id=t3.segment_head_id
where t1.r_flights_date=trunc(sysdate)+1
and t3.flag<>2
and t1.flag_id in(3,5,40,41)
and t1.whole_flight like '9C%'
and t1.whole_flight in('9C8843','9C8859','9C8911')
and t2.originairport='PVG'
and getmobile(t1.r_tel)<>'-';

========================================20200303==========================================================
--70\ 手机号码联系方式
select distinct  getmobile(t1.feature_value) 
  from dw.da_restrict_userinfo t1
  where length(t1.feature_value)=11
  and getmobile(t1.feature_value)<>'-';

--71\

==

select *
from(
select t1.flight_date,
       t1.h_route_id,
       t1.route_name,
       t2.wf_segment_name,
       sum(case
             when t1.flag = 2 then
              1
             else
              0
           end) num1,
       sum(case
             when t1.flag = 1 then
              1
             else
              0
           end) num2
  from dw.da_flight t1
  join dw.dim_segment_type t2 on t1.h_route_id=t2.h_route_id and t1.route_id=t2.route_id
 where t1.flight_date >= trunc(sysdate) - 30
   and t1.flight_date < trunc(sysdate)
   and t1.segment_type like '%经停%'   
 group by t1.flight_date, t1.h_route_id, t1.route_name,t2.wf_segment_name
 )h1
 where h1.num1 not in(0,3);
 
 
 select t1.route_name,min(t1.round_time),max(t1.round_time),avg(t1.round_time)
  from hdb.recent_flights_cost t1
  where t1.flight_date>=trunc(sysdate)-30
  and t1.flight_date< trunc(sysdate)
  and t1.qr_flag=1
  and t1.total_cost>0
  and t1.checkin_mile>0
  and t1.checkin_s_mile>0
  group by t1.route_name




--72\ 商务经济座

--订单号	购买的XID	工号	工号姓名


select t.flights_order_id,t1.BOOK_ID,t.users_id,t2.users_work_id
 from cqsale.cq_other_order@to_air t
 join cqsale.CQ_OTHER_ORDER_head@to_air t1 on t.order_id=t1.order_id
 left join cqsale.cq_user@to_air t2 on t.users_id=t2.users_id
 where t.order_date>=to_date('2020-03-02','yyyy-mm-dd')
   and t.order_date< to_date('2020-03-03','yyyy-mm-dd')
   and t1.flag_id in(3,5,40,41)
   and t1.BOOK_ID in(4072,4073,4077,4079,4080,4081,
   4082,4083,4085,4084,4075,4078,4074)


--73\

韩国航线数据

select /*+parallel(4) */
t1.flights_date 航班日期,t2.flight_no 航班号,t2.flights_segment_name 航段,
case when  t2.origin_country_id>0 then '入境'
else '出境' end,t2.oversale,count(1)  ,
sum(case when t1.EX_CFD7 ='KOR' then 1
else 0 end) 韩国籍人数
from dw.fact_order_detail t1
join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
where t1.flights_date>=to_date('2020-02-24','yyyy-mm-dd')
and t1.flights_date< trunc(sysdate)
and t1.flag_id=40
and t2.company_id=0
and t2.flag<>2
and t1.seats_name is not null
and t2.flights_segment_name like '%浦东%'
and t2.segment_country ='韩国'
group by t1.flights_date ,t2.flight_no ,t2.flights_segment_name ,
case when  t2.origin_country_id>0 then '入境'
else '出境' end,t2.oversale;



select /*+parallel(4) */
t1.r_flights_date 航班日期,t2.flight_no 航班号,t2.flights_segment_name 航段,
case when  t2.origin_country_id>0 then '入境'
else '出境' end, 
(t6.PLAN_Y + t6.PLAN_B + t6.PLAN_H + t6.PLAN_K + t6.PLAN_L +
                       t6.PLAN_M + t6.PLAN_N + t6.PLAN_Q + t6. PLAN_T + t6.
                        PLAN_X + t6.PLAN_U + t6.PLAN_E + t6.PLAN_W + t6.PLAN_P +
                        t6.PLAN_P1 + t6.PLAN_P2 + t6.PLAN_O + t6. PLAN_G + t6.
                        PLAN_G1 + t6.
                        PLAN_G2 + t6.PLAN_R1 + t6.PLAN_R2 + t6.PLAN_R3 + t6.PLAN_R4 +
                        NVL(t6.PLAN_F, 0) + NVL(t6.PLAN_F1, 0) + NVL(t6.PLAN_F2, 0) +
                        NVL(t6.PLAN_F3, 0) + NVL(t6.PLAN_F4, 0) + NVL(t6.PLAN_C, 0) +
                        NVL(t6.PLAN_C1, 0) + NVL(t6.PLAN_C2, 0) +
                        NVL(t6.PLAN_C3, 0) + NVL(t6.PLAN_C4, 0) + NVL(t6.PLAN_S, 0) +
                        NVL(t6.PLAN_V, 0) + NVL(t6.PLAN_A, 0) + NVL(t6.PLAN_D, 0) +
                        NVL(t6.PLAN_I, 0) + NVL(t6.PLAN_J, 0) + NVL(t6.PLAN_Z, 0) +
                        NVL(t6.PLAN_P3, 0) + NVL(t6.PLAN_P4, 0) +
                        NVL(t6.PLAN_P5, 0))  座位数,
count(1)  预约数,
sum(case when t4.nationality ='KOR' then 1
else 0 end) 韩国籍人数,
sum(case when t4.nationality ='JPN' then 1
else 0 end) 日本籍人数
from cqsale.cq_order_head@to_air t1
join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
join cqsale.cq_flights_segment_head@to_air t3 on t2.segment_head_id=t3.segment_head_id
left join cqsale.cq_traveller_info@to_air t4 on t1.flights_order_head_id=t4.flights_order_head_id
left join cqsale.cq_flights_seats_amount_plan@to_air t6 on t1.segment_Head_id=t6.segment_Head_id
where t1.r_flights_date>=to_date('2020-02-24','yyyy-mm-dd')
and t1.r_flights_date<=to_date('2020-03-03','yyyy-mm-dd')+(trunc(sysdate)-to_date('2020-02-26','yyyy-mm-dd'))
and t1.flag_id in(3,5,40,41)
and t2.company_id=0
and t3.flag<>2
and t1.seats_name is not null
and t2.flights_segment_name like '%浦东%'
and t2.segment_country in('韩国')
group by t1.r_flights_date ,t2.flight_no ,t2.flights_segment_name ,
(t6.PLAN_Y + t6.PLAN_B + t6.PLAN_H + t6.PLAN_K + t6.PLAN_L +
                       t6.PLAN_M + t6.PLAN_N + t6.PLAN_Q + t6. PLAN_T + t6.
                        PLAN_X + t6.PLAN_U + t6.PLAN_E + t6.PLAN_W + t6.PLAN_P +
                        t6.PLAN_P1 + t6.PLAN_P2 + t6.PLAN_O + t6. PLAN_G + t6.
                        PLAN_G1 + t6.
                        PLAN_G2 + t6.PLAN_R1 + t6.PLAN_R2 + t6.PLAN_R3 + t6.PLAN_R4 +
                        NVL(t6.PLAN_F, 0) + NVL(t6.PLAN_F1, 0) + NVL(t6.PLAN_F2, 0) +
                        NVL(t6.PLAN_F3, 0) + NVL(t6.PLAN_F4, 0) + NVL(t6.PLAN_C, 0) +
                        NVL(t6.PLAN_C1, 0) + NVL(t6.PLAN_C2, 0) +
                        NVL(t6.PLAN_C3, 0) + NVL(t6.PLAN_C4, 0) + NVL(t6.PLAN_S, 0) +
                        NVL(t6.PLAN_V, 0) + NVL(t6.PLAN_A, 0) + NVL(t6.PLAN_D, 0) +
                        NVL(t6.PLAN_I, 0) + NVL(t6.PLAN_J, 0) + NVL(t6.PLAN_Z, 0) +
                        NVL(t6.PLAN_P3, 0) + NVL(t6.PLAN_P4, 0) +
                        NVL(t6.PLAN_P5, 0)),
case when  t2.origin_country_id>0 then '入境'
else '出境' end;

select t1.flight_date,sum(case when t1.flag=2 then 1 else 0 end),count(1),sum(case when t1.flag<>2 then 1 else 0 end)
 from dw.da_flight t1
 where t1.flight_date>=to_date('2020-02-01','yyyy-mm-dd')
   and t1.flight_date< to_date('2020-03-16','yyyy-mm-dd')
   and t1.segment_country='韩国'
   group by t1.flight_date


--74\泰国相关数据

select to_char(t2.flight_date,'yyyy') 年,to_char(t2.flight_date,'mmdd') 日期,
   case when t2.flights_segment_name like '%曼谷%' then '曼谷'
   when t2.flights_segment_name like '%普吉%' then '普吉'
   else '其他' end 航站类型,
   case when t2.origin_country_id>0 then '入境'
   else '出境' end 出入境类型,   
       t3.wf_segment,sum(t2.oversale) 座位数,      
       count(1) 航班量
  from  dw.da_flight t2 
  left join dw.dim_segment_type t3 on t2.h_route_id = t3.h_route_id
                                  and t2.route_id = t3.route_id
 where t2.flight_date >= to_date('2020-02-14','yyyy-mm-dd')
   and t2.flight_date <=to_date('2020-05-31', 'yyyy-mm-dd')
   and t2.flag<>2
   and t2.segment_country='泰国'
   group by to_char(t2.flight_date,'yyyy'),to_char(t2.flight_date,'mmdd'),
   case when t2.flights_segment_name like '%曼谷%' then '曼谷'
   when t2.flights_segment_name like '%普吉%' then '普吉'
   else '其他' end ,
   case when t2.origin_country_id>0 then '入境'
   else '出境' end ,   
       t3.wf_segment


      
union all




select to_char(t2.flight_date,'yyyy'),to_char(t2.flight_date,'mmdd'),
   case when t2.flights_segment_name like '%曼谷%' then '曼谷'
   when t2.flights_segment_name like '%普吉%' then '普吉'
   else '其他' end 航站类型,
   case when t2.origin_country_id>0 then '入境'
   else '出境' end 出入境类型,   
       t3.wf_segment,sum(t2.oversale),      
       count(1) 销量
  from  dw.da_flight t2 
  left join dw.dim_segment_type t3 on t2.h_route_id = t3.h_route_id
                                  and t2.route_id = t3.route_id
 where t2.flight_date >= to_date('2019-02-14','yyyy-mm-dd')
   and t2.flight_date <=to_date('2019-05-31', 'yyyy-mm-dd')
   and t2.flag<>2
   and t2.segment_country='泰国'
   group by to_char(t2.flight_date,'yyyy'),to_char(t2.flight_date,'mmdd'),
   case when t2.flights_segment_name like '%曼谷%' then '曼谷'
   when t2.flights_segment_name like '%普吉%' then '普吉'
   else '其他' end ,
   case when t2.origin_country_id>0 then '入境'
   else '出境' end ,   
       t3.wf_segment;

--75\
--李剑总要求的数据
--日期、航线、航班号、机型、座位数、可供座公里、国际航段当日是否独飞

select t1.flight_date 航班日期,t1.flights_segment 航段,
t1.route_name 航段中文,t1.flight_no 航班号,t3.ac_type 机型,t1.plan 座位数,round(t1.checkin_s_mile,0) 可供座公里 ,null 国际航段当日是否独飞
 from hdb.recent_flights_cost t1
 left join (select t2.flights_no,t2.flights_date,max(ac_type) ac_type
                from cqsale.cq_flights@to_air t2 
                group by t2.flights_no,t2.flights_date)t3 on t1.flight_date=t3.flights_date and t1.flight_no=t3.flights_no
                where t1.flight_date>=to_date('2020-01-23','yyyy-mm-dd')
                   and t1.flight_date<=to_date('2020-02-29','yyyy-mm-dd')
                   and  t1.checkin_s_mile>0
                   and t1.nation_flag in(2,3)
                   

--76\
各位领导，同仁：关于我司经停国际航线申报，现在有个紧急需求，需要远点座位数，和近点座位数，请收益部门安排人员汇总1月23日至3月1日期间，我司经停航线座位数布局统计，
诸如：哈尔滨～北海～曼谷航线，哈尔滨～曼谷往返座位数分别是？北海～曼谷往返座位数分别是？因为非常紧急，请中午前提供，谢谢！


--1月23日至3月1日

select t1.flight_date,t1.flight_no,t1.route_name,t1.flights_segment_name,t1.segment_type,t1.oversale,(t6.PLAN_Y + t6.PLAN_B + t6.PLAN_H + t6.PLAN_K + t6.PLAN_L +
                       t6.PLAN_M + t6.PLAN_N + t6.PLAN_Q + t6. PLAN_T + t6.
                        PLAN_X + t6.PLAN_U + t6.PLAN_E + t6.PLAN_W + t6.PLAN_P +
                        t6.PLAN_P1 + t6.PLAN_P2 + t6.PLAN_O + t6. PLAN_G + t6.
                        PLAN_G1 + t6.
                        PLAN_G2 + t6.PLAN_R1 + t6.PLAN_R2 + t6.PLAN_R3 + t6.PLAN_R4 +
                        NVL(t6.PLAN_F, 0) + NVL(t6.PLAN_F1, 0) + NVL(t6.PLAN_F2, 0) +
                        NVL(t6.PLAN_F3, 0) + NVL(t6.PLAN_F4, 0) + NVL(t6.PLAN_C, 0) +
                        NVL(t6.PLAN_C1, 0) + NVL(t6.PLAN_C2, 0) +
                        NVL(t6.PLAN_C3, 0) + NVL(t6.PLAN_C4, 0) + NVL(t6.PLAN_S, 0) +
                        NVL(t6.PLAN_V, 0) + NVL(t6.PLAN_A, 0) + NVL(t6.PLAN_D, 0) +
                        NVL(t6.PLAN_I, 0) + NVL(t6.PLAN_J, 0) + NVL(t6.PLAN_Z, 0) +
                        NVL(t6.PLAN_P3, 0) + NVL(t6.PLAN_P4, 0) +
                        NVL(t6.PLAN_P5, 0))
  from dw.da_flight t1
  left join cqsale.cq_flights_seats_amount_plan@to_air t6 on t1.segment_Head_id=t6.segment_Head_id
  where t1.flight_date>=to_date('2020-01-23','yyyy-mm-dd')
    and t1.flight_date<=to_date('2020-03-01','yyyy-mm-dd')
    and t1.flag<>2
    and t1.company_id=0
    and t1.segment_type like '%经停%'
    and t1.nationflag<>'国内'
    order by 1,2,3




--77\ 国际地区航线数据

--xuheng@ch.com


select t1.flight_date 航班日期,t1.flight_no 航班号,t1.segment_code 航段,t1.flights_segment_name 航段中文,t1.layout 机型座位数
from dw.da_flight t1
where t1.flight_date>=to_date('2020-03-01','yyyy-mm-dd')
and t1.flight_date< to_date('2020-03-09','yyyy-mm-dd')
and t1.flag<>2
and t1.company_id=0
and t1.nationflag<>'国内';

--78\ 帮我看下1月23日-3月1日我们国际地区航线一共起降架次，运输人数，整体客座率

select count(1) 起降架次,sum(t1.boardnum) 运输人数,sum(t1.boardnum*t3.mile)/sum(t3.layout*t3.mile) 客座率
from dw.da_foc_order t1
join(
select flights_id,segment_code,t2.flag,t2.nationflag,t2.company_id,t2.mile,t2.layout
from dw.da_flight t2
where t2.flag<>2
and t2.flight_date>=to_date('2020-01-23','yyyy-mm-dd')
and t2.flight_date<=to_date('2020-02-29','yyyy-mm-dd')
and t2.company_id=0
) t3 on t1.flights_id=t3.flights_id and t1.segment_code=t3.segment_code
where t1.flights_date>=to_date('2020-01-23','yyyy-mm-dd')
  and t1.flights_date<=to_date('2020-02-29','yyyy-mm-dd')
  and t3.nationflag<>'国内'
  and t3.flag<>2
  and t3.company_id=0;


--79\

select to_char(t1.flights_date,'yyyy'),count(1) 起降架次,sum(t1.boardnum) 运输人数,sum(t1.boardnum*t3.mile)/sum(t3.layout*t3.mile) 客座率
from dw.da_foc_order t1
join(
select flights_id,segment_code,t2.flag,t2.nationflag,t2.company_id,t2.mile,t2.layout
from dw.da_flight t2
where t2.flag<>2
and t2.flight_date>=to_date('2018-01-01','yyyy-mm-dd')
and t2.flight_date< to_date('2020-01-01','yyyy-mm-dd')
and t2.company_id=0
) t3 on t1.flights_id=t3.flights_id and t1.segment_code=t3.segment_code
where t1.flights_date>=to_date('2018-01-01','yyyy-mm-dd')
  and t1.flights_date< to_date('2020-01-01','yyyy-mm-dd')
  and t3.nationflag='国际'
  and t3.flag<>2
  and t3.company_id=0
  group by to_char(t1.flights_date,'yyyy');
  
  

select --distinct t2.segment_code,t2.flights_segment_name,t4.wf_segment
count(distinct t4.wf_segment)
from dw.da_flight t2
left join dw.dim_segment_type t4 on t2.route_id=t4.route_id and t2.h_route_id=t4.h_route_id
where t2.flag<>2
and t2.flight_date>=to_date('2019-01-01','yyyy-mm-dd')
and t2.flight_date< to_date('2020-01-01','yyyy-mm-dd')
 and t2.nationflag='国际'
 and t2.company_id=0 
and not exists(select 1
  from dw.da_flight t3
where t3.flag<>2
and t3.flight_date>=to_date('2018-01-01','yyyy-mm-dd')
and t3.flight_date< to_date('2019-01-01','yyyy-mm-dd')
and t3.segment_code=t2.segment_code);



select --distinct t2.segment_code,t2.flights_segment_name,t4.wf_segment
count(distinct t4.wf_segment)
from dw.da_flight t2
left join dw.dim_segment_type t4 on t2.route_id=t4.route_id and t2.h_route_id=t4.h_route_id
where t2.flag<>2
and t2.flight_date>=to_date('2019-01-01','yyyy-mm-dd')
and t2.flight_date< to_date('2020-01-01','yyyy-mm-dd')
 and t2.nationflag='国际'
 and t2.company_id=0 
 and t2.segment_country='柬埔寨';
 
 
select /*+parallel(4) */
 count(1)
   from dw.fact_order_detail t1
   join dw.bi_order_region t2 on t1.flights_order_head_id=t2.flights_Order_head_id
   join dw.da_flight t3 on t1.segment_Head_id=t3.segment_Head_id
   where t3.flag<>2
     and t1.flag_id=40
	 and t1.seats_name is not null
	 and t3.nationflag='国际'
	and t1.flights_date>=to_date('2019-01-01','yyyy-mm-dd')
 and t1.flights_date< to_date('2020-01-01','yyyy-mm-dd')
 and t1.company_id=0
 and not regexp_like(t2.nationality,'(中国)|(香港)|(澳门)|(台湾)')
  
 


--80\

select h1.ordermonth,count(1) ordernum,sum(case when h2.flights_order_id is not null then 1 else 0 end),
       sum(h2.booknum),sum(h2.bookfee)       
from(
select t1.flights_order_id,to_char(t1.order_day,'yyyymm') ordermonth,count(1) ticketnum
from dw.fact_order_detail t1
   join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
      left join dw.da_restrict_userinfo t3 on t1.client_id=t3.users_id  
 where  t1.order_day>=to_date('2019-01-01','yyyy-mm-dd')
    and t1.order_day< to_date('2020-03-01','yyyy-mm-dd')
    and t1.company_id=0
    and t1.channel in('网站','手机')
    and t3.users_id is null
    group by t1.flights_order_id,to_char(t1.order_day,'yyyymm'))h1  
  left join (
  select t1.flights_order_id,sum(t1.book_num) booknum,sum(t1.book_fee) bookfee
  from dw.fact_other_order_detail t1
  where t1.channel in('网站','手机')
    and t1.pay_together=0
    and (t1.xtype_id in(1,2,4,11,6,7,10,17) or (t1.xtype_id =21 and regexp_like(lower(t1.xproduct_name),'(wifi)|(wf)|(4G)|(上网卡)')))
    and t1.order_day>=to_date('2019-01-01','yyyy-mm-dd')
    and t1.order_day< to_date('2020-03-01','yyyy-mm-dd')
    and t1.company_id=0
    group by t1.flights_order_id)h2 on h1.flights_order_id=h2.flights_order_id 
    group by h1.ordermonth;

    
     


--81\
--82\
--83\
--84\
--85\
--86\
--87\
--88\
--89\
--90\
--91\
--92\
--93\
--94\
--95\
--96\
--97\
--98\
--99\
--100\
--101\
--102\
--103\
--104\
--105\
--106\
--107\
--108\
--109\
--110\
--111\
--112\
--113\
--114\
--115\
--116\
--117\
--118\
--119\
--120\
--121\
--122\
--123\
--124\
--125\
--126\
--127\
--128\
--129\
--130\
--131\
--132\
--133\
--134\
--135\
--136\
--137\
--138\
--139\
--140\
--141\
--142\
--143\
--144\
--145\
--146\
--147\
--148\
--149\
--150\
--151\
--152\
--153\
--154\
--155\
--156\
--157\
--158\
--159\
--160\
--161\
--162\
--163\
--164\
--165\
--166\
--167\
--168\
--169\
--170\
--171\
--172\
--173\
--174\
--175\
--176\
--177\
--178\
--179\
--180\
--181\
--182\
--183\
--184\
--185\
--186\
--187\
--188\
--189\
--190\
--191\
--192\
--193\
--194\
--195\
--196\
--197\
--198\
--199\
--200\
--201\
--202\
--203\
--204\
--205\
--206\
--207\
--208\
--209\
--210\
--211\
--212\
--213\
--214\
--215\
--216\
--217\
--218\
--219\
--220\
--221\
--222\
--223\
--224\
--225\
--226\
--227\
--228\
--229\
--230\
--231\
--232\
--233\
--234\
--235\
--236\
--237\
--238\
--239\
--240\
--241\
--242\
--243\
--244\
--245\
--246\
--247\
--248\
--249\
--250\
--251\
--252\
--253\
--254\
--255\
--256\
--257\
--258\
--259\
--260\
--261\
--262\
--263\
--264\
--265\
--266\
--267\
--268\
--269\
--270\
--271\
--272\
--273\
--274\
--275\
--276\
--277\
--278\
--279\
--280\
--281\
--282\
--283\
--284\
--285\
--286\
--287\
--288\
--289\
--290\
--291\
--292\
--293\
--294\
--295\
--296\
--297\
--298\
--299\
--300\
  
