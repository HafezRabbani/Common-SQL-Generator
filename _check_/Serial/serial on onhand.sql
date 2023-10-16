SELECT Q.ONHAND_QUANTITY_ID
      ,Q.QTY_MONH
      ,Q.ITEM_ITEM_ID
      ,(SELECT I.COD_ITEM
          FROM MAM.MAM_ITEMS I
         WHERE I.ITEM_ID = Q.ITEM_ITEM_ID) AS I
      ,Q.MSINV_NAM_SUB_INVENTORY_MSINV
      ,Q.MSLOC_SUB_INVENTORY_LOCATOR_ID
      ,(SELECT L.COD_LOCATOR_MSLOC
          FROM MAM.MAM_SUB_INVENTORY_LOCATORS L
         WHERE L.SUB_INVENTORY_LOCATOR_ID =
               Q.MSLOC_SUB_INVENTORY_LOCATOR_ID) AS COD_LOCATOR
      ,Q.MSER_SERIAL_NUMBER_ID
      ,(SELECT S.COD_SERIAL_NUMBER_MSER
          FROM MAM.MAM_SERIAL_NUMBERS S
         WHERE S.SERIAL_NUMBER_ID = Q.MSER_SERIAL_NUMBER_ID) AS COD_SERIAL_NUMBER_MSER
      ,(SELECT SUM(SIGN(X.QTY_PRIMARY_MTRAN))
          FROM MAM.MAM_TRANSACTION_SERIAL_NUMBERS XS
         INNER JOIN MAM.MAM_MATERIAL_TRANSACTIONS X
            ON XS.MTRAN_MATERIAL_TRANSACTION_ID = X.MATERIAL_TRANSACTION_ID
         WHERE XS.MSER_SERIAL_NUMBER_ID = Q.MSER_SERIAL_NUMBER_ID) AS SQXS
  FROM MAM.MAM_ONHAND_QUANTITIES Q
 WHERE 1 = 1
       AND Q.ITEM_ITEM_ID =
       (SELECT ITEM_ID
              FROM MAM.MAM_ITEMS I
             WHERE I.COD_ITEM = TRIM('&COD_ITEM'))
   FOR UPDATE
