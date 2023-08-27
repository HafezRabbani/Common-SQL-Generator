SELECT RX.QTY_PRIMARY_MRCV
      ,RX.LKP_ROUTING_RECEIPT_MRCV
      ,RX.LKP_TYP_TRANSACTION_MRCV
      ,SUM(RX.QTY_PRIMARY_MRCV) OVER(PARTITION BY RX.ITEM_ITEM_ID, RX.LKP_TYP_TRANSACTION_MRCV) AS SQP
      ,SUM(RX.QTY_MRCV) OVER(PARTITION BY RX.ITEM_ITEM_ID, RX.LKP_TYP_TRANSACTION_MRCV) AS SQ
      ,RX.*
  FROM MAM.MAM_RCV_TRANSACTIONS RX
 WHERE EXISTS (SELECT 1
          FROM PUR.PUR_ORDERS O
         INNER JOIN PUR.PUR_ORDER_POSITIONS OP
            ON O.ORDER_ID = OP.PUROR_ORDER_ID
         WHERE O.NUM_PGV_PUROR = TRIM(&NUM_PGV_PUROR)
               AND OP.PUROP_ID = RX.PUROP_PUROP_ID);
--Ã“∆Ì«  —”Ìœ Â«Ì ”›«—‘
SELECT RX.ITEM_ITEM_ID AS ITEM_ID
      ,RX.LKP_ROUTING_RECEIPT_MRCV
      ,RX.CCNTR_COD_CC_CCNTR AS CC
      ,RX.LKP_TYP_TRANSACTION_MRCV || CASE
         WHEN RX.LKP_TYP_TRANSACTION_MRCV = 'Correct' THEN
          ' ' ||
          (SELECT RX1.LKP_TYP_TRANSACTION_MRCV
             FROM MAM.MAM_RCV_TRANSACTIONS RX1
            WHERE RX1.RCV_TRANSACTION_ID = RX.PARENT_TRANSACTION_ID_MRCV)
       END AS LKP
      ,RX.RCV_TRANSACTION_ID AS ID
      ,RX.PARENT_TRANSACTION_ID_MRCV AS PARENT
      ,RX.NUM_RECEIPT_AP_MRCV AS NUM_RECEIPT
      ,RX.QTY_PRIMARY_MRCV
      ,RX.*
  FROM MAM.MAM_RCV_TRANSACTIONS RX
 WHERE EXISTS (SELECT 1
          FROM PUR.PUR_ORDERS O
         INNER JOIN PUR.PUR_ORDER_POSITIONS OP
            ON O.ORDER_ID = OP.PUROR_ORDER_ID
         WHERE O.NUM_PGV_PUROR = TRIM(&NUM_PGV_PUROR)
               AND OP.PUROP_ID = RX.PUROP_PUROP_ID)
 ORDER BY RX.ITEM_ITEM_ID
         ,RX.CCNTR_COD_CC_CCNTR
         ,NVL((SELECT NVL(GP.RCV_TRANSACTION_ID, F.RCV_TRANSACTION_ID)
                FROM MAM.MAM_RCV_TRANSACTIONS GS
                LEFT OUTER JOIN MAM.MAM_RCV_TRANSACTIONS F
                  ON GS.PARENT_TRANSACTION_ID_MRCV = F.RCV_TRANSACTION_ID
                LEFT OUTER JOIN MAM.MAM_RCV_TRANSACTIONS GP
                  ON F.PARENT_TRANSACTION_ID_MRCV = GP.RCV_TRANSACTION_ID
               WHERE GS.RCV_TRANSACTION_ID = RX.RCV_TRANSACTION_ID)
             ,RX.RCV_TRANSACTION_ID)
         ,RX.RCV_TRANSACTION_ID;
-------
SELECT SUM(Z1.QTY_PRIMARY_MRCV) OVER(PARTITION BY Z1.NUM_RECEIPT, Z1.ITEM_ID, Z1.LKP_GRP) AS RECEIPT_STEP_SUM
      ,Z1.ITEM_ID
      ,Z1.LKP_ROUTING_RECEIPT_MRCV
      ,Z1.CC
      ,Z1.LKP
      ,Z1.ID
      ,Z1.PARENT
      ,Z1.NUM_RECEIPT
      ,Z1.QTY_PRIMARY_MRCV
  FROM ( --
        SELECT CASE
                  WHEN LKP IN ('Receipt', 'Correct Receipt') THEN
                   'Pure Receipt'
                  WHEN LKP IN ('Inspect', 'Correct Inspect') THEN
                   'Pure Inspect'
                  WHEN LKP IN ('Deliver', 'Correct Deliver') THEN
                   'Pure Deliver'
                END AS LKP_GRP
               ,ZZ.*
          FROM ( --
                 SELECT RX.ITEM_ITEM_ID AS ITEM_ID
                        ,RX.LKP_ROUTING_RECEIPT_MRCV
                        ,RX.CCNTR_COD_CC_CCNTR AS CC
                        ,RX.LKP_TYP_TRANSACTION_MRCV || CASE
                           WHEN RX.LKP_TYP_TRANSACTION_MRCV = 'Correct' THEN
                            ' ' || (SELECT RX1.LKP_TYP_TRANSACTION_MRCV
                                      FROM MAM.MAM_RCV_TRANSACTIONS RX1
                                     WHERE RX1.RCV_TRANSACTION_ID =
                                           RX.PARENT_TRANSACTION_ID_MRCV)
                         END AS LKP
                        ,RX.RCV_TRANSACTION_ID AS ID
                        ,RX.PARENT_TRANSACTION_ID_MRCV AS PARENT
                        ,RX.NUM_RECEIPT_AP_MRCV AS NUM_RECEIPT
                        ,RX.QTY_PRIMARY_MRCV
                 --,RX.*
                   FROM MAM.MAM_RCV_TRANSACTIONS RX
                  WHERE EXISTS
                  (SELECT 1
                           FROM PUR.PUR_ORDERS O
                          INNER JOIN PUR.PUR_ORDER_POSITIONS OP
                             ON O.ORDER_ID = OP.PUROR_ORDER_ID
                          WHERE O.NUM_PGV_PUROR = TRIM(&NUM_PGV_PUROR)
                                AND OP.PUROP_ID = RX.PUROP_PUROP_ID) --
                 ) ZZ
        --
        ) Z1
 ORDER BY ITEM_ID
         ,CC
         ,NVL((SELECT NVL(GP.RCV_TRANSACTION_ID, F.RCV_TRANSACTION_ID)
                FROM MAM.MAM_RCV_TRANSACTIONS GS
                LEFT OUTER JOIN MAM.MAM_RCV_TRANSACTIONS F
                  ON GS.PARENT_TRANSACTION_ID_MRCV = F.RCV_TRANSACTION_ID
                LEFT OUTER JOIN MAM.MAM_RCV_TRANSACTIONS GP
                  ON F.PARENT_TRANSACTION_ID_MRCV = GP.RCV_TRANSACTION_ID
               WHERE GS.RCV_TRANSACTION_ID = ID)
             ,ID)
         ,ID;
