--## ��Ʊ����

-----����������Ʊ���ݷ���

-----����������Ʊ���ݷ���
select /*+parallel(4) */
hb2.smonth,hb2.nationflag,--hb2.flights_segment_name,hb2.segment_country,
hb2.seat_type,hb2.focʵ���������ʱ��,/*hb2.apply_memo,*/
case  when hb2.ticketprice=0 and hb2.money_fy=0 then '0Ԫ��Ʊ'
when hb2.��Ʊ����='����' and hb2.money_fy =0 then '0Ԫ����'
when hb2.��Ʊ����='����' and hb2.money_fy=0 then 
case when hb2.is_guard ='���������ౣ��' then '���ౣ��0Ԫ'
when hb2.�������� in('ȡ��','ȡ������') and hb2.����ʱ������ is not null then 'ȡ������0Ԫ'
when hb2.�������� ='����' and hb2.����ʱ������ ='���������淢��������3Сʱ���ϲ�����Ʊ' then '����3Сʱ0Ԫ'
when hb2.�������� ='����' and hb2.����ʱ������ in('���������淢��������90���ӵ�3Сʱ���ϲ�����Ʊ','���������淢��������3Сʱ���ϲ�����Ʊ')
 and hb2.money_date>=date'2021-09-01' then '����1.5Сʱ0Ԫ'
when hb2.�������� ='����' and hb2.����ʱ������ in('���������淢��������90���ӵ�3Сʱ���ϲ�����Ʊ',
'���������淢��������3Сʱ���ϲ�����Ʊ','���������淢��������15���ӵ�90���Ӳ�����Ʊ')
 and hb2.money_date>=date'2021-11-16' then '����15����0Ԫ'
when hb2.money_date>=hb2.origin_std and hb2.focʵ���������ʱ��='3h+' then '��ɺ���ʵ������3H0Ԫ'
when hb2.money_date>=hb2.origin_std and hb2.focʵ���������ʱ�� in('3h+','1.5h~3h') then '��ɺ���ʵ������1.5H0Ԫ'
when hb2.money_date>=hb2.origin_std and hb2.focʵ���������ʱ�� in('15min~90min') then '��ɺ���ʵ������15min0Ԫ'
when hb2.��������<>'��������' and hb2.����ʱ������ is not null then '���������๫�����Ʊ'
when hb2.apply_memo like '%����%' then hb2.apply_memo
when hb2.apply_memo in('�ÿ�--�����','�ÿ�--�����ع�') then '��ע-�����0Ԫ'
when hb2.apply_memo 
in('��˾--����ȡ��','��˾--����ʱ�̵���','��˾--���ౣ��','��˾--����������','��˾--��������','��˾--���ಹ��','��˾--���౸��')
then '��ע-����������0Ԫ'
when hb2.apply_memo 
in('�ÿ�--���','��˾--�۸���ˮ','����--ȼ������','�ÿ�--����','�ÿ�--����','�ÿ�--����','Ͷ�ߴ���') then '��ע-�ÿ�Ͷ��0Ԫ' 
when hb2.apply_memo <>'δ��д��Ӧ��������' then '0Ԫ��ע-��������0Ԫ'
else '�ޱ�ע0Ԫ' end
when hb2.money_fy>0 then '��Ʊ�շ�' end apply_memo,
hb2.��������,hb2.��������,hb2.priod_date,
hb2.��Ʊ����,hb2.apply_user,
case when hb2.DELAY_HOUR>=0.25 and hb2.DELAY_HOUR< 1.5 then '15m~90m'
when hb2.DELAY_HOUR>=1.5 and hb2.DELAY_HOUR< 3 then '1.5h~3h' 
when hb2.DELAY_HOUR>=3 and hb2.DELAY_HOUR< 5 then '3h~5h' 
when hb2.DELAY_HOUR>=5  then '5h' 
else 'δ�ӳ�' end ���󺽰�ʱ������,
hb2.����ʱ������,
hb2.�շ�����,
hb2.return_channel,
hb2.order_channel,
sum(hb2.money_fy) money_fy,
sum(hb2.ticketprice) ticketprice,
sum(hb2.ys_fee) ys_fee,
count(distinct hb2.flights_order_head_id) ��Ʊ��,
sum(hb2.ys_fee)-sum(hb2.money_fy) ������,
hb2.is_guard �Ƿ񺽰ౣ��,
zhengce ��������,
seatnametype ��λ����
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
to_char(t1.origin_std,'yyyymm') smonth,
t9.order_date,
t1.money_date,
t2.flight_date,
t2.flights_segment_name,
t2.area_type nationflag,
t2.segment_country,
t2.origin_std,
case when t1.seattype='������' then '������'
else '��������' end seat_type,
case when t9.order_date< to_date('2022-02-09','yyyy-mm-dd') and t1.origin_std>=to_date('2022-02-08','yyyy-mm-dd')
and t1.origin_std< to_date('2022-03-01','yyyy-mm-dd') and t1.money_date>=date'2022-02-08' 
and regexp_like(t2.flights_segment_name,'����|����|����|����') then '�ⲿ-�������ֱ������ݽ�����'
when t9.order_date< to_date('2022-02-02','yyyy-mm-dd') and t1.origin_std>=to_date('2022-02-01','yyyy-mm-dd')
and t1.origin_std< to_date('2022-02-21','yyyy-mm-dd') and t1.money_date>=date'2022-02-01' 
and regexp_like(t2.flights_segment_name,'����') then '�ⲿ-����2�³�'
when t9.order_date< to_date('2022-01-27','yyyy-mm-dd') and t1.origin_std>=to_date('2022-01-26','yyyy-mm-dd')
and t1.origin_std< to_date('2022-02-09','yyyy-mm-dd') and t1.money_date>=date'2022-01-26' 
and t2.flights_segment_name like '%����%' then '�ⲿ-����1����Ѯ'
when t9.order_date< to_date('2022-01-26','yyyy-mm-dd') and t1.origin_std>=to_date('2022-01-25','yyyy-mm-dd')
and t1.origin_std< to_date('2022-02-08','yyyy-mm-dd') and t1.money_date>=date'2022-01-25' 
and t2.flights_segment_name like '%����%' then '�ⲿ-����1����Ѯ'

