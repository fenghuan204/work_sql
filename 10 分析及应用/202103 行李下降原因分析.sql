/*�ꡢ�¡����ڡ���Ʊ�������ڴ����ױ����ÿ������ϴ�����OTA������������Ʒ���ͣ���ͨ���������������񾭼��������������ʡ�ʼ��վ�����Ρ�
��λ���ͣ�BG����BG����������������ȡ����Ϲ����������������Ϲ�����������¹����������������¹��������
ʵ��������������(0��(0,10),10,(10,20),20,(20,30),30,30+)����Ʊ��
20210101~20210330*/

select to_char(t1.flights_date, 'yyyy') ��,
       to_char(t1.flights_date, 'mm') ��,
       t1.flights_date ��������,
       case
         when t1.channel in ('��վ', '�ֻ�') and b.users_id is not null then
          '����'
         when t1.channel in ('��վ', '�ֻ�') and
              t1.pay_gate in (15, 29, 31, 64, 71, 74) then
          '�ױ����ÿ�'
         when t1.channel in ('��վ', '�ֻ�') then
          '���ϴ���'
         when t1.channel in ('OTA', '�콢��') then
          'OTA'
         else
          '����'
       end ��Ʊ����,
       t1.seat_type ��Ʒ����,
       t1.nationflag ��������,
       t2.originairport_name ʼ��վ,
       t2.flights_segment_name ����,
       case
         when t1.seats_name in ('B', 'G', 'G1', 'G2', 'O') then
          'BGO'
         else
          '��BGO'
       end ��λ����,
       /*case
         when c.flights_order_head_id is not null then
          '��Ʊ'
         else
          '����Ʊ'
       end �Ƿ���Ʊ,*/
       /*nvl(l.weight_free, t1.weight_free) �������������,*/
       t1.weight_free �������������,
       greatest(nvl(l.weight_web, 0), 0) ���Ϲ�����������,
       greatest(nvl(l.fee_web, 0), 0) ���Ϲ���������,
       greatest(nvl(l.weight_gt, 0), 0) + greatest(nvl(l.weight_zz, 0), 0) +
       greatest(nvl(l.weight_xc, 0), 0) ���¹�����������,
       greatest(nvl(l.fee_gt, 0), 0) + greatest(nvl(l.fee_zz, 0), 0) +
       greatest(nvl(l.fee_xc, 0), 0) ���¹���������,
       greatest(nvl(l.weight_web, 0), 0) + greatest(nvl(l.weight_gt, 0), 0) +
       greatest(nvl(l.weight_zz, 0), 0) + greatest(nvl(l.weight_xc, 0), 0) �ϼƹ�����������,
       greatest(nvl(l.fee_web, 0), 0) + greatest(nvl(l.fee_gt, 0), 0) +
       greatest(nvl(l.fee_zz, 0), 0) + greatest(nvl(l.fee_xc, 0), 0) �ϼƹ���������,
       case
         when nvl(l.bagw, 0) <= 0 then
          '0'
         when nvl(l.bagw, 0) < 10 then
          '(0, 10)'
         when nvl(l.bagw, 0) = 10 then
          '10'
         when nvl(l.bagw, 0) < 20 then
          '(10, 20)'
         when nvl(l.bagw, 0) = 20 then
          '20'
         when nvl(l.bagw, 0) < 30 then
          '(20, 30)'
         when nvl(l.bagw, 0) = 30 then
          '30'
         when nvl(l.bagw, 0) > 30 then
          '30+'
         else
          null
       end ������������,
       count(1) ��Ʊ��,
       case
         when t1.weight_free >= l.bagw then
          '����Ҫ'
         else
          '��Ҫ'
       end �Ƿ���Ҫ��������
  from dw.fact_recent_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id = t2.segment_head_id
