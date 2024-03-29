SELECT P.PHYSICAL_INVENTORY_TAG_ID
      ,P.MPINV_PHYSICAL_INVENTORY_ID AS PHYSICAL_INVENTORY_ID
      ,P.MPSUB_PHYSICAL_SUBINVENTORY_ID AS PHYSICAL_SUBINVENTORY_ID
      ,P.NUM_TAG_MPTAG
      ,P.ITEM_ITEM_ID AS ITEM_ID
      ,APPS.MAM_ITEMS_CTRL_PKG.GET_DESCRIPTION(P.ITEM_ITEM_ID) AS ITEM
      ,P.MSINV_NAM_SUB_INVENTORY_MSINV AS INV
      ,P.MSLOC_SUB_INVENTORY_LOCATOR_ID
      ,APPS.MAM_SUB_INVENTRYLCTRS_CTRL_PKG.GET_DESCRIPTION(P_SUB_INVENTORY_LOCATOR_ID => P.MSLOC_SUB_INVENTORY_LOCATOR_ID) AS COD_LOC
      ,P.QTY_ONHAND_MPTAG
      ,P.MPADJ_PHYSICAL_ADJUSTMENT_ID
      ,P.COD_LOT_MPTAG
      ,P.COD_REVISION_MPTAG
      ,P.COD_SERIAL_NUMBER_MPTAG
      ,P.ID_LOCATOR_MPTAG
      ,P.FLG_ENABLED_MPTAG
      ,P.CREATE_DATE
      ,P.CREATE_BY_DB_USER
      ,P.CREATE_BY_APP_USER
      ,P.LAST_UPDATE_DATE
      ,P.LAST_UPDATE_BY_DB_USER
      ,P.LAST_UPDATE_BY_APP_USER
      ,P.ATTACH_ID
  FROM MAM.MAM_PHYSICAL_INVENTORY_TAGS P
 WHERE 1 = 1
   AND P.MPINV_PHYSICAL_INVENTORY_ID IN (&PHYSICAL_INVENTORY_ID)
 ORDER BY MPINV_PHYSICAL_INVENTORY_ID
         ,MPSUB_PHYSICAL_SUBINVENTORY_ID
         ,TO_NUMBER(P.NUM_TAG_MPTAG)
