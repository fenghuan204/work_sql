#����ɸѡ

select h1.client_id,h1.feature,h1.feature_value,h1.ticketnum,h1.totalnum,round(h1.totalnum/30,0) daynum,
DENSE_RANK() OVER(order by h1.totalnum/30) drank
from(select t1.client_id,case when t2.identify='troy' then 'troy'||'--'||t2.feature
else t2.identify end feature,t2.feature_value,count(1) ticketnum,
sum(count(1))over(partition by case when t2.identify='troy' then 'troy'||'--'||t2.feature
else t2.identify end,t2.feature_value) totalnum
  from dw.fact_order_detail t1
  left join dw.da_restrict_userinfo t2 on t1.client_id=t2.users_id
  where t1.channel in('��վ','�ֻ�')
    and t1.company_id=0
    and t1.order_day>=trunc(sysdate-30)
    and t1.seats_name is not null
    and t2.users_id is not null 
    and t1.seats_name <>'O'
    --and t1.r_tel='013000000000'
    group by t1.client_id,case when t2.identify='troy' then 'troy'||'--'||t2.feature
else t2.identify end,t2.feature_value)h1


#�����˺Űٷֱ�ɸѡ

select h2.client_id,h2.feature_id,h2.feature_value,trunc(sysdate) 
from(
select h1.client_id,h1.feature,h1.feature_id,h1.feature_value,h1.ticketnum,h1.totalnum,
sum(h1.ticketnum)over(partition by h1.feature,h1.feature_value order by client_id desc) pnum
from(select t1.client_id,case when t2.identify='troy' then 'troy'||'--'||t2.feature
else t2.identify end feature,t2.feature_id,t2.feature_value,count(1) ticketnum,
sum(count(1))over(partition by case when t2.identify='troy' then 'troy'||'--'||t2.feature
else t2.identify end,t2.feature_value) totalnum
  from dw.fact_order_detail t1
  left join dw.da_restrict_userinfo t2 on t1.client_id=t2.users_id
  where t1.channel in('��վ','�ֻ�')
    and t1.company_id=0
    and t1.order_day>=trunc(sysdate-60)
    and t1.seats_name is not null
    and t2.users_id is not null 
    and t1.seats_name <>'O'
   -- and t1.r_tel='013000000000'
    group by t1.client_id,case when t2.identify='troy' then 'troy'||'--'||t2.feature
else t2.identify end,t2.feature_value,t2.feature_id)h1
where not exists (select 1 from hdb.wb_agent_rcd tt1
where tt1.client_id=h1.client_id)
 and h1.totalnum>=120)h2
 where h2.pnum/h2.totalnum<=0.1;


 #������ʱ�ڴ���



---�ϳ���SQL
 insert into hdb.wb_agent_rcd_batch 
select 4 flag,round(sum(h2.ticketnum)/60,0) daynum,count(distinct h2.client_id) clientnum,trunc(sysdate) check_date
from(
select h1.client_id,h1.feature,h1.feature_id,h1.feature_value,h1.ticketnum,h1.totalnum,
sum(h1.ticketnum)over(partition by h1.feature,h1.feature_value order by client_id desc) pnum
from(select t1.client_id,case when t2.identify='troy' then 'troy'||'--'||t2.feature
else t2.identify end feature,t2.feature_id,t2.feature_value,count(1) ticketnum,
sum(count(1))over(partition by case when t2.identify='troy' then 'troy'||'--'||t2.feature
else t2.identify end,t2.feature_value) totalnum
  from dw.fact_order_detail t1
  left join dw.da_restrict_userinfo t2 on t1.client_id=t2.users_id
  where t1.channel in('��վ','�ֻ�')
    and t1.company_id=0
    and t1.order_day>=trunc(sysdate-60)
    and t1.seats_name is not null
    and t2.users_id is not null 
    and t1.seats_name <>'O'
    group by t1.client_id,case when t2.identify='troy' then 'troy'||'--'||t2.feature
else t2.identify end,t2.feature_value,t2.feature_id)h1
where not exists (select 1 from hdb.wb_agent_rcd tt1
where tt1.client_id=h1.client_id)
and not exists(select 1 from dw.da_lyuser tt2
where tt2.users_id_fk is not null
and tt2.users_id_fk=h1.client_id)
 and h1.totalnum>=60)h2
 where h2.pnum/h2.totalnum<=0.1;




--���������SQL
delete from hdb.wb_agent_rcd_batch
 where batch_id>14;
 
 insert into hdb.wb_agent_rcd_batch
 select t2.batch_id,round(count(1)/count(distinct t1.order_day),0),count(distinct t1.client_id),t2.create_date
