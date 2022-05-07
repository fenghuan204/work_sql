select trunc(t1.money_date),case when t2.flag=2 then 'ȡ������'
when t2.flag=0 then '��������'
else '��������' end ��������,
case when t1.seats_name in('B','G','G1','G2','O') then 'BGO'
else '��BGO' end ��λ����,
case when t3.flights_order_id is not null then '��Ʊ'
when t1.money_fy = 0 then '0Ԫ��Ʊ'
when t1.money_fy > 0 then '������Ʊ' end ��Ʊ����,
case when t4.province||t5.province  like '%�ӱ�%' then '�ӱ�'
when t4.province||t5.province  like '%����%' then '����'
when t4.province||t5.province  like '%������%' then '������'
when t4.province||t5.province  like '%ɽ��%' then 'ɽ��'
else '��������' end ����,
replace(replace(t6.wf_segment,'�ֶ�','�Ϻ�'),'����','�Ϻ�') ��������,
case when  trunc(t1.origin_std) < to_date('2021-01-28','yyyy-mm-dd') then '����ǰ'
when trunc(t1.origin_std) >=to_date('2021-02-09','yyyy-mm-dd')
      and trunc(t1.origin_std) <=to_date('2021-02-19','yyyy-mm-dd') then '����0209~0219'
when trunc(t1.origin_std) >=to_date('2021-01-28','yyyy-mm-dd')
      and trunc(t1.origin_std) <=to_date('2021-03-08','yyyy-mm-dd') then '������������'
when trunc(t1.origin_std) > to_date('2021-03-08','yyyy-mm-dd')
and trunc(t1.origin_std) <=to_date('2021-03-31','yyyy-mm-dd')
then '���˺�3��'
when trunc(t1.origin_std) >=to_date('2021-04-01','yyyy-mm-dd')
and trunc(t1.origin_std) < =to_date('2021-04-30','yyyy-mm-dd')
then '2021��4��'
when trunc(t1.origin_std) > to_date('2021-04-30','yyyy-mm-dd')
then '2021��4���Ժ�' end ������������,
case when t1.origin_std-t1.money_date < =0 then '��վ��'
when t1.origin_std-t1.money_date <=0.5 then '��0,12H]'
when t1.origin_std-t1.money_date <=1 then '��12,24H]'
when t1.origin_std-t1.money_date <=3 then '��1,3D]'
when t1.origin_std-t1.money_date <=7 then '��3,7D]'
when t1.origin_std-t1.money_date <=15 then '��7,15D]'
when t1.origin_std-t1.money_date <=30 then '��15,30D]'
when t1.origin_std-t1.money_date <=60 then '��30,60D]'
when t1.origin_std-t1.money_date > 60 then '60+' end ��Ʊ��ǰ�ڷֲ�,
count(1) ��Ʊ��,
sum(t1.money_fy) ��Ʊ���
  from dw.da_order_drawback t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  left join dw.fact_combo_ticket t3 on t1.flights_order_head_Id=t3.flights_order_head_Id
  left join hdb.cq_airport t4 on t2.originairport=t4.threecodeforcity
  left join hdb.cq_airport t5 on t2.destairport=t5.threecodeforcity
  left join dw.dim_segment_type t6 on t2.h_route_id=t6.h_route_id and t2.route_id=t6.route_id
  where t1.money_date>=to_date('2020-12-01','yyyy-mm-dd')
    and t1.money_date< to_date('2021-01-21','yyyy-mm-dd')
    and t1.seats_name is not null
  group by trunc(t1.money_date),case when t2.flag=2 then 'ȡ������'
when t2.flag=0 then '��������'
else '��������' end ,
case when t1.seats_name in('B','G','G1','G2','O') then 'BGO'
else '��BGO' end ,
case when t3.flights_order_id is not null then '��Ʊ'
when t1.money_fy = 0 then '0Ԫ��Ʊ'
when t1.money_fy > 0 then '������Ʊ' end ,
case when t4.province||t5.province  like '%�ӱ�%' then '�ӱ�'
when t4.province||t5.province  like '%����%' then '����'
when t4.province||t5.province  like '%������%' then '������'
when t4.province||t5.province  like '%ɽ��%' then 'ɽ��'
else '��������' end ,
case when  trunc(t1.origin_std) < to_date('2021-01-28','yyyy-mm-dd') then '����ǰ'
when trunc(t1.origin_std) >=to_date('2021-02-09','yyyy-mm-dd')
      and trunc(t1.origin_std) <=to_date('2021-02-19','yyyy-mm-dd') then '����0209~0219'
when trunc(t1.origin_std) >=to_date('2021-01-28','yyyy-mm-dd')
      and trunc(t1.origin_std) <=to_date('2021-03-08','yyyy-mm-dd') then '������������'
when trunc(t1.origin_std) > to_date('2021-03-08','yyyy-mm-dd')
and trunc(t1.origin_std) <=to_date('2021-03-31','yyyy-mm-dd')
then '���˺�3��'
when trunc(t1.origin_std) >=to_date('2021-04-01','yyyy-mm-dd')
and trunc(t1.origin_std) < =to_date('2021-04-30','yyyy-mm-dd')
then '2021��4��'
when trunc(t1.origin_std) > to_date('2021-04-30','yyyy-mm-dd')
then '2021��4���Ժ�' end ,
replace(replace(t6.wf_segment,'�ֶ�','�Ϻ�'),'����','�Ϻ�'),
case when t1.origin_std-t1.money_date < =0 then '��վ��'
when t1.origin_std-t1.money_date <=0.5 then '��0,12H]'
when t1.origin_std-t1.money_date <=1 then '��12,24H]'
when t1.origin_std-t1.money_date <=3 then '��1,3D]'
when t1.origin_std-t1.money_date <=7 then '��3,7D]'
when t1.origin_std-t1.money_date <=15 then '��7,15D]'
when t1.origin_std-t1.money_date <=30 then '��15,30D]'
when t1.origin_std-t1.money_date <=60 then '��30,60D]'
when t1.origin_std-t1.money_date > 60 then '60+' end;
