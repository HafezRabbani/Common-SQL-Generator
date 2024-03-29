SELECT I.COD_ITEM
      ,I.DES_ITEM
      ,SUM(R.QTY_RESERVATION_MRES) OVER(PARTITION BY R.ITEM_ITEM_ID) - SUM(R.QTY_DELIVER_MRES) OVER(PARTITION BY R.ITEM_ITEM_ID) S
      ,R.QTY_PRIMARY_RESERVATION_MRES QP
      ,R.QTY_RESERVATION_MRES QR
      ,R.QTY_DELIVER_MRES QD
      ,R.*
  FROM MAM.MAM_RESERVATIONS R
 INNER JOIN MAM.MAM_ITEMS I
    ON R.ITEM_ITEM_ID = I.ITEM_ID
 WHERE I.COD_ITEM = &COD_ITEM
--IN  ('7030110012', '7030110032')
 ORDER BY I.COD_ITEM, R.DAT_REQUIREMENT_MRES;
SELECT I.COD_ITEM, I.DES_ITEM, QS.*
  FROM MAM.MAM_ITEMS I
 INNER JOIN (SELECT II.ITEM_ID
                   ,SI.NAM_SUB_INVENTORY_MSINV
                   ,NVL(QUANTITY_IN_STOCK.QUANTITY_IN_STOCK, 0) AS QUANTITY_IN_EACH_STOCK
               FROM MAM.MAM_ITEMS II
              CROSS JOIN MAM.MAM_SUB_INVENTORIES SI
               LEFT OUTER JOIN ( --
                               SELECT X.ITEM_ITEM_ID_FOR
                                      ,MSINV_NAM_SUB_INVENTORY_MSIFOR AS NAM_SUB_INVENTORY_MSINV
                                      ,SUM(X.QTY_TRANSACTION_MTRAN) QUANTITY_IN_STOCK
                                 FROM MAM.MAM_MATERIAL_TRANSACTIONS X
                                GROUP BY X.ITEM_ITEM_ID_FOR
                                         ,X.MSINV_NAM_SUB_INVENTORY_MSIFOR
                               --
                               ) QUANTITY_IN_STOCK
                 ON II.ITEM_ID = QUANTITY_IN_STOCK.ITEM_ITEM_ID_FOR
                    AND SI.NAM_SUB_INVENTORY_MSINV =
                    QUANTITY_IN_STOCK.NAM_SUB_INVENTORY_MSINV) QS
    ON QS.ITEM_ID = I.ITEM_ID
 WHERE I.COD_ITEM = &COD_ITEM
      --IN ('7030110012', '7030110032')
       AND QS.QUANTITY_IN_EACH_STOCK > 0
 ORDER BY I.COD_ITEM, QS.QUANTITY_IN_EACH_STOCK;
