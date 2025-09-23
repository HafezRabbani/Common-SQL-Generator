SELECT Z.TRANSACTION_TYPE_ID
      ,Z.NAM_TRANSACTION_TYPE_MTYP
       --      ,Z.DES_MTYP
      ,CASE
         WHEN Z.EXISTING_FUNCTION IS NULL THEN
          Z.FUNCTION_NAME
       END AS ABSENT_FUNCTION
      ,Z.HAS_RECORDS
      ,Z.HAS_TIED_RECORDS
      ,CASE
         WHEN Z.EXISTING_FUNCTION IS NULL AND Z.HAS_RECORDS IS NOT NULL THEN
          'œ— «Ê·ÊÌ  «ÌÃ«œ'
       END AS IMPORTANT
      ,CASE
         WHEN 1 = 0 OR EXISTS
          (SELECT NULL
                 FROM --
                      JRN.MAM_MATERIAL_TRANSACTIONS_JRN J
                WHERE J.MTYP_TRANSACTION_TYPE_ID = Z.TRANSACTION_TYPE_ID
                  AND SUBSTR(J.JRN_PROGRAM, 1, 4) IN ( --
                                                      UPPER('FIRM')
                                                     ,UPPER('FPMS')
                                                     ,UPPER('FQUM')
                                                     ,UPPER('FROM')
                                                     ,UPPER('FRPS')
                                                     ,UPPER('FSHP')
                                                      --
                                                      )) OR EXISTS
          (SELECT NULL
                 FROM MAM.MAM_MATERIAL_TRANSACTIONS X
                WHERE X.MTYP_TRANSACTION_TYPE_ID = Z.TRANSACTION_TYPE_ID
                  AND SUBSTR(X.MODULE_NAME, 1, 4) IN ( --
                                                      UPPER('FIRM')
                                                     ,UPPER('FPMS')
                                                     ,UPPER('FQUM')
                                                     ,UPPER('FROM')
                                                     ,UPPER('FRPS')
                                                     ,UPPER('FSHP')
                                                      --
                                                      )) THEN
          'NEEDS LKP COD SYSTEM'
       END AS NEEDS_LKP_COD_SYSTEM
  FROM ( --
        SELECT TT.TRANSACTION_TYPE_ID
               ,TT.NAM_TRANSACTION_TYPE_MTYP
               ,TT.DES_MTYP
               ,UPPER('APP_MAM_MATERIAL_TRANSCTNS_PKG.') || 'INSERT_X' ||
                TT.TRANSACTION_TYPE_ID || '_FUN' AS FUNCTION_NAME
               ,CASE
                  WHEN EXISTS (SELECT NULL
                          FROM ALL_PROCEDURES T
                         WHERE T.OBJECT_NAME =
                               UPPER('app_mam_material_transctns_pkg')
                           AND T.PROCEDURE_NAME = CASE
                                 WHEN TT.TRANSACTION_TYPE_ID IN (25, 26) THEN
                                  UPPER('INSERT_X25_X26_FUN')
                                 ELSE
                                  UPPER('INSERT_X' ||
                                        TT.TRANSACTION_TYPE_ID || '_FUN') --
                               END) THEN
                   UPPER('APP_MAM_MATERIAL_TRANSCTNS_PKG.') || 'INSERT_X' ||
                   TT.TRANSACTION_TYPE_ID || '_FUN'
                END AS EXISTING_FUNCTION
               ,CASE
                  WHEN EXISTS (SELECT NULL
                          FROM MAM.MAM_MATERIAL_TRANSACTIONS X
                         WHERE X.MTYP_TRANSACTION_TYPE_ID =
                               TT.TRANSACTION_TYPE_ID) THEN
                   'œ«—«Ì ê—œ‘ À»  ‘œÂ'
                END AS HAS_RECORDS
               ,CASE
                  WHEN EXISTS (SELECT NULL
                          FROM MAM.MAM_MATERIAL_TRANSACTIONS X
                         WHERE X.MTYP_TRANSACTION_TYPE_ID =
                               TT.TRANSACTION_TYPE_ID
                           AND X.ID_TRANSFER_MTRAN IS NOT NULL) THEN
                   'œ«—«Ì ê—œ‘ „ ﬁ«»·'
                END AS HAS_TIED_RECORDS
               ,APPS.APP_FND_LOOKUP_PKG.GET_FARSI_MEANING_FUN(UPPER('MAM_TRANSACTION_TYPES')
                                                             ,UPPER('LKP_COD_TRANSACTION_ACTION_MTY')
                                                             ,TT.LKP_COD_TRANSACTION_ACTION_MTY) AS LKP_COD_TRANSACTION_ACTION_DES
               ,TO_CHAR(TT.DAT_DISABLE_MTYP
                       ,'YYYY/MM/DD HH24:MI:SS'
                       ,'NLS_CALENDAR=PERSIAN') AS DAT_DISABLE_MTYP_H
               ,APPS.APP_FND_LOOKUP_PKG.GET_FARSI_MEANING_FUN(UPPER('MAM_TRANSACTION_TYPES')
                                                             ,UPPER('LKP_COD_ACTION_MTYP')
                                                             ,TT.LKP_COD_ACTION_MTYP) AS LKP_COD_ACTION_MTYP_DES
          FROM MAM.MAM_TRANSACTION_TYPES TT
         WHERE 1 = 1
        --
        --       AND TT.TRANSACTION_TYPE_ID IN (&TRANSACTION_TYPE_ID)
         ORDER BY CASE
                     WHEN TT.TRANSACTION_TYPE_ID < 10 THEN
                      0
                     ELSE
                      1
                   END
                  ,RPAD(TT.TRANSACTION_TYPE_ID, 6, '0')
                  ,TT.TRANSACTION_TYPE_ID
        --
        ) Z
 WHERE '&SHOW_CALCULATIONS' IS NOT NULL
--
;
SELECT TT.TRANSACTION_TYPE_ID
      ,TT.NAM_TRANSACTION_TYPE_MTYP
      ,TT.DES_MTYP
      ,TT.LKP_COD_TRANSACTION_ACTION_MTY
      ,TT.DAT_DISABLE_MTYP
      ,TT.MSTP_SOURCE_TYPE_ID
      ,TT.TYP_USER_MTYP
      ,TT.LKP_COD_ACTION_MTYP
       --,TT.COD_GRP_FIN_MTYP
       --,TT.FITGR_FIN_ITEM_GROUP_ID
       
      ,APPS.APP_FND_LOOKUP_PKG.GET_FARSI_MEANING_FUN(UPPER('MAM_TRANSACTION_TYPES')
                                                    ,UPPER('LKP_COD_TRANSACTION_ACTION_MTY')
                                                    ,TT.LKP_COD_TRANSACTION_ACTION_MTY) AS LKP_COD_TRANSACTION_ACTION_DES
      ,TO_CHAR(TT.DAT_DISABLE_MTYP
              ,'YYYY/MM/DD HH24:MI:SS'
              ,'NLS_CALENDAR=PERSIAN') AS DAT_DISABLE_MTYP_H
      ,APPS.APP_FND_LOOKUP_PKG.GET_FARSI_MEANING_FUN(UPPER('MAM_TRANSACTION_TYPES')
                                                    ,UPPER('LKP_COD_ACTION_MTYP')
                                                    ,TT.LKP_COD_ACTION_MTYP) AS LKP_COD_ACTION_MTYP_DES
  FROM MAM.MAM_TRANSACTION_TYPES TT
 WHERE 1 = 1
--
--       AND TT.TRANSACTION_TYPE_ID IN (&TRANSACTION_TYPE_ID)
 ORDER BY CASE
            WHEN TT.TRANSACTION_TYPE_ID < 10 THEN
             0
            ELSE
             1
          END
         ,RPAD(TT.TRANSACTION_TYPE_ID, 6, '0')
         ,TT.TRANSACTION_TYPE_ID
--   FOR UPDATE
