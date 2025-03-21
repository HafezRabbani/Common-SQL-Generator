SELECT (SELECT O.NUM_PGV_PUROR
          FROM PUR.PUR_ORDERS O
         INNER JOIN PUR.PUR_ORDER_POSITIONS OP
            ON O.ORDER_ID = OP.PUROR_ORDER_ID
         WHERE OP.PUROP_ID = RX.PUROP_PUROP_ID) AS NUM_PGV_PUROR
      ,(SELECT I.COD_ITEM
          FROM MAM.MAM_ITEMS I
         WHERE I.ITEM_ID = RX.ITEM_ITEM_ID) I
      ,(SELECT U.NAM_UNIT_OF_MEASURE_MUOM
          FROM MAM.MAM_ITEMS I
         INNER JOIN MAM.MAM_MEASUREMENT_UNITS U
            ON I.MUOM_MEASUREMENT_UNIT_ID = U.MEASUREMENT_UNIT_ID
         WHERE I.ITEM_ID = RX.ITEM_ITEM_ID) NAM_UNIT
      ,RX.LKP_COD_INSPECTION_STATUS_MRCV
      ,APPS.APP_FND_LOOKUP_PKG.GET_FARSI_MEANING_FUN(UPPER('MAM_RCV_TRANSACTIONS')
                                                    ,UPPER('LKP_COD_INSPECTION_STATUS_MRCV')
                                                    ,RX.LKP_COD_INSPECTION_STATUS_MRCV) AS LKP_COD_INSPECTION_STATUS_DES
      ,TO_CHAR(RX.DAT_TRANSACTION_MRCV
              ,'YYYY/MM/DD HH24:MI:SS'
              ,'NLS_CALENDAR=PERSIAN') D
      ,(CASE
         WHEN 1 = 0 OR RX.ORPYDORPYM_NUM_ORD_PYM_ORPYM IS NOT NULL OR
              RX.ORPYD_NUM_SEQ_ORPYD IS NOT NULL
             --OR RX.DAT_STL_MRCV IS NOT NULL
              OR RX.SPINV_NUM_SRL_SPINV IS NOT NULL THEN
          'Don''t Change!'
       END) AS ERR
      ,RX.NUM_RECEIPT_AP_MRCV
      ,RX.LKP_TYP_TRANSACTION_MRCV
      ,RX.LKP_TYP_TRANSACTION_MRCV || ' ' ||
       (SELECT RX0.LKP_TYP_TRANSACTION_MRCV
          FROM MAM.MAM_RCV_TRANSACTIONS RX0
         WHERE RX0.RCV_TRANSACTION_ID = RX.PARENT_TRANSACTION_ID_MRCV) AS LKP_TYP
      ,RX.PUROP_PUROP_ID
      ,RX.RCV_TRANSACTION_ID
      ,RX.PARENT_TRANSACTION_ID_MRCV
      ,RX.QTY_PRIMARY_MRCV
      ,RX.QTY_MRCV
      ,RX.MTRAN_MATERIAL_TRANSACTION_ID
      ,RX.PCN_FALL_MRCV
      ,RX.PCN_FALL_AMOUNT_MRCV
      ,RX.PAKNR_PACKING_NUMBER_ID
      ,RX.BUSUN_COD_BUSUN
      ,RX.SPINV_NUM_SRL_SPINV
      ,RX.ORPYD_NUM_SEQ_ORPYD
       --      ,RX.ORPYDORPYM_NUM_ORD_PYM_ORPYM
       --      ,RX.DLVNH_DELIVERY_NOTE_ID
      ,RX.COD_REVISION_MRCV
      ,RX.QTY_BILLED_MRCV
      ,RX.ITEM_ITEM_ID
      ,RX.CCNTR_COD_CC_CCNTR
      ,RX.MSINV_NAM_SUB_INVENTORY_MSINV
      ,RX.MSLOC_SUB_INVENTORY_LOCATOR_ID
      ,RX.MTREA_TRANSACTION_REASON_ID
      ,RX.DAT_TRANSACTION_MRCV
      ,RX.AMN_ACTUAL_MRCV
      ,RX.AMN_STIMATE_MRCV
      ,RX.DAT_STL_MRCV
      ,RX.LKP_COD_DESTINATION_TYPE_MRCV
      ,RX.LKP_COD_FCT_MRCV
      ,RX.LKP_COD_SOURCE_DOCUMENT_MRCV
      ,RX.LKP_ROUTING_RECEIPT_MRCV
      ,RX.NAM_UNIT_OF_MEASURE_MRCV
      ,RX.NAM_UNIT_OF_MEASURE_PRIMARY_MR
      ,RX.NUM_RECEIPT_INV_MRCV
      ,RX.NUM_RMA_REFERENCE_MRCV
      ,RX.TXT_COMMENT_MRCV
      ,RX.CREATE_BY_APP_USER
      ,(SELECT FU.NAM_USER_USRS
          FROM FND.FND_USERS FU
         WHERE FU.IDE_USER_USRS = RX.CREATE_BY_APP_USER) AS IDE_USER_USRS
  FROM --
        MAM.MAM_RCV_TRANSACTIONS
       --APPS.MAM_RCV_TRANSACTIONS_JRN 
       --jrn.MAM_RCV_TRANSACTIONS_JRN 
       --
         RX
 WHERE 1 = 1
      --             AND RX.PUROP_PUROP_ID = &PUROP_ID
   AND RX.NUM_RECEIPT_AP_MRCV IN (&NUM_RECEIPT_AP_MRCV)
/*
       AND RX.ITEM_ITEM_ID =
       (SELECT ITEM_ID
              FROM MAM.MAM_ITEMS I
             WHERE I.COD_ITEM = TRIM('&COD_ITEM'))
*/
/*      
       AND EXISTS (SELECT NULL
          FROM PUR.PUR_ORDER_POSITIONS OP
         INNER JOIN PUR.PUR_ORDERS O
            ON OP.PUROR_ORDER_ID = O.ORDER_ID
         WHERE RX.PUROP_PUROP_ID = OP.PUROP_ID
               AND O.NUM_PGV_PUROR = &NUM_PGV_PUROR)
*/
-- AND RX.MTRAN_MATERIAL_TRANSACTION_ID IN (&MTRAN_MATERIAL_TRANSACTION_ID)
--       AND RX.RCV_TRANSACTION_ID = &RCV_TRANSACTION_ID
--       AND EXISTS (SELECT NULL FROM PUA.PUA_WAYBILL_ITEMS WI WHERE RX.NUM_RECEIPT_AP_MRCV = WI.NUM_RECEIPT_INV_WYBIT)
--       AND RX.PUROP_PUROP_ID = &OP_ID
 ORDER BY RX.NUM_RECEIPT_AP_MRCV
         ,RX.ITEM_ITEM_ID
         ,RX.DAT_TRANSACTION_MRCV
         ,RX.RCV_TRANSACTION_ID
   FOR UPDATE
