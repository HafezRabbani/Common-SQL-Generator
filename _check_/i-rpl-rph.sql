SELECT H.NUM_REPLENISHMENT_MREPH
      ,H.DAT_REPLENISHMENT_MREPH
      ,H.*
  FROM MAM.MAM_REPLENISH_HEADERS H
 WHERE 1 = 1
       AND H.NUM_REPLENISHMENT_MREPH LIKE '&NUM_REPLENISHMENT_MREPH'
--   FOR UPDATE
--
;

SELECT L.REPLENISH_LINE_ID
      ,L.LKP_STA_REPLENISHMENT_MREPL || CASE
         WHEN L.LKP_STA_REPLENISHMENT_MREPL IS NOT NULL THEN
          ': '
       END ||
       APPS.APP_FND_LOOKUP_PKG.GET_FARSI_MEANING_FUN(UPPER('MAM_REPLENISH_LINES')
                                                    ,UPPER('LKP_STA_REPLENISHMENT_MREPL')
                                                    ,L.LKP_STA_REPLENISHMENT_MREPL) AS LKP_STA_REPLENISHMENT_MREP_DES
      ,L.LKP_STA_REPLENISHMENT_MREPL
      ,(SELECT H.LKP_STA_REPLENISHMENT_MREPH || CASE
                 WHEN L.LKP_STA_REPLENISHMENT_MREPL IS NOT NULL THEN
                  ': '
               END ||
               APPS.APP_FND_LOOKUP_PKG.GET_FARSI_MEANING_FUN(UPPER('MAM_REPLENISH_HEADERS')
                                                            ,UPPER('LKP_STA_REPLENISHMENT_MREPH')
                                                            ,H.LKP_STA_REPLENISHMENT_MREPH)
          FROM MAM.MAM_REPLENISH_HEADERS H
         WHERE L.MREPH_REPLENISH_HEADER_ID = H.REPLENISH_HEADER_ID) AS LKP_STA_REPLENISHMENT_MREPHDES
      ,(SELECT H.NUM_REPLENISHMENT_MREPH
          FROM MAM.MAM_REPLENISH_HEADERS H
         WHERE L.MREPH_REPLENISH_HEADER_ID = H.REPLENISH_HEADER_ID) AS NUM_REPLENISHMENT_MREPH
      ,(SELECT I.COD_ITEM || ': ' || I.DES_ITEM
          FROM MAM.MAM_ITEMS I
         WHERE L.ITEM_ITEM_ID = I.ITEM_ID) AS ITEM
      ,(SELECT SUM(Q.QTY_MONH)
          FROM MAM.MAM_ONHAND_QUANTITIES Q
         WHERE Q.ITEM_ITEM_ID = L.ITEM_ITEM_ID) AS SQTY_MONH
      ,(SELECT SUM(X.QTY_PRIMARY_MTRAN)
          FROM MAM.MAM_MATERIAL_TRANSACTIONS X
         WHERE X.ITEM_ITEM_ID_FOR = L.ITEM_ITEM_ID) AS SQTY_PRIMARY_MTRAN
      ,L.ITEM_ITEM_ID
      ,L.BUYER_COD_PUR_BUYER
      ,L.MREPH_REPLENISH_HEADER_ID
       
      ,L.NAM_UNIT_OF_MEASURE_MREPL
      ,L.NUM_LINE_REPLENISHMENT_MREPL
      ,L.QTY_REPLENISHMENT_MREPL
      ,L.DAT_APPROVE_MREPL
      ,TO_CHAR(L.DAT_APPROVE_MREPL
              ,'YYYY/MM/DD HH24:MI:SS'
              ,'NLS_CALENDAR=PERSIAN') AS DAT_APPROVE_MREPL_H
      ,L.DAT_END_REQUIREMENT_MREPL
      ,TO_CHAR(L.DAT_END_REQUIREMENT_MREPL
              ,'YYYY/MM/DD HH24:MI:SS'
              ,'NLS_CALENDAR=PERSIAN') AS DAT_END_REQUIREMENT_MREPL_H
      ,L.DAT_START_REQUIREMENT_MREPL
      ,TO_CHAR(L.DAT_START_REQUIREMENT_MREPL
              ,'YYYY/MM/DD HH24:MI:SS'
              ,'NLS_CALENDAR=PERSIAN') AS DAT_START_REQUIREMENT_MREPL_H
      ,L.DAT_SUSPEND_MREPL
      ,TO_CHAR(L.DAT_SUSPEND_MREPL
              ,'YYYY/MM/DD HH24:MI:SS'
              ,'NLS_CALENDAR=PERSIAN') AS DAT_SUSPEND_MREPL_H
      ,L.LKP_COD_SUSPEND_MREPL
      ,L.LKP_COD_SUSPEND_MREPL || CASE
         WHEN L.LKP_COD_SUSPEND_MREPL IS NOT NULL THEN
          ': '
       END ||
       APPS.APP_FND_LOOKUP_PKG.GET_FARSI_MEANING_FUN(UPPER('MAM_REPLENISH_LINES')
                                                    ,UPPER('LKP_COD_SUSPEND_MREPL')
                                                    ,L.LKP_COD_SUSPEND_MREPL) AS LKP_COD_SUSPEND_MREPL_DES
      ,L.TXT_COMMENT_MREPL
      ,L.LKP_FLG_REPLENISHMENT_MREPL
      ,L.LKP_FLG_REPLENISHMENT_MREPL || CASE
         WHEN L.LKP_FLG_REPLENISHMENT_MREPL IS NOT NULL THEN
          ': '
       END ||
       APPS.APP_FND_LOOKUP_PKG.GET_FARSI_MEANING_FUN(UPPER('MAM_REPLENISH_LINES')
                                                    ,UPPER('LKP_FLG_REPLENISHMENT_MREPL')
                                                    ,L.LKP_FLG_REPLENISHMENT_MREPL) AS LKP_FLG_REPLENISHMENT_MREP_DES
  FROM MAM.MAM_REPLENISH_LINES L
 WHERE 1 = 1
       AND EXISTS
 (SELECT NULL
          FROM MAM.MAM_REPLENISH_HEADERS H
         WHERE L.MREPH_REPLENISH_HEADER_ID = H.REPLENISH_HEADER_ID
               AND H.NUM_REPLENISHMENT_MREPH LIKE '&NUM_REPLENISHMENT_MREPH')
