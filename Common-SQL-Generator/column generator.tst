PL/SQL Developer Test script 3.0
333
/*
function index
  0: NO FUCTION
  1: length
  2: TRIM
  3: SUBSTR
  4: SUBSTR(TRIM
--  ?: to_char(?,'yyyy/mm/dd','nls_calendar=persian')
*/
DECLARE
  L                NUMBER;
  LV_SQL           VARCHAR2(1000);
  LV_SCHEMA        VARCHAR2(1000);
  LV_OUTPUT_SCHEMA VARCHAR2(1000);
  LV_TABLE_NAME    VARCHAR2(1000);
  LV_TABLE_ALIAS   VARCHAR2(1000);

  LV_NOT_NULL_FIELDS_CONDITION VARCHAR2(1000);

  LV_NOT_NULL_FIELDS           NUMBER := 0;
  LV_NULL_FIELDS               NUMBER := 0;
  LV_OLD_NEW_4_TRIGGER         NUMBER := 0;
  LV_OUTPUT_4_FORM_ASSIGNMENT  NUMBER := 0;
  LV_OUTPUT_4_PLSQL_ASSIGNMENT NUMBER := 0;
  LV_OUTPUT_4_SELECT           NUMBER := 0;
  LV_OUTPUT_4_CREATE_TABLE     NUMBER := 0;
  LV_FUNCTION                  NUMBER := 0;
  LV_ADDITIVE                  VARCHAR2(100) := ' ';
