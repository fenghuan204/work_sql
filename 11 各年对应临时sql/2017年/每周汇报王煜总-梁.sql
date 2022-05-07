select '订单日期' 日期类型,
case when t1.order_day>=trunc(sysdate)-7 then '本周'||'('||to_char(trunc(sysdate)-7,'mmdd')||'~'||to_char(trunc(sysdate)-1,'mmdd')||')'
when t1.order_day>=trunc(sysdate)-14 then '上周'||'('||to_char(trunc(sysdate)-14,'mmdd')||'~'||to_char(trunc(sysdate)-8,'mmdd')||')'
when t1.order_day>=trunc(sysdate)-21 then '上上周'||'('||to_char(trunc(sysdate)-21,'mmdd')||'~'||to_char(trunc(sysdate)-15,'mmdd')||')' end 对比日期,

case when t1.channel in('手机','网站','B2B','呼叫中心','B2G机构客户') then '自有渠道'
when t1.channel in('OTA','旗舰店') then 'OTA旗舰店'
when t1.channel in('B2B代理') then 'B2B代理' end 渠道大类, 
case when t1.channel='手机' and t1.station_id =2 then 'M网站'
            when t1.channel='手机' and t1.station_id in(5,10) then '微信'
            when t1.channel='手机' and t1.station_id in(3,8) then '手机IOS'
            when t1.channel='手机' and t1.station_id in(4,9) then '手机Andriod'
            else t1.channel end 渠道,t2.nationflag 航线性质,
            case when t1.seats_name in('B','G','G1','O') then 'BGO'
                 else '非BGO' end 舱位类型,
               count(1) 销量,
            sum(t1.ticket_price) 机票金额,
            sum(t1.price) 民航公布价和
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  where t1.order_day>=trunc(sysdate)-21
    and t1.order_day< trunc(sysdate) 
    and t2.flag<>2
    and t1.whole_flight like '9C%'
    and t1.seats_name is not null
  group by   case when t1.order_day>=trunc(sysdate)-7 then '本周'||'('||to_char(trunc(sysdate)-7,'mmdd')||'~'||to_char(trunc(sysdate)-1,'mmdd')||')'
when t1.order_day>=trunc(sysdate)-14 then '上周'||'('||to_char(trunc(sysdate)-14,'mmdd')||'~'||to_char(trunc(sysdate)-8,'mmdd')||')'
when t1.order_day>=trunc(sysdate)-21 then '上上周'||'('||to_char(trunc(sysdate)-21,'mmdd')||'~'||to_char(trunc(sysdate)-15,'mmdd')||')' end ,

case when t1.channel in('手机','网站','B2B','呼叫中心','B2G机构客户') then '自有渠道'
when t1.channel in('OTA','旗舰店') then 'OTA旗舰店'
when t1.channel in('B2B代理') then 'B2B代理' end , 
case when t1.channel='手机' and t1.station_id =2 then 'M网站'
            when t1.channel='手机' and t1.station_id in(5,10) then '微信'
            when t1.channel='手机' and t1.station_id in(3,8) then '手机IOS'
            when t1.channel='手机' and t1.station_id in(4,9) then '手机Andriod'
            else t1.channel end ,t2.nationflag,
            case when t1.seats_name in('B','G','G1','O') then 'BGO'
                 else '非BGO' end 
    
union all


select '航班日期' 日期类型,
case when t1.flights_date>=trunc(sysdate)-7 then '本周'||'('||to_char(trunc(sysdate)-7,'mmdd')||'~'||to_char(trunc(sysdate)-1,'mmdd')||')'
when t1.flights_date>=trunc(sysdate)-14 then '上周'||'('||to_char(trunc(sysdate)-14,'mmdd')||'~'||to_char(trunc(sysdate)-8,'mmdd')||')'
when t1.flights_date>=trunc(sysdate)-21 then '上上周'||'('||to_char(trunc(sysdate)-21,'mmdd')||'~'||to_char(trunc(sysdate)-15,'mmdd')||')' end 对比日期,

case when t1.channel in('手机','网站','B2B','呼叫中心','B2G机构客户') then '自有渠道'
when t1.channel in('OTA','旗舰店') then 'OTA旗舰店'
when t1.channel in('B2B代理') then 'B2B代理' end 渠道大类, 
case when t1.channel='手机' and t1.station_id =2 then 'M网站'
            when t1.channel='手机' and t1.station_id in(5,10) then '微信'
            when t1.channel='手机' and t1.station_id in(3,8) then '手机IOS'
            when t1.channel='手机' and t1.station_id in(4,9) then '手机Andriod'
            else t1.channel end 渠道,t2.nationflag,
            case when t1.seats_name in('B','G','G1','O') then 'BGO'
                 else '非BGO' end 舱位类型,
               count(1) 销量,
            sum(t1.ticket_price) 机票金额,
            sum(t1.price) 民航公布价和
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  where t1.flights_date>=trunc(sysdate)-21
    and t1.flights_date< trunc(sysdate) 
    and t2.flag<>2
    and t1.whole_flight like '9C%'
    and t1.seats_name is not null    
    
  group by   case when t1.flights_date>=trunc(sysdate)-7 then '本周'||'('||to_char(trunc(sysdate)-7,'mmdd')||'~'||to_char(trunc(sysdate)-1,'mmdd')||')'
when t1.flights_date>=trunc(sysdate)-14 then '上周'||'('||to_char(trunc(sysdate)-14,'mmdd')||'~'||to_char(trunc(sysdate)-8,'mmdd')||')'
when t1.flights_date>=trunc(sysdate)-21 then '上上周'||'('||to_char(trunc(sysdate)-21,'mmdd')||'~'||to_char(trunc(sysdate)-15,'mmdd')||')' end ,

case when t1.channel in('手机','网站','B2B','呼叫中心','B2G机构客户') then '自有渠道'
when t1.channel in('OTA','旗舰店') then 'OTA旗舰店'
when t1.channel in('B2B代理') then 'B2B代理' end , 
case when t1.channel='手机' and t1.station_id =2 then 'M网站'
            when t1.channel='手机' and t1.station_id in(5,10) then '微信'
            when t1.channel='手机' and t1.station_id in(3,8) then '手机IOS'
            when t1.channel='手机' and t1.station_id in(4,9) then '手机Andriod'
            else t1.channel end ,t2.nationflag,
            case when t1.seats_name in('B','G','G1','O') then 'BGO'
                 else '非BGO' end 
    
