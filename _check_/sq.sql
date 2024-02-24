SELECT CASE
         WHEN NVL(SQ, 0) != NVL(QTY_MONH, 0) THEN
          '!'
       END AS ERROR
      ,D.*

  FROM ( --
        SELECT I.ITEM_ID
               ,I.COD_ITEM
               ,I.FLG_LOT_CONTROL_ITEM AS LOT
               ,I.COD_SERIAL_NUMBER_CONTROL_ITEM AS SERIAL
               ,INVL.INV AS INV
               ,INVL.LID AS SUB_INVENTORY_LOCATOR_ID
               ,(SELECT L.COD_LOCATOR_MSLOC
                   FROM MAM.MAM_SUB_INVENTORY_LOCATORS L
                  WHERE L.SUB_INVENTORY_LOCATOR_ID = INVL.LID) AS COD_LOCATOR
               ,(SELECT II.FLG_PRIMARY_SUBINVENTORY_MIINV
                   FROM MAM.MAM_ITEM_SUB_INVENTORIES II
                  WHERE II.ITEM_ITEM_ID = I.ITEM_ID
                        AND II.MSINV_NAM_SUB_INVENTORY_MSINV = INVL.INV
                        AND NVL(II.MSLOC_SUB_INVENTORY_LOCATOR_ID, 0) =
                        NVL(INVL.LID, 0)) AS FLG_PRIMARY_SUBINVENTORY_MIINV
               ,CAST(NVL(SQ.SQ, 0) AS NUMBER(15, 5)) AS SQ
               ,OH.ONHAND_QUANTITY_ID
               ,OH.QTY_MONH
               ,I.DES_ITEM
          FROM MAM.MAM_ITEMS I
          LEFT OUTER JOIN ( --
                           SELECT DISTINCT ITEM_ID
                                           ,INV
                                           ,LID
                             FROM ( --
                                    SELECT DISTINCT X.ITEM_ITEM_ID_FOR               AS ITEM_ID
                                                    ,X.MSINV_NAM_SUB_INVENTORY_MSIFOR AS INV
                                                    ,X.MSLOC_SUB_INVENTORY_LOCATORFOR AS LID
                                      FROM MAM.MAM_MATERIAL_TRANSACTIONS X
                                    UNION
                                    SELECT ITEM_ITEM_ID                     AS ITEM_ID
                                           ,Q.MSINV_NAM_SUB_INVENTORY_MSINV  AS INV
                                           ,Q.MSLOC_SUB_INVENTORY_LOCATOR_ID AS LID
                                      FROM MAM.MAM_ONHAND_QUANTITIES Q
                                    --
                                    ) --
                           ) INVL
            ON I.ITEM_ID = INVL.ITEM_ID
          LEFT OUTER JOIN ( --
                           SELECT X.ITEM_ITEM_ID_FOR
                                  ,X.MSINV_NAM_SUB_INVENTORY_MSIFOR
                                  ,X.MSLOC_SUB_INVENTORY_LOCATORFOR
                                  ,SUM(X.QTY_PRIMARY_MTRAN) AS SQ
                             FROM MAM.MAM_MATERIAL_TRANSACTIONS X
                            GROUP BY X.ITEM_ITEM_ID_FOR
                                     ,X.MSINV_NAM_SUB_INVENTORY_MSIFOR
                                     ,X.MSLOC_SUB_INVENTORY_LOCATORFOR
                           --
                           ) SQ
            ON SQ.ITEM_ITEM_ID_FOR = INVL.ITEM_ID
               AND SQ.MSINV_NAM_SUB_INVENTORY_MSIFOR = INVL.INV
               AND
               NVL(SQ.MSLOC_SUB_INVENTORY_LOCATORFOR, 0) = NVL(INVL.LID, 0)
          LEFT OUTER JOIN ( --
                           SELECT Q.ONHAND_QUANTITY_ID
                                  ,Q.QTY_MONH
                                  ,Q.ITEM_ITEM_ID
                                  ,Q.MSINV_NAM_SUB_INVENTORY_MSINV
                                  ,Q.MSLOC_SUB_INVENTORY_LOCATOR_ID
                             FROM MAM.MAM_ONHAND_QUANTITIES Q
                           --
                           ) OH
            ON OH.ITEM_ITEM_ID = INVL.ITEM_ID
               AND OH.MSINV_NAM_SUB_INVENTORY_MSINV = INVL.INV
               AND
               NVL(OH.MSLOC_SUB_INVENTORY_LOCATOR_ID, 0) = NVL(INVL.LID, 0)
        
         WHERE 1 = 1
              --               AND I.COD_SERIAL_NUMBER_CONTROL_ITEM = 1
              --               AND I.FLG_LOT_CONTROL_ITEM = 1
              --AND I.COD_ITEM LIKE (SELECT REPLACE(C, CHR(10), '') FROM (SELECT UPPER(TRIM('&cod_item')) AS C FROM DUAL)) || '%'
               AND I.COD_ITEM IN (&COD_ITEM)
        --               AND I.ITEM_ID IN (&ITEM_ID)
        --
        ) D
 WHERE 1 = 1
--       AND NVL(SQ, 0) != NVL(QTY_MONH, 0)
--       AND INV = &INV
--       AND NVL(SQ, 0) != 0
 ORDER BY COD_ITEM
         ,INV
         ,COD_LOCATOR
