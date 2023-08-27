SELECT cnt,NUM_RECEIPT_AP_MRCV
      ,LKP_TYP_TRANSACTION_MRCV
      ,QTY_PRIMARY_MRCV
      ,MTRAN_MATERIAL_TRANSACTION_ID
      ,MATERIAL_TRANSACTION_ID
      ,MTYP_TRANSACTION_TYPE_ID
      ,DAT_TRANSACTION_MTRAN_H
      ,ITEM
      ,QTY_PRIMARY_MTRAN
  FROM ( --
        SELECT COUNT(1) OVER(PARTITION BY RX.NUM_RECEIPT_AP_MRCV) AS CNT
               ,RX.NUM_RECEIPT_AP_MRCV
               ,RX.LKP_TYP_TRANSACTION_MRCV
               ,RX.QTY_PRIMARY_MRCV
               ,RX.MTRAN_MATERIAL_TRANSACTION_ID
               ,X.MATERIAL_TRANSACTION_ID
               ,X.DAT_TRANSACTION_MTRAN
               ,X.MTYP_TRANSACTION_TYPE_ID
               ,TO_CHAR(X.DAT_TRANSACTION_MTRAN
                       ,'YYYY/MM/DD HH24:MI:SS'
                       ,'NLS_CALENDAR=PERSIAN') AS DAT_TRANSACTION_MTRAN_H
               ,(SELECT I.COD_ITEM || ': ' || I.DES_ITEM
                   FROM MAM.MAM_ITEMS I
                  WHERE I.ITEM_ID = X.ITEM_ITEM_ID_FOR) AS ITEM
               ,X.QTY_PRIMARY_MTRAN
          FROM ( --
                 SELECT *
                   FROM MAM.MAM_RCV_TRANSACTIONS RX1
                  WHERE RX1.NUM_RECEIPT_AP_MRCV LIKE '40%'
                        AND RX1.ITEM_ITEM_ID = 42
                        AND RX1.MTRAN_MATERIAL_TRANSACTION_ID IS NOT NULL
                        AND ( --
                         TRUNC(RX1.DAT_TRANSACTION_MRCV) =
                         TO_DATE('1400/08/12'
                                    ,'yyyy/mm/dd'
                                    ,'nls_calendar=persian') 
                        --
                        )
                 --
                 ) RX
         INNER JOIN MAM.MAM_MATERIAL_TRANSACTIONS X
            ON (X.TXT_COMM_MTRAN LIKE '%Based on material_transaction_id = ' ||
               RX.MTRAN_MATERIAL_TRANSACTION_ID || '%')
        --
        )
--WHERE CNT = 1
 ORDER BY NUM_RECEIPT_AP_MRCV
         ,DAT_TRANSACTION_MTRAN
