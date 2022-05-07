select '2018��' ��,trunc(sysdate)-1  ��ֹ��������,h1.flight_date ��������,h1.segment_code ����,h1.flight_no �����,
h1.oversale �ƻ�����,h1.bgo_plan-h1.o_plan BG�ƻ���,h1.oversale-h1.bgo_plan+h1.o_plan ɢ�ͼƻ���,
nvl(h2.swnum,0) ɢ����������,nvl(h2.swprice,0) ɢ��Ʊ�ۺ�,nvl(h2.adfy,0) ɢ��ȼ�ͷ�,nvl(h2.otherfy,0) ɢ������˰��
from dw.da_flight h1
left join (
select t1.segment_head_id,sum(case when t1.seats_name not in('B','G','G1','G2') then 1 else 0 end) swnum ,
    sum(case when t1.seats_name not in('B','G','G1','G2') then t1.ticket_price else 0 end) swprice,
    sum(case when t1.seats_name not in('B','G','G1','G2') then t1.ad_fy else 0 end) adfy,
    sum(case when t1.seats_name not in('B','G','G1','G2') then t1.other_fy else 0 end) otherfy            
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  where t1.flights_date>=to_date('2018-01-20','yyyy-mm-dd')
    and t1.flights_date<=to_date('2018-03-11','yyyy-mm-dd')
    and t2.flag<>2
    and t2.nationflag in('����','����')
    and t1.order_day< trunc(sysdate)
    and t1.whole_flight like '9C%'
    group by t1.segment_head_id)h2 on h1.segment_head_id=h2.segment_head_id
    where h1.flight_date>=to_date('2018-01-20','yyyy-mm-dd')
    and h1.flight_date<=to_date('2018-03-11','yyyy-mm-dd')
    and h1.flag<>2
    and h1.nationflag in('����','����')
    and h1.company_id=0
    
    
    
   union all
   
   
   select '2017��',to_date('2016'||to_char(trunc(sysdate-1),'mmdd'),'yyyymmdd')  ��ֹ��������,h1.flight_date ��������,h1.segment_code ����,h1.flight_no �����,
h1.oversale �ƻ�����,h1.bgo_plan-h1.o_plan BG�ƻ���,h1.oversale-h1.bgo_plan+h1.o_plan ɢ�ͼƻ���,
nvl(h2.swnum,0) ɢ����������,nvl(h2.swprice,0) ɢ��Ʊ�ۺ�,nvl(h2.adfy,0) ɢ��ȼ�ͷ�,nvl(h2.otherfy,0) ɢ������˰��
from dw.da_flight h1
left join (
select t1.segment_head_id,sum(case when t1.seats_name not in('B','G','G1','G2') then 1 else 0 end) swnum ,
    sum(case when t1.seats_name not in('B','G','G1','G2') then t1.ticket_price else 0 end) swprice,
    sum(case when t1.seats_name not in('B','G','G1','G2') then t1.ad_fy else 0 end) adfy,
    sum(case when t1.seats_name not in('B','G','G1','G2') then t1.other_fy else 0 end) otherfy            
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  where t1.flights_date>=to_date('2017-01-01','yyyy-mm-dd')
    and t1.flights_date<=to_date('2017-02-20','yyyy-mm-dd')
    and t2.flag<>2
    and t2.nationflag in('����','����')
    and t1.order_day< to_date('2016'||to_char(trunc(sysdate),'mmdd'),'yyyymmdd')
    and t1.whole_flight like '9C%'
    group by t1.segment_head_id)h2 on h1.segment_head_id=h2.segment_head_id
    where h1.flight_date>=to_date('2017-01-01','yyyy-mm-dd')
    and h1.flight_date<=to_date('2017-02-20','yyyy-mm-dd')
    and h1.flag<>2
    and h1.nationflag in('����','����')
    and h1.company_id=0
   
   
   
   
    
    union all
    
    
    select '2016��',to_date('2015'||to_char(trunc(sysdate-1),'mmdd'),'yyyymmdd')  ��ֹ��������,h1.flight_date ��������,h1.segment_code ����,h1.flight_no �����,
