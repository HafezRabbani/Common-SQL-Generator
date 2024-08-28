BEGIN
  FOR C IN (SELECT F, '''' || F || '''' AS F2
              FROM ( --
                    SELECT TRIM(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(S.TEXT
                                                                        ,'FUNCTION'
                                                                        ,'')
                                                                ,'RETURN'
                                                                ,'')
                                                        ,'VARCHAR2'
                                                        ,'')
                                                ,'NUMBER;'
                                                ,'')
                                        ,CHR(10)
                                        ,'')) AS F
                      FROM ALL_SOURCE S
                     WHERE S.NAME = UPPER(TRIM('&pkg'))
                       AND S.TYPE = 'PACKAGE'
                       AND TEXT LIKE '%FUNCTION%')
            --
            )
  LOOP
    DBMS_OUTPUT.PUT_LINE('SELECT APPS.' || UPPER(TRIM('&pkg')) || '.' || C.F ||
                         ' AS F_VALUE,' || C.F2 || ' AS F FROM DUAL');
    DBMS_OUTPUT.PUT_LINE(' UNION');
  END LOOP;
END;
