select '��������' ��������,
case when t1.order_day>=trunc(sysdate)-7 then '����'||'('||to_char(trunc(sysdate)-7,'mmdd')||'~'||to_char(trunc(sysdate)-1,'mmdd')||')'
when t1.order_day>=trunc(sysdate)-14 then '����'||'('||to_char(trunc(sysdate)-14,'mmdd')||'~'||to_char(trunc(sysdate)-8,'mmdd')||')'
when t1.order_day>=trunc(sysdate)-21 then '������'||'('||to_char(trunc(sysdate)-21,'mmdd')||'~'||to_char(trunc(sysdate)-15,'mmdd')||')' end �Ա�����,

case when t1.channel in('�ֻ�','��վ','B2B','��������','B2G�����ͻ�') then '��������'
when t1.channel in('OTA','�콢��') then 'OTA�콢��'
when t1.channel in('B2B����') then 'B2B����' end ��������, 
case when t1.channel='�ֻ�' and t1.station_id =2 then 'M��վ'
            when t1.channel='�ֻ�' and t1.station_id in(5,10) then '΢��'
            when t1.channel='�ֻ�' and t1.station_id in(3,8) then '�ֻ�IOS'
            when t1.channel='�ֻ�' and t1.station_id in(4,9) then '�ֻ�Andriod'
            else t1.channel end ����,t2.nationflag ��������,
            case when t1.seats_name in('B','G','G1','O') then 'BGO'
                 else '��BGO' end ��λ����,
               count(1) ����,
            sum(t1.ticket_price) ��Ʊ���,
            sum(t1.price) �񺽹����ۺ�
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  where t1.order_day>=trunc(sysdate)-21
    and t1.order_day< trunc(sysdate) 
    and t2.flag<>2
    and t1.whole_flight like '9C%'
    and t1.seats_name is not null
  group by   case when t1.order_day>=trunc(sysdate)-7 then '����'||'('||to_char(trunc(sysdate)-7,'mmdd')||'~'||to_char(trunc(sysdate)-1,'mmdd')||')'
when t1.order_day>=trunc(sysdate)-14 then '����'||'('||to_char(trunc(sysdate)-14,'mmdd')||'~'||to_char(trunc(sysdate)-8,'mmdd')||')'
when t1.order_day>=trunc(sysdate)-21 then '������'||'('||to_char(trunc(sysdate)-21,'mmdd')||'~'||to_char(trunc(sysdate)-15,'mmdd')||')' end ,

case when t1.channel in('�ֻ�','��վ','B2B','��������','B2G�����ͻ�') then '��������'
when t1.channel in('OTA','�콢��') then 'OTA�콢��'
when t1.channel in('B2B����') then 'B2B����' end , 
case when t1.channel='�ֻ�' and t1.station_id =2 then 'M��վ'
            when t1.channel='�ֻ�' and t1.station_id in(5,10) then '΢��'
            when t1.channel='�ֻ�' and t1.station_id in(3,8) then '�ֻ�IOS'
            when t1.channel='�ֻ�' and t1.station_id in(4,9) then '�ֻ�Andriod'
            else t1.channel end ,t2.nationflag,
            case when t1.seats_name in('B','G','G1','O') then 'BGO'
                 else '��BGO' end 
    
union all


select '��������' ��������,
case when t1.flights_date>=trunc(sysdate)-7 then '����'||'('||to_char(trunc(sysdate)-7,'mmdd')||'~'||to_char(trunc(sysdate)-1,'mmdd')||')'
when t1.flights_date>=trunc(sysdate)-14 then '����'||'('||to_char(trunc(sysdate)-14,'mmdd')||'~'||to_char(trunc(sysdate)-8,'mmdd')||')'
when t1.flights_date>=trunc(sysdate)-21 then '������'||'('||to_char(trunc(sysdate)-21,'mmdd')||'~'||to_char(trunc(sysdate)-15,'mmdd')||')' end �Ա�����,

case when t1.channel in('�ֻ�','��վ','B2B','��������','B2G�����ͻ�') then '��������'
when t1.channel in('OTA','�콢��') then 'OTA�콢��'
when t1.channel in('B2B����') then 'B2B����' end ��������, 
case when t1.channel='�ֻ�' and t1.station_id =2 then 'M��վ'
            when t1.channel='�ֻ�' and t1.station_id in(5,10) then '΢��'
            when t1.channel='�ֻ�' and t1.station_id in(3,8) then '�ֻ�IOS'
            when t1.channel='�ֻ�' and t1.station_id in(4,9) then '�ֻ�Andriod'
            else t1.channel end ����,t2.nationflag,
            case when t1.seats_name in('B','G','G1','O') then 'BGO'
                 else '��BGO' end ��λ����,
               count(1) ����,
            sum(t1.ticket_price) ��Ʊ���,
            sum(t1.price) �񺽹����ۺ�
  from dw.fact_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  where t1.flights_date>=trunc(sysdate)-21
    and t1.flights_date< trunc(sysdate) 
    and t2.flag<>2
    and t1.whole_flight like '9C%'
    and t1.seats_name is not null    
    
  group by   case when t1.flights_date>=trunc(sysdate)-7 then '����'||'('||to_char(trunc(sysdate)-7,'mmdd')||'~'||to_char(trunc(sysdate)-1,'mmdd')||')'
when t1.flights_date>=trunc(sysdate)-14 then '����'||'('||to_char(trunc(sysdate)-14,'mmdd')||'~'||to_char(trunc(sysdate)-8,'mmdd')||')'
when t1.flights_date>=trunc(sysdate)-21 then '������'||'('||to_char(trunc(sysdate)-21,'mmdd')||'~'||to_char(trunc(sysdate)-15,'mmdd')||')' end ,

case when t1.channel in('�ֻ�','��վ','B2B','��������','B2G�����ͻ�') then '��������'
when t1.channel in('OTA','�콢��') then 'OTA�콢��'
when t1.channel in('B2B����') then 'B2B����' end , 
case when t1.channel='�ֻ�' and t1.station_id =2 then 'M��վ'
            when t1.channel='�ֻ�' and t1.station_id in(5,10) then '΢��'
            when t1.channel='�ֻ�' and t1.station_id in(3,8) then '�ֻ�IOS'
            when t1.channel='�ֻ�' and t1.station_id in(4,9) then '�ֻ�Andriod'
            else t1.channel end ,t2.nationflag,
            case when t1.seats_name in('B','G','G1','O') then 'BGO'
                 else '��BGO' end 
    
