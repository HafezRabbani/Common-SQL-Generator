SELECT W.WAYBILL_ID
      ,W.NUM_WYB_GOV_WYBIL
      ,W.ORDHE_COD_ORD_ORDHE
      ,W.DAT_WYB_WYBIL
      ,TO_CHAR(W.DAT_WYB_WYBIL
              ,'YYYY/MM/DD HH24:MI:SS'
              ,'NLS_CALENDAR=PERSIAN') AS DAT_WYB_WYBIL_H
      ,W.GEPOS_GEOGRAPHIC_POSITION_ID
      ,W.NUM_CAR_WYBIL
      ,W.NAM_DRV_WYBIL
      ,W.NAM_CARRIER_WYBIL
      ,W.LKP_TYP_CAR_WYBIL
      ,W.DAT_ENTR_WYBIL
      ,TO_CHAR(W.DAT_ENTR_WYBIL
              ,'YYYY/MM/DD HH24:MI:SS'
              ,'NLS_CALENDAR=PERSIAN') AS DAT_ENTR_WYBIL_H
       /*
       ,APPS.APP_FND_LOOKUP_PKG.GET_FARSI_MEANING_FUN(UPPER('PUA_WAYBILLS')
                                                     ,UPPER('LKP_TYP_CAR_WYBIL')
                                                     ,W.LKP_TYP_CAR_WYBIL) AS LKP_TYP_CAR_WYBIL_DES
       */
      ,W.LKP_FLG_WYB_WYBIL
       /*
       ,APPS.APP_FND_LOOKUP_PKG.GET_FARSI_MEANING_FUN(UPPER('PUA_WAYBILLS')
                                                     ,UPPER('LKP_FLG_WYB_WYBIL')
                                                     ,W.LKP_FLG_WYB_WYBIL) AS LKP_FLG_WYB_WYBIL_DES
       */
      ,W.LKP_COD_PEN_WYBIL
       /*
       ,APPS.APP_FND_LOOKUP_PKG.GET_FARSI_MEANING_FUN(UPPER('PUA_WAYBILLS')
                                                     ,UPPER('LKP_COD_PEN_WYBIL')
                                                     ,W.LKP_COD_PEN_WYBIL) AS LKP_COD_PEN_WYBIL_DES
       */
      ,W.DES_WYB_WYBIL
      ,W.DAT_EXIT_WYBIL
       /*      ,TO_CHAR(W.DAT_EXIT_WYBIL
       ,'YYYY/MM/DD HH24:MI:SS'
       ,'NLS_CALENDAR=PERSIAN') AS DAT_EXIT_WYBIL_H
       */
      ,W.AMN_WYB_WYBIL
      ,W.AMN_PYM_WYB_WYBIL
      ,W.AMN_PEN_WYBIL
      ,W.AMN_OTH_WYBIL
      ,W.THPRT_COD_THPRT
      ,W.PUROR_ORDER_ID
      ,W.PURLC_NUM_LC_PURLC
      ,W.ACVOH_NUM_DCM_ACVOH
      ,W.ACVOH_DAT_DCM_ACVOH
      ,W.TYP_WYB_WYBIL
       --      ,W.NUM_TOZIN_WYBIL
       --      ,W.DAT_EXIT_CAR_WYBIL
       /*
       ,TO_CHAR(W.DAT_EXIT_CAR_WYBIL
               ,'YYYY/MM/DD HH24:MI:SS'
               ,'NLS_CALENDAR=PERSIAN') AS DAT_EXIT_CAR_WYBIL_H
       */
       --      ,W.DAT_QTY_CAR_WYBIL
       /*
       ,TO_CHAR(W.DAT_QTY_CAR_WYBIL
               ,'YYYY/MM/DD HH24:MI:SS'
               ,'NLS_CALENDAR=PERSIAN') AS DAT_QTY_CAR_WYBIL_H
       */
       --      ,W.DAT_QTY_CAR_ITEM_WYBIL
       /*      
       ,TO_CHAR(W.DAT_QTY_CAR_ITEM_WYBIL
               ,'YYYY/MM/DD HH24:MI:SS'
               ,'NLS_CALENDAR=PERSIAN') AS DAT_QTY_CAR_ITEM_WYBIL_H
       */
       --      ,W.DAT_EMTY_WYBIL
       /*
       ,TO_CHAR(W.DAT_EMTY_WYBIL
               ,'YYYY/MM/DD HH24:MI:SS'
               ,'NLS_CALENDAR=PERSIAN') AS DAT_EMTY_WYBIL_H
       */
       --      ,W.TEL_DRV_WYBIL
      ,W.NUM_BASCULE_OUT_WYBIL
      ,W.NUM_BASCULE_IN_WYBIL
      ,W.NUM_WYB_SUPP_WYBIL
      ,W.QTY_REL_ITEM_WYBIL
      ,W.QTY_ITEM_WYBIL
      ,W.QTY_CAR_WYBIL
      ,W.QTY_CAR_ITEM_WYBIL
  FROM PUA.PUA_WAYBILLS W
 WHERE 1 = 1
      AND W.NUM_WYB_GOV_WYBIL LIKE TRIM('&NUM_WYB_GOV_WYBIL') || '%'
      -- AND W.NUM_WYB_SUPP_WYBIL LIKE TRIM('&NUM_WYB_SUPP_WYBIL') || '%'
      /*      
             AND EXISTS (SELECT NULL
                FROM PUR.PUR_ORDERS O
               WHERE O.NUM_PGV_PUROR = &NUM_PGV_PUROR
                     AND W.PUROR_ORDER_ID = O.ORDER_ID)
      */
      -- AND W.ORDHE_COD_ORD_ORDHE LIKE '%' || TRIM(&ORDHE_COD_ORD_ORDHE) || '%'
