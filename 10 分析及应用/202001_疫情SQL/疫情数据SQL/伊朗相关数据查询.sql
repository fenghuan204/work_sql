select t2.origin_std 航班起飞时间,t1.r_flights_date,t1.whole_flight,t1.whole_segment,t1.name||' '||coalesce(t1.second_name,'') 姓名,
t1.codeno,t1.r_tel,t1.flag_id
 from cqsale.cq_Order_head@to_air t1
 join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
 where codeno in('640222199710151911',
'E67075969',
'64032319931027261X',
'E09818347',
'64038119970410273X',
'E19164028',
'642222199412261014',
'E33804184',
'640382199512032956',
'E19160044',
'640302199503281115',
'E21112797',
'640324199706062615',
'E57814371',
'64022119900715361X',
'E14850354')
and t1.r_flights_date>=to_date('2020-02-01','yyyy-mm-dd')
and t1.flag_id in(3,5,40,41,2)