from dw.fact_order_detail t1
join hdb.wb_agent_rcd t2 on t1.client_id=t2.client_id
where t2.batch_id>14
and t1.order_day>=trunc(sysdate-60)
group by t2.batch_id,t2.create_date;

commit;



--�������

insert into hdb.wb_agent_rcd 
select h2.client_id,h2.feature,h2.feature_id,h2.feature_value,trunc(sysdate) create_date,4 flag
from(
select h1.client_id,h1.feature,h1.feature_id,h1.feature_value,h1.ticketnum,h1.totalnum,
sum(h1.ticketnum)over(partition by h1.feature,h1.feature_value order by client_id desc) pnum
from(select t1.client_id,case when t2.identify='troy' then 'troy'||'--'||t2.feature
else t2.identify end feature,t2.feature_id,t2.feature_value,count(1) ticketnum,
sum(count(1))over(partition by case when t2.identify='troy' then 'troy'||'--'||t2.feature
else t2.identify end,t2.feature_value) totalnum
  from dw.fact_order_detail t1
  left join dw.da_restrict_userinfo t2 on t1.client_id=t2.users_id
  where t1.channel in('��վ','�ֻ�')
    and t1.company_id=0
    and t1.order_day>=trunc(sysdate-60)
    and t1.seats_name is not null
    and t2.users_id is not null 
    and t1.seats_name <>'O'
    group by t1.client_id,case when t2.identify='troy' then 'troy'||'--'||t2.feature
else t2.identify end,t2.feature_value,t2.feature_id)h1
where not exists (select 1 from hdb.wb_agent_rcd tt1
where tt1.client_id=h1.client_id)
and not exists(select 1 from dw.da_lyuser tt2
where tt2.users_id_fk is not null
and tt2.users_id_fk=h1.client_id)
 and h1.totalnum>=120)h2
 where h2.pnum/h2.totalnum<=0.1;



===================================================����Ϊ����ɸѡ����============================================

 �´����˺�ɸѡ����

create table hdb.wb_agent_rcd_factor as
select h2.*, case when h2.tnum/h2.totalnum<=0.2 then 0.2
when h2.tnum/h2.totalnum<=0.4 then 0.4
when h2.tnum/h2.totalnum<=0.6 then 0.6
when h2.tnum/h2.totalnum<=0.8 then 0.8
when h2.tnum/h2.totalnum<=1 then 1 end factor,
trunc(sysdate) create_date,
null factor_flag
from(
select h1.client_id,h1.feature,h1.feature_id,h1.feature_value,h1.ticketnum,h1.totalnum1,h3.pnum,
sum(h1.ticketnum)over(partition by h1.feature,h1.feature_value order by h1.ticketnum desc) tnum,
sum(h1.ticketnum)over(partition by h1.feature,h1.feature_value) totalnum
from(
select t1.client_id,case when t2.identify='troy' then 'troy'||'--'||t2.feature
else t2.identify end feature,t2.feature_id,t2.feature_value,count(1) ticketnum,
sum(count(1))over(partition by case when t2.identify='troy' then 'troy'||'--'||t2.feature
else t2.identify end,t2.feature_id,t2.feature_value) totalnum1
  from dw.fact_order_detail t1
  left join dw.da_restrict_userinfo t2 on t1.client_id=t2.users_id
  where t1.channel in('��վ','�ֻ�')
    and t1.company_id=0
    and t1.order_day>=trunc(sysdate-60)
    and t1.seats_name is not null
    and t2.users_id is not null 
    and t1.seats_name <>'O'
    group by t1.client_id,case when t2.identify='troy' then 'troy'||'--'||t2.feature
else t2.identify end,t2.feature_value,t2.feature_id
)h1
left join (
select case when t2.identify='troy' then 'troy'||'--'||t2.feature
else t2.identify end feature,t2.feature_id,t2.feature_value,count(distinct t1.traveller_name||t1.codeno) pnum
  from dw.fact_order_detail t1
  left join dw.da_restrict_userinfo t2 on t1.client_id=t2.users_id
  where t1.channel in('��վ','�ֻ�')
    and t1.company_id=0
    and t1.order_day>=trunc(sysdate-60)
    and t1.seats_name is not null
    and t2.users_id is not null 
    and t1.seats_name <>'O'
    group by case when t2.identify='troy' then 'troy'||'--'||t2.feature
else t2.identify end ,t2.feature_id,t2.feature_value
)h3 on h1.feature=h3.feature and nvl(h1.feature_value,'-')=nvl(h3.feature_value,'-') and nvl(h1.feature_id,0)=nvl(h3.feature_id,0)
where not exists (select 1 from hdb.wb_agent_rcd tt1
where tt1.client_id=h1.client_id)
and not exists(select 1 from dw.da_lyuser tt2
where tt2.users_id_fk is not null
and tt2.users_id_fk=h1.client_id)
and regexp_like(h1.feature,'(troy)|(ȥ�Ķ�)|(���������)|(������)')
)h2
where (h2.feature like '%troy%' or (h2.feature not like '%troy%' and h2.totalnum1>60))
and h2.pnum/h2.totalnum> 0.2;



  update  hdb.wb_agent_rcd_factor
 set factor_flag=1
 where client_Id in(
 select client_id
 from(
 select t1.client_id,t1.factor,t1.ticketnum,row_number()over(partition by t1.factor order by t1.ticketnum) srow
 from hdb.wb_agent_rcd_factor t1
 where  t1.factor=1
 group by t1.client_id,t1.factor,t1.ticketnum)h1
 where h1.srow<=4496);
 
 update  hdb.wb_agent_rcd_factor t1
 set factor_flag=1
 where  t1.factor=0.2;
 
 commit;
 
 
 update  hdb.wb_agent_rcd_factor
 set factor_flag=2
 where client_Id in(
 select client_id
 from(
 select t1.client_id,t1.factor,t1.ticketnum,row_number()over(partition by t1.factor order by t1.ticketnum) srow
 from hdb.wb_agent_rcd_factor t1
 where t1.factor=1
 group by t1.client_id,t1.factor,t1.ticketnum)h1
 where h1.srow>4496
 and h1.srow<=4496+3530);
 
 update  hdb.wb_agent_rcd_factor t1
 set factor_flag=2
 where  t1.factor=0.4;
 
 commit;
 
 
 
