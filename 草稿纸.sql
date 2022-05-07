振远总，数美风控的风控策略是基于每个事件来做，
目前主要是注册、登录、下单、领券、点评、查询航班、浏览航班详情等环节，每个环节都有相关策略，数美现在针对代理的识别基本上均可以识别，
但是针对各个事件的处置方案还需要结合各个业务场景的实际情况进行调整，例如下单环节，不能直接按照数美识别到风险事件全部设置不通过，
这样会导致所有的代理下单都存在问题，我们目前的要求他们按照恶意占位的规则（取消订单比例、取消订单数量再结合数美的黑产库识别恶意占位）
调整下单环节的风险


根据地
1 上海
2 石家庄
3 沈阳
4 扬州
5 宁波
6 揭阳
7 深圳
8 广州
9 南昌
10 西安
11 兰州
12 成都
13 大连


您好
   三号楼3楼市场管理部市场分析处孟祥明 工号021349，新员工入职，因工作需要需要申请市场分析处redmine\SVN权限，
 
   市场分析处SVN权限1：https://spring-svn01.springgroup.cn/svn/春秋航空/市场管理部/工作周报/2019/市场分析处
   市场分析处SVN权限2：http://192.168.0.238/itdeptcm/2015S32401/数据管理组
   redmine 权限：申请“市场部数据提取”项目的“市场部数据提取人”的权限
  
   请帮忙操作，谢谢。


select *
 from dba_tab_comments@to_air t1
 join dba_col_comments@to_air t2 on t1.table_name=t2.table_name and t1.owner=t2.owner
 where  t1.owner='CQSALE'
 and t2.column_name like '%FLIGHTS_ORDER_ID%'
 order by 2；
 
 
 
 select  *
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  left join dw.dim_segment_type t3 on t2.h_route_id=t3.h_route_id and t2.route_id=t3.route_id  
  where t1.company_id=0
    and t1.flights_date>=to_date('2020-04-01','yyyy-mm-dd')
    and t1.flights_date< to_date('2020-05-01','yyyy-mm-dd')
	and t1.order_day>=to_date('2020-04-01','yyyy-mm-dd')
    and t1.order_day<=to_date('2020-04-01','yyyy-mm-dd') 
	and t1.seats_name not in('B','G','G1','G2','O')
    and t1.whole_segment like 'SHA%'
    and t2.flag<>2 
	
 
 
  select distinct  t1.route_id,flights_segment_name,flights_segment,
 split_part(flights_segment,'－',1) segment1,
 case when t1.p_segment1 is not null then split_part(flights_segment,'－',2)
 else null end segment2,
  case when t1.p_segment1 is not  null then split_part(flights_segment,'－',3)
 when t1.p_segment1 is   null then split_part(flights_segment,'－',2) end segment3,
t1.b_segment,t1.p_segment1 mid_segment,
 t1.e_segment
 from(
 select 
  replace(replace(replace(replace(b1.FLIGHTS_SEGMENT_NAME,
                                                                 '---',
                                                                 '－'),
                                                         '--',
                                                         '－'),
                                                 '-',
                                                 '－'),
                                         '—',
                                         '－') flights_segment,b1.*
  from stg.s_cq_flights_segment_route b1)t1
  where t1.flights_segment_name is not null
  
 

	


	
/WebReport/ReportServer/view/report?viewlet=gwy%252Fgwy_ticket.frm

http://192.168.113.48:8001/WebReport/decision#management/system/normal

http://192.168.113.48:8001/WebReport/ReportServer/login?origin=3bb1aa5f-d7a6-4ae6-bbf2-5514fde2ee9e


销售奖励：分社奖金、机场奖励（虹浦)、机场奖励（外站）、销售管理部奖励、呼叫中心服务费、X产品销售奖励、商务经济座销售奖励；										
机票佣金：B2B、OTA+CPS、呼叫中心；



/file:D:\kettle_job\kjb_windows\monthly\kjb\duomai_data.kjb /level:basic >> C:\download\log\duomai_data.log

/file:D:\kettle_job\kjb_windows\monthly\kjb\duomai_data.kjb /level:basic >> D:\job_log\kettle\duomai_data.log


/file:D:\kettle_job\kjb_windows\weekly\kjb\winterspring_data.kjb /level:basic >> D:\job_log\kettle\winterspring_data.log





select *
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id = t2.segment_head_id
 where t1.order_day >= to_date('2018-01-18', 'yyyy-mm-dd')
   and t1.order_day < to_date('2018-01-18', 'yyyy-mm-dd')
   and t1.flights_date >= to_date('2018-01-18', 'yyyy-mm-dd')
   and t1.flights_date < to_date('2018-01-18', 'yyyy-mm-dd')
   and t1.seats_name not in ('B', 'G', 'G1', 'G2', 'O')
   and t1.company_id = 0
   and t2.flag <> 2

  
select random_password('ulnasn') from dual
  
  
  
 select *
from(
select date_time,to_char(date_time,'yyyymm'),t1.run_airplane_count,t1.flight_count,
row_number()over(partition by to_char(date_time,'yyyymm') order by date_time desc ) rid
from stg.f_day_statistics t1
where t1.date_time>=to_date('2017-01-01','yyyy-mm-dd')
  and t1.date_time< to_date('2019-01-01','yyyy-mm-dd'))h1
  where h1.rid=1
  
  
  
  select case when t1.seats_name in('B','G','G1','G2','O') then 'BGO'
else '非BGO' end,
sum(t1.ticket_price+t1.ad_fy)
from dw.fact_order_detail t1
join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
where t1.flights_date>=to_date('2018-01-17','yyyy-mm-dd')
  and t1.flights_date<=to_date('2018-01-23','yyyy-mm-dd')
  and t1.company_id=0
  and t1.flag_id=40
  group by case when t1.seats_name in('B','G','G1','G2','O') then 'BGO'
else '非BGO' end


  
  
 MECE法则、
 假设驱动、
 结构化分析、
 逻辑树分析、
 关键驱动因素分析；
 解决方案呈现：金字塔写作方法
 
 
 SELECT regexp_like(o_no, '^((([+]?86)?)|((0086)?)|
 ((0)?([(]86[)])?)|(00860)?)1[0-9]{10}([+]?)$') FROM DUAL

 
 2018/03/17 12:58:17 - Mail - ERROR (version 6.1.0.1-196, build 1 from 2016-04-07 12.08.49 by buildguy) : Problem while sending message: javax.mail.MessagingException: IOException while sending message;  nested exception is:
	java.io.FileNotFoundException: C:\Users\biuser\AppData\Local\Temp\2\base.zip (系统找不到指定的文件。)
 
 
 营销云： 从官网进入www.datatist.com：帐号：datatist@datatist.com/123456

数据云：https://tracker.analyzer.datatist.cn    帐号：demo/123456



/file:D:\kettle_job\kjb_windows\daily\summer_data.kjb /level:basic >> D:\job_log\summer_data.log





select t1.order_day,t1.channel,
case when t1.channel ='手机' and t1.station_id=2 then 'M站'
when t1.channel ='手机' and t1.station_id=5 then '微信'
when t1.channel ='手机' and t1.station_id in(3,8) then 'IOS'
when t1.channel ='手机' and t1.station_id in(4,9) then 'Andriod'
when  t1.sub_channel in('淘宝','携程','同程','去哪儿') then sub_channel
else t1.channel end subchannel,
case when t1.channel in('网站','手机') and t3.users_id is not null then '代理'
when t1.channel in('网站','手机') and t4.users_id is not null then '代理'
else '非代理' end agent_type,count(1) ticketnum,sum(t1.ticket_price)
from dw.fact_order_detail t1
left join  dw.da_restrict_userinfo t3 on t1.client_id=t3.users_id
left join dw.bi_user_restrict_test t4 on t1.client_id=t4.users_id
where t1.order_day>=to_date('2018-03-01','yyyy-mm-dd')
and t1.company_id=0
and t1.seats_name not in('B','G','G1','G2','O')
group by t1.order_day,t1.channel,
case when t1.channel ='手机' and t1.station_id=2 then 'M站'
when t1.channel ='手机' and t1.station_id=5 then '微信'
when t1.channel ='手机' and t1.station_id in(3,8) then 'IOS'
when t1.channel ='手机' and t1.station_id in(4,9) then 'Andriod'
when  t1.sub_channel in('淘宝','携程','同程','去哪儿') then sub_channel
else t1.channel end subchannel,
case when t1.channel in('网站','手机') and t3.users_id is not null then '代理'
when t1.channel in('网站','手机') and t4.users_id is not null then '代理'
else '非代理' end	
 
 
 
 
 
 select hh1.order_day,hh1.week,hh1.datetype,hh1.channel,hh1.subchannel,
hh1.agent_type,hh1.nationflag,hh1.flights_segment_name,
case when hh1.ahead_days<=3 then '0~3'
when hh1.ahead_days<=7 then '4~7'
when hh1.ahead_days<=15 then '8~15'
when hh1.ahead_days<=30 then '16~30'
when hh1.ahead_days<=60 then '31~60'
when hh1.ahead_days<=90 then '61~90'  
when hh1.ahead_days> 90 then '90+' end aheadys,
case when age<12 then '<12'
            when age<18 then '12~17'
            when age<24 then '18~23'
            when age<30 then '24~29'
            when age<40 then '30~39'
            when age<50 then '40~49'
            when age<60 then '50~59'
            when age< 70 then '60~69'
            when age>=70 then '70+' end age,
            hh1.gender,
            case when hh1.nation ='中国' then '中国大陆'
            when hh1.nation in('中国澳门','中国香港','中国台湾') then '港澳台'
            else '其他' end,hh1.province,sum(ticketnum),
            sum(price),suM(adPrice)           
    

