select /*+parallel(4) */
hb2.smonth,hb2.nationflag,hb2.flights_segment_name,hb2.segment_country,
hb2.seat_type,hb2.foc实际起飞延误时间,/*hb2.apply_memo,*/
case  when hb2.ticketprice=0 and hb2.money_fy=0 then '0元机票'
when hb2.退票渠道='线上' and hb2.money_fy =0 then '0元线上'
when hb2.退票渠道='线下' and hb2.money_fy=0 then 
case when hb2.is_guard ='不正常航班保护' then '航班保护0元'
when hb2.航班类型 in('取消','取消航班') and hb2.公告时间类型 is not null then '取消航班0元'
when hb2.航班类型 ='延误' and hb2.公告时间类型 ='不正常公告发布后延误3小时以上操作退票' then '延误3小时0元'
when hb2.航班类型 ='延误' and hb2.公告时间类型 in('不正常公告发布后延误90分钟到3小时以上操作退票','不正常公告发布后延误3小时以上操作退票')
 and hb2.money_date>=date'2021-09-01' then '延误1.5小时0元'
when hb2.航班类型 ='延误' and hb2.公告时间类型 in('不正常公告发布后延误90分钟到3小时以上操作退票',
'不正常公告发布后延误3小时以上操作退票','不正常公告发布后延误15分钟到90分钟操作退票')
 and hb2.money_date>=date'2021-11-16' then '延误15分钟0元'
when hb2.money_date>=hb2.origin_std and hb2.foc实际起飞延误时间='3h+' then '起飞后退实际延误3H0元'
when hb2.money_date>=hb2.origin_std and hb2.foc实际起飞延误时间 in('3h+','1.5h~3h') then '起飞后退实际延误1.5H0元'
when hb2.money_date>=hb2.origin_std and hb2.foc实际起飞延误时间 in('15min~90min') then '起飞后退实际延误15min0元'
when hb2.航班类型<>'正常航班' and hb2.公告时间类型 is not null then '不正常航班公告后退票'
when hb2.apply_memo like '%疫情%' then '备注-疫情0元'
when hb2.apply_memo in('旅客--误操作','旅客--订错重购') then '备注-误操作0元'
when hb2.apply_memo 
in('航司--航班取消','航司--航班时刻调整','航司--航班保护','航司--不正常航班','航司--航班延误','航司--航班补班','航司--航班备降')
then '备注-不正常航班0元'
when hb2.apply_memo 
in('旅客--误机','航司--价格跳水','政策--燃油问题','旅客--超售','旅客--被减','旅客--拒载','投诉处理') then '备注-旅客投诉0元' 
when hb2.apply_memo <>'未填写相应申请理由' then '0元备注-其他理由0元'
else '无备注0元' end
when hb2.money_fy>0 then '退票收费' end apply_memo,

