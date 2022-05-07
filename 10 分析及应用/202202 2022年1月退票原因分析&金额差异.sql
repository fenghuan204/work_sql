--## 退票分析

-----航班日期退票数据分析

-----航班日期退票数据分析
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
when hb2.apply_memo like '%疫情%' then hb2.apply_memo
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
hb2.is_guard 是否航班保护,
zhengce 疫情政策,
seatnametype 舱位类型
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
to_char(t1.origin_std,'yyyymm') smonth,
t9.order_date,
t1.money_date,
t2.flight_date,
t2.flights_segment_name,
t2.area_type nationflag,
t2.segment_country,
t2.origin_std,
case when t1.seattype='商务座' then '商务座'
else '非商务座' end seat_type,
case when t9.order_date< to_date('2022-02-09','yyyy-mm-dd') and t1.origin_std>=to_date('2022-02-08','yyyy-mm-dd')
and t1.origin_std< to_date('2022-03-01','yyyy-mm-dd') and t1.money_date>=date'2022-02-08' 
and regexp_like(t2.flights_segment_name,'南宁|桂林|北海|柳州') then '外部-南宁桂林北海柳州进出港'
when t9.order_date< to_date('2022-02-02','yyyy-mm-dd') and t1.origin_std>=to_date('2022-02-01','yyyy-mm-dd')
and t1.origin_std< to_date('2022-02-21','yyyy-mm-dd') and t1.money_date>=date'2022-02-01' 
and regexp_like(t2.flights_segment_name,'深圳') then '外部-深圳2月初'
when t9.order_date< to_date('2022-01-27','yyyy-mm-dd') and t1.origin_std>=to_date('2022-01-26','yyyy-mm-dd')
and t1.origin_std< to_date('2022-02-09','yyyy-mm-dd') and t1.money_date>=date'2022-01-26' 
and t2.flights_segment_name like '%杭州%' then '外部-杭州1月下旬'
when t9.order_date< to_date('2022-01-26','yyyy-mm-dd') and t1.origin_std>=to_date('2022-01-25','yyyy-mm-dd')
and t1.origin_std< to_date('2022-02-08','yyyy-mm-dd') and t1.money_date>=date'2022-01-25' 
and t2.flights_segment_name like '%沈阳%' then '外部-沈阳1月下旬'

when t9.order_date< to_date('2022-01-25','yyyy-mm-dd') and t1.origin_std>=to_date('2022-01-24','yyyy-mm-dd')
and t1.origin_std< to_date('2022-02-07','yyyy-mm-dd') and t1.money_date>=date'2022-01-24' 
and regexp_like(t2.flights_city_name,'上海|天津|珠海') then '外部-上海天津珠海进出港'

when t9.order_date< to_date('2022-01-23','yyyy-mm-dd') and t1.origin_std>=to_date('2022-01-23','yyyy-mm-dd')
and t1.origin_std< to_date('2022-02-06','yyyy-mm-dd') and t1.money_date>=date'2022-01-23' 
and regexp_like(t2.flights_city_name,'济南|西双版纳') then '外部-济南西双版纳'

when t9.order_date< to_date('2022-01-19','yyyy-mm-dd') and t1.origin_std>=to_date('2022-01-18','yyyy-mm-dd')
and t1.origin_std< to_date('2022-02-02','yyyy-mm-dd') and t1.money_date>=date'2022-01-18' 
and regexp_like(t2.flights_city_name,'天津|西安|深圳|郑州') then '外部-天津西安深圳郑州'

when t9.order_date< to_date('2022-01-15','yyyy-mm-dd') and t1.origin_std>=to_date('2022-01-15','yyyy-mm-dd')
and t1.origin_std< to_date('2022-01-29','yyyy-mm-dd') and t1.money_date>=date'2022-01-14' 
and regexp_like(t2.flights_city_name,'珠海') then '外部-珠海1月中旬'

when t9.order_date< to_date('2022-01-14','yyyy-mm-dd') and t1.origin_std>=to_date('2022-01-14','yyyy-mm-dd')
and t1.origin_std< to_date('2022-01-28','yyyy-mm-dd') and t1.money_date>=date'2022-01-14' 
and regexp_like(t2.flights_city_name,'杭州') then '外部-杭州1月中旬'

