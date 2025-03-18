SELECT *
  FROM MAM.MAM_REQUEST_SERIAL_NUMBERS RS
 WHERE 1 = 1
   AND ( --
        EXISTS ( --
                SELECT NULL
                  FROM MAM.MAM_REQUEST_HEADERS H
                 INNER JOIN MAM.MAM_REQUEST_LINES L
                    ON H.REQUEST_HEADER_ID = L.MREQH_REQUEST_HEADER_ID
                 WHERE L.REQUEST_LINE_ID = RS.MREQL_REQUEST_LINE_ID
                      --AND H.NUM_REQUEST_MREQH LIKE TRIM('&NUM_REQUEST_LIKE')
                   AND H.NUM_REQUEST_MREQH IN (&NUM_REQUEST_IN)
                --
                )
       --
       )
--for update