from(
select t1.order_day,to_char(t1.order_day,'day') week,
case when t1.order_day>=to_date('2018-03-05','yyyy-mm-dd')
      and t1.order_day< to_date('2018-03-12','yyyy-mm-dd') then '环比日期'
      when t1.order_day>=to_date('2018-03-12','yyyy-mm-dd')
      and t1.order_day< to_date('2018-03-19','yyyy-mm-dd') then '查询日期' end datetype,
      t1.channel,
case when t1.channel ='手机' and t1.station_id=2 then 'M站'
when t1.channel ='手机' and t1.station_id=5 then '微信'
when t1.channel ='手机' and t1.station_id in(3,8) then 'IOS'
when t1.channel ='手机' and t1.station_id in(4,9) then 'Andriod'
when  t1.sub_channel in('淘宝','携程','同程','去哪儿') then sub_channel
else t1.channel end subchannel,
case when t1.channel in('网站','手机') and t3.users_id is not null then '代理'
when t1.channel in('网站','手机') and t4.users_id is not null then '代理'
else '非代理' end agent_type,t2.nationflag,t2.flights_segment_name,
t1.ahead_days,


      case WHEN t1.codetype<>1 THEN 
            CASE WHEN t1.birthday IS NOT NULL THEN 
                              floor((trunc(t1.order_day)-t1.birthday)/365)
                              ELSE NULL END 
              else getage(t1.order_day,t1.birthday)
                              END age,
     t1.gender ,
     CASE WHEN t1.ex_cfd7='CHN' THEN '中国'
          WHEN t1.ex_cfd7 IS NULL THEN '中国'
          ELSE t6.country_name END nation,
     CASE WHEN (CASE WHEN t1.ex_cfd7 ='CHN' THEN '中国'
          WHEN t1.ex_cfd7 IS NULL THEN '中国'
          ELSE t6.country_name END)='中国' THEN 
          CASE WHEN t8.province IS NOT NULL THEN t8.province
               WHEN t8.province IS NULL AND tt1.province IS NOT NULL THEN tt1.province
               ELSE NULL END 
          ELSE NULL END province,
/*      CASE WHEN (CASE WHEN t1.ex_cfd7 ='CHN' THEN '中国'
          WHEN t1.ex_cfd7 IS NULL THEN '中国'
          ELSE t6.country_name END)='中国' THEN 
          CASE WHEN t8.province IS NOT NULL THEN t8.city
               WHEN t8.province IS NULL AND tt1.province IS NOT NULL THEN tt1.city
               ELSE NULL END 
          ELSE NULL END city,
*/count(1) ticketnum,sum(t1.ticket_price) price,sum(t1.ticket_price+t1.ad_fy) adprice
from dw.fact_order_detail t1
join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
left join  dw.da_restrict_userinfo t3 on t1.client_id=t3.users_id
left join dw.bi_user_restrict_test t4 on t1.client_id=t4.users_id
 left join dw.adt_mobile_list t8 on regexp_like(t1.r_tel, '^1[0-9]{10}$')
                              and substr(t1.r_tel, 1, 7) = t8.mobilenumber
  left join dw.adt_region_code tt1 on t1.codetype = 1
                            and tt1.regioncode=substr(t1.codeno, 1, 6)
   left join stg.s_cq_country_area t6 on t1.ex_cfd7=t6.country_code
where t1.order_day>=to_date('2018-03-05','yyyy-mm-dd')
and t1.order_day< to_date('2018-03-19','yyyy-mm-dd')
and t1.company_id=0
and t2.flag<>2
and t1.seats_name not in('B','G','G1','G2','O')
group by t1.order_day,to_char(t1.order_day,'day') ,
case when t1.order_day>=to_date('2018-03-05','yyyy-mm-dd')
      and t1.order_day< to_date('2018-03-12','yyyy-mm-dd') then '环比日期'
      when t1.order_day>=to_date('2018-03-12','yyyy-mm-dd')
      and t1.order_day< to_date('2018-03-19','yyyy-mm-dd') then '查询日期' end,
      t1.channel,
case when t1.channel ='手机' and t1.station_id=2 then 'M站'
when t1.channel ='手机' and t1.station_id=5 then '微信'
when t1.channel ='手机' and t1.station_id in(3,8) then 'IOS'
when t1.channel ='手机' and t1.station_id in(4,9) then 'Andriod'
when  t1.sub_channel in('淘宝','携程','同程','去哪儿') then sub_channel
else t1.channel end,
case when t1.channel in('网站','手机') and t3.users_id is not null then '代理'
when t1.channel in('网站','手机') and t4.users_id is not null then '代理'
else '非代理' end ,
      case WHEN t1.codetype<>1 THEN 
            CASE WHEN t1.birthday IS NOT NULL THEN 
                              floor((trunc(t1.order_day)-t1.birthday)/365)
                              ELSE NULL END 
              else getage(t1.order_day,t1.birthday)
                              END  ,
     t1.gender ,
     CASE WHEN t1.ex_cfd7='CHN' THEN '中国'
          WHEN t1.ex_cfd7 IS NULL THEN '中国'
          ELSE t6.country_name END ,
     CASE WHEN (CASE WHEN t1.ex_cfd7 ='CHN' THEN '中国'
          WHEN t1.ex_cfd7 IS NULL THEN '中国'
          ELSE t6.country_name END)='中国' THEN 
          CASE WHEN t8.province IS NOT NULL THEN t8.province
               WHEN t8.province IS NULL AND tt1.province IS NOT NULL THEN tt1.province
               ELSE NULL END 
          ELSE NULL END ,
   /*   CASE WHEN (CASE WHEN t1.ex_cfd7 ='CHN' THEN '中国'
          WHEN t1.ex_cfd7 IS NULL THEN '中国'
          ELSE t6.country_name END)='中国' THEN 
          CASE WHEN t8.province IS NOT NULL THEN t8.city
               WHEN t8.province IS NULL AND tt1.province IS NOT NULL THEN tt1.city
               ELSE NULL END 
          ELSE NULL END,*/t2.nationflag,t2.flights_segment_name,
t1.ahead_days)hh1
group by hh1.order_day,hh1.week,hh1.datetype,hh1.channel,hh1.subchannel,
hh1.agent_type,hh1.nationflag,hh1.flights_segment_name,
case when hh1.ahead_days<=3 then '0~3'
when hh1.ahead_days<=7 then '4~7'
when hh1.ahead_days<=15 then '8~15'
when hh1.ahead_days<=30 then '16~30'
when hh1.ahead_days<=60 then '31~60'
when hh1.ahead_days<=90 then '61~90'  
when hh1.ahead_days> 90 then '90+' end ,
case when age<12 then '<12'
            when age<18 then '12~17'
            when age<24 then '18~23'
            when age<30 then '24~29'
            when age<40 then '30~39'
            when age<50 then '40~49'
            when age<60 then '50~59'
            when age< 70 then '60~69'
            when age>=70 then '70+' end ,
            hh1.gender,
            case when hh1.nation ='中国' then '中国大陆'
            when hh1.nation in('中国澳门','中国香港','中国台湾') then '港澳台'
            else '其他' end,hh1.province
					

select t.client_id,t.work_tel,t.order_linkman,t.email,t1.name,t1.whole_flight,t1.whole_segment,t1.r_tel,t1.flag_id
from stg.s_cq_order t
join stg.s_cq_order_Head t1 on t.flights_order_id=t1.flights_order_id
where t.client_id=3611207;

select * from dw.da_b2c_user t1
where t1.login_id='13916681001'



总结&建议：
1、新乘客的比例占到所有乘客的55%以上，针对这些新乘客后期如何维护如何转化成我们的忠诚乘客，建议区分新老乘机人针对性做营销活动以及短信营销，推出不同积分政策，提升1次到2次，2次到多次的转化；
2、自有渠道老乘客的占比下降比较明显，从40%多降到30%多，50%以上的老乘客二次购票到了OTA，这部分乘客对于我司是有忠诚度，但对渠道没有忠诚度。针对这批老乘客，简化绿翼会员注册流程，大力宣传积分政策以及官网最优，形成渠道忠诚度，例如分不同群体提醒积分的兑换以及使用；
3、各渠道各个根据直客转化有不同的特性，BG舱的乘客直客转化最低，建议这部分用户利用春秋旅游资源进行转化；OTA渠道直客转化目前只有14.57%，其中携程仅有10%，淘宝12%较低，去哪儿24.72%转化最高，各个OTA渠道可以采取不同的政策进行转化；各个根据地中扬泰根据地直客转化比例最高，上海根据地转化比例最差。前面均体现了不同乘客群体直客转化的不同，建议对不同航线不同渠道不同价格倾向不同年龄、性别、归属地制定不同的转化策略，例如有小孩的人群推送一家乘机小孩免单，对扬泰等直客转化率较高的根据地针对不同的群体预测下次出行的可能性推送下次出行优惠券、针对OTA渠道中对价格敏感预订提前期长的旅客宣传积分政策适当推送优惠券以及定制活动等等。建立完善的用户、乘机人、航线、渠道的对应标签体系，充分利用历史数据，针对不同的人群不同的场景制定不同的活动或者优惠券或者积分奖励政策。

通过用户访问特征、访问轨迹、生成订单特征等方式识别恶意代理进行访问限制以及购票限制，前端使用极验验证、短信验证防止恶意攻击，设置黑白名单对于特定用户进行标记。
--采取前端行为识别+后台算法识别+人工校验的综合方法遏制“爬虫" 恶意占座。后续会和阿里云的反作弊应用进行结合，加强对于”爬虫“的管理。

D:\ProgramData\Anaconda3
D:\ProgramData\Anaconda3;D:\ProgramData\Anaconda3\Scripts;D:\ProgramData\Anaconda3\Library\bin;
"C:\Program Files\data-integration\Kitchen.bat"
/file:C:\download\kjb\psg_retransform\fact_psg_retransform_update.kjb /level:basic >> C:\download\log\fact_psg_retransform_update.log



15.2017年企业通过电子商务（B2B、B2C）取得的营业收入占营业收入总额的比例是%。 【填空题】 
16.2017年新产品（新服务）或采用新工艺带来的销售收入占当年主营业务收入的比重为%。 【填空题】

1、总营收--B2C:77.43%,B2B:22.57%；2、微信小程序及新增辅收产品营收占比：3.37%
这个应该不在目前的辅收推荐二期的里面，现在做的是基于用户点击以及购买的数据进行推荐的


D:\ProgramFiles\data-integration\Kitchen.bat

/file:D:\kettle_job\kjb_windows\temp\callcenter_data.kjb /level:basic >> D:\job_log\kettle\callcenter_data.log

/file:C:\download\ktr\CMS数据\cms_tbl_dayday_record.kjb /level:basic >> C:\download\log\cms_tbl_dayday_record.log
1、客座率（客座率低于85%，价格限价往下走）  
2、平均价格
3、舱位分布、价格离散度
4、包销比例
5、运力变化（携程数据） --参考


价格、客座率关系
价格、离散度合理范围



监控：
1、日常销售异常监控；
2、困难航线销售监控；
3、未来航班客座率预估；



精准营销项目意义:

① 利用大数据技术以及机器学习算法精准自动化筛选推送人群，降低运营短信、EDM成本，提升订单转化率；
② 系统对接APP个推、外部DSP平台，进行精准APP推送，数字营销再营销、人群扩散，提升用户复购，增加用户量；
③ 打通用户行为数据和销售数据，以及CRM数据，实现营销一体化，实时跟踪运营及营销效果，效果报表实时呈现，提升运营人员的工作效率。


================================201809======================================


select * from tbl_pid_order
where pid='00014A7147713DB5E164CE25C6A1E683'


select * from lab_pid
where pid='00014A7147713DB5E164CE25C6A1E683'


移动号段：150 151 152 157 158 159 134 135 136 137 138 139 182 183 184 187 188 178 147 148 198 


D:/FineReport_9.0/WebReport/WEB-INF/

com.fr.third.org.hsqldb.jdbcDriver


emb:jdbc:hsqldb:file:D:/FineReport_9.0/WebReport/WEB-INF/logdb/db



