CREATE OR REPLACE PACKAGE MAM_ROUTINE_CONTRAST_PKG IS
  FUNCTION ROUTINE_EXTRACTION( --
                              P_PACKAGE_NAME ALL_ARGUMENTS.PACKAGE_NAME%TYPE
                             ,P_ROUTINE_NAME ALL_ARGUMENTS.OBJECT_NAME%TYPE
                              --
                              ) RETURN VARCHAR2;
  FUNCTION CHECK_IF_ROUTINE_EXISTS( --
                                   P_PACKAGE_NAME ALL_ARGUMENTS.PACKAGE_NAME%TYPE
                                  ,P_ROUTINE_NAME ALL_ARGUMENTS.OBJECT_NAME%TYPE
                                  ,P_COUNT        NUMBER
                                   --
                                   ) RETURN VARCHAR2;
END;
/
CREATE OR REPLACE PACKAGE BODY MAM_ROUTINE_CONTRAST_PKG IS

  -- ROUTINE_EXTRACTION_CHECK --------------------------------------------------------------------------------
  FUNCTION ROUTINE_EXTRACTION_CHECK( --
                                    P_PACKAGE_NAME ALL_ARGUMENTS.PACKAGE_NAME%TYPE
                                   ,P_ROUTINE_NAME ALL_ARGUMENTS.OBJECT_NAME%TYPE
                                    --
                                    ) RETURN VARCHAR2 IS
    LV_RESULT VARCHAR2(1000);
  BEGIN
    IF P_PACKAGE_NAME IS NULL
       AND P_ROUTINE_NAME IS NULL
    THEN
      LV_RESULT := '{نام پکیج و نام روتین نمیتواند توأمان تهی باشد}';
    END IF;
    RETURN LV_RESULT;
  END;
  -- ROUTINE_EXTRACTION --------------------------------------------------------------------------------
  FUNCTION ROUTINE_EXTRACTION( --
                              P_PACKAGE_NAME ALL_ARGUMENTS.PACKAGE_NAME%TYPE
                             ,P_ROUTINE_NAME ALL_ARGUMENTS.OBJECT_NAME%TYPE
                              --
                              ) RETURN VARCHAR2 IS
    LV_RESULT VARCHAR2(1000);
    LV_CNT    NUMBER;
  BEGIN
    LV_RESULT := ROUTINE_EXTRACTION_CHECK( --
                                          P_PACKAGE_NAME => P_PACKAGE_NAME
                                         ,P_ROUTINE_NAME => P_ROUTINE_NAME
                                          --
                                          );
    IF LV_RESULT IS NULL
    THEN
      LV_CNT := 0;
      DBMS_OUTPUT.PUT_LINE('WITH SOURCE_TABLE AS(');
      FOR C IN ( --
                SELECT A.OBJECT_NAME
                       ,A.PACKAGE_NAME
                       ,A.SUBPROGRAM_ID
                       ,COUNT(1) AS CNT
                --      ,A.*
                  FROM ALL_ARGUMENTS A
                 WHERE 1 = 1
                   AND (A.PACKAGE_NAME = UPPER(P_PACKAGE_NAME) OR
                       P_PACKAGE_NAME IS NULL)
                   AND (A.OBJECT_NAME = UPPER(P_ROUTINE_NAME) OR
                       P_ROUTINE_NAME IS NULL)
                 GROUP BY A.OBJECT_NAME, A.PACKAGE_NAME, A.SUBPROGRAM_ID
                 ORDER BY A.PACKAGE_NAME, A.OBJECT_NAME
                --
                )
      LOOP
        DBMS_OUTPUT.PUT_LINE(CASE WHEN LV_CNT > 0 THEN ' UNION '
                             END || --
                             'SELECT ' --
                             || CHR(39) || C.PACKAGE_NAME || CHR(39) ||
                             ' AS PACKAGE_NAME' || --
                             ', ' || CHR(39) || C.OBJECT_NAME || CHR(39) ||
                             ' AS ROUTINE_NAME ' || --
                             ', ' || C.CNT || ' AS ARGUMENT_COUNT' || --
                             ' FROM DUAL');
        LV_CNT := LV_CNT + 1;
      END LOOP;
      DBMS_OUTPUT.PUT_LINE(')');
      DBMS_OUTPUT.PUT_LINE('SELECT T.PACKAGE_NAME, T.ROUTINE_NAME, T.ARGUMENT_COUNT' || --
                           ', MAM_ROUTINE_CONTRAST_PKG.CHECK_IF_ROUTINE_EXISTS(P_PACKAGE_NAME => T.PACKAGE_NAME,P_ROUTINE_NAME => T.ROUTINE_NAME,P_COUNT => T.ARGUMENT_COUNT) AS EXISTANCE FROM SOURCE_TABLE T');
      DBMS_OUTPUT.PUT_LINE('UNION (SELECT A.PACKAGE_NAME');
      DBMS_OUTPUT.PUT_LINE(',A.OBJECT_NAME AS ROUTINE_NAME');
      DBMS_OUTPUT.PUT_LINE(',COUNT(1) AS ARGUMENT_COUNT');
      DBMS_OUTPUT.PUT_LINE(',' || CHR(39) || 'Source Doesn' || CHR(39) ||
                           CHR(39) || 't Have' || CHR(39) ||
                           ' AS EXISTANCE');
      DBMS_OUTPUT.PUT_LINE('FROM ALL_ARGUMENTS A');
      DBMS_OUTPUT.PUT_LINE('WHERE 1 = 1');
      DBMS_OUTPUT.PUT_LINE('AND EXISTS (SELECT NULL');
      DBMS_OUTPUT.PUT_LINE('FROM SOURCE_TABLE T1');
      DBMS_OUTPUT.PUT_LINE('WHERE T1.PACKAGE_NAME = A.PACKAGE_NAME)');
      DBMS_OUTPUT.PUT_LINE('GROUP BY A.OBJECT_NAME, A.PACKAGE_NAME, A.SUBPROGRAM_ID');
      DBMS_OUTPUT.PUT_LINE('MINUS');
      DBMS_OUTPUT.PUT_LINE('SELECT T0.PACKAGE_NAME');
      DBMS_OUTPUT.PUT_LINE(',T0.ROUTINE_NAME');
      DBMS_OUTPUT.PUT_LINE(',T0.ARGUMENT_COUNT');
      DBMS_OUTPUT.PUT_LINE(',' || CHR(39) || 'Source Doesn' || CHR(39) ||
                           CHR(39) || 't Have' || CHR(39) ||
                           ' AS EXISTANCE');
      DBMS_OUTPUT.PUT_LINE('FROM SOURCE_TABLE T0)');
    END IF;
    RETURN LV_RESULT;
  END;
  FUNCTION CHECK_IF_ROUTINE_EXISTS( --
                                   P_PACKAGE_NAME ALL_ARGUMENTS.PACKAGE_NAME%TYPE
                                  ,P_ROUTINE_NAME ALL_ARGUMENTS.OBJECT_NAME%TYPE
                                  ,P_COUNT        NUMBER
                                   --
                                   ) RETURN VARCHAR2 IS
    LV_RESULT VARCHAR2(1000);
  BEGIN
    FOR C IN ( --
              SELECT COUNT(1) AS CNT
                FROM ALL_ARGUMENTS A
               WHERE 1 = 1
                 AND (A.PACKAGE_NAME = UPPER(P_PACKAGE_NAME) OR
                     P_PACKAGE_NAME IS NULL)
                 AND (A.OBJECT_NAME = UPPER(P_ROUTINE_NAME) OR
                     P_ROUTINE_NAME IS NULL)
               GROUP BY A.OBJECT_NAME, A.PACKAGE_NAME, A.SUBPROGRAM_ID
              --
              )
    LOOP
      IF C.CNT = P_COUNT
      THEN
        LV_RESULT := 'Exists';
        EXIT;
      ELSIF C.CNT != 0
            AND P_COUNT != 0
      THEN
        LV_RESULT := 'Exists with ' || C.CNT || ' Arguments';
      END IF;
    END LOOP;
    IF LV_RESULT IS NULL
    THEN
      LV_RESULT := 'Destination Doesn''t Have';
    END IF;
    RETURN LV_RESULT;
  END;
BEGIN
  NULL;
END;
/
