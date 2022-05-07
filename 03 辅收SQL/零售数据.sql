select to_char(nvl(to_date(l.flight_date, 'yyyymmdd'), l.order_day),'yyyymm'),
                   nvl(t2.nationflag, '无法判断') nationflag,
               case when t2.origin_country_id>0 then t2.origin_country||'始发'
                    when t2.dest_country_id >0 then t2.dest_country||'到达'
                    else '国内' end,
               -1 seats_type,
               1 pay_together,
               case
                 when l.category = 3 then
                  '机上跨境'
                 when l.merchant_name = '上海春秋中免免税品有限公司' then
                  '机上免税品'
                 when l.type_name = '餐食' then
                  '餐食'
                 when l.type_name = '小吃' then
                  '小吃'
                 when l.type_name = '饮料' then
                  '饮料'
                 else
                 '机上其他'
               end xtype_id,
                sum(l.booknum) booknum,
               sum(l.bookfee) bookfee
          from dw.fact_prt_order_detail l
          left join dw.da_foc_order t1 on t1.flights_date =
                                          to_date(l.flight_date, 'yyyymmdd')
                                      and t1.flights_no =
                                          (case when length(l.flight_no) < 6 then
                                           '9C' || substr(l.flight_no, 1, 5) else
                                           substr(l.flight_no, 1, 7) end)
          left join dw.da_flight t2 on t1.flights_id = t2.flights_id
                                   and t1.segment_code = t2.segment_code
         where l.order_day >= to_date('2018-11-01','yyyy-mm-dd')
           and nvl(to_date(l.flight_date, 'yyyymmdd'), l.order_day) >=
               to_date('2018-11-01','yyyy-mm-dd')
           and nvl(to_date(l.flight_date, 'yyyymmdd'), l.order_day) <
               to_date('2019-09-01','yyyy-mm-dd')
           and nvl(l.flight_no, '9C') like '9C%'
           and l.status in ('200', '300', '301', '400', '500')
           group by to_char(nvl(to_date(l.flight_date, 'yyyymmdd'), l.order_day),'yyyymm'),
                   nvl(t2.nationflag, '无法判断') ,
               case when t2.origin_country_id>0 then t2.origin_country||'始发'
                    when t2.dest_country_id >0 then t2.dest_country||'到达'
                    else '国内' end,
                       case
                 when l.category = 3 then
                  '机上跨境'
                 when l.merchant_name = '上海春秋中免免税品有限公司' then
                  '机上免税品'
                 when l.type_name = '餐食' then
                  '餐食'
                 when l.type_name = '小吃' then
                  '小吃'
                 when l.type_name = '饮料' then
                  '饮料'
                 else
                 '机上其他'
               end;


			   
===================================================10月10日=========================================================


select to_char(t1.flights_date,'yyyy') years, to_char(t1.flights_date,'yyyymm') months,
      case when t1.channel in('手机','网站') and t2.users_id is not null then '代理'
            else '非代理' end ,
       case when t1.channel in('手机','网站') and t1.station_id =1  then '网站'
       when t1.channel in('手机','网站') and t1.station_id =2  then 'M网站'
       when t1.channel in('手机','网站') and t1.station_id in(3,8)  then 'IOS'
       when t1.channel in('手机','网站') and t1.station_id in(4,9)  then '安卓'
       when t1.channel in('手机','网站') and t1.station_id in(5,10)  then '微信' 
          else '其他' end,
       case
         when t1.xtype_name in ('境外险', '延误险', '取消险', '航意险') then
          '线上保险'
         when t1.xtype_id in (6, 10, 17) then
          '线上行李'       
         when t1.xtype_id = 21 and
              regexp_like(upper(t1.xproduct_name),
                          '(WIFI)|(WF)|(4G)|(上网卡)') then
          'WIFI'
         when t1.xtype_id = 21 and t1.xproduct_name like '%泊车%' then
          '泊车'
         when t1.xtype_id = 16 then
          '接送机'
         when t1.xtype_id = 14 and t1.xproduct_name = '大巴票' then
          '空铁空巴'
         when t1.xtype_id = 14 and t1.xproduct_name = '火车票' then
          '空铁空巴'
         when t1.xtype_id = 16 then
          '接送机'
          when t1.xtype_id = 7  then
          '线上餐食'
          when t1.xtype_id= 3 then '选座'
          else
          '其他'
       end sname,t1.xtype_name,       
       sum(t1.book_num) booknum,sum(t1.book_fee) bookfee,null ticketnum
  from dw.fact_other_order_detail t1
  left join dw.da_restrict_userinfo t2 on t1.client_id=t2.users_id
 where t1.flights_date >= to_date('2015-01-01', 'yyyy-mm-dd')
   and t1.flights_date < to_date('2019-10-01', 'yyyy-mm-dd')
   and t1.company_id = 0
   and t1.xtype_id not in(24,25)
   and t1.seats_name not in('B','G','G1','G2','O')
   and t1.flag_id in (3, 5, 40, 41) 
   group by to_char(t1.flights_date,'yyyy') , to_char(t1.flights_date,'yyyymm') ,
   case when t1.channel in('手机','网站') and t2.users_id is not null then '代理'
