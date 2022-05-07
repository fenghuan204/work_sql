# 辅收二次精准营销
/* 

针对国际航段，如往返程的，在去程出发前发送短信，如只有返程的，临近一周内起飞的不发送            
同一电话号码1个月内最多推送2条短信            
推送在官网购票的12-70周岁乘机人，剔除OTA及黑代号码           
所有提取的数据都为截止到该时间点，还未购买过该辅收产品的(行李/接送机只要订单中/同航段/同出行日期任意同行人买过，都不推送，餐食/接送机该乘机人买过，则不推送)           
推送产品优先级：行李---->餐食---->保险（境外/航意-延误-取消）---->接送机；            
餐点航班情况下的优先级：1） 餐食；2）行李；3）保险；4）接送机；            
红眼航班优先级：1） 接送机；2）行李；3）保险；4）餐食；            
若餐点航班与无免费托运行李额同时满足，以行李作为第一主推。           
若红眼航班与无免费托运行李额同时满足，以接送机作为第一主推           



线上行李:
"产品可售限制：-自有离港，航班计划起飞前2小时；
               -非自有离港，航班计划起飞前24小时；
"       
1.订单中包括了国际返程            
 1.订单中包括了航线性质未区域/国际且 国内到港的航段           
 2.座位类型为会员专享           
 3.团散为:Not BGO           
2.有潜在行李需求           
 1.过去一年内购买行李的次数>=1次            
3.国内航段，行程长（往返天数长，需要行李量大）            
 1.本次航线性质：国内 (且为往返程)           
 2.座位类型为会员专享           
 3.团散为:Not BGO           
 4.本次往返天数>=5天            
 5.本次行程免费托运行李额：无           
4.过去购买过行李产品           
 1.过去30天年内点击行李产品的次数>=1次            
 2.团散:Not BGO            
5.对行李产品感兴趣            
 1.过去30天年内点击行李产品的次数>=1次            
 2.团散:Not BGO            
6.所乘坐的航段历史行李购买率高            
 1.所乘坐的航段是否为过去30天内/去年同期临近30天行李购买率最高的前10%航班           
 2.团散:Not BGO

*/        



