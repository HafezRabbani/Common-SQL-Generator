SELECT ITEM_ID
      ,I.COD_ITEM
      ,I.DES_ITEM
      ,H.NUM_REPLENISHMENT_MREPH
      ,L.LKP_STA_REPLENISHMENT_MREPL
      ,APPS.APP_FND_LOOKUP_PKG.GET_FARSI_MEANING_FUN(UPPER('MAM_REPLENISH_LINES')
                                                    ,UPPER('LKP_STA_REPLENISHMENT_MREPL')
                                                    ,L.LKP_STA_REPLENISHMENT_MREPL) AS LKP_STA_REPLENISHMENT_DES
      ,R.NUM_PGV_PURRQ
      ,O.NUM_PGV_PUROR
      ,O.LKP_COD_STEP_PUROR
  FROM MAM.MAM_ITEMS I
 INNER JOIN MAM.MAM_REPLENISH_LINES L
    ON L.ITEM_ITEM_ID = I.ITEM_ID
 INNER JOIN MAM.MAM_REPLENISH_HEADERS H
    ON L.MREPH_REPLENISH_HEADER_ID = H.REPLENISH_HEADER_ID
  LEFT OUTER JOIN PUR.PUR_REQUEST_REPLENISHMENTS RR
    ON L.REPLENISH_LINE_ID = RR.MREPL_REPLENISH_LINE_ID
  LEFT OUTER JOIN PUR.PUR_REQUEST_POSITIONS RP
    ON RR.PURRP_PURRP_ID = RP.PURRP_ID
  LEFT OUTER JOIN PUR.PUR_REQUESTS R
    ON RP.PURRQ_NUM_PGV_PURRQ = R.NUM_PGV_PURRQ
  LEFT OUTER JOIN PUR.PUR_ORDER_POSITIONS OP
    ON RP.PURRP_ID = OP.PURRP_PURRP_ID
  LEFT OUTER JOIN PUR.PUR_ORDERS O
    ON O.ORDER_ID = OP.PUROR_ORDER_ID
 WHERE 1 = 1
       AND I.COD_ITEM = &COD_ITEM
--       AND I.DES_ITEM LIKE '%&DES_ITEM%'