else '非代理' end ,
     case when t1.channel in('手机','网站') and t1.station_id =1  then '网站'
       when t1.channel in('手机','网站') and t1.station_id =2  then 'M网站'
       when t1.channel in('手机','网站') and t1.station_id in(3,8)  then 'IOS'
       when t1.channel in('手机','网站') and t1.station_id in(4,9)  then '安卓'
       when t1.channel in('手机','网站') and t1.station_id in(5,10)  then '微信' 
          else '其他' end,
       case
         when t1.xtype_name in ('境外险', '延误险', '取消险', '航意险') then
          '线上保险'
         when t1.xtype_id in (6, 10, 17) then
          '线上行李'       
         when t1.xtype_id = 21 and
              regexp_like(upper(t1.xproduct_name),
                          '(WIFI)|(WF)|(4G)|(上网卡)') then
          'WIFI'
         when t1.xtype_id = 21 and t1.xproduct_name like '%泊车%' then
          '泊车'
         when t1.xtype_id = 16 then
          '接送机'
         when t1.xtype_id = 14 and t1.xproduct_name = '大巴票' then
          '空铁空巴'
         when t1.xtype_id = 14 and t1.xproduct_name = '火车票' then
          '空铁空巴'
         when t1.xtype_id = 16 then
          '接送机'
          when t1.xtype_id = 7  then
          '线上餐食'
          when t1.xtype_id= 3 then '选座'
          else
          '其他'
       end,t1.xtype_name
       
       union all
       
    select to_char(t1.flights_date,'yyyy') years, to_char(t1.flights_date,'yyyymm') months,
    case when t1.channel in('手机','网站') and t2.users_id is not null then '代理'
         else '非代理' end ,
      case when t1.channel in('手机','网站') and t1.station_id =1  then '网站'
       when t1.channel in('手机','网站') and t1.station_id =2  then 'M网站'
       when t1.channel in('手机','网站') and t1.station_id in(3,8)  then 'IOS'
       when t1.channel in('手机','网站') and t1.station_id in(4,9)  then '安卓'
       when t1.channel in('手机','网站') and t1.station_id in(5,10)  then '微信' 
          else '其他' end,
       null,
       null,
       0,0,count(1)
  from dw.fact_order_detail t1
   left join dw.da_restrict_userinfo t2 on t1.client_id=t2.users_id
 where t1.flights_date >= to_date('2015-01-01', 'yyyy-mm-dd')
   and t1.flights_date < to_date('2019-10-01', 'yyyy-mm-dd')
   and t1.company_id = 0
   and t1.flag_id in (3, 5, 40, 41) 
   and t1.seats_name not in('B','G','G1','G2','O')
   group by to_char(t1.flights_date,'yyyy') , to_char(t1.flights_date,'yyyymm') ,
   case when t1.channel in('手机','网站') and t2.users_id is not null then '代理'
else '非代理' end ,
        case when t1.channel in('手机','网站') and t1.station_id =1  then '网站'
       when t1.channel in('手机','网站') and t1.station_id =2  then 'M网站'
       when t1.channel in('手机','网站') and t1.station_id in(3,8)  then 'IOS'
       when t1.channel in('手机','网站') and t1.station_id in(4,9)  then '安卓'
       when t1.channel in('手机','网站') and t1.station_id in(5,10)  then '微信' 
          else '其他' end;


		  


        