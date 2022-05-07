select complaintype1c, cp.complaintype2c,complaintype3c,min(cp.conetent),count(1)
from hdb.crm_wo_baseinfo cp
 where trunc(cp.createtime) >= to_date('2018-10-01', 'yyyy-mm-dd')
   and trunc(cp.createtime) < trunc(sysdate) 
   and cp.gcflag = 0
   and cp.jobtypecode = 'T'
   and (cp.complaintype1c like '%��%'
   or cp.complaintype2c like '%��%'
   or cp.complaintype3c like '%��%'
   or cp.complaintype1c like '%��ǩ%'
   or cp.complaintype2c like '%��ǩ%'
   or cp.complaintype3c like '%��ǩ%'
   or cp.conetent like '%��%'
   or cp.conetent like '%��%')
   and not regexp_like(nvl(cp.complaintype1c,'-'),'(�˿�ʱ��)|(����)|(��Ʊ)|(����)|(����)|(ʱ�̵���)|(���)|(�ó�)|(����)
   |(ֵ��)|(Ԥ������)|(�г̵�)|(��ͨ)|(�ɹ�����)|(���ද̬)|(����̬��)|(�ظ���)|(��Ժ)|(�����)|(�˹��㲥)|(��Ա)|(��ֵ)|(����)|(�ͷ�)|(��Ʒ����)|(Ӫ��)|(ij)|(�Ͳ�)|(����)|(֪ͨ)|(�������)|
   (����)|(����)|(֧��)|(δ�յ�֪ͨ)|(����)|(����)|(��ԱΥ��)|(�˿�ʧ��)|(OTA�˿�)|(����)|(�м���)|(�����Ż�)|(��Ժ)
   |(����)|(�ǻ�)|(Ʊ��)|(ȼ�ͷ�)|(����ͨ)|(������)|(˰�ѵ���)|(�˿���)|(�)|(��Ϣ)|(����)|(�۸�)')
   and not regexp_like(nvl(cp.complaintype2c,'-'),'(��ֵ��Ʒ)|(��վ�)|(���/�ǻ�����)|(���񾭼���)|(����)|(©����ʧ)|(���ͻ�)|(ֵ��)|
   ( ��ɽ���)|(����)|(�����Ա)|(ѡ��)|(��������)|( �ÿ��˲���)|( ����)|(��Ʒ����)|(�ÿ���Ϣ)|(��Ϣ֪ͨ)|(�ǻ�)|(�ÿ��˲���)|
   (��Ա����)|(�Ͳ�)|(֧��)|(����ͨ��Ʒ)|(����)|(��Ա)|(����)|(����)|(��ԱΥ�����)|(�ͷ�)|(�۸�䶯)|(��Ʊ��Ϣ)|( �����ÿ�)|
   (���񾭼���)|(��Ϣ����)|(������Ϣ)|(Ӫ���)|(����ȱ��)|(����Ʒ)|(�����ۺϷ���)|(��Ϣ)|(�г̵�)|(Ԥ������)|(��ɽ���)|(���ද̬)|(�˿�ʱ��)')
   and not regexp_like(nvl(cp.complaintype3c,'-'),'(��ֵ��Ʒ)|(��վ�)|(���/�ǻ�����)|(���񾭼�����Ʒ)|(����)|(©����ʧ)|(���ͻ�)|(ֵ��)|
   ( ��ɽ���)|(����)|(�����Ա)|(ѡ��)|(��������)|( �ÿ��˲���)|( ����)|(��Ʒ����)|(�ÿ���Ϣ)|(��Ϣ֪ͨ)|(�ǻ�)|(�г̵�)|(�ÿ��˲���)|
   (��Ա����)|(�Ͳ�)|(�ͷ�����)')
   and not regexp_like(nvl(cp.conetent,'-'),'(��Ʊ)|(����)')
   group by  complaintype1c, cp.complaintype2c,complaintype3c;
   
   
   
   
   
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
         when cp.jobnextfrom in ('Android', 'IOS', 'M��', '��վ', '΢��', '�����̳�') then
          '�ڲ�����'
         when cp.jobnextfrom in ('�񺽾�', '�񺽾֣���ҳ��') then
          '�񺽾�'
         when cp.jobnextfrom = '��������' then
          '��������'
         when cp.jobnextfrom in
              ('����Ͷ�߿�', '�ÿ�����', '��ý��ƽ̨-����', '�����', '�ǻۿͲ�', '�ڲ�', '�ڲ�����', '����') then
          '�ڲ�����'
         when cp.jobnextfrom in ('�ڲ���ת(����)����', '�ڲ���ת(Ͷ��)����') then
          '�ڲ���ת'
       
         when cp.jobnextfrom = '����ί' then
          '�����ⲿ'
         when cp.jobnextfrom = '�ⲿ' then
          '�����ⲿ'
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
       cp.sex �Ա�,
       cp.age ����,
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
         decode(cp5.gender,'0','-',1,'��',2,'Ů') �Ա�,
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
             else '-' end ��ǩ��ǰ��          
  from hdb.crm_wo_baseinfo cp
  left join dw.da_flight cp1 on cp.flightdate=cp1.flight_date and cp.flightno=cp1.flight_no and cp.originairportcode||cp.destairportcode=cp1.segment_code
  left join dw.da_foc_flight cp2 on cp1.segment_head_id=cp2.segment_head_id
  left join dw.fact_recent_order_detail cp3 on cp.orderchannelchild=cp3.flights_order_head_id
  left join dw.da_restrict_userinfo cp4 on cp3.client_id=cp4.users_id
  left join dw.bi_order_region cp5 on cp.orderchannelchild=cp5.flights_order_head_id
  left join dw.da_order_drawback cp6 on cp.orderchannelchild=cp6.flights_order_head_id
  left join dw.da_order_change cp7 on cp.orderchannelchild=cp7.flights_order_head_id and cp1.segment_head_id=cp7.old_segment_id
 where trunc(cp.createtime) >= to_date('2018-10-01', 'yyyy-mm-dd')
   and trunc(cp.createtime) < trunc(sysdate) 
   and cp.gcflag = 0
   and cp.jobtypecode = 'T'
   and (cp.complaintype1c like '%��%'
   or cp.complaintype2c like '%��%'
   or cp.complaintype3c like '%��%'
   or cp.complaintype1c like '%��ǩ%'
   or cp.complaintype2c like '%��ǩ%'
   or cp.complaintype3c like '%��ǩ%'
   or cp.conetent like '%��%'
   or cp.conetent like '%��%')
   and not regexp_like(nvl(cp.complaintype1c,'-'),'(�˿�ʱ��)|(����)|(��Ʊ)|(����)|(����)|(ʱ�̵���)|(���)|(�ó�)|(����)
   |(ֵ��)|(Ԥ������)|(�г̵�)|(��ͨ)|(�ɹ�����)|(���ද̬)|(����̬��)|(�ظ���)|(��Ժ)|(�����)|(�˹��㲥)|(��Ա)|(��ֵ)|(����)|(�ͷ�)|(��Ʒ����)|(Ӫ��)|(ij)|(�Ͳ�)|(����)|(֪ͨ)|(�������)|
   (����)|(����)|(֧��)|(δ�յ�֪ͨ)|(����)|(����)|(��ԱΥ��)|(�˿�ʧ��)|(OTA�˿�)|(����)|(�м���)|(�����Ż�)|(��Ժ)
   |(����)|(�ǻ�)|(Ʊ��)|(ȼ�ͷ�)|(����ͨ)|(������)|(˰�ѵ���)|(�˿���)|(�)|(��Ϣ)|(����)|(�۸�)')
   and not regexp_like(nvl(cp.complaintype2c,'-'),'(��ֵ��Ʒ)|(��վ�)|(���/�ǻ�����)|(���񾭼���)|(����)|(©����ʧ)|(���ͻ�)|(ֵ��)|
   ( ��ɽ���)|(����)|(�����Ա)|(ѡ��)|(��������)|( �ÿ��˲���)|( ����)|(��Ʒ����)|(�ÿ���Ϣ)|(��Ϣ֪ͨ)|(�ǻ�)|(�ÿ��˲���)|
   (��Ա����)|(�Ͳ�)|(֧��)|(����ͨ��Ʒ)|(����)|(��Ա)|(����)|(����)|(��ԱΥ�����)|(�ͷ�)|(�۸�䶯)|(��Ʊ��Ϣ)|( �����ÿ�)|
   (���񾭼���)|(��Ϣ����)|(������Ϣ)|(Ӫ���)|(����ȱ��)|(����Ʒ)|(�����ۺϷ���)|(��Ϣ)|(�г̵�)|(Ԥ������)|(��ɽ���)|(���ද̬)|(�˿�ʱ��)')
   and not regexp_like(nvl(cp.complaintype3c,'-'),'(��ֵ��Ʒ)|(��վ�)|(���/�ǻ�����)|(���񾭼�����Ʒ)|(����)|(©����ʧ)|(���ͻ�)|(ֵ��)|
   ( ��ɽ���)|(����)|(�����Ա)|(ѡ��)|(��������)|( �ÿ��˲���)|( ����)|(��Ʒ����)|(�ÿ���Ϣ)|(��Ϣ֪ͨ)|(�ǻ�)|(�г̵�)|(�ÿ��˲���)|
   (��Ա����)|(�Ͳ�)|(�ͷ�����)')
   and not regexp_like(nvl(cp.conetent,'-'),'(��Ʊ)|(����)')
   

   

