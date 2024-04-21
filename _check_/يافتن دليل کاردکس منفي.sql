WITH INZ AS
 ( --
  SELECT CASE
            WHEN X2.MATERIAL_TRANSACTION_ID IS NULL THEN
             'Deleted'
            WHEN X2.ITEM_ITEM_ID_FOR != JR.ITEM_ITEM_ID_FOR THEN
             'Item ' ||
             APPS.MAM_ITEMS_CTRL_PKG.GET_DESCRIPTION(JR.ITEM_ITEM_ID_FOR) ||
             '  =>  ' ||
             APPS.MAM_ITEMS_CTRL_PKG.GET_DESCRIPTION(X2.ITEM_ITEM_ID_FOR)
            WHEN X2.QTY_PRIMARY_MTRAN != JR.QTY_PRIMARY_MTRAN THEN
             'Qty ' || JR.QTY_PRIMARY_MTRAN || '  =>  ' || X2.QTY_PRIMARY_MTRAN
            WHEN X2.DAT_TRANSACTION_MTRAN != JR.DAT_TRANSACTION_MTRAN THEN
             'Date ' || TO_CHAR(JR.DAT_TRANSACTION_MTRAN
                               ,'YYYY/MM/DD HH24:MI:SS'
                               ,'NLS_CALENDAR=PERSIAN') || '  =>  ' ||
             TO_CHAR(X2.DAT_TRANSACTION_MTRAN
                    ,'YYYY/MM/DD HH24:MI:SS'
                    ,'NLS_CALENDAR=PERSIAN') || ' Differenc = ' ||
             (TRUNC(JR.DAT_TRANSACTION_MTRAN) - TRUNC(X2.DAT_TRANSACTION_MTRAN))
            WHEN X2.MSINV_NAM_SUB_INVENTORY_MSIFOR !=
                 JR.MSINV_NAM_SUB_INVENTORY_MSIFOR THEN
             'Inv ' || JR.MSINV_NAM_SUB_INVENTORY_MSIFOR || '  =>  ' ||
             X2.MSINV_NAM_SUB_INVENTORY_MSIFOR
            WHEN NVL(X2.MSLOC_SUB_INVENTORY_LOCATORFOR, 0) !=
                 NVL(JR.MSLOC_SUB_INVENTORY_LOCATORFOR, 0) THEN
             'Loc ' ||
             APPS.MAM_SUB_INVENTRYLCTRS_CTRL_PKG.GET_DESCRIPTION(JR.MSLOC_SUB_INVENTORY_LOCATORFOR) ||
             '  =>  ' ||
             APPS.MAM_SUB_INVENTRYLCTRS_CTRL_PKG.GET_DESCRIPTION(X2.MSLOC_SUB_INVENTORY_LOCATORFOR)
          END AS CHANGE_
         ,CASE
            WHEN SIGN(JR.QTY_PRIMARY_MTRAN) < 0 THEN
             '-'
          END AS SIGN_
         ,JR.MATERIAL_TRANSACTION_ID
         ,JR.JRN_ID
         ,JR.JRN_OPERATION
         ,JR.DAT_TRANSACTION_MTRAN
         ,JR.ITEM_ITEM_ID_FOR
         ,JR.MTYP_TRANSACTION_TYPE_ID
         ,JR.MSINV_NAM_SUB_INVENTORY_MSIFOR
         ,JR.MSLOC_SUB_INVENTORY_LOCATORFOR
         ,JR.QTY_PRIMARY_MTRAN
         ,JR.NAM_TRANSACTION_SOURCE_MTRAN
         ,JR.JRN_DB_USER
         ,JR.JRN_PROGRAM
         ,JR.JRN_APP_USER
         ,JR.JRN_OS_USER
         ,JR.JRN_DATETIME
         ,X2.CREATE_DATE
    FROM JRN.MAM_MATERIAL_TRANSACTIONS_JRN JR
    LEFT OUTER JOIN MAM.MAM_MATERIAL_TRANSACTIONS X2
      ON JR.MATERIAL_TRANSACTION_ID = X2.MATERIAL_TRANSACTION_ID
   WHERE JR.MATERIAL_TRANSACTION_ID IN
         ( --
          SELECT J.MATERIAL_TRANSACTION_ID
            FROM JRN.MAM_MATERIAL_TRANSACTIONS_JRN J
           WHERE 1 = 1
             AND J.JRN_OPERATION = 'INS'
             AND J.ITEM_ITEM_ID_FOR --
                 IN ( --
                     SELECT ITEM_ID
                       FROM MAM.MAM_ITEMS I
                      WHERE I.COD_ITEM = TRIM(&COD_ITEM)
                     --
                     )
             AND EXISTS
           (SELECT NULL
                    FROM JRN.MAM_MATERIAL_TRANSACTIONS_JRN J2
                   WHERE 1 = 1
                     AND J2.JRN_OPERATION = 'UPD'
                     AND ( --
                          J2.ITEM_ITEM_ID_FOR != J.ITEM_ITEM_ID_FOR OR
                          J2.QTY_PRIMARY_MTRAN != J.QTY_PRIMARY_MTRAN OR
                          J2.DAT_TRANSACTION_MTRAN != J.DAT_TRANSACTION_MTRAN OR
                          J2.MSINV_NAM_SUB_INVENTORY_MSIFOR !=
                          J.MSINV_NAM_SUB_INVENTORY_MSIFOR OR
                          NVL(J2.MSLOC_SUB_INVENTORY_LOCATORFOR, 0) !=
                          NVL(J.MSLOC_SUB_INVENTORY_LOCATORFOR, 0)
                         --
                         )
                     AND J2.MATERIAL_TRANSACTION_ID = J.MATERIAL_TRANSACTION_ID
                  --
                  )
          UNION
          SELECT J.MATERIAL_TRANSACTION_ID
            FROM JRN.MAM_MATERIAL_TRANSACTIONS_JRN J
           WHERE 1 = 1
             AND J.JRN_OPERATION = 'DEL'
             AND J.ITEM_ITEM_ID_FOR --
                 IN ( --
                     SELECT ITEM_ID
                       FROM MAM.MAM_ITEMS I
                      WHERE I.COD_ITEM = TRIM(&COD_ITEM)
                     --
                     )
             AND TO_NUMBER(TO_CHAR(J.JRN_DATETIME
                                  ,'YYYY'
                                  ,'NLS_CALENDAR=PERSIAN')) >=
                 TO_NUMBER('&YEAR')
          UNION
          SELECT J.MATERIAL_TRANSACTION_ID
            FROM JRN.MAM_MATERIAL_TRANSACTIONS_JRN J
           WHERE 1 = 1
             AND J.ITEM_ITEM_ID_FOR --
                 IN ( --
                     SELECT ITEM_ID
                       FROM MAM.MAM_ITEMS I
                      WHERE I.COD_ITEM = TRIM(&COD_ITEM)
                     --
                     )
             AND J.JRN_PROGRAM IN ('PL/SQL Developer', 'plsqldev.exe')
          UNION
          SELECT X99.MATERIAL_TRANSACTION_ID
            FROM MAM.MAM_MATERIAL_TRANSACTIONS X99
           WHERE 1 = 1
             AND X99.ITEM_ITEM_ID_FOR --
                 IN ( --
                     SELECT ITEM_ID
                       FROM MAM.MAM_ITEMS I
                      WHERE I.COD_ITEM = TRIM(&COD_ITEM)
                     --
                     )
             AND ABS(TRUNC(X99.DAT_TRANSACTION_MTRAN) - TRUNC(X99.CREATE_DATE)) > 1
          --
          )
     AND '&YEAR' IN
         (TO_CHAR(JR.DAT_TRANSACTION_MTRAN, 'YYYY', 'NLS_CALENDAR=PERSIAN')
         ,NVL(TO_CHAR(X2.DAT_TRANSACTION_MTRAN
                     ,'YYYY'
                     ,'NLS_CALENDAR=PERSIAN')
             ,'&YEAR'))
  --
  )
