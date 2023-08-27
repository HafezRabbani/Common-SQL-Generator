SELECT RX.ITEM_ITEM_ID
      ,RXS.NUM_SERIAL_MRCVS
      ,COUNT(RXS.NUM_SERIAL_MRCVS)
      ,(SELECT COD_ITEM FROM MAM.MAM_ITEMS WHERE ITEM_ID = RX.ITEM_ITEM_ID) AS COD_ITEM
  FROM MAM.MAM_RCV_TRANSACTIONS RX
 INNER JOIN MAM.MAM_RCV_SERIAL_TRANSACTIONS RXS
    ON RX.RCV_TRANSACTION_ID = RXS.MRCV_RCV_TRANSACTION_ID
 WHERE RX.ITEM_ITEM_ID NOT IN (733, 1365, 1984, 419, 639, 1368)
 GROUP BY RX.ITEM_ITEM_ID
         ,RXS.NUM_SERIAL_MRCVS
HAVING COUNT(RXS.NUM_SERIAL_MRCVS) > 1
 ORDER BY 3
         ,1