hb2.费用类型,hb2.航班类型,hb2.priod_date,
hb2.退票渠道,hb2.apply_user,
case when hb2.DELAY_HOUR>=0.25 and hb2.DELAY_HOUR< 1.5 then '15m~90m'
when hb2.DELAY_HOUR>=1.5 and hb2.DELAY_HOUR< 3 then '1.5h~3h' 
when hb2.DELAY_HOUR>=3 and hb2.DELAY_HOUR< 5 then '3h~5h' 
when hb2.DELAY_HOUR>=5  then '5h' 
else '未延迟' end 延误航班时间类型,
hb2.公告时间类型,
hb2.收费类型,
hb2.return_channel,
hb2.order_channel,
sum(hb2.money_fy) money_fy,
sum(hb2.ticketprice) ticketprice,
sum(hb2.ys_fee) ys_fee,
count(distinct hb2.flights_order_head_id) 退票量,
sum(hb2.ys_fee)-sum(hb2.money_fy) 金额差异,
hb2.is_guard 是否航班保护
from (
select hb1.*,hb2.drawback_rate,case when hb1.ticketprice=0 then '0元机票'
 when hb1.money_fy=0 then '0元收费'
when hb1.ticketprice>0 and hb1.money_fy=hb1.ticketprice*hb2.drawback_rate then '正常收费'
when hb1.ticketprice>0 and hb1.money_fy> hb1.ticketprice*hb2.drawback_rate then '多收费'
when hb1.ticketprice>0 and hb1.money_fy< hb1.ticketprice*hb2.drawback_rate then '少收费'
else '正常收费'
end 收费类型,nvl(hb1.ticketprice*hb2.drawback_rate,hb1.money_fy) ys_fee
from(
select t1.flights_order_head_id,
to_char(t1.money_date,'yyyymm') smonth,
t9.r_order_date ,
t1.money_date,
t2.flight_date,
t2.flights_segment_name,
t2.area_type nationflag,
t2.segment_country,
t2.origin_std,
case when t1.seattype='商务座' then '商务座'
else '非商务座' end seat_type,
case when scfl.dis_round is not null then 
case when (scfl.dis_round -t2.origin_std)*24*60< 15 then '延误15分钟以下'
when (scfl.dis_round -t2.origin_std)*24*60>=15 and (scfl.dis_round-t2.origin_std)*24*60< 90 then '15min~90min'
when (scfl.dis_round -t2.origin_std)*24*60>=90 and (scfl.dis_round-t2.origin_std)*24< 3 then '1.5h~3h'
when (scfl.dis_round -t2.origin_std)*24>=3  then '3h+' end
else null end  foc实际起飞延误时间,
case when t1.money_fy=0 and t1.ticketprice=0  and t1.seats_name in('O','D') then 'OD退票'
when t1.money_fy=0 and t1.ticketprice=0   then '套票退票'
when t1.money_fy=0  then '0元退票'
when t1.money_fy>0 then '非0元退票' end 费用类型,
case when t2.flag=2 then '取消'
when t6.unnormaltype is not null then t6.unnormaltype
else '正常航班' end 航班类型,
case when t2.area_type ='国内' then
case when t1.origin_std-t1.money_date<0 then '离站后'
when (t1.origin_std-t1.money_date)*24<2 then '[0h,2h)'
when (t1.origin_std-t1.money_date)*24<24 then '[2h,1D)'
when (t1.origin_std-t1.money_date)<3 then '[1D,3D)'
when (t1.origin_std-t1.money_date)<7 then '[3D,7D)'
when (t1.origin_std-t1.money_date)>=7 then '7D+' end 
when t2.area_type ='国际' then
case when t1.origin_std-t1.money_date<0 then '离站后'
when (t1.origin_std-t1.money_date)<1 then '[0,1D)'
when (t1.origin_std-t1.money_date)<3 then '[1D,3D)'
when (t1.origin_std-t1.money_date)<7 then '[3D,7D)'
when (t1.origin_std-t1.money_date)<15 then '[7D,15D)'
when (t1.origin_std-t1.money_date)<30 then '[15D,30D)'
when (t1.origin_std-t1.money_date)>=30 then '30D+' end 
else null end priod_date,
nvl(t1.seats_name,'YE') seats_name,
t1.flights_order_id,
case when t1.apply_memo  like '%定错%' then '旅客--订错重购'
when t1.apply_memo  like '%订错%' then '旅客--订错重购'
when t1.apply_memo  like '%重购%' then '旅客--订错重购'
when t1.apply_memo  like '%重构%' then '旅客--订错重购'
when t1.apply_memo  like '%重订%' then '旅客--订错重购'
when t1.apply_memo  like '%新定单%' then '旅客--订错重购'
when t1.apply_memo  like '%重新订购%' then '旅客--订错重购'
when t1.apply_memo  like '%重复订票%' then '旅客--订错重购'
when t1.apply_memo  like '%重新购票%' then '旅客--订错重购'
when t1.apply_memo  like '%重复购票%' then '旅客--订错重购'
when t1.apply_memo  like '%航班选错%' then '旅客--订错重购'
when t1.apply_memo  like '%新订单%' then '旅客--订错重购'
when t1.apply_memo  like '%订反%' then '旅客--订错重购'
when t1.apply_memo  like '%原订单%' then '旅客--订错重购'
when t1.apply_memo  like '%原定单%' then '旅客--订错重购'
when t1.apply_memo  like '%误买%' then '旅客--订错重购'
when t1.apply_memo  like '%补订%' then '旅客--补订儿童婴儿'
when t1.apply_memo  like '%补丁%' then '旅客--补订儿童婴儿'
when t1.apply_memo  like '%漏订%' then '旅客--补订儿童婴儿'
when t1.apply_memo  like '%误操作%' then '旅客--误操作'
when t1.apply_memo  like '%误操%' then '旅客--误操作'
when t1.apply_memo  like '%推燃油%' then '政策--燃油问题'
when t1.apply_memo  like '%燃油问题%' then '政策--燃油问题'
when t1.apply_memo  like '%燃油%' then '政策--燃油问题'
when t1.apply_memo  like '%延误%' then '航司--航班延误'
when t1.apply_memo  like '%航班取消%' then '航司--航班取消'
when t1.apply_memo  like '%回程取消%' then '航司--航班取消'
when t1.apply_memo  like '%去程航取%' then '航司--航班取消'
when t1.apply_memo  like '%取消航线%' then '航司--航班取消'
when t1.apply_memo  like '%号%取消%' then '航司--航班取消'
when t1.apply_memo  like '%回程%取消%' then '航司--航班取消'
when t1.apply_memo  like '%去程%取消%' then '航司--航班取消'
when t1.apply_memo  like '%第一程%取消%' then '航司--航班取消'
when t1.apply_memo  like '%第二程%取消%' then '航司--航班取消'
when t1.apply_memo  like '%第一段%取消%' then '航司--航班取消'
when t1.apply_memo  like '%第二段%取消%' then '航司--航班取消'
when t1.apply_memo  like '%前段%取消%' then '航司--航班取消'
when t1.apply_memo  like '%后段%取消%' then '航司--航班取消'
when t1.apply_memo  like '%去取消%' then '航司--航班取消'
when t1.apply_memo  like '%去程取消%' then '航司--航班取消'
when t1.apply_memo  like '%返程取消%' then '航司--航班取消'
when t1.apply_memo  like '%取消%' and t2.flag=2 then '航司--航班取消'
when t1.apply_memo  like '%航班备降%' then '航司--航班备降'
when t1.apply_memo  like '%备降%' then '航司--航班备降'
when t1.apply_memo  like '%航班改降%' then '航司--航班备降'
when t1.apply_memo  like '%航班时间调整%' then '航司--航班时刻调整'
when t1.apply_memo  like '%时刻调整%' then '航司--航班时刻调整'
when t1.apply_memo  like '%时刻变更%' then '航司--航班时刻调整'
when t1.apply_memo  like '%时调%' then '航司--航班时刻调整'
when t1.apply_memo  like '%补班%' then '航司--航班补班'
when t1.apply_memo  like '%价格跳水%' then '航司--价格跳水'
when t1.apply_memo  like '%价格下降%' then '航司--价格跳水'
when t1.apply_memo  like '%跳水%' then '航司--价格跳水'
when t1.apply_memo  like '%病退%' then '旅客--病退'
when t1.apply_memo  like '%出血%' then '旅客--病退'
when t1.apply_memo  like '%心脏病%' then '旅客--病退'
when t1.apply_memo  like '%食物中毒%' then '旅客--病退'
when t1.apply_memo  like '%孕妇%' then '旅客--病退'
when t1.apply_memo  like '%怀孕%' then '旅客--病退'
when t1.apply_memo  like '%肺炎%' then '旅客--病退'
when t1.apply_memo  like '%肠胃炎%' then '旅客--病退'
when t1.apply_memo  like '%死亡%' then '旅客--病退'
when t1.apply_memo  like '%因病%' then '旅客--病退'
when t1.apply_memo  like '%病陪%' then '旅客--病退'

when t1.apply_memo  like '%疫情%' then '疫情'
when t1.apply_memo  like '%新冠%' then '疫情'
when t1.apply_memo  like '%符合%授权%' then '疫情'
when t1.apply_memo  like '%进出授权%' then '疫情'
when t1.apply_memo  like '%行程卡%' then '疫情'
when t1.apply_memo  like '%隔离%' then '疫情'
when t1.apply_memo  like '%核酸%' then '疫情'
when t1.apply_memo  like '%旅居史%' then '疫情'
when t1.apply_memo  like '%旅行史%' then '疫情'
when t1.apply_memo  like '%防疫%' then '疫情'
when t1.apply_memo  like '%行程码%' then '疫情'
when t1.apply_memo  like '%分控%' then '特殊情况--分控同意'
when t1.apply_memo  like '%审核修改费%' then '特殊情况--审核修改费用'
when t1.apply_memo  like '%投诉%' then '投诉处理'
when t1.apply_memo  like '%市场部%同意%' then '投诉处理'
when t1.apply_memo  like '%汪老师%' then '投诉处理'
when t1.apply_memo  like '%应老师%' then '投诉处理'
when t1.apply_memo  like '%陆丹%' then '投诉处理'
when t1.apply_memo  like '%张英%' then '投诉处理'
when t1.apply_memo  like '%应张蝶%' then '投诉处理'
when t1.apply_memo  like '%顾老师%' then '投诉处理'
when t1.apply_memo  like '%汪华茂%' then '投诉处理'
when t1.apply_memo  like '%吴世娟%' then '投诉处理'
when t1.apply_memo  like '%蔡老师%' then '投诉处理'
when t1.apply_memo  like '%范香%' then '投诉处理'

when t1.apply_memo  like '%定错%' then '旅客--订错重购'
when t1.apply_memo  like '%买错%' then '旅客--订错重购'
when t1.apply_memo  like '%补儿童%' then '旅客--补订儿童婴儿'
when t1.apply_memo  like '%航班保护%' then '航司--航班保护'
when t1.apply_memo  like '%去程%保护%' then '航司--航班保护'
when t1.apply_memo  like '%取消%保护%' then '航司--航班保护'
when t1.apply_memo  like '%前段%保护%' then '航司--航班保护'
when t1.apply_memo  like '%后段%保护%' then '航司--航班保护'
when t1.apply_memo  like '%保护不乘坐%' then '航司--航班保护'
when t1.apply_memo  like '%保护航班不乘坐%' then '航司--航班保护'
when t1.apply_memo  like '%取消保护不坐%' then '航司--航班保护'
when t1.apply_memo  like '%航班保护不乘坐%' then '航司--航班保护'
when t1.apply_memo  like '%保护航班不坐%' then '航司--航班保护'
when t1.apply_memo  like '%保护航班%' then '航司--航班保护'
when t1.apply_memo  like '%保护不坐%' then '航司--航班保护'
when t1.apply_memo  like '%保护%' then '航司--航班保护'
when t1.apply_memo  like '%不正常航班%' then '航司--不正常航班'
when t1.apply_memo  like '%暂停销售%' then '航司--不正常航班'
when t1.apply_memo  like '%去程不正常%' then '航司--不正常航班'
when t1.apply_memo  like '%航班停售%' then '航司--不正常航班'
when t1.apply_memo  like '%前段不正常%' then '航司--不正常航班'
when t1.apply_memo  like '%不正常回程%' then '航司--不正常航班'
when t1.apply_memo  like '%航班不正常%' then '航司--不正常航班'
when t1.apply_memo  like '%停止销售%' then '航司--不正常航班'
when t1.apply_memo  like '%不正常%' then '航司--不正常航班'
when t1.apply_memo  like '%停售%' then '航司--不正常航班'
when t1.apply_memo  like '%术后%' then '旅客--病退'
when t1.apply_memo  like '%高危%' then '旅客--病退'
when t1.apply_memo  like '%地震%' then '特殊事件'
when t1.apply_memo  like '%暴乱%' then '特殊事件'
when t1.apply_memo  like '%暴动%' then '特殊事件'
when t1.apply_memo  like '%学生%' then '旅客--学生政策'
when t1.apply_memo  like '%学校%' then '旅客--学生政策'
when t1.apply_memo  like '%关系户%' then '关系户'
when t1.apply_memo  like '%二次%' then '特殊情况--二次退'
when t1.apply_memo  like '%2次%' then '特殊情况--二次退'
when t1.apply_memo  like '%分控%' then '特殊情况--主控同意'
when t1.apply_memo  like '%主控%' then '特殊情况--主控同意'
when t1.apply_memo  like '%总控%' then '特殊情况--主控同意'
when t1.apply_memo  like '%特殊退改%' then '特殊退改政策'
when t1.apply_memo  like '%退改政策%' then '特殊退改政策'
when t1.apply_memo  like '%特殊政策%' then '特殊退改政策'
when t1.apply_memo  like '%香港政策%' then '特殊退改政策'
when t1.apply_memo  like '%特殊退票%' then '特殊退改政策'
when t1.apply_memo  like '%自愿%' then '旅客自愿'
when lower(t1.apply_memo)  like '%ziyuan%' then '旅客自愿'
when t1.apply_memo  like '%单%退%' then '单退'
when t1.apply_memo  like '%退 机 建 与 燃 油%' then '旅客自愿'
when t1.apply_memo  like '%退 机 建%' then '旅客自愿'
when t1.apply_memo  like '%自退%' then '旅客自愿'
when t1.apply_memo  like '%退机建%' then '旅客自愿'
when t1.apply_memo  like '%tuishui%' then '旅客自愿'
when t1.apply_memo  like '%退机建费%' then '旅客自愿'
when t1.apply_memo  like '%退机税%' then '旅客自愿'
when t1.apply_memo  like '%褪税%' then '旅客自愿'
when t1.apply_memo  like '%推机税%' then '旅客自愿'
when t1.apply_memo  like '%退机场建设费%' then '旅客自愿'
when t1.apply_memo  like '%退稅%' then '旅客--自愿'
when t1.apply_memo  like '%退税%' then '旅客--自愿'
when t1.apply_memo  like '%被减%' then '旅客--被减'
when t1.apply_memo  like '%超售%' then '旅客--超售'
when t1.apply_memo  like '%误机%' then '旅客--误机'
when t1.apply_memo  like '%晚到%' then '旅客--误机'
when t1.apply_memo  like '%wuji%' then '旅客--误机'
when t1.apply_memo  like '%漏机%' then '旅客--误机'
when t1.apply_memo  like '%拒载%' then '旅客--拒载'
when t1.apply_memo  like '%遗失%' then '旅客--客票遗失'
when t1.apply_memo  like '%测试%' then '测试'
when lower(t1.apply_memo)  like '%test%' then '测试'
when t1.apply_memo  like '%盗卡%' then '旅客--盗卡'
when t1.apply_memo  like '%20%%' then '投诉--少收手续费处理'
when t1.apply_memo  like '%30%%' then '投诉--少收手续费处理'
when t1.apply_memo  like '%10%%' then '投诉--少收手续费处理'
when t1.apply_memo  like '%5%%' then '投诉--少收手续费处理'
when t1.apply_memo  like '%机构退票%' then '机构退票'
when t1.apply_memo  like '%授权%' then '疫情'
when t1.apply_memo is not null then '其他原因'
else  '未填写相应申请理由'  end apply_memo,
t1.apply_user,
case when t1.money_terminal< 0 then '线上'
when t1.money_terminal>0 then '线下' end 退票渠道,
t6.unnormaltype 不正常类型,
t6.reason,
t6.PUBLISH_DATE,
t6.LAST_PUBLISH,
t6.DELAY_HOUR,
case when t6.PUBLISH_DATE is not null and t1.money_date >=t6.PUBLISH_DATE and t6.unnormaltype='延误'
and t6.DELAY_HOUR>=3 then '不正常公告发布后延误3小时以上操作退票'
when t6.PUBLISH_DATE is not null and t1.money_date >=t6.PUBLISH_DATE and t6.unnormaltype='延误'
and t6.DELAY_HOUR>=1.5 then '不正常公告发布后延误90分钟到3小时以上操作退票'
 when t6.PUBLISH_DATE is not null and  t1.money_date>=t6.PUBLISH_DATE and t6.unnormaltype='延误'
and t6.DELAY_HOUR>=0.25 and t6.DELAY_HOUR< 1.5 then '不正常公告发布后延误15分钟到90分钟操作退票'
when t6.PUBLISH_DATE is not null and t1.money_date>=t6.PUBLISH_DATE and t6.unnormaltype='延误'
 then '不正常公告发布后其他延误操作退票'
 when t6.PUBLISH_DATE is not null and t1.money_date>=t6.PUBLISH_DATE
 then '不正常公告发布后非延误操作退票'
 else null end 公告时间类型,
t1.money_fy,
t1.ticketprice,
case when t8.order_head_id is not null then '不正常航班保护'
else '-' end is_guard,
dim1.return_channel,
case when t9.channel in('OTA','旗舰店','网站','手机') then t9.sub_channel
when t9.channel not in('OTA','旗舰店','网站','手机')  then t9.channel end  order_channel
 from dw.da_order_drawback t1
 join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
 left join dw.dim_segment_type t3 on t2.h_route_id=t3.h_route_id and t2.route_id=t3.route_id
 left join hdb.cq_airport t4 on t2.originairport=t4.threecodeforcity
 left join hdb.cq_airport t5 on t2.destairport=t5.threecodeforcity
left join (select distinct order_head_id
 from cqsale.cq_free_change_log@to_air
 where state in(1,2))t8 on t8.order_head_id=t1.flights_order_head_Id
 left join dw.fact_recent_order_detail t9 on t1.flights_order_head_id=t9.flights_order_head_id
 --left join cqsale.cq_return_ticket_channel@to_air  t10 on t10.flights_order_head_id=t1.flights_order_head_id
 left join (select *
from(
select t1.segment_head_id,t1.unnormaltype,t1.reason,t1.PUBLISH_DATE,t1.LAST_PUBLISH,t1.DELAY_HOUR,
row_number()over(partition by segment_head_id
order by t1.last_publish desc) rid
from dw.tw_unnormal_flight t1)h1
where h1.rid=1) t6 on t1.segment_head_id=t6.segment_head_id
left join dw.da_foc_flight t7 on t1.segment_head_id=t7.segment_head_id
left join stg.s_cq_foc_landfee scfl on t7.foc_id=.id
left join (select *
from(
select ct1.FLIGHTS_ORDER__HEAD_ID flights_order_head_id,
case when ct1.TERMINAL_ID<0 and nvl(ct1.web_id,0)=0 and ct1.SALE_TYPE_DETAIL <=2 then '网站'
when ct1.TERMINAL_ID<0 and nvl(ct1.web_id,0)=0 and ct1.SALE_TYPE_DETAIL in(5,10) then '小程序'
when ct1.TERMINAL_ID<0 and nvl(ct1.web_id,0)=0 and ct1.SALE_TYPE_DETAIL in(3,8)  then 'IOS'
when ct1.TERMINAL_ID<0 and nvl(ct1.web_id,0)=0 and ct1.SALE_TYPE_DETAIL in(4,9)  then 'Android'
when ct1.TERMINAL_ID<0 and nvl(ct1.web_id,0)=0 then '线上自有渠道'
when nvl(ct1.web_id,0) in(1219,128,146,1482,1483,150,2185,228,2932,2956,3420,3979,435,4621,6298,7314,940)
then ct3.abrv
when  nvl(ct1.web_id,0) >0 and regexp_like(ct3.name,'(B2G)|(机构客户)|(集团客户)')  then '机构客户'
when  nvl(ct1.terminal_id,0) >0 and regexp_like(ct2.terminal,'(B2G)|(机构客户)|(集团客户)')  then '机构客户'
else 'B2B' end  return_channel,
ct1.OPERATE_INFO,
ct1.USERS_ID,
ct1.RETURN_DATE,
row_number()over(partition by ct1.FLIGHTS_ORDER__HEAD_ID order by ct1.RETURN_DATE) rid
 from cqsale.cq_return_ticket_channel@to_air ct1
 left join stg.s_cq_terminal ct2 on ct1.terminal_id=ct2.terminal_id
 left join stg.s_cq_agent_info ct3 on ct1.web_id=ct3.agent_id
 )
 where rid=1 
) dim1 on dim1.flights_order_head_id=t1.flights_order_head_id

  where t1.money_date>=date'2020-11-01'
 and t1.money_date< trunc(sysdate)
 and t2.company_id=0
     )hb1
left join dw.dim_tq_history_rule hb2 on hb1.nationflag=hb2.nationflag 
and hb1.seat_type=hb2.seat_type and hb1.priod_date=hb2.priod_type and hb1.seats_name=hb2.seats_name
and hb1.segment_country=nvl(hb2.segment_country,hb1.segment_country)
and trunc(hb1.r_order_date)>=hb2.begin_date and trunc(hb1.r_order_date)<=nvl(hb2.end_date,trunc(sysdate))
)hb2
group by hb2.smonth,hb2.flights_segment_name,hb2.nationflag,hb2.segment_country,
hb2.seat_type,hb2.foc实际起飞延误时间,case  when hb2.ticketprice=0 and hb2.money_fy=0 then '0元机票'
when hb2.退票渠道='线上' and hb2.money_fy =0 then '0元线上'
when hb2.退票渠道='线下' and hb2.money_fy=0 then 
case when hb2.is_guard ='不正常航班保护' then '航班保护0元'
when hb2.航班类型 in('取消','取消航班') and hb2.公告时间类型 is not null then '取消航班0元'
when hb2.航班类型 ='延误' and hb2.公告时间类型 ='不正常公告发布后延误3小时以上操作退票' then '延误3小时0元'
when hb2.航班类型 ='延误' and hb2.公告时间类型 in('不正常公告发布后延误90分钟到3小时以上操作退票','不正常公告发布后延误3小时以上操作退票')
 and hb2.money_date>=date'2021-09-01' then '延误1.5小时0元'
