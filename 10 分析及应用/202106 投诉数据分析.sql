select to_char(cp.createtime, 'yyyymm') �·�,
       trunc(cp.createtime) ����ʱ��,
       case
         when cp.jobtypecode = 'J' then
          '����'
         when cp.jobtypecode = 'B' then
          '����'
         when cp.jobtypecode = 'T' then
          'Ͷ��'
         when cp.jobtypecode = 'P' then
          '����'
         else
          cp.jobtypecode
       end ��������,
       cp.jobnextfrom ������Ϣ��Դ�����˵�,
       case
         when cp.jobnextfrom in ('���������������̡�������', '���������������̡�������', '�񺽾�', '�񺽾֣����⣩', '�񺽾֣���������֣�',
                   '�񺽾֣���ҳ��', '�����ⲿ���罻���磩', '�Ϻ���������12345', '�Ϻ����ŷð�', '�ⲿ',
                   '�ⲿý�壨�㲥�����硢���ţ�', '����ί', '��ý��ƽ̨-FACEBOOK', '��ý��ƽ̨-����') then
          '�ⲿͶ��'
         when cp.jobnextfrom = '��������' then
          '��������'
         when cp.jobnextfrom in
              ('Android', 'IOS', 'M��', '��վ', '΢��', '�����̳�',
             '����Ͷ�߿�', '�ÿ�����', '��ý��ƽ̨-����', '�����', '�ǻۿͲ�', '�ڲ�', '�ڲ�����', '����') then
          '�ڲ�����'
         when cp.jobnextfrom in ('�ڲ���ת(����)����', '�ڲ���ת(Ͷ��)����') then
          '�ڲ���ת'
       end Ͷ����Դ����,       
       cp.complaintype1c Ͷ�������������������,
       case when cp.conetent like '%��Ʊ%' then '��Ʊ��Ʒ����'
       else cp.complaintype2c end  Ͷ���������˵�����,
       cp.complaintype3c Ͷ����������˵�����,
       cp.passengertype �ÿ�����,
       cp.flightno �����,
       cp.flightdate ��������,
       cp.airport �𽵻���,
       cp.originairportcode ��ɻ���������,
       cp.destairportcode �������������,
       cp.conetent Ͷ������,
       case when cp.conetent like '%��Ʊ%' then '��Ʊ��Ʒ'
       when cp.conetent like '%���ķ�%' then '��Ʊ��Ʒ'
       when cp.conetent like '%����%' then '����'
       when cp.conetent like '%ȡ��%' then '����ȡ��'
       when cp.conetent like '%����%' then '��������'
        when cp.conetent like '%����%' then '���౸��'
       when cp.conetent like '%��Ʊ%' then '��Ʊ�˸�ǩ'
       when cp.conetent like '%��ǩ%' then '��Ʊ�˸�ǩ'       
       when cp.conetent like '%����%' then '����'
       when cp.complaintype1c like '%����ȡ��%' then '����ȡ��' 
       when cp.complaintype1c like '%��������%' then '��������' 
       when cp.complaintype1c like '%�˸�ǩ%' then '��Ʊ�˸�ǩ' 
       when cp.complaintype1c like '%����%' then '����'                    
       end �����ж�,
       case when cp.complaintype1c like '%����%' then '����'
   when cp.complaintype2c like '%����%' then '����'
   when cp.complaintype3c like '%����%' then '����'
   when  cp.conetent  like '%����%' then '����'
   when  cp.conetent  like '%�¹�%' then '����'
    when  cp.conetent  like '%��%'  then '����'
  when regexp_like(cp.complaintype1c,'����ȡ��|��ʱȡ��|��ʱ��ȡ��|����') then '����������'
  when regexp_like(cp.complaintype2c,'����ȡ��|��ʱȡ��|��ʱ��ȡ��|����') then '����������'
  when regexp_like(cp.complaintype3c,'����ȡ��|��ʱȡ��|��ʱ��ȡ��|����') then '����������'
  when regexp_like(cp.conetent,'����ȡ��|��ʱȡ��|��ʱ��ȡ��|����') then '����������'
  else '����' end ����,
  
    case when case when cp6.flights_order_head_id is not null  then cp6.money_fy
           when cp7.flights_order_head_id is not null then cp7.money_fy*cp7.rate
             end=0 then '0Ԫ'
         else '��0Ԫ' end �Ƿ�0Ԫ,      
                 
       cp.sex �Ա�,
       case when cp.age<=18 then '00~18'
       when cp.age<=23 then '19~23'
       when cp.age<=30 then '24~30'
       when cp.age<=40 then '31~40'
       when cp.age<=50 then '41~50'
       when cp.age<=60 then '51~60'
       when cp.age>60 then '60+' end ����,
       cp.orderchannel ��������,
       cp.orderchannelchild ����������,
       cp.leg ����,
       case when regexp_like(cp.cabin,'P1|P2|P3|P4|P5|R') then substr(cp.cabin,1,2)
       else substr(cp.cabin,1,1) end ��λ,
       cp.ticketprice Ʊ��,
       cp.station ��վ,
       cp.responsibilitydept,
       case when cp1.flag=2 then '����ȡ��'
       when (cp2.dep_time-cp1.origin_std)*24>= 0.5 
       and (cp2.dep_time-cp1.origin_std)*24<=1 then '����0.5~1H'
       when (cp2.dep_time-cp1.origin_std)*24>= 1
       and (cp2.dep_time-cp1.origin_std)*24< 3 then '����1~3H'
       when (cp2.dep_time-cp1.origin_std)*24>= 3 then '����3H+' end ����״̬,
       case when cp3.channel in('��վ','�ֻ�') and cp4.users_id is not null then '����Ȩ����'
         when cp3.channel in('��վ','�ֻ�') and cp3.pay_gate in(15,29,31) then '����Ȩ����'
         when cp3.channel in('��վ','�ֻ�') then '���ϴ���'
         when cp3.channel in('OTA','�콢��') then 'OTA'
         when cp3.flights_order_head_id is not null then 'B2B'
         else null end channel,
         decode(cp5.gender,'0','-',1,'��',2,'Ů') ��Ʊ�Ա�,
          case when cp5.age<=18 then '00~18'
       when cp5.age<=23 then '19~23'
       when cp5.age<=30 then '24~30'
       when cp5.age<=40 then '31~40'
       when cp5.age<=50 then '41~50'
       when cp5.age<=60 then '51~60'
       when cp5.age>60 then '60+' end ��Ʊ����,
       cp5.SEATS_NAME,
       cp3.ticket_price,
       cp1.price,
         case when cp6.flights_order_head_id is not null then '��Ʊ'
              when cp7.flights_order_head_id is not null then '��ǩ'
              else '����' end ��Ʊ״̬,
         case when cp6.money_date>=cp6.origin_std then '������վ��'
             when (cp6.origin_std-cp6.money_date)*24>=0 and (cp6.origin_std-cp6.money_date)*24< 2  then '[0,2h)'
             when (cp6.origin_std-cp6.money_date)*24>=2 and (cp6.origin_std-cp6.money_date)*24< 24  then '[2,24h)'
             when (cp6.origin_std-cp6.money_date)>=1 and (cp6.origin_std-cp6.money_date)< 3  then '[1D,3D)' 
             when (cp6.origin_std-cp6.money_date)>=3 and (cp6.origin_std-cp6.money_date)< 7  then '[3D,7D)'
             when (cp6.origin_std-cp6.money_date)>=7  then '7D+' 
             else '-' end ��Ʊ��ǰ��,
          case when cp7.modify_date>=cp6.origin_std then '������վ��'
             when (cp6.origin_std-cp7.modify_date)*24>=0 and (cp6.origin_std-cp7.modify_date)*24< 2  then '[0,2h)'
             when (cp6.origin_std-cp7.modify_date)*24>=2 and (cp6.origin_std-cp7.modify_date)*24< 24  then '[2,24h)'
             when (cp6.origin_std-cp7.modify_date)>=1 and (cp6.origin_std-cp7.modify_date)< 3  then '[1D,3D)' 
             when (cp6.origin_std-cp7.modify_date)>=3 and (cp6.origin_std-cp7.modify_date)< 7  then '[3D,7D)'
             when (cp6.origin_std-cp7.modify_date)>=7  then '7D+' 
             else '-' end ��ǩ��ǰ��,
           case when cp6.flights_order_head_id is not null  then cp6.money_fy
           when cp7.flights_order_head_id is not null then cp7.money_fy*cp7.rate
             end �˸�ǩ������,
          case when cp7.modify_date>=cp6.origin_std then '������վ��'
             when (cp6.origin_std-cp7.modify_date)*24>=0 and (cp6.origin_std-cp7.modify_date)*24< 2  then '[0,2h)'
             when (cp6.origin_std-cp7.modify_date)*24>=2 and (cp6.origin_std-cp7.modify_date)*24< 24  then '[2,24h)'
             when (cp6.origin_std-cp7.modify_date)>=1 and (cp6.origin_std-cp7.modify_date)< 3  then '[1D,3D)' 
             when (cp6.origin_std-cp7.modify_date)>=3 and (cp6.origin_std-cp7.modify_date)< 7  then '[3D,7D)'
             when (cp6.origin_std-cp7.modify_date)>=7  then '7D+' 
             else '-' end ��ǩ��ǰ��,
             round(case when cp6.flights_order_head_id is not null  then cp6.money_fy
           when cp7.flights_order_head_id is not null then cp7.money_fy*cp7.rate
             end/cp3.ticket_price*100,0) fee_rate                       
  from hdb.crm_wo_baseinfo cp
  left join dw.da_flight cp1 on cp.flightdate=cp1.flight_date and cp.flightno=cp1.flight_no and cp.originairportcode||cp.destairportcode=cp1.segment_code
   left join dw.fact_recent_order_detail cp3 on cp.orderchannelchild=cp3.flights_order_head_id 
   left join dw.da_foc_flight cp2 on cp1.segment_head_id=cp2.segment_head_id
   left join dw.da_restrict_userinfo cp4 on cp3.client_id=cp4.users_id
  left join dw.bi_order_region cp5 on cp.orderchannelchild=cp5.flights_order_head_id
  left join dw.da_order_drawback cp6 on cp.orderchannelchild=cp6.flights_order_head_id
  left join dw.da_order_change cp7 on cp.orderchannelchild=cp7.flights_order_head_id and cp1.segment_head_id=cp7.old_segment_id
 where trunc(cp.createtime) >= to_date('2018-01-01', 'yyyy-mm-dd')
   and trunc(cp.createtime) < trunc(sysdate) 
   and cp.gcflag = 0
   and cp.jobtypecode = 'T'
   and nvl(cp1.company_id,0)=0
   and nvl(cp6.flights_order_head_id,cp7.flights_order_head_id) is not null
   and cp3.flights_order_head_id is not null 
   and cp3.ticket_price>0
  and (cp.COMPLAINTYPE1C like '%�˸�%'
   or cp.COMPLAINTYPE2C like '%�˸�%'
   or cp.COMPLAINTYPE3C like '%�˸�%'
   or cp.COMPLAINTYPE1C like '%��Ʊ%'
   or cp.COMPLAINTYPE2C like '%��Ʊ%'
   or cp.COMPLAINTYPE3C like '%��Ʊ%'
    or cp.COMPLAINTYPE1C like '%��ǩ%'
   or cp.COMPLAINTYPE2C like '%��ǩ%'
   or cp.COMPLAINTYPE3C like '%��ǩ%'
   or cp.COMPLAINTYPE1C like '%�˿�%'
   or cp.COMPLAINTYPE2C like '%�˿�%'
   or cp.COMPLAINTYPE3C like '%�˿�%'
   or cp.conetent like '%��ǩ%'
  or cp.conetent like '%�˸�%'
  or cp.conetent like '%��Ʊ%'
  or cp.conetent like '%�˿�%)

