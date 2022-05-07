--套票宣传数据

/*数据需求如下：
（1）累计已售套票分布 --2999、3499、3999 3种套票销售占比
（2）累计已售套票地区分布-（省级为单位）
（3）累计已售套票 男女比例
（4）累计已售套票 年龄分布
（5）累计已售套票自用&转增用户分别占比
*/

--1、
select nvl(h2.stype,'合计'),sum(h2.ticketnum),round(sum(per)*100,2)||'%'
from(
select h1.stype,h1.ticketnum,h1.ticketnum/h1.totalnum per
from(
select case when t1.COMBO_NAME='想飞就飞惠选礼包' then '普通座2999套票'
when t1.COMBO_NAME='想飞就飞精选礼包' then '经济座3499套票'
when t1.COMBO_NAME='想飞就飞优选礼包' then '商务座3999套票'
end stype,count(1) ticketnum,sum(count(1))over(partition by 1) totalnum
 from yhq.cq_yhq_unlimited_combo@to_air t1
 where t1.CREATE_DATE>=to_DATE('2020-07-15 18:00:00','yyyy-mm-dd hh24:mi:ss')
 and t1.combo_name in('想飞就飞惠选礼包','想飞就飞精选礼包','想飞就飞优选礼包')
 and t1.status<>2
 group by case when t1.COMBO_NAME='想飞就飞惠选礼包' then '普通座2999套票'
when t1.COMBO_NAME='想飞就飞精选礼包' then '经济座3499套票'
when t1.COMBO_NAME='想飞就飞优选礼包' then '商务座3999套票'
end)h1)h2
group by rollup(h2.stype);

--2、
select t4.province 省份,getgender(nvl(t3.IDNO,t2.IDNO)) 性别,getage(trunc(t1.create_date),
nvl(getbirthday(nvl(t3.IDNO,t2.IDNO)),nvl(t3.birthday,t2.BIRTHDAY))) 年龄,
case when t1.USER_ID is null then '未兑换'
when t1.BUY_USER_ID=t1.USER_ID then '自己兑换'
when t1.BUY_USER_ID<>t1.USER_ID then '赠送他人' end 兑换人类型,

count(distinct t1.ticket_id) 套票数
from yhq.cq_yhq_unlimited_combo@to_air t1
left join cust.cq_flights_users@to_air t2 on t1.BUY_USER_ID=t2.users_id
left join cust.cq_flights_users_huiyuan@to_air t3 on t1.BUY_USER_ID=t3.users_id_fk
left join dw.adt_mobile_list t4 on substr(t1.BUY_CONTACT_PHONE,1,7) =t4.mobilenumber
/*where t1.CREATE_DATE>=to_DATE('2020-07-15 18:00:00','yyyy-mm-dd hh24:mi:ss')
 and t1.combo_name in('想飞就飞惠选礼包','想飞就飞精选礼包','想飞就飞优选礼包')
 and t1.status<>2*/
group by t4.province,getgender(nvl(t3.IDNO,t2.IDNO)),getage(trunc(t1.create_date),
nvl(getbirthday(nvl(t3.IDNO,t2.IDNO)),nvl(t3.birthday,t2.BIRTHDAY))),
case when t1.USER_ID is null then '未兑换'
when t1.BUY_USER_ID=t1.USER_ID then '自己兑换'
when t1.BUY_USER_ID<>t1.USER_ID then '赠送他人' end









