
#退改签数据



=========================中间数据==================================


create table hdb.temp_feng_1030 as
SELECT t2.flights_order_head_id,t2.sex
FROM DW.DA_ORDER_DRAWBACK T1
LEFT JOIN STG.S_CQ_ORDER_HEAD T2 ON T1.FLIGHTS_ORDER_HEAD_ID=T2.FLIGHTS_ORDER_HEAD_ID
where t2.sex in(2,3);






create table hdb.temp_feng_10301 as
SELECT t2.flights_order_head_id,
case when t2.EX_CFD2 ='S' and t2.ex_nfd3 is not null then '商务座'
when t2.EX_CFD10 is not null then '经济座'
end seattype
FROM DW.DA_ORDER_DRAWBACK T1
LEFT JOIN STG.S_CQ_ORDER_HEAD T2 ON T1.FLIGHTS_ORDER_HEAD_ID=T2.FLIGHTS_ORDER_HEAD_ID
where (t2.EX_CFD2 ='S' and t2.ex_nfd3 is not null)
or (t2.EX_CFD10 is not null);



create table hdb.temp_feng_10302 as
SELECT t2.flights_order_head_id,t2.sex
FROM dw.da_order_change T1
LEFT JOIN STG.S_CQ_ORDER_HEAD T2 ON t1.flights_order_head_id=T2.FLIGHTS_ORDER_HEAD_ID
where t2.sex in(2,3);




create table hdb.temp_feng_10303 as
SELECT t2.flights_order_head_id,case when t2.EX_CFD2 ='S' and t2.ex_nfd3 is not null then '商务座'
when t2.EX_CFD10 is not null then '经济座'
end seattype
FROM DW.da_order_change T1
LEFT JOIN STG.S_CQ_ORDER_HEAD T2 ON T1.FLIGHTS_ORDER_HEAD_ID=T2.FLIGHTS_ORDER_HEAD_ID
where (t2.EX_CFD2 ='S' and t2.ex_nfd3 is not null)
or (t2.EX_CFD10 is not null);


=========================update========================================

update dw.da_order_drawback t
set sex=(select sex from hdb.temp_feng_1030  t1
where t.flights_order_head_id=t1.flights_order_head_id)
where exists(select 1 from hdb.temp_feng_1030 t2
where t2.flights_order_head_id=t.flights_order_head_id);

commit;


--select count(1) from hdb.temp_feng_1030;  300660



update dw.da_order_drawback t
set seattype=(select seattype from hdb.temp_feng_10301  t1
where t.flights_order_head_id=t1.flights_order_head_id)
where exists(select 1 from hdb.temp_feng_10301 t2
where t2.flights_order_head_id=t.flights_order_head_id);

commit;

--select count(1) from hdb.temp_feng_10301;  618123




update dw.da_order_change t
set sex=(select sex from hdb.temp_feng_10302  t1
where t.flights_order_head_id=t1.flights_order_head_id)
where exists(select 1 from hdb.temp_feng_10302 t2
where t2.flights_order_head_id=t.flights_order_head_id);

commit;


--select count(1) from hdb.temp_feng_10302;  89024



update dw.da_order_change t
set seattype=(select seattype from hdb.temp_feng_10303  t1
where t.flights_order_head_id=t1.flights_order_head_id)
where exists(select 1 from hdb.temp_feng_10303 t2
where t2.flights_order_head_id=t.flights_order_head_id);

commit;


--select count(1) from hdb.temp_feng_10303;  95098