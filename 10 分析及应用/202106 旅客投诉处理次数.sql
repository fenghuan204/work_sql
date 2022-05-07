select to_char(mincreatetime,'yyyymm') 月份,jobstate,num, 
case when num1>0 and  num3+num2+num4>0  then '内部已有投诉还投诉到民航局'
     when num1=0 and  num3+num2+num4>1  then '内部多次处理'
     when num1>0 and  num3+num2+num4=0  then '仅民航局投诉'
     when num1=0 and  num3+num2+num4=1  then '内部仅一次处理' end 投诉类型,
     num1,num2,num3,num4,
     count(1) 去重投诉量
from(
select nvl(cp.orderchannelchild || cp.orderno||cp.cardno||cp.passengername, cp.jobno) tsnum,
       min(cp.createtime) mincreatetime,max(cp.createtime),max(case when cp.jobstate in('已结案','结案判定') then 1
       else 0 end) jobstate,
       sum(case
             when cp.jobnextfrom in ('Android', 'IOS', 'M网', '网站', '微信', '绿翼商城',
             '集团投诉科', '旅客评价', '新媒体平台-舆情', '意见卡', '智慧客舱', '内部', '内部渠道', '其它') then
             1
             else 0 end ) num4,
       sum(  case        
             when cp.jobnextfrom in
                  ('工商所（机场工商、华阳）', '公商所（机场工商、华阳）', '民航局', '民航局（调解）', '民航局（华东管理局）',
                   '民航局（网页）', '其他外部（社交网络）', '上海市民热线12345', '上海市信访办', '外部',
                   '外部媒体（广播、报社、新闻）', '消保委', '新媒体平台-FACEBOOK', '新媒体平台-舆情') then
                   1 
                 else 0 end) num1,
        sum(case       
             when cp.jobnextfrom = '呼叫中心' then
              1
              else 0 end )  num2,           
        sum( case 
             when cp.jobnextfrom in ('内部流转(其他)事项', '内部流转(投诉)事项') then
              1
              else 0 end)  num3,
       count(distinct nvl(cp.orderchannelchild || cp.orderno||cp.cardno||cp.passengername, cp.jobno)) totalnum,
       count(1) num
  from hdb.crm_wo_baseinfo cp
 where trunc(cp.createtime) >= to_date('2021-03-01', 'yyyy-mm-dd')
   and trunc(cp.createtime) < trunc(sysdate)
   and cp.gcflag = 0
   and cp.jobtypecode = 'T'
 group by nvl(cp.orderchannelchild || cp.orderno||cp.cardno||cp.passengername, cp.jobno))tb1
 group by to_char(mincreatetime,'yyyymm'),jobstate,num, 
case when num1>0 and  num3+num2+num4>0  then '内部已有投诉还投诉到民航局'
     when num1=0 and  num3+num2+num4>1  then '内部多次处理'
     when num1>0 and  num3+num2+num4=0  then '仅民航局投诉'
     when num1=0 and  num3+num2+num4=1  then '内部仅一次处理' end,
      num1,num2,num3,num4
         
