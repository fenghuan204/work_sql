select t1.memberlevelid 金银卡,case when t1.AUTOMEMBERLEVELID< t1.memberlevelid then '临时等级'
when t1.AUTOMEMBERLEVELID=t1.memberlevelid then '自动等级' end 是否自动等级,count(1) 票量
,count(1)
from dw.da_user_level t1
where t1.memberlevelid>=3
and MEMBEREXPIREDATE>=trunc(sysdate)
group by t1.memberlevelid,case when t1.AUTOMEMBERLEVELID< t1.memberlevelid then '临时等级'
when t1.AUTOMEMBERLEVELID=t1.memberlevelid then '自动等级' end;
