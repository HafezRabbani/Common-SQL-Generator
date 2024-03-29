SELECT O.ORDER_ID
      ,O.NUM_PGV_PUROR
       
      ,O.LKP_COD_STEP_PUROR
      ,O.DAT_CUR_PGSS_PUROR
      ,TO_CHAR(O.DAT_CUR_PGSS_PUROR, 'YYYY/MM/DD HH24:MI:SS', 'NLS_CALENDAR=PERSIAN') AS DAT_CUR_PGSS_PUROR_H
      ,R.NUM_PGV_PURRQ
      ,R.LKP_TYP_REQ_PURRQ || ':' ||
       APPS.APP_FND_LOOKUP_PKG.GET_FARSI_MEANING_FUN(UPPER('PUR_REQUESTS'), UPPER('LKP_TYP_REQ_PURRQ'), R.LKP_TYP_REQ_PURRQ) AS LKP_TYP_REQ_PURRQ_DES
      ,CC.COD_CC_CCNTR || ':' || CC.DES_CC_CCNTR AS CC
      ,DP.DELIVERY_POINTS_ID AS DP_ID
      ,APPS.MAM_DELIVERY_POINTS_CTRL_PKG.GET_DESCRIPTION(P_DELIVERY_POINTS_ID => DP.DELIVERY_POINTS_ID) AS DP_DES
      ,DP.FLG_DISABLE_MDELP
      ,(SELECT U.IDE_USER_USRS || ': ' || U.NAM_USER_USRS
          FROM FND.FND_USERS U
         WHERE U.IDE_USER_USRS = DP.USER_NAME_MDELP) AS "���� �����"
       ,(SELECT U.IDE_USER_USRS || ': ' || U.NAM_USER_USRS
          FROM FND.FND_USERS U
         WHERE U.IDE_USER_USRS = DP.USER_MANAGER_ID_MDELP) AS "����� �����"
       ,O.SUPCO_THPRT_COD_THPRT || CASE
         WHEN O.SUPCO_THPRT_COD_THPRT IS NOT NULL THEN
          ': ' || (SELECT TP.DES_THPRT
                     FROM BFS.BFS_THIRD_PARTIES TP
                    WHERE TP.COD_THPRT = O.SUPCO_THPRT_COD_THPRT)
       END AS THIRD_PARTY
