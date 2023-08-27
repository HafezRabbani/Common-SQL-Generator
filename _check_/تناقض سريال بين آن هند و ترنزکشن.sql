SELECT *
  FROM (SELECT I.ITEM_ID
              ,I.COD_ITEM
              ,I.DES_ITEM
              ,NVL((SELECT SUM(X.QTY_PRIMARY_MTRAN)
                     FROM MAM.MAM_MATERIAL_TRANSACTIONS X
                    WHERE X.ITEM_ITEM_ID_FOR = I.ITEM_ID)
                  ,0) SX
              ,NVL((SELECT SUM(Q.QTY_MONH)
                     FROM MAM.MAM_ONHAND_QUANTITIES Q
                    WHERE Q.ITEM_ITEM_ID = I.ITEM_ID)
                  ,0) SQ
          FROM MAM.MAM_ITEMS I
         WHERE I.COD_SERIAL_NUMBER_CONTROL_ITEM = 1) D
 WHERE SX <> SQ;
