PL/SQL Developer Test script 3.0
67
DECLARE
  L             NUMBER;
  LV_SQL        VARCHAR2(1000);
  LV_SCHEMA     VARCHAR2(1000);
  LV_TABLE_NAME VARCHAR2(1000);

  LV_ADDITIVE VARCHAR2(100) := ' ';
BEGIN
  LV_TABLE_NAME := UPPER(TRIM(:TABLE_NAME));
  FOR C IN ( --
            
            SELECT UPPER('COMMENT ON ' || Z.OBJECT_TYPE || ' ' ||
                          Z.OBJECT_NAME || ' is ''' ||
                          NVL(NVL(Z.COMMENTS, ALTERNATE_COMMENT), '?') ||
                          '''; ') AS SCRIPT
            
              FROM ( --
                     SELECT 'TABLE' AS OBJECT_TYPE
                            ,V.TABLE_NAME AS OBJECT_NAME
                            ,TC.COMMENTS
                            ,NULL AS ALTERNATE_COMMENT
                     
                       FROM ( --
                              SELECT T1.TABLE_NAME
                                FROM ALL_TABLES T1
                              UNION
                              SELECT T2.VIEW_NAME AS TABLE_NAME
                                FROM ALL_VIEWS T2
                              --
                              ) V
                       LEFT OUTER JOIN ALL_TAB_COMMENTS TC
                         ON V.TABLE_NAME = TC.TABLE_NAME
                      WHERE V.TABLE_NAME LIKE UPPER(LV_TABLE_NAME)
                     UNION
                     SELECT 'COLUMN' AS OBJECT_TYPE
                            ,V.TABLE_NAME || '.' || V.COLUMN_NAME AS OBJECT_NAME
                            ,CC.COMMENTS
                            ,(SELECT T.COMMENTS
                                FROM ALL_COL_COMMENTS T
                               WHERE 1 = 1
                                    --AND T.OWNER IN ('MAM', 'PUR')
                                     AND T.COMMENTS IS NOT NULL
                                     AND T.COLUMN_NAME = V.COLUMN_NAME
                                     AND
                                     UPPER(FND.FND_REPLACE_STRING(TRIM(T.COMMENTS))) NOT IN
                                     (V.COLUMN_NAME
                                     ,FND.FND_REPLACE_STRING('ﬂ·Ìœ «’·Ì'))
                                     AND ROWNUM = 1) AS ALTERNATE_COMMENT
                       FROM ALL_TAB_COLUMNS V
                       LEFT OUTER JOIN ALL_COL_COMMENTS CC
                         ON V.TABLE_NAME = CC.TABLE_NAME
                            AND V.COLUMN_NAME = CC.COLUMN_NAME
                      WHERE V.TABLE_NAME LIKE UPPER(LV_TABLE_NAME)
                     --
                     ) Z
             ORDER BY CASE
                         WHEN UPPER(Z.OBJECT_TYPE) = UPPER('TABLE') THEN
                          0
                         ELSE
                          1
                       END
            --
            )
  LOOP
    DBMS_OUTPUT.PUT_LINE(C.SCRIPT);
  END LOOP;
END;
1
TABLE_NAME
1
Ôªøpur_packing_numbers_viw
5
0
