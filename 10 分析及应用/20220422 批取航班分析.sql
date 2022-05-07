select tp1.flight_date,tp1.flight_no,tp1.route_name,tp1.flag,
tp1.origin_std,tp1.PUBLISH_DATE,
case when tp1.flag=0 then -1
else trunc(tp1.origin_std-tp1.PUBLISH_DATE) end prioddate,
     nvl(nvl(tp2.round_time,tp3.avgtime),tp4.avgtime) roundtime,
     case when tp1.flag=0 then nvl(tp2.total_num,tp1.boardnum)
     else nvl(tp2.total_num,tp1.cltkt) end 销量,
     case when tp1.flag=0 then  nvl(tp2.totalincome,tp1.tktfee1*0.9174)
     else nvl(tp2.totalincome,tp1.cltktfee*0.9174) end totalincome ,
     nvl(nvl(tp2.vari_cost,tp3.vari_cost),tp4.vari_cost) vari_cost ,
     case when tp1.flag=0 then  (tp1.backfy+tp1.gaify)*0.94
     else case when tp1.backfy+tp1.gaify-tp1.cltotaltgfy>0 then tp1.backfy+tp1.gaify-tp1.cltotaltgfy
     else 0 end  end 退改签收入,
     tp1.CORR_PREDICT_TICKET_NUM 预测销量,
     tp1.CORR_PREDICT_INCOME 预测航班收入,
     tp1.CORR_PREDICT_FZ 预测航班辅收,
     tp1.ftkt,
     tp1.tktfee1+tp1.backfy+tp1.gaify ffee,
     tp1.tsnum,
     tp1.wbtsnum,
     tp2.subsidy
   from(
select dim.flight_date,dim.flight_no,dim.route_name,max(flag) flag,min(origin_std) origin_std,
min(case when dim2.PUBLISH_DATE is not null then  dim2.PUBLISH_DATE
else dim.orderdate end) PUBLISH_DATE,
sum(dim.tsnum) tsnum,sum(dim.wbtsnum) wbtsnum,sum(CORR_PREDICT_TICKET_NUM) CORR_PREDICT_TICKET_NUM,
sum(CORR_PREDICT_INCOME) CORR_PREDICT_INCOME,sum(CORR_PREDICT_FZ) CORR_PREDICT_FZ,
sum(tkt) cltkt,
sum(tktfee) cltktfee,
sum(xfee) clxfee,
sum(dim.ftkt) ftkt,
sum(dim.tktfee1) tktfee1,
sum(dim.xfee1) xfee1,
sum(dim.backfy) backfy,
sum(dim.gaify) gaify,
sum(dim2.tgfy) cltotaltgfy,
sum(dim.boardnum) boardnum
from(
select t1.segment_head_id,t2.flight_date,t2.flight_no,t2.flights_segment_name,t2.route_name,
t2.flag,min(t2.origin_std) origin_std,max(t1.order_date) orderdate,
count(1) ftkt,
count(distinct t4.order_head_id) tsnum,
sum(nvl(t4.wbnum,0)) wbtsnum,
sum(case when t1.flag_id in(3,5,40,41) then 1
else 0 end) boardnum,
sum(case when t1.flag_id in(3,5,40,41) then t1.ticket_price+t1.ad_fy
else 0 end) tktfee1,
sum(case when t1.flag_id in(3,5,40,41) then t1.other_fee+t1.insurce_fee
else 0 end) xfee1,
sum(nvl(t5.money_fy,0)) backfy,
sum(nvl(t6.money_fy*t6.rate,0)) gaify
from dw.fact_recent_order_detail t1
 join dw.da_flight t2 on t1.segment_head_id =t2.segment_head_id
 left join dw.da_order_drawback t5 on t1.flights_order_head_id=t5.flights_order_head_id
 left join dw.da_order_change t6 on t1.segment_head_id=t6.new_segment_id and t1.flights_order_head_id=t6.flights_order_head_id
 left join(
 select order_head_id,jobnextfrom,
 case when jobnextfrom in('民航局','消保委','民航局（华东管理局）','上海市民热线12345','新媒体平台-FACEBOOK',
 '民航局（调解）','公商所（机场工商、华阳）','民航局（网页）','外部','工商所（机场工商、华阳）','上海市信访办') then 1
 else 0 end wbnum      
 from(
 select to_Number(regexp_substr(t3.orderchannelchild,'[0-9]+')) order_head_id ,max(jobnextfrom) jobnextfrom
  from hdb.crm_wo_baseinfo t3
  where t3.orderchannelchild is not null 
  group by  regexp_substr(t3.orderchannelchild,'[0-9]+')
  )h1) t4 on t1.flights_order_head_id=t4.order_head_id  
  where t1.flights_date>=to_date('20220407','yyyymmdd')
  and t1.flights_date<=to_date('20220420','yyyymmdd')
  and t1.nationflag='国内'
  --and t1.whole_flight='9C7015'
  group by t1.segment_head_id,t2.flight_date,t2.flight_no,t2.flights_segment_name,t2.route_name,
t2.flag)dim  
  
left join (
select *
from (
  select segment_head_id,SALE_NUM,FZ,CORR_PREDICT_TICKET_NUM,CORR_PREDICT_SALE,CORR_PREDICT_INCOME,CORR_PREDICT_FZ,PREDICT_TICKET_NUM,PREDICT_INCOME,
  row_number()over(partition by segment_head_id order by create_time desc) rid
   from dw.fr_segment_income_predict_bak3
  where flight_date>=to_date('2022-04-07','yyyy-mm-dd')
  and flight_date<=to_date('2022-04-20','yyyy-mm-dd')
  )h1
  where h1.rid=1)dim1    on dim.segment_head_id=dim1.segment_head_id
left join (select segment_head_id,PUBLISH_DATE,t1.back_num+t1.change_num+t1.remain_num tkt,
t1.back_tktfee+t1.back_adfee+t1.change_tktfee+t1.change_adfee++t1.remain_tktfee+t1.remain_adfee tktfee,
t1.back_tktfee+t1.back_adfee+t1.change_tktfee+t1.change_adfee tgfy,
t1.back_xfee+t1.change_xfee+t1.remain_xfee xfee
 from dw.tw_unnormal_flight t1
 where t1.unnormaltype='取消'
 and t1.flight_date>=date'2022-04-07'
 and t1.flight_date<=date'2022-04-22')dim2 on dim.segment_head_id=dim2.segment_head_id
  group by dim.flight_date,dim.flight_no,dim.route_name
  )tp1
  left join
  (select tt1.flight_date,tt1.flight_no,tt1.route_name,tt1.total_income-tt1.tax_fee totalincome,
          tt1.round_time,tt1.vari_cost,to_number(tt2.subsidy)  subsidy,tt1.totalnum total_num
   from hdb.recent_flights_cost tt1
   left join(select flightdate,
                    flightno,
                    route_name,
                    if.decrypt_des(subsidy, 'subsidy0718') subsidy
               from hdb.wb_flight_subsidy_summary) tt2 on tt1.flight_date=tt2.flightdate
               and tt1.flight_no=tt2.flightno and tt1.route_name=tt2.route_name   
   where tt1.flight_date>=date'2022-04-07'
   and tt1.flight_date< date'2022-04-20'
   and tt1.round_time is not null
   and tt1.total_cost>0  
  )tp2 on tp1.flight_date=tp2.flight_date and tp1.flight_no=tp2.flight_no
  and tp1.route_name=tp2.route_name
  left join
  (
  select tt1.flight_no,tt1.route_name,avg(tt1.round_time) avgtime,
  sum(tt1.vari_cost)/sum(tt1.round_time) avgcost,avg(tt1.vari_cost) vari_cost
   from hdb.recent_flights_cost tt1   
   where tt1.flight_date>=date'2022-04-07'
   and tt1.flight_date< date'2022-04-20'
   and tt1.round_time is not null
   and tt1.total_cost>0  
   group by tt1.flight_no,tt1.route_name
  )tp3 on tp1.flight_no=tp3.flight_no and tp1.route_name=tp3.route_name
  
   left join
  (
  select tt1.flight_no,tt1.route_name,avg(tt1.round_time) avgtime,
  sum(tt1.vari_cost)/sum(tt1.round_time) avgcost,avg(tt1.vari_cost) vari_cost
   from hdb.recent_flights_cost tt1   
   where tt1.flight_date>=date'2022-04-01'
   and tt1.flight_date< date'2022-04-22'
   and tt1.round_time is not null
   and tt1.total_cost>0  
   group by tt1.flight_no,tt1.route_name
  )tp4 on tp1.flight_no=tp4.flight_no and tp1.route_name=tp4.route_name
  
  
  