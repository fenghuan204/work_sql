select *
 from stg.s_cq_city t1
 where t1.threecodeforcity='YNZ';
 
 
 
 select *
 from hdb.cq_airport t1
 where regexp_like(t1.city_name,'����|����|����|ę́|ǭ��|����|��ɽ|ɳ��|�ռ�|ʮ��|��߷����|��־��|����|����|����|��־��')
