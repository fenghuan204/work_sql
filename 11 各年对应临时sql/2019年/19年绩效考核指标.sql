一、19年绩效考核标准：
1）  辅收指标考核
剔除：现场行李、现场选座
线上辅收：各渠道辅收+BG团队餐食
机票数据：（各渠道销售机票+在此辅收购买二次辅收的机票）剔除重复机票


select /*+parallel(4) */
h1.航班月,h1.channel,h1.sub_channel,sum(一次产品数量) 一次产品数量,
sum(二次产品数量) 二次产品数量,sum(一次产品金额) 一次产品金额,sum(二次产品金额) 二次产品金额,
sum(产品金额) 产品金额,sum(机票数量) 机票数量,sum(一次购辅收机票量) 一次购辅收机票量,
sum(二次购辅收机票量) 二次购辅收机票量,sum(购辅收机票量) 购辅收机票量
from(
select to_char(t1.flights_date, 'yyyymm') 航班月,
        case
         when t3.channel3='境外渠道' then '线下渠道'                
         when t1.channel in('手机','网站') then '线上自营渠道'
         when t1.channel in('OTA','旗舰店') then 'OTA+旗舰店' 
         else '线下渠道' end channel,
         case when t3.channel3='境外渠道' then '境外渠道'
         when t1.channel ='B2G机构客户' then 'B2GTMC'
         when t1.channel ='B2B' then 'B2B'
         when t1.channel ='B2B代理' then 'B2B代理'
         when t1.channel ='呼叫中心' then '呼叫中心'
         when t1.channel in('手机','网站') then '线上自营渠道'
         when t1.channel in('OTA','旗舰店') then 'OTA+旗舰店'
         else t1.sub_channel end sub_channel, 
       sum(case when t1.pay_together=0 then t1.book_num else 0 end) 一次产品数量,
       sum(case when t1.pay_together=1 then t1.book_num else 0 end) 二次产品数量,
       sum(case when t1.pay_together=0 then t1.book_fee else 0 end) 一次产品金额,
       sum(case when t1.pay_together=1 then t1.book_fee else 0 end) 二次产品金额,       
       sum(t1.book_fee) 产品金额,
       0 机票数量,
       count(distinct  case when t1.pay_together=0 then t1.flights_order_head_id else null end) 一次购辅收机票量,
       count(distinct  case when t1.pay_together=1 then t1.flights_order_head_id else null end) 二次购辅收机票量,
       count(distinct  t1.flights_order_head_id ) 购辅收机票量 
  from dw.fact_other_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id = t2.segment_head_id
  left join hdb.an_termianl_classify t3 on t1.sub_channel=t3.terminal
 where t1.flights_date >= to_date('2016-11-01', 'yyyy-mm-dd')
   and t1.flights_date < to_date('2018-12-01', 'yyyy-mm-dd')
   and t1.company_id = 0
   and t1.flag_id in (3, 5, 40, 41)
   and t1.xtype_id not in(24,25)
   and t2.flag <> 2
 group by to_char(t1.flights_date, 'yyyymm') ,
       case
         when t3.channel3='境外渠道' then '线下渠道' 
          when t1.channel in('手机','网站') then '线上自营渠道'
         when t1.channel in('OTA','旗舰店') then 'OTA+旗舰店' 
         else '线下渠道' end,
         case when t3.channel3='境外渠道' then '境外渠道'
         when t1.channel ='B2G机构客户' then 'B2GTMC'
         when t1.channel ='B2B' then 'B2B'
         when t1.channel ='B2B代理' then 'B2B代理'
         when t1.channel ='呼叫中心' then '呼叫中心'
         when t1.channel in('手机','网站') then '线上自营渠道'
         when t1.channel in('OTA','旗舰店') then 'OTA+旗舰店'
         else t1.sub_channel end

union all

select to_char(t2.r_flights_date,'yyyymm') flightmonth,
'B2B',
'B2B',
sum(t1.dinner_num),
0,
sum(t1.dinner_price * t1.dinner_num) bookfee,
0,
sum(t1.dinner_price * t1.dinner_num),
0,
count(distinct t2.flights_order_head_id),
0,
count(distinct t2.flights_order_head_id)        
          from stg.s_cq_group_dinner_detail t1
          join stg.s_cq_order_head t2 on t1.order_head_id =t2.flights_order_head_id
         where t2.flag_id in (3, 5, 40, 41)
           and t2.whole_flight like '9C%'
           and t2.r_flights_date>=to_date('2016-11-01', 'yyyy-mm-dd')
           and t2.r_flights_date< to_date('2018-12-01', 'yyyy-mm-dd')
           group by to_char(t2.r_flights_date,'yyyymm')
           
union all 


select to_char(t1.flights_date, 'yyyymm') flightmonth,
       case
         when t3.channel3='境外渠道' then '线下渠道'
         when t4.users_id is not null and t1.channel in('网站','手机') then '线下渠道'                    
         when t1.channel in('手机','网站') then '线上自营渠道'
         when t1.channel in('OTA','旗舰店') then 'OTA+旗舰店' 
         else '线下渠道' end,
         case when t3.channel3='境外渠道' then '境外渠道'
         when t1.channel ='B2G机构客户' then 'B2GTMC'
         when t1.channel ='B2B' then 'B2B'
        when t4.users_id is not null and t1.channel in('网站','手机') then 'B2B代理'    
         when t1.channel ='B2B代理' then 'B2B代理'
         when t1.channel ='呼叫中心' then '呼叫中心'         
         when t1.channel in('手机','网站') then '线上自营渠道'
         when t1.channel in('OTA','旗舰店') then 'OTA+旗舰店'
         else t1.sub_channel end, 
         0,0,      
       0,
       0,
       0,
       suM(case
             when t1.seats_name is not null then
              1
             else
              0
           end) ticketnum,
           0,0,0
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id = t2.segment_head_id
  left join dw.da_restrict_userinfo t4 on t1.client_id = t4.users_id
  left join hdb.an_termianl_classify t3 on t1.sub_channel=t3.terminal
 where t1.flights_date >= to_date('2016-11-01', 'yyyy-mm-dd')
   and t1.flights_date < to_date('2018-12-01', 'yyyy-mm-dd')
   and t1.company_id = 0
   and t1.flag_id in (3, 5, 40, 41)
   and t2.flag <> 2
 group by to_char(t1.flights_date, 'yyyymm') ,
 case
         when t3.channel3='境外渠道' then '线下渠道'
         when t4.users_id is not null and t1.channel in('网站','手机') then '线下渠道'                    
         when t1.channel in('手机','网站') then '线上自营渠道'
         when t1.channel in('OTA','旗舰店') then 'OTA+旗舰店' 
         else '线下渠道' end,
         case when t3.channel3='境外渠道' then '境外渠道'
         when t1.channel ='B2G机构客户' then 'B2GTMC'
         when t1.channel ='B2B' then 'B2B'
        when t4.users_id is not null and t1.channel in('网站','手机') then 'B2B代理'    
         when t1.channel ='B2B代理' then 'B2B代理'
         when t1.channel ='呼叫中心' then '呼叫中心'         
         when t1.channel in('手机','网站') then '线上自营渠道'
         when t1.channel in('OTA','旗舰店') then 'OTA+旗舰店'
         else t1.sub_channel end)h1
         group by h1.航班月,h1.channel,h1.sub_channel；
		 
