create materialized view V_REP_SEGMENT_VARICOST
refresh force on demand
start with to_date('25-05-2022 07:45:00', 'dd-mm-yyyy hh24:mi:ss') next TRUNC(SYSDATE) + 1 + 7.75 / 24 
as
select mid1.flightno,mid1.flights_segment_name,mid1.round_time/60 round_time,

case when mid2.vari_cost is not null or mid3.vari_cost is not null
or mid4.vari_cost is not null then nvl(nvl(mid2.vari_cost,mid3.vari_cost),mid4.vari_cost)
when sc1.flights_city_name is not null or sc1.flights_city_name is not null
then nvl(sc1.varicosthour,sc1.varicosthour)*(mid1.round_time/60)
when third1.originairport_name is not null or third2.originairport_name is not null
then nvl(third1.varicosthour,third2.varicosthour)*(mid1.round_time/60)
when four.income_type is not null
then  four.varicosthour*(mid1.round_time/60)
when six.nationflag is not null
then  six.varicosthour*(mid1.round_time/60)
else five.varicosthour*(mid1.round_time/60)
end vari_cost,
nvl(nvl(mid2.vari_cost,mid3.vari_cost),mid4.vari_cost) cost1,
nvl(sc1.varicosthour,sc1.varicosthour)*(mid1.round_time/60) cost2,
nvl(third1.varicosthour,third2.varicosthour)*(mid1.round_time/60) cost3,
four.varicosthour*(mid1.round_time/60)  cost4,
six.varicosthour*(mid1.round_time/60)  cost5,
five.varicosthour*(mid1.round_time/60)  cost6
from
(
select tp1.whole_flight,tp1.flightno,tp1.flights_segment_name,
replace(replace(replace(replace(tp1.flights_segment_name,'成都天府','成都'),'茅台','遵义'),'虹桥','上海'),'浦东','上海') flights_city_name,
tp1.round_time,count(distinct tp1.flights_id) fnum
from(
select t2.flight_date,t2.flight_no whole_flight,
case when t2.segment_type like '%经停AB%' then t2.flight_no||'X'
when t2.segment_type like '%经停BC%' then t2.flight_no||'Y'
when t2.segment_type like '%经停AC%' then t2.flight_no||'X'
else t2.flight_no end flightno,
case when t2.segment_type like '%经停AC%'
then split_part(t2.route_name,'－',1)||'－'||split_part(t2.route_name,'－',2)
else t2.flights_segment_name end flights_segment_name,
t2.route_name,
t3.round_time,
t4.round_time alltime,
t2.flights_id,
t2.layout,
t5.wf_segment_name
  from dw.da_flight t2
  left join if.v_rep_segment_roundtime t3 on (case when t2.segment_type like '%经停AC%' then
  split_part(t2.route_name,'－',1)||'－'||split_part(t2.route_name,'－',2)
  else t2.flights_segment_name end) =t3.flights_segment_name
  left join if.v_rep_segment_roundtime t4 on t2.route_name=t4.flights_segment_name
 left join dw.dim_segment_type t5 on t2.h_route_id = t5.h_route_id and t2.route_id = t5.route_id
  where t2.flight_date>=trunc(sysdate)
    --and t2.flight_date<=trunc(sysdate)+14
    and t2.flight_no like '9C%'
    and t2.flag<>2


union  all


select t2.flight_date,
t2.flight_no whole_flight,t2.flight_no||'Y' flightno,
split_part(t2.route_name,'－',2)||'－'||split_part(t2.route_name,'－',3) flights_segment_name,
t2.route_name,
t3.round_time,
t4.round_time alltime,
t2.flights_id,
t2.layout,
t5.wf_segment_name
  from  dw.da_flight t2
  left join if.v_rep_segment_roundtime t3 on split_part(t2.route_name,'－',2)||'－'||split_part(t2.route_name,'－',3) =t3.flights_segment_name
  left join if.v_rep_segment_roundtime t4 on t2.route_name=t4.flights_segment_name
  left join dw.dim_segment_type t5 on t2.h_route_id = t5.h_route_id and t2.route_id = t5.route_id
  where t2.flight_date>=trunc(sysdate)
    --and t2.flight_date<=trunc(sysdate)+14
    and t2.flight_no like '9C%'
    and t2.flag<>2
    and t2.segment_type like '%经停AC段%'
    )tp1
  group by tp1.whole_flight,tp1.flightno,tp1.flights_segment_name,tp1.round_time,
  replace(replace(replace(replace(tp1.flights_segment_name,'成都天府','成都'),'茅台','遵义'),'虹桥','上海'),'浦东','上海')
)mid1
left join (
select flights_segment_name,segment_code,min(nationflag) nationflag,min(nvl(income_type,'-')) income_type
         from dw.dim_segment_type
         where flights_segment_name is not null
         group by flights_segment_name,segment_code
) mid0 on mid0.flights_segment_name=mid1.flights_segment_name

