CREATE OR REPLACE PROCEDURE TEMPLE_1001 IS
  TEMPN       NUMBER;
  V_FLAG      BOOLEAN;
  V_MAILBEGIN VARCHAR2(100);
  V_MAILEND   VARCHAR2(100);
BEGIN

  FOR CUR IN (SELECT USERS_ID
                FROM CQ_FLIGHTS_USERS T
               WHERE T.REGISTER_IP IN
                     (SELECT REGISTER_IP
                        FROM (SELECT COUNT(REGISTER_IP), REGISTER_IP
                                FROM CQ_FLIGHTS_USERS T
                               WHERE T.REG_DATE >= SYSDATE - 1
                               GROUP BY REGISTER_IP
                              HAVING COUNT(REGISTER_IP) > = 10))
                 AND REG_DATE >= SYSDATE - 2 / 24
                 AND MEMO IS NULL
                 AND IS_MOBILE_REG = 3
                 AND ADDRESS IS NULL) LOOP
    SELECT COUNT(1)
      INTO TEMPN
      FROM CQ_AGENT_BANLIST
     WHERE CLIENT_ID = CUR.USERS_ID;
    IF TEMPN = 0 THEN
      INSERT INTO CQ_AGENT_BANLIST
        (ID,
         CLIENT_ID,
         BANLIST_LV,
         ORDER_NUM,
         MEMO,
         STATUS,
         CREATE_USER,
         VALID_USER,
         VALID_DATE)
      VALUES
        (CQ_AGENT_BANLIST_S.NEXTVAL,
         CUR.USERS_ID,
         3,
         0,
         '去哪儿代理帐号集中封',
         1,
         90000,
         90000,
         SYSDATE);
      COMMIT;
    END IF;
  END LOOP;

  FOR CUR IN (SELECT USERS_ID, REGISTER_IP, REALNAME, IDNO, EMAIL
                FROM CQ_FLIGHTS_USERS T
               WHERE T.REGISTER_IP IN
                     (SELECT REGISTER_IP
                        FROM (SELECT COUNT(REGISTER_IP) AA, REGISTER_IP
                                FROM CQ_FLIGHTS_USERS T
                               WHERE T.REG_DATE >= SYSDATE - 1
                               GROUP BY REGISTER_IP
                              HAVING COUNT(REGISTER_IP) > = 5)
                       WHERE AA < 10)
                 AND REG_DATE >= SYSDATE - 2 / 24
                 AND MEMO IS NULL
                 AND IS_MOBILE_REG = 3
                 AND ADDRESS IS NULL) LOOP
    V_FLAG := FALSE;
    SELECT COUNT(1)
      INTO TEMPN
      FROM CQ_AGENT_BANLIST
     WHERE CLIENT_ID = CUR.USERS_ID;
    IF TEMPN = 0 THEN
      IF CUR.IDNO IS NOT NULL THEN
        SELECT COUNT(1)
          INTO TEMPN
          FROM CQ_FLIGHTS_USERS
         WHERE IDNO = CUR.IDNO
           AND REGISTER_IP = CUR.REGISTER_IP
           AND IS_MOBILE_REG = 3
           AND REG_DATE > SYSDATE - 1;
        IF TEMPN >= 5 THEN
          V_FLAG := TRUE;
        END IF;
      END IF;
      IF NOT V_FLAG THEN
        IF CUR.REALNAME IS NOT NULL THEN
          SELECT COUNT(1)
            INTO TEMPN
            FROM CQ_FLIGHTS_USERS
           WHERE REALNAME = CUR.REALNAME
             AND REGISTER_IP = CUR.REGISTER_IP
             AND IS_MOBILE_REG = 3
             AND REG_DATE > SYSDATE - 1;
          IF TEMPN >= 5 THEN
            V_FLAG := TRUE;
          END IF;
        END IF;
      END IF;
      IF NOT V_FLAG THEN
        V_MAILEND   := SUBSTR(CUR.EMAIL, INSTR(CUR.EMAIL, '@'));
        V_MAILBEGIN := NULL;
        FOR I IN 1 .. INSTR(CUR.EMAIL, '@') - 1 LOOP
          IF SUBSTR(CUR.EMAIL, I, 1) >= '0' AND
             SUBSTR(CUR.EMAIL, I, 1) <= '9' THEN
            EXIT;
          ELSE
            V_MAILBEGIN := V_MAILBEGIN || SUBSTR(CUR.EMAIL, I, 1);
          END IF;
        END LOOP;
        IF V_MAILBEGIN IS NOT NULL THEN
          SELECT COUNT(1)
            INTO TEMPN
            FROM CQ_FLIGHTS_USERS
           WHERE EMAIL LIKE V_MAILBEGIN || '%' || V_MAILEND
             AND REGISTER_IP = CUR.REGISTER_IP
             AND IS_MOBILE_REG = 3
             AND REG_DATE > SYSDATE - 1;
          IF TEMPN >= 5 THEN
            V_FLAG := TRUE;
          END IF;
        END IF;
      END IF;
      IF V_FLAG THEN
        INSERT INTO CQ_AGENT_BANLIST
          (ID,
           CLIENT_ID,
           BANLIST_LV,
           ORDER_NUM,
           MEMO,
           STATUS,
           CREATE_USER,
           VALID_USER,
           VALID_DATE)
        VALUES
          (CQ_AGENT_BANLIST_S.NEXTVAL,
           CUR.USERS_ID,
           3,
           0,
           '去哪儿代理帐号集中封',
           1,
           90000,
           90000,
           SYSDATE);
        COMMIT;
      END IF;
    END IF;
  END LOOP;

END TEMPLE_1001;

 