when t9.order_date< to_date('2022-01-13','yyyy-mm-dd') and t1.origin_std>=to_date('2022-01-13','yyyy-mm-dd')
and t1.origin_std< to_date('2022-01-27','yyyy-mm-dd') and t1.money_date>=date'2022-01-13' 
and regexp_like(t2.flights_city_name,'上海') then '外部-上海1月中旬'

when t9.order_date< to_date('2022-01-12','yyyy-mm-dd') and t1.origin_std>=to_date('2022-01-12','yyyy-mm-dd')
and t1.origin_std< to_date('2022-01-27','yyyy-mm-dd') and t1.money_date>=date'2022-01-12' 
and regexp_like(t2.flights_city_name,'大连') then '外部-大连1月中旬'

when t9.order_date< to_date('2022-01-09','yyyy-mm-dd') and t1.origin_std>=to_date('2022-01-09','yyyy-mm-dd')
and t1.origin_std< to_date('2022-01-24','yyyy-mm-dd') and t1.money_date>=date'2022-01-09' 
and regexp_like(t2.flights_city_name,'天津') then '外部-天津1月中旬'


when t9.order_date< to_date('2022-01-07','yyyy-mm-dd') and t1.origin_std>=to_date('2022-01-07','yyyy-mm-dd')
and t1.origin_std< to_date('2022-01-22','yyyy-mm-dd') and t1.money_date>=date'2022-01-07' 
and regexp_like(t2.flights_city_name,'深圳') then '外部-深圳1月初'


when t9.order_date< to_date('2022-01-04','yyyy-mm-dd') and t1.origin_std>=to_date('2022-01-04','yyyy-mm-dd')
and t1.origin_std< to_date('2022-01-19','yyyy-mm-dd') and t1.money_date>=date'2022-01-04' 
and regexp_like(t2.flights_city_name,'深圳') then '外部-郑州1月初'

when t9.order_date< to_date('2022-01-02','yyyy-mm-dd') and t1.origin_std>=to_date('2022-01-02','yyyy-mm-dd')
and t1.origin_std< to_date('2022-01-17','yyyy-mm-dd') and t1.money_date>=date'2022-01-02' 
and regexp_like(t2.flights_city_name,'宁波') then '外部-宁波1月初'

when t9.order_date< to_date('2021-12-31','yyyy-mm-dd') and t1.origin_std>=to_date('2021-12-31','yyyy-mm-dd')
and t1.origin_std< to_date('2022-01-15','yyyy-mm-dd') and t1.money_date>=date'2021-12-31' 
and regexp_like(t2.flights_city_name,'洛阳') then '外部-洛阳12月底'
when t9.order_date< to_date('2021-12-28','yyyy-mm-dd') and t1.origin_std>=to_date('2021-12-28','yyyy-mm-dd')
and t1.origin_std< to_date('2022-01-12','yyyy-mm-dd') and t1.money_date>=date'2021-12-28' 
and regexp_like(t2.flights_city_name,'昆明|西双版纳') then '外部-昆明西双版纳12月底'

when t9.order_date< to_date('2021-12-23','yyyy-mm-dd') and t1.origin_std>=to_date('2021-12-22','yyyy-mm-dd')
and t1.origin_std< to_date('2022-01-22','yyyy-mm-dd') and t1.money_date>=date'2021-12-22' 
and regexp_like(t2.flights_city_name,'西安') then '外部-西安12月底'

when t9.order_date< to_date('2021-12-18','yyyy-mm-dd') and t1.origin_std>=to_date('2021-12-18','yyyy-mm-dd')
and t1.origin_std< to_date('2022-01-02','yyyy-mm-dd') and t1.money_date>=date'2021-12-17' 
and regexp_like(t2.flights_city_name,'西安|厦门|杭州|宁波') then '外部-西安厦门杭州宁波12月中旬'

when t9.order_date< to_date('2021-12-13','yyyy-mm-dd') and t1.origin_std>=to_date('2021-12-13','yyyy-mm-dd')
and t1.origin_std< to_date('2021-12-28','yyyy-mm-dd') and t1.money_date>=date'2021-12-13' 
and regexp_like(t2.flights_city_name,'杭州|宁波') then '外部-杭州宁波12月中旬'