create index p_cq_cp_pay_all_f1 on p_cq_cp_pay_all(TRUNC(create_date)) compress 1 tablespace stg_idx_ts;
create index f_balance_order_f1 on f_balance_order(TRUNC(ENTERDATE)) compress 1 tablespace stg_idx_ts;



t2.oversale-t2.bgo_plan-sum(case when t1.seats_name not in ('B', 'G', 'G1', 'G2', 'O')
                   and t1.nationflag = '国内' and t1.sex in(2,3) then 1 else 0 end)-
sum(case when t1.seats_name not in ('B', 'G', 'G1', 'G2', 'O')
                   and t1.nationflag = '国内' and t1.sex not in(2,3) and t1.is_swj>=1 then 1 else 0 end) oversale,
				   
				   
				   
				  t1.sex = 1
                   and t1.is_swj = 0
                   and t1.seats_name not in ('B', 'G', 'G1', 'G2', 'O')
                   and t1.nationflag = '国内' and 


				   
				   stg.s_cq_order_head  and d1.r_flights_date>=to_date('2018-01-01', 'yyyy-mm-dd') - 7
				   
				 
离群值（数据分析要检查数据质量）
缺失值
异常值

1、对比分析
2、结构分析：功能&结构
3、因素分析：哪些方面影响到
4、预警分析：目标和实际做的比较，目前低于多少需要预警，CPI（消费价格指数）、GDP增长
5、5W2H：who，what，where、why，when，how，how much
6、分析目的、分析思路和方法（认可思路和方法一致）、准备数据（数据有无）、处理数据、了解相关的业务知识、理解指标
7、RFM（excel低效的分析工具、tableau工具、spss工具）
8、候选资源的有效排序（有效排序：立足于匹配度的角度出发，其本质目的还是效果转化）
     推荐系统：更多的场景是用户流量是固定的，里头丢什么资源是相对开放的，即他对于具体曝光哪个资源的诉求较低，更多是站在用户的角度上，给用户匹配更合适的内容
	 广告：自己投放的广告是有一定程度上的曝光/转化相关的诉求存在的，即大体上资源是现实存在，且需要给他匹配流量。广告更多是站在广告主的角度，去给他匹配流量
	 推荐系统：推荐系统更多是站在用户的层面上去给他推荐/匹配资源。两者站的角度不同，所有体现的方式也不同
	 不同：资源本身，广告体现创意体现。推荐系统主要是资源的选择及排序上面。另外，还有一个重要的差异，广告是竞价的。
	 
广告主的诉求，流量计算匹配优化，转化预估的计算，一些资源流量竞价的逻辑
	 
			

1、数据架构：针对业务分析模型，调整底层数据仓库的数据架构，使之能被上层应用快速查询，进行报表开发，
2、负责市场部门BI平台应用中的数据报表、数据产品的需求分析、业务模型的设计和交互可视化实现
1、战略/预算规划：基于对历史数据分析，预测未来的发展态势，制定市场部门的核心指标和预算，拆解核心指标，并通过结果、过程、举措三层指标体系建立数据监控模型按月复盘达成进度；
总体负责市场运营数据仓库运维、数据分析体系搭建、数据报表开发、数据分析以及数据应用落地，从数据仓库搭建及运维，运营指标体系搭建，市场数据分析，数据可视化报表设计开发再到数据平台产品设计等。
职责业绩：
1、数据仓库搭建：从0到1搭建整个运营数据仓库，并基于运营数据分析体系进行后台数据架构的实现；
2、Finereport报表平台搭建：从0到1搭建整个运营报表平台的框架，截止目前整个团队已开发400+张报表，支持整个市场部门的业务数据需求；
3、业务监控体系搭建：通过日报、周报、月报以及常规业务报表（finereport实现）设定指标体系，构建分析框架，制作业务看板，通过数据指标全面了解业务进展，甄别业务问题，拆解波动因素，提示业务风险；
4、项目管理：主导开发了公司电商自采集系统，通过埋点方式采集APP、网站、微信等终端的用户行为数据，用于自建分析平台；主导推进电商APP、网站的推荐系统搭建；主导搭建春秋自己的用户标签库、建立用户画像，用于CRM、CDP精准营销；参与公司辅收产品ToC、ToB端精准营销项目，推进辅收产品精准营销落地；主导并推进公司精准营销平台搭建上线，并实现用户分群、会员营销自动化、用户生命周期等一系列功能设计；
4、团队管理：数据团队从2个人发展到10个人，从在运营部门下面发展成市场部的一个独立处室（总监级别），业务涉及航空核心收益部门的指标监控体系的搭建、产品设计及开发数据挖掘、收益管理相关数据分析、会员数据运营体系的完善。本人及团队先后获得公司先进个人、公司先进班组。



1、主要负责数据仓库搭建、运维以及业务数据建模；
2、负责市场业务数据分析；
3、负责黑代理的识别及封杀

总体负责市场运营数据仓库运维、数据分析体系搭建、数据报表开发、数据分析以及数据应用落地，从数据仓库搭建及运维，运营指标体系搭建，市场数据分析，数据可视化报表设计开发再到数据平台产品设计等。
职责业绩：
1、数据仓库搭建：从0到1搭建整个运营数据仓库，并基于运营数据分析体系进行后台数据架构的实现；
2、Finereport报表平台搭建：从0到1搭建整个运营报表平台的框架，截止目前整个团队已开发400+张报表，支持整个市场部门的业务数据需求；
3、业务监控体系搭建：通过日报、周报、月报以及常规业务报表（finereport实现）设定指标体系，构建分析框架，制作业务看板，通过数据指标全面了解业务进展，甄别业务问题，拆解波动因素，提示业务风险；
4、项目管理：主导开发了公司电商自采集系统，通过埋点方式采集APP、网站、微信等终端的用户行为数据，用于自建分析平台；主导推进电商APP、网站的推荐系统搭建；主导搭建春秋自己的用户标签库、建立用户画像，用于CRM、CDP精准营销；参与公司辅收产品ToC、ToB端精准营销项目，推进辅收产品精准营销落地；主导并推进公司精准营销平台搭建上线，并实现用户分群、会员营销自动化、用户生命周期等一系列功能设计；
4、团队管理：数据团队从2个人发展到10个人，从在运营部门下面发展成市场部的一个独立处室（总监级别），业务涉及航空核心收益部门的指标监控体系的搭建、产品设计及开发数据挖掘、收益管理相关数据分析、会员数据运营体系的完善。本人及团队先后获得公司先进个人、公司先进班组。


喜茶瞄准的是高度悦己的年轻人群，他们只会为认同与舒服买单
产品品牌化
企业数字化：打通线上、线下门店供应链、员工的即时沟通
喜茶Go小程序的背后是一个巨大的数字化平台，其中打通了门店收银、供应链、员工即时沟通、运营等系统。通过这个系统，顾客自动成为会员，从线下走到线上

会员体系1.0：主要是通过会员体系，与客户建立一种信任关系，消费场景的共同点：强刚需、消费频次高、复购率高且都必须在线下完成交易；
会员体系2.0：代表着企业与用户从简单的交易与服务的关系，向一种社群化的身份感与场景服务的关系升级，通过衍生的服务和产品来二次开发用户的价值
（用户需求、行业特点、商业模式）
S：行业结构
C：企业行为
P：经营绩效：经营利润、成本、市场份额等

低信任门槛（会员费的价格锚点）
保持高度黏性（娱乐性、传播性）
抢占用户心智（品牌的核心差异化）
建立价值闭环（用户全周期的价值管理）

数字化精准运营是提升客户满意度以及忠诚度最重要的战略之一。企业需要洞悉目标用户的心理，在与用户接触的每一个触点深入了解需求，才能设计出有效的数字化用户体系

新计算引擎操作文档-https://help.fanruan.com/finereport/doc-view-3550.html
抽数缓存插件-https://help.fanruan.com/finereport/doc-view-3638.html



1、A/B Test、弹窗待上线，裂变OK 
2、李呈奇：活动分析--机票量偏高（问题） ，正则匹配、人群去重
3、多维标签--解决方案（评估）
4、相关文档
5、标签之间的计算：生日
 
 反正都是明后年要走的，也没有什么
 实事求是
 以问题为导向，不行就是不行
 牺牲效率，坚持自己的想法，反正明年要重新找工作，今年利用好每个时间好好学习，实践自己想要的东西，提高提高再提高

一个产品好就是好，不好就是不好，有什么好说的，我们是业务部门，我们是使用部门，对于产品的使用有一些想法

也许我如果离职了，研究院是最高兴的吧，可以将市场数据这块收回去，没有人挡他们的路，动他们的蛋糕

以解决问题为前提，使用各种工具、方法，达到相关的目的

代理费的相关让直接找晓溢总问下，他们制定的逻辑，现在我是按照晓溢总他们报的回测的


代理费的相关让直接找晓溢总问下，他们制定的逻辑，现在我是按照晓溢总他们报的回测的

 01月31日

航班日期 航段 航班号  套票兑换量 额度 1兑换量 额度 2  销量进度(散客客座率)


真是不考虑我们这些在一线做事情的人，就想着他们自己的系统开发，自研，我们这边主要以实用为主，谁能帮助我们解决问题，我们就用谁。支持公司自研没有问题，
我们也会对接竹蜻蜓，但也不能让我们等个1、2年等你们系统开发成熟了，这1-2年还让我们给你们做免费的产品经理，我们这些人这1~2年还是每天拿着老旧的工具在干活

郑总，经过研究院演示他们的功能以及自己使用相关功能：目前研究院的竹蜻蜓自助分析功能主要还是一个自助提取数据的工具，对接底层数据库，通过元数据管理获取底层数据。
如果是简单获取一些底层数据库表里面的数据没有问题，涉及复杂数据查询，需要再底层建立数据集；可视化报表的支持这块，仅能简单的做一些图表，复杂图表多维图表、地图、仪表盘等很多图表无法支持，查询性能全部集中在数据库的性能上面；
数据分析这块无法完成我们想要的数据分析师探索式分析的要求，简单提数没有问题，在里面无法做分析。好处是元数据管理，数据集中管理，公司自研，单点登录，便于管理。


工作上的问题：
1、业务部门的新增上线的活动、新产品、老产品的调整，市场变化对于产品的影响
2、外部形势对于我们的影响
3、内部政策、活动、产品的变化带来的变化