/*       
,R.DAT_STR_VALD_PURRQ
,TO_CHAR(R.DAT_STR_VALD_PURRQ
       ,'YYYY/MM/DD HH24:MI:SS'
       ,'NLS_CALENDAR=PERSIAN') AS DAT_STR_VALD_PURRQ_H
,R.PAYCN_COD_PYM_PAYCN
,R.DES_SHO1_PURRQ
,R.DES_SHO2_PURRQ
,R.DAT_DOC_ISU_PURRQ
,TO_CHAR(R.DAT_DOC_ISU_PURRQ
       ,'YYYY/MM/DD HH24:MI:SS'
       ,'NLS_CALENDAR=PERSIAN') AS DAT_DOC_ISU_PURRQ_H
,R.DAT_END_VALD_PURRQ
,TO_CHAR(R.DAT_END_VALD_PURRQ
       ,'YYYY/MM/DD HH24:MI:SS'
       ,'NLS_CALENDAR=PERSIAN') AS DAT_END_VALD_PURRQ_H
,R.AMN_CUR_PURRQ
,R.DAT_CUR_PGSS_PURRQ
,TO_CHAR(R.DAT_CUR_PGSS_PURRQ
       ,'YYYY/MM/DD HH24:MI:SS'
       ,'NLS_CALENDAR=PERSIAN') AS DAT_CUR_PGSS_PURRQ_H
,R.BUYER_COD_PUR_BUYER
,R.CCNTR_COD_CC_CCNTR
,R.TXT_USR_PURRQ
,R.TOT_NUM_POS_PURRQ
,R.TOT_SUS_DAYS_PURRQ
,R.DAT_STR_SUS_PURRQ
,TO_CHAR(R.DAT_STR_SUS_PURRQ
       ,'YYYY/MM/DD HH24:MI:SS'
       ,'NLS_CALENDAR=PERSIAN') AS DAT_STR_SUS_PURRQ_H
,R.DAT_END_SUS_PURRQ
,TO_CHAR(R.DAT_END_SUS_PURRQ
       ,'YYYY/MM/DD HH24:MI:SS'
       ,'NLS_CALENDAR=PERSIAN') AS DAT_END_SUS_PURRQ_H
,R.DAT_ISU_INQ_PURRQ
,TO_CHAR(R.DAT_ISU_INQ_PURRQ
       ,'YYYY/MM/DD HH24:MI:SS'
       ,'NLS_CALENDAR=PERSIAN') AS DAT_ISU_INQ_PURRQ_H
,R.DAT_STR_INQ_PURRQ
,TO_CHAR(R.DAT_STR_INQ_PURRQ
       ,'YYYY/MM/DD HH24:MI:SS'
       ,'NLS_CALENDAR=PERSIAN') AS DAT_STR_INQ_PURRQ_H
,R.DAT_END_INQ_PURRQ
,TO_CHAR(R.DAT_END_INQ_PURRQ
       ,'YYYY/MM/DD HH24:MI:SS'
       ,'NLS_CALENDAR=PERSIAN') AS DAT_END_INQ_PURRQ_H
,R.DAT_STR_JOB_PURRQ
,TO_CHAR(R.DAT_STR_JOB_PURRQ
       ,'YYYY/MM/DD HH24:MI:SS'
       ,'NLS_CALENDAR=PERSIAN') AS DAT_STR_JOB_PURRQ_H
,R.DAT_END_JOB_PURRQ
,TO_CHAR(R.DAT_END_JOB_PURRQ
       ,'YYYY/MM/DD HH24:MI:SS'
       ,'NLS_CALENDAR=PERSIAN') AS DAT_END_JOB_PURRQ_H
,R.AMN_TRNS_PURRQ
,R.LKP_TYP_DOC_PURRQ
,APPS.APP_FND_LOOKUP_PKG.GET_FARSI_MEANING_FUN(UPPER('PUR_REQUESTS')
                                             ,UPPER('LKP_TYP_DOC_PURRQ')
                                             ,R.LKP_TYP_DOC_PURRQ) AS LKP_TYP_DOC_PURRQ_DES
,R.LKP_TYP_INQ_PURRQ
,APPS.APP_FND_LOOKUP_PKG.GET_FARSI_MEANING_FUN(UPPER('PUR_REQUESTS')
                                             ,UPPER('LKP_TYP_INQ_PURRQ')
                                             ,R.LKP_TYP_INQ_PURRQ) AS LKP_TYP_INQ_PURRQ_DES
,R.LKP_TYP_DEBT_PURRQ
,APPS.APP_FND_LOOKUP_PKG.GET_FARSI_MEANING_FUN(UPPER('PUR_REQUESTS')
                                             ,UPPER('LKP_TYP_DEBT_PURRQ')
                                             ,R.LKP_TYP_DEBT_PURRQ) AS LKP_TYP_DEBT_PURRQ_DES
,R.LKP_TYP_DLV_PURRQ
,APPS.APP_FND_LOOKUP_PKG.GET_FARSI_MEANING_FUN(UPPER('PUR_REQUESTS')
                                             ,UPPER('LKP_TYP_DLV_PURRQ')
                                             ,R.LKP_TYP_DLV_PURRQ) AS LKP_TYP_DLV_PURRQ_DES
,R.LKP_COD_STEP_PURRQ
,APPS.APP_FND_LOOKUP_PKG.GET_FARSI_MEANING_FUN(UPPER('PUR_REQUESTS')
                                             ,UPPER('LKP_COD_STEP_PURRQ')
                                             ,R.LKP_COD_STEP_PURRQ) AS LKP_COD_STEP_PURRQ_DES
,R.LKP_COD_SUS_PURRQ
,APPS.APP_FND_LOOKUP_PKG.GET_FARSI_MEANING_FUN(UPPER('PUR_REQUESTS')
                                             ,UPPER('LKP_COD_SUS_PURRQ')
                                             ,R.LKP_COD_SUS_PURRQ) AS LKP_COD_SUS_PURRQ_DES
,R.LKP_TYP_CNT_PURRQ
,APPS.APP_FND_LOOKUP_PKG.GET_FARSI_MEANING_FUN(UPPER('PUR_REQUESTS')
                                             ,UPPER('LKP_TYP_CNT_PURRQ')
                                             ,R.LKP_TYP_CNT_PURRQ) AS LKP_TYP_CNT_PURRQ_DES
,R.LKP_COD_MAKE_BUYE_PURRQ
,APPS.APP_FND_LOOKUP_PKG.GET_FARSI_MEANING_FUN(UPPER('PUR_REQUESTS')
                                             ,UPPER('LKP_COD_MAKE_BUYE_PURRQ')
                                             ,R.LKP_COD_MAKE_BUYE_PURRQ) AS LKP_COD_MAKE_BUYE_PURRQ_DES
,R.CREATE_DATE
,R.CREATE_BY_DB_USER
,R.CREATE_BY_APP_USER
,R.LAST_UPDATE_DATE
,R.LAST_UPDATE_BY_DB_USER
,R.LAST_UPDATE_BY_APP_USER
,R.ATTACH_ID
,R.FLG_UNDER_CNT_PURRQ
,R.DAT_EXTEND_INQ_PURRQ
,TO_CHAR(R.DAT_EXTEND_INQ_PURRQ
       ,'YYYY/MM/DD HH24:MI:SS'
       ,'NLS_CALENDAR=PERSIAN') AS DAT_EXTEND_INQ_PURRQ_H
,R.DAT_DEBTS_APPROVED_PURRQ
,TO_CHAR(R.DAT_DEBTS_APPROVED_PURRQ
       ,'YYYY/MM/DD HH24:MI:SS'
       ,'NLS_CALENDAR=PERSIAN') AS DAT_DEBTS_APPROVED_PURRQ_H
,R.FLG_DEBTS_APPROVED_PURRQ
,R.MDELP_DELIVERY_POINTS_ID
,R.DES_REJECT_PURRQ
,R.DAT_VALD_INQUIRY_PURRQ
,TO_CHAR(R.DAT_VALD_INQUIRY_PURRQ
       ,'YYYY/MM/DD HH24:MI:SS'
       ,'NLS_CALENDAR=PERSIAN') AS DAT_VALD_INQUIRY_PURRQ_H
,R.DES_INQ_PURRQ
,R.LKP_COD_MONEY_PURRQ
,APPS.APP_FND_LOOKUP_PKG.GET_FARSI_MEANING_FUN(UPPER('PUR_REQUESTS')
                                             ,UPPER('LKP_COD_MONEY_PURRQ')
                                             ,R.LKP_COD_MONEY_PURRQ) AS LKP_COD_MONEY_PURRQ_DES
,R.LKP_TYP_DEAL_PURRQ
,APPS.APP_FND_LOOKUP_PKG.GET_FARSI_MEANING_FUN(UPPER('PUR_REQUESTS')
                                             ,UPPER('LKP_TYP_DEAL_PURRQ')
                                             ,R.LKP_TYP_DEAL_PURRQ) AS LKP_TYP_DEAL_PURRQ_DES
,R.FLG_OPEN_CONTRACT_PURRQ
,R.DES_PUR_ADMIN_PURRQ
,R.DES_CDEAL_PURRQ
,R.NAM_SUGG_SUPP_PURRQ
,R.FLG_CDL_PURRQ
,R.LKP_LEVEL_BARGAIN_PURRQ
,APPS.APP_FND_LOOKUP_PKG.GET_FARSI_MEANING_FUN(UPPER('PUR_REQUESTS')
                                             ,UPPER('LKP_LEVEL_BARGAIN_PURRQ')
                                             ,R.LKP_LEVEL_BARGAIN_PURRQ) AS LKP_LEVEL_BARGAIN_PURRQ_DES
,R.LKP_COD_CLOSE_PURRQ
,APPS.APP_FND_LOOKUP_PKG.GET_FARSI_MEANING_FUN(UPPER('PUR_REQUESTS')
                                             ,UPPER('LKP_COD_CLOSE_PURRQ')
                                             ,R.LKP_COD_CLOSE_PURRQ) AS LKP_COD_CLOSE_PURRQ_DES
*/
  FROM PUR.PUR_ORDERS --
       -- JRN.PUR_ORDERS_JRN --
        O
 INNER JOIN PUR.PUR_REQUESTS R
    ON EXISTS (SELECT NULL
          FROM PUR.PUR_ORDER_POSITIONS OP
         INNER JOIN PUR.PUR_REQUEST_POSITIONS RP
            ON OP.PURRP_PURRP_ID = RP.PURRP_ID
         WHERE OP.PUROR_ORDER_ID = O.ORDER_ID
               AND RP.PURRQ_NUM_PGV_PURRQ = R.NUM_PGV_PURRQ)
