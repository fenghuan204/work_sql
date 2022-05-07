/*
--���ʺ���OTA����OTA��Ʊ��������ƽ��Ʊ��

select \*+parallel(4) *\
trunc(t1.flights_date,'mm') �·�,case when t1.channel in('OTA','�콢��') then 'OTA'
else '��OTA' end ����,
count(1) ��������,sum(t1.ticket_price) ���ʽ��
 from dw.fact_order_detail t1
 where  t1.flights_date>=to_date('2018-01-01','yyyy-mm-dd')
 and t1.flights_date< to_date('2018-05-01','yyyy-mm-dd')
 and t1.company_id=0
 and t1.flag_id=40
 and t1.seats_name not in('B','G','G1','G2','O')
 and t1.nationflag in('����','����')
 group by trunc(t1.flights_date,'mm'),case when t1.channel in('OTA','�콢��') then 'OTA'
else '��OTA' end;
 
 

 --���ں���OTA����OTA��Ʊ��������ƽ��Ʊ��
 
 select \*+parallel(4) *\
trunc(t1.flights_date,'mm') �·�,case when t1.channel in('OTA','�콢��') then 'OTA'
else '��OTA' end ����,
count(1) ��������,sum(t1.ticket_price) ���ڽ��,sum(t1.price) �����񺽹�����
 from dw.fact_order_detail t1
 where  t1.flights_date>=to_date('2018-01-01','yyyy-mm-dd')
 and t1.flights_date< to_date('2018-05-01','yyyy-mm-dd')
 and t1.company_id=0
  and t1.seats_name not in('B','G','G1','G2','O')
  and t1.nationflag='����'
  and t1.flag_id=40
 group by trunc(t1.flights_date,'mm') ,case when t1.channel in('OTA','�콢��') then 'OTA'
else '��OTA' end;
 

---��������

select \*+parallel(4) *\
trunc(t1.flights_date,'mm') �·�,case when t1.channel in('OTA','�콢��') then 'OTA'
else '��OTA' end ����,
count(1) ����,sum(t1.ticket_price) ���
 from dw.fact_order_detail t1
 where t1.flights_date>=to_date('2018-01-01','yyyy-mm-dd')
 and t1.flights_date< to_date('2018-05-01','yyyy-mm-dd')
 and t1.company_id=0
 and t1.flag_id=40
  and t1.seats_name not in('B','G','G1','G2','O')
 group by trunc(t1.flights_date,'mm'),case when t1.channel in('OTA','�콢��') then 'OTA'
else '��OTA' end;*/


----- �ۼ�����

select /*+parallel(4) */ *
from 
(select 
case when t1.nationflag in('����','����') then '����'
else '����' end nationflag,trunc(t1.flights_date,'mm') month,
sum(case when t1.channel in('OTA','�콢��') then 1 else 0 end) ota_num,
sum(case when t1.channel in('OTA','�콢��') then 0 else 1 end) nota_num,
count(1) totalnum,
sum(case when t1.channel in('OTA','�콢��') then t1.ticket_price else 0 end) ota_price,
sum(case when t1.channel in('OTA','�콢��') then 0 else t1.ticket_price end) nota_price,
sum(t1.ticket_price) totalprice,
sum(case when t1.channel in('OTA','�콢��') then t1.price else 0 end) ota_all,
sum(case when t1.channel in('OTA','�콢��') then 0 else t1.price end) nota_all,
sum(t1.price) totalall
 from dw.fact_order_detail t1
 where t1.flights_date>=to_date('2020-01-01','yyyy-mm-dd')
 and t1.flights_date< trunc(sysdate,'mm')
 and t1.company_id=0
 and t1.flag_id=40
  and t1.seats_name not in('B','G','G1','G2','O')
 group by rollup(case when t1.nationflag in('����','����') then '����'
else '����' end ,trunc(t1.flights_date,'mm')))h1
where month=trunc(trunc(sysdate,'mm')-1,'mm')
or month is null
order by nationflag,month