/*left join dw.fact_combo_ticket c on t1.flights_order_head_id =
                                      c.flights_order_head_id*/
  left join dw.fact_luggage_detail l on t1.flights_order_head_id =
                                        l.flights_order_head_id
  left join dw.da_restrict_userinfo b on t1.client_id = b.users_id
 where t1.whole_flight like '9C%'
   and t1.flights_date >= to_date('2021-01-01', 'yyyy-mm-dd')
   and t1.flights_date < to_date('2021-03-27', 'yyyy-mm-dd')
   and t1.flag_id in (3, 5, 40, 41)
   and t1.seats_name is not null
 group by to_char(t1.flights_date, 'yyyy'),
          to_char(t1.flights_date, 'mm'),
          t1.flights_date,
          case
            when t1.channel in ('��վ', '�ֻ�') and b.users_id is not null then
             '����'
            when t1.channel in ('��վ', '�ֻ�') and
                 t1.pay_gate in (15, 29, 31, 64, 71, 74) then
             '�ױ����ÿ�'
            when t1.channel in ('��վ', '�ֻ�') then
             '���ϴ���'
            when t1.channel in ('OTA', '�콢��') then
             'OTA'
            else
             '����'
          end,
          t1.seat_type,
          t1.nationflag,
          t2.originairport_name,
          t2.flights_segment_name,
          case
            when t1.seats_name in ('B', 'G', 'G1', 'G2', 'O') then
             'BGO'
            else
             '��BGO'
          end,
          /*case
            when c.flights_order_head_id is not null then
             '��Ʊ'
            else
             '����Ʊ'
          end,*/
          t1.weight_free,
       greatest(nvl(l.weight_web, 0), 0),
       greatest(nvl(l.fee_web, 0), 0),
       greatest(nvl(l.weight_gt, 0), 0) + greatest(nvl(l.weight_zz, 0), 0) +
       greatest(nvl(l.weight_xc, 0), 0),
       greatest(nvl(l.fee_gt, 0), 0) + greatest(nvl(l.fee_zz, 0), 0) +
       greatest(nvl(l.fee_xc, 0), 0),
       greatest(nvl(l.weight_web, 0), 0) + greatest(nvl(l.weight_gt, 0), 0) +
       greatest(nvl(l.weight_zz, 0), 0) + greatest(nvl(l.weight_xc, 0), 0),
       greatest(nvl(l.fee_web, 0), 0) + greatest(nvl(l.fee_gt, 0), 0) +
       greatest(nvl(l.fee_zz, 0), 0) + greatest(nvl(l.fee_xc, 0), 0),
       case
         when nvl(l.bagw, 0) <= 0 then
          '0'
         when nvl(l.bagw, 0) < 10 then
          '(0, 10)'
         when nvl(l.bagw, 0) = 10 then
          '10'
         when nvl(l.bagw, 0) < 20 then
          '(10, 20)'
         when nvl(l.bagw, 0) = 20 then
          '20'
         when nvl(l.bagw, 0) < 30 then
          '(20, 30)'
         when nvl(l.bagw, 0) = 30 then
          '30'
         when nvl(l.bagw, 0) > 30 then
          '30+'
         else
          null
       end,
       case
         when t1.weight_free >= l.bagw then
          '����Ҫ'
         else
          '��Ҫ'
       end;


------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*�ꡢ�¡����ڡ���Ʊ�������ڴ����ױ����ÿ������ϴ�����OTA������������Ʒ���ͣ���ͨ���������������񾭼��������������ʡ�ʼ��վ�����Ρ�
��λ���ͣ�BG����BG����������������ȡ����Ϲ����������������Ϲ�����������¹����������������¹��������
ʵ��������������(0��(0,10),10,(10,20),20,(20,30),30,30+)����Ʊ��
20190101~20190330*/

select to_char(t1.flights_date, 'yyyy') ��,
       to_char(t1.flights_date, 'mm') ��,
       t1.flights_date ��������,
       case
         when t1.channel in ('��վ', '�ֻ�') and b.users_id is not null then
          '����'
         when t1.channel in ('��վ', '�ֻ�') and
              t1.pay_gate in (15, 29, 31, 64, 71, 74) then
          '�ױ����ÿ�'
         when t1.channel in ('��վ', '�ֻ�') then
          '���ϴ���'
         when t1.channel in ('OTA', '�콢��') then
          'OTA'
         else
          '����'
       end ��Ʊ����,
       t1.seat_type ��Ʒ����,
       t1.nationflag ��������,
       t2.originairport_name ʼ��վ,
       t2.flights_segment_name ����,
       case
         when t1.seats_name in ('B', 'G', 'G1', 'G2', 'O') then
          'BGO'
         else
          '��BGO'
       end ��λ����,
       /*case
         when c.flights_order_head_id is not null then
          '��Ʊ'
         else
          '����Ʊ'
       end �Ƿ���Ʊ,*/
       /*nvl(l.weight_free, t1.weight_free) �������������,*/
       t1.weight_free �������������,
       greatest(nvl(l.weight_web, 0), 0) ���Ϲ�����������,
       greatest(nvl(l.fee_web, 0), 0) ���Ϲ���������,
       greatest(nvl(l.weight_gt, 0), 0) + greatest(nvl(l.weight_zz, 0), 0) +
       greatest(nvl(l.weight_xc, 0), 0) ���¹�����������,
       greatest(nvl(l.fee_gt, 0), 0) + greatest(nvl(l.fee_zz, 0), 0) +
       greatest(nvl(l.fee_xc, 0), 0) ���¹���������,
       greatest(nvl(l.weight_web, 0), 0) + greatest(nvl(l.weight_gt, 0), 0) +
       greatest(nvl(l.weight_zz, 0), 0) + greatest(nvl(l.weight_xc, 0), 0) �ϼƹ�����������,
       greatest(nvl(l.fee_web, 0), 0) + greatest(nvl(l.fee_gt, 0), 0) +
       greatest(nvl(l.fee_zz, 0), 0) + greatest(nvl(l.fee_xc, 0), 0) �ϼƹ���������,
       case
         when nvl(l.bagw, 0) <= 0 then
          '0'
         when nvl(l.bagw, 0) < 10 then
          '(0, 10)'
         when nvl(l.bagw, 0) = 10 then
          '10'
         when nvl(l.bagw, 0) < 20 then
          '(10, 20)'
         when nvl(l.bagw, 0) = 20 then
          '20'
         when nvl(l.bagw, 0) < 30 then
          '(20, 30)'
         when nvl(l.bagw, 0) = 30 then
          '30'
         when nvl(l.bagw, 0) > 30 then
          '30+'
         else
          null
       end ������������,
       count(1) ��Ʊ��,
       case
         when t1.weight_free >= l.bagw then
          '����Ҫ'
         else
          '��Ҫ'
       end �Ƿ���Ҫ��������
  from dw.fact_recent_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id = t2.segment_head_id
