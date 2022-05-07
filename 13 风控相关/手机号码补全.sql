delete from hdb.wb_add_mobile
where mobile in(select mobilenumber from dw.adt_mobile_list)


insert into hdb.wb_add_mobile as
select mobile
from(
SELECT DISTINCT  substr(getmobile(t.work_tel),1,7) mobile
FROM STG.S_CQ_ORDER t
where t.time_stamp>=trunc(sysdate-30)
union 

SELECT  substr(getmobile(t.mobile),1,7)
FROM STG.S_CQ_ORDER t
where t.time_stamp>=trunc(sysdate-30)

union 

SELECT   substr(getmobile(t1.r_tel),1,7)
FROM STG.S_CQ_ORDER_head t1
where t1.time_stamp>=trunc(sysdate-30)
union 

SELECT   substr(getmobile(t1.login_id),1,7)
FROM stg.c_cq_flights_users t1
where t1.reg_date>=trunc(sysdate-30)
union 

SELECT   substr(getmobile(t1.mobile),1,7)
FROM stg.c_cq_flights_users t1
where t1.reg_date>=trunc(sysdate-30)

union 
SELECT  substr( getmobile(t1.login_id),1,7)
FROM stg.c_cq_flights_users_huiyuan t1
where t1.reg_date>=trunc(sysdate-30)

union 
SELECT   substr(getmobile(t1.mobile),1,7)
FROM stg.c_cq_flights_users_huiyuan t1
where t1.reg_date>=trunc(sysdate-30))h1
left join dw.adt_mobile_list h2 on substr(h1.mobile,1,7)=h2.mobilenumber
where h1.mobile<>'-'
and h2.province is null;




delete  from hdb.wb_add_mobile
where substr(mobile,1,3) NOT  in('133','149','153','173','174','177','180','181','189','199','130','131','132','145','146','155','156','166','171','175','176','185',
'186','134','135','136','137','138','139','147','148','150','151','152','157','158','159','172','178','182','183','184','187','188','198','170','141','144');

commit;


insert into dw.adt_mobile_list
select t1.mobile7,null,t1.province,t1.city,null,null,null,0
from anl.temp_keepgoing_mobile@to_dds t1
where not exists(select mobilenumber
  from dw.adt_mobile_list  t2
  where t1.mobile7=t2.mobilenumber);
  
  
  
 select distinct t1.mobile7,null,t1.province,t1.city,null,
case when substr(t1.mobile7,1,4) in('1700','1701','1702','1410') then '电信'
when substr(t1.mobile7,1,4) in('1704','1707','1708','1709') then '联通'
when substr(t1.mobile7,1,4) in('1703','1705','1706','1440') then '移动'
when substr(t1.mobile7,1,3) in('133','149','153','173','174','177','180','181','189','199') then '电信' 
when substr(t1.mobile7,1,3) in('130','131','132','145','146','155','156','166','171','175','176','185',
'186') then '联通'
when substr(t1.mobile7,1,3) in('134','135','136','137','138','139','147',
'148','150','151','152','157','158','159','172','178','182','183','184','187','188','198') then '移动'
end type,null,0
from anl.temp_keepgoing_mobile@to_dds t1
where not exists(select 1
  from dw.adt_mobile_list  t2
  where t1.mobile7=t2.mobilenumber);
  
  
  


