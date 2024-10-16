SELECT Q.ONHAND_QUANTITY_ID
      ,Q.QTY_MONH
      ,Q.ITEM_ITEM_ID
      ,(SELECT I.COD_ITEM
          FROM MAM.MAM_ITEMS I
         WHERE I.ITEM_ID = Q.ITEM_ITEM_ID) AS I
      ,Q.MSINV_NAM_SUB_INVENTORY_MSINV
      ,Q.MSLOC_SUB_INVENTORY_LOCATOR_ID
      ,(SELECT L.COD_LOCATOR_MSLOC
          FROM MAM.MAM_SUB_INVENTORY_LOCATORS L
         WHERE L.SUB_INVENTORY_LOCATOR_ID =
               Q.MSLOC_SUB_INVENTORY_LOCATOR_ID) AS COD_LOCATOR
      ,Q.MLOT_LOT_NUMBER_ID
      ,Q.MSER_SERIAL_NUMBER_ID
      ,Q.NUM_PIE_MONH
      ,Q.LKP_COD_LOST_MONH
      ,APPS.APP_FND_LOOKUP_PKG.GET_FARSI_MEANING_FUN(UPPER('MAM_ONHAND_QUANTITIES')
                                                    ,UPPER('LKP_COD_LOST_MONH')
                                                    ,Q.LKP_COD_LOST_MONH) AS LKP_COD_LOST_MONH_DES
      ,Q.COD_REVISION_MONH
      ,Q.LKP_STA_PENDING_MONH
      ,APPS.APP_FND_LOOKUP_PKG.GET_FARSI_MEANING_FUN(UPPER('MAM_ONHAND_QUANTITIES')
                                                    ,UPPER('LKP_STA_PENDING_MONH')
                                                    ,Q.LKP_STA_PENDING_MONH) AS LKP_STA_PENDING_MONH_DES
      ,Q.CREATE_DATE
      ,Q.CREATE_BY_DB_USER
      ,Q.CREATE_BY_APP_USER
      ,Q.LAST_UPDATE_DATE
      ,Q.LAST_UPDATE_BY_DB_USER
      ,Q.LAST_UPDATE_BY_APP_USER
      ,Q.ATTACH_ID
  FROM MAM.MAM_ONHAND_QUANTITIES Q
 WHERE 1 = 1
      
   AND Q.ITEM_ITEM_ID = (SELECT ITEM_ID
                           FROM MAM.MAM_ITEMS I
                          WHERE 1 = 1
                               --                            AND I.LKP_STA_INVENTORY_ITEM = 1
                            AND I.COD_ITEM = TRIM('&COD_ITEM')
                         --
                         )

--   FOR UPDATE