1、市场部在过去一年，数据分析和应用起色不小，但在核心问题上：如何助力线上渠道的提升？辅收产品新增长点，突破效果不明显，2021年有何打算？
线上渠道提升从2个方面：1、APP订票流程优化上面，应用GIO以及自采集的相关数据，与运营部门打造个性化的APP；
2、老用户运营会方面，借助精准营销平台，利用算法模型，精准短信触达，特别针对OTA会员方面；拉新方面，对接外部投放数据，通过数据分析优化数字营销投放策略；
辅收方面，今年辅收产品这块已在积极创新，行李年卡、积分选座、一人多座、组合产品2.0 等，21年在做好辅收相关数据支持的情况，例如辅收精准营销，做好产品的用户调研，产品的竞品分析，
从数据分析师的角度，提出自己对于产品的创新建议
2、作为市场分析处的带头人，在提高整个市场部人员的数据分析与应用能力上，你什么好的建议。
1） 打造一个好的自助分析工具，将数据获取的能力赋予业务部门，并对业务人员进行分析能力培训，养成看数据、分析数据的能力；
2） 项目制是一个很好锻炼团队的机制，以项目制为主，包括产品、运营、营销、数据为项目成员的项目，高效协同，大家互相学习，将数据能力输出给项目组每个人；



又想逻辑自洽，制定的规划不合理还让人提出来，硬性的摊派下来，这样有什么意思

每个人都有每个人的活法，每个人都哟每个人的无奈，想让自己过得好，就得自己去打拼，没有人帮你去做事情
对于每个人而言，自己做的很多事情，不管是想做还是不想做，面对生活都要走下去，时间是一剂良药，时间又是一把杀猪刀，我们已经在案板上，怎样才能在有限的余生中创造自己的火花
有理想有抱负
我的理想我的抱负在哪?上研究生，我在做什么，上大学我又在做什么，只知道自怨自艾，一遍自怨自艾说自己蹉跎人生，一遍自己还是过着蹉跎人生的生活，生活也会想你想象的那样一直进行下去，如果不改变的话
每个人每一天都站在十字路口，每一天都面临选择，自己赋予自己历史使命



工作流、数据流、BI管理

1、线上自有渠道占比 （ 我们自己识别代理、易宝商旅卡）---线上自有、识别代理、OTA，线下  ---线上自有、易宝商旅卡、OTA、线下   （套票区分出来） 票量、占比  
2、线上人均辅收（不含税）
3、订单转化率 （总订单量/总UV） 总、网站、APP、微信、M网站
4、值机客座率 
5、新增绿翼会员
6、会员年复购率
7、线上自有渠道MAU——新维度
8、高频客占比（过去一年乘坐3次及以上）——新维度
9、搜索支付转化率（搜索-预订-下单-支付）——新维度   
10、数字营销收入
11、数字营销ROI
12、数字营销曝光价值指数
13、数字营销UV——新维度

201811~202011
指标测算：指标分解，按照分解过后每个销项
财务的逻辑：座公里=小时里程*小时*平均座位数，主要是小时里程，每个座位小时里程=2020实际座公里/平均座位数/小时，逻辑上没有问题，主要差异在每个座位每个小时的里程上面

1、负责销售系统数据管理，对于线上电商平台的产品、用户数据进行跟踪、分析和运营，提出改进方案；负责提供数据分析平台，辅助春秋航空做经营决策；负责提供分析咨询服务，包括产品设计方面定价、投放、营销策略、运营策略等
2、运营数据分析平台使用服务费包括数据采集、报表开发、数据应用等：200W/年；数据及分析咨询服务费：50W/年；

打造专业分析团队，主动走出去赋能业务：
近期也发现了一些问题：主动走出去的意识比较薄弱，分析报告的产出很少，感觉一直在做数据提取，我们是分析部门，名字叫市场分析处，没有分析产出，我们到底在做什么，也请大家思考，不是将数据给到业务部门就可以了。
我首先自我检讨，最近临近年底，有很多指标考核、总结、年度计划类的事情处理，再加上有一个员工离职，导致对于部门的管理有松懈，向大家道歉。下面是我这段时间一直在思考的事情，也请大家提供建议：
1、打破每个人绝对的分工界限，不在区分辅收、主营、线上渠道，，但有总体把控，李诚、李悦是我们部门的主管，主营、辅收相关的分析、数据，涉及到主营、辅收相关数据先由他们把关，渠道及营销这边我这边把关，
如果他们不通过的话直接打回去重做，到我这边的话主要检查是否存在数据安全、权限问题。但是任务上面的分配不会再做必须的要求，比如艳艳必须分析线上渠道、祥明这边必须负责GIO，彭凯斯负责零售，
这种界限已经没有了，可以交叉，不会其他模块的东西就学，给自己大家成长空间，但部门也要优胜劣汰。
2、部门主要分成两个大模块，也不是行政划分，是一个业务模块划分，一个是数据模块，主要范围是数据仓库管理、数据仓库建模、数据清洗、数据处理、数据ETL、数据报表开发；
一个是分析模块，主要是各个业务模块的业务分析，一个是数据应用模块，主要是研究数据落地，利用机器学习或者统计分析的方法构建数据应用场景。 这些模块如何串起来，
主要以项目制的形式串起来。
人员安排上--数据模块主要成员：以顾文怡为主，李艳艳、孟祥明、张凯勇；
分析模块---李诚、李悦、李艳艳、孟祥明、彭凯斯；
数据应用模块--算法主要以张凯勇为主，涉及到机器学习算法都要经过凯勇这边，数据应用模块主要以项目制为主，算法是中间一环，以生产数据应用项目为主。
3.、工作安排：自己决定自己的绩效，分成常规任务、课题任务、临时任务。
 其中常规任务：日周月报，业务数据监控，这块也要进行交叉执行（每隔一个月轮换一次）；
 课题任务：业务部门关注需要分析、自己认为对于业务部门有提高的也与业务部门沟通过，可以作为课题的任务；重要项目分析；要求：每个人每周自己确定一个课题，分析要有深度，要能给到业务部门建议；
 也可以做竞品分析、行业分析、标杆分析；也可以参与业务部门的项目中去。
 临时任务：公司领导部署下来的任务，临时汇报性的数据分析等等
 4、绩效方面：部门严格执行优胜劣汰，除了客观方面的绩效指标，主观工作完成情况按照常规任务（50%）、课题任务（50%）、临时任务（20%）完成数量及质量来确定，数量占50%，质量占50%，
 质量方面由业务部门领导、分析处的处室经理、相关把控这个方面的人三方进行打分。如果到月底只是做了一些常规任务，那么工作完成情况这一项，就只有50%；如果课题任务完成的较好，工作完成项100%，
 可以在KPA上面有体现。鼓励大家走出去，多次了解业务诉求，他们想要做什么，他们有什么问题需要我们协助解决。
 5、关于培训及参与业务部门的会议：每周三轮流有相关人的进行业务技能分享，后续这种方式成熟推广到整个市场管理部；
 业务部门的周例会：主营的例会请李诚周二晚上参加，每周六日轮流到公司来开线上渠道、辅收产品的例会，我这边每周六会来，所以剩下的人轮流来参与线上渠道或者辅收产品的例会（如果业务部门认可支持zoom参会也可zoom参会）
 ，从下周开始，不讲条件，不讲理由，业务部门都在总结得失，都在提升， 我们是分析部门不了解业务怎么赋能业务。因为是轮流参会，有些同事以前不负责这个模块，
 所以业务部门提出的问题不会回答的请带回来。并且每个人参会请记好会议纪要，特别是重要的一些事项，业务部门的业务规划等，每周一下班前发到市场分析处群里面。、
 并且基于参会的情况提交相应的下周的分析课题，不管是不是以前负责线上渠道或者辅收模块。
 6、请每个人每个月做月度总结的时候，写明自己下月的OKR，不懂OKR的可以百度，这种方法我们可以试行下。
大家到公司来工作，开始目标肯定不是混日子，奔着自己和公司一起提升的方面来的，我们还是要有目标的。如果要混日子，请不要到我们部门来，也不要到市场管理部来，这个地方混日子是混不下去的。
 
 
 站在上帝视角来做事情
 自我、唯我之间的相互切换
 今天到底要做什么，紧急矩阵是什么样子，我要怎么做，我要做哪些事情，我感觉自己在无所事事，没有成就感，动力不足
 
 
 数据分析师 （电商方向）
1.搭建数据分析模型，提高数据利用率及操作简便性，为日常运营活动提供数据支持，能够基于数据分析得到有价值的信息，为业务发展提供策略和建议；
2.负责对平台用户、交易、商品等维度数据监控跟踪与分析，建立数据汇报模板，规范运营日报周报月报；
3.负责对平台各类活动进行流量数据预测及活动复盘数据分析，定期提供运营分析报告，给到各部门及管理层分析结论和专业建议；
4.负责对平台各供应商、销售商销售数据进行分析，研究提升各商家GMV方案和影响因子；建立并通过数据分析及活动评估机制，优化活动方案；
5.配合产品、运营的需求，对用户行为数据进行数据挖掘、深度分析以及形成分析报告；
6.负责对用户进行漏斗分析，完成用户分层，利用数据提出营销建议；建立异常监控指标体系，优化数据监管机制；
任职要求：
1. 本科及以上学历，2年以上数据分析经验，丰富的电商行业数据分析、数据产品经验；
2. 具有较强的商业、数据和业务的敏感性，具备良好的逻辑分析能力，能够系统性的思考和分析问题，同时具有较好的分析总结能力
和数据报告呈现能力；
3. 熟悉电商相关的数据产品，熟悉主流电商平台相关规则，精通电商相关指标及提升方法，具快速反应和领悟新信息的能力；
4. 熟练掌握Excel、SQL及至少一种分析软件（SPSS、SAS、R、python等）；
5. 善于沟通，工作细心，执行能力强，具有良好的团队协作能力、语言表达能力;
6. 有数据基础架构、数据分析、数据治理、算法模型、数据应用等经验优先；


短信：GDS、CRM营销（月、日）

常规任务不固定时间，按照常规正常的时间进行，不限定时间


ota同价会员复购\金银卡升级加速\生命周期管理（和CRM的人对接确认之类）\每日发送的绿翼会员发送短信维护（脚本坏了修修，或者提需求新加什么维度之类，后面生命周期管理项目会替换掉）

成立项目组，以项目的形式来推动部门内部的工作进程，稳扎稳打，一步一步往前走
成立相应的项目组，建立先进的项目推动能力，针对现有的资源进行整合，更进一步开拓市场，减少相应的投入产出，对于国际国内进行连环开放及运营，人数总结30000，能够系统维护系统的稳定性，
会员复购、会员留存，公司聚会，吱声发展发到， 
1、工作安排：针对自身项目，进行优化调整，对于他人项目横挑眉毛竖挑眼，实时求是，数据治理，算法模型，数据应用，经验主义，数据分析，数据建模，数据仓库，算法精简，建立并维护通道，影响影子，
管理层分析结论，建立并通过数据，负责对用户进行罗东分析，完成用户分层、分群，利用数据剔除莹莹OA建立健全了，深入分析 及形成报表，负责对用户记性漏斗分析，完具哟较抢 商业，数据和业务的敏感性，具备良好的逻辑分析
能力，能够系统性的思考

