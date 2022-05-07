--创建 dw.fact_combo_ticket

create table dw.fact_combo_ticket as 
select
 trunc(t1.r_order_date) order_day,
             t1.r_flights_date,
       t1.segment_head_id,
       t1.whole_segment,
       h3.create_id,
       case when t1.sex=2 then '想飞就飞儿童礼包'
            when h3.create_id ='9971' then '想飞就飞精选礼包'
            when h3.create_id='10009' then '想飞就飞惠选礼包'
            when h3.create_id ='10010' then '想飞就飞优选礼包' end combo_name,
             case when t1.flag_id in(3,5,40,41) then 1
              else 0 end payflag,     
       1 ticket_num,       
       h5.yhq_money yhq_money,
       t1.flights_order_head_id,
       t1.name||coalesce(t1.second_name,'') sname,
       t1.flag_id,
       h3.users_id
   from yhq.cq_new_yhq_relation h3 
   join yhq.cq_new_yhq_history  h4 on h4.yhq_id=h3.id
          join yhq.cq_new_yhq_history_detail h5 on h4.id = h5.history_id
          join cqsale.cq_order_head t1 on h5.order_head_id = t1.flights_order_head_id
              where t1.flag_id in (3, 5, 40, 41,7,11,12)
           and t1.r_order_date >=to_date('2020-07-15 18:00:00', 'yyyy-mm-dd hh24:mi:ss')
           and t1.r_flights_date >=to_date('2020-07-15 18:00:00', 'yyyy-mm-dd hh24:mi:ss')
           and h4.create_date >=to_date('2020-07-15 18:00:00', 'yyyy-mm-dd hh24:mi:ss')
   and t1.seats_name not in('O','D')
   and t1.ticket_price=0
   and h3.create_date>=to_date('2020-07-15 18:00:00', 'yyyy-mm-dd hh24:mi:ss')
   and h3.create_id in(9971,10009,10010);
   
---乘机频次总榜
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
 where rownum<=10;
 
 --总省钱榜
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
 
 
 ---乘机频次周榜

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
 
