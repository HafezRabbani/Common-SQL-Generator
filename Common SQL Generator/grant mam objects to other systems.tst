PL/SQL Developer Test script 3.0
67
--GRANT SELECT ON FND.FND_APPLICATION_SYSTEMS TO SUP_BACKEND
DECLARE
  C_MAM  CONSTANT VARCHAR2(10) := UPPER('MAM');
  C_MAM_ CONSTANT VARCHAR2(10) := C_MAM || '_';
BEGIN
  FNDSYS.APP_FND_DB_SECURITY_PKG.REFERESH_ADMIN_PRIVS_PRC(P_USERNAME => 'SUP_BACKEND');
  --  FNDSYS.APP_FND_DB_SECURITY_PKG.SET_ADMIN_PRIVS(P_APP_ZONE => 'SUP',P_USERNAME => 'SUP_BACKEND');
  FOR C IN ( --
            SELECT 'GRANT ' || V.GRANT_LEVEL || ' ON APPS.' || V.OBJECT_NAME ||
                    ' TO ' || P.BACKEND_USER AS SQL_TEXT
              FROM ( --
                     SELECT DISTINCT VI.VIEW_NAME AS OBJECT_NAME
                                     ,'SELECT' AS GRANT_LEVEL
                       FROM ALL_VIEWS VI
                      WHERE VI.VIEW_NAME LIKE C_MAM || '%'
                     UNION
                     SELECT DISTINCT S.NAME AS OBJECT_NAME
                                     ,'EXECUTE' AS GRANT_LEVEL
                       FROM ALL_SOURCE S
                      WHERE S.NAME LIKE 'APP_' || C_MAM_ || '%'
                            OR S.NAME LIKE C_MAM_ || '%FUN'
                            OR S.NAME LIKE C_MAM_ || '%PRC'
                     --
                     ) V
             INNER JOIN ( --
                         SELECT IP.NAM_APP_SHORT_APPLS
                                ,IP.NAM_APP_SHORT_APPLS || '_' AS NAM_APP_SHORT_APPLS_
                                ,CASE UPPER(IP.NAM_APP_SHORT_APPLS)
                                   WHEN 'SAL' THEN
                                    'MKT_BACKEND'
                                   WHEN 'SHP' THEN
                                    'MKT_BACKEND'
                                   WHEN 'IRM' THEN
                                    'LGS_BACKEND'
                                   WHEN 'ROM' THEN
                                    'LGS_BACKEND'
                                   WHEN 'PMS' THEN
                                    'LGS_BACKEND'
                                   WHEN 'RPS' THEN
                                    'LGS_BACKEND'
                                 END AS BACKEND_USER
                           FROM FND.FND_APPLICATION_SYSTEMS IP
                          WHERE IP.NAM_APP_SHORT_APPLS IN
                                ('SAL', 'SHP', 'IRM', 'ROM', 'PMS', 'RPS')
                         --
                         ) P
                ON UPPER(SUBSTR(V.OBJECT_NAME, 1, 8)) IN
                   (UPPER(C_MAM_ || P.NAM_APP_SHORT_APPLS_))
                   OR
                   (UPPER(SUBSTR(V.OBJECT_NAME, 1, 12)) IN
                    (UPPER('APP_' || C_MAM_ || P.NAM_APP_SHORT_APPLS_)))
            --
            )
  LOOP
    BEGIN
      IF :LV_EXECUTE_IMMEDIATE = 0
      THEN
        DBMS_OUTPUT.PUT_LINE(C.SQL_TEXT || ';');
      ELSE
        APPS.APP_MAM_GLOBAL_TEMPS_PKG.EXEC_IMDT(C.SQL_TEXT);
      END IF;
    EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('fail to execute ''' || C.SQL_TEXT || '''');
    END;
  END LOOP;
END;
1
LV_EXECUTE_IMMEDIATE
1
1
3
0
