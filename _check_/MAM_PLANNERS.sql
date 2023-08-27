SELECT P.COD_PLANNER_MPLNR
      ,P.DES_MPLNR
      ,P.EMPLY_NUM_PRSN_EMPLY
      ,P.DAT_DISABLE_MPLNR
      ,TO_CHAR(P.DAT_DISABLE_MPLNR
              ,'YYYY/MM/DD HH24:MI:SS'
              ,'NLS_CALENDAR=PERSIAN') AS DAT_DISABLE_MPLNR_H
      ,P.COD_USER_MPLNR
      ,(SELECT U.NAM_USER_USRS
          FROM FND.FND_USERS U
         WHERE U.IDE_USER_USRS = P.COD_USER_MPLNR) AS NAM_USER_USRS
      ,P.TXT_EMAIL_MPLNR
      ,P.NUM_TEL_PLANNER_MPLNR
      ,P.DES_US_MPLNR
      ,P.LKP_TYP_MPLNR
      ,APPS.APP_FND_LOOKUP_PKG.GET_FARSI_MEANING_FUN(UPPER('MAM_PLANNERS')
                                                    ,UPPER('LKP_TYP_MPLNR')
                                                    ,P.LKP_TYP_MPLNR) AS LKP_TYP_MPLNR_DES
  FROM MAM.MAM_PLANNERS P
-- for update
