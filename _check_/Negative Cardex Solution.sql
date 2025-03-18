SELECT I
      ,INV
      ,LID
      ,ABS(MIN(SQ)) AS QTY
      ,TO_CHAR(MIN(DAT_TRANSACTION_MTRAN) - (1 / 86400)
              ,'yyyy/mm/dd hh24:mi:ss'
              ,'nls_calendar=persian') AS DAT
  FROM ( --
         SELECT Y.*
           FROM ( --
                  
                  SELECT X.MATERIAL_TRANSACTION_ID AS XID
                         ,SUM(X.QTY_PRIMARY_MTRAN) OVER(PARTITION BY X.ITEM_ITEM_ID_FOR, X.MSINV_NAM_SUB_INVENTORY_MSIFOR, X.MSLOC_SUB_INVENTORY_LOCATORFOR ORDER BY X.DAT_TRANSACTION_MTRAN, X.MATERIAL_TRANSACTION_ID, X.MSLOC_SUB_INVENTORY_LOCATORFOR) AS SQ
                         ,X.MSINV_NAM_SUB_INVENTORY_MSIFOR AS INV
                         ,X.DAT_TRANSACTION_MTRAN
                         ,X.MSLOC_SUB_INVENTORY_LOCATORFOR || CASE
                            WHEN X.MSLOC_SUB_INVENTORY_LOCATORFOR IS NOT NULL THEN
                             (SELECT ': ' || LL.COD_LOCATOR_MSLOC
                                FROM MAM.MAM_SUB_INVENTORY_LOCATORS LL
                               WHERE LL.SUB_INVENTORY_LOCATOR_ID =
                                     X.MSLOC_SUB_INVENTORY_LOCATORFOR)
                          END AS LID
                         ,(SELECT I.ITEM_ID || ': ' || I.COD_ITEM || ': ' ||
                                  I.DES_ITEM
                             FROM MAM.MAM_ITEMS I
                            WHERE I.ITEM_ID = X.ITEM_ITEM_ID_FOR) I
                    FROM MAM.MAM_MATERIAL_TRANSACTIONS X
                   WHERE 1 = 1
                  /*
                                 AND X.ITEM_ITEM_ID_FOR --
                                --               = &ITEM_ITEM_ID_FOR
                                
                                 IN ( --
                                         SELECT ITEM_ID
                                           FROM MAM.MAM_ITEMS I
                                          WHERE I.COD_ITEM = TRIM(&COD_ITEM)
                                         --
                                         )
                                 AND (X.MSINV_NAM_SUB_INVENTORY_MSIFOR = &NAM_SUB_INVENTORY OR
                                 &NAM_SUB_INVENTORY IS NULL)
                                 AND
                                 (X.MSLOC_SUB_INVENTORY_LOCATORFOR = &SUB_INVENTORY_LOCATOR_ID OR
                                 &SUB_INVENTORY_LOCATOR_ID IS NULL)
                  */ --
                  ) Y
         --
          WHERE --
          1 = 1
       AND SQ < 0
         --
         )
 GROUP BY I, INV, LID
