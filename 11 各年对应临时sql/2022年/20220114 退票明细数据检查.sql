select hb1.*,hb2.drawback_rate ��Ʊ�������,hb1.��ƱƱ����*hb2.drawback_rate Ӧ����Ʊ������
from(
select t1.flights_order_head_id ��Ʊ���,
t1.flights_order_id ������,
t9.order_date,
t1.money_date ��Ʊ����ʱ��,
t2.flight_date ��������,
t2.flights_segment_name ����,
t2.area_type nationflag ,
t2.segment_country ,
case when t1.seattype='������' then '������'
else '��������' end seat_type,
case when t7.dep_time is not null then 
case when (t7.dep_time-t2.origin_std)*24*60< 15 then '����15��������'
when (t7.dep_time-t2.origin_std)*24*60>=15 and (t7.dep_time-t2.origin_std)*24*60< 90 then '15min~90min'
when (t7.dep_time-t2.origin_std)*24*60>=90 and (t7.dep_time-t2.origin_std)*24< 3 then '1.5h~3h'
when (t7.dep_time-t2.origin_std)*24>=3  then '3h+'
end
else null end  focʵ���������ʱ������,
case when t1.money_fy=0 and t1.ticketprice=0 then '0Ԫ��Ʊ'
when t1.money_fy=0 and t1.ticketprice=0 then '��0Ԫ��Ʊ0Ԫ��Ʊ'
when t1.money_fy>0 then '��0Ԫ��Ʊ' end ��������,
case when t2.flag=2 then 'ȡ������'
else '��ȡ������' 
end ��������,
case when t2.area_type ='����' then
case when t1.origin_std-t1.money_date<0 then '��վ��'
when (t1.origin_std-t1.money_date)*24<2 then '[0h,2h)'
when (t1.origin_std-t1.money_date)*24<24 then '[2h,1D)'
when (t1.origin_std-t1.money_date)<3 then '[1D,3D)'
when (t1.origin_std-t1.money_date)<7 then '[3D,7D)'
when (t1.origin_std-t1.money_date)>=7 then '7D+' end 
when t2.area_type ='����' then
case when t1.origin_std-t1.money_date<0 then '��վ��'
when (t1.origin_std-t1.money_date)<1 then '[0,1D)'
when (t1.origin_std-t1.money_date)<3 then '[1D,3D)'
when (t1.origin_std-t1.money_date)<7 then '[3D,7D)'
when (t1.origin_std-t1.money_date)<15 then '[7D,15D)'
when (t1.origin_std-t1.money_date)<30 then '[15D,30D)'
when (t1.origin_std-t1.money_date)>=30 then '30D+' end 
else null end priod_date,
case when t1.seats_name in('Y','W') then 'YW'
when t1.seats_name in('S','H','V','K','L','M') then 'SHVKLM'
when t1.seats_name in('N','Q','T','X','U','E') then 'NQTXUE'
when t1.seats_name in('R1','R2','R3','R4') then 'R1R2R3R4'
when t1.seats_name in('P','P1','P2','P3','P4','P5') then 'PP1P2P3P4P5'
when t1.seats_name in('B','G','G1','G2','O') then 'BGO'
else '����' end ��Ʊ��ǰ��,nvl(t1.seats_name,'YE')  seats_name,
t1.apply_memo ��������,
t1.apply_user ������,
t11.terminal ��Ʊ�����ն�,
case when t1.money_terminal<0 then '������Ʊ'
 when t1.money_terminal> 0 then '������Ʊ'  end  ��Ʊ����,
t6.unnormaltype ��������������,
t6.reason ��������������,
t6.PUBLISH_DATE �����������ʼ����ʱ��,
t6.LAST_PUBLISH ������������󷢲�ʱ��,
t6.DELAY_HOUR ����Сʱ,
case when t6.PUBLISH_DATE is not null and t1.money_date >=t6.PUBLISH_DATE and t6.unnormaltype='����'
and t6.DELAY_HOUR>=3 then '���������淢��������3Сʱ���ϲ�����Ʊ'
when t6.PUBLISH_DATE is not null and t1.money_date >=t6.PUBLISH_DATE and t6.unnormaltype='����'
and t6.DELAY_HOUR>=1.5 then '���������淢��������90���ӵ�3Сʱ���ϲ�����Ʊ'
 when t6.PUBLISH_DATE is not null and  t1.money_date>=t6.PUBLISH_DATE and t6.unnormaltype='����'
and t6.DELAY_HOUR>=0.25 and t6.DELAY_HOUR< 1.5 then '���������淢��������15���ӵ�90���Ӳ�����Ʊ'
when t6.PUBLISH_DATE is not null and t1.money_date>=t6.PUBLISH_DATE and t6.unnormaltype='����'
 then '���������淢�����������������Ʊ'
 when t6.PUBLISH_DATE is not null and t1.money_date>=t6.PUBLISH_DATE
 then '���������淢��������������Ʊ'
 else null end ����Сʱ����,
case when t9.is_wf=1 and t9.is_qu_hui=1 then '����-ȥ��'
when t9.is_wf=1 and t9.is_qu_hui=1 then '����-����'
when t9.is_wf=1 and t9.is_qu_hui=1 then '����-����'
when t9.IS_LC=1 and t9.wf_lc_father_id=nvl(t9.LC_FATHER_ID,0) then '����-��һ��'
when t9.IS_LC=1  then '����-�ڶ���'
else '-' end ������Ʊ,
t1.money_fy ��Ʊ������,
t1.ticketprice ��ƱƱ����,

 from dw.da_order_drawback t1
 join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
 left join dw.dim_segment_type t3 on t2.h_route_id=t3.h_route_id and t2.route_id=t3.route_id
 left join hdb.cq_airport t4 on t2.originairport=t4.threecodeforcity
 left join hdb.cq_airport t5 on t2.destairport=t5.threecodeforcity
left join (select distinct order_head_id
 from cqsale.cq_free_change_log@to_air
 where state in(1,2))t8 on t8.order_head_id=t1.flights_order_head_Id
 left join dw.fact_recent_order_detail t9 on t1.flights_order_head_id=t9.flights_order_head_id
 left join dw.da_order_change t10  on t1.segment_head_id=t10.new_segment_id and t1.flights_order_head_id=t10.flights_order_head_id
 left join stg.s_cq_terminal t11 on t11.terminal_id=t1.money_terminal
 left join (select *
from(
select t1.segment_head_id,t1.unnormaltype,t1.reason,t1.PUBLISH_DATE,t1.LAST_PUBLISH,t1.DELAY_HOUR,
row_number()over(partition by segment_head_id
order by t1.last_publish desc) rid
from dw.tw_unnormal_flight t1)h1
where h1.rid=1) t6 on t1.segment_head_id=t6.segment_head_id
left join dw.da_foc_flight t7 on t1.segment_head_id=t7.segment_head_id
  where t1.money_date>=date'2022-01-03'
 and t1.money_date< date'2022-01-09'+1
 and t2.company_id=0
     )hb1
left join dw.dim_tq_history_rule hb2 on hb1.nationflag=hb2.nationflag 
and hb1.seat_type=hb2.seat_type and hb1.priod_date=hb2.priod_type and hb1.seats_name=hb2.seats_name
and hb1.segment_country=nvl(hb2.segment_country,hb1.segment_country)
and trunc(hb1.order_date)>=hb2.begin_date and trunc(hb1.order_date)<=nvl(hb2.end_date,trunc(sysdate))
