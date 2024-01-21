BEGIN
  FOR C IN (SELECT F
                  ,'''' || F || '''' AS F2
              FROM ( --
                    SELECT TRIM(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(S.TEXT
                                                                ,'FUNCTION'
                                                                ,'')
                                                        ,'RETURN'
                                                        ,'')
                                                ,'VARCHAR2'
                                                ,'')
                                        ,'NUMBER;'
                                        ,''),chr(10),'')) AS F
                      FROM ALL_SOURCE S
                     WHERE S.NAME = 'MAM_ERRORS_PKG'
                           AND S.TYPE = 'PACKAGE'
                           AND TEXT LIKE '%FUNCTION%')
            --
            )
  LOOP
    DBMS_OUTPUT.PUT_LINE('SELECT APPS.MAM_ERRORS_PKG.' || C.F ||
                         ' AS F_VALUE,' || C.F2 || ' AS F FROM DUAL');
    DBMS_OUTPUT.PUT_LINE(' UNION');
  END LOOP;
END;