/*left join dw.fact_combo_ticket c on t1.flights_order_head_id =
                                      c.flights_order_head_id*/
  left join dw.fact_luggage_detail l on t1.flights_order_head_id =
                                        l.flights_order_head_id
  left join dw.da_restrict_userinfo b on t1.client_id = b.users_id
 where t1.whole_flight like '9C%'
   and t1.flights_date >= to_date('2019-01-01', 'yyyy-mm-dd')
   and t1.flights_date < to_date('2019-03-27', 'yyyy-mm-dd')
   and t1.flag_id in (3, 5, 40, 41)
   and t1.seats_name is not null
 group by to_char(t1.flights_date, 'yyyy'),
          to_char(t1.flights_date, 'mm'),
          t1.flights_date,
          case
            when t1.channel in ('��վ', '�ֻ�') and b.users_id is not null then
             '����'
            when t1.channel in ('��վ', '�ֻ�') and
                 t1.pay_gate in (15, 29, 31, 64, 71, 74) then
             '�ױ����ÿ�'
            when t1.channel in ('��վ', '�ֻ�') then
             '���ϴ���'
            when t1.channel in ('OTA', '�콢��') then
             'OTA'
            else
             '����'
          end,
          t1.seat_type,
          t1.nationflag,
          t2.originairport_name,
          t2.flights_segment_name,
          case
            when t1.seats_name in ('B', 'G', 'G1', 'G2', 'O') then
             'BGO'
            else
             '��BGO'
          end,
          /*case
            when c.flights_order_head_id is not null then
             '��Ʊ'
            else
             '����Ʊ'
          end,*/
          t1.weight_free,
       greatest(nvl(l.weight_web, 0), 0),
       greatest(nvl(l.fee_web, 0), 0),
       greatest(nvl(l.weight_gt, 0), 0) + greatest(nvl(l.weight_zz, 0), 0) +
       greatest(nvl(l.weight_xc, 0), 0),
       greatest(nvl(l.fee_gt, 0), 0) + greatest(nvl(l.fee_zz, 0), 0) +
       greatest(nvl(l.fee_xc, 0), 0),
       greatest(nvl(l.weight_web, 0), 0) + greatest(nvl(l.weight_gt, 0), 0) +
       greatest(nvl(l.weight_zz, 0), 0) + greatest(nvl(l.weight_xc, 0), 0),
       greatest(nvl(l.fee_web, 0), 0) + greatest(nvl(l.fee_gt, 0), 0) +
       greatest(nvl(l.fee_zz, 0), 0) + greatest(nvl(l.fee_xc, 0), 0),
       case
         when nvl(l.bagw, 0) <= 0 then
          '0'
         when nvl(l.bagw, 0) < 10 then
          '(0, 10)'
         when nvl(l.bagw, 0) = 10 then
          '10'
         when nvl(l.bagw, 0) < 20 then
          '(10, 20)'
         when nvl(l.bagw, 0) = 20 then
          '20'
         when nvl(l.bagw, 0) < 30 then
          '(20, 30)'
         when nvl(l.bagw, 0) = 30 then
          '30'
         when nvl(l.bagw, 0) > 30 then
          '30+'
         else
          null
       end,
       case
         when t1.weight_free >= l.bagw then
          '����Ҫ'
         else
          '��Ҫ'
       end;


----------------------------------------------------------------------------------------------------------------------------------------------------------------------


/*�ꡢ�¡����ڡ��������ʡ�ʼ��վ�����Ρ����Ϲ�����������¹�����������Ϲ�������������
��������������ʵ��������������������������Ʊ��
*/ /*20210101~20210327*/

