
select '订单日期含退票' 类型,
to_char(t1.order_day,'yyyymm'),
       case when t1.channel in('网站','手机') then '线上自有渠道'
            when t1.channel in('OTA','旗舰店') then 'OTA'
            when t1.sub_channel = 'CAACSC' then  'GP' 
            when t1.channel = 'B2G机构客户' then 'TMCB2G'
            else t1.channel end,
       count(1),
       sum(count(1))over(partition by to_char(t1.order_day,'yyyymm'))
 from dw.fact_recent_order_detail t1
 join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
 where t1.order_day>=date'2020-11-01'
   and t1.order_day< date'2022-01-12'
   and t1.seats_name is not null 
   and t1.seats_name not in('B','G1','G','G2')
   group by to_char(t1.order_day,'yyyymm'), case when t1.channel in('网站','手机') then '线上自有渠道'
            when t1.channel in('OTA','旗舰店') then 'OTA'
            when t1.sub_channel = 'CAACSC' then  'GP' 
            when t1.channel = 'B2G机构客户' then 'TMCB2G'
            else t1.channel end
   
   
 union all
 
 
 select '航班日期已乘机' 类型,to_char(t1.flights_date,'yyyymm'),
       case when t1.channel in('网站','手机') then '线上自有渠道'
            when t1.channel in('OTA','旗舰店') then 'OTA'
            when t1.sub_channel = 'CAACSC' then  'GP' 
            when t1.channel = 'B2G机构客户' then 'TMCB2G'
            else t1.channel end,
       count(1),
       sum(count(1))over(partition by to_char(t1.flights_date,'yyyymm'))
 from dw.fact_recent_order_detail t1
 join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
 where t1.flights_date>=date'2020-11-01'
   and t1.flights_date< date'2022-01-12'
   and t1.seats_name is not null 
   and t1.flag_id=40
   and t1.seats_name not in('B','G1','G','G2')
   group by to_char(t1.flights_date,'yyyymm'), case when t1.channel in('网站','手机') then '线上自有渠道'
            when t1.channel in('OTA','旗舰店') then 'OTA'
            when t1.sub_channel = 'CAACSC' then  'GP' 
            when t1.channel = 'B2G机构客户' then 'TMCB2G'
            else t1.channel end;
