---0、插入相关月份的航段数据

insert into anl.adt_variflight_segment
select * from anl.adt_variflight_pro
where flightmonth='201807';



select * from anl.adt_variflight_pro
where flightmonth='201807'
for update;





---1、删除10月以后的数据

delete from anl.temp_czr_20180131
where sdate>=to_date('2018-10-01','yyyy-mm-dd');

commit;

---2、导入9月的9C已飞航线

insert into anl.adt_variflight_segment
select distinct h.originairport||h.destairport segment_code,h.originairport ori,h.destairport dst,'201809' months
from dw.da_flight@to_dg h 
left join
(select distinct t1.ori||t1.dst segment_code
from anl.temp_czr_20180131 t1
where t1.sdate>=to_date('2018-09-01','yyyy-mm-dd')
and t1.sdate< to_date('2018-10-01','yyyy-mm-dd'))h1 on h.segment_code=h1.segment_code
where h.flight_date>=to_date('2018-09-01','yyyy-mm-dd')
and h.flight_date<      to_date('2018-10-01','yyyy-mm-dd')
and h.company_id=0
and h1.segment_code is  null;


---3、删除掉已经爬取数据的航线

delete from anl.adt_variflight_segment
where segment_code in('SWAZHA');


----4、最终提取的数据

select t1.sdate 航日期,t1.ori 始发站,t1.dst 目的站,t1.num 航班量
from anl.fact_variflight_his t1
where t1.sdate>=trunc((add_months(trunc(sysdate),-1)),'mm')
and t1.sdate< trunc(sysdate,'mm')
and t1.company='执行航班总量';


select t1.sdate 航日期,t1.company 航司,t1.ori 始发站,t1.dst 目的站,t1.num 座位数
from anl.fact_variflight_his t1
where t1.sdate>=trunc((add_months(trunc(sysdate),-1)),'mm')
and t1.sdate< trunc(sysdate,'mm')
and t1.company<>'执行航班总量';