when t9.order_date< to_date('2021-12-12','yyyy-mm-dd') and t1.origin_std>=to_date('2021-12-12','yyyy-mm-dd')
and t1.origin_std< to_date('2021-12-27','yyyy-mm-dd') and t1.money_date>=date'2021-12-12' 
and regexp_like(t2.flights_city_name,'西安') then '外部-西安12月中旬'

when t9.order_date< to_date('2021-12-08','yyyy-mm-dd') and t1.origin_std>=to_date('2021-12-08','yyyy-mm-dd')
and t1.origin_std< to_date('2021-12-23','yyyy-mm-dd') and t1.money_date>=date'2021-12-08' 
and regexp_like(t2.flights_city_name,'南京') then '外部-南京12月上旬'



when t9.order_date< to_date('2022-02-13','yyyy-mm-dd') and t1.origin_std>=to_date('2022-02-06','yyyy-mm-dd')
and t1.origin_std< to_date('2022-02-27','yyyy-mm-dd') and t1.money_date>=date'2022-02-06' 
and t2.flights_segment_name like '%南宁%' then '内部-南宁进出港'
when t9.order_date< to_date('2022-02-13','yyyy-mm-dd') and t1.origin_std>=to_date('2022-02-08','yyyy-mm-dd')
and t1.origin_std< to_date('2022-03-01','yyyy-mm-dd') and t1.money_date>=date'2022-02-08' 
and regexp_like(t2.flights_segment_name,'南宁|桂林|北海|柳州') then '内部-南宁桂林北海柳州进出港'
when t9.order_date< to_date('2022-02-13','yyyy-mm-dd') and t1.origin_std>=to_date('2022-02-08','yyyy-mm-dd')
and t1.origin_std< to_date('2022-03-01','yyyy-mm-dd') and t1.money_date>=date'2022-02-08' 
and regexp_like(t2.flights_segment_name,'南宁|桂林|北海|柳州') then '内部-南宁桂林北海柳州进出港'
when t9.order_date< to_date('2022-02-01','yyyy-mm-dd') and t1.origin_std>=to_date('2022-01-24','yyyy-mm-dd')
and t1.origin_std< to_date('2022-02-14','yyyy-mm-dd') and t1.money_date>=date'2022-01-24' 
and regexp_like(t2.flights_city_name,'上海|天津|珠海') then '内部-上海天津珠海进出港放宽一周'
when t9.order_date< to_date('2022-01-30','yyyy-mm-dd') and t1.origin_std>=to_date('2022-01-23','yyyy-mm-dd')
and t1.origin_std< to_date('2022-02-13','yyyy-mm-dd') and t1.money_date>=date'2022-01-23' 
and regexp_like(t2.flights_city_name,'济南|西双版纳') then '内部-济南西双版纳放宽一周'

when t9.order_date< to_date('2022-02-01','yyyy-mm-dd') and t1.origin_std>=to_date('2022-01-24','yyyy-mm-dd')
and t1.origin_std< to_date('2022-02-14','yyyy-mm-dd') and t1.money_date>=date'2022-01-24' 
and regexp_like(t2.flights_city_name,'伊宁|沈阳') then '内部-伊宁沈阳放宽一周'
when t9.order_date< to_date('2022-01-12','yyyy-mm-dd') and t1.origin_std>=to_date('2022-01-12','yyyy-mm-dd')
and t1.origin_std< to_date('2022-02-27','yyyy-mm-dd') and t1.money_date>=date'2022-01-12' 
and regexp_like(t2.flights_city_name,'大连') then '内部-大连1月中旬'

when t9.order_date< to_date('2022-01-08','yyyy-mm-dd') and t1.origin_std>=to_date('2022-01-08','yyyy-mm-dd')
and t1.origin_std< to_date('2022-01-23','yyyy-mm-dd') and t1.money_date>=date'2022-01-08' 
and regexp_like(t2.flights_city_name,'天津') then '内部-天津1月中旬'

when t9.order_date< to_date('2022-01-08','yyyy-mm-dd') and t1.origin_std>=to_date('2022-01-08','yyyy-mm-dd')
and t1.origin_std< to_date('2022-02-01','yyyy-mm-dd') and t1.money_date>=date'2022-01-08' 
and regexp_like(t2.flights_city_name,'西安|洛阳|宁波|郑州|上海|延安') then '内部-西安洛阳宁波郑州上海延安'