SELECT Z.CHANGE_
      ,Z.SIGN_
      ,Z.MATERIAL_TRANSACTION_ID AS XID
      ,Z.JRN_ID
      ,Z.JRN_OPERATION AS J_OP
      ,Z.DAT_TRANSACTION_MTRAN
      ,TO_CHAR(Z.DAT_TRANSACTION_MTRAN
              ,'YYYY/MM/DD HH24:MI:SS'
              ,'NLS_CALENDAR=PERSIAN') AS D
      ,TRUNC(Z.DAT_TRANSACTION_MTRAN) - TRUNC(Z.CREATE_DATE) AS CREATE_DAT_TRANSACTION_DIFF
      ,Z.ITEM_ITEM_ID_FOR AS ITEM_ID
      ,Z.MTYP_TRANSACTION_TYPE_ID AS TT
      ,Z.QTY_PRIMARY_MTRAN
      ,Z.MSINV_NAM_SUB_INVENTORY_MSIFOR AS INV
      ,Z.MSLOC_SUB_INVENTORY_LOCATORFOR AS LID
      ,CASE
         WHEN Z.MSLOC_SUB_INVENTORY_LOCATORFOR IS NOT NULL THEN
          APPS.MAM_SUB_INVENTRYLCTRS_CTRL_PKG.GET_DESCRIPTION(Z.MSLOC_SUB_INVENTORY_LOCATORFOR)
       END AS LOC
      ,Z.NAM_TRANSACTION_SOURCE_MTRAN AS NAM_TRANSACTION_SOURCE
      ,APPS.MAM_ITEMS_CTRL_PKG.GET_DESCRIPTION(Z.ITEM_ITEM_ID_FOR) AS ITEM
      ,Z.JRN_DB_USER
      ,Z.JRN_PROGRAM
      ,Z.JRN_APP_USER
      ,Z.JRN_OS_USER
      ,Z.JRN_DATETIME
      ,TO_CHAR(Z.JRN_DATETIME
              ,'YYYY/MM/DD HH24:MI:SS'
              ,'NLS_CALENDAR=PERSIAN') AS DJO
  FROM INZ Z
 WHERE 1 = 1
   AND EXISTS
 (SELECT NULL
          FROM INZ Z2
         WHERE Z2.MATERIAL_TRANSACTION_ID = Z.MATERIAL_TRANSACTION_ID
           AND Z2.CHANGE_ IS NOT NULL)
      --   AND Z.CHANGE_ = 'Delete'
   AND TO_NUMBER(TO_CHAR(Z.JRN_DATETIME, 'YYYYMM', 'NLS_CALENDAR=PERSIAN')) >
       TO_NUMBER('&YEAR' || '&MM')
 ORDER BY Z.MATERIAL_TRANSACTION_ID
         ,Z.JRN_DATETIME
         ,Z.JRN_ID
         ,Z.JRN_OPERATION