when hb2.航班类型 ='延误' and hb2.公告时间类型 in('不正常公告发布后延误90分钟到3小时以上操作退票',
'不正常公告发布后延误3小时以上操作退票','不正常公告发布后延误15分钟到90分钟操作退票')
 and hb2.money_date>=date'2021-11-16' then '延误15分钟0元'
when hb2.money_date>=hb2.origin_std and hb2.foc实际起飞延误时间='3h+' then '起飞后退实际延误3H0元'
when hb2.money_date>=hb2.origin_std and hb2.foc实际起飞延误时间 in('3h+','1.5h~3h') then '起飞后退实际延误1.5H0元'
when hb2.money_date>=hb2.origin_std and hb2.foc实际起飞延误时间 in('15min~90min') then '起飞后退实际延误15min0元'
when hb2.航班类型<>'正常航班' and hb2.公告时间类型 is not null then '不正常航班公告后退票'
when hb2.apply_memo like '%疫情%' then '备注-疫情0元'
when hb2.apply_memo in('旅客--误操作','旅客--订错重购') then '备注-误操作0元'
when hb2.apply_memo 
in('航司--航班取消','航司--航班时刻调整','航司--航班保护','航司--不正常航班','航司--航班延误','航司--航班补班','航司--航班备降')
then '备注-不正常航班0元'
when hb2.apply_memo 
in('旅客--误机','航司--价格跳水','政策--燃油问题','旅客--超售','旅客--被减','旅客--拒载','投诉处理') then '备注-旅客投诉0元' 
when hb2.apply_memo <>'未填写相应申请理由' then '0元备注-其他理由0元'
else '无备注0元' end
when hb2.money_fy>0 then '退票收费' end,hb2.费用类型,hb2.航班类型,hb2.priod_date,
hb2.退票渠道,hb2.apply_user,
case when hb2.DELAY_HOUR>=0.25 and hb2.DELAY_HOUR< 1.5 then '15m~90m'
when hb2.DELAY_HOUR>=1.5 and hb2.DELAY_HOUR< 3 then '1.5h~3h' 
when hb2.DELAY_HOUR>=3 and hb2.DELAY_HOUR< 5 then '3h~5h' 
when hb2.DELAY_HOUR>=5  then '5h' 
else '未延迟' end ,
hb2.公告时间类型,
hb2.收费类型,
hb2.is_guard



