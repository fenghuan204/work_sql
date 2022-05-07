select to_char(t.flights_date, 'yyyymm') ������,
       t2.nationflag ��������,
       case
         when t.seats_name in ('B', 'G', 'G1', 'G2', 'O') then
          'BGO'
         else
          'notBGO'
       end ��ɢ,
       case
         when t.channel in ('�ֻ�', '��վ') then
          '��������'
         when t.channel in ('OTA', '�콢��') then
          'OTA'
         else
          'B2B'
       end ��Ʊ����,
       case
         when t.channel in ('��վ', '�ֻ�') and r.users_id is not null then
          '����'
         when t.channel in ('��վ', '�ֻ�') and
              t.pay_gate in (15, 29, 31, 64, 71, 74) then
          '����'
         else
          '�Ǵ���'
       end �Ƿ����,
       case
         when pp.part like '%����%' then
          '����'
         when pp.part = '����' then
          '����'
         else
          '����'
       end ����Ŀ��,
       case
         when t1.book_type = 1 then
          '����'
         when t1.xtype_id = 3 then
          '����ѡ��'
         when t1.xtype_id in (6, 10, 17) then
          '��������'
         when t1.xtype_id = 7 then
          '���ϲ�ʳ'
         when t1.xtype_id = 16 then
          '���ͻ�'
         when t1.xtype_id = 20 then
          '����ҷ���'
         when t1.xtype_id = 21 and
              regexp_like(upper(t1.xproduct_name),
                          '(WIFI)|(WF)|(4G)|(������)') then
          'WIFI'
         when t1.xtype_id = 23 then
          '������������'
         else
          '����'
       end ���մ���,
       case
         when t1.channel in ('�ֻ�', '��վ') then
          '��������'
         when t1.channel in ('OTA', '�콢��') then
          'OTA'
         when t1.channel = '��������' then
          '��������'
         else
          'B2B'
       end ���չ�������,
       case
         when t2.origin_std <= t1.order_date then
          '00h'
         when (t2.origin_std - t1.order_date) * 24 <= 2 then
          '(00,02]h'
         when (t2.origin_std - t1.order_date) * 24 <= 3 then
          '(02,03]h'
         when (t2.origin_std - t1.order_date) * 24 <= 18 then
          '(03,18]h'
         when (t2.origin_std - t1.order_date) * 24 <= 24 then
          '(18,24]h'
         when (t2.origin_std - t1.order_date) * 24 <= 36 then
          '(24,36]h'
         when (t2.origin_std - t1.order_date) * 24 <= 48 then
          '(36,48]h'
         when t2.origin_std - t1.order_date <= 3 then
          '(2,3]d'
         when t2.origin_std - t1.order_date <= 5 then
          '(3,5]d'
         when t2.origin_std - t1.order_date <= 7 then
          '(5,7]d'
         else
          '(7,+)d'
       end ���չ�����ǰ��,
       decode(t1.pay_together, 0, 'һ��', 1, '����') ���չ��򳡾�,
       sum(t1.book_num) ��������,
       sum(t1.book_fee) ���ս��,
       0 ��Ʊ��
  from dw.fact_other_order_detail t1
  join dw.fact_order_detail t on t.flights_order_head_id =
                                 t1.flights_order_head_id
  left join dw.fact_orderhead_trippurpose@to_ods pp on pp.flights_order_head_id =
                                                       t1.flights_order_head_id
  left join dw.da_flight t2 on t2.segment_head_id = t1.segment_head_id
  left join dw.da_restrict_userinfo r on r.users_id = t.client_id
 where t1.company_id = 0
   and t1.flights_date >= to_date('2018-11-01', 'yyyy-mm-dd')
   and t1.flights_date < to_date('2020-01-01', 'yyyy-mm-dd')
   and t1.xtype_id not in (24, 25)
 group by to_char(t.flights_date, 'yyyymm'),
          t2.nationflag,
          case
            when t.seats_name in ('B', 'G', 'G1', 'G2', 'O') then
             'BGO'
            else
             'notBGO'
          end,
          case
            when t.channel in ('�ֻ�', '��վ') then
             '��������'
            when t.channel in ('OTA', '�콢��') then
             'OTA'
            else
             'B2B'
          end,
          case
            when t.channel in ('��վ', '�ֻ�') and r.users_id is not null then
             '����'
            when t.channel in ('��վ', '�ֻ�') and
                 t.pay_gate in (15, 29, 31, 64, 71, 74) then
             '����'
            else
             '�Ǵ���'
          end,
          case
            when pp.part like '%����%' then
             '����'
            when pp.part = '����' then
             '����'
            else
             '����'
          end,
          case
            when t1.book_type = 1 then
             '����'
            when t1.xtype_id = 3 then
             '����ѡ��'
            when t1.xtype_id in (6, 10, 17) then
             '��������'
            when t1.xtype_id = 7 then
             '���ϲ�ʳ'
            when t1.xtype_id = 16 then
             '���ͻ�'
            when t1.xtype_id = 20 then
             '����ҷ���'
            when t1.xtype_id = 21 and
                 regexp_like(upper(t1.xproduct_name),
                             '(WIFI)|(WF)|(4G)|(������)') then
             'WIFI'
            when t1.xtype_id = 23 then
             '������������'
            else
             '����'
          end,
          case
         when t1.channel in ('�ֻ�', '��վ') then
          '��������'
         when t1.channel in ('OTA', '�콢��') then
          'OTA'
         when t1.channel = '��������' then
          '��������'
         else
          'B2B'
       end,
          case
            when t2.origin_std <= t1.order_date then
             '00h'
            when (t2.origin_std - t1.order_date) * 24 <= 2 then
             '(00,02]h'
            when (t2.origin_std - t1.order_date) * 24 <= 3 then
             '(02,03]h'
            when (t2.origin_std - t1.order_date) * 24 <= 18 then
             '(03,18]h'
            when (t2.origin_std - t1.order_date) * 24 <= 24 then
             '(18,24]h'
            when (t2.origin_std - t1.order_date) * 24 <= 36 then
             '(24,36]h'
            when (t2.origin_std - t1.order_date) * 24 <= 48 then
             '(36,48]h'
            when t2.origin_std - t1.order_date <= 3 then
             '(2,3]d'
            when t2.origin_std - t1.order_date <= 5 then
             '(3,5]d'
            when t2.origin_std - t1.order_date <= 7 then
             '(5,7]d'
            else
             '(7,+)d'
          end,
          decode(t1.pay_together, 0, 'һ��', 1, '����')
