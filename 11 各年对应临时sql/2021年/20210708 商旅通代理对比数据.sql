--����ͨ����
--2�� 


select 
case when t2.originairport_name in('�ֶ�','����','����','����','ʯ��ׯ','����','����')  then t2.originairport_name
else '-' end originairport_name,
case when t2.destairport_name in('�ֶ�','����','����','����','ʯ��ׯ','����','����')  then t2.destairport_name
else '-' end destairport_name,
case when t1.ahead_days< 5 then '00~05'
         when t1.ahead_days< 10 then '05~10'
       when t1.ahead_days< 15 then '10~15'
       when t1.ahead_days< 20 then '15~20'
       when t1.ahead_days>=20 then '20+' end 
 ��ǰ��, 
 decode(t3.gender,0,'-',1,'��',2,'Ů') �Ա�,
 case when t3.age<20 then '00~20'
         when t3.age<30 then '20~30'
       when t3.age<40 then '30~40'
       when t3.age<50 then '40~50'
       when t3.age<60 then '50~60'
       when t3.age>=60 then '60+' end,
   case when t3.cust_province like '%����%' then '����'
   when t3.cust_province like '%����%' then '����'
   when t3.cust_province like '%�Ĵ�%' then '�Ĵ�'
   when t3.cust_province like '%�ӱ�%' then '�ӱ�'
   when t3.cust_province like '%����%' then '����'
   when t3.cust_province like '%������%' then '������'
   when t3.cust_province like '%�㶫%' then '�㶫'
   else '--' end ,
   count(1)

 from dw.fact_order_detail t1
 join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
 left join dw.bi_order_region t3 on t1.flights_order_head_id=t3.flights_order_head_id
 where t1.order_day>=trunc(sysdate)-180
  and t1.order_day< trunc(sysdate)
  and t2.flag=0
  and t1.whole_flight like '9C%'
  and t1.seats_name not in('B','G1','G','G2','O')
  and t1.seats_name is not null 
  group by case when t2.originairport_name in('�ֶ�','����','����','����','ʯ��ׯ','����','����')  then t2.originairport_name
else '-' end ,
case when t2.destairport_name in('�ֶ�','����','����','����','ʯ��ׯ','����','����')  then t2.destairport_name
else '-' end ,
case when t1.ahead_days<5 then '00~05'
         when t1.ahead_days<10 then '05~10'
       when t1.ahead_days<15 then '10~15'
       when t1.ahead_days<20 then '15~20'
       when t1.ahead_days>=20 then '20+' end 
 , 
 decode(t3.gender,0,'-',1,'��',2,'Ů') ,
 case when t3.age<20 then '00~20'
         when t3.age<30 then '20~30'
       when t3.age<40 then '30~40'
       when t3.age<50 then '40~50'
       when t3.age<60 then '50~60'
       when t3.age>=60 then '60+' end,
   case when t3.cust_province like '%����%' then '����'
   when t3.cust_province like '%����%' then '����'
   when t3.cust_province like '%�Ĵ�%' then '�Ĵ�'
   when t3.cust_province like '%�ӱ�%' then '�ӱ�'
   when t3.cust_province like '%����%' then '����'
   when t3.cust_province like '%������%' then '������'
   when t3.cust_province like '%�㶫%' then '�㶫'
   else '--' end
