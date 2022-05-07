 select /*+parallel(4) */ 
 trunc(t1.money_date) 退票日期,
 case when t2.flag=2 then '取消航班' else '正常航班' end 航班状态,
case when t3.order_date< to_date('2020-01-24','yyyy-mm-dd') then '24号之前购票'
when t3.order_date>=  to_date('2020-01-24','yyyy-mm-dd') then '24号之后购票'
else null end 订单日期,
case when t1.money_date>=to_date('2020-01-24','yyyy-mm-dd') and t1.money_date<=t2.origin_std 
and t3.order_date<  to_date('2020-01-24','yyyy-mm-dd') and t2.origin_std>=to_date('2020-01-24','yyyy-mm-dd')
then '符合规则1'
when t1.money_date>=to_date('2020-01-28','yyyy-mm-dd') and t1.money_date<=t2.origin_std 
and t3.order_date< to_date('2020-01-28','yyyy-mm-dd') and t2.origin_std>=to_date('2020-01-28','yyyy-mm-dd')
then '符合规则2'
else '不符合规则' end rule_type,
case when t1.money_date> t2.origin_std then '离站后'
else '离站前' end 退票日期类型,
case when t1.origin_std< to_date('2020-01-24','yyyy-mm-dd')  then '24号之前航班'
when t1.origin_std>= to_date('2020-01-24','yyyy-mm-dd')  then '24号之后航班'
else null end  航班日期类型,
case when t3.terminal_id=-1 and t3.web_id =0 then '线上自有渠道'
 when t3.terminal_id in
                (300, 1233, 1309, 1330, 1400, 1401, 1516, 1571, 1801, 1802, 1803, 1805, 1806, 1807, 1808, 3505) then
            '呼叫中心'
when t3.terminal_id<0 and regexp_like(t4.abrv,'(淘宝)|(携程)|(去哪儿)|(同程)|(飞猪)') then t4.abrv
when t3.terminal_id>0 and t3.web_id=0 then 'B2B'
else '其他' end 渠道,
case when t1.money_fy=0 then '免费退'
when t1.money_fy>0 then '非免费退' end 是否免费,
case when t1.MONEY_TERMINAL<0 then '线上退'
else '线下退' end 退票渠道,
count(distinct t1.flights_order_head_id) 退票量
  from dw.da_order_drawback t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  left join cqsale.cq_order@to_air t3 on t1.flights_order_id=t3.flights_order_id
  left join stg.s_cq_agent_info t4 on t3.web_id=t4.agent_id
   where t1.money_date>=to_date('2020-01-24','yyyy-mm-dd')
   and t1.money_date< trunc(sysdate)
   and t1.seats_name is not null
   and t2.company_id=0
   group by trunc(t1.money_date),case when t2.flag=2 then '取消航班' else '正常航班' end,
case when t3.order_date< to_date('2020-01-24','yyyy-mm-dd') then '24号之前购票'
when t3.order_date>=  to_date('2020-01-24','yyyy-mm-dd') then '24号之后购票'
else null end,
case when t1.money_date> t2.origin_std then '离站后'
else '离站前' end,
case when t1.origin_std< to_date('2020-01-24','yyyy-mm-dd')  then '24号之前航班'
when t1.origin_std>= to_date('2020-01-24','yyyy-mm-dd')  then '24号之后航班'
else null end,
case when t3.terminal_id=-1 and t3.web_id =0 then '线上自有渠道'
 when t3.terminal_id in
                (300, 1233, 1309, 1330, 1400, 1401, 1516, 1571, 1801, 1802, 1803, 1805, 1806, 1807, 1808, 3505) then
            '呼叫中心'
when t3.terminal_id<0 and regexp_like(t4.abrv,'(淘宝)|(携程)|(去哪儿)|(同程)|(飞猪)') then t4.abrv
when t3.terminal_id>0 and t3.web_id=0 then 'B2B'
else '其他' end ,
case when t1.money_fy=0 then '免费退'
when t1.money_fy>0 then '非免费退' end,case when t1.MONEY_TERMINAL<0 then '线上退'
else '线下退' end,
case when t1.money_date>=to_date('2020-01-24','yyyy-mm-dd') and t1.money_date<=t2.origin_std 
and t3.order_date<  to_date('2020-01-24','yyyy-mm-dd') and t2.origin_std>=to_date('2020-01-24','yyyy-mm-dd')
then '符合规则1'
when t1.money_date>=to_date('2020-01-28','yyyy-mm-dd') and t1.money_date<=t2.origin_std 
and t3.order_date< to_date('2020-01-28','yyyy-mm-dd') and t2.origin_std>=to_date('2020-01-28','yyyy-mm-dd')
then '符合规则2'
else '不符合规则' end