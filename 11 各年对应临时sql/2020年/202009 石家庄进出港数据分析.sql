/*
2019年石家庄国内进出港人群画像
1、石家庄进出港乘机人的画像：年龄（0~11,12~17,18~23，24~30,31~40,41~50,51~60,60+）、性别、归属地（省份、城市），出行频次分布（1~2,3~4,5~6,7~12,12+），
出行目的（商务、旅游、探亲，其他）、同行人数（单人、2人、3人、4人、4人以上）、机票购买渠道（OTA、TMC、官网APP、线下代理、线下自营渠道-呼叫中心及门店）分布，
19年乘机人中前一年乘机记录有多少比例，前一年和19年的乘机频次层级（1~2,3~4,5~6,7~12,12+）有多少比例，有多少比例是新增乘机人？
各出行频次对应人群的数量及平均票价（出行频次-1\2\3\4\5\6\7\8\9\10\11\12\12+,出行人数，购买每张机票平均票价），
购买提前期分布（0\1\2\3\4\5\6\7\8~14\15~30\30~60\60+）机票量分布，购买航线的分布（出行频次、19年仅购买过一条往返航线、购买过2条往返航线、购买超过2条往返航线、乘机人数（去重）），
航线类型分布（中转联程、往返、单程）的机票量分布
2、石家庄国内进出港航班数据：日期、航班量、座位数、客座率；航线网络数据：日期、航段、航班号、航班量
3、石家庄进出港人群中石家庄当地人群特征：与1要求的特征一致
4、石家庄进出港人群中河北省人群特征：与1要求的特征一致
*/


select replace(replace(t3.wf_segment,'浦东','上海'),'虹桥','上海') wf_segment,
       t1.gender,
       t5.cust_province,
       t5.cust_city,
       t4.part,
       case when t1.channel in('网站','手机') then '官网APP'
       when t1.channel in('OTA','旗舰店') then 'OTA'
       when t1.channel='B2G机构客户' then 'B2G'
       else '其他' end,
       case when t1.ahead_days<=14 then to_char(t1.ahead_days)
       when t1.ahead_days<=30 then '15~30'
       when t1.ahead_days<=45 then '31~45'
       when t1.ahead_days<=60 then '46~60'
       when t1.ahead_days>60 then '60+' end,
       t1.SEAT_TYPE,
       case when IS_WF=0 then '单程'
       else '往返' end,
       LY_TYPE,
       count(1)
 from dw.fact_recent_order_detail t1
 join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
 left join dw.dim_segment_type t3 on t2.h_route_id=t3.h_route_id and t2.route_id=t3.route_id
 left join dw.fact_orderhead_trippurpose@to_ods t4 on t1.flights_order_head_id=t4.flights_order_head_id
 left join dw.bi_order_region t5 on t1.flights_order_head_id=t5.flights_order_head_id
 where t1.flag_id=40
   and t1.flights_date>=to_date('2019-01-01','yyyy-mm-dd')
   and t1.flights_date< to_date('2020-07-01','yyyy-mm-dd')
   and t1.seats_name <>'O'
   and t1.nationflag='国内'
   --and t1.sex=1
   and t2.flights_segment_name like '%石家庄%'
   group by replace(replace(t3.wf_segment,'浦东','上海'),'虹桥','上海') ,
       t1.gender,
       t5.cust_province,
       t5.cust_city,
       t4.part,
       case when t1.channel in('网站','手机') then '官网APP'
       when t1.channel in('OTA','旗舰店') then 'OTA'
       when t1.channel='B2G机构客户' then 'B2G'
       else '其他' end,
       case when t1.ahead_days<=14 then to_char(t1.ahead_days)
       when t1.ahead_days<=30 then '15~30'
       when t1.ahead_days<=45 then '31~45'
       when t1.ahead_days<=60 then '46~60'
       when t1.ahead_days>60 then '60+' end,
       t1.SEAT_TYPE,
       case when IS_WF=0 then '单程'
       else '往返' end,
       LY_TYPe;
       
       
       
       select 
       t4.part,
       case when t2.originairport_name ='石家庄' then '出港'
       else '进港' end,
        case when t2.originairport_name ='石家庄' then t2.destcity_name
       else t2.origincity_name end,
       count(1)
 from dw.fact_recent_order_detail t1
 join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
 left join dw.dim_segment_type t3 on t2.h_route_id=t3.h_route_id and t2.route_id=t3.route_id
 left join dw.fact_orderhead_trippurpose@to_ods t4 on t1.flights_order_head_id=t4.flights_order_head_id
 where t1.flag_id=40
   and t1.flights_date>=to_date('2020-07-01','yyyy-mm-dd')
   and t1.flights_date< to_date('2020-09-01','yyyy-mm-dd')
   and t1.seats_name <>'O'
   and t1.nationflag='国内'
   --and t1.sex=1
   and t2.flights_segment_name like '%石家庄%'
   group by  t4.part,
       case when t2.originairport_name ='石家庄' then '出港'
       else '进港' end,
        case when t2.originairport_name ='石家庄' then t2.destcity_name
       else t2.origincity_name end;
   
  
