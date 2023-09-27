SELECT T.WF_NOTIFICATION_ID
      ,T.MREQL_REQUEST_LINE_ID
      ,T.COD_USER_FROM_MFNOT
      ,T.COD_USER_TO_MFNOT
      ,T.NUM_SECTION_MFNOT
      ,(SELECT H.NUM_REQUEST_MREQH
          FROM MAM.MAM_REQUEST_HEADERS H
         INNER JOIN MAM.MAM_REQUEST_LINES L
            ON L.MREQH_REQUEST_HEADER_ID = H.REQUEST_HEADER_ID
         WHERE L.REQUEST_LINE_ID = T.MREQL_REQUEST_LINE_ID) AS NUM_REQUEST_MREQH
      ,T.LKP_APPROVAL_STATUS_MFNOT
      ,T.LKP_LEVEL_MFNOT
      ,(SELECT L.LKP_STA_LINE_MREQL
          FROM MAM.MAM_REQUEST_LINES L
         WHERE L.REQUEST_LINE_ID = T.MREQL_REQUEST_LINE_ID) AS LKP_STA_LINE
      ,(SELECT H.LKP_STA_HEADER_MREQH
          FROM MAM.MAM_REQUEST_LINES L
         INNER JOIN MAM.MAM_REQUEST_HEADERS H
            ON H.REQUEST_HEADER_ID = L.MREQH_REQUEST_HEADER_ID
         WHERE L.REQUEST_LINE_ID = T.MREQL_REQUEST_LINE_ID) AS LKP_STA_HEADER
      ,T.*
  FROM MAM.MAM_WF_NOTIFICATIONS T
 WHERE 1 = 1
      --       AND T.MREQL_REQUEST_LINE_ID IN (&REQUEST_LINE_ID)
       AND EXISTS
 (SELECT NULL
          FROM MAM.MAM_REQUEST_HEADERS H
         INNER JOIN MAM.MAM_REQUEST_LINES L
            ON L.MREQH_REQUEST_HEADER_ID = H.REQUEST_HEADER_ID
         WHERE L.REQUEST_LINE_ID = T.MREQL_REQUEST_LINE_ID
               AND H.NUM_REQUEST_MREQH IN (&NUM_REQUEST_MREQH))

   FOR UPDATE
 ORDER BY T.NUM_SECTION_MFNOT