when t9.order_date< to_date('2022-01-25','yyyy-mm-dd') and t1.origin_std>=to_date('2022-01-24','yyyy-mm-dd')
and t1.origin_std< to_date('2022-02-07','yyyy-mm-dd') and t1.money_date>=date'2022-01-24' 
and regexp_like(t2.flights_city_name,'�Ϻ�|���|�麣') then '�ⲿ-�Ϻ�����麣������'

when t9.order_date< to_date('2022-01-23','yyyy-mm-dd') and t1.origin_std>=to_date('2022-01-23','yyyy-mm-dd')
and t1.origin_std< to_date('2022-02-06','yyyy-mm-dd') and t1.money_date>=date'2022-01-23' 
and regexp_like(t2.flights_city_name,'����|��˫����') then '�ⲿ-������˫����'

when t9.order_date< to_date('2022-01-19','yyyy-mm-dd') and t1.origin_std>=to_date('2022-01-18','yyyy-mm-dd')
and t1.origin_std< to_date('2022-02-02','yyyy-mm-dd') and t1.money_date>=date'2022-01-18' 
and regexp_like(t2.flights_city_name,'���|����|����|֣��') then '�ⲿ-�����������֣��'

when t9.order_date< to_date('2022-01-15','yyyy-mm-dd') and t1.origin_std>=to_date('2022-01-15','yyyy-mm-dd')
and t1.origin_std< to_date('2022-01-29','yyyy-mm-dd') and t1.money_date>=date'2022-01-14' 
and regexp_like(t2.flights_city_name,'�麣') then '�ⲿ-�麣1����Ѯ'

when t9.order_date< to_date('2022-01-14','yyyy-mm-dd') and t1.origin_std>=to_date('2022-01-14','yyyy-mm-dd')
and t1.origin_std< to_date('2022-01-28','yyyy-mm-dd') and t1.money_date>=date'2022-01-14' 
and regexp_like(t2.flights_city_name,'����') then '�ⲿ-����1����Ѯ'

when t9.order_date< to_date('2022-01-13','yyyy-mm-dd') and t1.origin_std>=to_date('2022-01-13','yyyy-mm-dd')
and t1.origin_std< to_date('2022-01-27','yyyy-mm-dd') and t1.money_date>=date'2022-01-13' 
and regexp_like(t2.flights_city_name,'�Ϻ�') then '�ⲿ-�Ϻ�1����Ѯ'

when t9.order_date< to_date('2022-01-12','yyyy-mm-dd') and t1.origin_std>=to_date('2022-01-12','yyyy-mm-dd')
and t1.origin_std< to_date('2022-01-27','yyyy-mm-dd') and t1.money_date>=date'2022-01-12' 
and regexp_like(t2.flights_city_name,'����') then '�ⲿ-����1����Ѯ'

when t9.order_date< to_date('2022-01-09','yyyy-mm-dd') and t1.origin_std>=to_date('2022-01-09','yyyy-mm-dd')
and t1.origin_std< to_date('2022-01-24','yyyy-mm-dd') and t1.money_date>=date'2022-01-09' 
and regexp_like(t2.flights_city_name,'���') then '�ⲿ-���1����Ѯ'


when t9.order_date< to_date('2022-01-07','yyyy-mm-dd') and t1.origin_std>=to_date('2022-01-07','yyyy-mm-dd')
and t1.origin_std< to_date('2022-01-22','yyyy-mm-dd') and t1.money_date>=date'2022-01-07' 
and regexp_like(t2.flights_city_name,'����') then '�ⲿ-����1�³�'


when t9.order_date< to_date('2022-01-04','yyyy-mm-dd') and t1.origin_std>=to_date('2022-01-04','yyyy-mm-dd')
and t1.origin_std< to_date('2022-01-19','yyyy-mm-dd') and t1.money_date>=date'2022-01-04' 
and regexp_like(t2.flights_city_name,'����') then '�ⲿ-֣��1�³�'

when t9.order_date< to_date('2022-01-02','yyyy-mm-dd') and t1.origin_std>=to_date('2022-01-02','yyyy-mm-dd')
and t1.origin_std< to_date('2022-01-17','yyyy-mm-dd') and t1.money_date>=date'2022-01-02' 
and regexp_like(t2.flights_city_name,'����') then '�ⲿ-����1�³�'

when t9.order_date< to_date('2021-12-31','yyyy-mm-dd') and t1.origin_std>=to_date('2021-12-31','yyyy-mm-dd')
and t1.origin_std< to_date('2022-01-15','yyyy-mm-dd') and t1.money_date>=date'2021-12-31' 
and regexp_like(t2.flights_city_name,'����') then '�ⲿ-����12�µ�'
when t9.order_date< to_date('2021-12-28','yyyy-mm-dd') and t1.origin_std>=to_date('2021-12-28','yyyy-mm-dd')
and t1.origin_std< to_date('2022-01-12','yyyy-mm-dd') and t1.money_date>=date'2021-12-28' 
and regexp_like(t2.flights_city_name,'����|��˫����') then '�ⲿ-������˫����12�µ�'

when t9.order_date< to_date('2021-12-23','yyyy-mm-dd') and t1.origin_std>=to_date('2021-12-22','yyyy-mm-dd')
and t1.origin_std< to_date('2022-01-22','yyyy-mm-dd') and t1.money_date>=date'2021-12-22' 
and regexp_like(t2.flights_city_name,'����') then '�ⲿ-����12�µ�'

when t9.order_date< to_date('2021-12-18','yyyy-mm-dd') and t1.origin_std>=to_date('2021-12-18','yyyy-mm-dd')
and t1.origin_std< to_date('2022-01-02','yyyy-mm-dd') and t1.money_date>=date'2021-12-17' 
and regexp_like(t2.flights_city_name,'����|����|����|����') then '�ⲿ-�������ź�������12����Ѯ'

