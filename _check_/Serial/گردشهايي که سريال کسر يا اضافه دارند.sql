SELECT DISTINCT (SELECT COD_ITEM
                   FROM MAM.MAM_ITEMS I
                  WHERE I.ITEM_ID = Z.ITEM_ITEM_ID_FOR) AS COD_ITEM
-- ,Z.*
  FROM ( --
        SELECT X.MATERIAL_TRANSACTION_ID
               ,X.MTYP_TRANSACTION_TYPE_ID
               ,X.QTY_PRIMARY_MTRAN
               ,X.QTY_TRANSACTION_MTRAN
               ,COUNT(XS.MSER_SERIAL_NUMBER_ID) OVER(PARTITION BY X.MATERIAL_TRANSACTION_ID) C
               ,X.ITEM_ITEM_ID_FOR
          FROM MAM.MAM_MATERIAL_TRANSACTIONS X
          LEFT OUTER JOIN MAM.MAM_TRANSACTION_SERIAL_NUMBERS XS
            ON X.MATERIAL_TRANSACTION_ID = XS.MTRAN_MATERIAL_TRANSACTION_ID
         INNER JOIN MAM.MAM_ITEMS I
            ON X.ITEM_ITEM_ID_FOR = I.ITEM_ID
        
         WHERE I.COD_SERIAL_NUMBER_CONTROL_ITEM = 1
               AND
               X.DAT_TRANSACTION_MTRAN >
               (TO_DATE('1400/01/01', 'YYYY/MM/DD', 'NLS_CALENDAR=PERSIAN') -
               (1 / 86400))
        /* 
                 and X.ITEM_ITEM_ID_FOR =
                       (SELECT ITEM_ID
                          FROM MAM.MAM_ITEMS I
                         WHERE I.COD_ITEM = &COD_ITEM)
        */
        --
        ) Z
 WHERE ABS(QTY_TRANSACTION_MTRAN) != C
       OR ABS(QTY_TRANSACTION_MTRAN) != C
