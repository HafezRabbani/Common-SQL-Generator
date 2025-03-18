DECLARE
  LV_SQL --NUMBER; --
  VARCHAR2(32767);
BEGIN
  FOR C IN (SELECT DISTINCT S.NAME
                           ,S.TYPE
                           ,(SELECT SUM(LENGTH(SS.TEXT))
                               FROM ALL_SOURCE SS
                              WHERE SS.NAME = S.NAME
                                    AND SS.TYPE = S.TYPE) AS L
              FROM ALL_SOURCE S
             WHERE UPPER(S.TEXT) LIKE UPPER('%commit%')
                   AND
                   (S.NAME LIKE UPPER('%MAM%') OR S.NAME LIKE UPPER('%rom%') OR
                    S.NAME LIKE UPPER('%shp%'))
                   AND S.NAME NOT IN ( --
                                      'BRL_MAM_DELIVER_REQ_LINE2_PKG'
                                     ,'APP_LAB_MAM_PKG'
                                     ,'APP_MAM_PKG'
                                     ,'API_SCP_SHP_PKG'
                                     ,'APP_MAM_REQUEST_LINES_PKG'
                                     ,'FRM_FROM6001_PKG'
                                     ,'API_SMP_SHP_PKG'
                                     ,'FRM_FSHP2215_PKG'
                                     ,'SHP_RETURN_FROM_EXIT_FUN'
                                     ,'APP_ROM_SHP_PKG'
                                     ,'APP_MAM_ROM_PKG'
                                     ,'APP_MAM_CCM_PKG'
                                     ,'APP_MAM_REQUEST_HEADERS_PKG'
                                     ,'FRM_FSHP2213_PKG'
                                      --
                                      )
             ORDER BY 1
                     ,2)
  LOOP
    LV_SQL :=  --0; -- 
     NULL;
    IF C.L < 32767
    THEN
      FOR D IN (SELECT S1.TEXT
                      ,S1.LINE
                  FROM ALL_SOURCE S1
                 WHERE S1.NAME = C.NAME
                       AND S1.TYPE = C.TYPE
                 ORDER BY 2)
      LOOP
        LV_SQL := LV_SQL || CHR(10) || TRIM(D.TEXT);
        --      LV_SQL := LV_SQL + LENGTH(D.TEXT);
      END LOOP;
      BEGIN
        EXECUTE IMMEDIATE LV_SQL;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
      --    DBMS_OUTPUT.PUT_LINE(C.NAME || ' ' || C.TYPE || ' ' || LV_SQL);
    END IF;
  END LOOP;
END;
