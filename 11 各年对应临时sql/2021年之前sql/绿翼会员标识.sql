select t.users_id �û�ID,
       t.cust_id ��ԱID,
       (case t.change_from
         when 0 then
          '����'
         when 1 then
          'PC'
         when 2 then
          'Mվ'
         when 3 then
          'IOS'
         when 4 then
          'Android'
         when 5 then
          '΢�Ź��ں�'
         when 10 then
          '΢��С����'
         when 11 then
          '����Wifi'
         when 12 then
          '����ͨ'
         when 13 then
          'OTAת��'
         else
          ''
       end) ����,
       (case t.authentication_methods
         when '1' then
          '�������'
         when '2' then
          '֧����'
         when '3' then
          '΢��'
         when '4' then
          '������'
         when '5' then
          'ֵ��'
         else
          ''
       end) ��֤��ʽ,
       t.authentication_scenario ��֤����
  from cq_users_huiyuan_change t
 where t.create_date >= to_date('2019-07-13', 'yyyy-mm-dd')
   and t.create_date <=
       to_date('2019-07-14 23:59:59', 'yyyy-mm-dd hh24:mi:ss')
