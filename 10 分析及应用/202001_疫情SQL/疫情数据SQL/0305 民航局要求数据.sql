drop table hdb.temp_recent_flights_cost purge;

create table hdb.temp_recent_flights_cost as
      select hh1.flights_id,
           hh1.segment_head_id,
           hh1.flight_no,
           hh1.flight_date,
           hh1.flights_segment,
           hh1.route_name,
           hh1.round_time,
           hh1.nation_flag,
           hh1.bax_num,
           hh1.it_num,
           hh1.infant_num,
           hh1.totalnum,
           hh1.bx_cabin_arr,
           hh1.checkin_num,
           hh1.bj_ticket_income,
           hh1.bj_ad_fy_income,
           hh1.it_ticket_income,
           hh1.it_ad_fy_income,
           hh1.total_income,
           hh1.tax_fee,
           hh1.per_fee,
           hh1.trans_cost,
           hh1.total_cost,
           hh1.DAY_INCOME,
           hh1.GDCOST_MONEY,
           hh1.ROUTE_MONEY,
           hh1.PORT_FEE,
           hh1.CUST_SER,
           hh1.SEC_CUST,
           hh1.SEC_GOODS,
           hh1.QJ_FEE,
           hh1.CAO_FEE,
           hh1.FUND_MONEY,
           hh1.FLIGHT_MONEY,
           hh1.DP_MONEY,
           hh1.vari_cost,
           hh1.GDFEE_MONEY,
           hh1.DP_FEE,
           hh1.price,
           hh1.r_Mile,
           hh1.S_MILE,
           hh1.K_MILE,
           hh1.checkin_mile,
           hh1.plan plan,
          checkin_s_mile,
          hh1.qr_flag,
          hh1.cost_flag,
          hh1.route_flag,
          hh1.bal_flag,
          hh3.ad_name,
          hh1.flight_time,
          sysdate create_date
      from(
      SELECT   t.flights_id,--航班ID++financial_qr数据
                        t.segment_head_id,--航段ID+financial_qr数据
                         t.Flights_No flight_no, --航班号
                        T.PLAN_FLIGHT_DATE flight_date, --航班日期
                        t.flights_segment,  --航段
                        T.ROUTE_NAME, --中文航段
                        f.round_time,  --轮档时间
                        t.nation_flag,  --航线性质
                        t.qr_flag, --1 经停航班合并的状态标识位,其它的为空
                        f.cost_flag, --0  实航班 ,1 用于经停的航班分段统计  2 同机中转, 3  经停同机中转合并的统计一条
                        f.route_flag, --0 实航班 1经停 2 同机中转
                        t.bal_flag, --结算状态
                        t.bax_num,  --包销人数
                        t.it_num,   --直接运输人数
                        t.infant_num,--婴儿人数
                        nvl(t.total_num,0) totalnum, --总人数 包销人数+直接运输人数
                        t.bx_cabin_arr, --包销值机人数
                        nvl((T.BX_CABIN_ARR + T.IT_NUM),0) checkin_num, --值机人数
                        nvl(T.BJ_TICKET_INCOME, 0) bj_ticket_income, --包机客运收入
                        nvl(T.BJ_AD_FY_INCOME, 0) bj_ad_fy_income, --包机燃油收入
                        nvl(T.IT_TICKET_INCOME, 0) it_ticket_income, --商务客运收入
                        nvl(T.IT_AD_FY_INCOME, 0) it_ad_fy_income, --商务客运收入
                        nvl(T.BJ_TICKET_INCOME, 0)+nvl(T.BJ_AD_FY_INCOME, 0 )
                        + nvl(T.IT_TICKET_INCOME, 0)+nvl(T.IT_AD_FY_INCOME, 0) total_income, --客运收入合计
                        nvl(F.TAX_FEE, 0) tax_fee, --税收
                        nvl(F.PER_FEE, 0) per_fee, --期间费用
                        nvl(F.TRANS_COST, 0) trans_cost, --运输成本
                        nvl(F.TAX_FEE, 0)+nvl(F.PER_FEE, 0)+nvl(F.TRANS_COST, 0) total_cost,  --客运成本合计
                        nvl(T.BJ_TICKET_INCOME, 0)+ nvl(T.BJ_AD_FY_INCOME, 0) +
                        nvl(T.IT_TICKET_INCOME, 0) + nvl(T.IT_AD_FY_INCOME, 0) -
                        nvl(F.TAX_FEE, 0) - nvl(F.PER_FEE, 0) - nvl(F.TRANS_COST, 0) DAY_INCOME, --航班收益
                        nvl(F.GDCOST_MONEY,0) GDCOST_MONEY, --航班固定成本(航班轮档时间*各基地当天小时固定成本)
                        nvl(F.ROUTE_MONEY,0) ROUTE_MONEY, --航路费
                        nvl(F.PORT_FEE,0) PORT_FEE, --机场基本收费
                        nvl(F.CUST_SER,0) CUST_SER, --旅客旅客服务费
                        nvl(F.SEC_CUST,0) SEC_CUST, --旅客安检费
                        nvl(F.SEC_GOODS,0) SEC_GOODS, --货邮安检费
                        nvl(F.QJ_FEE,0) QJ_FEE, --起降费=航路费＋机场基本收费＋旅客旅客服务费＋旅客安检费＋货邮安检费
                        nvl(F.CAO_FEE,0) CAO_FEE, --航油费
                        nvl(F.FUND_MONEY,0) FUND_MONEY, --民航基金
                        nvl(F.FLIGHT_MONEY,0) FLIGHT_MONEY, --飞行小时费
                        nvl(F.DP_MONEY,0) DP_MONEY,--维修成本
                        nvl(F.QJ_FEE,0)+nvl(F.CAO_FEE,0)+nvl(F.FUND_MONEY,0)+nvl(F.FLIGHT_MONEY,0)+nvl(F.DP_MONEY,0) vari_cost,--变动成本
                        nvl(F.GDFEE_MONEY,0) GDFEE_MONEY, --固定费用金额=航班轮档时间*各基地当天小时固定费用
                        nvl(F.DP_FEE,0) DP_FEE,
                        t.price, --民航公布价
                        nvl(F.r_Mile,0) r_Mile, --航线里程
                        nvl(F.S_MILE,0) S_MILE, --座公里 180*航线里程
                        nvl(T.K_MILE,0) K_MILE, --客公里(用于经停航班合并的乘机人* 每航段的公里数)
                        decode(t.qr_flag,1,t.K_MILE ,nvl((T.BX_CABIN_ARR + T.IT_NUM),0) * nvl(F.r_Mile,0)) checkin_mile,--客公里数
                        nvl(T.FLIGHTS_PLAN,0)  PLAN,--计划数
                        decode(t.qr_flag,1,nvl(F.S_MILE,0),nvl(t.seat_num,180) * nvl(F.r_Mile,0)) checkin_s_mile,   --座公里数
                        f.base_id, --基地ID
                        f.flight_time,
						t.seat_num		

                   FROM (
                select
                b1.FLIGHTS_DATE PLAN_FLIGHT_DATE ,
                b1.FLIGHTS_NO PLAN_FLIGHT_NO ,
                b1.flights_id,
                b1.segment_head_id,
                b1.flights_no,
                b1.flights_segment,
                b1.BX_CABIN_PLAN bax_num,
                b1.it_num,
                b1.infant_num,
                b1.total_num,
                b1.bx_cabin_arr,
                b1.bj_ticket_income,
                b1.bj_ad_fy_income,
                b1.it_ticket_income,
                b1.it_ad_fy_income,
                b1.bal_flag,
                b1.nation_flag,
                replace(replace(replace(replace(b1.FLIGHTS_SEGMENT_NAME,
                                                                 '---',
                                                                 '－'),
                                                         '--',
                                                         '－'),
                                                 '-',
                                                 '－'),
                                         '—',
                                         '－') as ROUTE_NAME,
                b1.price,
                b1.flights_plan,
                b1.k_mile,
                b1.qr_flag,
                b1.seat_num
                from cqsale.CQ_FINANCIAL_QR@to_air b1
                    where not exists (SELECT 1 FROM cqsale.cq_delay_flight@to_air c1 where  b1.FLIGHTS_DATE between  c1.START_DATE and  c1.END_DATE and b1.flights_no=c1.flights_no and b1.flights_segment=c1.flights_segment)
                and not exists (select 1 from cqsale.cq_filled_filghts_preserve@to_air a1 where b1.FLIGHTS_NO = a1.FILLED_FLIGHT_NO and b1.flights_date = a1.FILLED_FLIGHT_DATE)
             and  b1.FLIGHTS_DATE >= to_date('2014-02-15', 'yyyy-mm-dd')
                   union
                   select b2.FLIGHTS_DATE + 1 PLAN_FLIGHT_DATE ,
              b2.FLIGHTS_NO PLAN_FLIGHT_NO ,
              b2.flights_id,
              b2.segment_head_id,
              b2.flights_no,
              b2.flights_segment,
              b2.bx_cabin_plan,
              b2.it_num,
              b2.infant_num,
              b2.total_num,
              b2.bx_cabin_arr,
              b2.bj_ticket_income,
              b2.bj_ad_fy_income,
              b2.it_ticket_income,
              b2.it_ad_fy_income,
              b2.bal_flag,
              b2.nation_flag,
              replace(replace(replace(replace(b2.FLIGHTS_SEGMENT_NAME,
                                                                 '---',
                                                                 '－'),
                                                         '--',
                                                         '－'),
                                                 '-',
                                                 '－'),
                                         '—',
                                         '－') as ROUTE_NAME,
               b2.price,
               b2.flights_plan,
               b2.k_mile,
               b2.qr_flag,
               b2.seat_num
            from cqsale.CQ_FINANCIAL_QR@to_air b2
            where not exists (select 1 from cqsale.cq_filled_filghts_preserve@to_air a1 where b2.FLIGHTS_NO = a1.FILLED_FLIGHT_NO and b2.flights_date = a1.FILLED_FLIGHT_DATE)
            and exists (SELECT 1 FROM cqsale.cq_delay_flight@to_air c1 where  b2.FLIGHTS_DATE between  c1.START_DATE and  c1.END_DATE and b2.flights_no=c1.flights_no and b2.flights_segment=c1.flights_segment)
            and b2.FLIGHTS_DATE >= to_date('2014-02-15', 'yyyy-mm-dd') - 1
                 union
                SELECT D3.PLAN_FLIGHT_DATE PLAN_FLIGHT_DATE,
                       D3.PLAN_FLIGHT_NO PLAN_FLIGHT_NO,
                       b3.flights_id,
                       CASE
                         WHEN F1.ROUTE_FLAG = 0 OR B3.QR_FLAG = 1 THEN
                          F1.SEGMENT_HEAD_ID
                         ELSE
                          B3.SEGMENT_HEAD_ID
                       END SEGMENT_HEAD_ID,
                       b3.flights_no,
                       B3.FLIGHTS_SEGMENT,
                       B3.BX_CABIN_PLAN,
                       B3.IT_NUM,
                       B3.INFANT_NUM,
                       B3.TOTAL_NUM,
                       b3.bx_cabin_arr,
                       B3.BJ_TICKET_INCOME,
                       B3.BJ_AD_FY_INCOME,
                       B3.IT_TICKET_INCOME,
                       B3.IT_AD_FY_INCOME,
                       B3.BAL_FLAG,
                       B3.NATION_FLAG,
                       REPLACE(REPLACE(REPLACE(REPLACE(B3.FLIGHTS_SEGMENT_NAME,
                                                       '---',
                                                       '－'),
                                               '--',
                                               '－'),
                                       '-',
                                       '－'),
                               '—',
                               '－') AS ROUTE_NAME,
                       B3.PRICE,
                       B3.FLIGHTS_PLAN,
                       B3.K_MILE,
                       B3.QR_FLAG,
                       b3.seat_num
                    from cqsale.CQ_FINANCIAL_QR@to_air b3, (select distinct a.PLAN_FLIGHT_DATE,a.PLAN_FLIGHT_NO,a.FILLED_FLIGHT_NO,a.FILLED_FLIGHT_DATE from cqsale.cq_filled_filghts_preserve@to_air a) d3,cqsale.CQ_FLIGHTS_COST@to_air F1
                   where b3.FLIGHTS_NO = d3.FILLED_FLIGHT_NO
                   and b3.FLIGHTS_DATE = d3.FILLED_FLIGHT_DATE
                    and DECODE(LENGTH(F1.FLIGHTS_NO),7,SUBSTR(F1.FLIGHTS_NO,0,6),F1.FLIGHTS_NO) = d3.PLAN_FLIGHT_NO
                    and F1.FLIGHTS_DATE = d3.PLAN_FLIGHT_DATE
                    and F1.Flights_Segment = b3.flights_segment
                and d3.PLAN_FLIGHT_DATE >= to_date('2014-02-15', 'yyyy-mm-dd')
                                     ) T,
            cqsale.CQ_FLIGHTS_COST@to_air F,
        cqsale.CQ_FLIGHTS_SEGMENT_HEAD@to_air T1,
        cqsale.CQ_FLIGHTS_SEGMENT_ROUTE@to_air T2
        WHERE T.SEGMENT_HEAD_ID = T1.SEGMENT_HEAD_ID(+)
        AND T1.H_ROUTE_ID = T2.ROUTE_ID(+)
        AND T.SEGMENT_HEAD_ID = F.SEGMENT_HEAD_ID(+)
        AND (F.COST_FLAG = 0 OR F.COST_FLAG = 3 OR F.COST_FLAG IS NULL)
        and (case when T2.ROUTE_FLAG in (1, 2) then T.QR_FLAG else 1 end) = 1
        and t.PLAN_FLIGHT_NO like '9C%'
        and (length(CASE WHEN T2.ROUTE_FLAG = 1  THEN
                DECODE(T.FLIGHTS_SEGMENT,
                       T2.B_SEGMENT || T2.E_SEGMENT,
                       T.PLAN_FLIGHT_NO || 'XY',
                       T2.B_SEGMENT || T2.P_SEGMENT1,
                       T.PLAN_FLIGHT_NO || 'X',
                       T2.P_SEGMENT1 || T2.E_SEGMENT,
                       T.PLAN_FLIGHT_NO || 'Y',
                       T.PLAN_FLIGHT_NO)
               WHEN T2.ROUTE_FLAG = 0 OR F.COST_FLAG = 3 THEN
                T.PLAN_FLIGHT_NO
               ELSE
                T.PLAN_FLIGHT_NO
             END )<=6 OR T2.ROUTE_FLAG = 2))hh1      
      left join cqsale.cq_cost_adinfo@to_air hh3 on hh1.base_id=hh3.ad_id
      where hh1.flight_date>=to_date('2020-01-23','yyyy-mm-dd')
        and hh1.flight_date< trunc(sysdate);

        COMMIT;
		
		
		
		
		 update hdb.temp_recent_flights_cost t1
       set t1.route_name = replace(t1.route_name, '扬州', '扬州泰州')
     where t1.route_name like '%扬州%'
       and t1.route_name not like '%扬州泰州%';
    
    update hdb.temp_recent_flights_cost t1
       set t1.route_name = replace(t1.route_name, '普吉岛', '普吉')
     where t1.route_name like '%普吉岛%';
    
    update hdb.temp_recent_flights_cost t1
       set t1.route_name = replace(t1.route_name, '济州', '济州岛')
     where t1.route_name like '%济州%'
       and t1.route_name not like '%济州岛%';
    
    update hdb.temp_recent_flights_cost t1
       set t1.route_name = replace(t1.route_name, '十堰', '十堰（武当山）')
     where t1.route_name like '%十堰%'
       and t1.route_name not like '%十堰（武当山）%';
    
    update hdb.temp_recent_flights_cost t1
       set t1.route_name = replace(t1.route_name, '素叻他尼', '素叻他尼(万伦)')
     where t1.route_name like '%素叻他尼%'
       and t1.route_name not like '%素叻他尼(万伦)%';
    
    update hdb.temp_recent_flights_cost t1
       set t1.route_name = replace(t1.route_name, '胡志明', '胡志明市')
     where t1.route_name like '%胡志明%'
       and t1.route_name not like '%胡志明市%';
    
    update hdb.temp_recent_flights_cost t1
       set t1.route_name = replace(t1.route_name, '东京羽田', '东京')
     where t1.route_name like '%东京羽田%';
    
    update hdb.temp_recent_flights_cost t1
       set t1.route_name = replace(t1.route_name, '羽田', '东京')
     where t1.route_name like '%羽田%';
    
    update hdb.temp_recent_flights_cost t1
       set t1.route_name = replace(t1.route_name, '东京成田', '成田')
     where t1.route_name like '%东京成田%';
    
    commit;


	
	select t1.flight_date 航班日期,t1.flights_segment 航段,
