select /*+parallel(4) */
hh1.syear ��,hh1.squar ����,hh1.rank �¶ȼ�,
hh1.�¶������Ͻ��׶� "01�¶������Ͻ��׶�",
hh1.�¶��ƶ����׶� "02�¶��ƶ����׶�",
hh1.�¶������Ͻ��׶� "07�¶����Ͻ��׶�",
hh1.�¶���Ӫ���׶� "08�¶���Ӫ���׶�",
hh1.�¶����ϴ����׶� "09�¶����ϴ����׶�",
hh1.�¶�B2B���׶� "10�¶�B2B���׶�",
hh1.�¶�B2C���׶� "11�¶�B2C���׶�",
hh1.�¶������Ͻ��׶� "32��������",
hh1.�¶���Ӫ���� "34�¶���Ӫ����",
hh1.�¶ȸ������� "38�¶ȸ�������",
hh1.�¶����ڽ��׶� "39�¶����ڽ��׶�",
hh1.�¶��ܶ����� "B01-1�¶��ܶ�����",
hh1.�¶��ƶ������� "B01-2�¶��ƶ�������",
hh1.�¶������Ͻ��׶�/hh2.�¶Ƚ��׶� "B02�¶����Ͻ��׶�ռ��",
hh1.���������Ͻ��׶� "01���������Ͻ��׶�",
hh1.�����ƶ����׶� "02�����ƶ����׶�",
hh1.���������Ͻ��׶� "07�������Ͻ��׶�",
hh1.������Ӫ���׶� "08������Ӫ���׶�",
hh1.�������ϴ����׶� "09�������ϴ����׶�",
hh1.����B2B���׶� "10����B2B���׶�",
hh1.����B2C���׶� "11����B2C���׶�",
hh1.���������Ͻ��׶� "32��������",
hh1.������Ӫ���� "34������Ӫ����",
hh1.���ȸ������� "38���ȸ�������",
hh1.�������ڽ��׶� "39�������ڽ��׶�",
hh1.�����ܶ����� "B01-1�����ܶ�����",
hh1.�����ƶ������� "B01-2�����ƶ�������",
hh1.���������Ͻ��׶�/hh2.���Ƚ��׶� "B02�������Ͻ��׶�ռ��"
from(
select 
h2.syear,h2.squar,h2.rank,
avg(�������Ͻ���) �¶������Ͻ��׶�,
avg(�ƶ�����) �¶��ƶ����׶�,
avg(��Ӫ���׶�) �¶���Ӫ���׶�,
avg(���ϴ����׶�) �¶����ϴ����׶�,
avg(B2G���׶�) �¶�B2B���׶�,
avg(B2C���׶�) �¶�B2C���׶�,
avg(��Ӫ����) �¶���Ӫ����,
avg(��������) �¶ȸ�������,
avg(���ڽ��׶�) �¶����ڽ��׶�,
avg(�ܽ��׶�����) �¶��ܶ�����,
avg(�ƶ����׶�����) �¶��ƶ�������,

sum(�������Ͻ���) ���������Ͻ��׶�,
sum(�ƶ�����) �����ƶ����׶�,
sum(��Ӫ���׶�) ������Ӫ���׶�,
sum(���ϴ����׶�) �������ϴ����׶�,
sum(B2G���׶�) ����B2B���׶�,
sum(B2C���׶�) ����B2C���׶�,
sum(��Ӫ����) ������Ӫ����,
sum(��������) ���ȸ�������,
sum(���ڽ��׶�) �������ڽ��׶�,
sum(�ܽ��׶�����) �����ܶ�����,
sum(�ƶ����׶�����) �����ƶ�������

from(
select h1.*,listagg(smonth,',') within GROUP (order by smonth) over (partition by h1.syear,h1.squar) rank
from(
SELECT to_char(t1.flights_date,'yyyy') syear,
TO_CHAR (t1.flights_date, 'q') squar,TO_CHAR (t1.flights_date, 'yyyymm') smonth,
sum(t1.ticket_price+t1.ad_fy+t1.port_pay+t1.insurce_fee+t1.other_fee+t1.other_fy+t1.sx_fy) �������Ͻ���,
sum(case when t1.station_id>1 then t1.ticket_price+t1.ad_fy+t1.port_pay+t1.insurce_fee+t1.other_fee+t1.other_fy+t1.sx_fy else 0 end) �ƶ�����,
sum(case when t1.channel in('��վ','�ֻ�','B2G�����ͻ�','B2B����')
 then t1.ticket_price+t1.ad_fy+t1.port_pay+t1.insurce_fee+t1.other_fee+t1.other_fy+t1.sx_fy else 0 end) ��Ӫ���׶�,
sum(case when t1.channel in('�콢��','OTA')
 then t1.ticket_price+t1.ad_fy+t1.port_pay+t1.insurce_fee+t1.other_fee+t1.other_fy+t1.sx_fy else 0 end) ���ϴ����׶�,
 sum(case when t1.channel in('B2G�����ͻ�','B2B����')
 then t1.ticket_price+t1.ad_fy+t1.port_pay+t1.insurce_fee+t1.other_fee+t1.other_fy+t1.sx_fy else 0 end) B2G���׶�,
sum(case when t1.channel in('�콢��','OTA','��վ','�ֻ�')
 then t1.ticket_price+t1.ad_fy+t1.port_pay+t1.insurce_fee+t1.other_fee+t1.other_fy+t1.sx_fy else 0 end) B2C���׶�,
 sum(t1.ticket_price+t1.ad_fy+t1.port_pay+t1.other_fy+t1.sx_fy) ��Ӫ����,
 sum(t1.insurce_fee+t1.other_fee) ��������,
 sum(case when t2.flights_city_name like '%�Ϻ�%' then t1.ticket_price+t1.ad_fy+t1.port_pay+t1.insurce_fee+t1.other_fee+t1.other_fy+t1.sx_fy
 else 0 end) ���ڽ��׶�,
 count(distinct t1.flights_order_id) �ܽ��׶�����,
 count( distinct case when t1.station_id>1 then t1.flights_order_id else null end) �ƶ����׶�����,
 sum(case when t1.channel='��վ' then  t1.ticket_price+t1.ad_fy+t1.port_pay+t1.insurce_fee+t1.other_fee+t1.other_fy+t1.sx_fy else 0 end) ��վ���׶�

  FROM DW.FACT_ORDER_DETAIL T1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  WHERE T1.FLIGHTS_DATE>=TO_DATE('2015-01-01','yyyy-mm-dd')
  and t1.flights_date< to_date('2018-10-01','yyyy-mm-dd')
  and t1.company_id=0
  and t2.flag<>2
  and t1.terminal_id<0  
  group by to_char(t1.flights_date,'yyyy'),
TO_CHAR (t1.flights_date, 'q'),TO_CHAR (t1.flights_date, 'yyyymm'))h1)h2
group by h2.syear,h2.squar,h2.rank)hh1
left join(

select 
h2.syear,h2.squar,h2.rank,
avg(�ܽ��׶�) �¶Ƚ��׶�,
sum(�ܽ��׶�) ���Ƚ��׶�
from(
select h1.*,listagg(smonth,',') within GROUP (order by smonth) over (partition by h1.syear,h1.squar) rank
from(
SELECT to_char(t1.flights_date,'yyyy') syear,
TO_CHAR (t1.flights_date, 'q') squar,TO_CHAR (t1.flights_date, 'yyyymm') smonth,
sum(t1.ticket_price+t1.ad_fy+t1.port_pay+t1.insurce_fee+t1.other_fee+t1.other_fy+t1.sx_fy) �ܽ��׶�
  FROM DW.FACT_ORDER_DETAIL T1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  WHERE T1.FLIGHTS_DATE>=TO_DATE('2015-01-01','yyyy-mm-dd')
  and t1.flights_date< to_date('2018-10-01','yyyy-mm-dd')
  and t1.company_id=0
  and t2.flag<>2
  group by to_char(t1.flights_date,'yyyy'),
TO_CHAR (t1.flights_date, 'q'),TO_CHAR (t1.flights_date, 'yyyymm'))h1)h2
group by h2.syear,h2.squar,h2.rank
)hh2 on hh1.syear=hh2.syear and hh1.squar=hh2.squar and hh1.rank=hh2.rank
