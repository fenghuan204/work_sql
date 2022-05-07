----------------------------------------------------------------------------营销短信退票分析---------------------------------------------------------------------------

--营销短信存储(每日发送T+2日期)

insert into   hdb.temp_feng_0129 
select distinct getmobile(t1.r_tel)  moile,t1.flights_order_head_id,t1.r_flights_date
 from cqsale.cq_order_head@to_air t1
 join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
 where t1.r_flights_date=trunc(sysdate+2)
 and t1.flag_id in (3,5)
 and t1.seats_name is not null
 and t1.sex=1
 and t2.flag<>2
 and t1.r_order_date< to_date('2020-01-28','yyyy-mm-dd')
 and t1.whole_flight like '9C%'
 and getmobile(t1.r_tel)<>'-';
 
 

---按照航班日期进行查询

--营销短信退票分析

--营销短信退票分析

select /*+parallel(4) */
t1.flights_date,case when t5.flights_order_head_id is not null then 'noshow'
else '非noshow' end,
case when t2.flights_order_head_id is not null then '退票'
else '未退票' end hourtype,
case when t3.flights_order_head_id is not null  then '重购'
else '非重购' end,
case when t2.money_terminal<0 then '线上退'
when t2.money_terminal>0 then '线下退'
else null end,
count(distinct  t1.flights_order_head_id)
from dw.fact_recent_order_detail t1
left join dw.da_order_drawback t2 on t1.flights_order_head_id=t2.flights_order_head_id
left join dw.da_flight t4 on t2.segment_head_id=t4.segment_head_id
left join cqsale.cq_order_head@to_air t3 on t2.sname=t3.name||coalesce(t3.second_name,'') and t3.codeno=t2.codeno and t2.money_date< t3.r_order_date and t3.r_flights_date>=trunc(t2.origin_std) 
and t2.flights_order_head_id<>t3.flights_order_head_id and t3.r_flights_date>=to_date('2020-01-29','yyyy-mm-dd')
left JOIN HDB.MID_NOSHOW_DATA t5 on t1.flights_order_head_id=t5.flights_order_head_id
group by t1.flights_date,case when t5.flights_order_head_id is not null then 'noshow'
else '非noshow' end,
case when t2.flights_order_head_id is not null then '退票'
else '未退票' end ,
case when t3.flights_order_head_id is not null  then '重购'
else '非重购' end,
case when t2.money_terminal<0 then '线上退'
when t2.money_terminal>0 then '线下退'
else null end;
---按照短信发送记录进行分析

--营销短信退票分析

select /*+parallel(4) */
t1.r_flights_date,case when t5.flights_order_head_id is not null then 'noshow'
else '非noshow' end,
case when t2.money_date> t2.origin_std then '离站后'
when (t2.origin_std-t2.money_date) *24< 2 then '[0~2h)'
when (t2.origin_std-t2.money_date) *24< 6 then '[2~6h)'
when (t2.origin_std-t2.money_date) *24< 8 then '[6~8h)'
when (t2.origin_std-t2.money_date) *24< 12 then '[8~12h)'
when (t2.origin_std-t2.money_date) *24< 24 then '[12~24h)'
when (t2.origin_std-t2.money_date) *24< 48 then '[24~48h)'
when (t2.origin_std-t2.money_date) *24>= 48 then '48h+' end hourtype,
case when t3.flights_order_head_id is not null and t2.segment_head_id=t3.segment_head_id then '退订再购相同航班'
when t3.flights_order_head_id is not null and t2.segment_head_id<>t3.segment_head_id
and t4.segment_code = t3.whole_segment  then '后续航班相同航段重购'
when t3.flights_order_head_id is not null and t2.segment_head_id<>t3.segment_head_id
and t4.segment_code <> t3.whole_segment  then '后续航班不同航段重购'
when t3.flights_order_head_id is not null then '其他重购'
end,
case when t2.money_terminal<0 then '线上退'
when t2.money_terminal>0 then '线下退'
else null end,
count(distinct  t1.flights_order_head_id),
count(distinct t1.moile)
from hdb.temp_feng_0129 t1
left join dw.da_order_drawback t2 on t1.flights_order_head_id=t2.flights_order_head_id
left join dw.da_flight t4 on t2.segment_head_id=t4.segment_head_id
left join cqsale.cq_order_head@to_air t3 on t2.sname=t3.name||coalesce(t3.second_name,'') and t3.codeno=t2.codeno and t2.money_date< t3.r_order_date and t3.r_flights_date>=trunc(t2.origin_std) 
and t2.flights_order_head_id<>t3.flights_order_head_id and t3.r_flights_date>=to_date('2020-01-29','yyyy-mm-dd')
left JOIN HDB.MID_NOSHOW_DATA t5 on t1.flights_order_head_id=t5.flights_order_head_id
group by t1.r_flights_date,case when t5.flights_order_head_id is not null then 'noshow'
else '非noshow' end,
case when t2.money_date> t2.origin_std then '离站后'
when (t2.origin_std-t2.money_date) *24< 2 then '[0~2h)'
when (t2.origin_std-t2.money_date) *24< 6 then '[2~6h)'
when (t2.origin_std-t2.money_date) *24< 8 then '[6~8h)'
when (t2.origin_std-t2.money_date) *24< 12 then '[8~12h)'
when (t2.origin_std-t2.money_date) *24< 24 then '[12~24h)'
when (t2.origin_std-t2.money_date) *24< 48 then '[24~48h)'
when (t2.origin_std-t2.money_date) *24>= 48 then '48h+' end ,
case when t3.flights_order_head_id is not null and t2.segment_head_id=t3.segment_head_id then '退订再购相同航班'
when t3.flights_order_head_id is not null and t2.segment_head_id<>t3.segment_head_id
and t4.segment_code = t3.whole_segment  then '后续航班相同航段重购'
when t3.flights_order_head_id is not null and t2.segment_head_id<>t3.segment_head_id
and t4.segment_code <> t3.whole_segment  then '后续航班不同航段重购'
when t3.flights_order_head_id is not null then '其他重购'
end,case when t2.money_terminal<0 then '线上退'
when t2.money_terminal>0 then '线下退'
else null end;