-----��Ʊ--

union all

select to_char(t.flights_date, 'yyyymm') ������,
       t2.nationflag ��������,
       case
         when t.seats_name in ('B', 'G', 'G1', 'G2', 'O') then
          'BGO'
         else
          'notBGO'
       end ��ɢ,
       case
         when t.channel in ('�ֻ�', '��վ') then
          '��������'
         when t.channel in ('OTA', '�콢��') then
          'OTA'
         else
          'B2B'
       end ��Ʊ����,
       case
         when t.channel in ('��վ', '�ֻ�') and r.users_id is not null then
          '����'
         when t.channel in ('��վ', '�ֻ�') and
              t.pay_gate in (15, 29, 31, 64, 71, 74) then
          '����'
         else
          '�Ǵ���'
       end �Ƿ����,
       case
         when pp.part like '%����%' then
          '����'
         when pp.part = '����' then
          '����'
         else
          '����'
       end ����Ŀ��,
       '��Ʊ' ���մ���,
       null ���չ�������,
       null ���չ�����ǰ��,
       null ���չ��򳡾�,
       0 ��������,
       0 ���ս��,
       sum(case
             when t.seats_name is not null then
              1
             else
              0
           end) ��Ʊ��
  from dw.fact_order_detail t
  join dw.da_flight t2 on t2.segment_head_id = t.segment_head_id
  left join dw.fact_orderhead_trippurpose@to_ods pp on pp.flights_order_head_id =
                                                       t.flights_order_head_id
  left join dw.da_restrict_userinfo r on r.users_id = t.client_id
 where t.company_id = 0
   and t.flights_date >= to_date('2018-11-01', 'yyyy-mm-dd')
   and t.flights_date < to_date('2020-01-01', 'yyyy-mm-dd')
 group by to_char(t.flights_date, 'yyyymm'),
          t2.nationflag,
          case
            when t.seats_name in ('B', 'G', 'G1', 'G2', 'O') then
             'BGO'
            else
             'notBGO'
          end,
          case
            when t.channel in ('�ֻ�', '��վ') then
             '��������'
            when t.channel in ('OTA', '�콢��') then
             'OTA'
            else
             'B2B'
          end,
          case
            when t.channel in ('��վ', '�ֻ�') and r.users_id is not null then
             '����'
            when t.channel in ('��վ', '�ֻ�') and
                 t.pay_gate in (15, 29, 31, 64, 71, 74) then
             '����'
            else
             '�Ǵ���'
          end,
          case
            when pp.part like '%����%' then
             '����'
            when pp.part = '����' then
             '����'
            else
             '����'
          end

