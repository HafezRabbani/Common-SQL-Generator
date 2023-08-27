SELECT II.DELIVERY_POINTS_ID
      ,II.CCNTR_COD_CC_CCNTR
      ,II.COD_DELIVEY_POINT_MDELP
       --      ,II.NUM_TEL_MDELP
       --      ,II.EMPLY_NUM_PRSN_EMPLY
       --      ,II.EMPLY_NUM_PRSN_EMPLY_FOR
      ,II.DES_DELIVEY_POINT_MDELP
      ,II.USER_NAME_MDELP
      ,(SELECT U.NAM_USER_USRS
          FROM FND.FND_USERS U
         WHERE U.IDE_USER_USRS = II.USER_NAME_MDELP) AS FND_USER_NAME_MDELP
      ,II.USER_MANAGER_ID_MDELP
      ,(SELECT U.NAM_USER_USRS
          FROM FND.FND_USERS U
         WHERE U.IDE_USER_USRS = II.USER_MANAGER_ID_MDELP) AS FND_USER_MANAGER_ID_MDELP
      ,II.FLG_DISABLE_MDELP
      ,II.LKP_TYP_MDELP
      ,APPS.APP_FND_LOOKUP_PKG.GET_FARSI_MEANING_FUN(UPPER('MAM_DELIVERY_POINTS')
                                                    ,UPPER('LKP_TYP_MDELP')
                                                    ,II.LKP_TYP_MDELP) AS LKP_TYP_MDELP_DES
  FROM MAM.MAM_DELIVERY_POINTS II
/*
LEFT OUTER JOIN COA.COA_COST_CENTERS A1 ON 
II.CCNTR_COD_CC_CCNTR = A1.COD_CC_CCNTR
LEFT OUTER JOIN PDS.PDS_EMPLOYEES A3 ON 
II.EMPLY_NUM_PRSN_EMPLY = A3.NUM_PRSN_EMPLY
LEFT OUTER JOIN PDS.PDS_EMPLOYEES A2 ON 
II.EMPLY_NUM_PRSN_EMPLY_FOR = A2.NUM_PRSN_EMPLY
*/
 WHERE 1 = 1
      --
      --       AND LKP_TYP_MDELP = 1
      --AND (II.USER_NAME_MDELP = UPPER(TRIM('&IDE_USER_USRS')) OR II.USER_MANAGER_ID_MDELP = UPPER(TRIM('&IDE_USER_USRS')))
  AND II.CCNTR_COD_CC_CCNTR IN (&CC)
--       AND II.DELIVERY_POINTS_ID IN(&DELIVERY_POINTS_ID)
 ORDER BY II.CCNTR_COD_CC_CCNTR
   FOR UPDATE
