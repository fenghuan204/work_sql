select t1.order_day ����,t1.company_id ��˾,
       case when t1.channel in('�ֻ�','��վ') and t1.station_id=2 then 'M��վ'
       when t1.channel in('�ֻ�','��վ') and t1.station_id in(5,10) then '΢��'
       else t1.channel end ����,
       count(1) ������,
       sum(count(1))over(partition by t1.order_day,t1.company_id) �պϼ�,
       round(avg(count(1))over(partition by t1.company_id,
       case when t1.channel in('�ֻ�','��վ') and t1.station_id=2 then 'M��վ'
       when t1.channel in('�ֻ�','��վ') and t1.station_id in(5,10) then '΢��'
       else t1.channel end),0) ƽ��Ʊ��,
        to_char(round(count(1)/sum(count(1))over(partition by t1.order_day,t1.company_id)*100,2),'fm99990.0099')||'%' ������ռ��,
        to_char(round(sum(count(1))over(partition by t1.company_id,case when t1.channel in('�ֻ�','��վ') and t1.station_id=2 then 'M��վ'
       when t1.channel in('�ֻ�','��վ') and t1.station_id in(5,10) then '΢��'
       else t1.channel end)/sum(count(1))over(partition by t1.company_id)*100,2),'fm9990.0099')||'%' ������ռ��
 from dw.fact_order_detail t1
 join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
 where t2.flag<>2
 and t1.order_day>=trunc(sysdate-28)
 and t1.order_day< trunc(sysdate)
 and t1.seats_name not in('B','G','G1','G2')
 group by t1.order_day,t1.company_id,
       case when t1.channel in('�ֻ�','��վ') and t1.station_id=2 then 'M��վ'
       when t1.channel in('�ֻ�','��վ') and t1.station_id in(5,10) then '΢��'
       else t1.channel end
       order by 1,2,4 desc;
 