--财务提供变动成本及上报民航局
left join hdb.rep_dim_varicost cw on mid1.whole_flight=cw.whole_flight and mid0.segment_code=cw.flights_segment

left join
(select h1.flights_no,h1.flights_segment,h2.flights_segment_name,avg(h1.round_time) round_time,
avg(vari_cost) vari_cost,sum(h1.vari_cost)/sum(h1.round_time) varicosthour
from(
select f.flights_date,
       f.flights_no,
       f.flights_segment,
       f.flights_id,
       f.segment_head_id,
       f.round_time,
       decode(f.ROUTE_FLAG, 0, '直飞', 1, '经停', 2, '同机中转') routeflag,
       decode(COST_FLAG,
              0,
              '直飞',
              1,
              '经停分段',
              2,
              '同机中转',
              3,
              '经停合计') costflag,
       nvl(F.QJ_FEE_NF, 0) + nvl(F.CAO_FEE, 0) + nvl(F.FUND_MONEY, 0) +
       nvl(F.FLIGHT_MONEY, 0) + nvl(F.DP_MONEY, 0) vari_cost
  from cqsale.CQ_FLIGHTS_COST@to_air F
   where f.flights_date >= trunc(sysdate) - 7
 and round_time>0
 and nvl(F.QJ_FEE_NF, 0) + nvl(F.CAO_FEE, 0) + nvl(F.FUND_MONEY, 0) +
       nvl(F.FLIGHT_MONEY, 0) + nvl(F.DP_MONEY, 0)>0
 )h1
 join (select segment_code,min(flights_segment_name) flights_segment_name
         from dw.dim_segment_type
         where flights_segment_name is not null
         group by segment_code) h2 on h1.flights_segment=h2.segment_code
 where h1.costflag<>'经停合计'
 group by h1.flights_no,h1.flights_segment,h2.flights_segment_name

 )mid2 on mid1.flightno=mid2.flights_no and mid1.flights_segment_name=mid2.flights_segment_name
left join
(select h1.flights_no,h1.flights_segment,h2.flights_segment_name,avg(h1.round_time) round_time,avg(vari_cost) vari_cost,sum(h1.vari_cost)/sum(h1.round_time) varicosthour
from(
select f.flights_date,
       f.flights_no,
       f.flights_segment,
       f.flights_id,
       f.segment_head_id,
       f.round_time,
       decode(f.ROUTE_FLAG, 0, '直飞', 1, '经停', 2, '同机中转') routeflag,
       decode(COST_FLAG,
              0,
              '直飞',
              1,
              '经停分段',
              2,
              '同机中转',
              3,
              '经停合计') costflag,
       nvl(F.QJ_FEE_NF, 0) + nvl(F.CAO_FEE, 0) + nvl(F.FUND_MONEY, 0) +
       nvl(F.FLIGHT_MONEY, 0) + nvl(F.DP_MONEY, 0) vari_cost
  from cqsale.CQ_FLIGHTS_COST@to_air F
   where f.flights_date >= trunc(sysdate) - 14
 and round_time>0
 and nvl(F.QJ_FEE_NF, 0) + nvl(F.CAO_FEE, 0) + nvl(F.FUND_MONEY, 0) +
       nvl(F.FLIGHT_MONEY, 0) + nvl(F.DP_MONEY, 0)>0
 )h1
 join (select segment_code,min(flights_segment_name) flights_segment_name
         from dw.dim_segment_type
         where flights_segment_name is not null
         group by segment_code) h2 on h1.flights_segment=h2.segment_code
 where h1.costflag<>'经停合计'
 group by h1.flights_no,h1.flights_segment,h2.flights_segment_name

 )mid3 on mid1.flightno=mid3.flights_no and mid1.flights_segment_name=mid3.flights_segment_name
