SELECT O.ORDER_ID
      ,O.NUM_PGV_PUROR
      ,O.NUM_MDF_PUROR
      ,O.LKP_TYP_ORD_PUROR
      ,OP.PUROP_ID
      ,OP.NUM_POS_PUROP
      ,OP.QTY_CMM_DLV_PUROP
      ,OP.QTY_DLV_PUROP
      ,RP.PURRP_ID
      ,I.ITEM_ID
      ,U.MEASUREMENT_UNIT_ID
      ,I.COD_ITEM
      ,I.DES_ITEM
      ,Z2.RCV_TRANSACTION_ID
      ,Z2.PARENT_TRANSACTION_ID_MRCV
      ,Z2.QTY_PRIMARY_MRCV
      ,Z2.P
      ,Z2.LKP_TYP_TRANSACTION_MRCV
      ,Z2.NUM_RECEIPT_AP_MRCV
      
  FROM PUR.PUR_ORDERS O
 INNER JOIN PUR.PUR_ORDER_POSITIONS OP
    ON O.ORDER_ID = OP.PUROR_ORDER_ID
 INNER JOIN PUR.PUR_REQUEST_POSITIONS RP
    ON OP.PURRP_PURRP_ID = RP.PURRP_ID
 INNER JOIN MAM.MAM_ITEMS I
    ON RP.ITEM_ITEM_ID = I.ITEM_ID
 INNER JOIN MAM.MAM_MEASUREMENT_UNITS U
    ON I.MUOM_MEASUREMENT_UNIT_ID = U.MEASUREMENT_UNIT_ID
  LEFT OUTER JOIN ( --
                   SELECT Z.LKP_TYP_TRANSACTION_MRCV || CASE
                             WHEN Z.P1 IS NOT NULL THEN
                              ' OF ' || Z.Q1 || ' ' || Z.P1
                           END AS P
                          ,Z.*
                     FROM ( --
                            SELECT (SELECT RX1.LKP_TYP_TRANSACTION_MRCV
                                       FROM MAM.MAM_RCV_TRANSACTIONS RX1
                                      WHERE RX1.RCV_TRANSACTION_ID =
                                            RX.PARENT_TRANSACTION_ID_MRCV) AS P1
                                   ,(SELECT RX1.QTY_PRIMARY_MRCV
                                       FROM MAM.MAM_RCV_TRANSACTIONS RX1
                                      WHERE RX1.RCV_TRANSACTION_ID =
                                            RX.PARENT_TRANSACTION_ID_MRCV) AS Q1
                                   ,RX.*
                              FROM MAM.MAM_RCV_TRANSACTIONS RX
                            --
                            ) Z
                   --
                   ) Z2
    ON Z2.PUROP_PUROP_ID = OP.PUROP_ID
 WHERE 1 = 1
       AND O.NUM_MDF_PUROR = 0
       AND O.NUM_PGV_PUROR = &NUM_PGV_PUROR
--       AND OP.PUROP_ID = &PUROP_ID
--       AND Z2.NUM_RECEIPT_AP_MRCV = &NUM_RECEIPT_AP_MRCV
/*
AND TRUNC(Z2.DAT_TRANSACTION_MRCV) >=
TO_DATE('&FROM_DATE', 'YYYY/MM/DD', 'NLS_CALENDAR=PERSIAN')
AND TRUNC(Z2.DAT_TRANSACTION_MRCV) <=
TO_DATE('&TO_DATE', 'YYYY/MM/DD', 'NLS_CALENDAR=PERSIAN')
*/
 ORDER BY Z2.ITEM_ITEM_ID
         ,Z2.RCV_TRANSACTION_ID
