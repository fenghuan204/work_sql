--2018.12.18���¼Ϊ��ʽ�˺���֤��¼��֮ǰΪ�����˺���֤��¼
select substr(t.timestamp,1,10) as "ʹ��ʱ��",
sum(CASE WHEN T.RESPMSG LIKE ('%��֤һ��%') or T.RESPMSG LIKE ('%��֤��һ��%') then 1 else 0 end) "�ɹ�����",count(1) "�ܴ���"
 from anl.fact_threevaild_detail t
WHERE T.TIMESTAMP>'2019-12-18'
group by substr(t.timestamp,1,10)
order by substr(t.timestamp,1,10)


