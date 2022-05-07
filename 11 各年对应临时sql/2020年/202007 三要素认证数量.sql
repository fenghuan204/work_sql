--2018.12.18后记录为正式账号认证记录，之前为测试账号认证记录
select substr(t.timestamp,1,10) as "使用时间",
sum(CASE WHEN T.RESPMSG LIKE ('%认证一致%') or T.RESPMSG LIKE ('%认证不一致%') then 1 else 0 end) "成功次数",count(1) "总次数"
 from anl.fact_threevaild_detail t
WHERE T.TIMESTAMP>'2019-12-18'
group by substr(t.timestamp,1,10)
order by substr(t.timestamp,1,10)