--  LEFT OUTER JOIN PUR.PUR_BUYERS B    ON R.BUYER_COD_PUR_BUYER = B.COD_PUR_BUYER
  LEFT OUTER JOIN COA.COA_COST_CENTERS CC
    ON R.CCNTR_COD_CC_CCNTR = CC.COD_CC_CCNTR
  LEFT OUTER JOIN MAM.MAM_DELIVERY_POINTS DP
    ON R.MDELP_DELIVERY_POINTS_ID = DP.DELIVERY_POINTS_ID
 WHERE 1 = 1
       AND O.NUM_MDF_PUROR = 0
       AND O.NUM_PGV_PUROR = &NUM_PGV_PUROR
--       AND R.NUM_PGV_PURRQ = &NUM_PGV_PURRQ
/*      
       AND EXISTS
 (SELECT NULL
          FROM PUR.PUR_ORDER_POSITIONS OP1
         INNER JOIN PUR.PUR_REQUEST_POSITIONS RP1
            ON OP1.PURRP_PURRP_ID = RP1.PURRP_ID
         INNER JOIN MAM.MAM_ITEMS I1
            ON RP1.ITEM_ITEM_ID = I1.ITEM_ID
         WHERE OP1.PUROR_ORDER_ID = O.ORDER_ID
               AND RP1.PURRQ_NUM_PGV_PURRQ = R.NUM_PGV_PURRQ
               AND I1.COD_ITEM IN (&COD_ITEM))
*/
