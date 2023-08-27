--GRANT SELECT ON FND.FND_LOOKUP_REL_TABLES TO SUP_BACKEND
--GRANT SELECT ON FND.FND_LOOKUP_VALUES TO SUP_BACKEND
SELECT T.NAM_TABLE_LKPRT AS TBL
      ,T.NAM_COLUMN_LKPRT AS COL
      ,(SELECT CC.COMMENTS
          FROM ALL_COL_COMMENTS CC
         WHERE 1 = 1
               AND CC.COMMENTS IS NOT NULL
               AND CC.TABLE_NAME = T.NAM_TABLE_LKPRT
               AND CC.COLUMN_NAME = T.NAM_COLUMN_LKPRT
               AND ROWNUM = 1) AS COMMNET
      ,V.VAL_LOOKUP_LKPVL
      ,V.DES_FARSI_LKPVL
  FROM FND.FND_LOOKUP_REL_TABLES T
 INNER JOIN FND.FND_LOOKUP_VALUES V
    ON V.LKPNM_NAM_LOOKUP_LKPNM = T.LKPNM_NAM_LOOKUP_LKPNM
 WHERE UPPER(T.NAM_TABLE_LKPRT) LIKE UPPER(TRIM('&TABLE_NAME'))
       AND UPPER(T.NAM_COLUMN_LKPRT) LIKE UPPER('&COLUMN_NAME')
 ORDER BY T.NAM_TABLE_LKPRT
         ,T.NAM_COLUMN_LKPRT
         ,V.VAL_LOOKUP_LKPVL

/*
SELECT V.VAL_LOOKUP_LKPVL || ': ' || V.DES_FARSI_LKPVL AS A, V.*
  FROM FND_LOOKUP_VALUES V
 WHERE V.LKPNM_NAM_LOOKUP_LKPNM IN (&LKP, UPPER(&LKP))
 ORDER BY V.LKPNM_NAM_LOOKUP_LKPNM, V.VAL_LOOKUP_LKPVL;
SELECT A, B, A || ': ' || B AS AB
  FROM (SELECT LEVEL A
              ,APP_FND_LOOKUP_PKG.GET_FARSI_MEANING_FUN(UPPER(&TBL),
                                                        UPPER(&LKP),
                                                        LEVEL) B
          FROM DUAL
        CONNECT BY LEVEL < 10000)
 WHERE B IS NOT NULL;
*/
/*
SELECT A
      ,CASE
         WHEN B IS NULL THEN
          CASE
            WHEN BPAD2 IS NULL THEN
             CASE
               WHEN BPAD3 IS NOT NULL THEN
                BPAD3
             END
            ELSE
             BPAD2
          END
         ELSE
          B
       END AS B
      ,CASE
         WHEN B IS NULL THEN
          CASE
            WHEN BPAD2 IS NULL THEN
             CASE
               WHEN BPAD3 IS NOT NULL THEN
                LPAD(A, 3, '0') || ': ' || BPAD3
             END
            ELSE
             LPAD(A, 2, '0') || ': ' || BPAD2
          END
         ELSE
          A || ': ' || B
       END AS AB
      ,CASE
         WHEN B IS NULL THEN
          CASE
            WHEN BPAD2 IS NULL THEN
             CASE
               WHEN BPAD3 IS NOT NULL THEN
                'BPAD3'
             END
            ELSE
             'BPAD2'
          END
         ELSE
          'B'
       END AS LVL
      ,TC
  FROM (SELECT L.L A
              ,APPS.APP_FND_LOOKUP_PKG.GET_FARSI_MEANING_FUN(UPPER(TC.TABLE_NAME)
                                                            ,UPPER(TC.COLUMN_NAME)
                                                            ,L.L) B
               
              ,TC.TABLE_NAME || '.' || TC.COLUMN_NAME AS TC
              ,APPS.APP_FND_LOOKUP_PKG.GET_FARSI_MEANING_FUN(UPPER(TC.TABLE_NAME)
                                                            ,UPPER(TC.COLUMN_NAME)
                                                            ,LPAD(TO_CHAR(L.L)
                                                                 ,2
                                                                 ,'0')) BPAD2
              ,APPS.APP_FND_LOOKUP_PKG.GET_FARSI_MEANING_FUN(UPPER(TC.TABLE_NAME)
                                                            ,UPPER(TC.COLUMN_NAME)
                                                            ,LPAD(TO_CHAR(L.L)
                                                                 ,3
                                                                 ,'0')) BPAD3
              ,TC.TABLE_NAME
              ,TC.COLUMN_NAME
          FROM ALL_TAB_COLUMNS TC
         CROSS JOIN (SELECT LEVEL-1 AS L FROM DUAL CONNECT BY LEVEL < 200) L
         WHERE TC.TABLE_NAME LIKE UPPER(TRIM('&TABLE_NAME'))
        --AND TC.COLUMN_NAME LIKE UPPER('lkp%')
        )
 WHERE (B IS NOT NULL OR BPAD2 IS NOT NULL OR BPAD3 IS NOT NULL)
--AND (TC.COLUMN_NAME LIKE UPPER('&COLUMN_NAME'))
 ORDER BY TC
         ,A
*/