select *
from(
select tb1.mobile,tb1.rule,tb1.stype,tb1.area_type,tb1.flights_date,tb1.whole_segment,tb1.flights_order_head_id,
row_number()over(partition by tb1.mobile order by tb1.rule,tb1.flights_date) srow
from(
select t2.area_type,t1.flights_date,t1.whole_segment,t1.flights_order_head_id,
case when t2.area_type='国内' and (t2.origin_std-sysdate)>=1 and  (t2.origin_std-sysdate)<=2 then '国内1-2天'
when t2.area_type='国际' and t1.is_qu_hui=1 and  (t2.origin_std-sysdate)>=1 and  (t2.origin_std-sysdate)<=2 then '国际去程1-2天'
when t2.area_type='国际' and t1.is_qu_hui=2 and (t2.origin_std-sysdate)>=7  then '国际返程7天以外' 
else '其他' end stype,'1' rule,getmobile(t1.r_tel) mobile
  from dw.fact_recent_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id = t2.segment_head_id 
where t2.origin_std >= sysdate + 1
   and t2.flag <> 2
   and t1.flights_date >= trunc(sysdate) + 1
   and t1.flag_id in (3, 5, 40)
   and t1.seats_name not in ('B', 'G', 'G1', 'G2', 'O')
   and t1.seat_type = '普通座'
   and t1.nationflag in ('区域', '国际')
   and getage(t1.flights_date,t1.birthday)>=12
   and getage(t1.flights_date,t1.birthday)<=70
   and t2.dest_country_id = 0
   and getmobile(t1.r_tel)<>'-'
   and not exists
 (select 1
          from dw.fact_other_order_detail t3
         where t3.flights_date >= trunc(sysdate) + 1
               and t3.xtype_id in (6, 10, 17)
           and t1.flights_order_id = t3.flights_order_id
           and t1.segment_head_id = t3.segment_head_id)
   and not exists (select 1
                     from dw.da_restrict_userinfo du
                     where du.feature_value=getmobile(t1.r_tel)
                      or du.mobile=getmobile(t1.r_tel))
  
 union  all
 
 select t2.area_type, t1.flights_date,t1.whole_segment,t1.flights_order_head_id,
case when t2.area_type='国内' and (t2.origin_std-sysdate)>=1 and  (t2.origin_std-sysdate)<=2 then '国内1-2天'
when t2.area_type='国际' and t1.is_qu_hui=1 and  (t2.origin_std-sysdate)>=1 and  (t2.origin_std-sysdate)<=2 then '国际去程1-2天'
when t2.area_type='国际' and t1.is_qu_hui=2 and (t2.origin_std-sysdate)>=7  then '国际返程7天以外' 
else '其他' end,'2' rule,getmobile(t1.r_tel) mobile
  from dw.fact_recent_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id = t2.segment_head_id
where t2.origin_std >= sysdate + 1
   and t2.flag <> 2
   and t1.flights_date >= trunc(sysdate) + 1
   and t1.flag_id in (3, 5, 40)
    and getmobile(t1.r_tel)<>'-'
     and getage(t1.flights_date,t1.birthday)>=12
   and getage(t1.flights_date,t1.birthday)<=70
   and not exists
 (select 1
          from dw.fact_other_order_detail t3
         where t3.flights_date >= trunc(sysdate) + 1
           and t3.xtype_id in (6, 10, 17)
           and t1.flights_order_id = t3.flights_order_id
           and t1.segment_head_id = t3.segment_head_id)
  and exists(
         select 1
          from dw.fact_other_order_detail t3
         where t3.flights_date >= trunc(sysdate-365)
           and t3.flights_date< trunc(sysdate) 
           and t3.xtype_id in (6, 10, 17)
           and t1.traveller_name=t3.traveller_name
           and t1.codeno=t3.codeno)
           and not exists (select 1
                     from dw.da_restrict_userinfo du
                     where du.feature_value=getmobile(t1.r_tel)
                      or du.mobile=getmobile(t1.r_tel))
           
           
  union all
  
  
 select t2.area_type, t1.flights_date,t1.whole_segment,t1.flights_order_head_id,
case when t2.area_type='国内' and (t2.origin_std-sysdate)>=1 and  (t2.origin_std-sysdate)<=2 then '国内1-2天'
when t2.area_type='国际' and t1.is_qu_hui=1 and  (t2.origin_std-sysdate)>=1 and  (t2.origin_std-sysdate)<=2 then '国际去程1-2天'
when t2.area_type='国际' and t1.is_qu_hui=2 and (t2.origin_std-sysdate)>=7  then '国际返程7天以外' 
else '其他' end,'3' rule,getmobile(t1.r_tel) mobile
  from dw.fact_recent_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id = t2.segment_head_id
  join dw.fact_recent_order_detail tt3 on t1.wf_flights_order_head_id=tt3.flights_order_head_id
where t2.origin_std >= sysdate + 1
   and t2.flag <> 2
   and t1.flights_date >= trunc(sysdate) + 1
   and t1.flag_id in (3, 5, 40)
   and t1.nationflag='国内'
   and t1.seats_name not in ('B', 'G', 'G1', 'G2', 'O')
   and t1.seat_type = '普通座'
   and t1.is_wf=1
   and t1.weight_free< 10
    and getage(t1.flights_date,t1.birthday)>=12
   and getage(t1.flights_date,t1.birthday)<=70
   and abs(t1.flights_date-tt3.flights_date)>=5
   and not exists
 (select 1
          from dw.fact_other_order_detail t3
         where t3.flights_date >= trunc(sysdate) + 1
           and t3.xtype_id in (6, 10, 17)
           and t1.flights_order_id = t3.flights_order_id
           and t1.segment_head_id = t3.segment_head_id)
   and getmobile(t1.r_tel)<>'-'
 and not exists (select 1
                     from dw.da_restrict_userinfo du
                     where du.feature_value=getmobile(t1.r_tel)
                      or du.mobile=getmobile(t1.r_tel))
           
           
 union all

--简化成过去30天的航段TOP10

select t2.area_type, t1.flights_date,t1.whole_segment,t1.flights_order_head_id,
case when t2.area_type='国内' and (t2.origin_std-sysdate)>=1 and  (t2.origin_std-sysdate)<=2 then '国内1-2天'
when t2.area_type='国际' and t1.is_qu_hui=1 and  (t2.origin_std-sysdate)>=1 and  (t2.origin_std-sysdate)<=2 then '国际去程1-2天'
when t2.area_type='国际' and t1.is_qu_hui=2 and (t2.origin_std-sysdate)>=7  then '国际返程7天以外' 
else '其他' end,'4' rule,getmobile(t1.r_tel) mobile
  from dw.fact_recent_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id = t2.segment_head_id
  join (
  select hh1.*
  from (
     select h1.whole_segment,sum(h2.book_num)/count(1) rate
          from dw.fact_order_detail h1
        left join dw.fact_other_order_detail h2 on h1.flights_order_head_id =h2.flights_Order_head_id and h2.xtype_id in (6, 10, 17)
         where h1.flights_date >= trunc(sysdate) -30
           and h1.flights_date <  trunc(sysdate)           
           and h1.seats_name not in ('B', 'G', 'G1', 'G2', 'O')
           and h1.company_id=0
           
           group by h1.whole_segment
           order by 2 desc)hh1
           where rownum<=10)hh2 on t1.whole_segment=hh2.whole_segment           
where t2.origin_std >= sysdate + 1
   and t2.flag <> 2
   and t1.flights_date >= trunc(sysdate) + 1
   and t1.flag_id in (3, 5, 40)
   and t1.seats_name not in ('B', 'G', 'G1', 'G2', 'O')
    and getage(t1.flights_date,t1.birthday)>=12
   and getage(t1.flights_date,t1.birthday)<=70
   and not exists
 (select 1
          from dw.fact_other_order_detail t3
         where t3.flights_date >= trunc(sysdate) + 1
           and t3.xtype_id in (6, 10, 17)
           and t1.flights_order_id = t3.flights_order_id
           and t1.segment_head_id = t3.segment_head_id)
     and getmobile(t1.r_tel)<>'-'
 and not exists (select 1
                     from dw.da_restrict_userinfo du
                     where du.feature_value=getmobile(t1.r_tel)
                      or du.mobile=getmobile(t1.r_tel))
                      ) tb1
                      where tb1.stype='其他'                      
                      )tb2
                      where tb2.srow=1;
					  
					
					
