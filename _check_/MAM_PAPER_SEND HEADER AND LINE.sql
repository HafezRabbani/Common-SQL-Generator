SELECT H.PAPER_SEND_HEADER_ID AS ID
      ,H.*
  FROM MAM.MAM_PAPER_SEND_HEADERS H
 WHERE 1 = 1
       AND H.COD_PAPER_SEND_MPASH LIKE '%&COD_PAPER_SEND_MPASH%'
--
   FOR UPDATE
--
;
SELECT L.PAPER_SEND_LINE_ID AS ID
      ,L.MPASH_PAPER_SEND_HEADER_ID AS HEAD
      ,L.LKP_STA_MPASL
      ,APPS.APP_FND_LOOKUP_PKG.GET_FARSI_MEANING_FUN(UPPER('MAM_PAPER_SEND_LINES'), UPPER('LKP_STA_MPASL'), L.LKP_STA_MPASL) AS MAM_PAPER_SEND_LINES_DES
      ,L.*
  FROM MAM.MAM_PAPER_SEND_LINES L
 WHERE 1 = 1
       AND EXISTS
 ( --
        SELECT NULL
          FROM MAM.MAM_PAPER_SEND_HEADERS H
         WHERE H.PAPER_SEND_HEADER_ID = L.MPASH_PAPER_SEND_HEADER_ID
               AND H.COD_PAPER_SEND_MPASH LIKE '%&COD_PAPER_SEND_MPASH%'
        --
        )
--
   FOR UPDATE
--
;
