/*2020年7月30日起春秋航空南京禄口国际机场国内航班进出港的柜台、登机口从目前的T2航站楼搬迁至T1航站楼；
需要提取旅客名单：7月20日14:55分前，购买7月30日（含）后，南京机场国内航班进出港所有航线的旅客名单；
（订单号/航班号/航班日期/航段/姓名/紧急联系电话/联系电话/邮箱）*/

select distinct t.flights_order_id 订单号,t1.whole_flight 航班号,t1.r_flights_date 航班日期,
t1.whole_segment 航段,t1.name||' '||coalesce(t1.second_name,'') 姓名,
t.work_tel 联系电话,t1.r_tel 紧急联系电话,t.email 邮箱
from cqsale.cq_order@to_air t
join cqsale.cq_order_head@to_air t1 on t.flights_order_id=t1.flights_order_id
where t1.r_flights_date>=to_date('2020-08-02','yyyy-mm-dd')
and t.order_date< to_date('2020-07-31 15:45','yyyy-mm-dd hh24:mi')
--and t1.r_nation_flag=1
 and t1.whole_segment like '%URC%'
  and t1.flag_id in(3,5,40,41);



  


 