when t9.order_date< to_date('2021-12-13','yyyy-mm-dd') and t1.origin_std>=to_date('2021-12-13','yyyy-mm-dd')
and t1.origin_std< to_date('2021-12-28','yyyy-mm-dd') and t1.money_date>=date'2021-12-13' 
and regexp_like(t2.flights_city_name,'����|����') then '�ⲿ-��������12����Ѯ'

when t9.order_date< to_date('2021-12-12','yyyy-mm-dd') and t1.origin_std>=to_date('2021-12-12','yyyy-mm-dd')
and t1.origin_std< to_date('2021-12-27','yyyy-mm-dd') and t1.money_date>=date'2021-12-12' 
and regexp_like(t2.flights_city_name,'����') then '�ⲿ-����12����Ѯ'

when t9.order_date< to_date('2021-12-08','yyyy-mm-dd') and t1.origin_std>=to_date('2021-12-08','yyyy-mm-dd')
and t1.origin_std< to_date('2021-12-23','yyyy-mm-dd') and t1.money_date>=date'2021-12-08' 
and regexp_like(t2.flights_city_name,'�Ͼ�') then '�ⲿ-�Ͼ�12����Ѯ'



when t9.order_date< to_date('2022-02-13','yyyy-mm-dd') and t1.origin_std>=to_date('2022-02-06','yyyy-mm-dd')
and t1.origin_std< to_date('2022-02-27','yyyy-mm-dd') and t1.money_date>=date'2022-02-06' 
and t2.flights_segment_name like '%����%' then '�ڲ�-����������'
when t9.order_date< to_date('2022-02-13','yyyy-mm-dd') and t1.origin_std>=to_date('2022-02-08','yyyy-mm-dd')
and t1.origin_std< to_date('2022-03-01','yyyy-mm-dd') and t1.money_date>=date'2022-02-08' 
and regexp_like(t2.flights_segment_name,'����|����|����|����') then '�ڲ�-�������ֱ������ݽ�����'
when t9.order_date< to_date('2022-02-13','yyyy-mm-dd') and t1.origin_std>=to_date('2022-02-08','yyyy-mm-dd')
and t1.origin_std< to_date('2022-03-01','yyyy-mm-dd') and t1.money_date>=date'2022-02-08' 
and regexp_like(t2.flights_segment_name,'����|����|����|����') then '�ڲ�-�������ֱ������ݽ�����'
when t9.order_date< to_date('2022-02-01','yyyy-mm-dd') and t1.origin_std>=to_date('2022-01-24','yyyy-mm-dd')
and t1.origin_std< to_date('2022-02-14','yyyy-mm-dd') and t1.money_date>=date'2022-01-24' 
and regexp_like(t2.flights_city_name,'�Ϻ�|���|�麣') then '�ڲ�-�Ϻ�����麣�����۷ſ�һ��'
when t9.order_date< to_date('2022-01-30','yyyy-mm-dd') and t1.origin_std>=to_date('2022-01-23','yyyy-mm-dd')
and t1.origin_std< to_date('2022-02-13','yyyy-mm-dd') and t1.money_date>=date'2022-01-23' 
and regexp_like(t2.flights_city_name,'����|��˫����') then '�ڲ�-������˫���ɷſ�һ��'

when t9.order_date< to_date('2022-02-01','yyyy-mm-dd') and t1.origin_std>=to_date('2022-01-24','yyyy-mm-dd')
and t1.origin_std< to_date('2022-02-14','yyyy-mm-dd') and t1.money_date>=date'2022-01-24' 
and regexp_like(t2.flights_city_name,'����|����') then '�ڲ�-���������ſ�һ��'
when t9.order_date< to_date('2022-01-12','yyyy-mm-dd') and t1.origin_std>=to_date('2022-01-12','yyyy-mm-dd')
and t1.origin_std< to_date('2022-02-27','yyyy-mm-dd') and t1.money_date>=date'2022-01-12' 
and regexp_like(t2.flights_city_name,'����') then '�ڲ�-����1����Ѯ'

when t9.order_date< to_date('2022-01-08','yyyy-mm-dd') and t1.origin_std>=to_date('2022-01-08','yyyy-mm-dd')
and t1.origin_std< to_date('2022-01-23','yyyy-mm-dd') and t1.money_date>=date'2022-01-08' 
and regexp_like(t2.flights_city_name,'���') then '�ڲ�-���1����Ѯ'

when t9.order_date< to_date('2022-01-08','yyyy-mm-dd') and t1.origin_std>=to_date('2022-01-08','yyyy-mm-dd')
and t1.origin_std< to_date('2022-02-01','yyyy-mm-dd') and t1.money_date>=date'2022-01-08' 
and regexp_like(t2.flights_city_name,'����|����|����|֣��|�Ϻ�|�Ӱ�') then '�ڲ�-������������֣���Ϻ��Ӱ�'

when  t1.origin_std>=to_date('2022-01-02','yyyy-mm-dd')
and t1.origin_std< to_date('2022-02-01','yyyy-mm-dd') and t1.money_date>=date'2022-01-02' and t1.money_date< date'2022-01-08'
and regexp_like(t2.flights_city_name,'����|����|����|����|�Ӱ�') then '�ڲ�-�����������������Ӱ�'


when t9.order_date< to_date('2022-01-07','yyyy-mm-dd') and t1.origin_std>=to_date('2022-01-07','yyyy-mm-dd')
and t1.origin_std< to_date('2022-01-22','yyyy-mm-dd') and t1.money_date>=date'2022-01-07' 
and regexp_like(t2.flights_city_name,'����') then '�ڲ�-����1����Ѯ'

when t9.order_date< to_date('2022-01-04','yyyy-mm-dd') and t1.origin_std>=to_date('2022-01-03','yyyy-mm-dd')
and t1.origin_std< to_date('2022-01-18','yyyy-mm-dd') and t1.money_date>=date'2022-01-03' 
and regexp_like(t2.flights_city_name,'�Ϻ�') then '�ڲ�-�Ϻ�1����Ѯ'

when t9.order_date< to_date('2021-12-28','yyyy-mm-dd') and t1.origin_std>=to_date('2021-12-28','yyyy-mm-dd')
and t1.origin_std< to_date('2022-01-12','yyyy-mm-dd') and t1.money_date>=date'2021-12-28' 
and regexp_like(t2.flights_city_name,'�Ͼ�') then '�ڲ�-�Ͼ�12�µ�'

