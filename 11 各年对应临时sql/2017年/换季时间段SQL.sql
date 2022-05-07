select tt1.flight_date,syear,smonth,sdays,case when timediff1<>1 then enddate2-1 else enddate end enddate,
case when smonth='03' then syear||'ÏÄÇïº½¼¾'
when smonth='10' then syear||'/'||substr(to_number(syear)+1,3,2)||'¶¬´ºº½¼¾' end type
from(
select tt.*,lead(flight_date,1)over( order by flight_date) enddate2,lead(flight_date,1)over( order by flight_date)-enddate timediff1
from
(
select *
from
(
select flight_date,syear,smonth,weeks,sdays,lead(flight_date,1)over(order by flight_date) enddate
from
(
select *
from(
select t2.flight_date,to_char(t2.flight_date,'yyyy') syear,to_char(t2.flight_date,'mm') smonth,
to_char(t2.flight_date,'w') weeks,to_char(t2.flight_date,'day') sdays,row_number()over(partition by to_char(t2.flight_date,'yyyy'),to_char(t2.flight_date,'mm')
order by to_char(t2.flight_date,'w') desc) xid
 from (select  to_date('2005-01-01','yyyy-mm-dd')+rownum-1 flight_date
   from dual 
   connect by rownum<=50*365+12) t2
 where to_char(t2.flight_date,'mm') in('10')
 and to_char(t2.flight_date,'day')='ÐÇÆÚÈÕ')h1
 where h1.xid=1

union all


select *
from(
select  t2.flight_date,to_char(t2.flight_date,'yyyy'),to_char(t2.flight_date,'mm'),
to_char(t2.flight_date,'w'),to_char(t2.flight_date,'day'),row_number()over(partition by to_char(t2.flight_date,'yyyy'),to_char(t2.flight_date,'mm')
order by to_char(t2.flight_date,'w') desc) xid
 from (select  to_date('2005-01-01','yyyy-mm-dd')+rownum-1 flight_date
   from dual 
   connect by rownum<=50*365+12) t2
 where to_char(t2.flight_date,'mm') in('03')
 and to_char(t2.flight_date,'day')='ÐÇÆÚÁù')h1
 where h1.xid=1)h2)h3
 where h3.smonth='10'
 and h3.enddate is not null
 
 union all
 
 
 select *
from(
select flight_date,syear,smonth,weeks,sdays,lead(flight_date,1)over(order by flight_date) enddate
from(
select *
from(
select t2.flight_date,to_char(t2.flight_date,'yyyy') syear,to_char(t2.flight_date,'mm') smonth,
to_char(t2.flight_date,'w') weeks,to_char(t2.flight_date,'day') sdays,row_number()over(partition by to_char(t2.flight_date,'yyyy'),to_char(t2.flight_date,'mm')
order by to_char(t2.flight_date,'w') desc) xid
 from (select  to_date('2005-01-01','yyyy-mm-dd')+rownum-1 flight_date
   from dual 
   connect by rownum<=50*365+12) t2
 where to_char(t2.flight_date,'mm') in('03')
 and to_char(t2.flight_date,'day')='ÐÇÆÚÈÕ')h1
 where h1.xid=1

union all


select *
from(
select  t2.flight_date,to_char(t2.flight_date,'yyyy'),to_char(t2.flight_date,'mm'),
to_char(t2.flight_date,'w'),to_char(t2.flight_date,'day'),row_number()over(partition by to_char(t2.flight_date,'yyyy'),to_char(t2.flight_date,'mm')
order by to_char(t2.flight_date,'w') desc) xid
 from (select  to_date('2005-01-01','yyyy-mm-dd')+rownum-1 flight_date
   from dual 
   connect by rownum<=50*365+12) t2
 where to_char(t2.flight_date,'mm') in('10')
 and to_char(t2.flight_date,'day')='ÐÇÆÚÁù')h1
 where h1.xid=1)h2)h3
 where h3.smonth='03'
 and h3.enddate is not null
 
 )tt)tt1


/*select *
from(
select tt.*,lead(flight_date,1)over( order by flight_date) enddate2,lead(flight_date,1)over( order by flight_date)-enddate timediff1
  from tmp tt)t1
  where t1.timediff1<>1
  
 */

 