·1、5W2H       Why，who，where、whic、What ;hower\hojum,dafd dfjskjkjl  数据有限，空间有限，乐器OK，了解整体变化，实时变换整个部门的安全管，实现=，
2、RFM :最近一次下单
3、线上渠道：花钱以及省钱相对的去呗，我要拿到相应的排名针对排旬做衣蛾有意义的的视频，是什么让你梵尼基答复，你这个基金凤姐 ，打飞机阿大幅度 
，GIO打的费自己将诶 ，I
4、指标解码真是不知道要做什么，对于部门的工作安排已经这样了，我们能做什么，又能做什么，没有工具，只能根据现有的资源进行优化

针对主营、辅收、会员、线上渠道这几块的具体思考？？
每天的形势，针对现有的措施以及逻辑，针对目前群体进行分解，优化，部门工作的优缺点，我自己的有确定，我不行，没有那个人一定比



有理有据：小的我们自己搞定，大的是不是房东搞定，已经影响我们正常生活了

付出什么就得到什么，
我付出了溢价，就要享受溢价的权益，怕麻烦，麻烦就会来找你
老实人总是被欺负

老时，前段时间王蕾这边还了我3万，你和王蕾的事情我也大概知道了一些，真是想说下你啊，哎，王蕾这边真不容易，你们的家事我这边也不好说什么。
也不知道你现在怎么样，打你电话也不接，微信也不回，是不是后面连我们这些朋友也不联系了



1\涉及到敏感数据不能导给别人
2\自己的工作职责（职业操守）
3\数据信息安全：权限开放问题

3\对数据库数据的管理，不是业务部门提取数据的机器（请说明数据用途）

职业操守：1、对敏感数据的保护；2、对提取数据用途的知晓；
         3、对数据提取自己的判断（不能盲目的提取数据）
         4、对数据库的维护
         5、数据的及时性
         6、对数据有自己的判断（不要做提线木偶）

思考、思考、思考


1、每周任务：

每周一：空铁联运数据（张杰62684508），--已在103job中、微信微博数据(已到期)

每周二：收益监控（朱文婷、路洁);调舱监控（朱文婷）---已做成job放到103


2、每月任务：
每月2号的郑总考核、直客占比----郑总考核数据已经做成job放到103中   ---朱亮

每月月初 运营月报  截止到2015年12月   接收人周嘉韵  杨冕 王浩宇 （每月4号）

每月4号的胡廷宝考核数据 （每月4号）

每月左晨绿翼积分舱位数据  --每月月初(每月4号) 


每月的第一周执行：7天乘机2次以上数据

每月值机数据--发给李葛夫 (每月7号)



--新增月度数据

1、王煜总的每月数据---每月月初数据


2、微博微信数据   ---薛欢欢  截止时间为2015年12月  kill


3\
临时更新_数据提取 #42342
新媒体2015年1月交易人次及机票数（常态数据，每月提取）

截止时间为2015年6月   --kill


4\ 临时更新_数据提取 55878

每月选座数据


4、每月日分数据

日分每月月初需要向局方提供上月承运人数的信息，请帮忙日分提取所要的数据

航班日期范围：航班月
订单状态：已售票、已出票、已乘机 
数据格式如下： 
航班号 航班日期 订单号 订单日期 订单时间 销售终端 类型（成/儿/婴） 订单状态 票价 燃油 性别 年龄
该数据为每月固定时间段需要，望能定制成每月一号上午七点提取，并邮件自动发送至指定邮箱。
邮箱：
a-nagai@jp.springairlines.com
xuzhihan@jp.springairlines.com
数据提取截止时间为2015年6月。






每月7号：

经信委数据---已做成job放到本地