update  hdb.wb_agent_rcd_factor
 set factor_flag=3
 where client_Id in(
 select client_id
 from(
 select t1.client_id,t1.factor,t1.ticketnum,row_number()over(partition by t1.factor order by t1.ticketnum) srow
 from hdb.wb_agent_rcd_factor t1
 where  t1.factor=1
 group by t1.client_id,t1.factor,t1.ticketnum)h1
 where h1.srow>4496+3530
 and h1.srow<=4496+3530+2715);
 
    update  hdb.wb_agent_rcd_factor t1
 set factor_flag=3
 where  t1.factor=0.6;
 
 commit;
 
 
 update  hdb.wb_agent_rcd_factor
 set factor_flag=4
 where client_Id in(
 select client_id
 from(
 select t1.client_id,t1.factor,t1.ticketnum,row_number()over(partition by t1.factor order by t1.ticketnum) srow
 from hdb.wb_agent_rcd_factor t1
 where  t1.factor=1
 group by t1.client_id,t1.factor,t1.ticketnum)h1
 where h1.srow>4496+3530+2715
 and h1.srow<=4496+3530+2715+619);
 
 
     update  hdb.wb_agent_rcd_factor t1
 set factor_flag=4
 where  t1.factor=0.8;
 
 commit;
 
 
  update  hdb.wb_agent_rcd_factor
 set factor_flag=5
 where client_Id in(
 select client_id
 from(
 select t1.client_id,t1.factor,t1.ticketnum,row_number()over(partition by t1.factor order by t1.ticketnum) srow
 from hdb.wb_agent_rcd_factor t1
 where  t1.factor=1
 group by t1.client_id,t1.factor,t1.ticketnum)h1
 where h1.srow>4496+3530+2715+619
);

  update  hdb.wb_agent_rcd_factor t1
 set factor_flag=5
 where  t1.factor=1
 and t1.factor_flag is null;
 
 commit ;

 

=====================================����Ϊ�˺�ɸѡ����=================================================








