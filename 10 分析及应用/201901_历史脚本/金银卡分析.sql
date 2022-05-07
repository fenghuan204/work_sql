--1、金银卡账号明细数据

/*
关联绿翼会员表，剔除掉无法找到证件号以及重复的数据
*/
with memberlevel as(
select *
  from (select t1.users_id,
               case
                 when MEMBERLEVELID = 3 then
                  '银卡'
                 when MEMBERLEVELID = 4 then
                  '金卡'
               end slevel,
               case
                 when MEMBERLEVELID = t1.automemberlevelid then
                  '自动'
                 when MEMBERLEVELID > t1.automemberlevelid then
                  '非自动'
               end stype,
               round(t1.memberexpiredate - t1.memberperiodstart, 0) expiredate,
               t1.memberlevelid,
               t1.automemberlevelid,
               t2.cust_id,
               t2.users_id_fk,
               t2.reg_date,
               t2.codeno,
               t2.CODETYPE,
               row_number() over(partition by t2.codeno order by t1.users_id) rid
          from dw.da_user_level t1
          join dw.da_lyuser t2 on t1.users_id = t2.users_id_fk
         where MEMBERLEVELID in (3, 4)) h1
 where h1.rid = 1);


--2、最近一年的销售数据

select t1.codeno,t1.codetype,t1.seat_type,
      case when t1.client_id=t6.users_id and t1.codeno=t6.codeno then '自购自乘'
      else '非自购' end stype1,
      t6.slevel,
      t6.stype stype2,
      t6.expiredate,
      case when t3.flights_order_head_id is not null and t3.money_fy> 0 then '付费退'
      when t3.flights_order_head_id is not null and t3.money_fy=0 then '免费退'
      else '其他' end stype3,
      t7.WEIGHT_GT_ALL+t7.WEIGHT_ZZ offline_weight,
      t7.weight_web online_weight,
      case when t7.bagw is null then '0'
      when t7.BAGW=0 then '0'
      when t7.BAGW<=5 then '(0,5]'
      when t7.BAGW<=10 then '(5,10]'
      when t7.BAGW<=15 then '(10,15]'
      when t7.BAGW<=20 then '(15,20]'
      when t7.BAGW<=25 then '(20,25]'
      when t7.BAGW<=30 then '(25,30]'
      when t7.BAGW> 30 then '30+' end bagw_type,
      case when t9.flights_order_head_id is not null then '购买手提'
      else '未购买手提' end st_type,
      case when t9.flights_order_head_Id is not null then 1
      when t1.seat_type ='经济座' then 1
      when t1.seat_type='商务经济座' and t7.BAGW>0 then 1
      when t7.WEIGHT_GT_ALL+t7.WEIGHT_ZZ+t7.weight_web>0 then 1
      when t7.BAGW>0 then 1 else 0 end is_luggage,
      count(1) tkt,
      sum(t7.bagw) tt_bagw,
      suM(t7.WEIGHT_GT_ALL+t7.WEIGHT_ZZ) tt_offweight,
      sum(t7.weight_web) tt_weight_web,
      sum(t7.fee_gt+t7.fee_zz) off_xlfee,
      sum(t7.fee_web) on_xlfee,
      sum(t9.book_fee) st_fee,
      sum(t3.money_fy) tuip_fy,
      sum(t5.changenum) changenum,
      sum(t5.change_fy) changefy 
  from dw.fact_recent_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
  join memberlevel t6 on t1.codeno=t6.codeno
left join dw.da_order_drawback t3 on t1.flights_order_head_id=t3.flights_order_head_id
left join (select t4.flights_order_head_id,count(1),sum(case when t4.money_fy>0 then 1 else  0 end) changenum,
                   sum(t4.money_fy*t4.rate) change_fy
              from dw.da_order_change t4
              group by t4.flights_order_head_id)t5 on t1.flights_order_head_id=t5.flights_order_head_id
left join dw.fact_luggage_detail t7 on t1.flights_order_head_id=t7.flights_order_head_id
left join(select t8.flights_order_head_id,sum(t8.book_num) book_num,sum(t8.book_fee) book_fee
              from dw.fact_other_order_detail t8 
              where t8.flights_date>=to_date('2020-08-01','yyyy-mm-dd')
     and t8.flights_date< to_date('2021-08-01','yyyy-mm-dd')
     and t8.xtype_id=23
     group by t8.flights_order_head_id)t9 on t1.flights_order_head_id=t9.flights_order_head_id
   where t1.flights_date>=to_date('2020-08-01','yyyy-mm-dd')
     and t1.flights_date< to_date('2021-08-01','yyyy-mm-dd')
     
              

