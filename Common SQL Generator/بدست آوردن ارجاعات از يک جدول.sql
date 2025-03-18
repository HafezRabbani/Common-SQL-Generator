DECLARE
  LV_TABLE_NAME NVARCHAR2(1000) := UPPER(TRIM('&TABLE_NAME'));
  LV_SCHEMA     NVARCHAR2(1000);
  LV_ADDITIVE   NVARCHAR2(10);
BEGIN
  SELECT T.OWNER
    INTO LV_SCHEMA
    FROM DBA_TABLES T
   WHERE T.TABLE_NAME = LV_TABLE_NAME;
  DBMS_OUTPUT.PUT_LINE('SELECT * FROM ' || LV_SCHEMA || '.' ||
                       LV_TABLE_NAME || ' II WHERE --');
  FOR C IN ( --
            SELECT CFROM.TABLE_NAME AS FTABLE_NAME
                   ,CTO.OWNER
                   ,CTO.TABLE_NAME AS TTABLE_NAME
                   ,CTO.CONSTRAINT_NAME
                   ,ROW_NUMBER() OVER(ORDER BY CTO.OWNER, CTO.TABLE_NAME) AS RW
              FROM DBA_CONSTRAINTS CFROM
             INNER JOIN DBA_CONSTRAINTS CTO
                ON CTO.R_CONSTRAINT_NAME = CFROM.CONSTRAINT_NAME
             WHERE CTO.TABLE_NAME = LV_TABLE_NAME
             ORDER BY CTO.OWNER
                      ,CTO.TABLE_NAME
            --
            )
  LOOP
    DBMS_OUTPUT.PUT_LINE(' LEFT OUTER JOIN ' || C.OWNER || '.' ||
                         C.FTABLE_NAME || ' A' || TO_CHAR(C.RW) || ' ON ');
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
      DBMS_OUTPUT.PUT_LINE(LV_ADDITIVE || ' II. ' || D.TCOLUMN_NAME ||
                           ' = A' || TO_CHAR(C.RW) || '.' ||
                           D.FCOLUMN_NAME);
      LV_ADDITIVE := ' AND ';
    END LOOP;
  END LOOP;
END;
