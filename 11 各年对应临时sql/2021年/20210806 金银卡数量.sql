select t1.memberlevelid ������,case when t1.AUTOMEMBERLEVELID< t1.memberlevelid then '��ʱ�ȼ�'
when t1.AUTOMEMBERLEVELID=t1.memberlevelid then '�Զ��ȼ�' end �Ƿ��Զ��ȼ�,count(1) Ʊ��
,count(1)
from dw.da_user_level t1
where t1.memberlevelid>=3
and MEMBEREXPIREDATE>=trunc(sysdate)
group by t1.memberlevelid,case when t1.AUTOMEMBERLEVELID< t1.memberlevelid then '��ʱ�ȼ�'
when t1.AUTOMEMBERLEVELID=t1.memberlevelid then '�Զ��ȼ�' end;
