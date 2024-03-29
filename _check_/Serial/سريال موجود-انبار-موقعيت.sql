SELECT XS.MSER_SERIAL_NUMBER_ID
      ,(SELECT S.ITEM_ITEM_ID
          FROM MAM.MAM_SERIAL_NUMBERS S
         WHERE S.SERIAL_NUMBER_ID = XS.MSER_SERIAL_NUMBER_ID) AS COD_SERIAL_NUMBER_MSER
      ,(SELECT S.COD_SERIAL_NUMBER_MSER
          FROM MAM.MAM_SERIAL_NUMBERS S
         WHERE S.SERIAL_NUMBER_ID = XS.MSER_SERIAL_NUMBER_ID) AS COD_SERIAL_NUMBER_MSER
      ,X.MSINV_NAM_SUB_INVENTORY_MSIFOR
      ,X.MSLOC_SUB_INVENTORY_LOCATORFOR
  FROM MAM.MAM_TRANSACTION_SERIAL_NUMBERS XS
 INNER JOIN MAM.MAM_MATERIAL_TRANSACTIONS X
    ON XS.MTRAN_MATERIAL_TRANSACTION_ID = X.MATERIAL_TRANSACTION_ID
 WHERE 1 = 1
       AND X.ITEM_ITEM_ID_FOR =
       (SELECT ITEM_ID
              FROM MAM.MAM_ITEMS I
             WHERE I.COD_ITEM = TRIM('&COD_ITEM'))
 GROUP BY XS.MSER_SERIAL_NUMBER_ID
         ,X.MSINV_NAM_SUB_INVENTORY_MSIFOR
         ,X.MSLOC_SUB_INVENTORY_LOCATORFOR
HAVING SUM(SIGN(X.QTY_PRIMARY_MTRAN)) > 0
