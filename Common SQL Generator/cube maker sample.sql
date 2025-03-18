DECLARE
  LV_ADDITIVE VARCHAR2(10);
  LV_CNTR     NUMBER;
BEGIN
  LV_CNTR := 1;
  DBMS_OUTPUT.PUT_LINE('SELECT * FROM (--');
  DBMS_OUTPUT.PUT_LINE('SELECT TO_CHAR(TRUNC(X.DAT_TRANSACTION_MTRAN),' ||
                       CHR(39) || 'YYYY/MM' || CHR(39) || ',' || CHR(39) ||
                       'NLS_CALENDAR=PERSIAN' || CHR(39) ||
                       ') AS TRANSACTION_DATE_H');
  FOR C IN ( --
            SELECT DISTINCT I.ITEM_ID
                            ,I.COD_ITEM
              FROM MAM.MAM_MATERIAL_TRANSACTIONS X
             INNER JOIN MAM.MAM_ITEMS I
                ON X.ITEM_ITEM_ID_FOR = I.ITEM_ID
             WHERE X.MTYP_TRANSACTION_TYPE_ID IN (51)
            --
            )
  LOOP
    DBMS_OUTPUT.PUT_LINE( --LV_ADDITIVE ||
                         ',(SELECT ABS(SUM(X' || LV_CNTR ||
                         '.QTY_PRIMARY_MTRAN)) FROM MAM.MAM_MATERIAL_TRANSACTIONS X' ||
                         LV_CNTR || ' WHERE X' || LV_CNTR ||
                         '.MTYP_TRANSACTION_TYPE_ID IN (51) AND X' ||
                         LV_CNTR || '.ITEM_ITEM_ID_FOR =' || C.ITEM_ID ||
                         ' AND TO_CHAR(TRUNC(X' || LV_CNTR ||
                         '.DAT_TRANSACTION_MTRAN)
                          ,' || CHR(39) ||
                         'YYYY/MM' || CHR(39) || ',' || CHR(39) ||
                         'NLS_CALENDAR=PERSIAN' || CHR(39) ||
                         ')=TO_CHAR(TRUNC(X.DAT_TRANSACTION_MTRAN)
                          ,' || CHR(39) ||
                         'YYYY/MM' || CHR(39) || ',' || CHR(39) ||
                         'NLS_CALENDAR=PERSIAN' || CHR(39) || ')) AS "' ||
                         C.COD_ITEM || '"');
    LV_ADDITIVE := ',';
    LV_CNTR     := LV_CNTR + 1;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('FROM MAM.MAM_MATERIAL_TRANSACTIONS X
         WHERE X.MTYP_TRANSACTION_TYPE_ID IN (51)
         GROUP BY TO_CHAR(TRUNC(X.DAT_TRANSACTION_MTRAN),' ||
                       CHR(39) || 'YYYY/MM' || CHR(39) || ',' || CHR(39) ||
                       'NLS_CALENDAR=PERSIAN' || CHR(39) || ')');
  DBMS_OUTPUT.PUT_LINE('--');
  DBMS_OUTPUT.PUT_LINE(') ORDER BY TRANSACTION_DATE_H');
END;
