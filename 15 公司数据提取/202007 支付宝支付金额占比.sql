/*ϲ��������֧�������Ǹ�����æ��һ��Excelͳ��һ�����ܵķݶ
�ݶ���ô���� ֧�����ĺ�֧�������ߵġ�΢��֧���ĺϼ���һ����100%��Ȼ��֧�����ϼƵ�ռ����ı���*/
--ϲ����7.27-8.9��8.10-8.23��֧������ ��һ��

select t1.order_day ��������,case when t1.gate_name like '%΢��%' then '΢��'
when t1.gate_name like '%֧����%' then '֧����' end ֧����ʽ,t1.gate_name ֧������,
sum(t1.ticket_price+t1.port_pay+t1.ad_fy+t1.other_fy+t1.insurce_fee+t1.other_fee) ֧�����,
count(1) ��Ʊ�� ,count(distinct t1.flights_Order_id) ������,
sum(count(1))over(partition by t1.order_day ) tonum,
round(count(1)/sum(count(1))over(partition by t1.order_day )*100,2) ռ��
 from dw.fact_order_detail t1
 where t1.order_day>=trunc(sysdate)-30
   and t1.order_day< trunc(sysdate)
   and t1.gate_name in('΢��С����','�Ƹ�ͨ΢��','֧����','֧��������')
   and t1.channel in('��վ','�ֻ�')
   and t1.whole_flight like '9C%'
   group by t1.order_day,case when t1.gate_name like '%΢��%' then '΢��'
when t1.gate_name like '%֧����%' then '֧����' end,t1.gate_name
   

   
   
 
 
 