select to_char(t1.flights_date, 'yyyy') ��,
       to_char(t1.flights_date, 'mm') ��,
       t1.flights_date ��������,
       t1.nationflag ��������,
       t2.originairport_name ʼ��վ,
       t2.flights_segment_name ����,
       sum(greatest(nvl(l.weight_web, 0), 0)) ���Ϲ�����������,
       sum(greatest(nvl(l.fee_web, 0), 0)) ���Ϲ���������,
       sum(greatest(nvl(l.weight_gt, 0), 0) +
           greatest(nvl(l.weight_zz, 0), 0) +
           greatest(nvl(l.weight_xc, 0), 0)) ���¹�����������,
       sum(greatest(nvl(l.fee_gt, 0), 0) + greatest(nvl(l.fee_zz, 0), 0) +
           greatest(nvl(l.fee_xc, 0), 0)) ���¹���������,
       sum(greatest(nvl(l.weight_web, 0), 0) +
           greatest(nvl(l.weight_gt, 0), 0) +
           greatest(nvl(l.weight_zz, 0), 0) +
           greatest(nvl(l.weight_xc, 0), 0)) �ϼƹ�����������,
       sum(greatest(nvl(l.fee_web, 0), 0) + greatest(nvl(l.fee_gt, 0), 0) +
           greatest(nvl(l.fee_zz, 0), 0) + greatest(nvl(l.fee_xc, 0), 0)) �ϼƹ���������,
       sum(nvl(l.bagw, 0)) ʵ��������������,
       count(1) ��Ʊ��,
       count(distinct t2.flights_id) ������
  from dw.fact_recent_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id = t2.segment_head_id
  left join dw.fact_luggage_detail l on t1.flights_order_head_id =
                                        l.flights_order_head_id
 where t1.whole_flight like '9C%'
   and t1.flights_date >= to_date('2021-01-01', 'yyyy-mm-dd')
   and t1.flights_date < to_date('2021-03-27', 'yyyy-mm-dd')
   and t1.flag_id in (3, 5, 40, 41)
   and t1.seats_name is not null
 group by to_char(t1.flights_date, 'yyyy'),
          to_char(t1.flights_date, 'mm'),
          t1.flights_date,
          t1.nationflag,
          t2.originairport_name,
          t2.flights_segment_name;

----------------------------------------------------------------------------------------------------------------------------------------------------------------------



/*�ꡢ�¡����ڡ��������ʡ�ʼ��վ�����Ρ����Ϲ�����������¹�����������Ϲ�������������
��������������ʵ��������������������������Ʊ��*//*20190101~20190327*/


select to_char(t1.flights_date, 'yyyy') ��,
       to_char(t1.flights_date, 'mm') ��,
       t1.flights_date ��������,
       t1.nationflag ��������,
       t2.originairport_name ʼ��վ,
       t2.flights_segment_name ����,
       sum(greatest(nvl(l.weight_web, 0), 0)) ���Ϲ�����������,
       sum(greatest(nvl(l.fee_web, 0), 0)) ���Ϲ���������,
       sum(greatest(nvl(l.weight_gt, 0), 0) +
           greatest(nvl(l.weight_zz, 0), 0) +
           greatest(nvl(l.weight_xc, 0), 0)) ���¹�����������,
       sum(greatest(nvl(l.fee_gt, 0), 0) + greatest(nvl(l.fee_zz, 0), 0) +
           greatest(nvl(l.fee_xc, 0), 0)) ���¹���������,
       sum(greatest(nvl(l.weight_web, 0), 0) +
           greatest(nvl(l.weight_gt, 0), 0) +
           greatest(nvl(l.weight_zz, 0), 0) +
           greatest(nvl(l.weight_xc, 0), 0)) �ϼƹ�����������,
       sum(greatest(nvl(l.fee_web, 0), 0) + greatest(nvl(l.fee_gt, 0), 0) +
           greatest(nvl(l.fee_zz, 0), 0) + greatest(nvl(l.fee_xc, 0), 0)) �ϼƹ���������,
       sum(nvl(l.bagw, 0)) ʵ��������������,
       count(1) ��Ʊ��,
       count(distinct t2.flights_id) ������
  from dw.fact_recent_order_detail t1
  join dw.da_flight t2 on t1.segment_head_id = t2.segment_head_id
  left join dw.fact_luggage_detail l on t1.flights_order_head_id =
                                        l.flights_order_head_id
 where t1.whole_flight like '9C%'
   and t1.flights_date >= to_date('2019-01-01', 'yyyy-mm-dd')
   and t1.flights_date < to_date('2019-03-27', 'yyyy-mm-dd')
   and t1.flag_id in (3, 5, 40, 41)
   and t1.seats_name is not null
 group by to_char(t1.flights_date, 'yyyy'),
          to_char(t1.flights_date, 'mm'),
          t1.flights_date,
          t1.nationflag,
          t2.originairport_name,
          t2.flights_segment_name;