left join
(select h1.flights_no,h1.flights_segment,h2.flights_segment_name,avg(h1.round_time) round_time,avg(vari_cost) vari_cost,sum(h1.vari_cost)/sum(h1.round_time) varicosthour
from(
select f.flights_date,
       f.flights_no,
       f.flights_segment,
       f.flights_id,
       f.segment_head_id,
       f.round_time,
       decode(f.ROUTE_FLAG, 0, '直飞', 1, '经停', 2, '同机中转') routeflag,
       decode(COST_FLAG,
              0,
              '直飞',
              1,
              '经停分段',
              2,
              '同机中转',
              3,
              '经停合计') costflag,
       nvl(F.QJ_FEE_NF, 0) + nvl(F.CAO_FEE, 0) + nvl(F.FUND_MONEY, 0) +
       nvl(F.FLIGHT_MONEY, 0) + nvl(F.DP_MONEY, 0) vari_cost
  from cqsale.CQ_FLIGHTS_COST@to_air F
   where f.flights_date >= trunc(sysdate,'mm')
 and round_time>0
 and nvl(F.QJ_FEE_NF, 0) + nvl(F.CAO_FEE, 0) + nvl(F.FUND_MONEY, 0) +
       nvl(F.FLIGHT_MONEY, 0) + nvl(F.DP_MONEY, 0)>0
 )h1
 join (select segment_code,min(flights_segment_name) flights_segment_name
         from dw.dim_segment_type
         where flights_segment_name is not null
         group by segment_code) h2 on h1.flights_segment=h2.segment_code
 where h1.costflag<>'经停合计'
 group by h1.flights_no,h1.flights_segment,h2.flights_segment_name

 )mid4 on mid1.flightno=mid4.flights_no and mid1.flights_segment_name=mid4.flights_segment_name

-----针对相同航线城市统计小时变动成本

left join(
 select replace(replace(replace(replace(h2.flights_segment_name,'成都天府','成都'),'茅台','遵义'),
 '虹桥','上海'),'浦东','上海') flights_city_name,
 avg(h1.round_time) round_time,
avg(vari_cost) vari_cost,sum(h1.vari_cost)/sum(h1.round_time) varicosthour
from(
select f.flights_date,
       f.flights_no,
       f.flights_segment,
       f.flights_id,
       f.segment_head_id,
       f.round_time,
       decode(f.ROUTE_FLAG, 0, '直飞', 1, '经停', 2, '同机中转') routeflag,
       decode(COST_FLAG,
              0,
              '直飞',
              1,
              '经停分段',
              2,
              '同机中转',
              3,
              '经停合计') costflag,
       nvl(F.QJ_FEE_NF, 0) + nvl(F.CAO_FEE, 0) + nvl(F.FUND_MONEY, 0) +
       nvl(F.FLIGHT_MONEY, 0) + nvl(F.DP_MONEY, 0) vari_cost
  from cqsale.CQ_FLIGHTS_COST@to_air F
   where f.flights_date >= trunc(sysdate) - 7
 and round_time>0
 and nvl(F.QJ_FEE_NF, 0) + nvl(F.CAO_FEE, 0) + nvl(F.FUND_MONEY, 0) +
       nvl(F.FLIGHT_MONEY, 0) + nvl(F.DP_MONEY, 0)>0
 )h1
 join (select segment_code,min(flights_segment_name) flights_segment_name
         from dw.dim_segment_type
         where flights_segment_name is not null
         group by segment_code) h2 on h1.flights_segment=h2.segment_code
 where h1.costflag<>'经停合计'
 group by replace(replace(replace(replace(h2.flights_segment_name,'成都天府','成都'),'茅台','遵义'),
 '虹桥','上海'),'浦东','上海')
)sc1  on sc1.flights_city_name=mid1.flights_city_name
left join(
select replace(replace(replace(replace(h2.flights_segment_name,'成都天府','成都'),'茅台','遵义'),
 '虹桥','上海'),'浦东','上海') flights_city_name,
 avg(h1.round_time) round_time,
avg(vari_cost) vari_cost,sum(h1.vari_cost)/sum(h1.round_time) varicosthour
from(
select f.flights_date,
       f.flights_no,
       f.flights_segment,
       f.flights_id,
       f.segment_head_id,
       f.round_time,
       decode(f.ROUTE_FLAG, 0, '直飞', 1, '经停', 2, '同机中转') routeflag,
       decode(COST_FLAG,
              0,
              '直飞',
              1,
              '经停分段',
              2,
              '同机中转',
              3,
              '经停合计') costflag,
       nvl(F.QJ_FEE_NF, 0) + nvl(F.CAO_FEE, 0) + nvl(F.FUND_MONEY, 0) +
       nvl(F.FLIGHT_MONEY, 0) + nvl(F.DP_MONEY, 0) vari_cost
  from cqsale.CQ_FLIGHTS_COST@to_air F
   where f.flights_date >= trunc(sysdate) - 7
 and round_time>0
 and nvl(F.QJ_FEE_NF, 0) + nvl(F.CAO_FEE, 0) + nvl(F.FUND_MONEY, 0) +
       nvl(F.FLIGHT_MONEY, 0) + nvl(F.DP_MONEY, 0)>0
 )h1
 join (select segment_code,min(flights_segment_name) flights_segment_name
         from dw.dim_segment_type
         where flights_segment_name is not null
         group by segment_code) h2 on h1.flights_segment=h2.segment_code
 where h1.costflag<>'经停合计'
 group by replace(replace(replace(replace(h2.flights_segment_name,'成都天府','成都'),'茅台','遵义'),
 '虹桥','上海'),'浦东','上海')
 )sc2 on sc2.flights_city_name=mid1.flights_city_name

