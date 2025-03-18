SELECT L.LOT_NUMBER_ID
      ,L.COD_LOT_MLOT
      ,L.FLG_DISABLE_MLOT
      ,L.DAT_EXPIRATION_MLOT
      ,TO_CHAR(L.DAT_EXPIRATION_MLOT
              ,'YYYY/MM/DD HH24:MI:SS'
              ,'NLS_CALENDAR=PERSIAN') AS DAT_EXPIRATION_MLOT_H
      ,L.ITEM_ITEM_ID
      ,L.LKP_STA_CURRENT_MLOT
      ,L.LKP_STA_CURRENT_MLOT || CASE
         WHEN L.LKP_STA_CURRENT_MLOT IS NOT NULL THEN
          ': '
       END ||
       APPS.APP_FND_LOOKUP_PKG.GET_FARSI_MEANING_FUN(UPPER('MAM_LOT_NUMBERS')
                                                    ,UPPER('LKP_STA_CURRENT_MLOT')
                                                    ,L.LKP_STA_CURRENT_MLOT) AS LKP_STA_CURRENT_MLOT_DES
      ,L.STA_OLD_MLOT
      ,L.NUM_QTY_MLOT

  FROM MAM.MAM_LOT_NUMBERS L
 WHERE 1 = 1
      -- and l.lot_number_id=&lot_number_id
   AND (L.COD_LOT_MLOT = &COD_LOT_MLOT OR &COD_LOT_MLOT IS NULL)
   AND L.ITEM_ITEM_ID IN ( --
                          SELECT ITEM_ID
                            FROM MAM.MAM_ITEMS I
                           WHERE I.COD_ITEM IN (&COD_ITEM)
                          --
                          )

   FOR UPDATE
--
;
SELECT L.LOT_NUMBER_ID
      ,X.MSINV_NAM_SUB_INVENTORY_MSIFOR
      ,X.MSLOC_SUB_INVENTORY_LOCATORFOR
      ,(SELECT LL.COD_LOCATOR_MSLOC
          FROM MAM.MAM_SUB_INVENTORY_LOCATORS LL
         WHERE LL.SUB_INVENTORY_LOCATOR_ID =
               X.MSLOC_SUB_INVENTORY_LOCATORFOR) AS COD_LOCATOR_MSLOC
      ,SUM(X.QTY_PRIMARY_MTRAN) OVER(PARTITION BY L.LOT_NUMBER_ID, X.MSINV_NAM_SUB_INVENTORY_MSIFOR, X.MSLOC_SUB_INVENTORY_LOCATORFOR) AS SQL
      ,X.MATERIAL_TRANSACTION_ID
      ,X.QTY_PRIMARY_MTRAN
      ,X.MTYP_TRANSACTION_TYPE_ID
      ,X.DAT_TRANSACTION_MTRAN
  FROM MAM.MAM_MATERIAL_TRANSACTIONS X
  LEFT OUTER JOIN MAM.MAM_TRANSACTION_LOT_NUMBERS XL
    ON XL.MTRAN_MATERIAL_TRANSACTION_ID = X.MATERIAL_TRANSACTION_ID
  LEFT OUTER JOIN MAM.MAM_LOT_NUMBERS L
    ON L.LOT_NUMBER_ID = XL.MLOT_LOT_NUMBER_ID
 WHERE 1 = 1
      --   AND L.LOT_NUMBER_ID = &LOT_NUMBER_ID
   AND (L.COD_LOT_MLOT = &COD_LOT_MLOT OR &COD_LOT_MLOT IS NULL)
      
   AND L.ITEM_ITEM_ID IN ( --
                          SELECT ITEM_ID
                            FROM MAM.MAM_ITEMS I
                           WHERE I.COD_ITEM = TRIM(&COD_ITEM)
                          --
                          )

 ORDER BY X.MATERIAL_TRANSACTION_ID DESC
--
;
