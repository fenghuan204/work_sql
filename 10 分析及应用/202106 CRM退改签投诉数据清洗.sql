select complaintype1c, cp.complaintype2c,complaintype3c,min(cp.conetent),count(1)
from hdb.crm_wo_baseinfo cp
 where trunc(cp.createtime) >= to_date('2018-10-01', 'yyyy-mm-dd')
   and trunc(cp.createtime) < trunc(sysdate) 
   and cp.gcflag = 0
   and cp.jobtypecode = 'T'
   and (cp.complaintype1c like '%退%'
   or cp.complaintype2c like '%退%'
   or cp.complaintype3c like '%退%'
   or cp.complaintype1c like '%改签%'
   or cp.complaintype2c like '%改签%'
   or cp.complaintype3c like '%改签%'
   or cp.conetent like '%退%'
   or cp.conetent like '%改%')
   and not regexp_like(nvl(cp.complaintype1c,'-'),'(退款时间)|(单退)|(火车票)|(病退)|(积分)|(时刻调整)|(快递)|(用车)|(行李)
   |(值机)|(预定错误)|(行程单)|(交通)|(成功短信)|(航班动态)|(服务态度)|(回复慢)|(法院)|(误操作)|(人工广播)|(会员)|(增值)|(表扬)|(客服)|(产品服务)|(营销)|(ij)|(客舱)|(促销)|(通知)|(地面服务)|
   (行李)|(超售)|(支付)|(未收到通知)|(掉单)|(错运)|(人员违规)|(退款失败)|(OTA退款)|(更名)|(残疾人)|(促销优惠)|(法院)
   |(付款)|(登机)|(票价)|(燃油费)|(商旅通)|(经济座)|(税费调整)|(退款慢)|(活动)|(信息)|(他航)|(价格)')
   and not regexp_like(nvl(cp.complaintype2c,'-'),'(增值产品)|(网站活动)|(候机/登机服务)|(商务经济座)|(行李)|(漏运遗失)|(接送机)|(值机)|
   ( 起飞降落)|(空铁)|(绿翼会员)|(选座)|(车辆服务)|( 旅客伤病亡)|( 破损)|(产品服务)|(旅客信息)|(信息通知)|(登机)|(旅客伤病亡)|
   (会员服务)|(客舱)|(支付)|(商旅通产品)|(掉单)|(会员)|(错运)|(错拿)|(人员违规操作)|(客服)|(价格变动)|(订票信息)|( 特殊旅客)|
   (商务经济座)|(信息错误)|(更改信息)|(营销活动)|(质量缺陷)|(零售品)|(其他综合服务)|(信息)|(行程单)|(预定错误)|(起飞降落)|(航班动态)|(退款时间)')
   and not regexp_like(nvl(cp.complaintype3c,'-'),'(增值产品)|(网站活动)|(候机/登机服务)|(商务经济座产品)|(行李)|(漏运遗失)|(接送机)|(值机)|
   ( 起飞降落)|(空铁)|(绿翼会员)|(选座)|(车辆服务)|( 旅客伤病亡)|( 破损)|(产品服务)|(旅客信息)|(信息通知)|(登机)|(行程单)|(旅客伤病亡)|
   (会员服务)|(客舱)|(客服服务)')
   and not regexp_like(nvl(cp.conetent,'-'),'(火车票)|(行李)')
   group by  complaintype1c, cp.complaintype2c,complaintype3c;
   
   
   
   
   
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
         when cp.jobnextfrom in ('Android', 'IOS', 'M网', '网站', '微信', '绿翼商城') then
          '内部渠道'
         when cp.jobnextfrom in ('民航局', '民航局（网页）') then
          '民航局'
         when cp.jobnextfrom = '呼叫中心' then
          '呼叫中心'
         when cp.jobnextfrom in
              ('集团投诉科', '旅客评价', '新媒体平台-舆情', '意见卡', '智慧客舱', '内部', '内部渠道', '其它') then
          '内部渠道'
         when cp.jobnextfrom in ('内部流转(其他)事项', '内部流转(投诉)事项') then
          '内部流转'
       
         when cp.jobnextfrom = '消保委' then
          '其他外部'
         when cp.jobnextfrom = '外部' then
          '其他外部'
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
       cp.sex 性别,
       cp.age 年龄,
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
         decode(cp5.gender,'0','-',1,'男',2,'女') 性别,
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
             else '-' end 改签提前期          
  from hdb.crm_wo_baseinfo cp
  left join dw.da_flight cp1 on cp.flightdate=cp1.flight_date and cp.flightno=cp1.flight_no and cp.originairportcode||cp.destairportcode=cp1.segment_code
  left join dw.da_foc_flight cp2 on cp1.segment_head_id=cp2.segment_head_id
  left join dw.fact_recent_order_detail cp3 on cp.orderchannelchild=cp3.flights_order_head_id
  left join dw.da_restrict_userinfo cp4 on cp3.client_id=cp4.users_id
  left join dw.bi_order_region cp5 on cp.orderchannelchild=cp5.flights_order_head_id
  left join dw.da_order_drawback cp6 on cp.orderchannelchild=cp6.flights_order_head_id
  left join dw.da_order_change cp7 on cp.orderchannelchild=cp7.flights_order_head_id and cp1.segment_head_id=cp7.old_segment_id
 where trunc(cp.createtime) >= to_date('2018-10-01', 'yyyy-mm-dd')
   and trunc(cp.createtime) < trunc(sysdate) 
   and cp.gcflag = 0
   and cp.jobtypecode = 'T'
   and (cp.complaintype1c like '%退%'
   or cp.complaintype2c like '%退%'
   or cp.complaintype3c like '%退%'
   or cp.complaintype1c like '%改签%'
   or cp.complaintype2c like '%改签%'
   or cp.complaintype3c like '%改签%'
   or cp.conetent like '%退%'
   or cp.conetent like '%改%')
   and not regexp_like(nvl(cp.complaintype1c,'-'),'(退款时间)|(单退)|(火车票)|(病退)|(积分)|(时刻调整)|(快递)|(用车)|(行李)
   |(值机)|(预定错误)|(行程单)|(交通)|(成功短信)|(航班动态)|(服务态度)|(回复慢)|(法院)|(误操作)|(人工广播)|(会员)|(增值)|(表扬)|(客服)|(产品服务)|(营销)|(ij)|(客舱)|(促销)|(通知)|(地面服务)|
   (行李)|(超售)|(支付)|(未收到通知)|(掉单)|(错运)|(人员违规)|(退款失败)|(OTA退款)|(更名)|(残疾人)|(促销优惠)|(法院)
   |(付款)|(登机)|(票价)|(燃油费)|(商旅通)|(经济座)|(税费调整)|(退款慢)|(活动)|(信息)|(他航)|(价格)')
   and not regexp_like(nvl(cp.complaintype2c,'-'),'(增值产品)|(网站活动)|(候机/登机服务)|(商务经济座)|(行李)|(漏运遗失)|(接送机)|(值机)|
   ( 起飞降落)|(空铁)|(绿翼会员)|(选座)|(车辆服务)|( 旅客伤病亡)|( 破损)|(产品服务)|(旅客信息)|(信息通知)|(登机)|(旅客伤病亡)|
   (会员服务)|(客舱)|(支付)|(商旅通产品)|(掉单)|(会员)|(错运)|(错拿)|(人员违规操作)|(客服)|(价格变动)|(订票信息)|( 特殊旅客)|
   (商务经济座)|(信息错误)|(更改信息)|(营销活动)|(质量缺陷)|(零售品)|(其他综合服务)|(信息)|(行程单)|(预定错误)|(起飞降落)|(航班动态)|(退款时间)')
   and not regexp_like(nvl(cp.complaintype3c,'-'),'(增值产品)|(网站活动)|(候机/登机服务)|(商务经济座产品)|(行李)|(漏运遗失)|(接送机)|(值机)|
   ( 起飞降落)|(空铁)|(绿翼会员)|(选座)|(车辆服务)|( 旅客伤病亡)|( 破损)|(产品服务)|(旅客信息)|(信息通知)|(登机)|(行程单)|(旅客伤病亡)|
   (会员服务)|(客舱)|(客服服务)')
   and not regexp_like(nvl(cp.conetent,'-'),'(火车票)|(行李)')
   

   