---针对相同出发地进行统计小时变动成本 例如上海－成都

 left join(
 select split_part(h2.flights_segment_name,'－',1) originairport_name,
 sum(h1.vari_cost)/sum(h1.round_time) varicosthour
from(
select f.flights_date,
       f.flights_no,
       f.flights_segment,
       f.flights_id,
       f.segment_head_id,
       f.round_time,
       decode(f.ROUTE_FLAG, 0, '直飞', 1, '经停', 2, '同机中转') routeflag,
       decode(COST_FLAG,
              0,
              '直飞',
              1,
              '经停分段',
              2,
              '同机中转',
              3,
              '经停合计') costflag,
       nvl(F.QJ_FEE_NF, 0) + nvl(F.CAO_FEE, 0) + nvl(F.FUND_MONEY, 0) +
       nvl(F.FLIGHT_MONEY, 0) + nvl(F.DP_MONEY, 0) vari_cost
  from cqsale.CQ_FLIGHTS_COST@to_air F
   where f.flights_date >= trunc(sysdate) - 7
 and round_time>0
 and nvl(F.QJ_FEE_NF, 0) + nvl(F.CAO_FEE, 0) + nvl(F.FUND_MONEY, 0) +
       nvl(F.FLIGHT_MONEY, 0) + nvl(F.DP_MONEY, 0)>0
 )h1
 join (select segment_code,min(flights_segment_name) flights_segment_name
         from dw.dim_segment_type
         where flights_segment_name is not null
         group by segment_code) h2 on h1.flights_segment=h2.segment_code
 where h1.costflag<>'经停合计'
 group by split_part(h2.flights_segment_name,'－',1)
)third1  on third1.originairport_name=split_part(mid1.flights_segment_name,'－',1)
left join(
select split_part(h2.flights_segment_name,'－',1)
originairport_name,sum(h1.vari_cost)/sum(h1.round_time) varicosthour
from(
select f.flights_date,
       f.flights_no,
       f.flights_segment,
       f.flights_id,
       f.segment_head_id,
       f.round_time,
       decode(f.ROUTE_FLAG, 0, '直飞', 1, '经停', 2, '同机中转') routeflag,
       decode(COST_FLAG,
              0,
              '直飞',
              1,
              '经停分段',
              2,
              '同机中转',
              3,
              '经停合计') costflag,
       nvl(F.QJ_FEE_NF, 0) + nvl(F.CAO_FEE, 0) + nvl(F.FUND_MONEY, 0) +
       nvl(F.FLIGHT_MONEY, 0) + nvl(F.DP_MONEY, 0) vari_cost
  from cqsale.CQ_FLIGHTS_COST@to_air F
   where f.flights_date >= trunc(sysdate) - 7
 and round_time>0
 and nvl(F.QJ_FEE_NF, 0) + nvl(F.CAO_FEE, 0) + nvl(F.FUND_MONEY, 0) +
       nvl(F.FLIGHT_MONEY, 0) + nvl(F.DP_MONEY, 0)>0
 )h1
 join (select segment_code,min(flights_segment_name) flights_segment_name
         from dw.dim_segment_type
         where flights_segment_name is not null
         group by segment_code) h2 on h1.flights_segment=h2.segment_code
 where h1.costflag<>'经停合计'
 group by split_part(h2.flights_segment_name,'－',1)
 )third2 on third2.originairport_name=split_part(mid1.flights_segment_name,'－',1)