--   FOR UPDATE
--
;

SELECT ITEM_ID
      ,I.COD_ITEM
      ,I.DES_ITEM
      ,I.LKP_STA_INVENTORY_ITEM || ': ' ||
       APPS.APP_FND_LOOKUP_PKG.GET_FARSI_MEANING_FUN(UPPER('MAM_ITEMS')
                                                    ,UPPER('LKP_STA_INVENTORY_ITEM')
                                                    ,I.LKP_STA_INVENTORY_ITEM) AS LKP_STA_INVENTORY_ITEM_DES
      ,(SELECT P.COD_PLANNER_MPLNR || ': ' || US.NAM_USER_USRS
          FROM MAM.MAM_PLANNERS P
         INNER JOIN FND.FND_USERS US
            ON P.COD_USER_MPLNR = US.IDE_USER_USRS
         WHERE P.COD_PLANNER_MPLNR = I.MPLNR_COD_PLANNER_MPLNR) AS PLANNER
       
      ,H.NUM_REPLENISHMENT_MREPH
      ,H.DAT_REPLENISHMENT_MREPH
      ,L.LKP_STA_REPLENISHMENT_MREPL
  FROM MAM.MAM_ITEMS I
 INNER JOIN --
MAM.MAM_REPLENISH_LINES --
-- JRN.MAM_REPLENISH_LINES_JRN--
L
    ON L.ITEM_ITEM_ID = I.ITEM_ID
 INNER JOIN MAM.MAM_REPLENISH_HEADERS H
    ON L.MREPH_REPLENISH_HEADER_ID = H.REPLENISH_HEADER_ID
 WHERE 1 = 1
      --       AND I.COD_ITEM = &COD_ITEM
      --       AND I.DES_ITEM LIKE '%&DES_ITEM%'
       AND H.NUM_REPLENISHMENT_MREPH LIKE '&NUM_REPLENISHMENT_MREPH'
--
;