/*      
       AND EXISTS
 (SELECT NULL
          FROM PUA.PUA_WAYBILL_ITEMS WI
         WHERE WI.WYBIL_WAYBILL_ID = W.WAYBILL_ID
               AND WI.NUM_RECEIPT_INV_WYBIT = &NUM_RECEIPT_INV_WYBIT)
*/               
   FOR UPDATE
--  
;
SELECT WI.WYBIL_WAYBILL_ID
      ,WI.NUM_RECEIPT_INV_WYBIT
      ,WI.DES_ITEM_WYBIT
      ,WI.ITEM_ITEM_ID
      ,WI.NUM_SEQ_WYBIT
  FROM PUA.PUA_WAYBILL_ITEMS WI
 WHERE EXISTS ( --
        SELECT NULL
          FROM PUA.PUA_WAYBILLS W
         WHERE 1 = 1
               AND W.WAYBILL_ID = WI.WYBIL_WAYBILL_ID
              -- AND W.ORDHE_COD_ORD_ORDHE LIKE '%' || TRIM(&ORDHE_COD_ORD_ORDHE) || '%'
           AND W.NUM_WYB_GOV_WYBIL LIKE TRIM('&NUM_WYB_GOV_WYBIL') || '%'
              -- AND W.NUM_WYB_SUPP_WYBIL LIKE TRIM('&NUM_WYB_SUPP_WYBIL') || '%'
         --      AND WI.NUM_RECEIPT_INV_WYBIT = &NUM_RECEIPT_INV_WYBIT
        /*              
                       AND EXISTS (SELECT NULL
                          FROM PUR.PUR_ORDERS O
                         WHERE O.NUM_PGV_PUROR = &NUM_PGV_PUROR
                               AND W.PUROR_ORDER_ID = O.ORDER_ID)
        */
        --
        )
--

--   FOR UPDATE
--
;
SELECT W.WAYBILL_ID
      ,O.ORDER_ID
      ,O.NUM_PGV_PUROR
      ,O.LKP_TYP_ORD_PUROR
      ,W.NUM_WYB_GOV_WYBIL
      ,replace(W.NUM_WYB_GOV_WYBIL,'-','') as NUM_WYB_GOV__
      ,W.LKP_FLG_WYB_WYBIL
      ,W.QTY_REL_ITEM_WYBIL
      ,TO_CHAR(W.DAT_ENTR_WYBIL
              ,'YYYY/MM/DD HH24:MI:SS'
              ,'NLS_CALENDAR=PERSIAN') AS HDAT_ENTR_WYBIL
      ,TO_CHAR(W.DAT_WYB_WYBIL
              ,'YYYY/MM/DD HH24:MI:SS'
              ,'NLS_CALENDAR=PERSIAN') AS HDAT_WYB_WYBIL
      ,TO_CHAR(W.DAT_EXIT_WYBIL
              ,'YYYY/MM/DD HH24:MI:SS'
              ,'NLS_CALENDAR=PERSIAN') AS HDAT_EXIT_WYBIL
      ,WI.NUM_RECEIPT_INV_WYBIT
      ,I.COD_ITEM
      ,I.DES_ITEM
  FROM PUA.PUA_WAYBILLS W
  LEFT OUTER JOIN PUA.PUA_WAYBILL_ITEMS WI
    ON W.WAYBILL_ID = WI.WYBIL_WAYBILL_ID
  LEFT OUTER JOIN MAM.MAM_ITEMS I
    ON WI.ITEM_ITEM_ID = I.ITEM_ID
  LEFT OUTER JOIN PUR.PUR_ORDERS O
    ON W.PUROR_ORDER_ID = O.ORDER_ID
 WHERE 1 = 1 --
      -- AND W.ORDHE_COD_ORD_ORDHE LIKE '%' || TRIM(&ORDHE_COD_ORD_ORDHE) || '%'
AND W.NUM_WYB_GOV_WYBIL LIKE TRIM('&NUM_WYB_GOV_WYBIL') || '%'
      -- AND W.NUM_WYB_SUPP_WYBIL LIKE TRIM('&NUM_WYB_SUPP_WYBIL') || '%'
--       AND WI.NUM_RECEIPT_INV_WYBIT = &NUM_RECEIPT_INV_WYBIT
--       AND O.NUM_PGV_PUROR = &NUM_PGV_PUROR
--
;