-----��������----       
union all

select to_char(t.flights_date, 'yyyymm') ������,
       t2.nationflag ��������,
       case
         when t.seats_name in ('B', 'G', 'G1', 'G2', 'O') then
          'BGO'
         else
          'notBGO'
       end ��ɢ,
       case
         when t.channel in ('�ֻ�', '��վ') then
          '��������'
         when t.channel in ('OTA', '�콢��') then
          'OTA'
         else
          'B2B'
       end ��Ʊ����,
       case
         when t.channel in ('��վ', '�ֻ�') and r.users_id is not null then
          '����'
         when t.channel in ('��վ', '�ֻ�') and
              t.pay_gate in (15, 29, 31, 64, 71, 74) then
          '����'
         else
          '�Ǵ���'
       end �Ƿ����,
       case
         when pp.part like '%����%' then
          '����'
         when pp.part = '����' then
          '����'
         else
          '����'
       end ����Ŀ��,
       '��������' ���մ���,
       '����' ���չ�������,
       null ���չ�����ǰ��,
       '����' ���չ��򳡾�,
       count(1) ��������,
       sum(b.feebag) ���ս��,
       0 ��Ʊ��
  from dw.fact_order_detail t
  join (select flights_order_head_id,
               sum(pay_weight) pay_weight,
               sum(fee_bag) feebag
          from dw.fact_dcs_money_detail
         where flights_date >= to_date('2018-11-01', 'yyyy-mm-dd')
           and flights_date < to_date('2020-01-01', 'yyyy-mm-dd')
           and fee_bag <> 0
         group by flights_order_head_id) b on b.flights_order_head_id =
                                              t.flights_order_head_id
  join dw.da_flight t2 on t2.segment_head_id = t.segment_head_id
  left join dw.da_restrict_userinfo r on r.users_id = t.client_id
  left join dw.fact_orderhead_trippurpose@to_ods pp on pp.flights_order_head_id =
                                                       t.flights_order_head_id
 where t.company_id = 0
   and t.flights_date >= to_date('2018-11-01', 'yyyy-mm-dd')
   and t.flights_date < to_date('2020-01-01', 'yyyy-mm-dd')
 group by to_char(t.flights_date, 'yyyymm'),
          t2.nationflag,
          case
            when t.seats_name in ('B', 'G', 'G1', 'G2', 'O') then
             'BGO'
            else
             'notBGO'
          end,
          case
            when t.channel in ('�ֻ�', '��վ') then
             '��������'
            when t.channel in ('OTA', '�콢��') then
             'OTA'
            else
             'B2B'
          end,
          case
            when t.channel in ('��վ', '�ֻ�') and r.users_id is not null then
             '����'
            when t.channel in ('��վ', '�ֻ�') and
                 t.pay_gate in (15, 29, 31, 64, 71, 74) then
             '����'
            else
             '�Ǵ���'
          end,
          case
            when pp.part like '%����%' then
             '����'
            when pp.part = '����' then
             '����'
            else
             '����'
          end

--------����ѡ��-----

union all

