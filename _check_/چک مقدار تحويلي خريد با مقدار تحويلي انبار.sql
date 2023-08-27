
SELECT OP.QTY_DLV_PUROP
      ,(SELECT SUM(RX1.QTY_PRIMARY_MRCV + NVL(RXC1.QTY_PRIMARY_MRCV, 0)) AS QTY_DLV
         FROM MAM.MAM_RCV_TRANSACTIONS RX1
         LEFT OUTER JOIN ( --
                         SELECT RXC11.PARENT_TRANSACTION_ID_MRCV
                                ,SUM(RXC11.QTY_PRIMARY_MRCV) AS QTY_PRIMARY_MRCV
                           FROM MAM.MAM_RCV_TRANSACTIONS RXC11
                          WHERE LKP_TYP_TRANSACTION_MRCV = 'Correct'
                          GROUP BY RXC11.PARENT_TRANSACTION_ID_MRCV
                         --
                         ) RXC1
           ON RXC1.PARENT_TRANSACTION_ID_MRCV = RX1.RCV_TRANSACTION_ID
        WHERE RX1.LKP_TYP_TRANSACTION_MRCV = 'Deliver'
              AND RX1.PUROP_PUROP_ID = OP.PUROP_ID
        GROUP BY RX1.PUROP_PUROP_ID)
      ,OP.QTY_CMM_DLV_PUROP
      ,(SELECT SUM(RX1.QTY_MRCV + NVL(RXC1.QTY_MRCV, 0)) AS QTY_DLV
         FROM MAM.MAM_RCV_TRANSACTIONS RX1
         LEFT OUTER JOIN ( --
                         SELECT RXC11.PARENT_TRANSACTION_ID_MRCV
                                ,SUM(RXC11.QTY_MRCV) AS QTY_MRCV
                           FROM MAM.MAM_RCV_TRANSACTIONS RXC11
                          WHERE LKP_TYP_TRANSACTION_MRCV = 'Correct'
                          GROUP BY RXC11.PARENT_TRANSACTION_ID_MRCV
                         --
                         ) RXC1
           ON RXC1.PARENT_TRANSACTION_ID_MRCV = RX1.RCV_TRANSACTION_ID
        WHERE RX1.LKP_TYP_TRANSACTION_MRCV = 'Deliver'
              AND RX1.PUROP_PUROP_ID = OP.PUROP_ID
        GROUP BY RX1.PUROP_PUROP_ID)

  FROM PUR.PUR_ORDER_POSITIONS OP
 WHERE EXISTS ( --
        SELECT NULL
          FROM PUR.PUR_ORDERS O
         WHERE OP.PUROR_ORDER_ID = O.ORDER_ID
               AND O.NUM_MDF_PUROR = 0
               AND O.NUM_PGV_PUROR = &NUM_PGV_PUROR
        --
        )
       AND EXISTS
 (SELECT 1
          FROM ( --
                SELECT SUM(RX2.QTY_PRIMARY_MRCV -
                            NVL(RXC2.QTY_PRIMARY_MRCV, 0)) AS QTY_DLV
                       ,RX2.PUROP_PUROP_ID
                  FROM MAM.MAM_RCV_TRANSACTIONS RX2
                  LEFT OUTER JOIN ( --
                                   SELECT PARENT_TRANSACTION_ID_MRCV
                                          ,SUM(RXC11.QTY_PRIMARY_MRCV) AS QTY_PRIMARY_MRCV
                                     FROM MAM.MAM_RCV_TRANSACTIONS RXC11
                                    WHERE LKP_TYP_TRANSACTION_MRCV = 'Correct'
                                    GROUP BY RXC11.PARENT_TRANSACTION_ID_MRCV
                                   --
                                   ) RXC2
                    ON RXC2.PARENT_TRANSACTION_ID_MRCV =
                       RX2.RCV_TRANSACTION_ID
                 WHERE RX2.LKP_TYP_TRANSACTION_MRCV = 'Deliver'
                 GROUP BY RX2.PUROP_PUROP_ID
                --
                --
                ) SQ
        
         WHERE OP.PUROP_ID = SQ.PUROP_PUROP_ID
        --
        )
       AND
      --OP.QTY_DLV_PUROP 
       OP.QTY_CMM_DLV_PUROP !=
      
       (SELECT CAST( --SUM(RX3.QTY_PRIMARY_MRCV + NVL(RXC3.QTY_PRIMARY_MRCV, 0))
                    SUM(RX3.QTY_MRCV + NVL(RXC3.QTY_MRCV, 0))
                    --
                     AS NUMBER(20, 3)) AS QTY_DLV
          FROM MAM.MAM_RCV_TRANSACTIONS RX3
          LEFT OUTER JOIN (
                          --
                          SELECT PARENT_TRANSACTION_ID_MRCV
                                 ,SUM(RXC33.QTY_PRIMARY_MRCV) AS QTY_PRIMARY_MRCV
                                 ,SUM(RXC33.QTY_MRCV) AS QTY_MRCV
                            FROM MAM.MAM_RCV_TRANSACTIONS RXC33
                           WHERE LKP_TYP_TRANSACTION_MRCV = 'Correct'
                           GROUP BY RXC33.PARENT_TRANSACTION_ID_MRCV
                          --
                          ) RXC3
            ON RXC3.PARENT_TRANSACTION_ID_MRCV = RX3.RCV_TRANSACTION_ID
         WHERE RX3.LKP_TYP_TRANSACTION_MRCV = 'Deliver'
               AND RX3.PUROP_PUROP_ID = OP.PUROP_ID
         GROUP BY RX3.PUROP_PUROP_ID)
/*         
       AND EXISTS
 (SELECT 1
          FROM MAM.MAM_ITEMS I4
         INNER JOIN PUR.PUR_REQUEST_POSITIONS RP4
            ON I4.ITEM_ID = RP4.ITEM_ITEM_ID
         INNER JOIN PUR.PUR_ORDER_POSITIONS OP4
            ON RP4.PURRP_ID = OP4.PURRP_PURRP_ID
         WHERE OP4.PUROP_ID = OP.PUROP_ID
               AND I4.MUOM_MEASUREMENT_UNIT_ID = 760)
*/
