--��Ʊ��������

/*�����������£�
��1���ۼ�������Ʊ�ֲ� --2999��3499��3999 3����Ʊ����ռ��
��2���ۼ�������Ʊ�����ֲ�-��ʡ��Ϊ��λ��
��3���ۼ�������Ʊ ��Ů����
��4���ۼ�������Ʊ ����ֲ�
��5���ۼ�������Ʊ����&ת���û��ֱ�ռ��
*/

--1��
select nvl(h2.stype,'�ϼ�'),sum(h2.ticketnum),round(sum(per)*100,2)||'%'
from(
select h1.stype,h1.ticketnum,h1.ticketnum/h1.totalnum per
from(
select case when t1.COMBO_NAME='��ɾͷɻ�ѡ���' then '��ͨ��2999��Ʊ'
when t1.COMBO_NAME='��ɾͷɾ�ѡ���' then '������3499��Ʊ'
when t1.COMBO_NAME='��ɾͷ���ѡ���' then '������3999��Ʊ'
end stype,count(1) ticketnum,sum(count(1))over(partition by 1) totalnum
 from yhq.cq_yhq_unlimited_combo@to_air t1
 where t1.CREATE_DATE>=to_DATE('2020-07-15 18:00:00','yyyy-mm-dd hh24:mi:ss')
 and t1.combo_name in('��ɾͷɻ�ѡ���','��ɾͷɾ�ѡ���','��ɾͷ���ѡ���')
 and t1.status<>2
 group by case when t1.COMBO_NAME='��ɾͷɻ�ѡ���' then '��ͨ��2999��Ʊ'
when t1.COMBO_NAME='��ɾͷɾ�ѡ���' then '������3499��Ʊ'
when t1.COMBO_NAME='��ɾͷ���ѡ���' then '������3999��Ʊ'
end)h1)h2
group by rollup(h2.stype);

--2��
select t4.province ʡ��,getgender(nvl(t3.IDNO,t2.IDNO)) �Ա�,getage(trunc(t1.create_date),
nvl(getbirthday(nvl(t3.IDNO,t2.IDNO)),nvl(t3.birthday,t2.BIRTHDAY))) ����,
case when t1.USER_ID is null then 'δ�һ�'
when t1.BUY_USER_ID=t1.USER_ID then '�Լ��һ�'
when t1.BUY_USER_ID<>t1.USER_ID then '��������' end �һ�������,

count(distinct t1.ticket_id) ��Ʊ��
from yhq.cq_yhq_unlimited_combo@to_air t1
left join cust.cq_flights_users@to_air t2 on t1.BUY_USER_ID=t2.users_id
left join cust.cq_flights_users_huiyuan@to_air t3 on t1.BUY_USER_ID=t3.users_id_fk
left join dw.adt_mobile_list t4 on substr(t1.BUY_CONTACT_PHONE,1,7) =t4.mobilenumber
/*where t1.CREATE_DATE>=to_DATE('2020-07-15 18:00:00','yyyy-mm-dd hh24:mi:ss')
 and t1.combo_name in('��ɾͷɻ�ѡ���','��ɾͷɾ�ѡ���','��ɾͷ���ѡ���')
 and t1.status<>2*/
group by t4.province,getgender(nvl(t3.IDNO,t2.IDNO)),getage(trunc(t1.create_date),
nvl(getbirthday(nvl(t3.IDNO,t2.IDNO)),nvl(t3.birthday,t2.BIRTHDAY))),
case when t1.USER_ID is null then 'δ�һ�'
when t1.BUY_USER_ID=t1.USER_ID then '�Լ��һ�'
when t1.BUY_USER_ID<>t1.USER_ID then '��������' end









