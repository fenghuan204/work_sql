/*
2019��ʯ��ׯ���ڽ�������Ⱥ����
1��ʯ��ׯ�����۳˻��˵Ļ������䣨0~11,12~17,18~23��24~30,31~40,41~50,51~60,60+�����Ա𡢹����أ�ʡ�ݡ����У�������Ƶ�ηֲ���1~2,3~4,5~6,7~12,12+����
����Ŀ�ģ��������Ρ�̽�ף���������ͬ�����������ˡ�2�ˡ�3�ˡ�4�ˡ�4�����ϣ�����Ʊ����������OTA��TMC������APP�����´���������Ӫ����-�������ļ��ŵ꣩�ֲ���
19��˻�����ǰһ��˻���¼�ж��ٱ�����ǰһ���19��ĳ˻�Ƶ�β㼶��1~2,3~4,5~6,7~12,12+���ж��ٱ������ж��ٱ����������˻��ˣ�
������Ƶ�ζ�Ӧ��Ⱥ��������ƽ��Ʊ�ۣ�����Ƶ��-1\2\3\4\5\6\7\8\9\10\11\12\12+,��������������ÿ�Ż�Ʊƽ��Ʊ�ۣ���
������ǰ�ڷֲ���0\1\2\3\4\5\6\7\8~14\15~30\30~60\60+����Ʊ���ֲ��������ߵķֲ�������Ƶ�Ρ�19��������һ���������ߡ������2���������ߡ����򳬹�2���������ߡ��˻�������ȥ�أ�����
�������ͷֲ�����ת���̡����������̣��Ļ�Ʊ���ֲ�
2��ʯ��ׯ���ڽ����ۺ������ݣ����ڡ�����������λ���������ʣ������������ݣ����ڡ����Ρ�����š�������
3��ʯ��ׯ��������Ⱥ��ʯ��ׯ������Ⱥ��������1Ҫ�������һ��
4��ʯ��ׯ��������Ⱥ�кӱ�ʡ��Ⱥ��������1Ҫ�������һ��
*/


select replace(replace(t3.wf_segment,'�ֶ�','�Ϻ�'),'����','�Ϻ�') wf_segment,
       t1.gender,
       t5.cust_province,
       t5.cust_city,
       t4.part,
       case when t1.channel in('��վ','�ֻ�') then '����APP'
       when t1.channel in('OTA','�콢��') then 'OTA'
       when t1.channel='B2G�����ͻ�' then 'B2G'
       else '����' end,
       case when t1.ahead_days<=14 then to_char(t1.ahead_days)
       when t1.ahead_days<=30 then '15~30'
       when t1.ahead_days<=45 then '31~45'
       when t1.ahead_days<=60 then '46~60'
       when t1.ahead_days>60 then '60+' end,
       t1.SEAT_TYPE,
       case when IS_WF=0 then '����'
       else '����' end,
       LY_TYPE,
       count(1)
 from dw.fact_recent_order_detail t1
 join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
 left join dw.dim_segment_type t3 on t2.h_route_id=t3.h_route_id and t2.route_id=t3.route_id
 left join dw.fact_orderhead_trippurpose@to_ods t4 on t1.flights_order_head_id=t4.flights_order_head_id
 left join dw.bi_order_region t5 on t1.flights_order_head_id=t5.flights_order_head_id
 where t1.flag_id=40
   and t1.flights_date>=to_date('2019-01-01','yyyy-mm-dd')
   and t1.flights_date< to_date('2020-07-01','yyyy-mm-dd')
   and t1.seats_name <>'O'
   and t1.nationflag='����'
   --and t1.sex=1
   and t2.flights_segment_name like '%ʯ��ׯ%'
   group by replace(replace(t3.wf_segment,'�ֶ�','�Ϻ�'),'����','�Ϻ�') ,
       t1.gender,
       t5.cust_province,
       t5.cust_city,
       t4.part,
       case when t1.channel in('��վ','�ֻ�') then '����APP'
       when t1.channel in('OTA','�콢��') then 'OTA'
       when t1.channel='B2G�����ͻ�' then 'B2G'
       else '����' end,
       case when t1.ahead_days<=14 then to_char(t1.ahead_days)
       when t1.ahead_days<=30 then '15~30'
       when t1.ahead_days<=45 then '31~45'
       when t1.ahead_days<=60 then '46~60'
       when t1.ahead_days>60 then '60+' end,
       t1.SEAT_TYPE,
       case when IS_WF=0 then '����'
       else '����' end,
       LY_TYPe;
       
       
       
       select 
       t4.part,
       case when t2.originairport_name ='ʯ��ׯ' then '����'
       else '����' end,
        case when t2.originairport_name ='ʯ��ׯ' then t2.destcity_name
       else t2.origincity_name end,
       count(1)
 from dw.fact_recent_order_detail t1
 join dw.da_flight t2 on t1.segment_head_id=t2.segment_head_id
 left join dw.dim_segment_type t3 on t2.h_route_id=t3.h_route_id and t2.route_id=t3.route_id
 left join dw.fact_orderhead_trippurpose@to_ods t4 on t1.flights_order_head_id=t4.flights_order_head_id
 where t1.flag_id=40
   and t1.flights_date>=to_date('2020-07-01','yyyy-mm-dd')
   and t1.flights_date< to_date('2020-09-01','yyyy-mm-dd')
   and t1.seats_name <>'O'
   and t1.nationflag='����'
   --and t1.sex=1
   and t2.flights_segment_name like '%ʯ��ׯ%'
   group by  t4.part,
       case when t2.originairport_name ='ʯ��ׯ' then '����'
       else '����' end,
        case when t2.originairport_name ='ʯ��ׯ' then t2.destcity_name
       else t2.origincity_name end;
   
  