when t9.order_date< to_date('2021-12-27','yyyy-mm-dd') and t1.origin_std>=to_date('2021-12-27','yyyy-mm-dd')
and t1.origin_std< to_date('2022-01-11','yyyy-mm-dd') and t1.money_date>=date'2021-12-27' 
and regexp_like(t2.originairport_name,'����|տ��|�麣|����|����') then '�ڲ�-�㶫����12�µ�'

else '---'

end  zhengce,











case when scfl.dis_round is not null then 
case when (scfl.dis_round -t2.origin_std)*24*60< 15 then '����15��������'
when (scfl.dis_round -t2.origin_std)*24*60>=15 and (scfl.dis_round-t2.origin_std)*24*60< 90 then '15min~90min'
when (scfl.dis_round -t2.origin_std)*24*60>=90 and (scfl.dis_round-t2.origin_std)*24< 3 then '1.5h~3h'
when (scfl.dis_round -t2.origin_std)*24>=3  then '3h+' end
else null end  focʵ���������ʱ��,
case when t1.money_fy=0 and t1.ticketprice=0  and t1.seats_name in('O','D') then 'OD��Ʊ'
when t1.money_fy=0 and t1.ticketprice=0   then '��Ʊ��Ʊ'
when t1.money_fy=0  then '0Ԫ��Ʊ'
when t1.money_fy>0 then '��0Ԫ��Ʊ' end ��������,
case when t2.flag=2 then 'ȡ��'
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
case when nvl(t1.apply_memo,dim2.memo_user)  like '%����%' then '�ÿ�--�����ع�'
when nvl(t1.apply_memo,dim2.memo_user)  like '%����%' then '�ÿ�--�����ع�'
when nvl(t1.apply_memo,dim2.memo_user)  like '%�ع�%' then '�ÿ�--�����ع�'
when nvl(t1.apply_memo,dim2.memo_user)  like '%�ع�%' then '�ÿ�--�����ع�'
when nvl(t1.apply_memo,dim2.memo_user)  like '%�ض�%' then '�ÿ�--�����ع�'
when nvl(t1.apply_memo,dim2.memo_user)  like '%�¶���%' then '�ÿ�--�����ع�'
when nvl(t1.apply_memo,dim2.memo_user)  like '%���¶���%' then '�ÿ�--�����ع�'
when nvl(t1.apply_memo,dim2.memo_user)  like '%�ظ���Ʊ%' then '�ÿ�--�����ع�'
when nvl(t1.apply_memo,dim2.memo_user)  like '%���¹�Ʊ%' then '�ÿ�--�����ع�'
when nvl(t1.apply_memo,dim2.memo_user)  like '%�ظ���Ʊ%' then '�ÿ�--�����ع�'
when nvl(t1.apply_memo,dim2.memo_user)  like '%����ѡ��%' then '�ÿ�--�����ع�'
when nvl(t1.apply_memo,dim2.memo_user)  like '%�¶���%' then '�ÿ�--�����ع�'
when nvl(t1.apply_memo,dim2.memo_user)  like '%����%' then '�ÿ�--�����ع�'
when nvl(t1.apply_memo,dim2.memo_user)  like '%ԭ����%' then '�ÿ�--�����ع�'
when nvl(t1.apply_memo,dim2.memo_user)  like '%ԭ����%' then '�ÿ�--�����ع�'
when nvl(t1.apply_memo,dim2.memo_user)  like '%����%' then '�ÿ�--�����ع�'
when nvl(t1.apply_memo,dim2.memo_user)  like '%����%' then '�ÿ�--������ͯӤ��'
when nvl(t1.apply_memo,dim2.memo_user)  like '%����%' then '�ÿ�--������ͯӤ��'
when nvl(t1.apply_memo,dim2.memo_user)  like '%©��%' then '�ÿ�--������ͯӤ��'
when nvl(t1.apply_memo,dim2.memo_user)  like '%�����%' then '�ÿ�--�����'
when nvl(t1.apply_memo,dim2.memo_user)  like '%���%' then '�ÿ�--�����'
when nvl(t1.apply_memo,dim2.memo_user)  like '%��ȼ��%' then '����--ȼ������'
when nvl(t1.apply_memo,dim2.memo_user)  like '%ȼ������%' then '����--ȼ������'
when nvl(t1.apply_memo,dim2.memo_user)  like '%ȼ��%' then '����--ȼ������'
when nvl(t1.apply_memo,dim2.memo_user)  like '%����%' then '��˾--��������'
when nvl(t1.apply_memo,dim2.memo_user)  like '%����ȡ��%' then '��˾--����ȡ��'
when nvl(t1.apply_memo,dim2.memo_user)  like '%�س�ȡ��%' then '��˾--����ȡ��'
when nvl(t1.apply_memo,dim2.memo_user)  like '%ȥ�̺�ȡ%' then '��˾--����ȡ��'
when nvl(t1.apply_memo,dim2.memo_user)  like '%ȡ������%' then '��˾--����ȡ��'
when nvl(t1.apply_memo,dim2.memo_user)  like '%��%ȡ��%' then '��˾--����ȡ��'
when nvl(t1.apply_memo,dim2.memo_user)  like '%�س�%ȡ��%' then '��˾--����ȡ��'
when nvl(t1.apply_memo,dim2.memo_user)  like '%ȥ��%ȡ��%' then '��˾--����ȡ��'
when nvl(t1.apply_memo,dim2.memo_user)  like '%��һ��%ȡ��%' then '��˾--����ȡ��'
when nvl(t1.apply_memo,dim2.memo_user)  like '%�ڶ���%ȡ��%' then '��˾--����ȡ��'
when nvl(t1.apply_memo,dim2.memo_user)  like '%��һ��%ȡ��%' then '��˾--����ȡ��'
when nvl(t1.apply_memo,dim2.memo_user)  like '%�ڶ���%ȡ��%' then '��˾--����ȡ��'
when nvl(t1.apply_memo,dim2.memo_user)  like '%ǰ��%ȡ��%' then '��˾--����ȡ��'
when nvl(t1.apply_memo,dim2.memo_user)  like '%���%ȡ��%' then '��˾--����ȡ��'
when nvl(t1.apply_memo,dim2.memo_user)  like '%ȥȡ��%' then '��˾--����ȡ��'
when nvl(t1.apply_memo,dim2.memo_user)  like '%ȥ��ȡ��%' then '��˾--����ȡ��'
when nvl(t1.apply_memo,dim2.memo_user)  like '%����ȡ��%' then '��˾--����ȡ��'
when nvl(t1.apply_memo,dim2.memo_user)  like '%ȡ��%' and t2.flag=2 then '��˾--����ȡ��'
when nvl(t1.apply_memo,dim2.memo_user)  like '%���౸��%' then '��˾--���౸��'
when nvl(t1.apply_memo,dim2.memo_user)  like '%����%' then '��˾--���౸��'
when nvl(t1.apply_memo,dim2.memo_user)  like '%����Ľ�%' then '��˾--���౸��'
when nvl(t1.apply_memo,dim2.memo_user)  like '%����ʱ�����%' then '��˾--����ʱ�̵���'
when nvl(t1.apply_memo,dim2.memo_user)  like '%ʱ�̵���%' then '��˾--����ʱ�̵���'
when nvl(t1.apply_memo,dim2.memo_user)  like '%ʱ�̱��%' then '��˾--����ʱ�̵���'
when nvl(t1.apply_memo,dim2.memo_user)  like '%ʱ��%' then '��˾--����ʱ�̵���'
when nvl(t1.apply_memo,dim2.memo_user)  like '%����%' then '��˾--���ಹ��'
when nvl(t1.apply_memo,dim2.memo_user)  like '%�۸���ˮ%' then '��˾--�۸���ˮ'
when nvl(t1.apply_memo,dim2.memo_user)  like '%�۸��½�%' then '��˾--�۸���ˮ'
when nvl(t1.apply_memo,dim2.memo_user)  like '%��ˮ%' then '��˾--�۸���ˮ'
when nvl(t1.apply_memo,dim2.memo_user)  like '%����%' then '�ÿ�--����'
when nvl(t1.apply_memo,dim2.memo_user)  like '%��Ѫ%' then '�ÿ�--����'
when nvl(t1.apply_memo,dim2.memo_user)  like '%���ಡ%' then '�ÿ�--����'
when nvl(t1.apply_memo,dim2.memo_user)  like '%ʳ���ж�%' then '�ÿ�--����'
when nvl(t1.apply_memo,dim2.memo_user)  like '%�и�%' then '�ÿ�--����'
when nvl(t1.apply_memo,dim2.memo_user)  like '%����%' then '�ÿ�--����'
when nvl(t1.apply_memo,dim2.memo_user)  like '%����%' then '�ÿ�--����'
when nvl(t1.apply_memo,dim2.memo_user)  like '%��θ��%' then '�ÿ�--����'
when nvl(t1.apply_memo,dim2.memo_user)  like '%����%' then '�ÿ�--����'
when nvl(t1.apply_memo,dim2.memo_user)  like '%��%' then '�ÿ�--����'
when nvl(t1.apply_memo,dim2.memo_user)  like '%����%' then '�ÿ�--����'
when nvl(t1.apply_memo,dim2.memo_user)  like '%����%��Ȩ%' then '����-������Ȩ'
when nvl(t1.apply_memo,dim2.memo_user)  like '%������Ȩ%' then '����-������Ȩ'
when nvl(t1.apply_memo,dim2.memo_user)  like '%�г̿�%' then '����-�г̿�'
when nvl(t1.apply_memo,dim2.memo_user)  like '%����%' then '����-��������'
when nvl(t1.apply_memo,dim2.memo_user)  like '%����%' then '����-��������'
when nvl(t1.apply_memo,dim2.memo_user)  like '%����%' then '����-��������'
when nvl(t1.apply_memo,dim2.memo_user)  like '%�þ�ʷ%' then '����-�þ�ʷ'
when nvl(t1.apply_memo,dim2.memo_user)  like '%����ʷ%' then '����-�þ�ʷ'
when nvl(t1.apply_memo,dim2.memo_user)  like '%�г���%' then '����-�г̿�'
when nvl(t1.apply_memo,dim2.memo_user)  like '%����%' then '����-����'
when nvl(t1.apply_memo,dim2.memo_user)  like '%����%' then '����-��������'
when nvl(t1.apply_memo,dim2.memo_user)  like '%����%' then '����'
when nvl(t1.apply_memo,dim2.memo_user)  like '%����%' then '����'
when nvl(t1.apply_memo,dim2.memo_user)  like '%�¹�%' then '����'
when nvl(t1.apply_memo,dim2.memo_user)  like '%�ֿ�%' then '�������--�ֿ�ͬ��'
when nvl(t1.apply_memo,dim2.memo_user)  like '%����޸ķ�%' then '�������--����޸ķ���'
when nvl(t1.apply_memo,dim2.memo_user)  like '%Ͷ��%' then 'Ͷ�ߴ���'
when nvl(t1.apply_memo,dim2.memo_user)  like '%�г���%ͬ��%' then 'Ͷ�ߴ���'
when nvl(t1.apply_memo,dim2.memo_user)  like '%����ʦ%' then 'Ͷ�ߴ���'
when nvl(t1.apply_memo,dim2.memo_user)  like '%Ӧ��ʦ%' then 'Ͷ�ߴ���'
when nvl(t1.apply_memo,dim2.memo_user)  like '%½��%' then 'Ͷ�ߴ���'
when nvl(t1.apply_memo,dim2.memo_user)  like '%��Ӣ%' then 'Ͷ�ߴ���'
when nvl(t1.apply_memo,dim2.memo_user)  like '%Ӧ�ŵ�%' then 'Ͷ�ߴ���'
when nvl(t1.apply_memo,dim2.memo_user)  like '%����ʦ%' then 'Ͷ�ߴ���'
when nvl(t1.apply_memo,dim2.memo_user)  like '%����ï%' then 'Ͷ�ߴ���'
when nvl(t1.apply_memo,dim2.memo_user)  like '%������%' then 'Ͷ�ߴ���'
when nvl(t1.apply_memo,dim2.memo_user)  like '%����ʦ%' then 'Ͷ�ߴ���'
when nvl(t1.apply_memo,dim2.memo_user)  like '%����%' then 'Ͷ�ߴ���'
when nvl(t1.apply_memo,dim2.memo_user)  like '%����%' then '�ÿ�--�����ع�'
when nvl(t1.apply_memo,dim2.memo_user)  like '%���%' then '�ÿ�--�����ع�'
when nvl(t1.apply_memo,dim2.memo_user)  like '%����ͯ%' then '�ÿ�--������ͯӤ��'
when nvl(t1.apply_memo,dim2.memo_user)  like '%���ౣ��%' then '��˾--���ౣ��'
when nvl(t1.apply_memo,dim2.memo_user)  like '%ȥ��%����%' then '��˾--���ౣ��'
when nvl(t1.apply_memo,dim2.memo_user)  like '%ȡ��%����%' then '��˾--���ౣ��'
when nvl(t1.apply_memo,dim2.memo_user)  like '%ǰ��%����%' then '��˾--���ౣ��'
when nvl(t1.apply_memo,dim2.memo_user)  like '%���%����%' then '��˾--���ౣ��'
when nvl(t1.apply_memo,dim2.memo_user)  like '%����������%' then '��˾--���ౣ��'
when nvl(t1.apply_memo,dim2.memo_user)  like '%�������಻����%' then '��˾--���ౣ��'
when nvl(t1.apply_memo,dim2.memo_user)  like '%ȡ����������%' then '��˾--���ౣ��'
when nvl(t1.apply_memo,dim2.memo_user)  like '%���ౣ��������%' then '��˾--���ౣ��'
when nvl(t1.apply_memo,dim2.memo_user)  like '%�������಻��%' then '��˾--���ౣ��'
when nvl(t1.apply_memo,dim2.memo_user)  like '%��������%' then '��˾--���ౣ��'
when nvl(t1.apply_memo,dim2.memo_user)  like '%��������%' then '��˾--���ౣ��'
when nvl(t1.apply_memo,dim2.memo_user)  like '%����%' then '��˾--���ౣ��'
when nvl(t1.apply_memo,dim2.memo_user)  like '%����������%' then '��˾--����������'
when nvl(t1.apply_memo,dim2.memo_user)  like '%��ͣ����%' then '��˾--����������'
when nvl(t1.apply_memo,dim2.memo_user)  like '%ȥ�̲�����%' then '��˾--����������'
when nvl(t1.apply_memo,dim2.memo_user)  like '%����ͣ��%' then '��˾--����������'
when nvl(t1.apply_memo,dim2.memo_user)  like '%ǰ�β�����%' then '��˾--����������'
when nvl(t1.apply_memo,dim2.memo_user)  like '%�������س�%' then '��˾--����������'
when nvl(t1.apply_memo,dim2.memo_user)  like '%���಻����%' then '��˾--����������'
when nvl(t1.apply_memo,dim2.memo_user)  like '%ֹͣ����%' then '��˾--����������'
when nvl(t1.apply_memo,dim2.memo_user)  like '%������%' then '��˾--����������'
when nvl(t1.apply_memo,dim2.memo_user)  like '%ͣ��%' then '��˾--����������'
when nvl(t1.apply_memo,dim2.memo_user)  like '%����%' then '�ÿ�--����'
when nvl(t1.apply_memo,dim2.memo_user)  like '%��Σ%' then '�ÿ�--����'
when nvl(t1.apply_memo,dim2.memo_user)  like '%����%' then '�����¼�'
when nvl(t1.apply_memo,dim2.memo_user)  like '%����%' then '�����¼�'
when nvl(t1.apply_memo,dim2.memo_user)  like '%����%' then '�����¼�'
when nvl(t1.apply_memo,dim2.memo_user)  like '%ѧ��%' then '�ÿ�--ѧ������'
when nvl(t1.apply_memo,dim2.memo_user)  like '%ѧУ%' then '�ÿ�--ѧ������'
when nvl(t1.apply_memo,dim2.memo_user)  like '%��ϵ��%' then '��ϵ��'
when nvl(t1.apply_memo,dim2.memo_user)  like '%����%' then '�������--������'
when nvl(t1.apply_memo,dim2.memo_user)  like '%2��%' then '�������--������'
when nvl(t1.apply_memo,dim2.memo_user)  like '%�ֿ�%' then '�������--����ͬ��'
when nvl(t1.apply_memo,dim2.memo_user)  like '%����%' then '�������--����ͬ��'
when nvl(t1.apply_memo,dim2.memo_user)  like '%�ܿ�%' then '�������--����ͬ��'
when nvl(t1.apply_memo,dim2.memo_user)  like '%�����˸�%' then '�����˸�����'
when nvl(t1.apply_memo,dim2.memo_user)  like '%�˸�����%' then '�����˸�����'
when nvl(t1.apply_memo,dim2.memo_user)  like '%��������%' then '�����˸�����'
when nvl(t1.apply_memo,dim2.memo_user)  like '%�������%' then '�����˸�����'
when nvl(t1.apply_memo,dim2.memo_user)  like '%������Ʊ%' then '�����˸�����'
when nvl(t1.apply_memo,dim2.memo_user)  like '%��Ը%' then '�ÿ���Ը'
when lower(nvl(t1.apply_memo,dim2.memo_user))  like '%ziyuan%' then '�ÿ���Ը'
when nvl(t1.apply_memo,dim2.memo_user)  like '%��%��%' then '����'
when nvl(t1.apply_memo,dim2.memo_user)  like '%�� �� �� �� ȼ ��%' then '�ÿ���Ը'
when nvl(t1.apply_memo,dim2.memo_user)  like '%�� �� ��%' then '�ÿ���Ը'
when nvl(t1.apply_memo,dim2.memo_user)  like '%����%' then '�ÿ���Ը'
when nvl(t1.apply_memo,dim2.memo_user)  like '%�˻���%' then '�ÿ���Ը'
when nvl(t1.apply_memo,dim2.memo_user)  like '%tuishui%' then '�ÿ���Ը'
when nvl(t1.apply_memo,dim2.memo_user)  like '%�˻�����%' then '�ÿ���Ը'
when nvl(t1.apply_memo,dim2.memo_user)  like '%�˻�˰%' then '�ÿ���Ը'
when nvl(t1.apply_memo,dim2.memo_user)  like '%��˰%' then '�ÿ���Ը'
when nvl(t1.apply_memo,dim2.memo_user)  like '%�ƻ�˰%' then '�ÿ���Ը'
when nvl(t1.apply_memo,dim2.memo_user)  like '%�˻��������%' then '�ÿ���Ը'
when nvl(t1.apply_memo,dim2.memo_user)  like '%�˶�%' then '�ÿ�--��Ը'
when nvl(t1.apply_memo,dim2.memo_user)  like '%��˰%' then '�ÿ�--��Ը'
when nvl(t1.apply_memo,dim2.memo_user)  like '%����%' then '�ÿ�--����'
when nvl(t1.apply_memo,dim2.memo_user)  like '%����%' then '�ÿ�--����'
when nvl(t1.apply_memo,dim2.memo_user)  like '%���%' then '�ÿ�--���'
when nvl(t1.apply_memo,dim2.memo_user)  like '%��%' then '�ÿ�--���'
when nvl(t1.apply_memo,dim2.memo_user)  like '%wuji%' then '�ÿ�--���'
when nvl(t1.apply_memo,dim2.memo_user)  like '%©��%' then '�ÿ�--���'
when nvl(t1.apply_memo,dim2.memo_user)  like '%����%' then '����--����'
when nvl(t1.apply_memo,dim2.memo_user)  like '%��ʧ%' then '�ÿ�--��Ʊ��ʧ'
when nvl(t1.apply_memo,dim2.memo_user)  like '%����%' then '����'
when lower(nvl(t1.apply_memo,dim2.memo_user))  like '%test%' then '����'
when nvl(t1.apply_memo,dim2.memo_user)  like '%����%' then '�ÿ�--����'
when nvl(t1.apply_memo,dim2.memo_user)  like '%20%%' then 'Ͷ��--���������Ѵ���'
when nvl(t1.apply_memo,dim2.memo_user)  like '%30%%' then 'Ͷ��--���������Ѵ���'
when nvl(t1.apply_memo,dim2.memo_user)  like '%10%%' then 'Ͷ��--���������Ѵ���'
when nvl(t1.apply_memo,dim2.memo_user)  like '%5%%' then 'Ͷ��--���������Ѵ���'
when nvl(t1.apply_memo,dim2.memo_user)  like '%������Ʊ%' then '������Ʊ'
when nvl(t1.apply_memo,dim2.memo_user)  like '%��Ȩ%' then '����-������Ȩ'
when nvl(t1.apply_memo,dim2.memo_user) is not null then '����ԭ��'
else  'δ��д��Ӧ��������'  end  apply_memo,
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
t1.ticketprice,
case when t1.seats_name in('B','G','G1','G2','O','A','D','Z','I','J') then 'BGOADZIJ'
else '�������λ' end seatnametype,
case when t8.order_head_id is not null then '���������ౣ��'
else '-' end is_guard,
dim1.return_channel,
case when t9.channel in('��վ','�ֻ�') and t91.users_id is not null then '�ڴ���'
when t9.channel in('��վ','�ֻ�') and t9.pay_gate in(15,29,31) then '�ڴ���'
when t9.channel in('OTA','�콢��','��վ','�ֻ�') then t9.sub_channel
when t9.channel not in('OTA','�콢��','��վ','�ֻ�')  then t9.channel end  order_channel
 from dw.da_order_drawback t1
 join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
 left join dw.dim_segment_type t3 on t2.h_route_id=t3.h_route_id and t2.route_id=t3.route_id
 left join hdb.cq_airport t4 on t2.originairport=t4.threecodeforcity
 left join hdb.cq_airport t5 on t2.destairport=t5.threecodeforcity
