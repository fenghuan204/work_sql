select h3.flight_no �����,h3.flights_segment_name ����,h3.flight_date ��������,
h3.segment_type ��������,h3.adhead ���뺽��ƻ���ɻ��м���,
case when h3.swplan>0 then  h3.tkt/h3.swplan
else null end ɢ�����۽���,
case when h3.tkt>0 then  h3.onlinenum/h3.tkt
else null end ��������ռ��,
h3.bookfee ���ϸ����ܽ��,
h3.luggage_fee ����������,
h3.sjlugg_fee ����������,
h3.xz_fee ѡ�����,
h3.cs_fee ��ʳ���,
h3.hyinsur_fee �����ս��,
h3.qxinsur_fee ȡ���ս��,
h3.jwinsur_fee �����ս��,
h3.ywinsur_fee �����ս��,
h3.xlinsur_fee  �����ս��,
h3.zhinsur_fee �ۺ��ս��,
H3.other_fee �����������ս��,
h4.lastnum,
h4.thisnum
from(
select h2.flight_no,h2.flights_segment_name,h2.flight_date,h2.segment_type,h2.adhead,
       suM(h2.swplan) swplan,
       sum(h2.tkt) tkt,
       sum(h2.onlinenum) onlinenum,
        sum(h2.bookfee) bookfee,
       sum(h2.luggage_fee) luggage_fee,
       sum(h2.sjlugg_fee) sjlugg_fee,
       sum(h2.xz_fee) xz_fee,
       sum(h2.cs_fee) cs_fee,
       sum(h2.hyinsur_fee) hyinsur_fee,
       sum(h2.qxinsur_fee) qxinsur_fee,
       sum(h2.jwinsur_fee) jwinsur_fee,
       sum(h2.jwinsur_fee) ywinsur_fee,
       sum(h2.xlinsur_fee) xlinsur_fee,
       sum(h2.zhinsur_fee) zhinsur_fee,
       sum(h2.other_fee) other_fee      
from(
select t1.segment_head_id,t3.flight_no,t3.flights_segment_name,t3.flight_date,t3.flight_date-trunc(sysdate) adhead,
       t3.segment_type,t3.oversale-t3.bgo_plan+t3.o_plan swplan,
       count(1) tkt,sum(case when t1.channel in('��վ','�ֻ�') then 1 else 0 end) onlinenum,
       sum(h1.bookfee) bookfee,
       sum(h1.luggage_fee) luggage_fee,
       sum(h1.sjlugg_fee) sjlugg_fee,
       sum(h1.xz_fee) xz_fee,
       sum(h1.cs_fee) cs_fee,
       sum(h1.hyinsur_fee) hyinsur_fee,
       sum(h1.qxinsur_fee) qxinsur_fee,
       sum(h1.jwinsur_fee) jwinsur_fee,
       sum(h1.jwinsur_fee) ywinsur_fee,
       sum(h1.xlinsur_fee) xlinsur_fee,
       sum(h1.zhinsur_fee) zhinsur_fee,
       sum(h1.other_fee) other_fee
 from dw.fact_order_detail t1
 join dw.da_flight t3 on t1.segment_head_id=t3.segment_head_id
 left join(select t2.flights_order_head_id,
                   sum(case when t2.xtype_id in(6,10,17) then t2.book_fee 
                   else 0 end) luggage_fee,
                   sum(case when t2.xtype_id =23 then t2.book_fee 
                   else 0 end) sjlugg_fee,
                   sum(case when t2.xtype_id =3 then t2.book_fee 
                   else 0 end) xz_fee,
                   sum(case when t2.xtype_id =1 then t2.book_fee 
                   else 0 end) hyinsur_fee,
                   sum(case when t2.xtype_id =2 then t2.book_fee 
                   else 0 end) qxinsur_fee,
                   sum(case when t2.xtype_id =4 then t2.book_fee 
                   else 0 end) jwinsur_fee,
                   sum(case when t2.xtype_id =11 then t2.book_fee 
                   else 0 end) ywinsur_fee,
                   sum(case when t2.xtype_id =28 then t2.book_fee 
                   else 0 end) xlinsur_fee,
                    sum(case when t2.xtype_id =33 then t2.book_fee 
                   else 0 end) zhinsur_fee,
                  sum(case when t2.xtype_id =7 then t2.book_fee 
                   else 0 end) cs_fee,
                   sum(case when t2.xtype_id not in(6,10,17,23,3,1,2,4,11,28,33,7)  then t2.book_fee 
                   else 0 end) other_fee,
                   sum(t2.book_fee) bookfee              
            from dw.fact_other_order_detail t2 
            where t2.flights_date>=trunc(sysdate)
             and  t2.flights_date< trunc(sysdate)+7
             and  t2.company_id=0
             and t2.xtype_id not in(24,25,34)
             group by t2.flights_order_head_id)h1 on t1.flights_order_head_id=h1.flights_order_head_id            
          where t1.flights_date>=trunc(sysdate)
            and t1.flights_date< trunc(sysdate)+7
            and t1.seats_name is not null 
            and t1.company_id=0
            and t3.flag=0
            and t1.seats_NAME NOT IN('B','G','G1','G2')
            group by t1.segment_head_id,t3.flight_no,t3.flights_segment_name,t3.flight_date,t3.flight_date-trunc(sysdate),
       t3.segment_type,t3.oversale-t3.bgo_plan+t3.o_plan)h2       
      group by h2.flight_no,h2.flights_segment_name,h2.flight_date,h2.segment_type,h2.adhead)h3
      left JOIN(
      
      select tt1.flight_no,tt2.flights_segment_name,
      case when lastnum>0 then  nvl(lastfee,0)/lastnum 
      else 0 end lastnum,
      case when thisnum>0 then  nvl(thisfee,0)/thisnum 
      else 0 end thisnum
      from(
      select t3.flight_no,t3.flights_segment_name,
      sum(case when t3.flight_date>=add_months(last_day(trunc(sysdate))+1,-2) and 
          t3.flight_date< add_months(last_day(trunc(sysdate))+1,-1) then  1
          else 0 end) lastnum,
          sum(case when t3.flight_date>=add_months(last_day(trunc(sysdate))+1,-1) and 
          t3.flight_date< trunc(sysdate) then  1
          else 0 end) thisnum                       
       from dw.fact_order_detail t1
       join dw.da_flight t3 on t1.segment_head_id=t3.segment_head_id
             where t3.flight_date>=add_months(last_day(trunc(sysdate))+1,-2)
             and  t3.flight_date< trunc(sysdate)+7
             and  t3.company_id=0
             and t1.seats_name not in('B','G1','G2','G')          
             and t3.flag=0
             group by t3.flight_no,t3.flights_segment_name)tt1
             
      
       left join(      
      select t3.flight_no,t3.flights_segment_name,
          sum(case when t2.flights_date>=add_months(last_day(trunc(sysdate))+1,-2) and 
          t2.flights_date< add_months(last_day(trunc(sysdate))+1,-1) then   t2.book_fee 
          else 0 end) lastfee,
          sum(case when t2.flights_date>=add_months(last_day(trunc(sysdate))+1,-1) and 
          t2.flights_date< trunc(sysdate) then   t2.book_fee 
          else 0 end) thisfee                       
            from dw.fact_other_order_detail t2 
            join dw.da_flight t3 on t2.segment_head_id=t3.segment_head_id            
            where t2.flights_date>=add_months(last_day(trunc(sysdate))+1,-2)
             and  t2.flights_date< trunc(sysdate)+7
             and  t2.company_id=0
             and t2.seats_name not in('B','G1','G2','G')
             and t2.xtype_id not in(24,25,34)
             group by t3.flight_no,t3.flights_segment_name)tt2 on tt1.flight_no =tt2.flight_no
             and tt1.flights_segment_name=tt2.flights_segment_name )h4 on h4.flight_no =h3.flight_no
             and h4.flights_segment_name=h3.flights_segment_name
          
