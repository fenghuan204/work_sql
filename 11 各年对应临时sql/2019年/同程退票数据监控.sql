--ͬ����Ʊ����

--ͬ�̴����ڼ������˸������Ż�

select trunc(t1.money_date) ��Ʊʱ��,trunc(t1.origin_std) ��������,
case when (t1.origin_std-t1.money_date)*24<0 then '��վ��'
when (t1.origin_std-t1.money_date)*24<24 then '[0,24H)'
when (t1.origin_std-t1.money_date)< 7 then '[1D,7D)'
when (t1.origin_std-t1.money_date)< 15 then '[7D,15D)'
when (t1.origin_std-t1.money_date)< 30 then '[15D,30D)'
when (t1.origin_std-t1.money_date)>=30 then '30+' end �˸���ǰ��,
count(1),sum(t1.money_fy)
from dw.da_order_drawback t1
where t1.web_id=146
and t1.origin_std>=to_date('2019-01-21','yyyy-mm-dd')
and t1.origin_std< to_date('2019-03-02','yyyy-mm-dd')
group by trunc(t1.money_date) ,trunc(t1.origin_std) ,
case when (t1.origin_std-t1.money_date)*24<0 then '��վ��'
when (t1.origin_std-t1.money_date)*24<24 then '[0,24H)'
when (t1.origin_std-t1.money_date)< 7 then '[1D,7D)'
when (t1.origin_std-t1.money_date)< 15 then '[7D,15D)'
when (t1.origin_std-t1.money_date)< 30 then '[15D,30D)'
when (t1.origin_std-t1.money_date)>=30 then '30+' end 