left join (select distinct order_head_id
 from cqsale.cq_free_change_log@to_air
 where state in(1,2))t8 on t8.order_head_id=t1.flights_order_head_Id
 left join dw.fact_recent_order_detail t9 on t1.flights_order_head_id=t9.flights_order_head_id
 left join if.v_da_restrict_userinfo t91 on t9.client_id=t91.users_id
 --left join cqsale.cq_return_ticket_channel@to_air  t10 on t10.flights_order_head_id=t1.flights_order_head_id
 left join (select *
from(
select t1.segment_head_id,t1.unnormaltype,t1.reason,t1.PUBLISH_DATE,t1.LAST_PUBLISH,t1.DELAY_HOUR,
row_number()over(partition by segment_head_id
order by t1.last_publish desc) rid
from dw.tw_unnormal_flight t1)h1
where h1.rid=1) t6 on t1.segment_head_id=t6.segment_head_id
left join dw.da_foc_flight t7 on t1.segment_head_id=t7.segment_head_id
left join stg.s_cq_foc_landfee scfl on t7.foc_id=scfl.id
left join (select *
from(
select ct1.FLIGHTS_ORDER__HEAD_ID flights_order_head_id,
case when ct1.TERMINAL_ID<0 and nvl(ct1.web_id,0)=0 and ct1.SALE_TYPE_DETAIL <=2 then '��վ'
when ct1.TERMINAL_ID<0 and nvl(ct1.web_id,0)=0 and ct1.SALE_TYPE_DETAIL in(5,10) then 'С����'
when ct1.TERMINAL_ID<0 and nvl(ct1.web_id,0)=0 and ct1.SALE_TYPE_DETAIL in(3,8)  then 'IOS'
when ct1.TERMINAL_ID<0 and nvl(ct1.web_id,0)=0 and ct1.SALE_TYPE_DETAIL in(4,9)  then 'Android'
when ct1.TERMINAL_ID<0 and nvl(ct1.web_id,0)=0 then '������������'
when nvl(ct1.web_id,0) in(1219,128,146,1482,1483,150,2185,228,2932,2956,3420,3979,435,4621,6298,7314,940)
then ct3.abrv
when  nvl(ct1.web_id,0) >0 and regexp_like(ct3.name,'(B2G)|(�����ͻ�)|(���ſͻ�)')  then '�����ͻ�'
when  nvl(ct1.terminal_id,0) >0 and regexp_like(ct2.terminal,'(B2G)|(�����ͻ�)|(���ſͻ�)')  then '�����ͻ�'
else 'B2B' end  return_channel,
ct1.OPERATE_INFO,
ct1.USERS_ID,
ct1.RETURN_DATE,
row_number()over(partition by ct1.FLIGHTS_ORDER__HEAD_ID order by ct1.RETURN_DATE) rid
 from cqsale.cq_return_ticket_channel@to_air ct1
 left join stg.s_cq_terminal ct2 on ct1.terminal_id=ct2.terminal_id
 left join stg.s_cq_agent_info ct3 on ct1.web_id=ct3.agent_id
 )
 where rid=1 
) dim1 on dim1.flights_order_head_id=t1.flights_order_head_id
left join (select t1.flights_order_head_id,
       min(t1.memo_for_user)  memo_user
  from stg.s_cq_flights_head_history t1,
       stg.s_cq_order_head           t2,      
       stg.s_cq_flights_segment_head t9
 where t1.flights_order_head_id = t2.flights_order_head_id   
   and t2.segment_head_id = t9.segment_head_id
   and t9.origin_std >= to_date('2022-01-01', 'yyyy-mm-dd')
   and t9.origin_std <  to_date('2022-02-01', 'yyyy-mm-dd')
    and t1.log_code in (5,20)
    group by t1.flights_order_head_id
) dim2 on dim2.flights_order_head_Id=t1.flights_order_head_id




  where t1.origin_std>=date'2022-01-01'
 and t1.origin_std< date'2022-02-01'
 and t2.company_id=0
     )hb1
