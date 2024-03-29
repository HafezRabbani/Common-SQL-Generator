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
SELECT S.SERIAL_NUMBER_ID, S.COD_SERIAL_NUMBER_MSER, S.*
  FROM MAM.MAM_SERIAL_NUMBERS S
 WHERE S.ITEM_ITEM_ID = (SELECT ITEM_ID FROM MAM.MAM_ITEMS I WHERE I.COD_ITEM = &COD_ITEM);
SELECT X.MATERIAL_TRANSACTION_ID, X.QTY_PRIMARY_MTRAN, X.*, ROWID
  FROM MAM.MAM_MATERIAL_TRANSACTIONS X
 WHERE X.ITEM_ITEM_ID_FOR = (SELECT ITEM_ID FROM MAM.MAM_ITEMS I WHERE I.COD_ITEM = &COD_ITEM)
 ORDER BY X.MATERIAL_TRANSACTION_ID;
/*
SELECT X.MSER_SERIAL_NUMBER_ID, X.*, ROWID
  FROM MAM.MAM_ONHAND_QUANTITIES X
 WHERE X.ITEM_ITEM_ID = (SELECT ITEM_ID FROM MAM.MAM_ITEMS I WHERE I.COD_ITEM = &COD_ITEM);
*/
SELECT X.MSER_SERIAL_NUMBER_ID
      ,X.MTRAN_MATERIAL_TRANSACTION_ID
      ,(SELECT X1.MTYP_TRANSACTION_TYPE_ID
          FROM MAM.MAM_MATERIAL_TRANSACTIONS X1
         WHERE X1.MATERIAL_TRANSACTION_ID = X.MTRAN_MATERIAL_TRANSACTION_ID) TT
      ,ROWID
  FROM MAM.MAM_TRANSACTION_SERIAL_NUMBERS X
 WHERE X.MTRAN_MATERIAL_TRANSACTION_ID IN
       (SELECT X1.MATERIAL_TRANSACTION_ID
          FROM MAM.MAM_MATERIAL_TRANSACTIONS X1
         WHERE X1.ITEM_ITEM_ID_FOR = (SELECT ITEM_ID FROM MAM.MAM_ITEMS I WHERE I.COD_ITEM = &COD_ITEM))
 ORDER BY X.MTRAN_MATERIAL_TRANSACTION_ID, X.MSER_SERIAL_NUMBER_ID;

SELECT X2.MATERIAL_TRANSACTION_ID
      ,X2.QTY_PRIMARY_MTRAN
      ,X2.MTYP_TRANSACTION_TYPE_ID
  FROM MAM.MAM_MATERIAL_TRANSACTIONS X2
 WHERE X2.ITEM_ITEM_ID_FOR = (SELECT ITEM_ID FROM MAM.MAM_ITEMS I WHERE I.COD_ITEM = &COD_ITEM)
       AND X2.MATERIAL_TRANSACTION_ID NOT IN
       (SELECT X.MTRAN_MATERIAL_TRANSACTION_ID
              FROM MAM.MAM_TRANSACTION_SERIAL_NUMBERS X
             WHERE X.MTRAN_MATERIAL_TRANSACTION_ID IN
                   (SELECT X1.MATERIAL_TRANSACTION_ID
                      FROM MAM.MAM_MATERIAL_TRANSACTIONS X1
                     WHERE X1.ITEM_ITEM_ID_FOR = (SELECT ITEM_ID FROM MAM.MAM_ITEMS I WHERE I.COD_ITEM = &COD_ITEM)))
 ORDER BY X2.MATERIAL_TRANSACTION_ID;
