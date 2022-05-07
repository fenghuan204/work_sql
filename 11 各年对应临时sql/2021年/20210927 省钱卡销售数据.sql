select trunc(to_date(t1.CREATE_TIME,'yyyy-mm-dd hh24:mi:ss')) order_day, to_char(to_date(t1.CREATE_TIME,'yyyy-mm-dd hh24:mi:ss'),'hh24') ordertime,
decode(t1.ORDER_STATUS,401,'��Ԥ��',402,'����', 403,'�����',404,'��ȡ��',405,'��ʱȡ��',406,'�����˿�',407,'�˿���',408,'���˿�') orderstatus,
decode(t1.pay_id,44,'΢��',25,'֧����',58,'����׻���') ֧����ʽ,
sum(sales_num) sales_num,sum(order_price/100) price
 from  hdb.ec_order_goods t1
 where t1.goods_id=11
 and to_date(t1.CREATE_TIME,'yyyy-mm-dd hh24:mi:ss')>=trunc(sysdate)
 and t1.create_time>='2021-09-27 09:40:00'
 group by trunc(to_date(t1.CREATE_TIME,'yyyy-mm-dd hh24:mi:ss')) , to_char(to_date(t1.CREATE_TIME,'yyyy-mm-dd hh24:mi:ss'),'hh24') ,
decode(t1.ORDER_STATUS,401,'��Ԥ��',402,'����', 403,'�����',404,'��ȡ��',405,'��ʱȡ��',406,'�����˿�',407,'�˿���',408,'���˿�') ,
decode(t1.pay_id,44,'΢��',25,'֧����',58,'����׻���')
order by 1,2