left join dw.dim_tq_history_rule hb2 on hb1.nationflag=hb2.nationflag 
and hb1.seat_type=hb2.seat_type and hb1.priod_date=hb2.priod_type and hb1.seats_name=hb2.seats_name
and hb1.segment_country=nvl(hb2.segment_country,hb1.segment_country)
and trunc(hb1.order_date)>=hb2.begin_date and trunc(hb1.order_date)<=nvl(hb2.end_date,trunc(sysdate))
)hb2
group by hb2.smonth,hb2.nationflag,--hb2.flights_segment_name,hb2.segment_country,
hb2.seat_type,hb2.focʵ���������ʱ��,case  when hb2.ticketprice=0 and hb2.money_fy=0 then '0Ԫ��Ʊ'
when hb2.��Ʊ����='����' and hb2.money_fy =0 then '0Ԫ����'
when hb2.��Ʊ����='����' and hb2.money_fy=0 then 
case when hb2.is_guard ='���������ౣ��' then '���ౣ��0Ԫ'
when hb2.�������� in('ȡ��','ȡ������') and hb2.����ʱ������ is not null then 'ȡ������0Ԫ'
when hb2.�������� ='����' and hb2.����ʱ������ ='���������淢��������3Сʱ���ϲ�����Ʊ' then '����3Сʱ0Ԫ'
when hb2.�������� ='����' and hb2.����ʱ������ in('���������淢��������90���ӵ�3Сʱ���ϲ�����Ʊ','���������淢��������3Сʱ���ϲ�����Ʊ')
 and hb2.money_date>=date'2021-09-01' then '����1.5Сʱ0Ԫ'
