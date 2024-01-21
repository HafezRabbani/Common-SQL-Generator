SELECT PN.PACKING_NUMBER_ID
      ,PN.PAKLS_PACKING_LIST_ID
      ,APPS.MAM_ITEMS_CTRL_PKG.GET_DESCRIPTION(P_ITEM_ID => (select distinct rx.item_item_id from mam.mam_rcv_transactions rx where rx.paknr_packing_number_id=pn.packing_number_id)) AS ITEM
      ,(SELECT O.NUM_PGV_PUROR
          FROM PUR.PUR_ORDERS O
         INNER JOIN PUR.PUR_ORDER_POSITIONS OP
            ON O.ORDER_ID = OP.PUROR_ORDER_ID
         WHERE OP.PUROP_ID = PN.PUROP_PUROP_ID) AS NUM_PGV_PUROR_PN
      ,(SELECT O.NUM_PGV_PUROR
          FROM PUA.PUA_WAYBILLS W
         INNER JOIN PUR.PUR_ORDERS O
            ON W.PUROR_ORDER_ID = O.ORDER_ID
         WHERE W.WAYBILL_ID = PN.WYBIL_WAYBILL_ID) AS NUM_PGV_PUROR_WAYBILL
      ,(SELECT DISTINCT O.NUM_PGV_PUROR
          FROM MAM.MAM_RCV_TRANSACTIONS RX
         INNER JOIN PUR.PUR_ORDER_POSITIONS OP
            ON RX.PUROP_PUROP_ID = OP.PUROP_ID
         INNER JOIN PUR.PUR_ORDERS O
            ON O.ORDER_ID = OP.PUROR_ORDER_ID
         WHERE RX.PAKNR_PACKING_NUMBER_ID = PN.PACKING_NUMBER_ID) AS NUM_PGV_PUROR_RX
      ,(SELECT W.NUM_WYB_GOV_WYBIL
          FROM PUA.PUA_WAYBILLS W
         WHERE W.WAYBILL_ID = PN.WYBIL_WAYBILL_ID) AS NUM_WYB_GOV_WYBIL
      ,(SELECT OP.NUM_POS_PUROP
          FROM PUR.PUR_ORDER_POSITIONS OP
         WHERE OP.PUROP_ID = PN.PUROP_PUROP_ID) AS NUM_POS_PUROP
      ,(SELECT RP.ID_PRODUCT_PURRP
          FROM PUR.PUR_ORDER_POSITIONS OP
         INNER JOIN PUR.PUR_REQUEST_POSITIONS RP
            ON OP.PURRP_PURRP_ID = RP.PURRP_ID
         WHERE OP.PUROP_ID = PN.PUROP_PUROP_ID) AS ID_PRODUCT_PURRP
      ,PN.TKS_PACK_PAKNR
      ,PN.WID_PACK_PAKNR
      ,PN.COD_QLY_EXT_PAKNR
      ,PN.NUM_EXT_COIL_PAKNR
      ,PN.MUOM_MEASUREMENT_UNIT_ID
      ,PN.PAKLS_PACKING_LIST_ID
      ,PN.NUM_INTERNAL_COIL_PAKNR
      ,PN.PUROP_PUROP_ID
      ,PN.ITEM_ITEM_ID
      ,PN.VAL_DIA_EXT_PAKNR
      ,PN.VAL_DIA_INT_PAKNR
      ,PN.COD_QLY_INT_PAKNR
      ,PN.NUM_REF_PAKNR
      ,PN.NUM_POS_PAKNR
      ,PN.LKP_COD_INSPECTION_PAKNR
      ,APPS.APP_FND_LOOKUP_PKG.GET_FARSI_MEANING_FUN(UPPER('PUR_PACKING_NUMBERS'), UPPER('LKP_COD_INSPECTION_PAKNR'), PN.LKP_COD_INSPECTION_PAKNR) AS LKP_COD_INSPECTION_PAKNR_DES
      ,PN.COD_LOCATOR_PAKNR
      ,PN.WYBIL_WAYBILL_ID
      ,(SELECT A3.NUM_WYB_GOV_WYBIL
          FROM PUA.PUA_WAYBILLS A3
         WHERE PN.WYBIL_WAYBILL_ID = A3.WAYBILL_ID) AS NUM_WYB_GOV_WYBIL
      ,PN.QTY_WEI_SUPPLIER_PAKNR
      ,PN.QTY_WEI_PACK_PACKNR
      ,PN.LKP_TYP_PACKING_PAKNR
      ,APPS.APP_FND_LOOKUP_PKG.GET_FARSI_MEANING_FUN(UPPER('PUR_PACKING_NUMBERS'), UPPER('LKP_TYP_PACKING_PAKNR'), PN.LKP_TYP_PACKING_PAKNR) AS LKP_TYP_PACKING_PAKNR_DES
      ,PN.COD_ORD_ORDHE_PAKNR
      ,PN.TYP_DB_ORDHE_PAKNR
      ,PN.NUM_ITEM_ORDIT_PAKNR
  FROM --
        PUR.PUR_PACKING_NUMBERS
       --  JRN.PUR_PACKING_NUMBERS_JRN
       --
         PN
 WHERE 1 = 1
      --       AND PN.COD_ORD_ORDHE_PAKNR = &COD_ORD_ORDHE_PAKNR
      --       AND PN.NUM_EXT_COIL_PAKNR IN (&NUM_EXT_COIL_PAKNR)
       AND PN.NUM_INTERNAL_COIL_PAKNR IN (&NUM_INTERNAL_COIL_PAKNR)
/*
       AND
       PN.PUROP_PUROP_ID IN ( --
                             SELECT OP.PUROP_ID
                               FROM PUR.PUR_ORDER_POSITIONS OP
                              INNER JOIN PUR.PUR_ORDERS O
                                 ON OP.PUROR_ORDER_ID = O.ORDER_ID
                                    AND O.NUM_MDF_PUROR = 0
                                   --AND OP.NUM_POS_PUROP LIKE '&NUM_POS_PUROP'
                                    AND O.NUM_PGV_PUROR LIKE '&NUM_PGV_PUROR'
                             --
                             )
*/
/*      
       AND EXISTS ( --
        SELECT NULL
          FROM PUA.PUA_WAYBILLS W
         INNER JOIN PUR.PUR_ORDERS O
            ON W.PUROR_ORDER_ID = O.ORDER_ID
         WHERE W.WAYBILL_ID = PN.WYBIL_WAYBILL_ID
              --       AND W.NUM_WYB_GOV_WYBIL IN (&NUM_WYB_GOV_WYBIL)
               AND O.NUM_PGV_PUROR = '&NUM_PGV_PUROR'
        --
        )
*/
--   FOR UPDATE