##1 
select trunc(t.order_date) ��������,
       case
         when t1.ex_cfd2 = 'S' and t1.ex_nfd3 is not null then
          '���񾭼���'
         when t1.ex_nfd10 is not null then
          '������'
         else
          'ר����'
       end ��λ���� ,
       t1.seats_name ��λ,
       t3.min_seat_name ������Ͳ�λ,
       t1.ticket_price Ʊ��,
       t1.r_com_rate ����,
       t3.min_seat_price ������ͼ۸�,
       t3.rate ��ͼ۸����,
       case
         when t3.MIN_SEAT_NAME is null then
          '��ǰ������ͼ�'
         when t3.min_seat_price is null then
          '��ǰ������ͼ�'
         when t3.MIN_SEAT_NAME = t1.seats_name and
              t1.ticket_price * t1.r_com_rate = t3.min_seat_price * t3.RATE then
          '��ǰ������ͼ�'
         when t1.ticket_price * t1.r_com_rate >= t3.min_seat_price * t3.RATE then
          '����'
          when t1.ticket_price*t1.r_com_rate< t3.min_seat_price*t3.RATE and t1.seats_name in('P2','P5')  then 'P���'
       end �۸�����,
       count(1) Ʊ��
  from cqsale.cq_order@to_air t
  join cqsale.cq_order_head@to_air t1 on t.flights_order_id =
                                         t1.flights_order_id
  join hdb.wb_agent_rcd t2 on t.client_id = t2.CLIENT_ID
  left join cqsale.cq_min_price_rcd@to_air t3 on t3.ORDER_HEAD_ID =
                                                 t1.flights_order_head_id
 where t1.flag_id in (3, 5, 40)
   and t.order_date >= to_date('2018-10-25','yyyy-mm-dd')
 group by trunc(t.order_date),
          case
            when t1.ex_cfd2 = 'S' and t1.ex_nfd3 is not null then
             '���񾭼���'
            when t1.ex_nfd10 is not null then
             '������'
            else
             'ר����'
          end,
          case
            when t3.MIN_SEAT_NAME is null then
             '��ǰ������ͼ�'
            when t3.min_seat_price is null then
             '��ǰ������ͼ�'
            when t3.MIN_SEAT_NAME = t1.seats_name and
                 t1.ticket_price * t1.r_com_rate =
                 t3.min_seat_price * t3.RATE then
             '��ǰ������ͼ�'
            when t1.ticket_price * t1.r_com_rate >=
                 t3.min_seat_price * t3.RATE then
             '����'
             when t1.ticket_price*t1.r_com_rate< t3.min_seat_price*t3.RATE and t1.seats_name in('P2','P5')  then 'P���'
          end,
          t1.seats_name,
          t3.min_seat_name,
          t1.ticket_price,
          t1.r_com_rate,
          t3.min_seat_price,
          t3.rate;



##2

select trunc(t.order_date) ��������,
       case
         when t1.ex_cfd2 = 'S' and t1.ex_nfd3 is not null then
          '���񾭼���'
         when t1.ex_nfd10 is not null then
          '������'
         else
          'ר����'
       end ,
       t1.seats_name,
       t3.min_seat_name,
       t1.ticket_price,
       t1.r_com_rate,
       t3.min_seat_price,
       t3.rate,
       case
         when t3.MIN_SEAT_NAME is null then
          '��ǰ������ͼ�'
         when t3.min_seat_price is null then
          '��ǰ������ͼ�'
         when t3.MIN_SEAT_NAME = t1.seats_name and
              t1.ticket_price * t1.r_com_rate = t3.min_seat_price * t3.RATE then
          '��ǰ������ͼ�'
         when t1.ticket_price * t1.r_com_rate >= t3.min_seat_price * t3.RATE then
          '����'
          when t1.ticket_price*t1.r_com_rate< t3.min_seat_price*t3.RATE and t1.seats_name in('P2','P5')  then 'P���'
       end,
       count(1)
  from cqsale.cq_order@to_air t
  join cqsale.cq_order_head@to_air t1 on t.flights_order_id =
                                         t1.flights_order_id
  join hdb.wb_agent_rcd t2 on t.client_id = t2.CLIENT_ID
  left join cqsale.cq_min_price_rcd@to_air t3 on t3.ORDER_HEAD_ID =
                                                 t1.flights_order_head_id
 where t1.flag_id in (3, 5, 40)
   and t.order_date >= trunc(sysdate - 3)
 group by trunc(t.order_date),
          case
            when t1.ex_cfd2 = 'S' and t1.ex_nfd3 is not null then
             '���񾭼���'
            when t1.ex_nfd10 is not null then
             '������'
            else
             'ר����'
          end,
          case
            when t3.MIN_SEAT_NAME is null then
             '��ǰ������ͼ�'
            when t3.min_seat_price is null then
             '��ǰ������ͼ�'
            when t3.MIN_SEAT_NAME = t1.seats_name and
                 t1.ticket_price * t1.r_com_rate =
                 t3.min_seat_price * t3.RATE then
             '��ǰ������ͼ�'
            when t1.ticket_price * t1.r_com_rate >=
                 t3.min_seat_price * t3.RATE then
             '����'
             when t1.ticket_price*t1.r_com_rate< t3.min_seat_price*t3.RATE and t1.seats_name in('P2','P5')  then 'P���'
          end,
          t1.seats_name,
          t3.min_seat_name,
          t1.ticket_price,
          t1.r_com_rate,
          t3.min_seat_price,
          t3.rate;


      ##3


      select trunc(t.order_date),
       case
         when t1.ex_cfd2 = 'S' and t1.ex_nfd3 is not null then
          '���񾭼���'
         when t1.ex_nfd10 is not null then
          '������'
         else
          'ר����'
       end,
       t1.seats_name,
       t3.min_seat_name,
       t1.ticket_price,
       t1.r_com_rate,
       t3.min_seat_price,
       t3.rate,
       case
         when t3.MIN_SEAT_NAME is null then
          '��ǰ������ͼ�'
         when t3.min_seat_price is null then
          '��ǰ������ͼ�'
         when t3.MIN_SEAT_NAME = t1.seats_name and
              t1.ticket_price * t1.r_com_rate = t3.min_seat_price * t3.RATE then
          '��ǰ������ͼ�'
         when t1.ticket_price * t1.r_com_rate >= t3.min_seat_price * t3.RATE then
          '����'
          when t1.ticket_price*t1.r_com_rate< t3.min_seat_price*t3.RATE and t1.seats_name in('P2','P5')  then 'P���'
       end,
       count(1)
  from cqsale.cq_order@to_air t
  join cqsale.cq_order_head@to_air t1 on t.flights_order_id =
                                         t1.flights_order_id
  join hdb.wb_agent_rcd t2 on t.client_id = t2.CLIENT_ID
  left join cqsale.cq_min_price_rcd@to_air t3 on t3.ORDER_HEAD_ID =
                                                 t1.flights_order_head_id
 where t1.flag_id in (3, 5, 40)
   and t.order_date >= trunc(sysdate)
 group by trunc(t.order_date),
          case
            when t1.ex_cfd2 = 'S' and t1.ex_nfd3 is not null then
             '���񾭼���'
            when t1.ex_nfd10 is not null then
             '������'
            else
             'ר����'
          end,
          case
            when t3.MIN_SEAT_NAME is null then
             '��ǰ������ͼ�'
            when t3.min_seat_price is null then
             '��ǰ������ͼ�'
            when t3.MIN_SEAT_NAME = t1.seats_name and
                 t1.ticket_price * t1.r_com_rate =
                 t3.min_seat_price * t3.RATE then
             '��ǰ������ͼ�'
            when t1.ticket_price * t1.r_com_rate >=
                 t3.min_seat_price * t3.RATE then
             '����'
             when t1.ticket_price*t1.r_com_rate< t3.min_seat_price*t3.RATE and t1.seats_name in('P2','P5')  then 'P���'
          end,
          t1.seats_name,
          t3.min_seat_name,
          t1.ticket_price,
          t1.r_com_rate,
          t3.min_seat_price,
          t3.rate