-----------------------------------------------------最终sql------------------------------------------------------------------------


select /*+parallel(4) */
hb2.smonth,hb2.nationflag,--hb2.flights_segment_name,hb2.segment_country,
hb2.seat_type,hb2.foc实际起飞延误时间,/*hb2.apply_memo,*/
case  when hb2.ticketprice=0 and hb2.money_fy=0 then '0元机票'
when hb2.退票渠道='线上' and hb2.money_fy =0 then '0元线上'
when hb2.退票渠道='线下' and hb2.money_fy=0 then 
case when hb2.is_guard ='不正常航班保护' then '航班保护0元'
when hb2.航班类型 in('取消','取消航班') and hb2.公告时间类型 is not null then '取消航班0元'
when hb2.航班类型 ='延误' and hb2.公告时间类型 ='不正常公告发布后延误3小时以上操作退票' then '延误3小时0元'
when hb2.航班类型 ='延误' and hb2.公告时间类型 in('不正常公告发布后延误90分钟到3小时以上操作退票','不正常公告发布后延误3小时以上操作退票')
 and hb2.money_date>=date'2021-09-01' then '延误1.5小时0元'
when hb2.航班类型 ='延误' and hb2.公告时间类型 in('不正常公告发布后延误90分钟到3小时以上操作退票',
'不正常公告发布后延误3小时以上操作退票','不正常公告发布后延误15分钟到90分钟操作退票')
 and hb2.money_date>=date'2021-11-16' then '延误15分钟0元'