when  t1.origin_std>=to_date('2022-01-02','yyyy-mm-dd')
and t1.origin_std< to_date('2022-02-01','yyyy-mm-dd') and t1.money_date>=date'2022-01-02' and t1.money_date< date'2022-01-08'
and regexp_like(t2.flights_city_name,'西安|洛阳|宁波|昆明|延安') then '内部-西安洛阳宁波昆明延安'


when t9.order_date< to_date('2022-01-07','yyyy-mm-dd') and t1.origin_std>=to_date('2022-01-07','yyyy-mm-dd')
and t1.origin_std< to_date('2022-01-22','yyyy-mm-dd') and t1.money_date>=date'2022-01-07' 
and regexp_like(t2.flights_city_name,'深圳') then '内部-深圳1月上旬'

when t9.order_date< to_date('2022-01-04','yyyy-mm-dd') and t1.origin_std>=to_date('2022-01-03','yyyy-mm-dd')
and t1.origin_std< to_date('2022-01-18','yyyy-mm-dd') and t1.money_date>=date'2022-01-03' 
and regexp_like(t2.flights_city_name,'上海') then '内部-上海1月上旬'

when t9.order_date< to_date('2021-12-28','yyyy-mm-dd') and t1.origin_std>=to_date('2021-12-28','yyyy-mm-dd')
and t1.origin_std< to_date('2022-01-12','yyyy-mm-dd') and t1.money_date>=date'2021-12-28' 
and regexp_like(t2.flights_city_name,'南京') then '内部-南京12月底'

when t9.order_date< to_date('2021-12-27','yyyy-mm-dd') and t1.origin_std>=to_date('2021-12-27','yyyy-mm-dd')
and t1.origin_std< to_date('2022-01-11','yyyy-mm-dd') and t1.money_date>=date'2021-12-27' 
and regexp_like(t2.originairport_name,'揭阳|湛江|珠海|广州|深圳') then '内部-广东出发12月底'

else '---'