=============================================选座数据========================================================


select tb1.*
from(
select t1.work_tel,t1.flights_date,2 xid
 from dw.fact_recent_order_detail t1
 join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
 left join dw.da_restrict_userinfo t3 on t1.client_id=t3.users_id
 where t2.originairport_name in('浦东','成都')
   and t2.segment_country in('日本','柬埔寨','香港','澳门')
   and t1.is_swj=0
   and t1.flag_id in(3,5,41)
   and t1.flights_date>=trunc(sysdate+3)
   and t1.flights_date< trunc(sysdate+6)
   and t3.users_id is null
   and t1.channel in('网站','手机')
   and getmobile(t1.work_tel)<>'-'
   and not exists (select 1 from hdb.mid_black_phone_change h1
                        where getmobile(t1.work_tel)=h1.mobile
                        )
                        

        
   union    
   
   select t1.work_tel,t1.flights_date,2 xid
 from dw.fact_recent_order_detail t1
 join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
 left join dw.da_restrict_userinfo t3 on t1.client_id=t3.users_id
 where t2.nationflag in('国际','区域')
   and t1.is_swj=0
   and t1.flag_id in(3,5,41)
    and t3.users_id is null
   and t1.flights_date>=trunc(sysdate+3)
   and t1.flights_date< trunc(sysdate+6)
   and t1.channel in('网站','手机')
   and getmobile(t1.work_tel)<>'-'
   and not (t1.is_wf=1 and t1.is_qu_hui=2)
   and not exists (select 1 from hdb.mid_black_phone_change h1
                        where getmobile(t1.work_tel)=h1.mobile
                        )
   and exists (select 1 from dw.fact_other_order_detail h2
                      where t1.traveller_name=h2.traveller_name
                      and t1.codeno=h2.codeno
                      and h2.flights_date<=trunc(sysdate)
                      and h2.xtype_id=3))tb1；
   



  