/*
\*7.15-8.9   飞行次数，飞行里程，省钱。
8.3-8.9    航线指数、最热目的地，以这个为准*\


--营销宣传使用

select count(distinct t2.origincity_name) 始发城市数量,count(distinct t2.destcity_name) 抵达城市数量,
       count(distinct t2.flights_city_name) 航线数量,count(distinct t2.segment_head_id) 航班量
  from dw.fact_combo_ticket t1
  join dw.da_flight t2 on t1.segment_head_id = t2.segment_head_id
 where t1.payflag=1;

select rownum TOP,flights_city_name 航线
 from(
select t2.flights_city_name,sum(t1.ticket_num)
  from dw.fact_combo_ticket t1
  join dw.da_flight t2 on t1.segment_head_id = t2.segment_head_id
 where t1.flag_id=40
    and t1.r_flights_date>=to_date('2020-07-15','yyyy-mm-dd')
    and t1.r_flights_date<=to_date('2020-08-16','yyyy-mm-dd')
group by t2.flights_city_name
order by 2 desc)h1
where rownum<=30;


select rownum TOP,destcity_name 目的地
from(
select t2.destcity_name,sum(t1.ticket_num)
  from dw.fact_combo_ticket t1
  join dw.da_flight t2 on t1.segment_head_id = t2.segment_head_id
 where t1.flag_id=40
     and t1.r_flights_date>=to_date('2020-07-15','yyyy-mm-dd')
    and t1.r_flights_date<=to_date('2020-08-16','yyyy-mm-dd')
group by t2.destcity_name
order by 2 desc)
where rownum<=30;*/



---维度1---乘机频次总榜

select rownum 排序,split_part(sname,' -',1) 姓名, ticketnum 乘机频次,mile 里程数
froM(
select t1.sname,decode(t1.combo_name,'想飞就飞惠选礼包',2999,'想飞就飞精选礼包',3499,'想飞就飞优选礼包',3999) comprice,
count(1) ticketnum,suM(t2.mile) mile,sum(t1.yhq_money) yhq_money
  from dw.fact_combo_ticket t1
  join dw.da_flight t2 on t1.segment_head_id = t2.segment_head_id
 where t1.flag_id =40
 and t2.flag<>2
 and t1.r_flights_date>=to_date('2020-07-15','yyyy-mm-dd')
 and t1.r_flights_date<=trunc(sysdate,'iw')-1
 group by t1.sname,decode(t1.combo_name,'想飞就飞惠选礼包',2999,'想飞就飞精选礼包',3499,'想飞就飞优选礼包',3999)
 order by 3 desc,4 desc)
 where rownum<=10
 

/*
--维度2 

select rownum 排序,split_part(sname,' -',1) 姓名, mile 里程数
froM(
select t1.sname,count(1) ticketnum,suM(t2.mile) mile
  from dw.fact_combo_ticket t1
  join dw.da_flight t2 on t1.segment_head_id = t2.segment_head_id
 where t1.flag_id =40
 and t2.flag<>2
 and t1.r_flights_date>=to_date('2020-07-15','yyyy-mm-dd')
 and t1.r_flights_date<=to_date('2020-08-16','yyyy-mm-dd')
 group by t1.sname
 order by 3 desc,2 desc)
 where rownum<=10*/

---维度4---省钱总榜

select rownum 排序,split_part(sname,' -',1) 姓名,yhq_money 节省金额
froM(
select h1.sname,yhq_money  yhq_money
from(
select t1.sname, decode(t1.combo_name,'想飞就飞惠选礼包',2999,'想飞就飞精选礼包',3499,'想飞就飞优选礼包',3999) comprice,
sum(t1.yhq_money) yhq_money
  from dw.fact_combo_ticket t1
  join dw.da_flight t2 on t1.segment_head_id = t2.segment_head_id
 where t1.flag_id =40
 and t2.flag<>2
  and t1.r_flights_date>=to_date('2020-07-15','yyyy-mm-dd')
 and t1.r_flights_date<=trunc(sysdate,'iw')-1
 group by t1.sname, decode(t1.combo_name,'想飞就飞惠选礼包',2999,'想飞就飞精选礼包',3499,'想飞就飞优选礼包',3999))h1
 order by 2 desc)h1
 where rownum<=10;
 
 
 
 
 ---维度1---乘机频次周榜

select rownum 排序,split_part(sname,' -',1) 姓名, ticketnum 乘机频次,mile 里程数
froM(
select t1.sname,decode(t1.combo_name,'想飞就飞惠选礼包',2999,'想飞就飞精选礼包',3499,'想飞就飞优选礼包',3999) comprice,
count(1) ticketnum,suM(t2.mile) mile,sum(t1.yhq_money) yhq_money
  from dw.fact_combo_ticket t1
  join dw.da_flight t2 on t1.segment_head_id = t2.segment_head_id
 where t1.flag_id =40
 and t2.flag<>2
 and t1.r_flights_date>=trunc(sysdate,'iw')-7
 and t1.r_flights_date<=trunc(sysdate,'iw')-1
 group by t1.sname,decode(t1.combo_name,'想飞就飞惠选礼包',2999,'想飞就飞精选礼包',3499,'想飞就飞优选礼包',3999)
 order by 3 desc,4 desc)
 where rownum<=10
 
 


  
 /*select t1.create_date 退订套票购买时间,t1.ticket_id,t1.buy_user_id 购买人,t1.combo_price 购买套票金额,t1.user_id 绑定userid,
 t1.yhq_batch_id 退订套票优惠批次,t1.LAST_UPDATE_TIME 最后更新时间,t1.status 退订状态,
 t2.orderday 乘机机票订单日期,t2.minflightdate 乘机机票乘机时间,t2.combo_name 乘机对应套票名称,t2.create_id 乘机对应套票优惠批次,
 t3.create_date 已兑创建时间,t3.combo_price 已兑套票金额, t3.ticket_id 目前已兑套票id,t3.user_id 已兑套票usersid,
 t3.yhq_batch_id 已兑套票优惠批次,t3.status 已兑状态,
 case when t1.create_date>t3.create_date then '先购买退订'
 when t1.create_date<=t3.create_date then '后购买退订' end 购买时间类型,
 case when t1.combo_price>t3.combo_price then '前高后低'
 when t1.combo_price< t3.combo_price then '前低后高'
  when t1.combo_price= t3.combo_price then '前后一致' 
  end 前后套票类型
 
 from yhq.cq_yhq_unlimited_combo@to_air t1
 join(select t1.users_id,t1.combo_name,t1.create_id,min(t1.order_day) orderday,min(t1.r_flights_date) minflightdate
  from dw.fact_combo_ticket t1
  where t1.flag_id=40
  group by t1.users_id,t1.combo_name,t1.create_id
  )t2 on t1.user_id=t2.users_id 
  left join yhq.cq_yhq_unlimited_combo@to_air t3 on t2.users_id=t3.user_id and t3.yhq_batch_id=t2.create_id and t3.status=1
  where t1.status=2;
  
*/
