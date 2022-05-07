       SELECT /*+parallel(4) */
               decode(A.BGO_FLAG,1,'BGO',0,'非BGO') 是否BGO舱位,
               NVL(B.ROOT_NATIONFALG, '-') 航线性质,
               NVL(B.SEGMENT_REGION, '-') 航线国家,
               NVL(B.INCOME_TYPE, '-') 收益类型,
               A.FLIGHT_DATE 航班日期,
               A.FLIGHT_NO 航班号,
               A.SEGMENT_CODE 航段,
               A.SEATS_PLAN 总计划数,
               A.TICKETS 已售量,
               A.REMAIN_TICKETS 剩余量,
               A.PRICE 民航公布价,
               A.TICKET_PRICE "机票收入(不含油）",
               A.ticket_adprice "机票收入（含油）"
          FROM (SELECT     T1.FLIGHT_DATE,
               CASE
                 WHEN T1.FLIGHT_DATE - TRUNC(SYSDATE) < 0 THEN
                  0
                 ELSE
                  T1.FLIGHT_DATE - TRUNC(SYSDATE)
               END AS AHEAD_DAYS,
               T1.BGO_FLAG,
               T1.SEGMENT_HEAD_ID,
               T1.SEGMENT_CODE,
               T1.FLIGHT_NO,
               T.TICKETS,
               T1.PRICE PRICE,
               T.TICKET_PRICE,
               t.ticket_adprice,
               T1.SEATS_PLAN,
               T1.ROUTE_ID,
               T1.H_ROUTE_ID,
               case
                 when T.TICKETS >= T1.SEATS_PLAN then
                  0
                 else
                  T1.SEATS_PLAN - T.TICKETS
               end REMAIN_TICKETS
          FROM (SELECT A.SEGMENT_HEAD_ID,
                       A.FLIGHTS_SEGMENT SEGMENT_CODE,
                       A.R_FLIGHTS_NO FLIGHT_NO,
                       A.ROUTE_ID,
                       A.H_ROUTE_ID,
                       A.PRICE,
                       1 BGO_FLAG,
                       TRUNC(A.ORIGIN_STD) FLIGHT_DATE,
                       B.PLAN_B + B.PLAN_G + B.PLAN_G1 + B.PLAN_G2 +
                       B.PLAN_O SEATS_PLAN
                  FROM CQSALE.CQ_FLIGHTS_SEGMENT_HEAD@TO_AIR A
                 LEFT JOIN CQSALE.CQ_FLIGHTS_SEATS_AMOUNT_PLAN@TO_AIR B ON A.SEGMENT_HEAD_ID =
                                                                            B.SEGMENT_HEAD_ID
                 WHERE A.FLAG <> 2
                   AND A.COMPANY_ID = 0
                   AND TRUNC(A.ORIGIN_STD) >=to_date('2020-01-01', 'yyyy-mm-dd')
                   AND TRUNC(A.ORIGIN_STD) <=to_date('2020-12-31', 'yyyy-mm-dd')
                UNION ALL
                SELECT A.SEGMENT_HEAD_ID,
                       A.FLIGHTS_SEGMENT SEGMENT_CODE,
                       A.R_FLIGHTS_NO FLIGHT_NO,
                       A.ROUTE_ID,
                       A.H_ROUTE_ID,
                       A.PRICE,
                       0 BGO_FLAG,
                       TRUNC(A.ORIGIN_STD) FLIGHT_DATE,
                      (PLAN_Y + PLAN_H + PLAN_K + PLAN_L + PLAN_M + PLAN_N +
                       PLAN_Q + PLAN_T + PLAN_X + PLAN_U + PLAN_E + PLAN_W +
                       PLAN_P + PLAN_P1 + PLAN_P2 + PLAN_R1 + PLAN_R2 +
                       PLAN_R3 + PLAN_R4 + NVL(PLAN_F, 0) + NVL(PLAN_F1, 0) +
                       NVL(PLAN_F2, 0) + NVL(PLAN_F3, 0) + NVL(PLAN_F4, 0) +
                       NVL(PLAN_C, 0) + NVL(PLAN_C1, 0) + NVL(PLAN_C2, 0) +
                       NVL(PLAN_C3, 0) + NVL(PLAN_C4, 0) + NVL(PLAN_S, 0) +
                       NVL(PLAN_V, 0) + NVL(PLAN_A, 0) + NVL(PLAN_D, 0) +
                       NVL(PLAN_I, 0) + NVL(PLAN_J, 0) + NVL(PLAN_Z, 0) +
                       NVL(PLAN_P3, 0) + NVL(PLAN_P4, 0) + NVL(PLAN_P5, 0)) AS SEATS_PLAN
                  FROM CQSALE.CQ_FLIGHTS_SEGMENT_HEAD@TO_AIR A
                 LEFT JOIN CQSALE.CQ_FLIGHTS_SEATS_AMOUNT_PLAN@TO_AIR B ON A.SEGMENT_HEAD_ID =
                                                                            B.SEGMENT_HEAD_ID
                 WHERE A.FLAG <> 2
                   AND TRUNC(A.ORIGIN_STD) >=to_date('2020-01-01', 'yyyy-mm-dd')
                   AND TRUNC(A.ORIGIN_STD) <=to_date('2020-12-31', 'yyyy-mm-dd')
                   AND A.COMPANY_ID = 0) T1
          LEFT JOIN (SELECT SEGMENT_HEAD_ID,
                            CASE
                              WHEN SEATS_NAME IN ('B', 'G', 'G1', 'G2', 'O') THEN
                               1
                              ELSE
                               0
                            END AS BGO_FLAG,
                            COUNT(1) AS TICKETS,
                            SUM(TICKET_PRICE * NVL(R_COM_RATE, 1)) AS TICKET_PRICE,
                            SUM((TICKET_PRICE+ad_fy) * NVL(R_COM_RATE, 1)) AS TICKET_adPRICE
                       FROM CQSALE.CQ_ORDER_HEAD@TO_AIR                      
                      WHERE WHOLE_FLIGHT LIKE '9C%'
                        AND SEATS_NAME IS NOT NULL
                        AND R_FLIGHTS_DATE >=to_date('2020-01-01', 'yyyy-mm-dd')
                        AND R_FLIGHTS_DATE <=to_date('2020-12-31', 'yyyy-mm-dd')
                        AND FLAG_ID IN (3, 5, 40, 41)
                      GROUP BY SEGMENT_HEAD_ID,
                               CASE
                                 WHEN SEATS_NAME IN
                                      ('B', 'G', 'G1', 'G2', 'O') THEN
                                  1
                                 ELSE
                                  0
                               END) T ON T.SEGMENT_HEAD_ID =
                                         T1.SEGMENT_HEAD_ID
                                     AND T1.BGO_FLAG = T.BGO_FLAG
         WHERE T1.SEATS_PLAN > 0)A           
          LEFT JOIN DW.DIM_SEGMENT_TYPE B ON A.ROUTE_ID = B.ROUTE_ID
                                         AND A.H_ROUTE_ID = B.H_ROUTE_ID
        
