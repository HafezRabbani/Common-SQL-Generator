DECLARE
  LV_PACKAGE       VARCHAR2(100) := TRIM('&PACKAGE_NAME_LIKE');
  LV_ROUTINE       VARCHAR2(100) := TRIM('&ROUTINE_LIKE');
  LV_FUNCTIONALITY NUMBER := &FUNCTIONALITY;
  --FUNCTIONALITY :
  -- 1: MAKE ROUTINE SIGNATURE
  -- 2: MAKE LOG VIEW
  LV_ADDITIVE  VARCHAR2(100);
  LV_VIEW_NAME VARCHAR2(100) := SUBSTR(SYS_GUID(), 1, 30 - 8);
BEGIN
  FOR C IN (SELECT DISTINCT A.OBJECT_NAME
                           ,A.PACKAGE_NAME
                           ,A.SUBPROGRAM_ID
              FROM ALL_ARGUMENTS A
             WHERE 1 = 1
                   AND (A.PACKAGE_NAME LIKE UPPER(LV_PACKAGE) OR
                   LV_PACKAGE IS NULL)
                   AND (A.OBJECT_NAME LIKE UPPER(LV_ROUTINE))
             ORDER BY A.PACKAGE_NAME
                     ,A.OBJECT_NAME
            --
            )
  LOOP
    LV_ADDITIVE := NULL;
    IF LV_FUNCTIONALITY = 1
    THEN
      DBMS_OUTPUT.PUT_LINE(CASE
                             WHEN C.PACKAGE_NAME IS NOT NULL THEN
                              C.PACKAGE_NAME || '.'
                           END || C.OBJECT_NAME || '(');
    ELSIF LV_FUNCTIONALITY = 2
    THEN
      DBMS_OUTPUT.PUT_LINE('DECLARE LV_SQL VARCHAR2(32000);');
      DBMS_OUTPUT.PUT_LINE('BEGIN');
      DBMS_OUTPUT.PUT_LINE('LV_SQL :=''CREATE OR REPLACE VIEW MAM_' || LV_VIEW_NAME ||
                           '_VIW AS ''');
      DBMS_OUTPUT.PUT_LINE('||''SELECT ''');
    END IF;
    FOR D IN ( --
              SELECT DISTINCT A1.ARGUMENT_NAME
                              ,A1.DATA_TYPE
                              ,A1.POSITION
                              ,A1.IN_OUT
                FROM ALL_ARGUMENTS A1
               WHERE 1 = 1
                     AND (A1.PACKAGE_NAME = C.PACKAGE_NAME OR
                     C.PACKAGE_NAME IS NULL)
                     AND
                     (A1.OBJECT_NAME = C.OBJECT_NAME OR C.OBJECT_NAME IS NULL)
                     AND A1.SUBPROGRAM_ID = C.SUBPROGRAM_ID
               ORDER BY A1.POSITION
              --
              )
    LOOP
      IF LV_FUNCTIONALITY = 1
      THEN
        DBMS_OUTPUT.PUT_LINE(LV_ADDITIVE || D.ARGUMENT_NAME || CASE
                               WHEN D.IN_OUT = 'IN/OUT' THEN
                                ' IN OUT '
                               WHEN D.IN_OUT = 'OUT' THEN
                                ' OUT '
                               ELSE
                                '  '
                             END || D.DATA_TYPE);
        LV_ADDITIVE := ',';
      ELSIF LV_FUNCTIONALITY = 2
      THEN
        IF (D.IN_OUT != 'OUT')
        THEN
          DBMS_OUTPUT.PUT_LINE(LV_ADDITIVE || '||CASE WHEN ' ||
                               D.ARGUMENT_NAME ||
                               ' IS NULL THEN ''NULL'' ELSE ' || CASE
                                 WHEN D.DATA_TYPE IN ('VARCHAR2', 'CHAR', 'NVARCHAR2') THEN
                                  'CHR(39)||'||D.ARGUMENT_NAME||'||CHR(39)'
                                 WHEN D.DATA_TYPE IN ('NUMBER') THEN
                                  'TO_CHAR(' || D.ARGUMENT_NAME || ')'
                                 WHEN D.DATA_TYPE IN ('DATE') THEN
                                  '''TO_DATE(''||chr(39)||' || 'TO_CHAR(' || D.ARGUMENT_NAME ||
                                  ',''YYYY/MM/DD HH24:MI:SS'',''NLS_CALENDAR=PERSIAN'')||chr(39)||''' || ',' ||
                                  CHR(39) || CHR(39) || 'YYYY/MM/DD HH24:MI:SS' || CHR(39) || CHR(39) || ',' ||
                                  CHR(39) || CHR(39) || 'NLS_CALENDAR=PERSIAN' || CHR(39) || CHR(39) ||
                                  ')'''
                                 ELSE
                                  D.ARGUMENT_NAME
                               END || '  END ||'' AS ' ||
                               SUBSTR(D.ARGUMENT_NAME, 1, 30) || '''');
          LV_ADDITIVE := '||CHR(10)||'',''';
        END IF;
      END IF;
    END LOOP;
    IF LV_FUNCTIONALITY = 1
    THEN
      DBMS_OUTPUT.PUT_LINE(');');
    ELSIF LV_FUNCTIONALITY = 2
    THEN
      DBMS_OUTPUT.PUT_LINE('|| '' FROM DUAL'';');
      DBMS_OUTPUT.PUT_LINE('app_mam_global_temps_pkg.EXEC_IMDT(LV_SQL);');
      DBMS_OUTPUT.PUT_LINE('END;');
      DBMS_OUTPUT.PUT_LINE('');
      
    END IF;
  END LOOP;
END;
--BRL_MAM_COST_CENTER_CNTRLS_PKG.INS_MCCND_PRC
