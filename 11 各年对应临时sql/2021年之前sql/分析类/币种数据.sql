select distinct t1.segment_code,t1.flights_segment_name,t1.carrier,t1.price,
        case when t1.origin_country_id=0 then '人民币'
             when t1.origin_country_id=2 and t3.MONEY_CLASS_ID=1 then '日元'
             when t1.origin_country_id=189 and t3.MONEY_CLASS_ID=101 then '泰铢'
             when t1.origin_country_id=169 and t3.MONEY_CLASS_ID=62 then '韩币'
             when t1.origin_country_id=174 and t3.MONEY_CLASS_ID=121 then '马来西亚令吉'
             when t1.origin_country_id=186 and t3.MONEY_CLASS_ID=161 then '新加坡元'
             when t1.origin_country_id=198 and t3.MONEY_CLASS_ID=61 then '港币'
             when t1.origin_country_id=200 and t3.MONEY_CLASS_ID=141 then '新台币'
             when t1.origin_country_id=199 and t3.MONEY_CLASS_ID=81 then '澳门元'
             end,
             
          case when t1.origin_country_id=0 then t1.price
             when t1.origin_country_id=2 and t3.MONEY_CLASS_ID=1 then t3.price
             when t1.origin_country_id=189 and t3.MONEY_CLASS_ID=101 then t3.price
             when t1.origin_country_id=169 and t3.MONEY_CLASS_ID=62 then t3.price
             when t1.origin_country_id=174 and t3.MONEY_CLASS_ID=121 then t3.price
             when t1.origin_country_id=186 and t3.MONEY_CLASS_ID=161 then t3.price
             when t1.origin_country_id=198 and t3.MONEY_CLASS_ID=61 then t3.price
             when t1.origin_country_id=200 and t3.MONEY_CLASS_ID=141 then t3.price
             when t1.origin_country_id=199 and t3.MONEY_CLASS_ID=81 then t3.price
             end
   from dw.da_flight t1
   --left join anl.temp_feng_0226@to_dds t2 on t1.segment_code=t2.segment_code   
   left join cqsale.cq_flights_segment_head_m@to_air t3 on t1.segment_head_id=t3.segment_head_id
   where t1.flight_date>=trunc(sysdate)
     and t1.flag<>2
     and t1.company_id=0
     
     
     select * from stg.p_cq_money_class
 
2	日本
189	泰国
156	柬埔寨
169	韩国
174	马来西亚
196	越南
186	新加坡
