SELECT H.REQUEST_HEADER_ID
      ,H.NUM_REQUEST_MREQH
      ,H.LKP_STA_HEADER_MREQH
      ,H.*
  FROM MAM.MAM_REQUEST_HEADERS H
 WHERE 1 = 1
      --       AND H.NUM_REQUEST_MREQH LIKE TRIM('&NUM_REQUEST_LIKE')
   AND H.NUM_REQUEST_MREQH IN (&NUM_REQUEST_IN)
/*
       AND EXISTS
 (SELECT NULL
          FROM --
                MAM.MAM_REQUEST_LINES
               --
                 L
         WHERE L.MREQH_REQUEST_HEADER_ID = H.REQUEST_HEADER_ID
               AND ( --
                &COD_ITEM IS NULL OR EXISTS
                ( --
                     SELECT NULL
                       FROM MAM.MAM_ITEMS I
                      WHERE L.ITEM_ITEM_ID = I.ITEM_ID
                           --       AND I.COD_ITEM = TRIM(&COD_ITEM)
                            AND I.COD_ITEM LIKE TRIM(&COD_ITEM) || '%'
                     --
                     )
               --
               )
--
 )
*/
--   FOR UPDATE
--
;
SELECT L.REQUEST_LINE_ID
      ,( --
        SELECT I.COD_ITEM
          FROM MAM.MAM_ITEMS I
         WHERE L.ITEM_ITEM_ID = I.ITEM_ID
        --
        ) AS COD_ITEM
      ,( --
        SELECT H.NUM_REQUEST_MREQH
          FROM MAM.MAM_REQUEST_HEADERS H
         WHERE H.REQUEST_HEADER_ID = L.MREQH_REQUEST_HEADER_ID
        --
        ) AS NUM_REQUEST_MREQH
      ,(SELECT SUM(X.QTY_PRIMARY_MTRAN)
          FROM MAM.MAM_MATERIAL_TRANSACTIONS X
         WHERE X.MREQL_REQUEST_LINE_ID = L.REQUEST_LINE_ID) AS QTY_DELIVERED
      ,L.QTY_MREQL
      ,L.MREQH_REQUEST_HEADER_ID
      ,L.DAT_END_REQUIREMENT_MREQL
      ,TO_CHAR(L.DAT_END_REQUIREMENT_MREQL
              ,'YYYY/MM/DD HH24:MI:SS'
              ,'NLS_CALENDAR=PERSIAN') AS DAT_END_REQUIREMENT_MREQL_H
      ,L.ITEM_ITEM_ID
      ,L.NUM_LINE_MREQL
      ,L.LKP_STA_LINE_MREQL
      ,APPS.APP_FND_LOOKUP_PKG.GET_FARSI_MEANING_FUN(UPPER('MAM_REQUEST_LINES')
                                                    ,UPPER('LKP_STA_LINE_MREQL')
                                                    ,L.LKP_STA_LINE_MREQL) AS LKP_STA_LINE_MREQL_DES
      ,L.DAT_STATUS_MREQL
      ,TO_CHAR(L.DAT_STATUS_MREQL
              ,'YYYY/MM/DD HH24:MI:SS'
              ,'NLS_CALENDAR=PERSIAN') AS DAT_STATUS_MREQL_H
      ,L.QTY_PRIMARY_MREQL
      ,L.CCNTR_COD_CC_CCNTR
      ,L.MSINV_NAM_SUB_INVENTORY_MSIFOR
      ,L.QTY_DELIVERED_MREQL
      ,L.DAT_START_REQUIREMENT_MREQL
      ,TO_CHAR(L.DAT_START_REQUIREMENT_MREQL
              ,'YYYY/MM/DD HH24:MI:SS'
              ,'NLS_CALENDAR=PERSIAN') AS DAT_START_REQUIREMENT_MREQL_H
      ,L.NAM_UNIT_OF_MEASURE_MREQL
      ,L.NAM_UNIT_OF_MEASURE_PRIMARY_MR
      ,L.TXT_COMMENT_MREQL
      ,L.THPRT_COD_THPRT
      ,L.DES_ITEM_MREQL
--,L.TXT_RETURN_REQEUST_MREQL
  FROM --
        MAM.MAM_REQUEST_LINES
       -- JRN.MAM_REQUEST_LINES_JRN
       --
         L
 WHERE 1 = 1 --
      --
      --AND (&LKP_STA_LINE_MREQL IS NULL OR L.LKP_STA_LINE_MREQL != &LKP_STA_LINE_MREQL)
      --       AND       (&REQUEST_LINE_ID IS NULL OR L.REQUEST_LINE_ID = &REQUEST_LINE_ID)
      /*
            
             AND ( --
              &COD_ITEM IS NULL OR EXISTS
              ( --
                   SELECT NULL
                     FROM MAM.MAM_ITEMS I
                    WHERE L.ITEM_ITEM_ID = I.ITEM_ID
                         --       AND I.COD_ITEM = TRIM(&COD_ITEM)
                          AND I.COD_ITEM LIKE TRIM(&COD_ITEM) || '%'
                   --
                   )
             --
             )
      */
      
   AND ( --
        EXISTS ( --
                SELECT NULL
                  FROM MAM.MAM_REQUEST_HEADERS H
                 WHERE H.REQUEST_HEADER_ID = L.MREQH_REQUEST_HEADER_ID
                      --AND H.NUM_REQUEST_MREQH LIKE TRIM('&NUM_REQUEST_LIKE')
                   AND H.NUM_REQUEST_MREQH IN (&NUM_REQUEST_IN)
                --
                )
       --
       )
--   FOR UPDATE
--
;
SELECT (SELECT APPS.MAM_ITEMS_CTRL_PKG.GET_DESCRIPTION(P_ITEM_ID => S.ITEM_ITEM_ID)
          FROM MAM.MAM_SERIAL_NUMBERS S
         WHERE S.SERIAL_NUMBER_ID = RS.MSER_SERIAL_NUMBER_ID) AS ITEM
      ,RS.*
  FROM MAM.MAM_REQUEST_SERIAL_NUMBERS RS
 WHERE 1 = 1
   AND EXISTS ( --
        SELECT NULL
          FROM MAM.MAM_REQUEST_HEADERS H
         INNER JOIN MAM.MAM_REQUEST_LINES L
            ON H.REQUEST_HEADER_ID = L.MREQH_REQUEST_HEADER_ID
         WHERE L.REQUEST_LINE_ID = RS.MREQL_REQUEST_LINE_ID
           AND H.NUM_REQUEST_MREQH IN (&NUM_REQUEST_IN)
        --
        )
--   FOR UPDATE
--
;
