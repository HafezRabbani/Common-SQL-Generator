SELECT RXL.RCV_LOT_TRANSACTION_ID
      ,RXL.ITEM_ITEM_ID
      ,APPS.MAM_ITEMS_CTRL_PKG.GET_DESCRIPTION(P_ITEM_ID => RXL.ITEM_ITEM_ID) AS ITEM
      ,RXL.NUM_LOT_MRCVL
      ,RXL.QTY_MRCVL
      ,RXL.MRCV_RCV_TRANSACTION_ID
      ,RXL.MRCV_RCV_TRANSACTION_ID_FOR
      ,RXL.COD_REVISION_MRCVL
      ,RXL.CREATE_DATE
      ,RXL.CREATE_BY_DB_USER
      ,RXL.CREATE_BY_APP_USER
      ,RXL.LAST_UPDATE_DATE
      ,RXL.LAST_UPDATE_BY_DB_USER
      ,RXL.LAST_UPDATE_BY_APP_USER
      ,RXL.ATTACH_ID
  FROM MAM.MAM_RCV_LOT_TRANSACTIONS RXL
 WHERE 1 = 1
   AND EXISTS
 (SELECT NULL
          FROM MAM.MAM_RCV_TRANSACTIONS A3
         WHERE RXL.MRCV_RCV_TRANSACTION_ID = A3.RCV_TRANSACTION_ID
           AND A3.NUM_RECEIPT_AP_MRCV in( &NUM_RECEIPT_AP_MRCV))
