SELECT Z.*
  FROM ( --
        SELECT X.MATERIAL_TRANSACTION_ID AS XID
               ,X.DAT_TRANSACTION_MTRAN
               ,TO_CHAR(X.DAT_TRANSACTION_MTRAN
                       ,'YYYY/MM/DD HH24:MI:SS'
                       ,'NLS_CALENDAR=PERSIAN') AS D
                
               ,X.MSINV_NAM_SUB_INVENTORY_MSIFOR AS INV
               ,L.COD_LOCATOR_MSLOC
               ,X.MTYP_TRANSACTION_TYPE_ID AS TT
               ,X.QTY_PRIMARY_MTRAN
               ,SUM(X.QTY_PRIMARY_MTRAN) OVER(PARTITION BY X.ITEM_ITEM_ID_FOR, X.MSINV_NAM_SUB_INVENTORY_MSIFOR, X.MSLOC_SUB_INVENTORY_LOCATORFOR ORDER BY X.DAT_TRANSACTION_MTRAN, X.MATERIAL_TRANSACTION_ID) AS SQ
               ,NVL((SELECT COUNT(1)
                      FROM MAM.MAM_TRANSACTION_SERIAL_NUMBERS XS1
                     WHERE XS1.MTRAN_MATERIAL_TRANSACTION_ID =
                           X.MATERIAL_TRANSACTION_ID)
                   ,0) AS XS_CNT
               ,CASE
                  WHEN ABS(X.QTY_PRIMARY_MTRAN) !=
                       NVL((SELECT COUNT(1)
                             FROM MAM.MAM_TRANSACTION_SERIAL_NUMBERS XS1
                            WHERE XS1.MTRAN_MATERIAL_TRANSACTION_ID =
                                  X.MATERIAL_TRANSACTION_ID)
                          ,0) THEN
                   'Err'
                END AS CNT_CNFLICT
               ,(SELECT LISTAGG(XS.MSER_SERIAL_NUMBER_ID, ', ') WITHIN GROUP(ORDER BY XS.MSER_SERIAL_NUMBER_ID)
                   FROM MAM.MAM_TRANSACTION_SERIAL_NUMBERS XS
                  WHERE XS.MTRAN_MATERIAL_TRANSACTION_ID =
                        X.MATERIAL_TRANSACTION_ID) AS SR
               ,(SELECT LISTAGG(V0.MSER_SERIAL_NUMBER_ID, ', ') WITHIN GROUP(ORDER BY V0.MSER_SERIAL_NUMBER_ID)
                   FROM APPS.MAM_SERIAL_REARRNGMNT_X_FA_VIW V0
                  WHERE V0.XID = X.MATERIAL_TRANSACTION_ID
                    AND V0.ITEM_ID = X.ITEM_ITEM_ID_FOR
                    AND EXISTS
                  (SELECT NULL
                           FROM MAM.MAM_SERIAL_NUMBERS S9
                          WHERE S9.ITEM_ITEM_ID = X.ITEM_ITEM_ID_FOR
                            AND V0.MSER_SERIAL_NUMBER_ID = S9.SERIAL_NUMBER_ID)) AS VALIDITY
          FROM MAM.MAM_MATERIAL_TRANSACTIONS X
         INNER JOIN MAM.MAM_ITEMS I
            ON X.ITEM_ITEM_ID_FOR = I.ITEM_ID
          LEFT OUTER JOIN MAM.MAM_SUB_INVENTORY_LOCATORS L
            ON X.MSLOC_SUB_INVENTORY_LOCATORFOR = L.SUB_INVENTORY_LOCATOR_ID
         WHERE I.COD_ITEM = 1121130023
           AND L.COD_LOCATOR_MSLOC = 'O06'
           AND X.MSINV_NAM_SUB_INVENTORY_MSIFOR = 10
        --   AND S.SERIAL_NUMBER_ID NOT IN (&SERIAL_NUMBER_ID)
        --
        ) Z
 WHERE 1 = 1
-- AND Z.QTY_PRIMARY_MTRAN < 0
--   AND Z.TT NOT IN (4)
--   AND Z.SR != Z.VALIDITY
 ORDER BY Z.DAT_TRANSACTION_MTRAN, XID
