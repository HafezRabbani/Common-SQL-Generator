--GRANT SELECT ON FND.FND_REPORTS TO SUP_BACKEND
--GRANT SELECT ON FND.FND_PROGRAMS TO SUP_BACKEND
--GRANT SELECT ON FND.FND_SETUPS TO SUP_BACKEND
SELECT DS.NAM_PROJECT_SETUP AS PROJECT_NAME
      ,DS.COD_PROJECT_SETUP AS PROJECT_COD
      ,DFR.NAM
      ,DFR.CAPTION
  FROM ( --
        SELECT R.NAM_REP_REPRT AS NAM, R.NAM_REP_TITLE_REPRT AS CAPTION
          FROM FND.FND_REPORTS R
         WHERE 1 = 1
           AND (R.NAM_REP_REPRT LIKE UPPER('rmam%') OR
               R.NAM_REP_REPRT LIKE UPPER('rcsm%'))
        UNION
        SELECT P.NAM_PRG_PROG AS NAM, P.NAM_TITLE_PROG AS CAPTION
          FROM FND.FND_PROGRAMS P
         WHERE 1 = 1
           AND (P.NAM_PRG_PROG LIKE UPPER('fmam%') OR
               P.NAM_PRG_PROG LIKE UPPER('fcsm%'))
        --
        ) DFR
 CROSS JOIN --
 (SELECT S.NAM_PROJECT_SETUP, S.COD_PROJECT_SETUP FROM FND.FND_SETUPS S) DS
 WHERE 1 = 1
   AND (FND.FND_REPLACE_STRING(DFR.CAPTION) LIKE
       FND.FND_REPLACE_STRING('%&Caption%') OR '&Caption' = '')
      
   AND (DFR.NAM LIKE UPPER(TRIM('%&NAM_LIKE')) OR '&NAM_LIKE' = '')
   AND EXISTS
 ( --
        SELECT NULL
          FROM ( --
                 SELECT V.GROUP_IDE_GRP_GROUP
                        ,UPPER(TRIM(V.REPRT_NAM_REP_REPRT)) AS NAM
                   FROM FND.FND_GROUP_REPORTS V
                 UNION
                 SELECT NG.GROUP_IDE_GRP_GROUP
                        ,UPPER(TRIM(N.PROG_NAM_PRG_PROG)) AS NAM
                   FROM FND.FND_MENU_NODE_GROUPS NG
                  INNER JOIN FND.FND_MENU_NODES N
                     ON NG.MNOD_NAM_NOD_MNOD = N.NAM_NOD_MNOD
                  INNER JOIN FND.FND_GROUPS G
                     ON NG.GROUP_IDE_GRP_GROUP = G.IDE_GRP_GROUP
                 --                    
                 ) ZZ
         WHERE ZZ.NAM = DFR.NAM
           AND (EXISTS (SELECT NULL
                          FROM FND.FND_GROUP_USERS GU
                         WHERE GU.GROUP_IDE_GRP_GROUP = ZZ.GROUP_IDE_GRP_GROUP
                           AND GU.USRS_IDE_USER_USRS = '&IDE_USER') OR
                '&IDE_USER' IS NULL)
        --
        )
 ORDER BY NULL
          -- ,dfr.nam
         ,REGEXP_SUBSTR(DFR.NAM, '[[:alpha:]]+')
         ,TO_NUMBER(REGEXP_SUBSTR(DFR.NAM, '[[:digit:]]+'));
