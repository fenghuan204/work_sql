---0����������·ݵĺ�������

insert into anl.adt_variflight_segment
select * from anl.adt_variflight_pro
where flightmonth='201807';



select * from anl.adt_variflight_pro
where flightmonth='201807'
for update;





---1��ɾ��10���Ժ������

delete from anl.temp_czr_20180131
where sdate>=to_date('2018-10-01','yyyy-mm-dd');

commit;

---2������9�µ�9C�ѷɺ���

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


---3��ɾ�����Ѿ���ȡ���ݵĺ���

delete from anl.adt_variflight_segment
where segment_code in('SWAZHA');


----4��������ȡ������

select t1.sdate ������,t1.ori ʼ��վ,t1.dst Ŀ��վ,t1.num ������
from anl.fact_variflight_his t1
where t1.sdate>=trunc((add_months(trunc(sysdate),-1)),'mm')
and t1.sdate< trunc(sysdate,'mm')
and t1.company='ִ�к�������';


select t1.sdate ������,t1.company ��˾,t1.ori ʼ��վ,t1.dst Ŀ��վ,t1.num ��λ��
from anl.fact_variflight_his t1
where t1.sdate>=trunc((add_months(trunc(sysdate),-1)),'mm')
and t1.sdate< trunc(sysdate,'mm')
and t1.company<>'ִ�к�������';


