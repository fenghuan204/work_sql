select *
 from stg.s_cq_city t1
 where t1.threecodeforcity='YNZ';
 
 
 
 select *
 from hdb.cq_airport t1
 where regexp_like(t1.city_name,'扬州|重庆|遵义|茅台|黔江|济州|白山|沙巴|普吉|十堰|素叻他尼|胡志明|东京|羽田|成田|胡志明')
