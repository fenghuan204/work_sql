select to_char(t1.flights_date,'yyyymm'),case when t1.seats_name in('B','G','G1','G2') then 'BG'
else '非BG' end,case when t1.channel='手机' and t1.station_id=2 then 'M网站'
when t1.channel ='手机' and t1.station_id  in(5,10) then '微信'
else t1.channel end,0,sum(t1.book_fee)
from dw.fact_other_order_detail t1
where t1.flights_date>=to_date('2016-11-01','yyyy-mm-dd')
  and t1.flights_date< to_date('2017-12-01','yyyy-mm-dd')
  and t1.company_id=0
  and t1.flag_id =40
  group by to_char(t1.flights_date,'yyyymm'),case when t1.seats_name in('B','G','G1','G2') then 'BG'
else '非BG' end,case when t1.channel='手机' and t1.station_id=2 then 'M网站'
when t1.channel ='手机' and t1.station_id  in(5,10) then '微信'
else t1.channel end
  
union all 
select to_char(t1.flights_date,'yyyymm'),case when t1.seats_name in('B','G','G1','G2') then 'BG'
else '非BG' end,case when t1.channel='手机' and t1.station_id=2 then 'M网站'
when t1.channel ='手机' and t1.station_id  in(5,10) then '微信'
else t1.channel end,count(1),0
from dw.fact_order_detail t1
where t1.flights_date>=to_date('2016-11-01','yyyy-mm-dd')
  and t1.flights_date< to_date('2017-12-01','yyyy-mm-dd')
  and t1.company_id=0
  and t1.seats_name is not null
  and t1.flag_id =40
  group by to_char(t1.flights_date,'yyyymm'),case when t1.seats_name in('B','G','G1','G2') then 'BG'
else '非BG' end,case when t1.channel='手机' and t1.station_id=2 then 'M网站'
when t1.channel ='手机' and t1.station_id  in(5,10) then '微信'
else t1.channel end