t1.route_name 航段中文,t1.flight_no 航班号,
 case when t1.seat_num =180 then 'A320'
 when t1.seat_num=186 then 'A320'
 when t1.seat_num ='240' then 'A321' end,t1.seat_num 机型座位数,round(t1.checkin_s_mile,0) 可供座公里 ,null 国际航段当日是否独飞
 from hdb.temp_recent_flights_cost t1
                 where t1.flight_date>=to_date('2020-01-23','yyyy-mm-dd')
                   and t1.flight_date<=to_date('2020-02-29','yyyy-mm-dd')
                   and  t1.checkin_s_mile>0
                   and t1.nation_flag in(2,3);
				   
				   
  
  select t1.qr_flag,t1.flight_date 航班日期,t1.flights_segment 航段,
t1.route_name 航段中文,t1.flight_no 航班号,
 case when t1.seat_num =180 then 'A320'
 when t1.seat_num=186 then 'A320'
 when t1.seat_num ='240' then 'A321' end,t1.seat_num 机型座位数,round(t1.checkin_s_mile,0) 可供座公里 ,h2.s_mile 国际段座公里,
 null 国际航段当日是否独飞
 from hdb.temp_recent_flights_cost t1
 left join(select  h1.flights_date,substr(h1.flights_no,1,6) flights_no,h1.s_mile
               from cqsale.cq_flights_cost@to_air h1
               left join (select distinct t1.segment_code,t1.nationflag
                     from dw.da_flight t1
                     where t1.company_id=0
                     and t1.flag<>2)h2 on h1.flights_segment=h2.segment_code
               where substr(h1.flights_no,7,1) in('X','Y')
               and h1.flights_date>=to_date('2020-01-22','yyyy-mm-dd')
               and  h2.nationflag<>'国内'
               
               
               )h2 on t1.flight_date=h2.flights_date and t1.flight_no=h2.flights_no  
                 where t1.flight_date>=to_date('2020-01-23','yyyy-mm-dd')
                   and t1.flight_date<=to_date('2020-02-29','yyyy-mm-dd')
                   and  t1.checkin_s_mile>0
                   and t1.nation_flag in(2,3);
           