CREATE OR REPLACE PACKAGE MAM_LOG_AND_COMMIT_MAKER_PKG IS
  -- CREATE_CHECK_ROUTINE ------------------------------
  FUNCTION CREATE_CHECK_ROUTINE( --
                                P_PACKAGE_NAME    VARCHAR2
                               ,P_ROUTINE_NAME    VARCHAR2
                               ,P_ROUTINE_CREATED OUT VARCHAR2
                                --
                                ) RETURN CLOB;
  -- CREATE_CHECK_ROUTINE ------------------------------
  FUNCTION CREATE_IMPLEMENT_CHECK_ROUTINE( --
                                          P_PACKAGE_NAME    VARCHAR2
                                         ,P_ROUTINE_NAME    VARCHAR2
                                         ,P_ROUTINE_CREATED OUT VARCHAR2
                                          --
                                          ) RETURN CLOB;
  -- CREATE_LOG_ROUTINE ------------------------------
  FUNCTION CREATE_LOG_ROUTINE( --
                              P_PACKAGE_NAME    VARCHAR2
                             ,P_ROUTINE_NAME    VARCHAR2
                             ,P_ROUTINE_CREATED OUT VARCHAR2
                              --
                              ) RETURN CLOB;

  -- CREATE_COMMIT_ROUTINE ------------------------------
  FUNCTION CREATE_COMMIT_ROUTINE( --
                                 P_PACKAGE_NAME    VARCHAR2
                                ,P_ROUTINE_NAME    VARCHAR2
                                ,P_ROUTINE_CREATED OUT VARCHAR2
                                 --
                                 ) RETURN CLOB;
