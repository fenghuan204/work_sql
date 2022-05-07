select trmnl_tp,
       case
         when trmnl_tp = '΢��' then
          '΢������'
         when trmnl_tp = 'Android' then
          '��׿����'
         when trmnl_tp = 'IOS' then
          'IOS����'
         when trmnl_tp in ('��վ', 'Mվ') and channel1 = '�ǹ������' then
          'ֱ������'
         when trmnl_tp in ('��վ', 'Mվ') and channel1 = '����' then
          '��������'
         else
          channel1
       end channel1,
       visit_date,
       sum(UV) UV,
       sum(PV) PV
  from dw.cj_sdaily_cmpid@to_ods
 where 1 = 1
   and visit_date >= to_date('2017-03-01', 'yyyy-mm-dd')
   and visit_date < to_date('2017-10-20', 'yyyy-mm-dd')
   and channel1 <> 'Display'
 group by trmnl_tp,
          case
            when trmnl_tp = '΢��' then
             '΢������'
            when trmnl_tp = 'Android' then
             '��׿����'
            when trmnl_tp = 'IOS' then
             'IOS����'
            when trmnl_tp in ('��վ', 'Mվ') and channel1 = '�ǹ������' then
             'ֱ������'
            when trmnl_tp in ('��վ', 'Mվ') and channel1 = '����' then
             '��������'
            else
             channel1
          end,
          visit_date
