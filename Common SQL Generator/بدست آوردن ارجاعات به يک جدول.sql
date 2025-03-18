DECLARE
  LV_TABLE_NAME VARCHAR2(100) := UPPER(TRIM('&TABLE_NAME'));
  LV_METHOD     NUMBER := '&METHOD';
  --0: select "table name" 
  --1: select from related table 
  --2: select "delete table name"
  --others: exists
  LV_SCHEMA          VARCHAR2(1000);
  LV_ADDITIVE        VARCHAR2(100);
  LV_RELATED_SCHEMAS NVARCHAR2(1000) := REPLACE(UPPER(CHR(39) ||
                                                      NVL(TRIM('&RELATED_SCHEMAS')
                                                         ,'ALL') || CHR(39))
                                               ,','
                                               ,CHR(39) || ',' || CHR(39));
BEGIN
  SELECT T.OWNER
    INTO LV_SCHEMA
    FROM DBA_TABLES T
   WHERE T.TABLE_NAME = LV_TABLE_NAME;
  FOR C IN ( --
            SELECT DISTINCT CTO.OWNER
                            ,CTO.TABLE_NAME
                            ,CFROM.OWNER AS FO
              FROM DBA_CONSTRAINTS CFROM
             INNER JOIN DBA_CONSTRAINTS CTO
                ON CTO.R_CONSTRAINT_NAME = CFROM.CONSTRAINT_NAME
             WHERE CFROM.TABLE_NAME = LV_TABLE_NAME
                   AND
                   (INSTR(CHR(39) || LV_RELATED_SCHEMAS || CHR(39)
                         ,UPPER(CTO.OWNER)) != 0 OR
                   LV_RELATED_SCHEMAS = CHR(39) || UPPER('all') || CHR(39))
             ORDER BY CASE
                         WHEN CTO.OWNER = CFROM.OWNER THEN
                          0
                         ELSE
                          1
                       END
                      ,CTO.TABLE_NAME
            --
            )
  LOOP
    NULL;
    DBMS_OUTPUT.PUT_LINE('-- GRANT SELECT ON ' || C.OWNER || '.' ||
                         C.TABLE_NAME || ' TO SUP_BACKEND');
  END LOOP;
  IF NVL(LV_METHOD, 0) = 0
  THEN
    DBMS_OUTPUT.PUT_LINE('SELECT ');
  ELSIF NVL(LV_METHOD, 0) IN (1, 2)
  THEN
    DBMS_OUTPUT.PUT_LINE('SELECT ');
  ELSE
    DBMS_OUTPUT.PUT_LINE('SELECT NULL FROM ' || LV_SCHEMA || '.' ||
                         LV_TABLE_NAME || ' II WHERE --');
  END IF;
  FOR C IN ( --
            SELECT CFROM.TABLE_NAME AS FTABLE_NAME
                   ,CTO.OWNER
                   ,CTO.TABLE_NAME AS TTABLE_NAME
                   ,CTO.CONSTRAINT_NAME
                   ,ROW_NUMBER() OVER(ORDER BY CTO.OWNER, CTO.TABLE_NAME) AS RW
              FROM DBA_CONSTRAINTS CFROM
             INNER JOIN DBA_CONSTRAINTS CTO
                ON CTO.R_CONSTRAINT_NAME = CFROM.CONSTRAINT_NAME
             WHERE CFROM.TABLE_NAME = LV_TABLE_NAME
                   AND
                   (INSTR(CHR(39) || LV_RELATED_SCHEMAS || CHR(39)
                         ,UPPER(CTO.OWNER)) != 0 OR
                   LV_RELATED_SCHEMAS = CHR(39) || UPPER('all') || CHR(39))
             ORDER BY CTO.OWNER
                      ,CTO.TABLE_NAME
            --
            )
  LOOP
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
      IF NVL(LV_METHOD, 0) = 0
      THEN
        DBMS_OUTPUT.PUT_LINE(LV_ADDITIVE || ' CASE WHEN EXISTS (SELECT ' ||
                             CHR(39) || C.TTABLE_NAME || CHR(39) ||
                             ' FROM ' || C.OWNER || '.' || C.TTABLE_NAME ||
                             ' T WHERE T.' || D.TCOLUMN_NAME || ' = II.' ||
                             D.FCOLUMN_NAME || ') THEN ''' || C.OWNER || '.' ||
                             C.TTABLE_NAME || ''' END AS T' ||
                             TO_CHAR(C.RW));
        LV_ADDITIVE := ',';
      ELSIF NVL(LV_METHOD, 0) = 1
      THEN
        DBMS_OUTPUT.PUT_LINE(LV_ADDITIVE || ' (SELECT NULL FROM ' ||
                             C.OWNER || '.' || C.TTABLE_NAME ||
                             ' T WHERE T.' || D.TCOLUMN_NAME || ' = II.' ||
                             D.FCOLUMN_NAME || ') AS ' || C.TTABLE_NAME ||
                             TO_CHAR(C.RW));
        LV_ADDITIVE := ',';
      ELSIF NVL(LV_METHOD, 0) = 2
      THEN
        DBMS_OUTPUT.PUT_LINE(LV_ADDITIVE || ' CASE WHEN EXISTS (SELECT ' ||
                             CHR(39) || C.TTABLE_NAME || CHR(39) ||
                             ' FROM ' || C.OWNER || '.' || C.TTABLE_NAME ||
                             ' T WHERE T.' || D.TCOLUMN_NAME || ' = II.' ||
                             D.FCOLUMN_NAME || ') THEN ' || CHR(39) ||
                             'DELETE ' || C.OWNER || '.' || C.TTABLE_NAME ||
                             ' T WHERE T.' || D.TCOLUMN_NAME || ' = ' ||
                             CHR(38) || CHR(38) || D.FCOLUMN_NAME || ';' ||
                             CHR(39) || ' END AS T' || TO_CHAR(C.RW));
        LV_ADDITIVE := ',';
      ELSE
        DBMS_OUTPUT.PUT_LINE(LV_ADDITIVE || ' NOT EXISTS (SELECT 1 FROM ' ||
                             C.OWNER || '.' || C.TTABLE_NAME || ' A' ||
                             TO_CHAR(C.RW) || ' WHERE A' || TO_CHAR(C.RW) || '.' ||
                             D.TCOLUMN_NAME || ' = II.' || D.FCOLUMN_NAME || ')');
        LV_ADDITIVE := 'AND';
      END IF;
    END LOOP;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE(' FROM ' || LV_SCHEMA || '.' || LV_TABLE_NAME ||
                       ' II ');
  DBMS_OUTPUT.PUT_LINE('--WHERE');
END;