h1.oversale �ƻ�����,h1.bgo_plan-h1.o_plan BG�ƻ���,h1.oversale-h1.bgo_plan+h1.o_plan ɢ�ͼƻ���,
nvl(h2.swnum,0) ɢ����������,nvl(h2.swprice,0) ɢ��Ʊ�ۺ�,nvl(h2.adfy,0) ɢ��ȼ�ͷ�,nvl(h2.otherfy,0) ɢ������˰��
from dw.da_flight h1
left join (
select t1.segment_head_id,sum(case when t1.seats_name not in('B','G','G1','G2') then 1 else 0 end) swnum ,
    sum(case when t1.seats_name not in('B','G','G1','G2') then t1.ticket_price else 0 end) swprice,
    sum(case when t1.seats_name not in('B','G','G1','G2') then t1.ad_fy else 0 end) adfy,
    sum(case when t1.seats_name not in('B','G','G1','G2') then t1.other_fy else 0 end) otherfy            
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  where t1.flights_date>=to_date('2016-01-12','yyyy-mm-dd')
    and t1.flights_date<=to_date('2016-03-02','yyyy-mm-dd')
    and t2.flag<>2
    and t2.nationflag in('����','����')
    and t1.order_day< to_date('2015'||to_char(trunc(sysdate),'mmdd'),'yyyymmdd')
    and t1.whole_flight like '9C%'
    group by t1.segment_head_id)h2 on h1.segment_head_id=h2.segment_head_id
    where h1.flight_date>=to_date('2016-01-12','yyyy-mm-dd')
    and h1.flight_date<=to_date('2016-03-02','yyyy-mm-dd')
    and h1.flag<>2
    and h1.nationflag in('����','����')
    and h1.company_id=0
   
      
    union all
    
    
    
     select '2015��',to_date('2014'||to_char(trunc(sysdate-1),'mmdd'),'yyyymmdd')  ��ֹ��������,h1.flight_date ��������,h1.segment_code ����,h1.flight_no �����,
h1.oversale �ƻ�����,h1.bgo_plan-h1.o_plan BG�ƻ���,h1.oversale-h1.bgo_plan+h1.o_plan ɢ�ͼƻ���,
nvl(h2.swnum,0) ɢ����������,nvl(h2.swprice,0) ɢ��Ʊ�ۺ�,nvl(h2.adfy,0) ɢ��ȼ�ͷ�,nvl(h2.otherfy,0) ɢ������˰��
from dw.da_flight h1
left join (
select t1.segment_head_id,sum(case when t1.seats_name not in('B','G','G1','G2') then 1 else 0 end) swnum ,
    sum(case when t1.seats_name not in('B','G','G1','G2') then t1.ticket_price else 0 end) swprice,
    sum(case when t1.seats_name not in('B','G','G1','G2') then t1.ad_fy else 0 end) adfy,
    sum(case when t1.seats_name not in('B','G','G1','G2') then t1.other_fy else 0 end) otherfy            
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  where t1.flights_date>=to_date('2015-01-23','yyyy-mm-dd')
    and t1.flights_date<=to_date('2015-03-14','yyyy-mm-dd')
    and t2.flag<>2
    and t2.nationflag in('����','����')
    and t1.order_day< to_date('2014'||to_char(trunc(sysdate),'mmdd'),'yyyymmdd')
    and t1.whole_flight like '9C%'
    group by t1.segment_head_id)h2 on h1.segment_head_id=h2.segment_head_id
    where h1.flight_date>=to_date('2015-01-23','yyyy-mm-dd')
    and h1.flight_date<=to_date('2015-03-14','yyyy-mm-dd')
    and h1.flag<>2
    and h1.nationflag in('����','����')
    and h1.company_id=0
   
  
