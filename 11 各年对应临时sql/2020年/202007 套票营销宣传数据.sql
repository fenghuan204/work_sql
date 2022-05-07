/*
\*7.15-8.9   ���д�����������̣�ʡǮ��
8.3-8.9    ����ָ��������Ŀ�ĵأ������Ϊ׼*\


--Ӫ������ʹ��

select count(distinct t2.origincity_name) ʼ����������,count(distinct t2.destcity_name) �ִ��������,
       count(distinct t2.flights_city_name) ��������,count(distinct t2.segment_head_id) ������
  from dw.fact_combo_ticket t1
  join dw.da_flight t2 on t1.segment_head_id = t2.segment_head_id
 where t1.payflag=1;

select rownum TOP,flights_city_name ����
 from(
select t2.flights_city_name,sum(t1.ticket_num)
  from dw.fact_combo_ticket t1
  join dw.da_flight t2 on t1.segment_head_id = t2.segment_head_id
 where t1.flag_id=40
    and t1.r_flights_date>=to_date('2020-07-15','yyyy-mm-dd')
    and t1.r_flights_date<=to_date('2020-08-16','yyyy-mm-dd')
group by t2.flights_city_name
order by 2 desc)h1
where rownum<=30;


select rownum TOP,destcity_name Ŀ�ĵ�
from(
select t2.destcity_name,sum(t1.ticket_num)
  from dw.fact_combo_ticket t1
  join dw.da_flight t2 on t1.segment_head_id = t2.segment_head_id
 where t1.flag_id=40
     and t1.r_flights_date>=to_date('2020-07-15','yyyy-mm-dd')
    and t1.r_flights_date<=to_date('2020-08-16','yyyy-mm-dd')
group by t2.destcity_name
order by 2 desc)
where rownum<=30;*/



---ά��1---�˻�Ƶ���ܰ�

select rownum ����,split_part(sname,' -',1) ����, ticketnum �˻�Ƶ��,mile �����
froM(
select t1.sname,decode(t1.combo_name,'��ɾͷɻ�ѡ���',2999,'��ɾͷɾ�ѡ���',3499,'��ɾͷ���ѡ���',3999) comprice,
count(1) ticketnum,suM(t2.mile) mile,sum(t1.yhq_money) yhq_money
  from dw.fact_combo_ticket t1
  join dw.da_flight t2 on t1.segment_head_id = t2.segment_head_id
 where t1.flag_id =40
 and t2.flag<>2
 and t1.r_flights_date>=to_date('2020-07-15','yyyy-mm-dd')
 and t1.r_flights_date<=trunc(sysdate,'iw')-1
 group by t1.sname,decode(t1.combo_name,'��ɾͷɻ�ѡ���',2999,'��ɾͷɾ�ѡ���',3499,'��ɾͷ���ѡ���',3999)
 order by 3 desc,4 desc)
 where rownum<=10
 

/*
--ά��2 

select rownum ����,split_part(sname,' -',1) ����, mile �����
froM(
select t1.sname,count(1) ticketnum,suM(t2.mile) mile
  from dw.fact_combo_ticket t1
  join dw.da_flight t2 on t1.segment_head_id = t2.segment_head_id
 where t1.flag_id =40
 and t2.flag<>2
 and t1.r_flights_date>=to_date('2020-07-15','yyyy-mm-dd')
 and t1.r_flights_date<=to_date('2020-08-16','yyyy-mm-dd')
 group by t1.sname
 order by 3 desc,2 desc)
 where rownum<=10*/

---ά��4---ʡǮ�ܰ�

select rownum ����,split_part(sname,' -',1) ����,yhq_money ��ʡ���
froM(
select h1.sname,yhq_money  yhq_money
from(
select t1.sname, decode(t1.combo_name,'��ɾͷɻ�ѡ���',2999,'��ɾͷɾ�ѡ���',3499,'��ɾͷ���ѡ���',3999) comprice,
sum(t1.yhq_money) yhq_money
  from dw.fact_combo_ticket t1
  join dw.da_flight t2 on t1.segment_head_id = t2.segment_head_id
 where t1.flag_id =40
 and t2.flag<>2
  and t1.r_flights_date>=to_date('2020-07-15','yyyy-mm-dd')
 and t1.r_flights_date<=trunc(sysdate,'iw')-1
 group by t1.sname, decode(t1.combo_name,'��ɾͷɻ�ѡ���',2999,'��ɾͷɾ�ѡ���',3499,'��ɾͷ���ѡ���',3999))h1
 order by 2 desc)h1
 where rownum<=10;
 
 
 
 
 ---ά��1---�˻�Ƶ���ܰ�

select rownum ����,split_part(sname,' -',1) ����, ticketnum �˻�Ƶ��,mile �����
froM(
select t1.sname,decode(t1.combo_name,'��ɾͷɻ�ѡ���',2999,'��ɾͷɾ�ѡ���',3499,'��ɾͷ���ѡ���',3999) comprice,
count(1) ticketnum,suM(t2.mile) mile,sum(t1.yhq_money) yhq_money
  from dw.fact_combo_ticket t1
  join dw.da_flight t2 on t1.segment_head_id = t2.segment_head_id
 where t1.flag_id =40
 and t2.flag<>2
 and t1.r_flights_date>=trunc(sysdate,'iw')-7
 and t1.r_flights_date<=trunc(sysdate,'iw')-1
 group by t1.sname,decode(t1.combo_name,'��ɾͷɻ�ѡ���',2999,'��ɾͷɾ�ѡ���',3499,'��ɾͷ���ѡ���',3999)
 order by 3 desc,4 desc)
 where rownum<=10
 
 


  
 /*select t1.create_date �˶���Ʊ����ʱ��,t1.ticket_id,t1.buy_user_id ������,t1.combo_price ������Ʊ���,t1.user_id ��userid,
 t1.yhq_batch_id �˶���Ʊ�Ż�����,t1.LAST_UPDATE_TIME ������ʱ��,t1.status �˶�״̬,
 t2.orderday �˻���Ʊ��������,t2.minflightdate �˻���Ʊ�˻�ʱ��,t2.combo_name �˻���Ӧ��Ʊ����,t2.create_id �˻���Ӧ��Ʊ�Ż�����,
 t3.create_date �ѶҴ���ʱ��,t3.combo_price �Ѷ���Ʊ���, t3.ticket_id Ŀǰ�Ѷ���Ʊid,t3.user_id �Ѷ���Ʊusersid,
 t3.yhq_batch_id �Ѷ���Ʊ�Ż�����,t3.status �Ѷ�״̬,
 case when t1.create_date>t3.create_date then '�ȹ����˶�'
 when t1.create_date<=t3.create_date then '�����˶�' end ����ʱ������,
 case when t1.combo_price>t3.combo_price then 'ǰ�ߺ��'
 when t1.combo_price< t3.combo_price then 'ǰ�ͺ��'
  when t1.combo_price= t3.combo_price then 'ǰ��һ��' 
  end ǰ����Ʊ����
 
 from yhq.cq_yhq_unlimited_combo@to_air t1
 join(select t1.users_id,t1.combo_name,t1.create_id,min(t1.order_day) orderday,min(t1.r_flights_date) minflightdate
  from dw.fact_combo_ticket t1
  where t1.flag_id=40
  group by t1.users_id,t1.combo_name,t1.create_id
  )t2 on t1.user_id=t2.users_id 
  left join yhq.cq_yhq_unlimited_combo@to_air t3 on t2.users_id=t3.user_id and t3.yhq_batch_id=t2.create_id and t3.status=1
  where t1.status=2;
  
*/