when hb2.money_date>=hb2.origin_std and hb2.foc实际起飞延误时间='3h+' then '起飞后退实际延误3H0元'
when hb2.money_date>=hb2.origin_std and hb2.foc实际起飞延误时间 in('3h+','1.5h~3h') then '起飞后退实际延误1.5H0元'
when hb2.money_date>=hb2.origin_std and hb2.foc实际起飞延误时间 in('15min~90min') then '起飞后退实际延误15min0元'
when hb2.航班类型<>'正常航班' and hb2.公告时间类型 is not null then '不正常航班公告后退票'
when hb2.apply_memo like '%疫情%' then '备注-疫情0元'
when hb2.apply_memo in('旅客--误操作','旅客--订错重购') then '备注-误操作0元'
when hb2.apply_memo 
in('航司--航班取消','航司--航班时刻调整','航司--航班保护','航司--不正常航班','航司--航班延误','航司--航班补班','航司--航班备降')
then '备注-不正常航班0元'
when hb2.apply_memo 
in('旅客--误机','航司--价格跳水','政策--燃油问题','旅客--超售','旅客--被减','旅客--拒载','投诉处理') then '备注-旅客投诉0元' 
when hb2.apply_memo <>'未填写相应申请理由' then '0元备注-其他理由0元'
else '无备注0元' end
when hb2.money_fy>0 then '退票收费' end apply_memo,

