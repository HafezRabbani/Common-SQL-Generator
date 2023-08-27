DECLARE
  LV_ITEM_ID               NUMBER;
  P_SERIAL_NUMBER_ID       NUMBER;
  P_COD_SERIAL_NUMBER_MSER VARCHAR2(100);
  LV_RESULT1               VARCHAR2(1000);
  LV_RESULT2               VARCHAR2(1000);
BEGIN
  FOR C IN ( --
            SELECT Z.*
                   ,QTY_MREQL - RS_CNT AS DIF
              FROM ( --
                     SELECT H.REQUEST_HEADER_ID
                            ,H.NUM_REQUEST_MREQH
                            ,I.ITEM_ID
                            ,I.COD_ITEM
                            ,I.DES_ITEM
                            ,L.REQUEST_LINE_ID
                            ,L.QTY_MREQL
                            ,(SELECT COUNT(1)
                                FROM MAM.MAM_REQUEST_TRANSACTIONS RX
                               INNER JOIN MAM.MAM_REQUEST_TRANS_SERIALS RXS
                                  ON RX.REQUEST_TRANSACTION_ID =
                                     RXS.MRTRA_REQUEST_TRANSACTION_ID
                               WHERE RX.MREQL_REQUEST_LINE_ID = L.REQUEST_LINE_ID) AS RXS_CNT
                            ,(SELECT COUNT(1)
                                FROM MAM.MAM_REQUEST_SERIAL_NUMBERS RS
                               WHERE RS.MREQL_REQUEST_LINE_ID = L.REQUEST_LINE_ID) AS RS_CNT
                       FROM MAM.MAM_ITEMS I
                      INNER JOIN MAM.MAM_REQUEST_LINES L
                         ON I.ITEM_ID = L.ITEM_ITEM_ID
                      INNER JOIN MAM.MAM_REQUEST_HEADERS H
                         ON L.MREQH_REQUEST_HEADER_ID = H.REQUEST_HEADER_ID
                      WHERE I.COD_SERIAL_NUMBER_CONTROL_ITEM = 1
                            AND L.LKP_STA_LINE_MREQL BETWEEN 20 AND 30
                     --
                     ) Z
             WHERE QTY_MREQL > NVL(RS_CNT, 0)
             ORDER BY NUM_REQUEST_MREQH
            --
            )
  LOOP
    FOR I IN 1 .. C.DIF
    LOOP
      P_COD_SERIAL_NUMBER_MSER := NULL;
      P_SERIAL_NUMBER_ID       := NULL;
      LV_RESULT1               := APPS.APP_MAM_SERIAL_NUMBERS_PKG.ADD(P_SERIAL_NUMBER_ID       => P_SERIAL_NUMBER_ID
                                                                     ,P_ITEM_ITEM_ID           => C.ITEM_ID
                                                                     ,P_COD_SERIAL_NUMBER_MSER => P_COD_SERIAL_NUMBER_MSER
                                                                     ,P_LKP_STA_CURRENT_MSER   => 3);
      IF LV_RESULT1 IS NULL
      THEN
        LV_RESULT2 := APPS.APP_MAM_REQUEST_SERILNMBRS_PKG.ADD(P_MREQL_REQUEST_LINE_ID => C.REQUEST_LINE_ID
                                                             ,P_MSER_SERIAL_NUMBER_ID => P_SERIAL_NUMBER_ID
                                                             ,P_DAT_TRANSACTION_MRSER => SYSDATE);
      END IF;
      IF LV_RESULT1 IS NULL
         AND LV_RESULT2 IS NULL
      THEN
        COMMIT;
      ELSE
        ROLLBACK;
      END IF;
    END LOOP;
  END LOOP;
END;
