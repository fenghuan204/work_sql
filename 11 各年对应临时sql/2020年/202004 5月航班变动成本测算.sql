select tp1.wf_segment_name 往返航线,tp1.route_name 航段,tp1.flight_no 航班号,
decode(tp1.nation_flag,1,'国内',2,'区域',3,'国际') 航线性质,
case when tp2.route_name is not null then '老航线'
when tp2.route_name is null and tp3.route_name is not null then '新增航班号'
when tp2.route_name is null and tp3.route_name is null then '4月无此航线'
end "5月是否有计划航班",
nvl(tp2.perhour_cost,tp3.perhour_cost) 小时变动成本,
nvl(tp2.avgtime,tp3.avgtime)  "4月平均轮档小时",
nvl(tp2.avgcaofee,tp3.avgcaofee) "4月平均航油费",
nvl(tp2.down_fee,tp3.down_fee) "每小时航油下降费用",
/*nvl(tp2.avghourdown,tp3.avghourdown) avghourdown,
nvl(tp2.avg_down,tp3.avg_down) avg_down,*/
nvl(tp2.stddev,tp3.stddev) "4月小时变动成本标准差",
nvl(nvl(tp2.perhour_cost-tp2.down_fee,tp3.perhour_cost-tp3.down_fee),tp4.perhour_cost-tp4.down_fee) "5月份预估变动成本"
from(
select distinct t2.wf_segment_name,t1.route_name,case when t1.segment_type like '经停' then 1 else 0 end segment_type,
t1.root_nation_flag nation_flag ,t1.flight_no
from dw.da_flight t1
join dw.dim_segment_type t2 on t1.h_route_id=t2.h_route_id and t1.route_id=t2.route_id
where t1.flight_date>=to_date('2020-05-01','yyyy-mm-dd')
  and t1.flight_date< to_date('2020-06-01','yyyy-mm-dd')
  and t1.flag<>2
  and t1.company_id=0)tp1
  left join (
select *
from(
(
select h1.route_name,h1.flight_no,sum(h1.vari_cost) vari_cost,sum(h1.round_time) round_time,sum(h1.cao_fee) cao_fee,
sum(h1.vari_cost)/sum(h1.round_time) perhour_cost,
sum(h1.cao_fee)/sum(h1.round_time) hour_fee, --每小时用油量
(sum(h1.cao_fee)/sum(h1.round_time)/3029)*1680 lasthour_fee,  --每小时用油金额
sum(h1.cao_fee)/sum(h1.round_time) -(sum(h1.cao_fee)/sum(h1.round_time)/3029)*1680 down_fee,
avg(h1.hour_down) avghourdown,
avg(h1.cao_fee) avgcaofee,
h1.avg_down,
h1.stddev,
avg(h1.round_time) avgtime
from(
select route_name,flight_no,vari_cost,cao_fee,round_time,hourfee,last_hourfee,hour_down,
avg(hour_down)OVER (PARTITION BY route_name,flight_no) avg_down,
STDDEV (hour_down) OVER (PARTITION BY route_name,flight_no)     stddev
from(
select t1.route_name,t1.flight_no,t1.vari_cost,t1.cao_fee,t1.round_time,
t1.cao_fee/t1.round_time hourfee,
(t1.cao_fee/t1.round_time/3029)*1680 last_hourfee,
t1.cao_fee/t1.round_time-(t1.cao_fee/t1.round_time/3029)*1680 hour_down
 from hdb.recent_flights_cost t1
 where t1.flight_date>=to_date('2020-04-01','yyyy-mm-dd')
   and t1.flight_date< to_date('2020-05-01','yyyy-mm-dd')
   and t1.round_time>0
   and t1.total_cost>0
   and t1.vari_cost>0
   and t1.qr_flag=1
   and t1.checkin_s_mile>0
   and exists(  
   select   1
   from(
    select t2.route_name,t2.flight_no,t2.flight_date,count(1) num1
                   from dw.da_flight t2
                   where t2.flag<>2
                   and t2.flight_date>=to_date('2020-04-01','yyyy-mm-dd')
           and t2.flight_date< to_date('2020-05-01','yyyy-mm-dd')
           and t2.company_id=0
           and t2.segment_type like '%经停%'
           group by t2.route_name,t2.flight_no,t2.flight_date
           having count(1)=3)h1
       where h1.route_name=t1.route_name
       and h1.flight_no=t1.flight_no
       and h1.flight_date=t1.flight_date))h1
       group by route_name,flight_no,vari_cost,cao_fee,round_time,hourfee,last_hourfee,hour_down)h1
group by h1.route_name,h1.flight_no,h1.avg_down,h1.stddeV)

union all


--直飞航班
(
select h1.route_name,h1.flight_no,sum(h1.vari_cost) vari_cost,sum(h1.round_time) round_time,sum(h1.cao_fee) cao_fee,
sum(h1.vari_cost)/sum(h1.round_time) perhour_cost,
sum(h1.cao_fee)/sum(h1.round_time) hour_fee, --每小时用油量
(sum(h1.cao_fee)/sum(h1.round_time)/3029)*1680 lasthour_fee,  --每小时用油金额
sum(h1.cao_fee)/sum(h1.round_time) -(sum(h1.cao_fee)/sum(h1.round_time)/3029)*1680 down_fee,
avg(h1.hour_down) avghourdown,
avg(h1.cao_fee) avgcaofee,
h1.avg_down,
h1.stddev,
avg(h1.round_time) avgtime
from(
select route_name,flight_no,vari_cost,cao_fee,round_time,hourfee,last_hourfee,hour_down,
avg(hour_down)OVER (PARTITION BY route_name,flight_no) avg_down,
STDDEV (hour_down) OVER (PARTITION BY route_name,flight_no)     stddev
from(
select t1.route_name,t1.flight_no,t1.vari_cost,t1.cao_fee,t1.round_time,
t1.cao_fee/t1.round_time hourfee,
(t1.cao_fee/t1.round_time/3029)*1680 last_hourfee,
t1.cao_fee/t1.round_time-(t1.cao_fee/t1.round_time/3029)*1680 hour_down
 from hdb.recent_flights_cost t1
 where t1.flight_date>=to_date('2020-04-01','yyyy-mm-dd')
   and t1.flight_date< to_date('2020-05-01','yyyy-mm-dd')
   and t1.round_time>0
   and t1.total_cost>0
   and t1.vari_cost>0
   and t1.checkin_s_mile>0
   and t1.qr_flag is  null
   )h1
       group by route_name,flight_no,vari_cost,cao_fee,round_time,hourfee,last_hourfee,hour_down)h1
group by h1.route_name,h1.flight_no,h1.avg_down,h1.stddeV))
  
  )tp2 on tp1.route_name=tp2.route_name and tp1.flight_no=tp2.flight_no
  left join (select *
from(
select *
from(
select h1.route_name,sum(h1.vari_cost) vari_cost,sum(h1.round_time) round_time,sum(h1.cao_fee) cao_fee,
sum(h1.vari_cost)/sum(h1.round_time) perhour_cost,
sum(h1.cao_fee)/sum(h1.round_time) hour_fee, --每小时用油量
(sum(h1.cao_fee)/sum(h1.round_time)/3029)*1680 lasthour_fee,  --每小时用油金额
sum(h1.cao_fee)/sum(h1.round_time) -(sum(h1.cao_fee)/sum(h1.round_time)/3029)*1680 down_fee,
avg(h1.hour_down) avghourdown,
avg(h1.cao_fee) avgcaofee,
h1.avg_down,
h1.stddev,
avg(h1.round_time) avgtime
from(
select route_name,vari_cost,cao_fee,round_time,hourfee,last_hourfee,hour_down,
avg(hour_down)OVER (PARTITION BY route_name) avg_down,
STDDEV (hour_down) OVER (PARTITION BY route_name)     stddev
from(
select t1.route_name,t1.vari_cost,t1.cao_fee,t1.round_time,
t1.cao_fee/t1.round_time hourfee,
(t1.cao_fee/t1.round_time/3029)*1680 last_hourfee,
t1.cao_fee/t1.round_time-(t1.cao_fee/t1.round_time/3029)*1680 hour_down
 from hdb.recent_flights_cost t1
 where t1.flight_date>=to_date('2020-04-01','yyyy-mm-dd')
   and t1.flight_date< to_date('2020-05-01','yyyy-mm-dd')
   and t1.round_time>0
   and t1.total_cost>0
   and t1.vari_cost>0
   and t1.qr_flag=1
   and t1.checkin_s_mile>0
   and exists(  
   select   1
   from(
    select t2.route_name,t2.flight_no,t2.flight_date,count(1) num1
                   from dw.da_flight t2
                   where t2.flag<>2
                   and t2.flight_date>=to_date('2020-04-01','yyyy-mm-dd')
           and t2.flight_date< to_date('2020-05-01','yyyy-mm-dd')
           and t2.company_id=0
           and t2.segment_type like '%经停%'
           group by t2.route_name,t2.flight_no,t2.flight_date
           having count(1)=3)h1
       where h1.route_name=t1.route_name
       and h1.flight_no=t1.flight_no
       and h1.flight_date=t1.flight_date)
     )h1
       group by route_name,vari_cost,cao_fee,round_time,hourfee,last_hourfee,hour_down)h1
group by h1.route_name,h1.avg_down,h1.stddeV)

union all

select *
from(
select h1.route_name,sum(h1.vari_cost) vari_cost,sum(h1.round_time) round_time,sum(h1.cao_fee) cao_fee,
sum(h1.vari_cost)/sum(h1.round_time) perhour_cost,
sum(h1.cao_fee)/sum(h1.round_time) hour_fee, --每小时用油量
(sum(h1.cao_fee)/sum(h1.round_time)/3029)*1680 lasthour_fee,  --每小时用油金额
sum(h1.cao_fee)/sum(h1.round_time) -(sum(h1.cao_fee)/sum(h1.round_time)/3029)*1680 down_fee,
avg(h1.hour_down) avghourdown,
avg(h1.cao_fee) avgcaofee,
h1.avg_down,
h1.stddev,
avg(h1.round_time) avgtime
from(
select route_name,vari_cost,cao_fee,round_time,hourfee,last_hourfee,hour_down,
avg(hour_down)OVER (PARTITION BY route_name) avg_down,
STDDEV (hour_down) OVER (PARTITION BY route_name)     stddev
from(
select t1.route_name,t1.vari_cost,t1.cao_fee,t1.round_time,
t1.cao_fee/t1.round_time hourfee,
(t1.cao_fee/t1.round_time/3029)*1680 last_hourfee,
t1.cao_fee/t1.round_time-(t1.cao_fee/t1.round_time/3029)*1680 hour_down
 from hdb.recent_flights_cost t1
 where t1.flight_date>=to_date('2020-04-01','yyyy-mm-dd')
   and t1.flight_date< to_date('2020-05-01','yyyy-mm-dd')
   and t1.round_time>0
   and t1.total_cost>0
   and t1.vari_cost>0
   and t1.checkin_s_mile>0
   and t1.qr_flag is  null
   )h1
       group by route_name,vari_cost,cao_fee,round_time,hourfee,last_hourfee,hour_down)h1
group by h1.route_name,h1.avg_down,h1.stddeV))hh1  
  
  )tp3 on tp1.route_name=tp3.route_name
  
  left join(
  select h1.nation_flag,sum(h1.vari_cost) vari_cost,sum(h1.round_time) round_time,sum(h1.cao_fee) cao_fee,
sum(h1.vari_cost)/sum(h1.round_time) perhour_cost,
sum(h1.cao_fee)/sum(h1.round_time) hour_fee, --每小时用油量
(sum(h1.cao_fee)/sum(h1.round_time)/3029)*1680 lasthour_fee,  --每小时用油金额
sum(h1.cao_fee)/sum(h1.round_time) -(sum(h1.cao_fee)/sum(h1.round_time)/3029)*1680 down_fee,
avg(h1.round_time) avgtime,
avg(h1.cao_fee) avgcao
from(
select t1.nation_flag,t1.route_name,t1.vari_cost,t1.cao_fee,t1.round_time,
t1.cao_fee/t1.round_time hourfee,
(t1.cao_fee/t1.round_time/3029)*1680 last_hourfee,
t1.cao_fee/t1.round_time-(t1.cao_fee/t1.round_time/3029)*1680 hour_down
 from hdb.recent_flights_cost t1
 where t1.flight_date>=to_date('2020-04-01','yyyy-mm-dd')
   and t1.flight_date< to_date('2020-05-01','yyyy-mm-dd')
   and t1.round_time>0
   and t1.total_cost>0
   and t1.vari_cost>0
   and t1.checkin_s_mile>0
   and t1.qr_flag is  null
   
   union all
   
   select  t1.nation_flag,t1.route_name,t1.vari_cost,t1.cao_fee,t1.round_time,
t1.cao_fee/t1.round_time hourfee,
(t1.cao_fee/t1.round_time/3029)*1680 last_hourfee,
t1.cao_fee/t1.round_time-(t1.cao_fee/t1.round_time/3029)*1680 hour_down
 from hdb.recent_flights_cost t1
 where t1.flight_date>=to_date('2020-04-01','yyyy-mm-dd')
   and t1.flight_date< to_date('2020-05-01','yyyy-mm-dd')
   and t1.round_time>0
   and t1.total_cost>0
   and t1.vari_cost>0
   and t1.qr_flag=1
   and t1.checkin_s_mile>0
   and exists(  
   select   1
   from(
    select t2.route_name,t2.flight_no,t2.flight_date,count(1) num1
                   from dw.da_flight t2
                   where t2.flag<>2
                   and t2.flight_date>=to_date('2020-04-01','yyyy-mm-dd')
           and t2.flight_date< to_date('2020-05-01','yyyy-mm-dd')
           and t2.company_id=0
           and t2.segment_type like '%经停%'
           group by t2.route_name,t2.flight_no,t2.flight_date
           having count(1)=3)h1
       where h1.route_name=t1.route_name
       and h1.flight_no=t1.flight_no
       and h1.flight_date=t1.flight_date)
     )h1
     group by h1.nation_flag 
  )tp4 on tp1.nation_flag=tp4.nation_flag
  