绿翼会员
bi_integerRevenueEstimates  (函数运行）（输入时间问一下  null） 查询6个月 统计月


每月10号运行：
pkg.bi_assess_data(输入日期）  '2013','12'  (收益考核）
pkg.bi_assess （输入日期）

pkg.bi_baseprofit_date(输入日期）     （基地收益）
pkg.bi_baseprofit (输入日期）z

pkg.bi_selfcheckin (输入日期）     （自助值机考核)

pkg.bi_hkbaseprofit(输入日期）   (香港基地收益考核）

pkg.economyseat_saleanalyse(输入null,null）  （商务经济座销售分析）

pkg.bi_b2cagentsell (输入null,null）（ b2c代理销售分析）


3、邮件发送监控 （一周的邮件监控文件放到一起）

发送邮件的地址变更可能导致程序运行出现问题（邮件当事人离职）


注意：每月定时发送的邮件需要注意
bi_member		        每月4日11：25	





4\定期对数据库进行同步（cq_financial_qr cq_flights_cost  cq_order cq_order_head  cq_other_order cq_other_order_head）



3\郑要求：
1、把在OA邮件里的文件附件都删除掉（关于此敏感信息的）
2、以后涉及到旅客信息数据提取的由郑总审批




https://192.168.0.200    帐号hadoop  密码hadoop@Admin2014



数据模型  数据展示工具





------------------------------------------------------------
Sequel
 data manipulation language  DML 数据操作语言 用于检索或修改数据
 data control language       DCL 数据控制语言 用于定义数据库用户的权限
 data difinition language    DDL 数据定义语言 用于创建、修改和删除数据库对象
grant
synonym
select last,city,age from empinfo
where age>30;
select frist from empinfo 
where frist like='%s'     =====error

first


DML: select  insert  update  delete 
DDL:create table; alter table;drop table;create index;drop index;
DCL:alter password;grant;revoke( 废除）;create synonym 

constrai
部门
department

select distinct store_name from Store_Information


2、查询重复字段

select * from 表名
where 重复字段名 from 表名 IN（where 重复字段 from 表名 group by 重复字段 having count（*）>1)

3、选取top limit (查询前多少 限制输出行数）

oracle:rownum

mysql:top

sqlserver:limit



---工作内容：
1、航线整理：往返航线算一个

2、IP地址库搜索



bi@china-sss.com 邮箱的web管理页地址  先有500M容量



(nvl(t2.adjust,'0') = '1' and nvl(t2.day_adjust,'0') = '7') or  nvl(t2.is_can,'0') = '1'




绿翼积分


svn地址：http://192.168.0.232/doc/doc/004 部门管理/008 研究院





\\192.168.9.156

1、下载jdk
2、安装jdk
3、配置环境变量：右击“我的电脑”-->"高级"-->"环境变量"
1）在系统变量里新建“JAVA_HOME”变量，变量值为：C:\Program Files\Java\jdk1.6.0_14（根据自己的安装路径填写）
2）新建“classpath”变量，变量值为：.;%JAVA_HOME%\lib;%JAVA_HOME%\lib\tools.jar
3）在path变量（已存在不用新建）添加变量值：%JAVA_HOME%\bin;%JAVA_HOME%\jre\bin（注意变量值之间用“;”隔开
）4、“开始”-->“运行”-->输入“javac”-->"Enter"，如果能正常打印用法说明配置成功！
补充环境变量的解析:JAVA_HOME:jdk的安装路径
classpath:java加载类路径，只有类在classpath中java命令才能识别，在路径前加了个"."表示当前路径。
path：系统在任何路径下都可以识别java,javac命令。'



SELECT t1.terminal_id,t1.web_id,t1.ex_nfd1,t1.channel,t3.agent_type,t2.sub_channel,COUNT(1)
FROM hdb.an_priod_channel t1
LEFT JOIN hdb.an_termianl_classify t2 ON t1.channel=t2.terminal
LEFT JOIN stg.s_cq_agent_info t3 ON t1.web_id=t3.agent_id
GROUP BY t1.terminal_id,t1.web_id,t1.ex_nfd1,t1.channel,t3.agent_type,t2.sub_channel




INSERT INTO hdb.an_termianl_classify(terminal,channel,sub_channel,memo,create_date)
SELECT h1.channel,
CASE WHEN h1.terminal_id<0 THEN 'B2C'
     WHEN h1.terminal_id>0 THEN 'B2B' END channel1,
CASE WHEN web_id>0 AND agent_type=5 THEN 'B2G机构客户'
     WHEN web_id>0 AND agent_type=1 THEN 'OTA'
     WHEN web_id>0 AND agent_type=2 THEN '外部代理'
     END,'5月新增' memo,SYSDATE

FROM(
SELECT t1.terminal_id,t1.web_id,t1.ex_nfd1,t1.channel,t3.agent_type,t2.sub_channel,COUNT(1)
FROM hdb.an_priod_channel t1
LEFT JOIN hdb.an_termianl_classify t2 ON t1.channel=t2.terminal
LEFT JOIN stg.s_cq_agent_info t3 ON t1.web_id=t3.agent_id
GROUP BY t1.terminal_id,t1.web_id,t1.ex_nfd1,t1.channel,t3.agent_type,t2.sub_channel)h1
WHERE h1.sub_channel IS NULL


INSERT INTO hdb.an_termianl_classify(terminal,channel,sub_channel,memo,create_date)
SELECT h1.channel,
CASE WHEN h1.terminal_id<0 THEN 'B2C'
     WHEN h1.terminal_id>0 THEN 'B2B' END channel1,
CASE WHEN web_id>0 AND agent_type=5 THEN 'B2G机构客户'
     WHEN web_id>0 AND agent_type=1 THEN 'OTA'
     WHEN web_id>0 AND agent_type=2 THEN '外部代理'
     WHEN h1.terminal_id>0 AND h1.web_id=0 AND h1.channel LIKE '%机构客户%' THEN 'B2G机构客户'
     END,to_char(sysdate,'mm')||'月新增' memo,SYSDATE

FROM(
SELECT t1.terminal_id,t1.web_id,t1.ex_nfd1,t1.channel,t3.agent_type,t2.sub_channel,COUNT(1)
FROM hdb.an_priod_channel t1
LEFT JOIN hdb.an_termianl_classify t2 ON t1.channel=t2.terminal
LEFT JOIN stg.s_cq_agent_info t3 ON t1.web_id=t3.agent_id
GROUP BY t1.terminal_id,t1.web_id,t1.ex_nfd1,t1.channel,t3.agent_type,t2.sub_channel)h1
WHERE h1.sub_channel IS NULL





INSERT INTO hdb.an_termianl_classify(terminal,channel,sub_channel,memo,create_date)
SELECT h1.channel,
CASE WHEN h1.terminal_id<0 THEN 'B2C'
     WHEN h1.terminal_id>0 THEN 'B2B' END channel1,
CASE WHEN web_id>0 AND agent_type=5 THEN 'B2G机构客户'
     WHEN web_id>0 AND agent_type=1 THEN 'OTA'
     WHEN web_id>0 AND agent_type=2 THEN '外部代理'
     WHEN h1.terminal_id>0 AND h1.web_id=0 AND h1.channel LIKE '%机构客户%' THEN 'B2G机构客户'
     WHEN h1.terminal_id>0 AND h1.web_id=0 AND h1.channel LIKE '%机场外部代理%' THEN '外部代理'
     END,to_char(sysdate,'mm')||'月新增' memo,SYSDATE
FROM(
SELECT t1.terminal_id,t1.web_id,t1.channel,t3.agent_type,t2.sub_channel,COUNT(1)
FROM hdb.an_priod_channel t1
LEFT JOIN hdb.an_termianl_classify t2 ON t1.channel=t2.terminal
LEFT JOIN stg.s_cq_agent_info t3 ON t1.web_id=t3.agent_id
GROUP BY t1.terminal_id,t1.web_id,t1.channel,t3.agent_type,t2.sub_channel)h1
WHERE h1.sub_channel IS NULL




select t1.terminal_id,t1.terminal,t2.area_name from stg.s_cq_terminal t1
         join stg.s_cq_area t2 on t1.area_id=t2.area_id
where t1.terminal ='金山二店营业部'


select * from hdb.cq_airport;


select * from stg.s_cq_city;


select t1.* from stg.s_cq_city T1
         LEFT JOIN HDB.CQ_AIRPORT T2 ON t1.threecodeforcity=t2.threecodeforcity
         WHERE t2.threecodeforcity IS NULL



select h1.*
from(
select t1.route_id,t1.h_route_id,t1.root_route_type,t1.segment_type,t1.segment_code,
case when t1.segment_type like '%经停%' then t2.originairport||'－'||t2.mid_airport||'－'||t2.destairport
     else t2.originairport||'－'||t2.destairport end root_segment_code,
t1.flights_segment_name,t1.route_name,
case when t1.root_nation_flag=1 then '国内'
     when t1.root_nation_flag=2 then '区域'
     when t1.root_nation_flag=3 then '国际'
     end root_nationflag,
     null segment_region,
     null income_type,
     t2.wf_segment_name,
     t2.wf_city_name,min(t1.flight_date) min_flightdate,max(t1.flight_date) max_flightdate
  from dw.da_flight t1
  left join dw.adt_wf_segment t2 on t1.h_route_id=t2.route_id
  where t1.flight_date>=to_date('2013-01-01','yyyy-mm-dd')
   and t1.flag<>2
   and t1.company_id=0
   group by t1.route_id,t1.h_route_id,t1.root_route_type,t1.segment_type,t1.segment_code,
case when t1.segment_type like '%经停%' then t2.originairport||'－'||t2.mid_airport||'－'||t2.destairport
     else t2.originairport||'－'||t2.destairport end ,
t1.flights_segment_name,t1.route_name,
case when t1.root_nation_flag=1 then '国内'
     when t1.root_nation_flag=2 then '区域'
     when t1.root_nation_flag=3 then '国际'
     end ,
     t2.wf_segment_name,
     t2.wf_city_name
    )h1
left join dw.dim_segment_type h2 on h1.route_id=h2.route_id and h2.h_route_id=h1.h_route_id
where h2.route_id is null




跳舱数据



 (SELECT H1.ORDER_NO,
                    H1.ORDER_HEAD_ID,
                    H1.MIN_SEAT_NAME,
                    H1.MIN_SEAT_PRICE,
                    H1.RATE
               FROM (SELECT H.ORDER_NO,
                            H.ORDER_HEAD_ID,
                            H.MIN_SEAT_NAME,
                            H.MIN_SEAT_PRICE,
                            H.RATE,
                            ROW_NUMBER() OVER(PARTITION BY H.ORDER_HEAD_ID ORDER BY ID) ROWNUMBER
                       FROM STG.S_CQ_MIN_PRICE_RCD H) H1
              WHERE H1.ROWNUMBER = 1) T3


---通用SQL

SELECT * FROM stg.s_cq_order t
         JOIN stg.s_cq_order_head t1 ON t.flights_order_id=t1.flights_order_id
         JOIN dw.da_flight t2 ON t1.segment_head_id=t2.segment_head




---收益关联数据



SELECT to_char(t1.flight_date,'yyyy-mm'),
 CASE WHEN t1.qr_flag=1 THEN replace(replace(t4.wf_segment_name,'虹桥','上海'),'浦东','上海')
      WHEN t1.qr_flag IS NULL THEN replace(replace(t3.wf_segment_name,'虹桥','上海'),'浦东','上海') END,
      t1.flight_no,
      SUM(t1.flight_time),
      SUM(t1.day_income)
 FROM hdb.recent_flights_cost t1
 LEFT JOIN dw.da_flight t2 ON t1.qr_flag IS NULL AND t1.segment_head_id=t2.segment_head_id 
 LEFT JOIN dw.adt_wf_segment t3 ON t2.h_route_id=t3.route_id
 LEFT JOIN dw.adt_wf_segment t4 ON t1.qr_flag=1 AND t1.flights_id=t4.route_id
 WHERE t1.flight_date>=to_date('2014-10-26','yyyy-mm-dd')
   AND t1.flight_date<=to_date('2015-03-28','yyyy-mm-dd')
   AND t1.total_cost> 0
 GROUP BY  to_char(t1.flight_date,'yyyy-mm'),CASE WHEN t1.qr_flag=1 THEN replace(replace(t4.wf_segment_name,'虹桥','上海'),'浦东','上海')
      WHEN t1.qr_flag IS NULL THEN replace(replace(t3.wf_segment_name,'虹桥','上海'),'浦东','上海') END,t1.flight_no







SELECT t1.*,CASE WHEN t1.qr_flag IS NULL THEN t2.origin_std
                 WHEN t1.qr_flag=1 THEN t5.origin_std END 起飞时间,
              CASE WHEN t1.qr_flag=1 THEN t4.wf_city_name
      WHEN t1.qr_flag IS NULL THEN t3.wf_city_name END 往返航线城市
 FROM hdb.recent_flights_cost t1
  LEFT JOIN dw.da_flight t2 ON t1.qr_flag IS NULL AND t1.segment_head_id=t2.segment_head_id
 LEFT JOIN dw.da_flight t5 ON t1.qr_flag=1 AND t1.FLIGHTS_ID=t5.h_route_id 
 AND t1.FLIGHT_DATE=t5.flight_date AND t5.route_type='经停' 
 AND t5.segment_type='经停AC段' AND t5.flag<>2
 AND t1.flight_no=t5.flight_no
 LEFT JOIN dw.adt_wf_segment t3 ON t2.h_route_id=t3.route_id
 LEFT JOIN dw.adt_wf_segment t4 ON t1.qr_flag=1 AND t1.flights_id=t4.route_id
 WHERE t1.flight_date>=to_date('2014-10-26','yyyy-mm-dd')
   AND t1.flight_date<=to_date('2015-03-28','yyyy-mm-dd')
   AND t1.total_cost> 0
   AND (CASE WHEN t1.qr_flag IS NULL THEN t2.is_bsale
            WHEN t1.qr_flag=1 THEN t5.is_bsale END )=0




SELECT h1.航班年,h1.航班月,h1.航段,SUM(h1.收益) 航班收益,SUM(h1.轮档时间) 轮档时间,SUM(h1.架次) 架次
FROM(
select 
to_char(t1.flight_date,'yyyy') 航班年,
to_char(t1.flight_date,'mm') 航班月,
to_char(t1.flight_date,'yyyy-mm') MONTH,
t1.route_name 航段,
SUM(t1.total_profit) 收益,
sum(flight_hour) 轮档时间,
count(0) 架次
from hdb.flights_cost t1
where t1.flag in (0,1,2)---找出汇总成本
and t1.flight_no like '9C%'
and t1.total_cost>0
group by 
to_char(t1.flight_date,'yyyy'), 
to_char(t1.flight_date,'mm') ,
to_char(t1.flight_date,'yyyy-mm'),
t1.route_name 

union all

select to_char(t2.flight_date,'yyyy') 航班年,
to_char(t2.flight_date,'mm') 航班月,
to_char(t2.flight_date,'yyyy-mm') MONTH,
t2.route_name 航段,
sum(t2.day_income)收益,
sum(t2.round_time) 轮档时间,
count(0) 架次
from hdb.recent_flights_cost t2
where t2.total_cost>0
 group BY to_char(t2.flight_date,'yyyy'),
to_char(t2.flight_date,'mm'),
to_char(t2.flight_date,'yyyy-mm') ,
t2.route_name)h1
WHERE h1.month IN('2011-05','2011-06','2011-07','2011-08','2011-09','2011-10',
                  '2012-05','2012-06','2012-07','2012-08','2012-09','2012-10',
                  '2013-05','2013-06','2013-07','2013-08','2013-09','2013-10',
                  '2014-05','2014-06','2014-07','2014-08','2014-09','2014-10')
                  GROUP BY h1.航班年,h1.航班月,h1.航段






select *
from hdb.temp_feng_0730 
where segment_head_id in(
SELECT h2.segment_head_id
FROM(
SELECT * FROM HDB.TEMP_FENG_0730
WHERE SEGMENT_HEAD_ID IS NULL
 AND FLIGHT_NO NOT LIKE '%/%'
 AND FLIGHT_SEGMENT ='PVGREP'
 AND FLIGHT_DATE>=TO_DATE('2013-02-01','YYYY-MM-DD'))h1
 left join dw.da_flight h2 on h1.flight_date=h2.flight_date+1 and h1.flight_no=h2.flight_no and h1.flight_segment=h2.segment_code)
 and h2.id not in in(
 
SELECT h2.segment_head_id,h2.flight_date,h1.*
FROM(
SELECT * FROM HDB.TEMP_FENG_0730
WHERE /*SEGMENT_HEAD_ID IS NULL
 AND*/ FLIGHT_NO NOT LIKE '%/%'
 AND FLIGHT_SEGMENT ='PVGREP'
 AND FLIGHT_DATE>=TO_DATE('2013-02-01','YYYY-MM-DD'))h1
 left join dw.da_flight h2 on h1.flight_date=h2.flight_date+1 and h1.flight_no=h2.flight_no and h1.flight_segment=h2.segment_code 
 )
 
  
  
 
  
create table hdb.temp_feng_0732 as
SELECT 
h1.ID,
h1.FLIGHT_NO,
h1.FLIGHT_DATE,
h1.FLIGHT_SEGMENT,
h1.ROUTE_NAME,
h1.B_SEGMENT,
h1.P_SEGMENT,
h1.E_SEGMENT,
h1.B_CODE,
h1.P_CODE,
h1.E_CODE,
h1.NATION_FLAG,
h1.FLIGHT_HOUR,
h1.BX_NUM,
h1.ZY_NUM,
h1.INFANT_NUM,
h1.TOTAL_NUM,
h1.SEAT_PER,
h1.BJ_TICKET_INCOME,
h1.BJ_AD_FY_INCOME,
h1.SW_TICKET_INCOME,
h1.SW_AD_FY_INCOME,
h1.AVG_SW_TICKET,
h1.AVG_SW_DISCOUNT,
h1.AVG_TICKET,
h1.AVG_DISCOUNT,
h1.TOTAL_INCOME,
h1.TRANS_COST,
h1.PER_FEE,
h1.TAX_FEE,
h1.TOTAL_COST,
h1.TOTAL_PROFIT,
h1.SUB_PROFIT,
h1.CHECKIN_SEAT_PER,
h1.FIXED_COST,
h1.VAR_COST,
h1.MARG_PROFIT,
h1.HOUR_COST_FEE,
h1.HOUR_FIXED_COST_FEE,
h1.SORTIE,
h1.BASE,
h1.TEMPLET_ID,
h1.FLAG,
h1.CREATE_DATE,
h2.segment_head_id,h2.segment_code,
h2.route_name routename,
h2.h_route_id,
h2.flight_date flightdate,
h2.flight_no flightno,
h2.segment_type,
11 routeflag
FROM(
SELECT * FROM HDB.TEMP_FENG_0730
WHERE /*SEGMENT_HEAD_ID IS NULL
 AND*/ FLIGHT_NO NOT LIKE '%/%'
 AND FLIGHT_SEGMENT ='PVGREP'
 AND FLIGHT_DATE>=TO_DATE('2013-02-01','YYYY-MM-DD'))h1
 left join dw.da_flight h2 on h1.flight_date=h2.flight_date+1 and h1.flight_no=h2.flight_no and h1.flight_segment=h2.segment_code 
 
 
 
 
 
 delete from hdb.temp_feng_0730 
 where id in(select id
 FROM(
SELECT * FROM HDB.TEMP_FENG_0730
WHERE /*SEGMENT_HEAD_ID IS NULL
 AND*/ FLIGHT_NO NOT LIKE '%/%'
 AND FLIGHT_SEGMENT ='PVGREP'
 AND FLIGHT_DATE>=TO_DATE('2013-02-01','YYYY-MM-DD'))h1
 left join dw.da_flight h2 on h1.flight_date=h2.flight_date+1 and h1.flight_no=h2.flight_no and h1.flight_segment=h2.segment_code  )


insert into hdb.temp_feng_0730
select * from hdb.temp_feng_0732

select * from hdb.temp_feng_0730 ttt1
where ttt1.flight_segment='PVGREP'
 and ttt1.segment_head_id is null
 for update
  
  


select t1.type,t1.flights_order_head_id,t1.segment_head_id,t2.flight_date,t2.flight_no,t2.segment_code,
       t2.flights_segment_name,t5.wf_segment_name,t2.nationflag,t2.origin_std,t2.dest_sta,
       t1.sname,t6.codetype_name,t1.codeno,t8.province,t8.city,t9.province mprovince,t9.city mcity,t11.country_name,
        case when t4.terminal_id<0 and t4.web_id=0 and t4.ex_nfd1<=1 then '网站'
            when t4.terminal_id<0 and t4.web_id=0 and t4.ex_nfd1>1 then '手机'
            when t4.web_id>0 then decode(t13.agent_type,1,'OTA',2,'B2B代理',5,'B2G机构客户')
            when t4.terminal_id in (300,1233,1309,1330,1400,1401,1516,1571,1801,1802,1803,1805,1806,1807,1808) then '呼叫中心'
            when t4.terminal_id not in (-1,-11,300,1233,1309,1330,1400,1401,1516,1571,1801,1802,1803,1805,1806,1807,1808) 
         and t4.web_id = 0 AND NOT regexp_like(t12.terminal,'(95524)|(机构客户)|(集团客户)') then 'B2B'
         when t4.terminal_id>0 AND t4.web_id=0 AND regexp_like(t12.terminal,'(95524)|(机构客户)|(集团客户)') THEN 'B2G机构客户' END,
         t1.modify_date,
         t7.dd checkin_date,
         t7.info       
from hdb.temp_feng_0804 t1
join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
join stg.s_cq_order_head t3 on t1.flights_order_head_id=t3.flights_order_head_id
join stg.s_cq_order t4 on t3.flights_order_id=t4.flights_order_id
JOIN dw.adt_wf_segment t5 ON t5.route_id=t2.route_id
JOIN stg.s_cq_codetype t6 ON t6.codetype=t1.codetype
LEFT JOIN dw.adt_region_code t8 ON t1.codetype=1 AND substr(getcardno('ID',t1.codeno),1,6)=t8.regioncode
LEFT JOIN dw.adt_mobile_list t9 ON t9.mobilenumber=substr(getmobile(t3.r_tel),1,7)
LEFT JOIN stg.s_cq_traveller_info t10 ON t3.flights_order_head_id=t10.flights_order_head_id
LEFT JOIN stg.s_cq_country_area t11 ON t10.nationality=t11.country_code
LEFT JOIN stg.s_cq_terminal t12 ON t12.terminal_id=t4.terminal_id
LEFT JOIN stg.s_cq_agent_info t13 ON t13.agent_id=t4.web_id
left join stg.s_dcs_out_m t7 on t7.rl=t1.flights_order_id and t7.ri=t1.valid_code




------------------------------------------性别、年龄--------------------------------------------------------------------

case when t1.codetype=1 then hdb.getgender(t1.codeno)
     WHEN t1.codetype<>1 THEN CASE WHEN t9.GENDER='1' THEN '男'
                                   WHEN t9.gender='2' THEN '女'
                                   ELSE '-' END
     ELSE '-' END gender,
CASE WHEN t1.codetype=1 THEN getage(t1.r_flights_date,getbirthday(t1.codeno))
     WHEN t1.codetype<>1 THEN CASE WHEN t9.birthday IS NOT NULL THEN 
                              floor((t1.r_flights_date-t9.birthday)/365)
                              ELSE NULL END 
                              END age
 


SELECT to_char(t.order_date,'yyyy-mm-dd'),t2.nationflag,t2.flights_segment_name,t2.segment_country,
      case when t.terminal_id<0 and t.web_id=0 and t.ex_nfd1<=1 then '网站'
            when t.terminal_id<0 and t.web_id=0 and t.ex_nfd1>1 then '手机'
            when t.web_id>0 then decode(t4.agent_type,1,'OTA',2,'B2B代理',5,'B2G机构客户')
            when t.terminal_id in (300,1233,1309,1330,1400,1401,1516,1571,1801,1802,1803,1805,1806,1807,1808) then '呼叫中心'
            when t.terminal_id not in (-1,-11,300,1233,1309,1330,1400,1401,1516,1571,1801,1802,1803,1805,1806,1807,1808) 
         and t.web_id = 0 AND NOT regexp_like(t3.terminal,'(95524)|(机构客户)|(集团客户)') then 'B2B'
         when t.terminal_id>0 AND t.web_id=0 AND regexp_like(t3.terminal,'(95524)|(机构客户)|(集团客户)') THEN 'B2G机构客户' END,
            COUNT(1) 票数
  FROM stg.s_cq_Order t
  JOIN stg.s_cq_order_head t1 ON t.flights_order_id=t1.flights_order_id
  JOIN dw.da_flight t2 ON t1.segment_head_id=t2.segment_head_id
  LEFT JOIN stg.s_cq_agent_info t4 ON t.web_id=t4.agent_id
  LEFT JOIN stg.s_cq_terminal t3 ON t.terminal_id=t3.terminal_id
  WHERE t.order_date>=to_date('2015-08-03','yyyy-mm-dd')
   AND t.order_date< trunc(SYSDATE)
   AND t1.flag_id IN(3,5,40)
   AND t1.seats_name IS NOT NULL
   AND t1.seats_name NOT IN('B','G','G1','G2','O')
   AND t2.company_id=0
   GROUP BY to_char(t.order_date,'yyyy-mm-dd'),t2.nationflag,t2.flights_segment_name,t2.segment_country,
      case when t.terminal_id<0 and t.web_id=0 and t.ex_nfd1<=1 then '网站'
            when t.terminal_id<0 and t.web_id=0 and t.ex_nfd1>1 then '手机'
            when t.web_id>0 then decode(t4.agent_type,1,'OTA',2,'B2B代理',5,'B2G机构客户')
            when t.terminal_id in (300,1233,1309,1330,1400,1401,1516,1571,1801,1802,1803,1805,1806,1807,1808) then '呼叫中心'
            when t.terminal_id not in (-1,-11,300,1233,1309,1330,1400,1401,1516,1571,1801,1802,1803,1805,1806,1807,1808) 
         and t.web_id = 0 AND NOT regexp_like(t3.terminal,'(95524)|(机构客户)|(集团客户)') then 'B2B'
         when t.terminal_id>0 AND t.web_id=0 AND regexp_like(t3.terminal,'(95524)|(机构客户)|(集团客户)') THEN 'B2G机构客户' END
 



----------------------------------------------------订单掉单率-------------------------------------------------------------


SELECT A.GATENAME GATENAME,
			 NVL(SUM(A.FAIL), 0) FAIL,
			 NVL(SUM(A.SUCCE), 0) SUCCESS,
			 NVL(SUM(A.TOTAL), 0) TOTAL,
			 NVL(SUM(A.CONFIRM), 0) CONFIRMNUM,
			 NVL(SUM(A.ORDERFAIL), 0) ORDERFAIL,
			 NVL(ROUND(SUM(A.ORDERFAIL) /
								 DECODE(SUM(A.SUCCE), 0, 1, SUM(A.SUCCE)),
								 4) * 100,
					 0) LOSORDERRATE,
			 NVL(ROUND(SUM(A.SUCCE) / DECODE(SUM(A.TOTAL), 0, 1, SUM(A.TOTAL)), 4) * 100,
					 0) SUCCESRATE
	FROM (SELECT G.GATE_NAME GATENAME,
							 CASE
								 WHEN I.PAY_FLAG = 0 THEN
									COUNT(I.IPS_ORDER_ID) --失败支付数
							 END FAIL,
							 CASE
								 WHEN I.PAY_FLAG IN (1, 2) THEN
									COUNT(I.IPS_ORDER_ID) --成功支付数
							 END SUCCE,
							 CASE
								 WHEN I.PAY_FLAG IN (1, 2) AND I.EX_NFD1 IS NULL THEN
									COUNT(I.IPS_ORDER_ID) --掉单率
							 END ORDERFAIL,
							 COUNT(I.IPS_ORDER_ID) TOTAL,
							 CASE
								 WHEN I.CONFIRM_USERID != -1 AND I.PAY_FLAG IN (1, 2) THEN
									COUNT(I.IPS_ORDER_ID)  --人工确认率
							 END CONFIRM
					FROM PAY.CQ_IPS_ORDER_ID I, PAY.CQ_PAY_GATE G
				 WHERE I.PAY_GATE = G.ID
					 AND G.IS_ONLINE != 1
					 AND NVL(I.COMPANY_ID, 0) = 0
					 AND I.CREATE_DATE >= TO_DATE('2014-01-01', 'yyyy-mm-dd')
					 AND I.CREATE_DATE < TO_DATE('2014-12-31', 'yyyy-mm-dd') + 1
				 GROUP BY G.GATE_NAME, I.PAY_FLAG, I.EX_NFD1, I.CONFIRM_USERID) A
 GROUP BY A.GATENAME
 ORDER BY SUCCESRATE DESC;








SELECT SUM(ticketnum),count(distinct client_id)
FROM (
SELECT h1.tel,h1.client_id,sum(COUNT(DISTINCT h1.channel))over(partition by h1.tel) num,SUM(h1.ticketnum) ticketnum
FROM(
SELECT hdb.getmobile(t.work_tel) tel,t.client_id,
  CASE WHEN t.terminal_id<0 AND t.ex_Nfd1<=1 THEN '网站'
       WHEN t.terminal_id<0 AND t.ex_nfd1>1 THEN '手机'
       ELSE '其他' END channel,
       COUNT(DISTINCT t.flights_order_id) ticketnum
 
  FROM STG.S_CQ_ORDER T
  JOIN DW.DA_B2C_USER T1 ON T.CLIENT_ID = T1.USERS_ID
  JOIN STG.S_CQ_ORDER_HEAD T2 ON T.FLIGHTS_ORDER_ID = T2.FLIGHTS_ORDER_ID
 WHERE T1.CUST_TYPENAME = '微信会员'
    T.ORDER_DATE >= TRUNC(SYSDATE - 365)
   AND T.ORDER_DATE < TRUNC(SYSDATE)
   AND T2.FLAG_ID IN (3, 5, 40)
   AND T.R_COMPANY_ID = 0
   GROUP BY hdb.getmobile(t.work_tel),t.client_id,
  CASE WHEN t.terminal_id<0 AND t.ex_Nfd1<=1 THEN '网站'
       WHEN t.terminal_id<0 AND t.ex_nfd1>1 THEN '手机'
       ELSE '其他' END)h1
GROUP BY h1.tel,h1.client_id
)h2
where h2.num>=2; 


--====================================================2021年tuc==========================================================

--20210118
下一步淘汰的人
对于任务的安排我再强调一下，我安排的工作后续不管有没有问题，先执行再反馈问题，不接受拒绝，想拒绝可以直接找郑总，不想干可以不干
对于不想进步的人，我不用给他太多的机会，让他慢慢失去竞争力即可，也不用太过理会
慢慢增加想要上进的人

经验教训：

# 股票投资要进行判断，要有依据，不能凭感觉
## 大盘总体的情况是什么样，板块总体的情况是什么样子，个股的价值是什么样子，是做长期还是短期？？ 短期的话最近一段时间的行情是什么样子？
## 大盘下行的话判断进入时间，大盘上行确定什么时候退出
## 有价值，有上升空间的，做T，弥补现在的损失

1、大盘总体的情况是什么样，板块总体的情况是什么样子，个股的价值是什么样子，是做长期还是短期？？ 短期的话最近一段时间的行情是什么样子？
2、先看下军工龙头股票是否是市盈率过高，市净率过高，通过这个来筛选基金
都在看好的时候有可能就是一波小行情，可以跟随几天，别人都不看好情况下，进入时机要把握准确，拿不准就不要进入
不赚自己没有把握的钱
现在都在看好的时候就要想着出来了，别人都在看好的时候就要想着出来，在别人都不看好的时候要进入
2、有价值，被套的，有上升空间，做T，弥补损失


设置止损线：下降4个点即可出局，即算是判断失误，技术壁垒高，收益率高的企业
设置止盈线: 20%即可退出，10%提醒
长期看好、证券不发力

两个月的时间来学习python，在搬入新家之前有一个完成知识体系积累，学习，实践，实践，再实践，没有人能阻止我学习

len(classmates) - 1
list 可变的有序表
list = ['dafnd','dfads',1,2]


---各个部门数据建设要求（预留一名业务分析人员），可以是实习生，也可以是相当人事转岗
1、建议各个部门培养一个专门对接数据需求、进行数据分析的人员，可以协助各个处室总监进行工作
2、部门业务数据框架、部门分析框架等
3、作用：放在业务部门的数据分析师，嵌入模式（注入、集中）

1、内部优劣势，外部：机会、威胁及挑战  数据：态势分析
2、金字塔原理
myself：
1、知识结构更新
2、技术能力提升
3、英语、语言表达能力提升
不要有抵触心理

人员结构：
1、数据分析师：主营、辅收、线上渠道、ETL及可视化
---需要做的事情：JD（任职要求）
---部门发展：发展系统自动haul，例如没有智造
2、数据项目：
---1、数据产品：CDP功能完善
---2、机票精准营销模型
---3、数字营销精细化投放模型
---4、辅收精准营销
---5、APP内部转化率提升
3、sleep、？？？？怎么办？？？？？？？？？打发
4、内部各种不公平，社会就是不公平的，人员的工作轻度，人预见集体打发大幅度，辅收精准营销
5、杯子开开心先大幅度， 大飞机的是否按时的烦恼，打洞机
人不为己天诛地灭，在保全自己、丰富自己的基础上在去做烂好人
对于社群运营的，投放模型，

您好：
数据决策系统报表权限已开通，工号：002678 密码：26l_9q
决策系统内网访问地址：http://dmp.springgroup.cn/WebReport/ReportServer
若外网环境下通过公司VPN访问，请访问地址：http://192.168.112.69/WebReport/ReportServer
报表对应数据涉及公司运营数据，请严格保密,谢谢。
关于决策系统的问题，可以直接联系我。

除周一三五上午中午外其他时间均可


您好
     三号楼3楼市场管理部市场分析处孟祥明 工号021349，新员工入职，因工作需要需要申请市场分析处redmine\SVN权限，
 
   市场分析处SVN权限1：https://spring-svn01.springgroup.cn/svn/春秋航空/市场管理部/工作周报/2019/市场分析处
   市场分析处SVN权限2：http://192.168.0.238/itdeptcm/2015S32401/数据管理组
   redmine 权限：申请“市场部数据提取”项目的“市场部数据提取人”的权限
  
   请帮忙操作，谢谢。



一个人手头上至少两个事情，一个是当前在做的，一个是未来规划要做的

1、你给我计划，要不就按照我的计划来，两个你选一个
2、按照我的计划你要能完成，完成不了不要来找我

后续周例会大家轮流主持，会议主题在开会前收集，没有收集到进行指定 ，顺序从我这边开始--孟祥明--李悦--彭凯斯--李诚--杨杰昊--韦莹--李沁--李艳艳--顾文怡，
会议主持需要确定的点：1、周三前收集大家的议题，若没有议题的我这边会指定；2、会议重要问题及结论的记录；3、开会前的准备


CONCATENATE('20210701~',CONCATENATE(year(today()-1),month(today()-1),DAY(today()-1)))

CONCATENATE('20210701~',CONCATENATE(year(today()-1),format(month(today()-1),"00"),format(day(today()-1),"00"))

----------------------------------------------数字营销----------------------------------------------


IJ 客舱销售数据对接并开发对应报表\TMC销售统计报表修改\业务批量调整报表：商务经济座5个其他辅收1个\张静璐餐食配置二次优化



关于数字营销数据项目的说明：
1.项目概述：
为打通从曝光到用户运维的全链路流程，现接入第三方平台数字营销数据；接入主要通过CDP监测链接部署至第三方信息流平台实现，在获取到点击和曝光数据后通过
将自有环境点击和曝光数据的设备值匹配，最终实现整体数据打通。
2.归因模型：
归因主要围绕激活、注册、下单三个关键指标进行，基于将投放的创意id作为CMPID，用last归因模式、30天窗口期进行归因。
3.分析体系：
基于搭建好的数据框架，数字营销分析体系会从曝光-点击-激活-注册-下单-流失全生命周期进行追踪和分析，分析所涉及的参数（如流失窗口、复购行为等）可基于
业务自行设定。


数据提取流程（非敏感信息）：需求人--所在处室领导审批---市场部信息化经理审核---市场分析处经理审核并安排人执行--OA发送相应结果给到需求人
数据提取流程（敏感信息）：需求人--所在处室领导审批---市场部总经理---市场分析处经理审核并安排人执行--OA发送相应结果给到需求人（数据加密，密码另行通知需求人）



---------------------------------------------20210723 后续业务计划及跟踪----------------------------------------------------------

1） 历史标签：会员标签、乘机人标签、行为标签
      1、长期：现有标签梳理，标签数据验证，标签逻辑重构，证针对现有标签进行优化
	  2、 行为标签：重构，基于现有宽表，数字营销，考虑能快速获取设备ID，做精准营销，做弹窗，做A/B
	  3、基于短信营销的逻辑汇总相应的短信营销需要的场景标签，涉及到历史标签在这块来做，如果涉及实时标签的话我们就要销售宽表/会员宽表
2） 销售宽表/辅收宽表/会员宽表
      1、应用：sql查询
	  2、短信营销自动化
	  3、自助分析报表平台
思考：事件宽表：思考，是否有应用场景
	  
任务：
1、流量宽表：数据验证完毕后，宽表--》 聚合表，聚合表方案 （应用场景：数字营销效果聚合表(增加GIO数字营销效果获取)，日流量统计表--和我们目前的finereport报表、绩效考核数据，月流量） 
2、月度计划：短信营销自动化---汇总梳理短信营销场景标签，用了哪些标签，缺了哪些标签；短信营销自动化CDP实现方案
3、月度计划：CDP培训手册，一步一步开放相应的功能/ Deeplink什么时候能开发完毕
4、为什么还在GIO投放，有哪些问题需要IT解决，GIO投放迁移至CDP的一个方案



 ((t1.order_day >= '${sdate}'
         and t1.order_day <= '${edate}') or
       (t1.order_day >= '${corrsdate}' and t1.order_day <= '${corredate}'))

and t1.order_day >= to_date('${sdate}','yyyy-mm-dd')
and t1.order_day <= to_date('${edate}','yyyy-mm-dd')

192.168.210.76
administrator
123qweASD



为科学反映我国不同区域的社会经济发展状况，为党中央、国务院制定区域发展政策提供依据，根据《中共中央、国务院关于促进中部地区崛起的若干意见》、
《国务院发布关于西部大开发若干政策措施的实施意见》以及党的十六大报告的精神，现将我国的经济区域划分为东部、中部、西部和东北四大地区。
东部包括：北京、天津、河北、上海、江苏、浙江、福建、山东、广东和海南。
中部包括：山西、安徽、江西、河南、湖北和湖南。
西部包括：内蒙古、广西、重庆、四川、贵州、云南、西藏、陕西、甘肃、青海、宁夏和新疆。
东北包括：辽宁、吉林和黑龙江。



网站：https://www.growingio.com/projects/4PYpWDRM 
APP：https://www.growingio.com/projects/woVabrP2
M网站：https://www.growingio.com/projects/EoZkXM9k
小程序：https://www.growingio.com/projects/a9B45VPn

Jk@20210801
ZchRgZP!8QkuF
绕航率：(AB+BC-AC)/AC


fengxihuan@ch.com
Fxh136079*

