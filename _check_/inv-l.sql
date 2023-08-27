SELECT INV.NAM_SUB_INVENTORY_MSINV AS INV
      ,INV.DES_MSINV
      ,INV.LKP_RESPONSIBILITY_RESTRICTED_
      ,L.SUB_INVENTORY_LOCATOR_ID
      ,L.COD_LOCATOR_MSLOC
      ,L.FLG_PRIMARY_LOCATOR_MSLOC
  FROM MAM.MAM_SUB_INVENTORIES INV
  LEFT OUTER JOIN MAM.MAM_SUB_INVENTORY_LOCATORS L
    ON INV.NAM_SUB_INVENTORY_MSINV = L.MSINV_NAM_SUB_INVENTORY_MSINV