end  zhengce,











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
case when nvl(t1.apply_memo,dim2.memo_user)  like '%定错%' then '旅客--订错重购'
when nvl(t1.apply_memo,dim2.memo_user)  like '%订错%' then '旅客--订错重购'
when nvl(t1.apply_memo,dim2.memo_user)  like '%重购%' then '旅客--订错重购'
when nvl(t1.apply_memo,dim2.memo_user)  like '%重构%' then '旅客--订错重购'
when nvl(t1.apply_memo,dim2.memo_user)  like '%重订%' then '旅客--订错重购'
when nvl(t1.apply_memo,dim2.memo_user)  like '%新定单%' then '旅客--订错重购'
when nvl(t1.apply_memo,dim2.memo_user)  like '%重新订购%' then '旅客--订错重购'
when nvl(t1.apply_memo,dim2.memo_user)  like '%重复订票%' then '旅客--订错重购'
when nvl(t1.apply_memo,dim2.memo_user)  like '%重新购票%' then '旅客--订错重购'
when nvl(t1.apply_memo,dim2.memo_user)  like '%重复购票%' then '旅客--订错重购'
when nvl(t1.apply_memo,dim2.memo_user)  like '%航班选错%' then '旅客--订错重购'
when nvl(t1.apply_memo,dim2.memo_user)  like '%新订单%' then '旅客--订错重购'
when nvl(t1.apply_memo,dim2.memo_user)  like '%订反%' then '旅客--订错重购'
when nvl(t1.apply_memo,dim2.memo_user)  like '%原订单%' then '旅客--订错重购'
when nvl(t1.apply_memo,dim2.memo_user)  like '%原定单%' then '旅客--订错重购'
when nvl(t1.apply_memo,dim2.memo_user)  like '%误买%' then '旅客--订错重购'
when nvl(t1.apply_memo,dim2.memo_user)  like '%补订%' then '旅客--补订儿童婴儿'
when nvl(t1.apply_memo,dim2.memo_user)  like '%补丁%' then '旅客--补订儿童婴儿'
when nvl(t1.apply_memo,dim2.memo_user)  like '%漏订%' then '旅客--补订儿童婴儿'
when nvl(t1.apply_memo,dim2.memo_user)  like '%误操作%' then '旅客--误操作'
when nvl(t1.apply_memo,dim2.memo_user)  like '%误操%' then '旅客--误操作'
when nvl(t1.apply_memo,dim2.memo_user)  like '%推燃油%' then '政策--燃油问题'
when nvl(t1.apply_memo,dim2.memo_user)  like '%燃油问题%' then '政策--燃油问题'
when nvl(t1.apply_memo,dim2.memo_user)  like '%燃油%' then '政策--燃油问题'
when nvl(t1.apply_memo,dim2.memo_user)  like '%延误%' then '航司--航班延误'
when nvl(t1.apply_memo,dim2.memo_user)  like '%航班取消%' then '航司--航班取消'
when nvl(t1.apply_memo,dim2.memo_user)  like '%回程取消%' then '航司--航班取消'
when nvl(t1.apply_memo,dim2.memo_user)  like '%去程航取%' then '航司--航班取消'
when nvl(t1.apply_memo,dim2.memo_user)  like '%取消航线%' then '航司--航班取消'
when nvl(t1.apply_memo,dim2.memo_user)  like '%号%取消%' then '航司--航班取消'
when nvl(t1.apply_memo,dim2.memo_user)  like '%回程%取消%' then '航司--航班取消'
when nvl(t1.apply_memo,dim2.memo_user)  like '%去程%取消%' then '航司--航班取消'
when nvl(t1.apply_memo,dim2.memo_user)  like '%第一程%取消%' then '航司--航班取消'
when nvl(t1.apply_memo,dim2.memo_user)  like '%第二程%取消%' then '航司--航班取消'
when nvl(t1.apply_memo,dim2.memo_user)  like '%第一段%取消%' then '航司--航班取消'
when nvl(t1.apply_memo,dim2.memo_user)  like '%第二段%取消%' then '航司--航班取消'
when nvl(t1.apply_memo,dim2.memo_user)  like '%前段%取消%' then '航司--航班取消'
when nvl(t1.apply_memo,dim2.memo_user)  like '%后段%取消%' then '航司--航班取消'
when nvl(t1.apply_memo,dim2.memo_user)  like '%去取消%' then '航司--航班取消'
when nvl(t1.apply_memo,dim2.memo_user)  like '%去程取消%' then '航司--航班取消'
when nvl(t1.apply_memo,dim2.memo_user)  like '%返程取消%' then '航司--航班取消'
when nvl(t1.apply_memo,dim2.memo_user)  like '%取消%' and t2.flag=2 then '航司--航班取消'
when nvl(t1.apply_memo,dim2.memo_user)  like '%航班备降%' then '航司--航班备降'
when nvl(t1.apply_memo,dim2.memo_user)  like '%备降%' then '航司--航班备降'
when nvl(t1.apply_memo,dim2.memo_user)  like '%航班改降%' then '航司--航班备降'
when nvl(t1.apply_memo,dim2.memo_user)  like '%航班时间调整%' then '航司--航班时刻调整'
when nvl(t1.apply_memo,dim2.memo_user)  like '%时刻调整%' then '航司--航班时刻调整'
when nvl(t1.apply_memo,dim2.memo_user)  like '%时刻变更%' then '航司--航班时刻调整'
when nvl(t1.apply_memo,dim2.memo_user)  like '%时调%' then '航司--航班时刻调整'
when nvl(t1.apply_memo,dim2.memo_user)  like '%补班%' then '航司--航班补班'
when nvl(t1.apply_memo,dim2.memo_user)  like '%价格跳水%' then '航司--价格跳水'
when nvl(t1.apply_memo,dim2.memo_user)  like '%价格下降%' then '航司--价格跳水'
when nvl(t1.apply_memo,dim2.memo_user)  like '%跳水%' then '航司--价格跳水'
when nvl(t1.apply_memo,dim2.memo_user)  like '%病退%' then '旅客--病退'
when nvl(t1.apply_memo,dim2.memo_user)  like '%出血%' then '旅客--病退'
when nvl(t1.apply_memo,dim2.memo_user)  like '%心脏病%' then '旅客--病退'
when nvl(t1.apply_memo,dim2.memo_user)  like '%食物中毒%' then '旅客--病退'
when nvl(t1.apply_memo,dim2.memo_user)  like '%孕妇%' then '旅客--病退'
when nvl(t1.apply_memo,dim2.memo_user)  like '%怀孕%' then '旅客--病退'
when nvl(t1.apply_memo,dim2.memo_user)  like '%肺炎%' then '旅客--病退'
when nvl(t1.apply_memo,dim2.memo_user)  like '%肠胃炎%' then '旅客--病退'
when nvl(t1.apply_memo,dim2.memo_user)  like '%死亡%' then '旅客--病退'
when nvl(t1.apply_memo,dim2.memo_user)  like '%因病%' then '旅客--病退'
when nvl(t1.apply_memo,dim2.memo_user)  like '%病陪%' then '旅客--病退'
when nvl(t1.apply_memo,dim2.memo_user)  like '%符合%授权%' then '疫情-符合授权'
when nvl(t1.apply_memo,dim2.memo_user)  like '%进出授权%' then '疫情-符合授权'
when nvl(t1.apply_memo,dim2.memo_user)  like '%行程卡%' then '疫情-行程卡'
when nvl(t1.apply_memo,dim2.memo_user)  like '%隔离%' then '疫情-社区隔离'
when nvl(t1.apply_memo,dim2.memo_user)  like '%核酸%' then '疫情-核酸问题'
when nvl(t1.apply_memo,dim2.memo_user)  like '%核算%' then '疫情-核酸问题'
when nvl(t1.apply_memo,dim2.memo_user)  like '%旅居史%' then '疫情-旅居史'
when nvl(t1.apply_memo,dim2.memo_user)  like '%旅行史%' then '疫情-旅居史'
when nvl(t1.apply_memo,dim2.memo_user)  like '%行程码%' then '疫情-行程卡'
when nvl(t1.apply_memo,dim2.memo_user)  like '%拒载%' then '疫情-拒载'
when nvl(t1.apply_memo,dim2.memo_user)  like '%体温%' then '疫情-体温问题'
when nvl(t1.apply_memo,dim2.memo_user)  like '%防疫%' then '疫情'
when nvl(t1.apply_memo,dim2.memo_user)  like '%疫情%' then '疫情'
when nvl(t1.apply_memo,dim2.memo_user)  like '%新冠%' then '疫情'
when nvl(t1.apply_memo,dim2.memo_user)  like '%分控%' then '特殊情况--分控同意'
when nvl(t1.apply_memo,dim2.memo_user)  like '%审核修改费%' then '特殊情况--审核修改费用'
when nvl(t1.apply_memo,dim2.memo_user)  like '%投诉%' then '投诉处理'
when nvl(t1.apply_memo,dim2.memo_user)  like '%市场部%同意%' then '投诉处理'
when nvl(t1.apply_memo,dim2.memo_user)  like '%汪老师%' then '投诉处理'
when nvl(t1.apply_memo,dim2.memo_user)  like '%应老师%' then '投诉处理'
when nvl(t1.apply_memo,dim2.memo_user)  like '%陆丹%' then '投诉处理'
when nvl(t1.apply_memo,dim2.memo_user)  like '%张英%' then '投诉处理'
when nvl(t1.apply_memo,dim2.memo_user)  like '%应张蝶%' then '投诉处理'
when nvl(t1.apply_memo,dim2.memo_user)  like '%顾老师%' then '投诉处理'
when nvl(t1.apply_memo,dim2.memo_user)  like '%汪华茂%' then '投诉处理'
when nvl(t1.apply_memo,dim2.memo_user)  like '%吴世娟%' then '投诉处理'
when nvl(t1.apply_memo,dim2.memo_user)  like '%蔡老师%' then '投诉处理'
when nvl(t1.apply_memo,dim2.memo_user)  like '%范香%' then '投诉处理'
when nvl(t1.apply_memo,dim2.memo_user)  like '%定错%' then '旅客--订错重购'
when nvl(t1.apply_memo,dim2.memo_user)  like '%买错%' then '旅客--订错重购'
when nvl(t1.apply_memo,dim2.memo_user)  like '%补儿童%' then '旅客--补订儿童婴儿'
when nvl(t1.apply_memo,dim2.memo_user)  like '%航班保护%' then '航司--航班保护'
when nvl(t1.apply_memo,dim2.memo_user)  like '%去程%保护%' then '航司--航班保护'
when nvl(t1.apply_memo,dim2.memo_user)  like '%取消%保护%' then '航司--航班保护'
when nvl(t1.apply_memo,dim2.memo_user)  like '%前段%保护%' then '航司--航班保护'
when nvl(t1.apply_memo,dim2.memo_user)  like '%后段%保护%' then '航司--航班保护'
when nvl(t1.apply_memo,dim2.memo_user)  like '%保护不乘坐%' then '航司--航班保护'
when nvl(t1.apply_memo,dim2.memo_user)  like '%保护航班不乘坐%' then '航司--航班保护'
when nvl(t1.apply_memo,dim2.memo_user)  like '%取消保护不坐%' then '航司--航班保护'
when nvl(t1.apply_memo,dim2.memo_user)  like '%航班保护不乘坐%' then '航司--航班保护'
when nvl(t1.apply_memo,dim2.memo_user)  like '%保护航班不坐%' then '航司--航班保护'
when nvl(t1.apply_memo,dim2.memo_user)  like '%保护航班%' then '航司--航班保护'
when nvl(t1.apply_memo,dim2.memo_user)  like '%保护不坐%' then '航司--航班保护'
when nvl(t1.apply_memo,dim2.memo_user)  like '%保护%' then '航司--航班保护'
when nvl(t1.apply_memo,dim2.memo_user)  like '%不正常航班%' then '航司--不正常航班'
when nvl(t1.apply_memo,dim2.memo_user)  like '%暂停销售%' then '航司--不正常航班'
when nvl(t1.apply_memo,dim2.memo_user)  like '%去程不正常%' then '航司--不正常航班'
when nvl(t1.apply_memo,dim2.memo_user)  like '%航班停售%' then '航司--不正常航班'
when nvl(t1.apply_memo,dim2.memo_user)  like '%前段不正常%' then '航司--不正常航班'
when nvl(t1.apply_memo,dim2.memo_user)  like '%不正常回程%' then '航司--不正常航班'
when nvl(t1.apply_memo,dim2.memo_user)  like '%航班不正常%' then '航司--不正常航班'
when nvl(t1.apply_memo,dim2.memo_user)  like '%停止销售%' then '航司--不正常航班'
when nvl(t1.apply_memo,dim2.memo_user)  like '%不正常%' then '航司--不正常航班'
when nvl(t1.apply_memo,dim2.memo_user)  like '%停售%' then '航司--不正常航班'
when nvl(t1.apply_memo,dim2.memo_user)  like '%术后%' then '旅客--病退'
when nvl(t1.apply_memo,dim2.memo_user)  like '%高危%' then '旅客--病退'
when nvl(t1.apply_memo,dim2.memo_user)  like '%地震%' then '特殊事件'
when nvl(t1.apply_memo,dim2.memo_user)  like '%暴乱%' then '特殊事件'
when nvl(t1.apply_memo,dim2.memo_user)  like '%暴动%' then '特殊事件'
when nvl(t1.apply_memo,dim2.memo_user)  like '%学生%' then '旅客--学生政策'
when nvl(t1.apply_memo,dim2.memo_user)  like '%学校%' then '旅客--学生政策'
when nvl(t1.apply_memo,dim2.memo_user)  like '%关系户%' then '关系户'
when nvl(t1.apply_memo,dim2.memo_user)  like '%二次%' then '特殊情况--二次退'
when nvl(t1.apply_memo,dim2.memo_user)  like '%2次%' then '特殊情况--二次退'
when nvl(t1.apply_memo,dim2.memo_user)  like '%分控%' then '特殊情况--主控同意'
when nvl(t1.apply_memo,dim2.memo_user)  like '%主控%' then '特殊情况--主控同意'
when nvl(t1.apply_memo,dim2.memo_user)  like '%总控%' then '特殊情况--主控同意'
when nvl(t1.apply_memo,dim2.memo_user)  like '%特殊退改%' then '特殊退改政策'
when nvl(t1.apply_memo,dim2.memo_user)  like '%退改政策%' then '特殊退改政策'
when nvl(t1.apply_memo,dim2.memo_user)  like '%特殊政策%' then '特殊退改政策'
when nvl(t1.apply_memo,dim2.memo_user)  like '%香港政策%' then '特殊退改政策'
when nvl(t1.apply_memo,dim2.memo_user)  like '%特殊退票%' then '特殊退改政策'
when nvl(t1.apply_memo,dim2.memo_user)  like '%自愿%' then '旅客自愿'
when lower(nvl(t1.apply_memo,dim2.memo_user))  like '%ziyuan%' then '旅客自愿'
when nvl(t1.apply_memo,dim2.memo_user)  like '%单%退%' then '单退'
when nvl(t1.apply_memo,dim2.memo_user)  like '%退 机 建 与 燃 油%' then '旅客自愿'
when nvl(t1.apply_memo,dim2.memo_user)  like '%退 机 建%' then '旅客自愿'
when nvl(t1.apply_memo,dim2.memo_user)  like '%自退%' then '旅客自愿'
when nvl(t1.apply_memo,dim2.memo_user)  like '%退机建%' then '旅客自愿'
when nvl(t1.apply_memo,dim2.memo_user)  like '%tuishui%' then '旅客自愿'
when nvl(t1.apply_memo,dim2.memo_user)  like '%退机建费%' then '旅客自愿'
when nvl(t1.apply_memo,dim2.memo_user)  like '%退机税%' then '旅客自愿'
when nvl(t1.apply_memo,dim2.memo_user)  like '%褪税%' then '旅客自愿'
when nvl(t1.apply_memo,dim2.memo_user)  like '%推机税%' then '旅客自愿'
when nvl(t1.apply_memo,dim2.memo_user)  like '%退机场建设费%' then '旅客自愿'
when nvl(t1.apply_memo,dim2.memo_user)  like '%退稅%' then '旅客--自愿'
when nvl(t1.apply_memo,dim2.memo_user)  like '%退税%' then '旅客--自愿'
when nvl(t1.apply_memo,dim2.memo_user)  like '%被减%' then '旅客--被减'
when nvl(t1.apply_memo,dim2.memo_user)  like '%超售%' then '旅客--超售'
when nvl(t1.apply_memo,dim2.memo_user)  like '%误机%' then '旅客--误机'
when nvl(t1.apply_memo,dim2.memo_user)  like '%晚到%' then '旅客--误机'
when nvl(t1.apply_memo,dim2.memo_user)  like '%wuji%' then '旅客--误机'
when nvl(t1.apply_memo,dim2.memo_user)  like '%漏机%' then '旅客--误机'
when nvl(t1.apply_memo,dim2.memo_user)  like '%拒载%' then '疫情--拒载'
when nvl(t1.apply_memo,dim2.memo_user)  like '%遗失%' then '旅客--客票遗失'
when nvl(t1.apply_memo,dim2.memo_user)  like '%测试%' then '测试'
when lower(nvl(t1.apply_memo,dim2.memo_user))  like '%test%' then '测试'
when nvl(t1.apply_memo,dim2.memo_user)  like '%盗卡%' then '旅客--盗卡'
when nvl(t1.apply_memo,dim2.memo_user)  like '%20%%' then '投诉--少收手续费处理'
when nvl(t1.apply_memo,dim2.memo_user)  like '%30%%' then '投诉--少收手续费处理'
when nvl(t1.apply_memo,dim2.memo_user)  like '%10%%' then '投诉--少收手续费处理'
when nvl(t1.apply_memo,dim2.memo_user)  like '%5%%' then '投诉--少收手续费处理'
when nvl(t1.apply_memo,dim2.memo_user)  like '%机构退票%' then '机构退票'
when nvl(t1.apply_memo,dim2.memo_user)  like '%授权%' then '疫情-符合授权'
when nvl(t1.apply_memo,dim2.memo_user) is not null then '其他原因'
else  '未填写相应申请理由'  end  apply_memo,
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
case when t1.seats_name in('B','G','G1','G2','O','A','D','Z','I','J') then 'BGOADZIJ'
else '非特殊舱位' end seatnametype,
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
left join (select t1.flights_order_head_id,
       min(t1.memo_for_user)  memo_user
  from stg.s_cq_flights_head_history t1,
       stg.s_cq_order_head           t2,      
       stg.s_cq_flights_segment_head t9
 where t1.flights_order_head_id = t2.flights_order_head_id   
   and t2.segment_head_id = t9.segment_head_id
   and t9.origin_std >= to_date('2022-01-01', 'yyyy-mm-dd')
   and t9.origin_std <  to_date('2022-02-01', 'yyyy-mm-dd')
    and t1.log_code in (5,20)
    group by t1.flights_order_head_id
) dim2 on dim2.flights_order_head_Id=t1.flights_order_head_id




  where t1.origin_std>=date'2022-01-01'
 and t1.origin_std< date'2022-02-01'
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
when hb2.apply_memo like '%疫情%' then hb2.apply_memo
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
hb2.order_channel,
zhengce,
seatnametype;
