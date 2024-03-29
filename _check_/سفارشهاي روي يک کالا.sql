SELECT DISTINCT O.NUM_PGV_PUROR AS "�����"
                ,APPS.APP_FND_LOOKUP_PKG.GET_FARSI_MEANING_FUN(UPPER('PUR_REQUESTS')
                                                             ,UPPER('LKP_TYP_REQ_PURRQ')
                                                             ,R.LKP_TYP_REQ_PURRQ) AS "��� �������"
  FROM MAM.MAM_RCV_TRANSACTIONS RX
 INNER JOIN PUR.PUR_ORDER_POSITIONS OP
    ON RX.PUROP_PUROP_ID = OP.PUROP_ID
 INNER JOIN PUR.PUR_REQUEST_POSITIONS RP
    ON OP.PURRP_PURRP_ID = RP.PURRP_ID
 INNER JOIN PUR.PUR_REQUESTS R
    ON RP.PURRQ_NUM_PGV_PURRQ = R.NUM_PGV_PURRQ
 INNER JOIN PUR.PUR_ORDERS O
    ON OP.PUROR_ORDER_ID = O.ORDER_ID
 WHERE RX.ITEM_ITEM_ID =
       (SELECT ITEM_ID FROM MAM.MAM_ITEMS I WHERE I.COD_ITEM = &COD_ITEM)
 ORDER BY O.NUM_PGV_PUROR