BEGIN
  LV_SCHEMA                    := UPPER(TRIM(:SCHEMA_));
  LV_OUTPUT_SCHEMA             := UPPER(TRIM(:OUTPUT_SCHEMA));
  LV_TABLE_NAME                := UPPER(TRIM(:TABLE_NAME));
  LV_TABLE_ALIAS               := UPPER(TRIM(:TABLE_ALIAS));
  LV_NULL_FIELDS               := TO_NUMBER(:NULL_FIELDS);
  LV_NOT_NULL_FIELDS           := TO_NUMBER(:NOT_NULL_FIELDS);
  LV_OLD_NEW_4_TRIGGER         := TO_NUMBER(:OLD_NEW_4_TRIGGER);
  LV_OUTPUT_4_FORM_ASSIGNMENT  := TO_NUMBER(:OUTPUT_4_FORM_ASSIGNMENT);
  LV_OUTPUT_4_PLSQL_ASSIGNMENT := TO_NUMBER(:OUTPUT_4_PLSQL_ASSIGNMENT);
  LV_OUTPUT_4_SELECT           := TO_NUMBER(:OUTPUT_4_SELECT);
  LV_OUTPUT_4_CREATE_TABLE     := TO_NUMBER(:OUTPUT_4_CREATE_TABLE);
  LV_FUNCTION                  := TO_NUMBER(:FUNCTION_INDEX);

  LV_NOT_NULL_FIELDS_CONDITION := TRIM(:NOT_NULL_FIELDS_CONDITION);

  LV_NULL_FIELDS               := NVL(LV_NULL_FIELDS, 0);
  LV_NOT_NULL_FIELDS           := NVL(LV_NOT_NULL_FIELDS, 0);
  LV_OLD_NEW_4_TRIGGER         := NVL(LV_OLD_NEW_4_TRIGGER, 0);
  LV_OUTPUT_4_FORM_ASSIGNMENT  := NVL(LV_OUTPUT_4_FORM_ASSIGNMENT, 0);
  LV_OUTPUT_4_PLSQL_ASSIGNMENT := NVL(LV_OUTPUT_4_PLSQL_ASSIGNMENT, 0);
  LV_OUTPUT_4_SELECT           := NVL(LV_OUTPUT_4_SELECT, 0);
  LV_OUTPUT_4_CREATE_TABLE     := NVL(LV_OUTPUT_4_CREATE_TABLE, 0);
  LV_FUNCTION                  := NVL(LV_FUNCTION, 0);

  IF (LV_OUTPUT_4_FORM_ASSIGNMENT = 1)
  THEN
    DBMS_OUTPUT.PUT_LINE('BEGIN');
  ELSIF (LV_OLD_NEW_4_TRIGGER = 1 OR LV_OUTPUT_4_PLSQL_ASSIGNMENT = 1 OR
        LV_OUTPUT_4_SELECT = 1)
  THEN
    DBMS_OUTPUT.PUT_LINE('SELECT ');
  END IF;
  FOR C IN ( --
            SELECT V1.TABLE_NAME
                   ,V1.COLUMN_NAME
                   ,V1.COLUMN_ID
                   ,V1.DATA_TYPE
                   ,V1.DATA_LENGTH
                   ,V1.DATA_PRECISION
              FROM ( --
                     SELECT (CASE
                               WHEN EXISTS
                                (SELECT NULL
                                       FROM ALL_CONSTRAINTS CC
                                      INNER JOIN ALL_CONS_COLUMNS TC
                                         ON TC.TABLE_NAME = CC.TABLE_NAME
                                            AND
                                            CC.CONSTRAINT_NAME = TC.CONSTRAINT_NAME
                                      WHERE CC.CONSTRAINT_TYPE = 'P'
                                            AND CC.TABLE_NAME = V.TABLE_NAME
                                            AND TC.COLUMN_NAME = V.COLUMN_NAME) THEN
                                1
                               ELSE
                                0
                             END) AS PRIMARY_KEY
                            ,V.*
                       FROM ALL_TAB_COLUMNS V
                      WHERE V.TABLE_NAME LIKE UPPER(LV_TABLE_NAME)
                            AND V.COLUMN_NAME NOT IN (
                                                      --
                                                      'CREATE_DATE'
                                                     ,'CREATE_BY_DB_USER'
                                                     ,'CREATE_BY_APP_USER'
                                                     ,'LAST_UPDATE_DATE'
                                                     ,'LAST_UPDATE_BY_DB_USER'
                                                     ,'LAST_UPDATE_BY_APP_USER'
                                                     ,'LAST_CHANGE_TS'
                                                     ,'MODULE_NAME'
                                                     ,'OS_USERNAME'
                                                     ,'ATTACH_ID'
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
                      ,V1.COLUMN_ID
            --
            )
  LOOP
  
    IF (NVL(LV_NOT_NULL_FIELDS, 0) = 0)
    THEN
      IF (NVL(LV_NULL_FIELDS, 0) = 0)
      THEN
        LV_SQL := 'SELECT 1 AS FLG FROM DUAL';
      ELSE
        LV_SQL := 'SELECT 1 AS FLG FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM ' ||
                  LV_SCHEMA || '.' || C.TABLE_NAME || ' T WHERE T.' ||
                  C.COLUMN_NAME || ' IS NOT NULL ';
        LV_SQL := LV_SQL || ' )';
      END IF;
    ELSE
      LV_SQL := 'SELECT 1 AS FLG FROM DUAL WHERE EXISTS (SELECT 1 FROM ' ||
                LV_SCHEMA || '.' || C.TABLE_NAME || ' T WHERE T.' ||
                C.COLUMN_NAME || ' IS NOT NULL ';
      IF (LV_NOT_NULL_FIELDS_CONDITION IS NOT NULL)
      THEN
        LV_SQL := LV_SQL || ' AND ' || LV_NOT_NULL_FIELDS_CONDITION;
      END IF;
      LV_SQL := LV_SQL || ' )';
    
    END IF;
  
    BEGIN
      EXECUTE IMMEDIATE LV_SQL
        INTO L;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        L := 0;
    END;
    L := NVL(L, 0);
    --DBMS_OUTPUT.PUT_LINE('CASE WHEN ' || C.COLUMN_NAME ||' IS NULL THEN 1 END AS ' || C.COLUMN_NAME || ', ');
    -- DBMS_OUTPUT.PUT_LINE('LENGTH('||C.COLUMN_NAME||') AS '||C.COLUMN_NAME||', ')  ;
    --DBMS_OUTPUT.PUT_LINE(C.COLUMN_NAME || ', ');
    IF (L > 0)
    THEN
      --DBMS_OUTPUT.PUT_LINE(LV_TABLE_ALIAS || '.' || C.COLUMN_NAME || ', ');
      IF LV_OUTPUT_4_CREATE_TABLE = 1
      THEN
        DBMS_OUTPUT.PUT_LINE(LV_ADDITIVE || C.COLUMN_NAME || CHR(9) ||
                             C.DATA_TYPE || CASE
                               WHEN C.DATA_TYPE IN ('NUMBER', 'NVARCHAR2', 'CHAR', 'NCHAR', 'VARCHAR2') THEN
                                '(' || C.DATA_LENGTH || CASE
                                  WHEN C.DATA_PRECISION IS NOT NULL THEN
                                   ',' || C.DATA_PRECISION
                                END || ')'
                             END);
        LV_ADDITIVE := ',';
      
      ELSIF (LV_OUTPUT_4_FORM_ASSIGNMENT = 1)
      THEN
        DBMS_OUTPUT.PUT_LINE(':' || CASE
                               WHEN LV_TABLE_ALIAS IS NULL THEN
                                ''
                               ELSE
                                LV_TABLE_ALIAS || '.'
                             END || C.COLUMN_NAME || ' := :' ||
                             LV_TABLE_NAME || '.' || C.COLUMN_NAME || ';');
      ELSIF (LV_OLD_NEW_4_TRIGGER = 1)
      THEN
        DBMS_OUTPUT.PUT_LINE(LV_ADDITIVE || ':OLD.' || C.COLUMN_NAME ||
                             ' = :NEW.' || C.COLUMN_NAME);
        LV_ADDITIVE := ' AND ';
      ELSIF (LV_OUTPUT_4_PLSQL_ASSIGNMENT = 1)
      THEN
        DBMS_OUTPUT.PUT_LINE(LV_ADDITIVE || CASE
                               WHEN LV_TABLE_ALIAS IS NULL THEN
                                ''
                               ELSE
                                LV_TABLE_ALIAS || '.'
                             END || C.COLUMN_NAME || ' = ' ||
                             LV_TABLE_NAME || '.' || C.COLUMN_NAME);
        LV_ADDITIVE := ',';
      ELSIF (LV_OUTPUT_4_SELECT = 1)
      THEN
        IF LV_FUNCTION = 0
        THEN
          DBMS_OUTPUT.PUT_LINE(LV_ADDITIVE || CASE
                                 WHEN LV_TABLE_ALIAS IS NULL THEN
                                  ''
                                 ELSE
                                  LV_TABLE_ALIAS || '.'
                               END || C.COLUMN_NAME);
          LV_ADDITIVE := ',';
          IF SUBSTR(C.COLUMN_NAME, 1, 4) = 'LKP_'
          THEN
            DBMS_OUTPUT.PUT_LINE(LV_ADDITIVE || CASE
                                   WHEN LV_TABLE_ALIAS IS NULL THEN
                                    ''
                                   ELSE
                                    LV_TABLE_ALIAS || '.'
                                 END || C.COLUMN_NAME || ' || CASE WHEN '||CASE
                                   WHEN LV_TABLE_ALIAS IS NULL THEN
                                    ''
                                   ELSE
                                    LV_TABLE_ALIAS || '.'
                                 END || C.COLUMN_NAME ||' IS NOT NULL THEN '': '' END || ' ||
                                 'APPS.APP_FND_LOOKUP_PKG.GET_FARSI_MEANING_FUN(UPPER(''' ||
                                 LV_TABLE_NAME || '''),UPPER(''' ||
                                 C.COLUMN_NAME || '''),' || CASE
                                   WHEN LV_TABLE_ALIAS IS NULL THEN
                                    ''
                                   ELSE
                                    LV_TABLE_ALIAS || '.'
                                 END || C.COLUMN_NAME || ') AS ' ||
                                 SUBSTR(C.COLUMN_NAME, 1, 26) || '_DES');
          ELSIF SUBSTR(C.COLUMN_NAME, 1, 4) = 'DAT_'
          THEN
            DBMS_OUTPUT.PUT_LINE(LV_ADDITIVE || 'TO_CHAR(' || CASE
                                   WHEN LV_TABLE_ALIAS IS NULL THEN
                                    ''
                                   ELSE
                                    LV_TABLE_ALIAS || '.'
                                 END || C.COLUMN_NAME ||
                                 ', ''YYYY/MM/DD HH24:MI:SS'', ''NLS_CALENDAR=PERSIAN'') AS ' ||
                                 SUBSTR(C.COLUMN_NAME, 1, 28) || '_H');
          
          END IF;
        ELSIF LV_FUNCTION = 1
        THEN
          DBMS_OUTPUT.PUT_LINE(LV_ADDITIVE || 'LENGTH(' || CASE
                                 WHEN LV_TABLE_ALIAS IS NULL THEN
                                  ''
                                 ELSE
                                  LV_TABLE_ALIAS || '.'
                               END || C.COLUMN_NAME || ') AS ' ||
                               C.COLUMN_NAME);
        ELSIF LV_FUNCTION = 2
        THEN
          IF (C.DATA_TYPE IN ('NVARCHAR2', 'CHAR', 'NCHAR', 'VARCHAR2'))
          THEN
            DBMS_OUTPUT.PUT_LINE(LV_ADDITIVE ||
                                 
                                 'TRIM(' || CASE
                                   WHEN LV_TABLE_ALIAS IS NULL THEN
                                    ''
                                   ELSE
                                    LV_TABLE_ALIAS || '.'
                                 END || C.COLUMN_NAME || ') AS ' ||
                                 C.COLUMN_NAME);
          ELSE
            DBMS_OUTPUT.PUT_LINE(LV_ADDITIVE || CASE WHEN
                                 LV_TABLE_ALIAS IS NULL THEN '' ELSE
                                 LV_TABLE_ALIAS || '.'
                                 END || C.COLUMN_NAME);
          END IF;
        ELSIF LV_FUNCTION = 3
        THEN
          IF (C.DATA_TYPE IN ('NVARCHAR2', 'CHAR', 'NCHAR', 'VARCHAR2'))
          THEN
            DBMS_OUTPUT.PUT_LINE(LV_ADDITIVE ||
                                 
                                 'SUBSTR(' || CASE
                                   WHEN LV_TABLE_ALIAS IS NULL THEN
                                    ''
                                   ELSE
                                    LV_TABLE_ALIAS || '.'
                                 END || C.COLUMN_NAME || ',1,' ||
                                 TO_CHAR(C.DATA_LENGTH) || ') AS ' ||
                                 C.COLUMN_NAME);
          ELSE
            DBMS_OUTPUT.PUT_LINE(LV_ADDITIVE || CASE WHEN
                                 LV_TABLE_ALIAS IS NULL THEN '' ELSE
                                 LV_TABLE_ALIAS || '.'
                                 END || C.COLUMN_NAME);
          END IF;
        ELSIF LV_FUNCTION = 4
        THEN
          IF (C.DATA_TYPE IN ('NVARCHAR2', 'CHAR', 'NCHAR', 'VARCHAR2'))
          THEN
            DBMS_OUTPUT.PUT_LINE(LV_ADDITIVE ||
                                 
                                 'SUBSTR(TRIM(' || CASE
                                   WHEN LV_TABLE_ALIAS IS NULL THEN
                                    ''
                                   ELSE
                                    LV_TABLE_ALIAS || '.'
                                 END || C.COLUMN_NAME || '),1,' ||
                                 TO_CHAR(C.DATA_LENGTH) || ') AS ' ||
                                 C.COLUMN_NAME);
          ELSE
            DBMS_OUTPUT.PUT_LINE(LV_ADDITIVE || CASE WHEN
                                 LV_TABLE_ALIAS IS NULL THEN '' ELSE
                                 LV_TABLE_ALIAS || '.'
                                 END || C.COLUMN_NAME);
          END IF;
        END IF;
        LV_ADDITIVE := ',';
      END IF;
    END IF;
  END LOOP;
  IF (LV_OUTPUT_4_FORM_ASSIGNMENT = 1)
  THEN
    DBMS_OUTPUT.PUT_LINE('END;');
  ELSIF (LV_OLD_NEW_4_TRIGGER = 1 OR LV_OUTPUT_4_PLSQL_ASSIGNMENT = 1 OR
        LV_OUTPUT_4_SELECT = 1)
  THEN
    DBMS_OUTPUT.PUT_LINE('FROM ' || CASE
                           WHEN LV_OUTPUT_SCHEMA IS NULL THEN
                            ''
                           ELSE
                            LV_SCHEMA || '.'
                         END || LV_TABLE_NAME || ' ' || LV_TABLE_ALIAS);
    /*
        IF (LV_OUTPUT_SCHEMA IS NULL)
        THEN
          DBMS_OUTPUT.PUT_LINE('FROM ' || LV_TABLE_NAME || ' ' ||
                               LV_TABLE_ALIAS);
        ELSE
          DBMS_OUTPUT.PUT_LINE('FROM ' || LV_SCHEMA || '.' || LV_TABLE_NAME || ' ' ||
                               LV_TABLE_ALIAS);
        END IF;
    */
  END IF;
  DBMS_OUTPUT.PUT_LINE('--TO_DATE(A, ''YYYY/MM/DD'', ''NLS_CALENDAR=PERSIAN'') AS A');
  DBMS_OUTPUT.PUT_LINE('--TO_CHAR(A, ''YYYY/MM/DD'', ''NLS_CALENDAR=PERSIAN'') AS A');
END;
13
SCHEMA_
1
﻿mam
5
OUTPUT_SCHEMA
1
﻿mam
5
TABLE_NAME
1
﻿MAM_REQUEST_HEADERS
5
TABLE_ALIAS
1
﻿h
5
NULL_FIELDS
1
0
3
NOT_NULL_FIELDS
1
1
3
OUTPUT_4_CREATE_TABLE
1
﻿0
5
OLD_NEW_4_TRIGGER
1
0
3
OUTPUT_4_FORM_ASSIGNMENT
1
0
3
OUTPUT_4_PLSQL_ASSIGNMENT
1
0
3
OUTPUT_4_SELECT
1
1
3
FUNCTION_INDEX
1
0
3
NOT_NULL_FIELDS_CONDITION
1
﻿TRUNC(CREATE_DATE) = TRUNC(SYSDATE)
5
1
LV_SQL