hb2.费用类型,hb2.航班类型,hb2.priod_date,
hb2.退票渠道,hb2.apply_user,
case when hb2.DELAY_HOUR>=0.25 and hb2.DELAY_HOUR< 1.5 then '15m~90m'
when hb2.DELAY_HOUR>=1.5 and hb2.DELAY_HOUR< 3 then '1.5h~3h' 
when hb2.DELAY_HOUR>=3 and hb2.DELAY_HOUR< 5 then '3h~5h' 
when hb2.DELAY_HOUR>=5  then '5h' 
else '未延迟' end 延误航班时间类型,
hb2.公告时间类型,
hb2.收费类型,
hb2.return_channel,
hb2.order_channel,
sum(hb2.money_fy) money_fy,
sum(hb2.ticketprice) ticketprice,
sum(hb2.ys_fee) ys_fee,
count(distinct hb2.flights_order_head_id) 退票量,
sum(hb2.ys_fee)-sum(hb2.money_fy) 金额差异,
hb2.is_guard 是否航班保护
from (
select hb1.*,hb2.drawback_rate,case when hb1.ticketprice=0 then '0元机票'
 when hb1.money_fy=0 then '0元收费'
when hb1.ticketprice>0 and hb1.money_fy=hb1.ticketprice*hb2.drawback_rate then '正常收费'
when hb1.ticketprice>0 and hb1.money_fy> hb1.ticketprice*hb2.drawback_rate then '多收费'
when hb1.ticketprice>0 and hb1.money_fy< hb1.ticketprice*hb2.drawback_rate then '少收费'
else '正常收费'
end 收费类型,nvl(hb1.ticketprice*hb2.drawback_rate,hb1.money_fy) ys_fee
from(
select t1.flights_order_head_id,
to_char(t1.money_date,'yyyymm') smonth,
t9.order_date,
t1.money_date,
t2.flight_date,
t2.flights_segment_name,
t2.area_type nationflag,
t2.segment_country,
t2.origin_std,
case when t1.seattype='商务座' then '商务座'
else '非商务座' end seat_type,
case when scfl.dis_round is not null then 
case when (scfl.dis_round -t2.origin_std)*24*60< 15 then '延误15分钟以下'
when (scfl.dis_round -t2.origin_std)*24*60>=15 and (scfl.dis_round-t2.origin_std)*24*60< 90 then '15min~90min'
when (scfl.dis_round -t2.origin_std)*24*60>=90 and (scfl.dis_round-t2.origin_std)*24< 3 then '1.5h~3h'
when (scfl.dis_round -t2.origin_std)*24>=3  then '3h+' end
else null end  foc实际起飞延误时间,
case when t1.money_fy=0 and t1.ticketprice=0  and t1.seats_name in('O','D') then 'OD退票'
when t1.money_fy=0 and t1.ticketprice=0   then '套票退票'
when t1.money_fy=0  then '0元退票'
when t1.money_fy>0 then '非0元退票' end 费用类型,
case when t2.flag=2 then '取消'
when t6.unnormaltype is not null then t6.unnormaltype
else '正常航班' end 航班类型,
case when t2.area_type ='国内' then
case when t1.origin_std-t1.money_date<0 then '离站后'
when (t1.origin_std-t1.money_date)*24<2 then '[0h,2h)'
when (t1.origin_std-t1.money_date)*24<24 then '[2h,1D)'
when (t1.origin_std-t1.money_date)<3 then '[1D,3D)'
when (t1.origin_std-t1.money_date)<7 then '[3D,7D)'
when (t1.origin_std-t1.money_date)>=7 then '7D+' end 
when t2.area_type ='国际' then
case when t1.origin_std-t1.money_date<0 then '离站后'
when (t1.origin_std-t1.money_date)<1 then '[0,1D)'
when (t1.origin_std-t1.money_date)<3 then '[1D,3D)'
when (t1.origin_std-t1.money_date)<7 then '[3D,7D)'
when (t1.origin_std-t1.money_date)<15 then '[7D,15D)'
when (t1.origin_std-t1.money_date)<30 then '[15D,30D)'
when (t1.origin_std-t1.money_date)>=30 then '30D+' end 
else null end priod_date,
nvl(t1.seats_name,'YE') seats_name,
t1.flights_order_id,
case when t1.apply_memo  like '%定错%' then '旅客--订错重购'
when t1.apply_memo  like '%订错%' then '旅客--订错重购'
when t1.apply_memo  like '%重购%' then '旅客--订错重购'
when t1.apply_memo  like '%重构%' then '旅客--订错重购'
when t1.apply_memo  like '%重订%' then '旅客--订错重购'
when t1.apply_memo  like '%新定单%' then '旅客--订错重购'
when t1.apply_memo  like '%重新订购%' then '旅客--订错重购'
when t1.apply_memo  like '%重复订票%' then '旅客--订错重购'
when t1.apply_memo  like '%重新购票%' then '旅客--订错重购'
when t1.apply_memo  like '%重复购票%' then '旅客--订错重购'
when t1.apply_memo  like '%航班选错%' then '旅客--订错重购'
when t1.apply_memo  like '%新订单%' then '旅客--订错重购'
when t1.apply_memo  like '%订反%' then '旅客--订错重购'
when t1.apply_memo  like '%原订单%' then '旅客--订错重购'
when t1.apply_memo  like '%原定单%' then '旅客--订错重购'
when t1.apply_memo  like '%误买%' then '旅客--订错重购'
when t1.apply_memo  like '%补订%' then '旅客--补订儿童婴儿'
when t1.apply_memo  like '%补丁%' then '旅客--补订儿童婴儿'
when t1.apply_memo  like '%漏订%' then '旅客--补订儿童婴儿'
when t1.apply_memo  like '%误操作%' then '旅客--误操作'
when t1.apply_memo  like '%误操%' then '旅客--误操作'
when t1.apply_memo  like '%推燃油%' then '政策--燃油问题'
when t1.apply_memo  like '%燃油问题%' then '政策--燃油问题'
when t1.apply_memo  like '%燃油%' then '政策--燃油问题'
when t1.apply_memo  like '%延误%' then '航司--航班延误'
when t1.apply_memo  like '%航班取消%' then '航司--航班取消'
when t1.apply_memo  like '%回程取消%' then '航司--航班取消'
when t1.apply_memo  like '%去程航取%' then '航司--航班取消'
when t1.apply_memo  like '%取消航线%' then '航司--航班取消'
when t1.apply_memo  like '%号%取消%' then '航司--航班取消'
when t1.apply_memo  like '%回程%取消%' then '航司--航班取消'
when t1.apply_memo  like '%去程%取消%' then '航司--航班取消'
when t1.apply_memo  like '%第一程%取消%' then '航司--航班取消'
when t1.apply_memo  like '%第二程%取消%' then '航司--航班取消'
when t1.apply_memo  like '%第一段%取消%' then '航司--航班取消'
when t1.apply_memo  like '%第二段%取消%' then '航司--航班取消'
when t1.apply_memo  like '%前段%取消%' then '航司--航班取消'
when t1.apply_memo  like '%后段%取消%' then '航司--航班取消'
when t1.apply_memo  like '%去取消%' then '航司--航班取消'
when t1.apply_memo  like '%去程取消%' then '航司--航班取消'
when t1.apply_memo  like '%返程取消%' then '航司--航班取消'
when t1.apply_memo  like '%取消%' and t2.flag=2 then '航司--航班取消'
when t1.apply_memo  like '%航班备降%' then '航司--航班备降'
when t1.apply_memo  like '%备降%' then '航司--航班备降'
when t1.apply_memo  like '%航班改降%' then '航司--航班备降'
when t1.apply_memo  like '%航班时间调整%' then '航司--航班时刻调整'
when t1.apply_memo  like '%时刻调整%' then '航司--航班时刻调整'
when t1.apply_memo  like '%时刻变更%' then '航司--航班时刻调整'
when t1.apply_memo  like '%时调%' then '航司--航班时刻调整'
when t1.apply_memo  like '%补班%' then '航司--航班补班'
when t1.apply_memo  like '%价格跳水%' then '航司--价格跳水'
when t1.apply_memo  like '%价格下降%' then '航司--价格跳水'
when t1.apply_memo  like '%跳水%' then '航司--价格跳水'
when t1.apply_memo  like '%病退%' then '旅客--病退'
when t1.apply_memo  like '%出血%' then '旅客--病退'
when t1.apply_memo  like '%心脏病%' then '旅客--病退'
when t1.apply_memo  like '%食物中毒%' then '旅客--病退'
when t1.apply_memo  like '%孕妇%' then '旅客--病退'
when t1.apply_memo  like '%怀孕%' then '旅客--病退'
when t1.apply_memo  like '%肺炎%' then '旅客--病退'
when t1.apply_memo  like '%肠胃炎%' then '旅客--病退'
when t1.apply_memo  like '%死亡%' then '旅客--病退'
when t1.apply_memo  like '%因病%' then '旅客--病退'
when t1.apply_memo  like '%病陪%' then '旅客--病退'

when t1.apply_memo  like '%疫情%' then '疫情'
when t1.apply_memo  like '%新冠%' then '疫情'
when t1.apply_memo  like '%符合%授权%' then '疫情'
when t1.apply_memo  like '%进出授权%' then '疫情'
when t1.apply_memo  like '%行程卡%' then '疫情'
when t1.apply_memo  like '%隔离%' then '疫情'
when t1.apply_memo  like '%核酸%' then '疫情'
when t1.apply_memo  like '%旅居史%' then '疫情'
when t1.apply_memo  like '%旅行史%' then '疫情'
when t1.apply_memo  like '%防疫%' then '疫情'
when t1.apply_memo  like '%行程码%' then '疫情'
when t1.apply_memo  like '%分控%' then '特殊情况--分控同意'
when t1.apply_memo  like '%审核修改费%' then '特殊情况--审核修改费用'
when t1.apply_memo  like '%投诉%' then '投诉处理'
when t1.apply_memo  like '%市场部%同意%' then '投诉处理'
when t1.apply_memo  like '%汪老师%' then '投诉处理'
when t1.apply_memo  like '%应老师%' then '投诉处理'
when t1.apply_memo  like '%陆丹%' then '投诉处理'
when t1.apply_memo  like '%张英%' then '投诉处理'
when t1.apply_memo  like '%应张蝶%' then '投诉处理'
when t1.apply_memo  like '%顾老师%' then '投诉处理'
when t1.apply_memo  like '%汪华茂%' then '投诉处理'
when t1.apply_memo  like '%吴世娟%' then '投诉处理'
when t1.apply_memo  like '%蔡老师%' then '投诉处理'
when t1.apply_memo  like '%范香%' then '投诉处理'

when t1.apply_memo  like '%定错%' then '旅客--订错重购'
when t1.apply_memo  like '%买错%' then '旅客--订错重购'
when t1.apply_memo  like '%补儿童%' then '旅客--补订儿童婴儿'
when t1.apply_memo  like '%航班保护%' then '航司--航班保护'
when t1.apply_memo  like '%去程%保护%' then '航司--航班保护'
when t1.apply_memo  like '%取消%保护%' then '航司--航班保护'
when t1.apply_memo  like '%前段%保护%' then '航司--航班保护'
when t1.apply_memo  like '%后段%保护%' then '航司--航班保护'
when t1.apply_memo  like '%保护不乘坐%' then '航司--航班保护'
when t1.apply_memo  like '%保护航班不乘坐%' then '航司--航班保护'
when t1.apply_memo  like '%取消保护不坐%' then '航司--航班保护'
when t1.apply_memo  like '%航班保护不乘坐%' then '航司--航班保护'
when t1.apply_memo  like '%保护航班不坐%' then '航司--航班保护'
when t1.apply_memo  like '%保护航班%' then '航司--航班保护'
when t1.apply_memo  like '%保护不坐%' then '航司--航班保护'
when t1.apply_memo  like '%保护%' then '航司--航班保护'
when t1.apply_memo  like '%不正常航班%' then '航司--不正常航班'
when t1.apply_memo  like '%暂停销售%' then '航司--不正常航班'
when t1.apply_memo  like '%去程不正常%' then '航司--不正常航班'
when t1.apply_memo  like '%航班停售%' then '航司--不正常航班'
when t1.apply_memo  like '%前段不正常%' then '航司--不正常航班'
when t1.apply_memo  like '%不正常回程%' then '航司--不正常航班'
when t1.apply_memo  like '%航班不正常%' then '航司--不正常航班'
when t1.apply_memo  like '%停止销售%' then '航司--不正常航班'
when t1.apply_memo  like '%不正常%' then '航司--不正常航班'
when t1.apply_memo  like '%停售%' then '航司--不正常航班'
when t1.apply_memo  like '%术后%' then '旅客--病退'
when t1.apply_memo  like '%高危%' then '旅客--病退'
when t1.apply_memo  like '%地震%' then '特殊事件'
when t1.apply_memo  like '%暴乱%' then '特殊事件'
when t1.apply_memo  like '%暴动%' then '特殊事件'
when t1.apply_memo  like '%学生%' then '旅客--学生政策'
when t1.apply_memo  like '%学校%' then '旅客--学生政策'
when t1.apply_memo  like '%关系户%' then '关系户'
when t1.apply_memo  like '%二次%' then '特殊情况--二次退'
when t1.apply_memo  like '%2次%' then '特殊情况--二次退'
when t1.apply_memo  like '%分控%' then '特殊情况--主控同意'
when t1.apply_memo  like '%主控%' then '特殊情况--主控同意'
when t1.apply_memo  like '%总控%' then '特殊情况--主控同意'
when t1.apply_memo  like '%特殊退改%' then '特殊退改政策'
when t1.apply_memo  like '%退改政策%' then '特殊退改政策'
when t1.apply_memo  like '%特殊政策%' then '特殊退改政策'
when t1.apply_memo  like '%香港政策%' then '特殊退改政策'
when t1.apply_memo  like '%特殊退票%' then '特殊退改政策'
when t1.apply_memo  like '%自愿%' then '旅客自愿'
when lower(t1.apply_memo)  like '%ziyuan%' then '旅客自愿'
when t1.apply_memo  like '%单%退%' then '单退'
when t1.apply_memo  like '%退 机 建 与 燃 油%' then '旅客自愿'
when t1.apply_memo  like '%退 机 建%' then '旅客自愿'
when t1.apply_memo  like '%自退%' then '旅客自愿'
when t1.apply_memo  like '%退机建%' then '旅客自愿'
when t1.apply_memo  like '%tuishui%' then '旅客自愿'
when t1.apply_memo  like '%退机建费%' then '旅客自愿'
when t1.apply_memo  like '%退机税%' then '旅客自愿'
when t1.apply_memo  like '%褪税%' then '旅客自愿'
when t1.apply_memo  like '%推机税%' then '旅客自愿'
when t1.apply_memo  like '%退机场建设费%' then '旅客自愿'
when t1.apply_memo  like '%退稅%' then '旅客--自愿'
when t1.apply_memo  like '%退税%' then '旅客--自愿'
when t1.apply_memo  like '%被减%' then '旅客--被减'
when t1.apply_memo  like '%超售%' then '旅客--超售'
when t1.apply_memo  like '%误机%' then '旅客--误机'
when t1.apply_memo  like '%晚到%' then '旅客--误机'
when t1.apply_memo  like '%wuji%' then '旅客--误机'
when t1.apply_memo  like '%漏机%' then '旅客--误机'
when t1.apply_memo  like '%拒载%' then '旅客--拒载'
when t1.apply_memo  like '%遗失%' then '旅客--客票遗失'
when t1.apply_memo  like '%测试%' then '测试'
when lower(t1.apply_memo)  like '%test%' then '测试'
when t1.apply_memo  like '%盗卡%' then '旅客--盗卡'
when t1.apply_memo  like '%20%%' then '投诉--少收手续费处理'
when t1.apply_memo  like '%30%%' then '投诉--少收手续费处理'
when t1.apply_memo  like '%10%%' then '投诉--少收手续费处理'
when t1.apply_memo  like '%5%%' then '投诉--少收手续费处理'
when t1.apply_memo  like '%机构退票%' then '机构退票'
when t1.apply_memo  like '%授权%' then '疫情'
when t1.apply_memo is not null then '其他原因'
else  '未填写相应申请理由'  end apply_memo,
t1.apply_user,
case when t1.money_terminal< 0 then '线上'
when t1.money_terminal>0 then '线下' end 退票渠道,
t6.unnormaltype 不正常类型,
t6.reason,
t6.PUBLISH_DATE,
t6.LAST_PUBLISH,
t6.DELAY_HOUR,
case when t6.PUBLISH_DATE is not null and t1.money_date >=t6.PUBLISH_DATE and t6.unnormaltype='延误'
and t6.DELAY_HOUR>=3 then '不正常公告发布后延误3小时以上操作退票'
when t6.PUBLISH_DATE is not null and t1.money_date >=t6.PUBLISH_DATE and t6.unnormaltype='延误'
and t6.DELAY_HOUR>=1.5 then '不正常公告发布后延误90分钟到3小时以上操作退票'
 when t6.PUBLISH_DATE is not null and  t1.money_date>=t6.PUBLISH_DATE and t6.unnormaltype='延误'
and t6.DELAY_HOUR>=0.25 and t6.DELAY_HOUR< 1.5 then '不正常公告发布后延误15分钟到90分钟操作退票'
when t6.PUBLISH_DATE is not null and t1.money_date>=t6.PUBLISH_DATE and t6.unnormaltype='延误'
 then '不正常公告发布后其他延误操作退票'
 when t6.PUBLISH_DATE is not null and t1.money_date>=t6.PUBLISH_DATE
 then '不正常公告发布后非延误操作退票'
 else null end 公告时间类型,
t1.money_fy,
t1.ticketprice,
case when t8.order_head_id is not null then '不正常航班保护'
else '-' end is_guard,
dim1.return_channel,
case when t9.channel in('网站','手机') and t91.users_id is not null then '黑代理'
when t9.channel in('网站','手机') and t9.pay_gate in(15,29,31) then '黑代理'
when t9.channel in('OTA','旗舰店','网站','手机') then t9.sub_channel
when t9.channel not in('OTA','旗舰店','网站','手机')  then t9.channel end  order_channel
 from dw.da_order_drawback t1
 join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
 left join dw.dim_segment_type t3 on t2.h_route_id=t3.h_route_id and t2.route_id=t3.route_id
 left join hdb.cq_airport t4 on t2.originairport=t4.threecodeforcity
 left join hdb.cq_airport t5 on t2.destairport=t5.threecodeforcity
left join (select distinct order_head_id
 from cqsale.cq_free_change_log@to_air
 where state in(1,2))t8 on t8.order_head_id=t1.flights_order_head_Id
 left join dw.fact_recent_order_detail t9 on t1.flights_order_head_id=t9.flights_order_head_id
 left join if.v_da_restrict_userinfo t91 on t9.client_id=t91.users_id
 --left join cqsale.cq_return_ticket_channel@to_air  t10 on t10.flights_order_head_id=t1.flights_order_head_id
 left join (select *
from(
select t1.segment_head_id,t1.unnormaltype,t1.reason,t1.PUBLISH_DATE,t1.LAST_PUBLISH,t1.DELAY_HOUR,
row_number()over(partition by segment_head_id
order by t1.last_publish desc) rid
from dw.tw_unnormal_flight t1)h1
where h1.rid=1) t6 on t1.segment_head_id=t6.segment_head_id
left join dw.da_foc_flight t7 on t1.segment_head_id=t7.segment_head_id
left join stg.s_cq_foc_landfee scfl on t7.foc_id=scfl.id
left join (select *
from(
select ct1.FLIGHTS_ORDER__HEAD_ID flights_order_head_id,
case when ct1.TERMINAL_ID<0 and nvl(ct1.web_id,0)=0 and ct1.SALE_TYPE_DETAIL <=2 then '网站'
when ct1.TERMINAL_ID<0 and nvl(ct1.web_id,0)=0 and ct1.SALE_TYPE_DETAIL in(5,10) then '小程序'
when ct1.TERMINAL_ID<0 and nvl(ct1.web_id,0)=0 and ct1.SALE_TYPE_DETAIL in(3,8)  then 'IOS'
when ct1.TERMINAL_ID<0 and nvl(ct1.web_id,0)=0 and ct1.SALE_TYPE_DETAIL in(4,9)  then 'Android'
when ct1.TERMINAL_ID<0 and nvl(ct1.web_id,0)=0 then '线上自有渠道'
when nvl(ct1.web_id,0) in(1219,128,146,1482,1483,150,2185,228,2932,2956,3420,3979,435,4621,6298,7314,940)
then ct3.abrv
when  nvl(ct1.web_id,0) >0 and regexp_like(ct3.name,'(B2G)|(机构客户)|(集团客户)')  then '机构客户'
when  nvl(ct1.terminal_id,0) >0 and regexp_like(ct2.terminal,'(B2G)|(机构客户)|(集团客户)')  then '机构客户'
else 'B2B' end  return_channel,
ct1.OPERATE_INFO,
ct1.USERS_ID,
ct1.RETURN_DATE,
row_number()over(partition by ct1.FLIGHTS_ORDER__HEAD_ID order by ct1.RETURN_DATE) rid
 from cqsale.cq_return_ticket_channel@to_air ct1
 left join stg.s_cq_terminal ct2 on ct1.terminal_id=ct2.terminal_id
 left join stg.s_cq_agent_info ct3 on ct1.web_id=ct3.agent_id
 )
 where rid=1 
) dim1 on dim1.flights_order_head_id=t1.flights_order_head_id

  where t1.money_date>=date'2020-11-01'
 and t1.money_date< trunc(sysdate)
 and t2.company_id=0
     )hb1
left join dw.dim_tq_history_rule hb2 on hb1.nationflag=hb2.nationflag 
and hb1.seat_type=hb2.seat_type and hb1.priod_date=hb2.priod_type and hb1.seats_name=hb2.seats_name
and hb1.segment_country=nvl(hb2.segment_country,hb1.segment_country)
and trunc(hb1.order_date)>=hb2.begin_date and trunc(hb1.order_date)<=nvl(hb2.end_date,trunc(sysdate))
)hb2
group by hb2.smonth,hb2.nationflag,--hb2.flights_segment_name,hb2.segment_country,
hb2.seat_type,hb2.foc实际起飞延误时间,case  when hb2.ticketprice=0 and hb2.money_fy=0 then '0元机票'
when hb2.退票渠道='线上' and hb2.money_fy =0 then '0元线上'
when hb2.退票渠道='线下' and hb2.money_fy=0 then 
case when hb2.is_guard ='不正常航班保护' then '航班保护0元'
when hb2.航班类型 in('取消','取消航班') and hb2.公告时间类型 is not null then '取消航班0元'
when hb2.航班类型 ='延误' and hb2.公告时间类型 ='不正常公告发布后延误3小时以上操作退票' then '延误3小时0元'
when hb2.航班类型 ='延误' and hb2.公告时间类型 in('不正常公告发布后延误90分钟到3小时以上操作退票','不正常公告发布后延误3小时以上操作退票')
 and hb2.money_date>=date'2021-09-01' then '延误1.5小时0元'