when hb2.�������� ='����' and hb2.����ʱ������ in('���������淢��������90���ӵ�3Сʱ���ϲ�����Ʊ',
'���������淢��������3Сʱ���ϲ�����Ʊ','���������淢��������15���ӵ�90���Ӳ�����Ʊ')
 and hb2.money_date>=date'2021-11-16' then '����15����0Ԫ'
when hb2.money_date>=hb2.origin_std and hb2.focʵ���������ʱ��='3h+' then '��ɺ���ʵ������3H0Ԫ'
when hb2.money_date>=hb2.origin_std and hb2.focʵ���������ʱ�� in('3h+','1.5h~3h') then '��ɺ���ʵ������1.5H0Ԫ'
when hb2.money_date>=hb2.origin_std and hb2.focʵ���������ʱ�� in('15min~90min') then '��ɺ���ʵ������15min0Ԫ'
when hb2.��������<>'��������' and hb2.����ʱ������ is not null then '���������๫�����Ʊ'
when hb2.apply_memo like '%����%' then hb2.apply_memo
when hb2.apply_memo in('�ÿ�--�����','�ÿ�--�����ع�') then '��ע-�����0Ԫ'
when hb2.apply_memo 
in('��˾--����ȡ��','��˾--����ʱ�̵���','��˾--���ౣ��','��˾--����������','��˾--��������','��˾--���ಹ��','��˾--���౸��')
then '��ע-����������0Ԫ'
when hb2.apply_memo 
in('�ÿ�--���','��˾--�۸���ˮ','����--ȼ������','�ÿ�--����','�ÿ�--����','�ÿ�--����','Ͷ�ߴ���') then '��ע-�ÿ�Ͷ��0Ԫ' 
when hb2.apply_memo <>'δ��д��Ӧ��������' then '0Ԫ��ע-��������0Ԫ'
else '�ޱ�ע0Ԫ' end
when hb2.money_fy>0 then '��Ʊ�շ�' end,hb2.��������,hb2.��������,hb2.priod_date,
hb2.��Ʊ����,hb2.apply_user,
case when hb2.DELAY_HOUR>=0.25 and hb2.DELAY_HOUR< 1.5 then '15m~90m'
when hb2.DELAY_HOUR>=1.5 and hb2.DELAY_HOUR< 3 then '1.5h~3h' 
when hb2.DELAY_HOUR>=3 and hb2.DELAY_HOUR< 5 then '3h~5h' 
when hb2.DELAY_HOUR>=5  then '5h' 
else 'δ�ӳ�' end ,
hb2.����ʱ������,
hb2.�շ�����,
hb2.is_guard,
hb2.return_channel,
hb2.order_channel,
zhengce,
seatnametype;
