SELECT O.ORDER_ID
      ,O.NUM_PGV_PUROR
      ,O.NUM_MDF_PUROR
      ,O.LKP_TYP_ORD_PUROR || ': ' ||
       APPS.APP_FND_LOOKUP_PKG.GET_FARSI_MEANING_FUN(UPPER('PUR_ORDERS')
                                                    ,UPPER('LKP_TYP_ORD_PUROR')
                                                    ,O.LKP_TYP_ORD_PUROR) AS TYP_ORD
      ,O.LKP_COD_STEP_PUROR || ': ' ||
       APPS.APP_FND_LOOKUP_PKG.GET_FARSI_MEANING_FUN(UPPER('PUR_ORDERS')
                                                    ,UPPER('LKP_COD_STEP_PUROR')
                                                    ,O.LKP_COD_STEP_PUROR) AS STEP
      ,OP.PUROP_ID
      ,OP.NUM_POS_PUROP
      ,OP.QTY_CMM_ORD_PUROP
      ,OP.QTY_CMM_DLV_PUROP
      ,OP.QTY_DLV_PUROP
      ,OP.MUOM_MEASUREMENT_UNIT_ID
      ,R.LKP_TYP_REQ_PURRQ || ': ' ||
       APPS.APP_FND_LOOKUP_PKG.GET_FARSI_MEANING_FUN(UPPER('PUR_REQUESTS')
                                                    ,UPPER('LKP_TYP_REQ_PURRQ')
                                                    ,R.LKP_TYP_REQ_PURRQ) AS LKP_TYP_REQ_PURRQ
      ,RP.PURRP_ID
      ,R.LKP_TYP_DEBT_PURRQ || ': ' ||
       APPS.APP_FND_LOOKUP_PKG.GET_FARSI_MEANING_FUN(UPPER('PUR_REQUESTS')
                                                    ,UPPER('LKP_TYP_DEBT_PURRQ')
                                                    ,R.LKP_TYP_DEBT_PURRQ) AS LKP_TYP_DEBT_PURRQ
      ,I.ITEM_ID
      ,U.MEASUREMENT_UNIT_ID AS U_ID
      ,I.COD_ITEM
      ,I.DES_ITEM
      ,I.LKP_STA_INVENTORY_ITEM || ': ' ||
       APPS.APP_FND_LOOKUP_PKG.GET_FARSI_MEANING_FUN(UPPER('mam_items')
                                                    ,UPPER('LKP_STA_INVENTORY_ITEM')
                                                    ,I.LKP_STA_INVENTORY_ITEM) AS LKP_STA_INVENTORY_ITEM
      ,I.LKP_TYPE_WAY_RCV_ITEM || ': ' ||
       APPS.APP_FND_LOOKUP_PKG.GET_FARSI_MEANING_FUN(UPPER('mam_items')
                                                    ,UPPER('LKP_TYPE_WAY_RCV_ITEM')
                                                    ,I.LKP_TYPE_WAY_RCV_ITEM) AS LKP_TYPE_WAY_RCV_ITEM
      ,Z2.RCV_TRANSACTION_ID AS RX_ID
      ,Z2.PARENT_TRANSACTION_ID_MRCV AS PARENT_ID
      ,Z2.QTY_PRIMARY_MRCV
      ,Z2.P
      ,Z2.LKP_TYP_TRANSACTION_MRCV || ': ' ||
       APPS.APP_FND_LOOKUP_PKG.GET_FARSI_MEANING_FUN(UPPER('mam_rcv_transactions')
                                                    ,UPPER('LKP_TYP_TRANSACTION_MRCV')
                                                    ,Z2.LKP_TYP_TRANSACTION_MRCV) AS
      ,Z2.NUM_RECEIPT_AP_MRCV
      ,Z2.MTRAN_MATERIAL_TRANSACTION_ID
  FROM PUR.PUR_ORDERS O
 INNER JOIN (SELECT OP1.*
               FROM PUR.PUR_ORDER_POSITIONS OP1
              WHERE OP1.NUM_MDF_PUROP = 0) OP
    ON O.ORDER_ID = OP.PUROR_ORDER_ID
 INNER JOIN PUR.PUR_REQUEST_POSITIONS RP
    ON OP.PURRP_PURRP_ID = RP.PURRP_ID
 INNER JOIN PUR.PUR_REQUESTS R
    ON RP.PURRQ_NUM_PGV_PURRQ = R.NUM_PGV_PURRQ
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
      --       AND O.NUM_PGV_PUROR = &NUM_PGV_PUROR
      --       AND OP.PUROP_ID = &PUROP_ID
       AND I.COD_ITEM = '&COD_ITEM'
--       AND Z2.NUM_RECEIPT_AP_MRCV = &NUM_RECEIPT_AP_MRCV
 ORDER BY NULL
         ,OP.NUM_POS_PUROP
         ,Z2.ITEM_ITEM_ID
         ,Z2.RCV_TRANSACTION_ID
