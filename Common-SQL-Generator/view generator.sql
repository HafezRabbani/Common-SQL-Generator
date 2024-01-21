DECLARE
  LV_TABLE_NAME VARCHAR2(1000) := UPPER(TRIM('&TABLE_NAME'));
  LV_SCHEMA     VARCHAR2(1000);
  LV_ADDITIVE   VARCHAR2(10);
  LV_VIEW_NAME  VARCHAR2(32) := SUBSTR(SYS_GUID(), 1, 22);
  LV_COMMENT    VARCHAR2(1000);
  CURSOR COLUMN_CURSOR IS
    SELECT V1.TABLE_NAME
          ,V1.COLUMN_NAME
          ,V1.COLUMN_ID
          ,V1.DATA_TYPE
      FROM ( --
            SELECT (CASE
                      WHEN EXISTS
                       (SELECT NULL
                              FROM ALL_CONSTRAINTS CC
                             INNER JOIN ALL_CONS_COLUMNS TC
                                ON TC.TABLE_NAME = CC.TABLE_NAME
                                   AND CC.CONSTRAINT_NAME = TC.CONSTRAINT_NAME
                             WHERE CC.CONSTRAINT_TYPE = 'P'
                                   AND CC.TABLE_NAME = V.TABLE_NAME
                                   AND TC.COLUMN_NAME = V.COLUMN_NAME) THEN
                       1
                      ELSE
                       0
                    END) AS PRIMARY_KEY
                   ,V.*
              FROM ALL_TAB_COLUMNS V
             WHERE V.TABLE_NAME LIKE UPPER(TRIM(LV_TABLE_NAME))
                   AND V.COLUMN_NAME NOT IN (
                                             --
                                             '-'
                                             /*
                                            ,'ATTACH_ID'
                                            ,'CREATE_DATE'
                                            ,'CREATE_BY_DB_USER'
                                            ,'CREATE_BY_APP_USER'
                                            ,'LAST_UPDATE_DATE'
                                            ,'LAST_UPDATE_BY_DB_USER'
                                            ,'LAST_UPDATE_BY_APP_USER'
                                            */
                                            ,'LAST_CHANGE_TS'
                                            ,'MODULE_NAME'
                                            ,'OS_USERNAME'
                                            ,'JRN_OPERATION'
                                            ,'JRN_DB_USER'
                                            ,'JRN_DATETIME'
                                            ,'JRN_PROGRAM'
                                            ,'JRN_ID'
                                            ,'JRN_APP_USER'
                                            ,'JRN_OS_USER'
                                             --
                                             )
            --
            ) V1
     ORDER BY V1.PRIMARY_KEY DESC
             ,V1.COLUMN_ID;