## �������ν��в�ѯ

select t2.batch_id,
trunc(t.order_date) ��������,       
       case
         when t3.MIN_SEAT_NAME is null then
          '��ǰ������ͼ�'
         when t3.min_seat_price is null then
          '��ǰ������ͼ�'
         when t3.MIN_SEAT_NAME = t1.seats_name and
              t1.ticket_price * t1.r_com_rate = t3.min_seat_price * t3.RATE then
          '��ǰ������ͼ�'
         when t1.ticket_price * t1.r_com_rate >= t3.min_seat_price * t3.RATE then
          '����'
          when t1.ticket_price*t1.r_com_rate< t3.min_seat_price*t3.RATE and t1.seats_name in('P2','P5')  then 'P���'
       end,
       count(1)
  from cqsale.cq_order@to_air t
  join cqsale.cq_order_head@to_air t1 on t.flights_order_id =
                                         t1.flights_order_id
  join  hdb.wb_agent_rcd  t2 on t.client_id = t2.client_id
  left join cqsale.cq_min_price_rcd@to_air t3 on t3.ORDER_HEAD_ID =
                                                 t1.flights_order_head_id
 where t1.flag_id in (3, 5, 40)
   and t.order_date >= trunc(sysdate - 3)
   and t1.whole_flight like '9C%'
 group by t2.batch_id,
trunc(t.order_date) ,
       
       case
         when t3.MIN_SEAT_NAME is null then
          '��ǰ������ͼ�'
         when t3.min_seat_price is null then
          '��ǰ������ͼ�'
         when t3.MIN_SEAT_NAME = t1.seats_name and
              t1.ticket_price * t1.r_com_rate = t3.min_seat_price * t3.RATE then
          '��ǰ������ͼ�'
         when t1.ticket_price * t1.r_com_rate >= t3.min_seat_price * t3.RATE then
          '����'
          when t1.ticket_price*t1.r_com_rate< t3.min_seat_price*t3.RATE and t1.seats_name in('P2','P5')  then 'P���'
       end