END;
/*
BEGIN
  :RESULT1 := MAM_LOG_AND_COMMIT_MAKER_PKG.CREATE_CHECK_ROUTINE(P_PACKAGE_NAME    => :P_PACKAGE_NAME
                                                              ,P_ROUTINE_NAME    => :P_ROUTINE_NAME
                                                              ,P_ROUTINE_CREATED => :P_ROUTINE_CREATED1);
  :RESULT2 := MAM_LOG_AND_COMMIT_MAKER_PKG.CREATE_IMPLEMENT_CHECK_ROUTINE(P_PACKAGE_NAME    => :P_PACKAGE_NAME
                                                              ,P_ROUTINE_NAME    => :P_ROUTINE_NAME
                                                              ,P_ROUTINE_CREATED => :P_ROUTINE_CREATED2);
  :RESULT3 := MAM_LOG_AND_COMMIT_MAKER_PKG.CREATE_LOG_ROUTINE(P_PACKAGE_NAME    => :P_PACKAGE_NAME
                                                              ,P_ROUTINE_NAME    => :P_ROUTINE_NAME
                                                              ,P_ROUTINE_CREATED => :P_ROUTINE_CREATED3);
  :RESULT4 := MAM_LOG_AND_COMMIT_MAKER_PKG.CREATE_COMMIT_ROUTINE(P_PACKAGE_NAME    => :P_PACKAGE_NAME
                                                              ,P_ROUTINE_NAME    => :P_ROUTINE_NAME
                                                              ,P_ROUTINE_CREATED => :P_ROUTINE_CREATED4);
END;
*/
/
CREATE OR REPLACE PACKAGE BODY MAM_LOG_AND_COMMIT_MAKER_PKG IS

  -- CREATE_LOG_ROUTINE_NAME ------------------------------
  FUNCTION CREATE_CHECK_ROUTINE_NAME( --
                                     P_INPUT_ROUTINE_NAME VARCHAR2
                                     --
                                     ) RETURN VARCHAR2 IS
    LV_RESULT VARCHAR2(200);
  BEGIN
    LV_RESULT := UPPER(MAM_EXECUTE_IMMEDIATE_PKG.PACK_INPUT_FUN('CHECK_' ||
                                                                P_INPUT_ROUTINE_NAME
                                                               ,24));
    RETURN LV_RESULT;
  END;
  -- CREATE_LOG_ROUTINE_NAME ------------------------------
  FUNCTION CREATE_LOG_ROUTINE_NAME( --
                                   P_INPUT_ROUTINE_NAME VARCHAR2
                                   --
                                   ) RETURN VARCHAR2 IS
    LV_RESULT VARCHAR2(200);
  BEGIN
    LV_RESULT := UPPER(MAM_EXECUTE_IMMEDIATE_PKG.PACK_INPUT_FUN(P_INPUT_ROUTINE_NAME
                                                               ,26) ||
                       '_LOG');
    RETURN LV_RESULT;
  END;
  -- CREATE_COMMIT_ROUTINE_NAME ------------------------------
  FUNCTION CREATE_COMMIT_ROUTINE_NAME( --
                                      P_INPUT_ROUTINE_NAME VARCHAR2
                                      --
                                      ) RETURN VARCHAR2 IS
    LV_RESULT VARCHAR2(200);
  BEGIN
    LV_RESULT := UPPER(MAM_EXECUTE_IMMEDIATE_PKG.PACK_INPUT_FUN(P_INPUT_ROUTINE_NAME
                                                               ,26) ||
                       '_cmt');
    RETURN LV_RESULT;
  END;
  -- CREATE_CHECK_ROUTINE ------------------------------
  FUNCTION CREATE_CHECK_ROUTINE( --
                                P_PACKAGE_NAME    VARCHAR2
                               ,P_ROUTINE_NAME    VARCHAR2
                               ,P_ROUTINE_CREATED OUT VARCHAR2
                                --
                                ) RETURN CLOB IS
    LV_RESULT          CLOB;
    LV_ROUTINE_CREATED VARCHAR2(200);
    LV_COMMA           VARCHAR2(5);
    LV_PACKAGE_NAME    VARCHAR2(256) := UPPER(TRIM(P_PACKAGE_NAME));
    LV_ROUTINE_NAME    VARCHAR2(256) := UPPER(TRIM(P_ROUTINE_NAME));
  BEGIN
    FOR P IN ( --
              SELECT B.OBJECT_NAME
                     ,B.SUBPROGRAM_ID
                     ,CNT
                     ,B2.ARGUMENT_NAME
                     ,B2.DATA_TYPE
                FROM ( --
                       SELECT A.OBJECT_NAME, A.SUBPROGRAM_ID, COUNT(1) AS CNT
                         FROM ALL_ARGUMENTS A
                        WHERE NVL(A.PACKAGE_NAME, '-') =
                              NVL(LV_PACKAGE_NAME, '-')
                          AND A.OBJECT_NAME = LV_ROUTINE_NAME
                        GROUP BY A.OBJECT_NAME, A.SUBPROGRAM_ID
                        ORDER BY A.OBJECT_NAME, A.SUBPROGRAM_ID
                       --
                       ) B
                LEFT OUTER JOIN ( --
                                 SELECT B1.SUBPROGRAM_ID
                                        ,B1.ARGUMENT_NAME
                                        ,B1.DATA_TYPE
                                   FROM ALL_ARGUMENTS B1
                                  WHERE NVL(B1.PACKAGE_NAME, '-') =
                                        NVL(LV_PACKAGE_NAME, '-')
                                    AND B1.OBJECT_NAME = LV_ROUTINE_NAME
                                    AND B1.POSITION = 0
                                 --
                                 ) B2
                  ON B.SUBPROGRAM_ID = B2.SUBPROGRAM_ID
              --
              )
    LOOP
      LV_ROUTINE_CREATED := CREATE_CHECK_ROUTINE_NAME(P.OBJECT_NAME);
      LV_RESULT          := LV_RESULT ||
                            RPAD(STR1 => '-- ' || LV_ROUTINE_CREATED || ' '
                                ,LEN  => 80
                                ,PAD  => '-');
      LV_RESULT          := LV_RESULT || CHR(10) || 'FUNCTION ' ||
                            LV_ROUTINE_CREATED || '(--';
      LV_COMMA           := NULL;
      FOR R IN ( --
                SELECT DISTINCT A.POSITION
                                ,A.ARGUMENT_NAME
                                ,A.DATA_TYPE
                                ,A.IN_OUT
                  FROM ALL_ARGUMENTS A
                 WHERE NVL(A.PACKAGE_NAME, '-') = NVL(LV_PACKAGE_NAME, '-')
                   AND A.OBJECT_NAME = LV_ROUTINE_NAME
                   AND A.SUBPROGRAM_ID = P.SUBPROGRAM_ID
                --AND A.IN_OUT != 'OUT'
                 ORDER BY A.POSITION
                --
                )
      LOOP
        IF R.ARGUMENT_NAME IS NOT NULL
        THEN
          IF R.IN_OUT != 'OUT'
          THEN
            LV_RESULT := LV_RESULT || CHR(10) || LV_COMMA ||
                         R.ARGUMENT_NAME || ' ' || R.DATA_TYPE;
            LV_COMMA  := ',';
          END IF;
        END IF;
      END LOOP;
      LV_RESULT := LV_RESULT || CHR(10) || ' --' || CHR(10) || ')';
      LV_RESULT := LV_RESULT || CHR(10) || ' RETURN VARCHAR2' || ' IS ';
      LV_RESULT := LV_RESULT || CHR(10) || ' LV_RESULT VARCHAR2(1000);';
      LV_RESULT := LV_RESULT || CHR(10) || ' BEGIN ';
      LV_RESULT := LV_RESULT || CHR(10) || 'IF LV_RESULT IS NULL THEN ' ||
                   CHR(10) || 'LV_RESULT:=NULL; END IF;';
      LV_RESULT := LV_RESULT || CHR(10) ||
                   '--IF LV_RESULT IS NULL THEN LV_RESULT:=NULL; END IF;';
      LV_RESULT := LV_RESULT || CHR(10) || ' RETURN LV_RESULT; ';
      LV_RESULT := LV_RESULT || CHR(10) || ' END; ';
      LV_RESULT := LV_RESULT || CHR(10);
    END LOOP;
    P_ROUTINE_CREATED := LV_ROUTINE_CREATED;
    RETURN LV_RESULT;
  END;
  -- CREATE_CHECK_ROUTINE ------------------------------
  FUNCTION CREATE_IMPLEMENT_CHECK_ROUTINE( --
                                          P_PACKAGE_NAME    VARCHAR2
                                         ,P_ROUTINE_NAME    VARCHAR2
                                         ,P_ROUTINE_CREATED OUT VARCHAR2
                                          --
                                          ) RETURN CLOB IS
    LV_RESULT          CLOB;
    LV_ROUTINE_CREATED VARCHAR2(200);
    LV_COMMA           VARCHAR2(5);
    LV_PACKAGE_NAME    VARCHAR2(256) := UPPER(TRIM(P_PACKAGE_NAME));
    LV_ROUTINE_NAME    VARCHAR2(256) := UPPER(TRIM(P_ROUTINE_NAME));
  BEGIN
    FOR P IN ( --
              SELECT B.OBJECT_NAME
                     ,B.SUBPROGRAM_ID
                     ,CNT
                     ,B2.ARGUMENT_NAME
                     ,B2.DATA_TYPE
                FROM ( --
                       SELECT A.OBJECT_NAME, A.SUBPROGRAM_ID, COUNT(1) AS CNT
                         FROM ALL_ARGUMENTS A
                        WHERE NVL(A.PACKAGE_NAME, '-') =
                              NVL(LV_PACKAGE_NAME, '-')
                          AND A.OBJECT_NAME = LV_ROUTINE_NAME
                        GROUP BY A.OBJECT_NAME, A.SUBPROGRAM_ID
                        ORDER BY A.OBJECT_NAME, A.SUBPROGRAM_ID
                       --
                       ) B
                LEFT OUTER JOIN ( --
                                 SELECT B1.SUBPROGRAM_ID
                                        ,B1.ARGUMENT_NAME
                                        ,B1.DATA_TYPE
                                   FROM ALL_ARGUMENTS B1
                                  WHERE NVL(B1.PACKAGE_NAME, '-') =
                                        NVL(LV_PACKAGE_NAME, '-')
                                    AND B1.OBJECT_NAME = LV_ROUTINE_NAME
                                    AND B1.POSITION = 0
                                 --
                                 ) B2
                  ON B.SUBPROGRAM_ID = B2.SUBPROGRAM_ID
              --
              )
    LOOP
      LV_ROUTINE_CREATED := CREATE_CHECK_ROUTINE_NAME(P.OBJECT_NAME);
      /*      LV_RESULT          := LV_RESULT ||
                                  RPAD(STR1 => '-- ' || LV_ROUTINE_CREATED || ' '
                                      ,LEN  => 80
                                      ,PAD  => '-');
            IF P.ARGUMENT_NAME IS NULL
            THEN
              LV_RESULT := LV_RESULT || CHR(10) || 'FUNCTION ';
            ELSE
              LV_RESULT := LV_RESULT || CHR(10) || 'PROCEDURE ';
            END IF;
      */
      --       IF P.CNT > 1 THEN
      LV_RESULT := LV_RESULT || CHR(10) ||
                   'IF LV_RESULT IS NULL THEN LV_RESULT:=' ||
                   LV_ROUTINE_CREATED || '(--';
      --       END IF;
      LV_COMMA := NULL;
      FOR R IN ( --
                SELECT DISTINCT A.POSITION
                                ,A.ARGUMENT_NAME
                                ,A.DATA_TYPE
                                ,A.IN_OUT
                  FROM ALL_ARGUMENTS A
                 WHERE NVL(A.PACKAGE_NAME, '-') = NVL(LV_PACKAGE_NAME, '-')
                   AND A.OBJECT_NAME = LV_ROUTINE_NAME
                   AND A.SUBPROGRAM_ID = P.SUBPROGRAM_ID
                --AND A.IN_OUT != 'OUT'
                 ORDER BY A.POSITION
                --
                )
      LOOP
        IF R.ARGUMENT_NAME IS NOT NULL
        THEN
          IF R.IN_OUT != 'OUT'
          THEN
            LV_RESULT := LV_RESULT || CHR(10) || LV_COMMA ||
                         R.ARGUMENT_NAME || '=>' || R.ARGUMENT_NAME;
            LV_COMMA  := ',';
          END IF;
        END IF;
      END LOOP;
      LV_RESULT := LV_RESULT || CHR(10) || ' --' || CHR(10) || ');';
      LV_RESULT := LV_RESULT || CHR(10) || ' END IF;';
      LV_RESULT := LV_RESULT || CHR(10);
    END LOOP;
    P_ROUTINE_CREATED := LV_ROUTINE_CREATED;
    RETURN LV_RESULT;
  END;
  -- CREATE_LOG_ROUTINE ------------------------------
  FUNCTION CREATE_LOG_ROUTINE( --
                              P_PACKAGE_NAME    VARCHAR2
                             ,P_ROUTINE_NAME    VARCHAR2
                             ,P_ROUTINE_CREATED OUT VARCHAR2
                              --
                              ) RETURN CLOB IS
    LV_RESULT          CLOB;
    LV_ROUTINE_CREATED VARCHAR2(200);
    LV_COMMA           VARCHAR2(5);
    LV_PACKAGE_NAME    VARCHAR2(256) := UPPER(TRIM(P_PACKAGE_NAME));
    LV_ROUTINE_NAME    VARCHAR2(256) := UPPER(TRIM(P_ROUTINE_NAME));
  
  BEGIN
    FOR P IN ( --
              SELECT B.OBJECT_NAME
                     ,B.SUBPROGRAM_ID
                     ,CNT
                     ,B2.ARGUMENT_NAME
                     ,B2.DATA_TYPE
                FROM ( --
                       SELECT A.OBJECT_NAME, A.SUBPROGRAM_ID, COUNT(1) AS CNT
                         FROM ALL_ARGUMENTS A
                        WHERE NVL(A.PACKAGE_NAME, '-') =
                              NVL(LV_PACKAGE_NAME, '-')
                          AND A.OBJECT_NAME = LV_ROUTINE_NAME
                        GROUP BY A.OBJECT_NAME, A.SUBPROGRAM_ID
                        ORDER BY A.OBJECT_NAME, A.SUBPROGRAM_ID
                       --
                       ) B
                LEFT OUTER JOIN ( --
                                 SELECT B1.SUBPROGRAM_ID
                                        ,B1.ARGUMENT_NAME
                                        ,B1.DATA_TYPE
                                   FROM ALL_ARGUMENTS B1
                                  WHERE NVL(B1.PACKAGE_NAME, '-') =
                                        NVL(LV_PACKAGE_NAME, '-')
                                    AND B1.OBJECT_NAME = LV_ROUTINE_NAME
                                    AND B1.POSITION = 0
                                 --
                                 ) B2
                  ON B.SUBPROGRAM_ID = B2.SUBPROGRAM_ID
              --
              )
    LOOP
      LV_ROUTINE_CREATED := CREATE_LOG_ROUTINE_NAME(P.OBJECT_NAME);
      LV_RESULT          := LV_RESULT ||
                            RPAD(STR1 => '-- ' || LV_ROUTINE_CREATED || ' '
                                ,LEN  => 80
                                ,PAD  => '-');
      IF P.ARGUMENT_NAME IS NULL
      THEN
        LV_RESULT := LV_RESULT || CHR(10) || 'FUNCTION ' ||
                     LV_ROUTINE_CREATED;
      ELSE
        LV_RESULT := LV_RESULT || CHR(10) || 'PROCEDURE ' ||
                     LV_ROUTINE_CREATED;
      END IF;
      IF NVL(P.CNT, 0) > 1
      THEN
        --         LV_RESULT := LV_RESULT || LV_ROUTINE_CREATED || '(--';
        LV_RESULT := LV_RESULT || '(--';
      END IF;
      FOR R IN ( --
                SELECT DISTINCT A.POSITION
                                ,A.ARGUMENT_NAME
                                ,A.DATA_TYPE
                                ,CASE
                                   WHEN A.IN_OUT = 'IN/OUT' THEN
                                    'IN OUT'
                                   ELSE
                                    A.IN_OUT
                                 END AS IN_OUT
                  FROM ALL_ARGUMENTS A
                 WHERE NVL(A.PACKAGE_NAME, '-') = NVL(LV_PACKAGE_NAME, '-')
                   AND A.OBJECT_NAME = LV_ROUTINE_NAME
                   AND A.SUBPROGRAM_ID = P.SUBPROGRAM_ID
                --AND A.IN_OUT != 'OUT'
                 ORDER BY A.POSITION
                --
                )
      LOOP
        IF R.ARGUMENT_NAME IS NOT NULL
        THEN
          LV_RESULT := LV_RESULT || CHR(10) || LV_COMMA || R.ARGUMENT_NAME || ' ' || CASE
                         WHEN UPPER(TRIM(R.IN_OUT)) != UPPER(TRIM('IN')) THEN
                          R.IN_OUT || ' '
                       END || R.DATA_TYPE;
          LV_COMMA  := ',';
        END IF;
      END LOOP;
      IF P.CNT > 1
      THEN
        LV_RESULT := LV_RESULT || CHR(10) || '--' || CHR(10) || ')';
      END IF;
      IF P.DATA_TYPE IS NULL
      THEN
        LV_RESULT := LV_RESULT || ' IS ' || CHR(10);
      ELSE
        LV_RESULT := LV_RESULT || CHR(10) || ' RETURN ' || P.DATA_TYPE ||
                     ' IS ';
        LV_RESULT := LV_RESULT || CHR(10) || ' LV_RESULT ' || P.DATA_TYPE || CASE
                       WHEN P.DATA_TYPE IN ('VARCHAR2') THEN
                        '(1000)'
                     END || ';';
      END IF;
      --       LV_RESULT := LV_RESULT || CHR(10) || ' BEGIN ';
      LV_RESULT := LV_RESULT || CHR(10) || ' LV_LOG_RESULT VARCHAR2(1000);';
      LV_RESULT := LV_RESULT || CHR(10) ||
                   ' LV_LOG_ID MAM_LOGS.LOG_ID%TYPE;';
      LV_RESULT := LV_RESULT || CHR(10) ||
                   ' LV_LOG_RESPONSE_ID MAM_LOG_RESPONSES.LOG_RESPONSE_ID%TYPE;';
      LV_RESULT := LV_RESULT || CHR(10) ||
                   'LV_LOG_AFFECTED_RECORD_ID MAM_LOG_AFFECTED_RECORDS.LOG_AFFECTED_RECORD_ID%TYPE;';
      LV_RESULT := LV_RESULT || CHR(10) || ' BEGIN ';
      LV_RESULT := LV_RESULT || CHR(10) ||
                   'LV_LOG_RESULT := APP_MAM_LOGS_PKG.ADD( --';
      LV_RESULT := LV_RESULT || CHR(10) ||
                   'P_LOG_ID                   => LV_LOG_ID';
      LV_RESULT := LV_RESULT || CHR(10) || ',P_NAM_CALLER_ROUTINE_MLOGS => ''' || CASE
                     WHEN LV_PACKAGE_NAME IS NOT NULL THEN
                      LV_PACKAGE_NAME || '.'
                   END || LV_ROUTINE_CREATED || '''';
      /*
            LV_RESULT := LV_RESULT || CHR(10) ||
                         ',P_TXT_PARAMETERS_MLOGS     => ''' ||
                         REPLACE(MAM_LOGS_CTRL_PKG.LOG_SQL(P_PACKAGE_NAME => LV_PACKAGE_NAME
                                                          ,P_ROUTINE_NAME => LV_ROUTINE_NAME)
                                ,CHR(39)
                                ,CHR(39) || CHR(39)) || '';
      */
      LV_RESULT := LV_RESULT || CHR(10) ||
                   ',P_TXT_PARAMETERS_MLOGS     => ' ||
                   MAM_LOGS_CTRL_PKG.LOG_SQL(P_PACKAGE_NAME  => LV_PACKAGE_NAME
                                            ,P_ROUTINE_NAME  => LV_ROUTINE_NAME
                                            ,P_SUBPROGRAM_ID => P.SUBPROGRAM_ID);
      LV_RESULT := LV_RESULT || CHR(10) || '--';
      LV_RESULT := LV_RESULT || CHR(10) || ');';
      IF P.DATA_TYPE IS NULL
      THEN
        LV_RESULT := LV_RESULT || CHR(10) || ' BEGIN ';
      ELSE
        LV_RESULT := LV_RESULT || CHR(10) ||
                     ' IF LV_RESULT IS NULL THEN BEGIN' || CHR(10) ||
                     'LV_RESULT:=';
      END IF;
      --*******************************************************************************
      LV_RESULT := LV_RESULT || CHR(10) || P_PACKAGE_NAME || CASE
                     WHEN P_PACKAGE_NAME IS NOT NULL THEN
                      '.'
                   END || LV_ROUTINE_NAME;
      IF P.CNT > 1
      THEN
        LV_RESULT := LV_RESULT || /*CHR(10) ||*/
                     '(--';
      END IF;
      LV_COMMA := '';
      FOR R IN ( --
                SELECT DISTINCT A.POSITION
                                ,A.ARGUMENT_NAME
                                ,A.DATA_TYPE
                                ,A.IN_OUT
                  FROM ALL_ARGUMENTS A
                 WHERE NVL(A.PACKAGE_NAME, '-') = NVL(LV_PACKAGE_NAME, '-')
                   AND A.OBJECT_NAME = LV_ROUTINE_NAME
                   AND A.SUBPROGRAM_ID = P.SUBPROGRAM_ID
                --AND A.IN_OUT != 'OUT'
                 ORDER BY A.POSITION
                --
                )
      LOOP
        IF R.ARGUMENT_NAME IS NOT NULL
        THEN
          LV_RESULT := LV_RESULT || CHR(10) || LV_COMMA || R.ARGUMENT_NAME ||
                       ' => ' || R.ARGUMENT_NAME;
          LV_COMMA  := ',';
        END IF;
      END LOOP;
      IF P.CNT > 1
      THEN
        LV_RESULT := LV_RESULT || CHR(10) || '--' || CHR(10) || ')';
      END IF;
      LV_RESULT := LV_RESULT || ';';
      --*******************************************************************************
      LV_RESULT := LV_RESULT || CHR(10) || ' EXCEPTION WHEN OTHERS THEN ';
      IF P.DATA_TYPE IS NULL
      THEN
        LV_RESULT := LV_RESULT || CHR(10) || ' NULL; ';
      ELSE
        LV_RESULT := LV_RESULT || CHR(10) ||
                     'LV_RESULT := SUBSTR(''{'' || SQLERRM || ''}'', 1, 300);' ||
                     CHR(10) || 'END; END IF; ';
        LV_RESULT := LV_RESULT || CHR(10) || 'IF LV_RESULT IS NULL';
        LV_RESULT := LV_RESULT || CHR(10) || 'THEN';
        LV_RESULT := LV_RESULT || CHR(10) ||
                     'LV_LOG_RESULT := MAM_LOG_AFFECTED_RCRDS_APP_PKG.ADD( --';
        LV_RESULT := LV_RESULT || CHR(10) ||
                     'P_LOG_AFFECTED_RECORD_ID => LV_LOG_AFFECTED_RECORD_ID';
        LV_RESULT := LV_RESULT || CHR(10) ||
                     ',P_MLAFR_LOG_ID           => LV_LOG_ID';
        LV_RESULT := LV_RESULT || CHR(10) ||
                     ',P_NAM_TABLE_MLAFR        => ''MAM_MATERIAL_TRANSACTIONS''';
        LV_RESULT := LV_RESULT || CHR(10) ||
                     ',P_NAM_KEY_FIELD_MLAFR    => ''MATERIAL_TRANSACTION_ID''';
        LV_RESULT := LV_RESULT || CHR(10) ||
                     ',P_NAM_VAL_MLAFR          => P_MATERIAL_TRANSACTION_ID_FROM';
        LV_RESULT := LV_RESULT || CHR(10) || '--';
        LV_RESULT := LV_RESULT || CHR(10) || ');';
        LV_RESULT := LV_RESULT || CHR(10) || 'ELSE';
        LV_RESULT := LV_RESULT || CHR(10) || 'IF LV_LOG_ID IS NOT NULL';
        LV_RESULT := LV_RESULT || CHR(10) || 'THEN';
        LV_RESULT := LV_RESULT || CHR(10) ||
                     'LV_LOG_RESULT := APP_MAM_LOG_RESPONSES_PKG.ADD( --';
        LV_RESULT := LV_RESULT || CHR(10) ||
                     'P_LOG_RESPONSE_ID    => LV_LOG_RESPONSE_ID';
        LV_RESULT := LV_RESULT || CHR(10) ||
                     ',P_LOG_ID_MLOGR       => LV_LOG_ID';
        LV_RESULT := LV_RESULT || CHR(10) ||
                     ',P_TXT_RESPONSE_MLOGR => LV_RESULT';
        LV_RESULT := LV_RESULT || CHR(10) || '--';
        LV_RESULT := LV_RESULT || CHR(10) || ');';
        LV_RESULT := LV_RESULT || CHR(10) || 'END IF;';
        LV_RESULT := LV_RESULT || CHR(10) || 'END IF;';
      END IF;
      IF P.DATA_TYPE IS NULL
      THEN
        LV_RESULT := LV_RESULT || ' END; ';
      ELSE
        LV_RESULT := LV_RESULT || CHR(10) || ' RETURN LV_RESULT; ';
        LV_RESULT := LV_RESULT || CHR(10) || ' END; ';
      END IF;
      LV_RESULT := LV_RESULT || CHR(10);
    END LOOP;
    P_ROUTINE_CREATED := LV_ROUTINE_CREATED;
    RETURN LV_RESULT;
  END;
  -- CREATE_COMMIT_ROUTINE ------------------------------
  FUNCTION CREATE_COMMIT_ROUTINE( --
                                 P_PACKAGE_NAME    VARCHAR2
                                ,P_ROUTINE_NAME    VARCHAR2
                                ,P_ROUTINE_CREATED OUT VARCHAR2
                                 --
                                 ) RETURN CLOB IS
    LV_RESULT          CLOB;
    LV_ROUTINE_CREATED VARCHAR2(200);
    LV_COMMA           VARCHAR2(5);
    LV_PACKAGE_NAME    VARCHAR2(256) := UPPER(TRIM(P_PACKAGE_NAME));
    LV_ROUTINE_NAME    VARCHAR2(256) := UPPER(TRIM(P_ROUTINE_NAME));
  
  BEGIN
    FOR P IN ( --
              SELECT B.OBJECT_NAME
                     ,B.SUBPROGRAM_ID
                     ,CNT
                     ,B2.ARGUMENT_NAME
                     ,B2.DATA_TYPE
                FROM ( --
                       SELECT A.OBJECT_NAME, A.SUBPROGRAM_ID, COUNT(1) AS CNT
                         FROM ALL_ARGUMENTS A
                        WHERE NVL(A.PACKAGE_NAME, '-') =
                              NVL(LV_PACKAGE_NAME, '-')
                          AND A.OBJECT_NAME = LV_ROUTINE_NAME
                        GROUP BY A.OBJECT_NAME, A.SUBPROGRAM_ID
                        ORDER BY A.OBJECT_NAME, A.SUBPROGRAM_ID
                       --
                       ) B
                LEFT OUTER JOIN ( --
                                 SELECT B1.SUBPROGRAM_ID
                                        ,B1.ARGUMENT_NAME
                                        ,B1.DATA_TYPE
                                   FROM ALL_ARGUMENTS B1
                                  WHERE NVL(B1.PACKAGE_NAME, '-') =
                                        NVL(LV_PACKAGE_NAME, '-')
                                    AND B1.OBJECT_NAME = LV_ROUTINE_NAME
                                    AND B1.POSITION = 0
                                 --
                                 ) B2
                  ON B.SUBPROGRAM_ID = B2.SUBPROGRAM_ID
              --
              )
    LOOP
      LV_ROUTINE_CREATED := CREATE_COMMIT_ROUTINE_NAME(P.OBJECT_NAME);
      LV_RESULT          := LV_RESULT ||
                            RPAD(STR1 => '-- ' || LV_ROUTINE_CREATED || ' '
                                ,LEN  => 80
                                ,PAD  => '-');
      IF P.ARGUMENT_NAME IS NULL
      THEN
        LV_RESULT := LV_RESULT || CHR(10) || 'FUNCTION ' ||
                     LV_ROUTINE_CREATED;
      ELSE
        LV_RESULT := LV_RESULT || CHR(10) || 'PROCEDURE ' ||
                     LV_ROUTINE_CREATED;
      END IF;
      IF P.CNT > 1
      THEN
        --         LV_RESULT := LV_RESULT || LV_ROUTINE_CREATED || '(--';
        LV_RESULT := LV_RESULT || '(--';
      END IF;
      FOR R IN ( --
                SELECT DISTINCT A.POSITION
                                ,A.ARGUMENT_NAME
                                ,A.DATA_TYPE
                                ,CASE
                                   WHEN A.IN_OUT = 'IN/OUT' THEN
                                    'IN OUT'
                                   ELSE
                                    A.IN_OUT
                                 END AS IN_OUT
                  FROM ALL_ARGUMENTS A
                 WHERE NVL(A.PACKAGE_NAME, '-') = NVL(LV_PACKAGE_NAME, '-')
                   AND A.OBJECT_NAME = LV_ROUTINE_NAME
                   AND A.SUBPROGRAM_ID = P.SUBPROGRAM_ID
                --AND A.IN_OUT != 'OUT'
                 ORDER BY A.POSITION
                --
                )
      LOOP
        IF R.ARGUMENT_NAME IS NOT NULL
        THEN
          LV_RESULT := LV_RESULT || CHR(10) || LV_COMMA || R.ARGUMENT_NAME || ' ' || CASE
                         WHEN UPPER(TRIM(R.IN_OUT)) != UPPER(TRIM('IN')) THEN
                          R.IN_OUT || ' '
                       END || R.DATA_TYPE;
          LV_COMMA  := ',';
        END IF;
      END LOOP;
      IF P.CNT > 1
      THEN
        LV_RESULT := LV_RESULT || CHR(10) || '--' || CHR(10) || ')';
      END IF;
      IF P.DATA_TYPE IS NULL
      THEN
        LV_RESULT := LV_RESULT || ' IS ' || CHR(10) ||
                     ' PRAGMA AUTONOMOUS_TRANSACTION; ';
      ELSE
        LV_RESULT := LV_RESULT || CHR(10) || ' RETURN ' || P.DATA_TYPE ||
                     ' IS ' || CHR(10) ||
                     ' PRAGMA AUTONOMOUS_TRANSACTION; ';
        LV_RESULT := LV_RESULT || CHR(10) || ' LV_RESULT ' || P.DATA_TYPE || CASE
                       WHEN P.DATA_TYPE IN ('VARCHAR2') THEN
                        '(1000)'
                     END || ';';
      END IF;
      LV_RESULT := LV_RESULT || CHR(10) || ' BEGIN ';
      LV_RESULT := LV_RESULT || CHR(10) ||
                   ' IF LV_RESULT IS NULL THEN BEGIN' || CHR(10) ||
                   'LV_RESULT:=';
      --*******************************************************************************
      LV_RESULT := LV_RESULT || CHR(10) || P_PACKAGE_NAME || CASE
                     WHEN P_PACKAGE_NAME IS NOT NULL THEN
                      '.'
                   END ||
                   CREATE_LOG_ROUTINE_NAME(P_INPUT_ROUTINE_NAME => P_ROUTINE_NAME);
      IF P.CNT > 1
      THEN
        LV_RESULT := LV_RESULT || /*CHR(10) ||*/
                     '(--';
      END IF;
      LV_COMMA := '';
      FOR R IN ( --
                SELECT DISTINCT A.POSITION
                                ,A.ARGUMENT_NAME
                                ,A.DATA_TYPE
                                ,A.IN_OUT
                  FROM ALL_ARGUMENTS A
                 WHERE NVL(A.PACKAGE_NAME, '-') = NVL(LV_PACKAGE_NAME, '-')
                   AND A.OBJECT_NAME = LV_ROUTINE_NAME
                   AND A.SUBPROGRAM_ID = P.SUBPROGRAM_ID
                --AND A.IN_OUT != 'OUT'
                 ORDER BY A.POSITION
                --
                )
      LOOP
        IF R.ARGUMENT_NAME IS NOT NULL
        THEN
          LV_RESULT := LV_RESULT || CHR(10) || LV_COMMA || R.ARGUMENT_NAME ||
                       ' => ' || R.ARGUMENT_NAME;
          LV_COMMA  := ',';
        END IF;
      END LOOP;
      IF P.CNT > 1
      THEN
        LV_RESULT := LV_RESULT || CHR(10) || '--' || CHR(10) || ')';
      END IF;
      LV_RESULT := LV_RESULT || ';';
      --*******************************************************************************
      LV_RESULT := LV_RESULT || CHR(10) || ' EXCEPTION WHEN OTHERS THEN ';
      IF P.DATA_TYPE IS NULL
      THEN
        LV_RESULT := LV_RESULT || CHR(10) || ' NULL; ';
      ELSE
        LV_RESULT := LV_RESULT || CHR(10) ||
                     'LV_RESULT := SUBSTR(''{'' || SQLERRM || ''}'', 1, 300);' ||
                     CHR(10) || 'END; END IF; ';
      END IF;
      IF P.DATA_TYPE IS NULL
      THEN
        LV_RESULT := LV_RESULT || ' END; ';
      ELSE
        LV_RESULT := LV_RESULT || CHR(10) || ' IF LV_RESULT IS NULL';
        LV_RESULT := LV_RESULT || CHR(10) || ' THEN';
        LV_RESULT := LV_RESULT || CHR(10) || ' COMMIT;';
        LV_RESULT := LV_RESULT || CHR(10) || ' ELSE';
        LV_RESULT := LV_RESULT || CHR(10) || ' ROLLBACK;';
        LV_RESULT := LV_RESULT || CHR(10) || ' END IF;';
        LV_RESULT := LV_RESULT || CHR(10) || ' RETURN LV_RESULT; ';
        LV_RESULT := LV_RESULT || CHR(10) || ' END; ';
      END IF;
      LV_RESULT := LV_RESULT || CHR(10);
    END LOOP;
    P_ROUTINE_CREATED := LV_ROUTINE_CREATED;
    RETURN LV_RESULT;
  END;
BEGIN
  NULL;
END;
/