select to_char(t.flights_date, 'yyyymm') ������,
       t2.nationflag ��������,
       case
         when t.seats_name in ('B', 'G', 'G1', 'G2', 'O') then
          'BGO'
         else
          'notBGO'
       end ��ɢ,
       case
         when t.channel in ('�ֻ�', '��վ') then
          '��������'
         when t.channel in ('OTA', '�콢��') then
          'OTA'
         else
          'B2B'
       end ��Ʊ����,
       case
         when t.channel in ('��վ', '�ֻ�') and r.users_id is not null then
          '����'
         when t.channel in ('��վ', '�ֻ�') and
              t.pay_gate in (15, 29, 31, 64, 71, 74) then
          '����'
         else
          '�Ǵ���'
       end �Ƿ����,
       case
         when pp.part like '%����%' then
          '����'
         when pp.part = '����' then
          '����'
         else
          '����'
       end ����Ŀ��,
       '����ѡ��' ���մ���,
       '����' ���չ�������,
       null ���չ�����ǰ��,
       '����' ���չ��򳡾�,
       count(1) ��������,
       sum(b.feekdj) ���ս��,
       0 ��Ʊ��
  from dw.fact_order_detail t
  join (select flights_order_head_id, sum(fee_kdj) feekdj
          from dw.fact_dcs_money_detail
         where flights_date >= to_date('2018-11-01', 'yyyy-mm-dd')
           and fee_kdj <> 0
         group by flights_order_head_id) b on b.flights_order_head_id =
                                              t.flights_order_head_id
  join dw.da_flight t2 on t2.segment_head_id = t.segment_head_id
  left join dw.fact_orderhead_trippurpose@to_ods pp on pp.flights_order_head_id =
                                                       t.flights_order_head_id
  left join dw.da_restrict_userinfo r on r.users_id = t.client_id
 where t.company_id = 0
   and t.flights_date >= to_date('2018-11-01', 'yyyy-mm-dd')
   and t.flights_date < to_date('2020-01-01', 'yyyy-mm-dd')
 group by to_char(t.flights_date, 'yyyymm'),
          t2.nationflag,
          case
            when t.seats_name in ('B', 'G', 'G1', 'G2', 'O') then
             'BGO'
            else
             'notBGO'
          end,
          case
            when t.channel in ('�ֻ�', '��վ') then
             '��������'
            when t.channel in ('OTA', '�콢��') then
             'OTA'
            else
             'B2B'
          end,
          case
            when t.channel in ('��վ', '�ֻ�') and r.users_id is not null then
             '����'
            when t.channel in ('��վ', '�ֻ�') and
                 t.pay_gate in (15, 29, 31, 64, 71, 74) then
             '����'
            else
             '�Ǵ���'
          end,
          case
            when pp.part like '%����%' then
             '����'
            when pp.part = '����' then
             '����'
            else
             '����'
          end

------���ϲ�Ʒ----

union all

select nvl(substr(l.flight_date,1,6), to_char(l.order_day, 'yyyymm')) ������,
       nvl(t2.nationflag, '�޷��ж�') ��������,
       '�޷��ж�' ��ɢ,
       '�޷��ж�' ��Ʊ����,
       '�޷��ж�' �Ƿ����,
       '�޷��ж�' ����Ŀ��,
       case
         when l.category = 3 then
          '���Ͽ羳'
         when l.merchant_name = '�Ϻ�����������˰Ʒ���޹�˾' then
          '������˰Ʒ'
         when l.type_name in ('��ʳ', 'С��', '����') then
          '����' || l.type_name
         else
          '���ϼ���Ʒ'
       end ���մ���,
       '����-' || decode(l.terminal_type,
                       '2',
                       'wifi����',
                       '3',
                       '��վ',
                       '4',
                       '��������',
                       '5',
                       '����΢���̳�',
                       '6',
                       'M��վ',
                       '7',
                       '����',
                       '8',
                       'С����') ���չ�������,
       null ���չ�����ǰ��,
       '����' ���չ��򳡾�,
       sum(l.booknum) ��������,
       sum(l.bookfee) ���ս��,
       0 ��Ʊ��
  from dw.fact_prt_order_detail l
  join stg.prt_eshop_product p on p.id = l.product_id
  left join dw.da_foc_order t1 on t1.flights_date =
                                  to_date(l.flight_date, 'yyyymmdd')
                              and t1.flights_no =
                                  (case when length(l.flight_no) < 6 then
                                   '9C' || substr(l.flight_no, 1, 5) else
                                   substr(l.flight_no, 1, 7) end)

  left join dw.da_flight t2 on t1.flights_id = t2.flights_id
                           and t1.segment_code = t2.segment_code
 where nvl(to_date(l.flight_date, 'yyyymmdd'), l.order_day) >=
       to_date('2018-11-01', 'yyyy-mm-dd')
   and nvl(to_date(l.flight_date, 'yyyymmdd'), l.order_day) <
       to_date('2020-01-01', 'yyyy-mm-dd')
   and nvl(l.flight_no, '9C') like '9C%'
   and length(l.flight_date) in(0,8)
   and l.status in ('200', '300', '301', '400', '500')
   and (case when
        p.merchant_id = 10220 and regexp_like(p.name, '��ɾͷ�|�����') then 0 else 1 end) = 1
 group by nvl(substr(l.flight_date,1,6),
              to_char(l.order_day, 'yyyymm')),
          nvl(t2.nationflag, '�޷��ж�'),
          
          case
            when l.category = 3 then
             '���Ͽ羳'
            when l.merchant_name = '�Ϻ�����������˰Ʒ���޹�˾' then
             '������˰Ʒ'
            when l.type_name in ('��ʳ', 'С��', '����') then
             '����' || l.type_name
            else
             '���ϼ���Ʒ'
          end,
          '����-' || decode(l.terminal_type,
                          '2',
                          'wifi����',
                          '3',
                          '��վ',
                          '4',
                          '��������',
                          '5',
                          '����΢���̳�',
                          '6',
                          'M��վ',
                          '7',
                          '����',
                          '8',
                          'С����')
                          
                          