-----------相同收益类型统计小时收入

 left join(
 select h2.income_type,
 sum(h1.vari_cost)/sum(h1.round_time) varicosthour
from(
select f.flights_date,
       f.flights_no,
       f.flights_segment,
       f.flights_id,
       f.segment_head_id,
       f.round_time,
       decode(f.ROUTE_FLAG, 0, '直飞', 1, '经停', 2, '同机中转') routeflag,
       decode(COST_FLAG,
              0,
              '直飞',
              1,
              '经停分段',
              2,
              '同机中转',
              3,
              '经停合计') costflag,
       nvl(F.QJ_FEE_NF, 0) + nvl(F.CAO_FEE, 0) + nvl(F.FUND_MONEY, 0) +
       nvl(F.FLIGHT_MONEY, 0) + nvl(F.DP_MONEY, 0) vari_cost
  from cqsale.CQ_FLIGHTS_COST@to_air F
   where f.flights_date >= trunc(sysdate) - 7
 and round_time>0
 and nvl(F.QJ_FEE_NF, 0) + nvl(F.CAO_FEE, 0) + nvl(F.FUND_MONEY, 0) +
       nvl(F.FLIGHT_MONEY, 0) + nvl(F.DP_MONEY, 0)>0
 )h1
 join (select segment_code,min(nvl(income_type,'-')) income_type
         from dw.dim_segment_type
         where flights_segment_name is not null
         group by segment_code) h2 on h1.flights_segment=h2.segment_code
 where h1.costflag<>'经停合计'
 group by h2.income_type
)four  on four.income_type=mid0.income_type

---按照航线性质统计小时收入
 left join(
 select h2.nationflag,
 sum(h1.vari_cost)/sum(h1.round_time) varicosthour
from(
select f.flights_date,
       f.flights_no,
       f.flights_segment,
       f.flights_id,
       f.segment_head_id,
       f.round_time,
       decode(f.ROUTE_FLAG, 0, '直飞', 1, '经停', 2, '同机中转') routeflag,
       decode(COST_FLAG,
              0,
              '直飞',
              1,
              '经停分段',
              2,
              '同机中转',
              3,
              '经停合计') costflag,
       nvl(F.QJ_FEE_NF, 0) + nvl(F.CAO_FEE, 0) + nvl(F.FUND_MONEY, 0) +
       nvl(F.FLIGHT_MONEY, 0) + nvl(F.DP_MONEY, 0) vari_cost
  from cqsale.CQ_FLIGHTS_COST@to_air F
   where f.flights_date >= trunc(sysdate) - 7
 and round_time>0
 and nvl(F.QJ_FEE_NF, 0) + nvl(F.CAO_FEE, 0) + nvl(F.FUND_MONEY, 0) +
       nvl(F.FLIGHT_MONEY, 0) + nvl(F.DP_MONEY, 0)>0
 )h1
 join (select segment_code,min(nationflag) nationflag
         from dw.dim_segment_type
         where flights_segment_name is not null
         group by segment_code) h2 on h1.flights_segment=h2.segment_code
 where h1.costflag<>'经停合计'
 group by h2.nationflag
)six  on six.nationflag=mid0.nationflag


----获取2022年各航线的平均小时成本

 left join(
 select h2.flights_segment_name,
 sum(h1.vari_cost)/sum(h1.round_time) varicosthour
from(
select f.flights_date,
       f.flights_no,
       f.flights_segment,
       f.flights_id,
       f.segment_head_id,
       f.round_time,
       decode(f.ROUTE_FLAG, 0, '直飞', 1, '经停', 2, '同机中转') routeflag,
       decode(COST_FLAG,
              0,
              '直飞',
              1,
              '经停分段',
              2,
              '同机中转',
              3,
              '经停合计') costflag,
       nvl(F.QJ_FEE_NF, 0) + nvl(F.CAO_FEE, 0) + nvl(F.FUND_MONEY, 0) +
       nvl(F.FLIGHT_MONEY, 0) + nvl(F.DP_MONEY, 0) vari_cost
  from cqsale.CQ_FLIGHTS_COST@to_air F
   where f.flights_date >= date'2022-01-01'
 and round_time>0
 and nvl(F.QJ_FEE_NF, 0) + nvl(F.CAO_FEE, 0) + nvl(F.FUND_MONEY, 0) +
       nvl(F.FLIGHT_MONEY, 0) + nvl(F.DP_MONEY, 0)>0
 )h1
 join (select segment_code,min(flights_segment_name) flights_segment_name
         from dw.dim_segment_type
         where flights_segment_name is not null
         group by segment_code) h2 on h1.flights_segment=h2.segment_code
 where h1.costflag<>'经停合计'
 group by h2.flights_segment_name
)five  on five.flights_segment_name=mid1.flights_segment_name;
