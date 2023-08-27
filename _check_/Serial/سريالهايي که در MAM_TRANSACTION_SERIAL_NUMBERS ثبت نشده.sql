SELECT COUNT(1) OVER(PARTITION BY RX1.ITEM_ITEM_ID) AS CNT
      ,(SELECT I.COD_ITEM
          FROM MAM.MAM_ITEMS I
         WHERE I.ITEM_ID = RX1.ITEM_ITEM_ID) AS ITEM
      ,S1.COD_SERIAL_NUMBER_MSER
      ,Z.*
  FROM MAM.MAM_TRANSACTION_SERIAL_NUMBERS
       --
        Z
 INNER JOIN MAM.MAM_RCV_TRANSACTIONS RX1
    ON Z.MTRAN_MATERIAL_TRANSACTION_ID = RX1.MTRAN_MATERIAL_TRANSACTION_ID
 INNER JOIN MAM.MAM_SERIAL_NUMBERS S1
    ON Z.MSER_SERIAL_NUMBER_ID = S1.SERIAL_NUMBER_ID
 WHERE RX1.RCV_TRANSACTION_ID
      --
       IN ( --
           SELECT RCV_TRANSACTION_ID
             FROM (
                   --
                    ( --
                     SELECT RSX.NUM_SERIAL_MRCVS
                            ,RSX.MRCV_RCV_TRANSACTION_ID AS RCV_TRANSACTION_ID
                            ,RSX.ITEM_ITEM_ID
                       FROM MAM.MAM_RCV_SERIAL_TRANSACTIONS RSX
                     MINUS
                     SELECT S.COD_SERIAL_NUMBER_MSER AS NUM_SERIAL_MRCVS
                            ,RX.RCV_TRANSACTION_ID
                            ,RX.ITEM_ITEM_ID
                       FROM MAM.MAM_RCV_TRANSACTIONS RX
                      INNER JOIN MAM.MAM_TRANSACTION_SERIAL_NUMBERS XS
                         ON RX.MTRAN_MATERIAL_TRANSACTION_ID =
                            XS.MTRAN_MATERIAL_TRANSACTION_ID
                      INNER JOIN MAM.MAM_SERIAL_NUMBERS S
                         ON XS.MSER_SERIAL_NUMBER_ID = S.SERIAL_NUMBER_ID
                     --
                     )
                   --
                   )
           --
           )
       AND EXISTS
 (SELECT NULL
          FROM MAM.MAM_ITEMS I
         WHERE I.ITEM_ID = RX1.ITEM_ITEM_ID
               AND (I.COD_ITEM = &COD_ITEM OR &COD_ITEM IS NULL)
               AND NVL(I.COD_SERIAL_NUMBER_CONTROL_ITEM, 0) = 1)
 ORDER BY 1 DESC, 3
