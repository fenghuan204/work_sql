select /*+parallel(4) */
hb2.smonth,hb2.flights_segment_name,hb2.nationflag,hb2.segment_country,
hb2.seat_type,hb2.focʵ���������ʱ��,hb2.apply_memo,hb2.��������,hb2.��������,hb2.priod_date,
hb2.��Ʊ����,hb2.apply_user,
case when hb2.DELAY_HOUR>=0.25 and hb2.DELAY_HOUR< 1.5 then '15m~90m'
when hb2.DELAY_HOUR>=1.5 and hb2.DELAY_HOUR< 3 then '1.5h~3h' 
when hb2.DELAY_HOUR>=3 and hb2.DELAY_HOUR< 5 then '3h~5h' 
when hb2.DELAY_HOUR>=5  then '5h' 
else 'δ�ӳ�' end ���󺽰�ʱ������,
hb2.����ʱ������,
hb2.�շ�����,
sum(hb2.money_fy) money_fy,
sum(hb2.ticketprice) ticketprice,
sum(hb2.ys_fee) ys_fee,
count(distinct hb2.flights_order_head_id) ��Ʊ��,
sum(hb2.ys_fee)-sum(hb2.money_fy) ������
from (
select hb1.*,hb2.drawback_rate,case when hb1.ticketprice=0 then '0Ԫ��Ʊ'
 when hb1.money_fy=0 then '0Ԫ�շ�'
when hb1.ticketprice>0 and hb1.money_fy=hb1.ticketprice*hb2.drawback_rate then '�����շ�'
when hb1.ticketprice>0 and hb1.money_fy> hb1.ticketprice*hb2.drawback_rate then '���շ�'
when hb1.ticketprice>0 and hb1.money_fy< hb1.ticketprice*hb2.drawback_rate then '���շ�'
else '�����շ�'
end �շ�����,nvl(hb1.ticketprice*hb2.drawback_rate,hb1.money_fy) ys_fee

from(
select t1.flights_order_head_id,
to_char(t1.money_date,'yyyymm') smonth,
t9.r_order_date ,
t1.money_date,
t2.flight_date,
t2.flights_segment_name,
t2.area_type nationflag,
t2.segment_country,
case when t1.seattype='������' then '������'
else '��������' end seat_type,
case when t7.dep_time is not null then 
case when (t7.dep_time-t2.origin_std)*24*60< 15 then '����15��������'
when (t7.dep_time-t2.origin_std)*24*60>=15 and (t7.dep_time-t2.origin_std)*24*60< 90 then '15min~90min'
when (t7.dep_time-t2.origin_std)*24*60>=90 and (t7.dep_time-t2.origin_std)*24< 3 then '1.5h~3h'
when (t7.dep_time-t2.origin_std)*24>=3  then '3h+'
end
else null end  focʵ���������ʱ��,
case when t1.money_fy=0 and t1.ticketprice=0  and t1.seats_name in('O','D') then 'OD��Ʊ'
when t1.money_fy=0 and t1.ticketprice=0   then '��Ʊ��Ʊ'
when t1.money_fy=0  then '0Ԫ��Ʊ'
when t1.money_fy>0 then '��0Ԫ��Ʊ' end ��������,
case when t2.flag=2 then 'ȡ������'
when t6.unnormaltype is not null then t6.unnormaltype
else '��������' end ��������,
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
nvl(t1.seats_name,'YE') seats_name,
t1.flights_order_id,
case when t1.apply_memo  like '%����%' then '�ÿ�--�����ع�'
when t1.apply_memo  like '%����%' then '�ÿ�--�����ع�'
when t1.apply_memo  like '%�ع�%' then '�ÿ�--�����ع�'
when t1.apply_memo  like '%�ع�%' then '�ÿ�--�����ع�'
when t1.apply_memo  like '%�ض�%' then '�ÿ�--�����ع�'
when t1.apply_memo  like '%�¶���%' then '�ÿ�--�����ع�'
when t1.apply_memo  like '%���¶���%' then '�ÿ�--�����ع�'
when t1.apply_memo  like '%�ظ���Ʊ%' then '�ÿ�--�����ع�'
when t1.apply_memo  like '%���¹�Ʊ%' then '�ÿ�--�����ع�'
when t1.apply_memo  like '%�ظ���Ʊ%' then '�ÿ�--�����ع�'
when t1.apply_memo  like '%����ѡ��%' then '�ÿ�--�����ع�'
when t1.apply_memo  like '%�¶���%' then '�ÿ�--�����ع�'
when t1.apply_memo  like '%����%' then '�ÿ�--�����ع�'
when t1.apply_memo  like '%ԭ����%' then '�ÿ�--�����ع�'
when t1.apply_memo  like '%ԭ����%' then '�ÿ�--�����ع�'
when t1.apply_memo  like '%����%' then '�ÿ�--�����ع�'
when t1.apply_memo  like '%����%' then '�ÿ�--������ͯӤ��'
when t1.apply_memo  like '%����%' then '�ÿ�--������ͯӤ��'
when t1.apply_memo  like '%©��%' then '�ÿ�--������ͯӤ��'
when t1.apply_memo  like '%�����%' then '�ÿ�--�����'
when t1.apply_memo  like '%���%' then '�ÿ�--�����'
when t1.apply_memo  like '%��ȼ��%' then '����--ȼ������'
when t1.apply_memo  like '%ȼ������%' then '����--ȼ������'
when t1.apply_memo  like '%ȼ��%' then '����--ȼ������'
when t1.apply_memo  like '%����%' then '��˾--��������'
when t1.apply_memo  like '%����ȡ��%' then '��˾--����ȡ��'
when t1.apply_memo  like '%�س�ȡ��%' then '��˾--����ȡ��'
when t1.apply_memo  like '%ȥ�̺�ȡ%' then '��˾--����ȡ��'
when t1.apply_memo  like '%ȡ������%' then '��˾--����ȡ��'
when t1.apply_memo  like '%��%ȡ��%' then '��˾--����ȡ��'
when t1.apply_memo  like '%�س�%ȡ��%' then '��˾--����ȡ��'
when t1.apply_memo  like '%ȥ��%ȡ��%' then '��˾--����ȡ��'
when t1.apply_memo  like '%��һ��%ȡ��%' then '��˾--����ȡ��'
when t1.apply_memo  like '%�ڶ���%ȡ��%' then '��˾--����ȡ��'
when t1.apply_memo  like '%��һ��%ȡ��%' then '��˾--����ȡ��'
when t1.apply_memo  like '%�ڶ���%ȡ��%' then '��˾--����ȡ��'
when t1.apply_memo  like '%ǰ��%ȡ��%' then '��˾--����ȡ��'
when t1.apply_memo  like '%���%ȡ��%' then '��˾--����ȡ��'
when t1.apply_memo  like '%ȥȡ��%' then '��˾--����ȡ��'
when t1.apply_memo  like '%ȥ��ȡ��%' then '��˾--����ȡ��'
when t1.apply_memo  like '%����ȡ��%' then '��˾--����ȡ��'
when t1.apply_memo  like '%ȡ��%' and t2.flag=2 then '��˾--����ȡ��'
when t1.apply_memo  like '%���౸��%' then '��˾--���౸��'
when t1.apply_memo  like '%����%' then '��˾--���౸��'
when t1.apply_memo  like '%����Ľ�%' then '��˾--���౸��'
when t1.apply_memo  like '%����ʱ�����%' then '��˾--����ʱ�̵���'
when t1.apply_memo  like '%ʱ�̵���%' then '��˾--����ʱ�̵���'
when t1.apply_memo  like '%ʱ�̱��%' then '��˾--����ʱ�̵���'
when t1.apply_memo  like '%ʱ��%' then '��˾--����ʱ�̵���'
when t1.apply_memo  like '%����%' then '��˾--���ಹ��'
when t1.apply_memo  like '%�۸���ˮ%' then '��˾--�۸���ˮ'
when t1.apply_memo  like '%�۸��½�%' then '��˾--�۸���ˮ'
when t1.apply_memo  like '%��ˮ%' then '��˾--�۸���ˮ'
when t1.apply_memo  like '%����%' then '�ÿ�--����'
when t1.apply_memo  like '%��Ѫ%' then '�ÿ�--����'
when t1.apply_memo  like '%���ಡ%' then '�ÿ�--����'
when t1.apply_memo  like '%ʳ���ж�%' then '�ÿ�--����'
when t1.apply_memo  like '%�и�%' then '�ÿ�--����'
when t1.apply_memo  like '%����%' then '�ÿ�--����'
when t1.apply_memo  like '%����%' then '�ÿ�--����'
when t1.apply_memo  like '%��θ��%' then '�ÿ�--����'
when t1.apply_memo  like '%����%' then '�ÿ�--����'
when t1.apply_memo  like '%��%' then '�ÿ�--����'
when t1.apply_memo  like '%����%' then '�ÿ�--����'

when t1.apply_memo  like '%����%' then '����'
when t1.apply_memo  like '%�¹�%' then '����'
when t1.apply_memo  like '%����%��Ȩ%' then '����'
when t1.apply_memo  like '%������Ȩ%' then '����'
when t1.apply_memo  like '%�г̿�%' then '����'
when t1.apply_memo  like '%����%' then '����'
when t1.apply_memo  like '%����%' then '����'
when t1.apply_memo  like '%�þ�ʷ%' then '����'
when t1.apply_memo  like '%����ʷ%' then '����'
when t1.apply_memo  like '%����%' then '����'
when t1.apply_memo  like '%�г���%' then '����'
when t1.apply_memo  like '%�ֿ�%' then '�������--�ֿ�ͬ��'
when t1.apply_memo  like '%����޸ķ�%' then '�������--����޸ķ���'
when t1.apply_memo  like '%Ͷ��%' then 'Ͷ�ߴ���'
when t1.apply_memo  like '%�г���%ͬ��%' then 'Ͷ�ߴ���'
when t1.apply_memo  like '%����ʦ%' then 'Ͷ�ߴ���'
when t1.apply_memo  like '%Ӧ��ʦ%' then 'Ͷ�ߴ���'
when t1.apply_memo  like '%½��%' then 'Ͷ�ߴ���'
when t1.apply_memo  like '%��Ӣ%' then 'Ͷ�ߴ���'
when t1.apply_memo  like '%Ӧ�ŵ�%' then 'Ͷ�ߴ���'
when t1.apply_memo  like '%����ʦ%' then 'Ͷ�ߴ���'
when t1.apply_memo  like '%����ï%' then 'Ͷ�ߴ���'
when t1.apply_memo  like '%������%' then 'Ͷ�ߴ���'
when t1.apply_memo  like '%����ʦ%' then 'Ͷ�ߴ���'
when t1.apply_memo  like '%����%' then 'Ͷ�ߴ���'

when t1.apply_memo  like '%����%' then '�ÿ�--�����ع�'
when t1.apply_memo  like '%���%' then '�ÿ�--�����ع�'
when t1.apply_memo  like '%����ͯ%' then '�ÿ�--������ͯӤ��'
when t1.apply_memo  like '%���ౣ��%' then '��˾--���ౣ��'
when t1.apply_memo  like '%ȥ��%����%' then '��˾--���ౣ��'
when t1.apply_memo  like '%ȡ��%����%' then '��˾--���ౣ��'
when t1.apply_memo  like '%ǰ��%����%' then '��˾--���ౣ��'
when t1.apply_memo  like '%���%����%' then '��˾--���ౣ��'
when t1.apply_memo  like '%����������%' then '��˾--���ౣ��'
when t1.apply_memo  like '%�������಻����%' then '��˾--���ౣ��'
when t1.apply_memo  like '%ȡ����������%' then '��˾--���ౣ��'
when t1.apply_memo  like '%���ౣ��������%' then '��˾--���ౣ��'
when t1.apply_memo  like '%�������಻��%' then '��˾--���ౣ��'
when t1.apply_memo  like '%��������%' then '��˾--���ౣ��'
when t1.apply_memo  like '%��������%' then '��˾--���ౣ��'
when t1.apply_memo  like '%����%' then '��˾--���ౣ��'
when t1.apply_memo  like '%����������%' then '��˾--����������'
when t1.apply_memo  like '%��ͣ����%' then '��˾--����������'
when t1.apply_memo  like '%ȥ�̲�����%' then '��˾--����������'
when t1.apply_memo  like '%����ͣ��%' then '��˾--����������'
when t1.apply_memo  like '%ǰ�β�����%' then '��˾--����������'
when t1.apply_memo  like '%�������س�%' then '��˾--����������'
when t1.apply_memo  like '%���಻����%' then '��˾--����������'
when t1.apply_memo  like '%ֹͣ����%' then '��˾--����������'
when t1.apply_memo  like '%������%' then '��˾--����������'
when t1.apply_memo  like '%ͣ��%' then '��˾--����������'
when t1.apply_memo  like '%����%' then '�ÿ�--����'
when t1.apply_memo  like '%��Σ%' then '�ÿ�--����'
when t1.apply_memo  like '%����%' then '�����¼�'
when t1.apply_memo  like '%����%' then '�����¼�'
when t1.apply_memo  like '%����%' then '�����¼�'
when t1.apply_memo  like '%ѧ��%' then '�ÿ�--ѧ������'
when t1.apply_memo  like '%ѧУ%' then '�ÿ�--ѧ������'
when t1.apply_memo  like '%��ϵ��%' then '��ϵ��'
when t1.apply_memo  like '%����%' then '�������--������'
when t1.apply_memo  like '%2��%' then '�������--������'
when t1.apply_memo  like '%�ֿ�%' then '�������--����ͬ��'
when t1.apply_memo  like '%����%' then '�������--����ͬ��'
when t1.apply_memo  like '%�ܿ�%' then '�������--����ͬ��'
when t1.apply_memo  like '%�����˸�%' then '�����˸�����'
when t1.apply_memo  like '%�˸�����%' then '�����˸�����'
when t1.apply_memo  like '%��������%' then '�����˸�����'
when t1.apply_memo  like '%�������%' then '�����˸�����'
when t1.apply_memo  like '%������Ʊ%' then '�����˸�����'
when t1.apply_memo  like '%��Ը%' then '�ÿ���Ը'
when lower(t1.apply_memo)  like '%ziyuan%' then '�ÿ���Ը'
when t1.apply_memo  like '%��%��%' then '����'
when t1.apply_memo  like '%�� �� �� �� ȼ ��%' then '�ÿ���Ը'
when t1.apply_memo  like '%�� �� ��%' then '�ÿ���Ը'
when t1.apply_memo  like '%����%' then '�ÿ���Ը'
when t1.apply_memo  like '%�˻���%' then '�ÿ���Ը'
when t1.apply_memo  like '%tuishui%' then '�ÿ���Ը'
when t1.apply_memo  like '%�˻�����%' then '�ÿ���Ը'
when t1.apply_memo  like '%�˻�˰%' then '�ÿ���Ը'
when t1.apply_memo  like '%��˰%' then '�ÿ���Ը'
when t1.apply_memo  like '%�ƻ�˰%' then '�ÿ���Ը'
when t1.apply_memo  like '%�˻��������%' then '�ÿ���Ը'
when t1.apply_memo  like '%�˶�%' then '�ÿ�--��Ը'
when t1.apply_memo  like '%��˰%' then '�ÿ�--��Ը'
when t1.apply_memo  like '%����%' then '�ÿ�--����'
when t1.apply_memo  like '%����%' then '�ÿ�--����'
when t1.apply_memo  like '%���%' then '�ÿ�--���'
when t1.apply_memo  like '%��%' then '�ÿ�--���'
when t1.apply_memo  like '%wuji%' then '�ÿ�--���'
when t1.apply_memo  like '%©��%' then '�ÿ�--���'
when t1.apply_memo  like '%����%' then '�ÿ�--����'
when t1.apply_memo  like '%��ʧ%' then '�ÿ�--��Ʊ��ʧ'
when t1.apply_memo  like '%����%' then '����'
when lower(t1.apply_memo)  like '%test%' then '����'
when t1.apply_memo  like '%����%' then '�ÿ�--����'
when t1.apply_memo  like '%20%%' then 'Ͷ��--���������Ѵ���'
when t1.apply_memo  like '%30%%' then 'Ͷ��--���������Ѵ���'
when t1.apply_memo  like '%10%%' then 'Ͷ��--���������Ѵ���'
when t1.apply_memo  like '%5%%' then 'Ͷ��--���������Ѵ���'
when t1.apply_memo  like '%������Ʊ%' then '������Ʊ'
when t1.apply_memo  like '%��Ȩ%' then '����'
else  '����ԭ��'  end apply_memo,
t1.apply_user,
case when t1.money_terminal< 0 then '����'
when t1.money_terminal>0 then '����' end ��Ʊ����,
t6.unnormaltype ����������,
t6.reason,
t6.PUBLISH_DATE,
t6.LAST_PUBLISH,
t6.DELAY_HOUR,
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
 else null end ����ʱ������,
t1.money_fy,
t1.ticketprice
 from dw.da_order_drawback t1
 join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
 left join dw.dim_segment_type t3 on t2.h_route_id=t3.h_route_id and t2.route_id=t3.route_id
 left join hdb.cq_airport t4 on t2.originairport=t4.threecodeforcity
 left join hdb.cq_airport t5 on t2.destairport=t5.threecodeforcity
 left join stg.s_cq_order_head t9 on t1.flights_order_head_id=t9.flights_order_head_id
 left join (select *
from(
select t1.segment_head_id,t1.unnormaltype,t1.reason,t1.PUBLISH_DATE,t1.LAST_PUBLISH,t1.DELAY_HOUR,
row_number()over(partition by segment_head_id
order by t1.last_publish desc) rid
from dw.tw_unnormal_flight t1)h1
where h1.rid=1) t6 on t1.segment_head_id=t6.segment_head_id
left join dw.da_foc_flight t7 on t1.segment_head_id=t7.segment_head_id
  where t1.money_date>=date'2020-11-01'
 and t1.money_date< trunc(sysdate)
 and t2.company_id=0
     )hb1
left join dw.dim_tq_history_rule hb2 on hb1.nationflag=hb2.nationflag 
and hb1.seat_type=hb2.seat_type and hb1.priod_date=hb2.priod_type and hb1.seats_name=hb2.seats_name
and hb1.segment_country=nvl(hb2.segment_country,hb1.segment_country)
and trunc(hb1.r_order_date)>=hb2.begin_date and trunc(hb1.r_order_date)<=nvl(hb2.end_date,trunc(sysdate))
)hb2
group by hb2.smonth,hb2.flights_segment_name,hb2.nationflag,hb2.segment_country,
hb2.seat_type,hb2.focʵ���������ʱ��,hb2.apply_memo,hb2.��������,hb2.��������,hb2.priod_date,
hb2.��Ʊ����,hb2.apply_user,
case when hb2.DELAY_HOUR>=0.25 and hb2.DELAY_HOUR< 1.5 then '15m~90m'
when hb2.DELAY_HOUR>=1.5 and hb2.DELAY_HOUR< 3 then '1.5h~3h' 
when hb2.DELAY_HOUR>=3 and hb2.DELAY_HOUR< 5 then '3h~5h' 
when hb2.DELAY_HOUR>=5  then '5h' 
else 'δ�ӳ�' end ,
hb2.����ʱ������,
hb2.�շ�����
