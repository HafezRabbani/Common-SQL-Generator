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
      ,APPS.APP_FND_LOOKUP_PKG.GET_FARSI_MEANING_FUN(UPPER('MAM_TRANSACTION_TYPES'), UPPER('LKP_COD_TRANSACTION_ACTION_MTY'), TT.LKP_COD_TRANSACTION_ACTION_MTY) AS LKP_COD_TRANSACTION_ACTION_DES
      ,TO_CHAR(TT.DAT_DISABLE_MTYP, 'YYYY/MM/DD HH24:MI:SS', 'NLS_CALENDAR=PERSIAN') AS DAT_DISABLE_MTYP_H
      ,APPS.APP_FND_LOOKUP_PKG.GET_FARSI_MEANING_FUN(UPPER('MAM_TRANSACTION_TYPES'), UPPER('LKP_COD_ACTION_MTYP'), TT.LKP_COD_ACTION_MTYP) AS LKP_COD_ACTION_MTYP_DES
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
