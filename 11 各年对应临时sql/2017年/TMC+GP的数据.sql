/*已上线：中兴商旅、金色世纪、阿斯兰、武汉胜意、宝钢国旅
未上线：深圳特航、汇联易、在路上、行旅、号码百事通、中智关爱通、锦江HRG、捷马BCD、华为慧通、北京宝库、美亚商旅、国旅运通、苏州罗盘、必去科技*/


select case when h1.channel in('B2G机构客户','TMC') then 'B2G+TMC'
when h1.channel in('OTA','旗舰店') then 'OTA+旗舰店'
when h1.channel in('B2B','呼叫中心') then 'B2B+呼叫中心'
else h1.channel end 渠道,
h1.channel 子渠道,
sum(ticket) 数量
from(
select  case when t1.sub_channel like '%CAACSC%' then 'GP'
when regexp_like(t1.sub_channel,'(宝钢国旅)|(中兴)|(金色世纪)|(阿斯兰)|(胜意)') then 'TMC'
when t1.channel='手机' and t1.station_id =2 then 'M网站'
            when t1.channel='手机' and t1.station_id in(5,10) then '微信'
            when t1.channel='手机' and t1.station_id >2 then 'APP'
            else t1.channel end channel,
        count(1)  ticket       
   from dw.fact_order_detail t1
   join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
   where t1.flights_date>=to_date('2017-10-01','yyyy-mm-dd')
     and t1.flights_date< to_date('2017-11-01','yyyy-mm-dd')
     and t1.company_id=0
     and t1.seats_name is not null
     and t1.seats_name not in('B','G','G1','G2','O')
  group by case when t1.sub_channel like '%CAACSC%' then 'GP'
when regexp_like(t1.sub_channel,'(宝钢国旅)|(中兴)|(金色世纪)|(阿斯兰)|(胜意)') then 'TMC'
when t1.channel='手机' and t1.station_id =2 then 'M网站'
            when t1.channel='手机' and t1.station_id in(5,10) then '微信'
            when t1.channel='手机' and t1.station_id >2 then 'APP'
            else t1.channel end)h1
            group by case when h1.channel in('B2G机构客户','TMC') then 'B2G+TMC'
when h1.channel in('OTA','旗舰店') then 'OTA+旗舰店'
when h1.channel in('B2B','呼叫中心') then 'B2B+呼叫中心'
else h1.channel end ,
h1.channel
