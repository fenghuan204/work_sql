select to_char(mincreatetime,'yyyymm') �·�,jobstate,num, 
case when num1>0 and  num3+num2+num4>0  then '�ڲ�����Ͷ�߻�Ͷ�ߵ��񺽾�'
     when num1=0 and  num3+num2+num4>1  then '�ڲ���δ���'
     when num1>0 and  num3+num2+num4=0  then '���񺽾�Ͷ��'
     when num1=0 and  num3+num2+num4=1  then '�ڲ���һ�δ���' end Ͷ������,
     num1,num2,num3,num4,
     count(1) ȥ��Ͷ����
from(
select nvl(cp.orderchannelchild || cp.orderno||cp.cardno||cp.passengername, cp.jobno) tsnum,
       min(cp.createtime) mincreatetime,max(cp.createtime),max(case when cp.jobstate in('�ѽ᰸','�᰸�ж�') then 1
       else 0 end) jobstate,
       sum(case
             when cp.jobnextfrom in ('Android', 'IOS', 'M��', '��վ', '΢��', '�����̳�',
             '����Ͷ�߿�', '�ÿ�����', '��ý��ƽ̨-����', '�����', '�ǻۿͲ�', '�ڲ�', '�ڲ�����', '����') then
             1
             else 0 end ) num4,
       sum(  case        
             when cp.jobnextfrom in
                  ('���������������̡�������', '���������������̡�������', '�񺽾�', '�񺽾֣����⣩', '�񺽾֣���������֣�',
                   '�񺽾֣���ҳ��', '�����ⲿ���罻���磩', '�Ϻ���������12345', '�Ϻ����ŷð�', '�ⲿ',
                   '�ⲿý�壨�㲥�����硢���ţ�', '����ί', '��ý��ƽ̨-FACEBOOK', '��ý��ƽ̨-����') then
                   1 
                 else 0 end) num1,
        sum(case       
             when cp.jobnextfrom = '��������' then
              1
              else 0 end )  num2,           
        sum( case 
             when cp.jobnextfrom in ('�ڲ���ת(����)����', '�ڲ���ת(Ͷ��)����') then
              1
              else 0 end)  num3,
       count(distinct nvl(cp.orderchannelchild || cp.orderno||cp.cardno||cp.passengername, cp.jobno)) totalnum,
       count(1) num
  from hdb.crm_wo_baseinfo cp
 where trunc(cp.createtime) >= to_date('2021-03-01', 'yyyy-mm-dd')
   and trunc(cp.createtime) < trunc(sysdate)
   and cp.gcflag = 0
   and cp.jobtypecode = 'T'
 group by nvl(cp.orderchannelchild || cp.orderno||cp.cardno||cp.passengername, cp.jobno))tb1
 group by to_char(mincreatetime,'yyyymm'),jobstate,num, 
case when num1>0 and  num3+num2+num4>0  then '�ڲ�����Ͷ�߻�Ͷ�ߵ��񺽾�'
     when num1=0 and  num3+num2+num4>1  then '�ڲ���δ���'
     when num1>0 and  num3+num2+num4=0  then '���񺽾�Ͷ��'
     when num1=0 and  num3+num2+num4=1  then '�ڲ���һ�δ���' end,
      num1,num2,num3,num4
         