---�ŶӲ�---
union all 


select to_char(t.flights_date, 'yyyymm') ������,
       t2.nationflag ��������,
       case
         when t.seats_name in ('B', 'G', 'G1', 'G2', 'O') then
          'BGO'
         else
          'notBGO'
       end ��ɢ,
       case
         when t.channel in ('�ֻ�', '��վ') then
          '��������'
         when t.channel in ('OTA', '�콢��') then
          'OTA'
         else
          'B2B'
       end ��Ʊ����,
       case
         when t.channel in ('��վ', '�ֻ�') and r.users_id is not null then
          '����'
         when t.channel in ('��վ', '�ֻ�') and
              t.pay_gate in (15, 29, 31, 64, 71, 74) then
          '����'
         else
          '�Ǵ���'
       end �Ƿ����,
       case
         when pp.part like '%����%' then
          '����'
         when pp.part = '����' then
          '����'
         else
          '����'
       end ����Ŀ��,
       '�ŶӲ�' ���մ���,
       '�ŶӶ���' ���չ�������,
       null ���չ�����ǰ��,
       '����' ���չ��򳡾�,
       sum(b.dinner_num) ��������,
       sum(b.feekdj) ���ս��,
       0 ��Ʊ��
  from dw.fact_order_detail t
  join (select q.flights_order_head_id, sum(f.dinner_num)dinner_num, sum(f.dinner_price*f.dinner_num) feekdj
          from stg.s_cq_group_dinner_detail f
          join stg.s_cq_order_head q on f.order_head_id =q.flights_order_head_id
         where q.flag_id in (3, 5, 40, 41)
           and q.whole_flight like '9C%'
           and q.r_flights_date>=to_date('2018-11-01', 'yyyy-mm-dd')
           and q.r_flights_date< to_date('2020-01-01', 'yyyy-mm-dd')
         group by q.flights_order_head_id) b on b.flights_order_head_id =
                                              t.flights_order_head_id
  join dw.da_flight t2 on t2.segment_head_id = t.segment_head_id
  left join dw.fact_orderhead_trippurpose@to_ods pp on pp.flights_order_head_id =
                                                       t.flights_order_head_id
  left join dw.da_restrict_userinfo r on r.users_id = t.client_id
 where t.company_id = 0
   and t.flights_date >= to_date('2021-01-01', 'yyyy-mm-dd')
   and t.flights_date < to_date('2021-02-01', 'yyyy-mm-dd')
 group by to_char(t.flights_date, 'yyyymm'),
          t2.nationflag,
          case
            when t.seats_name in ('B', 'G', 'G1', 'G2', 'O') then
             'BGO'
            else
             'notBGO'
          end,
          case
            when t.channel in ('�ֻ�', '��վ') then
             '��������'
            when t.channel in ('OTA', '�콢��') then
             'OTA'
            else
             'B2B'
          end,
          case
            when t.channel in ('��վ', '�ֻ�') and r.users_id is not null then
             '����'
            when t.channel in ('��վ', '�ֻ�') and
                 t.pay_gate in (15, 29, 31, 64, 71, 74) then
             '����'
            else
             '�Ǵ���'
          end,
          case
            when pp.part like '%����%' then
             '����'
            when pp.part = '����' then
             '����'
            else
             '����'
          end
          
          
          