when hb2.航班类型 ='延误' and hb2.公告时间类型 in('不正常公告发布后延误90分钟到3小时以上操作退票',
'不正常公告发布后延误3小时以上操作退票','不正常公告发布后延误15分钟到90分钟操作退票')
 and hb2.money_date>=date'2021-11-16' then '延误15分钟0元'
when hb2.money_date>=hb2.origin_std and hb2.foc实际起飞延误时间='3h+' then '起飞后退实际延误3H0元'
when hb2.money_date>=hb2.origin_std and hb2.foc实际起飞延误时间 in('3h+','1.5h~3h') then '起飞后退实际延误1.5H0元'
when hb2.money_date>=hb2.origin_std and hb2.foc实际起飞延误时间 in('15min~90min') then '起飞后退实际延误15min0元'
when hb2.航班类型<>'正常航班' and hb2.公告时间类型 is not null then '不正常航班公告后退票'
when hb2.apply_memo like '%疫情%' then '备注-疫情0元'
when hb2.apply_memo in('旅客--误操作','旅客--订错重购') then '备注-误操作0元'
when hb2.apply_memo 
in('航司--航班取消','航司--航班时刻调整','航司--航班保护','航司--不正常航班','航司--航班延误','航司--航班补班','航司--航班备降')
then '备注-不正常航班0元'
when hb2.apply_memo 
in('旅客--误机','航司--价格跳水','政策--燃油问题','旅客--超售','旅客--被减','旅客--拒载','投诉处理') then '备注-旅客投诉0元' 
when hb2.apply_memo <>'未填写相应申请理由' then '0元备注-其他理由0元'
else '无备注0元' end
when hb2.money_fy>0 then '退票收费' end,hb2.费用类型,hb2.航班类型,hb2.priod_date,
hb2.退票渠道,hb2.apply_user,
case when hb2.DELAY_HOUR>=0.25 and hb2.DELAY_HOUR< 1.5 then '15m~90m'
when hb2.DELAY_HOUR>=1.5 and hb2.DELAY_HOUR< 3 then '1.5h~3h' 
when hb2.DELAY_HOUR>=3 and hb2.DELAY_HOUR< 5 then '3h~5h' 
when hb2.DELAY_HOUR>=5  then '5h' 
else '未延迟' end ,
hb2.公告时间类型,
hb2.收费类型,
hb2.is_guard,
hb2.return_channel,
hb2.order_channel;

