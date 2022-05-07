select to_char(cp.createtime, 'yyyymm') 月份,
       trunc(cp.createtime) 创建时间,
       case
         when cp.jobtypecode = 'J' then
          '建议'
         when cp.jobtypecode = 'B' then
          '表扬'
         when cp.jobtypecode = 'T' then
          '投诉'
         when cp.jobtypecode = 'P' then
          '评价'
         else
          cp.jobtypecode
       end 工单类型,
       cp.jobnextfrom 工单信息来源二级菜单,
       case
         when cp.jobnextfrom in ('工商所（机场工商、华阳）', '公商所（机场工商、华阳）', '民航局', '民航局（调解）', '民航局（华东管理局）',
                   '民航局（网页）', '其他外部（社交网络）', '上海市民热线12345', '上海市信访办', '外部',
                   '外部媒体（广播、报社、新闻）', '消保委', '新媒体平台-FACEBOOK', '新媒体平台-舆情') then
          '外部投诉'
         when cp.jobnextfrom = '呼叫中心' then
          '呼叫中心'
         when cp.jobnextfrom in
              ('Android', 'IOS', 'M网', '网站', '微信', '绿翼商城',
             '集团投诉科', '旅客评价', '新媒体平台-舆情', '意见卡', '智慧客舱', '内部', '内部渠道', '其它') then
          '内部渠道'
         when cp.jobnextfrom in ('内部流转(其他)事项', '内部流转(投诉)事项') then
          '内部流转'
       end 投诉来源分类,       
       cp.complaintype1c 投诉类别基础数据里的名称,
       case when cp.conetent like '%套票%' then '套票产品服务'
       else cp.complaintype2c end  投诉类别二级菜单名称,
       cp.complaintype3c 投诉类别三级菜单名称,
       cp.passengertype 旅客类型,
       cp.flightno 航班号,
       cp.flightdate 航班日期,
       cp.airport 起降机场,
       cp.originairportcode 起飞机场三字码,
       cp.destairportcode 降落机场三字码,
       cp.conetent 投诉内容,
       case when cp.conetent like '%套票%' then '套票产品'
       when cp.conetent like '%随心飞%' then '套票产品'
       when cp.conetent like '%疫情%' then '疫情'
       when cp.conetent like '%取消%' then '航班取消'
       when cp.conetent like '%延误%' then '航班延误'
        when cp.conetent like '%备降%' then '航班备降'
       when cp.conetent like '%退票%' then '机票退改签'
       when cp.conetent like '%改签%' then '机票退改签'       
       when cp.conetent like '%行李%' then '行李'
       when cp.complaintype1c like '%航班取消%' then '航班取消' 
       when cp.complaintype1c like '%航班延误%' then '航班延误' 
       when cp.complaintype1c like '%退改签%' then '机票退改签' 
       when cp.complaintype1c like '%行李%' then '行李'                    
       end 内容判断,
       case when cp.complaintype1c like '%疫情%' then '疫情'
   when cp.complaintype2c like '%疫情%' then '疫情'
   when cp.complaintype3c like '%疫情%' then '疫情'
   when  cp.conetent  like '%疫情%' then '疫情'
   when  cp.conetent  like '%新冠%' then '疫情'
    when  cp.conetent  like '%疫%'  then '疫情'
  when regexp_like(cp.complaintype1c,'航班取消|临时取消|临时性取消|延误') then '不正常航班'
  when regexp_like(cp.complaintype2c,'航班取消|临时取消|临时性取消|延误') then '不正常航班'
  when regexp_like(cp.complaintype3c,'航班取消|临时取消|临时性取消|延误') then '不正常航班'
  when regexp_like(cp.conetent,'航班取消|临时取消|临时性取消|延误') then '不正常航班'
  else '正常' end 类型,
  
    case when case when cp6.flights_order_head_id is not null  then cp6.money_fy
           when cp7.flights_order_head_id is not null then cp7.money_fy*cp7.rate
             end=0 then '0元'
         else '非0元' end 是否0元,      
                 
       cp.sex 性别,
       case when cp.age<=18 then '00~18'
       when cp.age<=23 then '19~23'
       when cp.age<=30 then '24~30'
       when cp.age<=40 then '31~40'
       when cp.age<=50 then '41~50'
       when cp.age<=60 then '51~60'
       when cp.age>60 then '60+' end 年龄,
       cp.orderchannel 订单渠道,
       cp.orderchannelchild 订单子渠道,
       cp.leg 航段,
       case when regexp_like(cp.cabin,'P1|P2|P3|P4|P5|R') then substr(cp.cabin,1,2)
       else substr(cp.cabin,1,1) end 舱位,
       cp.ticketprice 票价,
       cp.station 航站,
       cp.responsibilitydept,
       case when cp1.flag=2 then '航班取消'
       when (cp2.dep_time-cp1.origin_std)*24>= 0.5 
       and (cp2.dep_time-cp1.origin_std)*24<=1 then '延误0.5~1H'
       when (cp2.dep_time-cp1.origin_std)*24>= 1
       and (cp2.dep_time-cp1.origin_std)*24< 3 then '延误1~3H'
       when (cp2.dep_time-cp1.origin_std)*24>= 3 then '延误3H+' end 航班状态,
       case when cp3.channel in('网站','手机') and cp4.users_id is not null then '非授权代理'
         when cp3.channel in('网站','手机') and cp3.pay_gate in(15,29,31) then '非授权代理'
         when cp3.channel in('网站','手机') then '线上纯量'
         when cp3.channel in('OTA','旗舰店') then 'OTA'
         when cp3.flights_order_head_id is not null then 'B2B'
         else null end channel,
         decode(cp5.gender,'0','-',1,'男',2,'女') 机票性别,
          case when cp5.age<=18 then '00~18'
       when cp5.age<=23 then '19~23'
       when cp5.age<=30 then '24~30'
       when cp5.age<=40 then '31~40'
       when cp5.age<=50 then '41~50'
       when cp5.age<=60 then '51~60'
       when cp5.age>60 then '60+' end 机票年龄,
       cp5.SEATS_NAME,
       cp3.ticket_price,
       cp1.price,
         case when cp6.flights_order_head_id is not null then '退票'
              when cp7.flights_order_head_id is not null then '改签'
              else '正常' end 机票状态,
         case when cp6.money_date>=cp6.origin_std then '航班离站后'
             when (cp6.origin_std-cp6.money_date)*24>=0 and (cp6.origin_std-cp6.money_date)*24< 2  then '[0,2h)'
             when (cp6.origin_std-cp6.money_date)*24>=2 and (cp6.origin_std-cp6.money_date)*24< 24  then '[2,24h)'
             when (cp6.origin_std-cp6.money_date)>=1 and (cp6.origin_std-cp6.money_date)< 3  then '[1D,3D)' 
             when (cp6.origin_std-cp6.money_date)>=3 and (cp6.origin_std-cp6.money_date)< 7  then '[3D,7D)'
             when (cp6.origin_std-cp6.money_date)>=7  then '7D+' 
             else '-' end 退票提前期,
          case when cp7.modify_date>=cp6.origin_std then '航班离站后'
             when (cp6.origin_std-cp7.modify_date)*24>=0 and (cp6.origin_std-cp7.modify_date)*24< 2  then '[0,2h)'
             when (cp6.origin_std-cp7.modify_date)*24>=2 and (cp6.origin_std-cp7.modify_date)*24< 24  then '[2,24h)'
             when (cp6.origin_std-cp7.modify_date)>=1 and (cp6.origin_std-cp7.modify_date)< 3  then '[1D,3D)' 
             when (cp6.origin_std-cp7.modify_date)>=3 and (cp6.origin_std-cp7.modify_date)< 7  then '[3D,7D)'
             when (cp6.origin_std-cp7.modify_date)>=7  then '7D+' 
             else '-' end 改签提前期,
           case when cp6.flights_order_head_id is not null  then cp6.money_fy
           when cp7.flights_order_head_id is not null then cp7.money_fy*cp7.rate
             end 退改签手续费,
          case when cp7.modify_date>=cp6.origin_std then '航班离站后'
             when (cp6.origin_std-cp7.modify_date)*24>=0 and (cp6.origin_std-cp7.modify_date)*24< 2  then '[0,2h)'
             when (cp6.origin_std-cp7.modify_date)*24>=2 and (cp6.origin_std-cp7.modify_date)*24< 24  then '[2,24h)'
             when (cp6.origin_std-cp7.modify_date)>=1 and (cp6.origin_std-cp7.modify_date)< 3  then '[1D,3D)' 
             when (cp6.origin_std-cp7.modify_date)>=3 and (cp6.origin_std-cp7.modify_date)< 7  then '[3D,7D)'
             when (cp6.origin_std-cp7.modify_date)>=7  then '7D+' 
             else '-' end 改签提前期,
             round(case when cp6.flights_order_head_id is not null  then cp6.money_fy
           when cp7.flights_order_head_id is not null then cp7.money_fy*cp7.rate
             end/cp3.ticket_price*100,0) fee_rate                       
  from hdb.crm_wo_baseinfo cp
  left join dw.da_flight cp1 on cp.flightdate=cp1.flight_date and cp.flightno=cp1.flight_no and cp.originairportcode||cp.destairportcode=cp1.segment_code
   left join dw.fact_recent_order_detail cp3 on cp.orderchannelchild=cp3.flights_order_head_id 
   left join dw.da_foc_flight cp2 on cp1.segment_head_id=cp2.segment_head_id
   left join dw.da_restrict_userinfo cp4 on cp3.client_id=cp4.users_id
  left join dw.bi_order_region cp5 on cp.orderchannelchild=cp5.flights_order_head_id
  left join dw.da_order_drawback cp6 on cp.orderchannelchild=cp6.flights_order_head_id
  left join dw.da_order_change cp7 on cp.orderchannelchild=cp7.flights_order_head_id and cp1.segment_head_id=cp7.old_segment_id
 where trunc(cp.createtime) >= to_date('2018-01-01', 'yyyy-mm-dd')
   and trunc(cp.createtime) < trunc(sysdate) 
   and cp.gcflag = 0
   and cp.jobtypecode = 'T'
   and nvl(cp1.company_id,0)=0
   and nvl(cp6.flights_order_head_id,cp7.flights_order_head_id) is not null
   and cp3.flights_order_head_id is not null 
   and cp3.ticket_price>0
  and (cp.COMPLAINTYPE1C like '%退改%'
   or cp.COMPLAINTYPE2C like '%退改%'
   or cp.COMPLAINTYPE3C like '%退改%'
   or cp.COMPLAINTYPE1C like '%退票%'
   or cp.COMPLAINTYPE2C like '%退票%'
   or cp.COMPLAINTYPE3C like '%退票%'
    or cp.COMPLAINTYPE1C like '%改签%'
   or cp.COMPLAINTYPE2C like '%改签%'
   or cp.COMPLAINTYPE3C like '%改签%'
   or cp.COMPLAINTYPE1C like '%退款%'
   or cp.COMPLAINTYPE2C like '%退款%'
   or cp.COMPLAINTYPE3C like '%退款%'
   or cp.conetent like '%改签%'
  or cp.conetent like '%退改%'
  or cp.conetent like '%退票%'
  or cp.conetent like '%退款%)

