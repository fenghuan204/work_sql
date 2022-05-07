select count(distinct t1.mobile)
from dw.da_b2c_user t1
join dw.fact_mobile_statistics t2 on t1.mobile=t2.mobile
where t1.mobile<>'-'
and t1.reg_day>=to_date('2017-11-01','yyyy-mm-dd')
and t1.reg_day< to_date('2017-12-01','yyyy-mm-dd')
and t1.reg_day>=t2.min_flightdate