SELECT DISTINCT SUM(CASE
                      WHEN LKP_GRP = 1 THEN
                       RECEIPT_STEP_SUM
                      WHEN LKP_GRP = 3 THEN
                       -RECEIPT_STEP_SUM
                    END) OVER(PARTITION BY ITEM_ID, NUM_RECEIPT) AS PURE_ITEM_RECEIPT_REMAINING
               ,SUM(CASE
                      WHEN LKP_GRP = 3 THEN
                       RECEIPT_STEP_SUM
                    END) OVER(PARTITION BY ITEM_ID, NUM_RECEIPT) AS PURE_ITEM_RECEIPT_DELIVERED
               ,RECEIPT_STEP_SUM
               ,ITEM_ID
               ,LKP_GRP_DES
               ,NUM_RECEIPT
  FROM ( --
        SELECT SUM(Z1.QTY_PRIMARY_MRCV) OVER(PARTITION BY Z1.NUM_RECEIPT, Z1.ITEM_ID, Z1.LKP_GRP) AS RECEIPT_STEP_SUM
               ,Z1.ITEM_ID
               ,Z1.LKP_ROUTING_RECEIPT_MRCV
               ,Z1.CC
               ,Z1.LKP
               ,Z1.ID
               ,Z1.PARENT
               ,Z1.NUM_RECEIPT
               ,Z1.QTY_PRIMARY_MRCV
               ,Z1.LKP_GRP_DES
               ,Z1.LKP_GRP
          FROM ( --
                 SELECT CASE
                           WHEN LKP IN ('Receipt', 'Correct Receipt') THEN
                            'Pure Receipt'
                           WHEN LKP IN ('Inspect', 'Correct Inspect') THEN
                            'Pure Inspect'
                           WHEN LKP IN ('Deliver', 'Correct Deliver') THEN
                            'Pure Deliver'
                         END AS LKP_GRP_DES
                        ,CASE
                           WHEN LKP IN ('Receipt', 'Correct Receipt') THEN
                            1
                           WHEN LKP IN ('Inspect', 'Correct Inspect') THEN
                            2
                           WHEN LKP IN ('Deliver', 'Correct Deliver') THEN
                            3
                         END AS LKP_GRP
                         
                        ,ZZ.*
                   FROM ( --
                          SELECT RX.ITEM_ITEM_ID AS ITEM_ID
                                 ,RX.LKP_ROUTING_RECEIPT_MRCV
                                 ,RX.CCNTR_COD_CC_CCNTR AS CC
                                 ,RX.LKP_TYP_TRANSACTION_MRCV || CASE
                                    WHEN RX.LKP_TYP_TRANSACTION_MRCV = 'Correct' THEN
                                     ' ' ||
                                     (SELECT RX1.LKP_TYP_TRANSACTION_MRCV
                                        FROM MAM.MAM_RCV_TRANSACTIONS RX1
                                       WHERE RX1.RCV_TRANSACTION_ID =
                                             RX.PARENT_TRANSACTION_ID_MRCV)
                                  END AS LKP
                                 ,RX.RCV_TRANSACTION_ID AS ID
                                 ,RX.PARENT_TRANSACTION_ID_MRCV AS PARENT
                                 ,RX.NUM_RECEIPT_AP_MRCV AS NUM_RECEIPT
                                 ,RX.QTY_PRIMARY_MRCV
                          --,RX.*
                            FROM MAM.MAM_RCV_TRANSACTIONS RX
                           WHERE EXISTS
                           (SELECT 1
                                    FROM PUR.PUR_ORDERS O
                                   INNER JOIN PUR.PUR_ORDER_POSITIONS OP
                                      ON O.ORDER_ID = OP.PUROR_ORDER_ID
                                   WHERE O.NUM_PGV_PUROR = TRIM(&NUM_PGV_PUROR)
                                         AND OP.PUROP_ID = RX.PUROP_PUROP_ID) --
                          ) ZZ
                 --
                 
                 ) Z1
        --
        )
 ORDER BY NUM_RECEIPT;