BEGIN
  SELECT T.OWNER
    INTO LV_SCHEMA
    FROM DBA_TABLES T
   WHERE T.TABLE_NAME = LV_TABLE_NAME;
  DBMS_OUTPUT.PUT_LINE('CREATE VIEW MAM_' || LV_VIEW_NAME || '_VIW AS');
  DBMS_OUTPUT.PUT_LINE('SELECT ');

  FOR C IN COLUMN_CURSOR /*( --
                                
                                --
                                )
                      */
  LOOP
    DBMS_OUTPUT.PUT_LINE(LV_ADDITIVE || 'II.' || C.COLUMN_NAME);
    LV_ADDITIVE := ',';
    IF SUBSTR(C.COLUMN_NAME, 1, 4) = 'LKP_'
    THEN
      DBMS_OUTPUT.PUT_LINE(LV_ADDITIVE ||
                           'APPS.APP_FND_LOOKUP_PKG.GET_FARSI_MEANING_FUN(UPPER(''' ||
                           LV_TABLE_NAME || '''),UPPER(''' ||
                           C.COLUMN_NAME || '''),' || 'II.' ||
                           C.COLUMN_NAME || ') AS ' ||
                           SUBSTR(C.COLUMN_NAME, 1, 26) || '_DES');
    ELSIF SUBSTR(C.COLUMN_NAME, 1, 4) = 'DAT_'
    THEN
      DBMS_OUTPUT.PUT_LINE(LV_ADDITIVE || 'TO_CHAR(' || 'II.' ||
                           C.COLUMN_NAME ||
                           ', ''YYYY/MM/DD HH24:MI:SS'', ''NLS_CALENDAR=PERSIAN'') AS ' ||
                           SUBSTR(C.COLUMN_NAME, 1, 28) || '_H');
    
    END IF;
  END LOOP;

  DBMS_OUTPUT.PUT_LINE(' FROM ' || LV_SCHEMA || '.' || LV_TABLE_NAME ||
                       ' II ');
  FOR C IN ( --
            SELECT CT.OWNER
                   ,CT.TABLE_NAME
                   ,CF.CONSTRAINT_NAME
                   ,ROW_NUMBER() OVER(ORDER BY CT.OWNER, CT.TABLE_NAME) AS RW
              FROM DBA_CONSTRAINTS CT
             INNER JOIN DBA_CONSTRAINTS CF
                ON CF.R_CONSTRAINT_NAME = CT.CONSTRAINT_NAME
             WHERE CF.TABLE_NAME = LV_TABLE_NAME
             ORDER BY CASE
                         WHEN CT.OWNER = CF.OWNER THEN
                          0
                         ELSE
                          1
                       END
                      ,CT.OWNER
                      ,CT.TABLE_NAME --
            )
  LOOP
    DBMS_OUTPUT.PUT_LINE(' LEFT OUTER JOIN ' || C.OWNER || '.' ||
                         C.TABLE_NAME || ' A' || TO_CHAR(C.RW) || ' ON ');
    LV_ADDITIVE := '';
    FOR D IN ( --
              SELECT CCF.COLUMN_NAME FCOLUMN_NAME
                     ,CCT.COLUMN_NAME TCOLUMN_NAME
                     ,CCF.POSITION
                FROM DBA_CONSTRAINTS CFROM
               INNER JOIN DBA_CONSTRAINTS CTO
                  ON CTO.R_CONSTRAINT_NAME = CFROM.CONSTRAINT_NAME
               INNER JOIN DBA_CONS_COLUMNS CCF
                  ON CFROM.CONSTRAINT_NAME = CCF.CONSTRAINT_NAME
               INNER JOIN DBA_CONS_COLUMNS CCT
                  ON CTO.CONSTRAINT_NAME = CCT.CONSTRAINT_NAME
                     AND CCF.POSITION = CCT.POSITION
               WHERE CTO.CONSTRAINT_NAME = C.CONSTRAINT_NAME
               ORDER BY CCF.POSITION
              --
              )
    LOOP
      DBMS_OUTPUT.PUT_LINE(LV_ADDITIVE || ' II.' || D.TCOLUMN_NAME ||
                           ' = A' || TO_CHAR(C.RW) || '.' ||
                           D.FCOLUMN_NAME);
      LV_ADDITIVE := ' AND ';
    END LOOP;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('--WHERE');
  DBMS_OUTPUT.PUT_LINE(';');
  DBMS_OUTPUT.PUT_LINE('COMMENT ON TABLE MAM_' || LV_VIEW_NAME ||
                       '_VIW IS ' || CHR(39) || '?' || CHR(39) || '; ');
  FOR C IN COLUMN_CURSOR
  LOOP
    BEGIN
      SELECT UPPER(TRIM(NVL(CASE
                              WHEN Z.COMMENTS IS NULL THEN
                               (SELECT T.COMMENTS
                                  FROM ALL_COL_COMMENTS T
                                 WHERE 1 = 1
                                       AND T.COMMENTS IS NOT NULL
                                       AND T.TABLE_NAME = Z.TABLE_NAME
                                       AND T.COLUMN_NAME = Z.COLUMN_NAME
                                       AND UPPER(FND.FND_REPLACE_STRING(TRIM(T.COMMENTS))) NOT IN
                                       (Z.COLUMN_NAME, FND.FND_REPLACE_STRING('ﬂ·Ìœ «’·Ì'))
                                       AND ROWNUM = 1)
                              ELSE
                               Z.COMMENTS
                            END
                            
                           ,'?')) ) AS CMNT
        INTO LV_COMMENT
        FROM ( --
              SELECT CC.TABLE_NAME
                     ,CC.COLUMN_NAME
                     ,CC.COMMENTS
                FROM ALL_COL_COMMENTS CC
               WHERE CC.TABLE_NAME = C.TABLE_NAME
                     AND CC.COLUMN_NAME = C.COLUMN_NAME
              --
              ) Z;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        NULL;
    END;
    LV_COMMENT := NVL(LV_COMMENT, '?');
    DBMS_OUTPUT.PUT_LINE('COMMENT ON COLUMN  MAM_' || LV_VIEW_NAME ||
                         '_VIW' || '.' || C.COLUMN_NAME || ' IS ' ||
                         CHR(39) || LV_COMMENT || CHR(39) || '; ');
    IF SUBSTR(C.COLUMN_NAME, 1, 4) = 'LKP_'
    THEN
      DBMS_OUTPUT.PUT_LINE('COMMENT ON COLUMN  MAM_' || LV_VIEW_NAME ||
                           '_VIW' || '.' || SUBSTR(C.COLUMN_NAME, 1, 26) ||
                           '_DES' || ' IS ' || CHR(39) || '‘—Õ ' ||
                           LV_COMMENT || CHR(39) || '; ');
    ELSIF SUBSTR(C.COLUMN_NAME, 1, 4) = 'DAT_'
    THEN
      DBMS_OUTPUT.PUT_LINE('COMMENT ON COLUMN  MAM_' || LV_VIEW_NAME ||
                           '_VIW' || '.' || SUBSTR(C.COLUMN_NAME, 1, 28) || '_H' ||
                           ' IS ' || CHR(39) || LV_COMMENT || ' »Â ÂÃ—Ì' ||
                           CHR(39) || '; ');
    END IF;
  END LOOP;

END;
