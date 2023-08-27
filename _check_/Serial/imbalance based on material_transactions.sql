SELECT *
  FROM ( --
        SELECT Z.MATERIAL_TRANSACTION_ID AS XID
               ,(SELECT RX.RCV_TRANSACTION_ID
                   FROM MAM.MAM_RCV_TRANSACTIONS RX
                  WHERE RX.MTRAN_MATERIAL_TRANSACTION_ID =
                        Z.MATERIAL_TRANSACTION_ID) AS RXID_ON_XID
               ,SUM(Z.QTY_PRIMARY_MTRAN / ABS(Z.QTY_PRIMARY_MTRAN)) OVER(PARTITION BY Z.MSER_SERIAL_NUMBER_ID, Z.ITEM_ITEM_ID_FOR) AS SUM_ITEM_SERIAL
               ,(SELECT SUM(XX.QTY_PRIMARY_MTRAN)
                   FROM MAM.MAM_MATERIAL_TRANSACTIONS XX
                  WHERE XX.ITEM_ITEM_ID_FOR = Z.ITEM_ITEM_ID_FOR) AS SQ
               ,(SELECT I.COD_ITEM
                   FROM MAM.MAM_ITEMS I
                  WHERE I.ITEM_ID = Z.ITEM_ITEM_ID_FOR) AS ITEM
               ,Z.ITEM_ITEM_ID_FOR AS ITEM_ID
               ,S.SERIAL_NUMBER_ID
               ,S.COD_SERIAL_NUMBER_MSER AS COD_SERIAL_NUMBER
               ,(SELECT DISTINCT XY.MSINV_NAM_SUB_INVENTORY_MSIFOR
                   FROM MAM.MAM_MATERIAL_TRANSACTIONS XY
                   LEFT OUTER JOIN MAM.MAM_TRANSACTION_SERIAL_NUMBERS XSY
                     ON XY.MATERIAL_TRANSACTION_ID =
                        XSY.MTRAN_MATERIAL_TRANSACTION_ID
                  WHERE XSY.MSER_SERIAL_NUMBER_ID = S.SERIAL_NUMBER_ID
                        AND
                        XY.MATERIAL_TRANSACTION_ID = Z.MATERIAL_TRANSACTION_ID) AS INV
               ,(SELECT DISTINCT XY.MSLOC_SUB_INVENTORY_LOCATORFOR
                   FROM MAM.MAM_MATERIAL_TRANSACTIONS XY
                   LEFT OUTER JOIN MAM.MAM_TRANSACTION_SERIAL_NUMBERS XSY
                     ON XY.MATERIAL_TRANSACTION_ID =
                        XSY.MTRAN_MATERIAL_TRANSACTION_ID
                  WHERE XSY.MSER_SERIAL_NUMBER_ID = S.SERIAL_NUMBER_ID
                        AND
                        XY.MATERIAL_TRANSACTION_ID = Z.MATERIAL_TRANSACTION_ID) AS LID
               ,S.LKP_STA_CURRENT_MSER AS LKP_STA
               ,Z.MTYP_TRANSACTION_TYPE_ID AS TT
               ,Z.MSER_SERIAL_NUMBER_ID AS SID
               ,(SELECT RX.NUM_RECEIPT_AP_MRCV
                   FROM MAM.MAM_RCV_TRANSACTIONS RX
                  WHERE RX.MTRAN_MATERIAL_TRANSACTION_ID =
                        Z.MATERIAL_TRANSACTION_ID) AS NUM_RECEIPT_AP_MRCV
               ,Z.DAT_TRANSACTION_MTRAN
               ,TO_CHAR(Z.DAT_TRANSACTION_MTRAN
                       ,'YYYY/MM/DD hh24:mi:ss'
                       ,'NLS_CALENDAR=PERSIAN') AS DH
               ,COUNT(Z.MATERIAL_TRANSACTION_ID) OVER(PARTITION BY Z.MSER_SERIAL_NUMBER_ID) CNT_ITEM_SERIAL
               ,CASE
                  WHEN ABS(Z.QTY_PRIMARY_MTRAN) != SUM(1)
                   OVER(PARTITION BY Z.MATERIAL_TRANSACTION_ID) THEN
                   '!'
                END AS ABNORMAL
               ,Z.QTY_PRIMARY_MTRAN
               ,SUM(1) OVER(PARTITION BY Z.MATERIAL_TRANSACTION_ID) AS XS_SUM_QTY
          FROM ( --
                 SELECT DISTINCT X.QTY_PRIMARY_MTRAN
                                 ,XS.MSER_SERIAL_NUMBER_ID
                                 ,X.ITEM_ITEM_ID_FOR
                                 ,X.MATERIAL_TRANSACTION_ID
                                 ,X.MTYP_TRANSACTION_TYPE_ID
                                 ,X.DAT_TRANSACTION_MTRAN
                   FROM MAM.MAM_MATERIAL_TRANSACTIONS X
                   LEFT OUTER JOIN MAM.MAM_TRANSACTION_SERIAL_NUMBERS XS
                     ON XS.MTRAN_MATERIAL_TRANSACTION_ID =
                        X.MATERIAL_TRANSACTION_ID
                  WHERE
                 /*X.DAT_TRANSACTION_MTRAN >=
                 TO_DATE('1400/01/01', 'YYYY/MM/DD', 'NLS_CALENDAR=PERSIAN')
                 AND*/
                  EXISTS
                  (SELECT NULL
                     FROM (SELECT ITEM_ID
                             FROM ( --
                                   SELECT I43.ITEM_ID
                                     FROM MAM.MAM_ITEMS I43
                                    WHERE I43.COD_SERIAL_NUMBER_CONTROL_ITEM = 1
                                          AND EXISTS
                                    (SELECT NULL
                                             FROM MAM.MAM_MATERIAL_TRANSACTIONS X
                                            WHERE X.ITEM_ITEM_ID_FOR = I43.ITEM_ID
                                                  AND NOT EXISTS
                                            (SELECT NULL
                                                     FROM MAM.MAM_TRANSACTION_SERIAL_NUMBERS XS
                                                    WHERE XS.MTRAN_MATERIAL_TRANSACTION_ID =
                                                          X.MATERIAL_TRANSACTION_ID))
                                   MINUS
                                   SELECT I46.ITEM_ID
                                     FROM MAM.MAM_ITEMS I46
                                    WHERE I46.COD_SERIAL_NUMBER_CONTROL_ITEM = 1
                                          AND EXISTS
                                    (SELECT NULL
                                             FROM MAM.MAM_RCV_TRANSACTIONS RX
                                            WHERE RX.ITEM_ITEM_ID = I46.ITEM_ID
                                                  AND
                                                  RX.MTRAN_MATERIAL_TRANSACTION_ID IS NOT NULL
                                                  AND NOT EXISTS
                                            (SELECT NULL
                                                     FROM MAM.MAM_RCV_SERIAL_TRANSACTIONS RXS
                                                    WHERE RXS.MRCV_RCV_TRANSACTION_ID =
                                                          RX.RCV_TRANSACTION_ID))
                                   --
                                   ) G53
                            WHERE ROWNUM = 1) I
                    WHERE I.ITEM_ID = X.ITEM_ITEM_ID_FOR)
                 --
                 ) Z
          LEFT OUTER JOIN MAM.MAM_SERIAL_NUMBERS S
            ON Z.MSER_SERIAL_NUMBER_ID = S.SERIAL_NUMBER_ID
        --    where nvl(S.COD_SERIAL_NUMBER_MSER,0)not in('1')
        --
        )
-- WHERE (&X = 0 OR CNT_ITEM_SERIAL != 2)
 ORDER BY --0 DESC, 
          COD_SERIAL_NUMBER
         ,DAT_TRANSACTION_MTRAN
