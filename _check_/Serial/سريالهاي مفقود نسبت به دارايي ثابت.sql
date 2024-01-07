SELECT (SELECT I.COD_ITEM
          FROM MAM.MAM_ITEMS I
         WHERE I.ITEM_ID = S.ITEM_ITEM_ID) AS "„›ﬁÊœ œ— FIA"
       ,S.SERIAL_NUMBER_ID
  FROM MAM.MAM_SERIAL_NUMBERS S
 WHERE 1 = 1
       AND EXISTS (SELECT NULL
          FROM MAM.MAM_ITEMS I
         WHERE I.ITEM_ID = S.ITEM_ITEM_ID
               AND I.COD_ITEM = '&COD_ITEM')
MINUS
SELECT (SELECT I.COD_ITEM
          FROM MAM.MAM_ITEMS I
         WHERE I.ITEM_ID = FA.ITEM_ITEM_ID) AS "„›ﬁÊœ œ— FIA"
       ,FA.MSER_SERIAL_NUMBER_ID
  FROM FIA.FIA_FIXED_ASSETS FA
 WHERE 1 = 1
       AND EXISTS (SELECT NULL
          FROM MAM.MAM_ITEMS I
         WHERE I.ITEM_ID = FA.ITEM_ITEM_ID
               AND I.COD_ITEM = '&COD_ITEM')
--
;
SELECT (SELECT I.COD_ITEM
          FROM MAM.MAM_ITEMS I
         WHERE I.ITEM_ID = FA.ITEM_ITEM_ID) AS "„›ﬁÊœ œ— MAM"
       ,FA.MSER_SERIAL_NUMBER_ID
  FROM FIA.FIA_FIXED_ASSETS FA
 WHERE 1 = 1
       AND EXISTS (SELECT NULL
          FROM MAM.MAM_ITEMS I
         WHERE I.ITEM_ID = FA.ITEM_ITEM_ID
               AND I.COD_ITEM = '&COD_ITEM')
MINUS
SELECT (SELECT I.COD_ITEM
          FROM MAM.MAM_ITEMS I
         WHERE I.ITEM_ID = S.ITEM_ITEM_ID) AS "„›ﬁÊœ œ— MAM"
       ,S.SERIAL_NUMBER_ID
  FROM MAM.MAM_SERIAL_NUMBERS S
 WHERE 1 = 1
       AND EXISTS (SELECT NULL
          FROM MAM.MAM_ITEMS I
         WHERE I.ITEM_ID = S.ITEM_ITEM_ID
               AND I.COD_ITEM = '&COD_ITEM')
--
;
SELECT (SELECT I.COD_ITEM
          FROM MAM.MAM_ITEMS I
         WHERE I.ITEM_ID = FA.ITEM_ITEM_ID) AS "„›ﬁÊœ œ— MAM"
       ,FA.MSER_SERIAL_NUMBER_ID
  FROM FIA.FIA_FIXED_ASSETS FA
 WHERE 1 = 1
       AND EXISTS (SELECT NULL
          FROM MAM.MAM_ITEMS I
         WHERE I.ITEM_ID = FA.ITEM_ITEM_ID
               AND I.COD_ITEM = '&COD_ITEM')
MINUS
SELECT (SELECT I.COD_ITEM
          FROM MAM.MAM_ITEMS I
         WHERE I.ITEM_ID = S.ITEM_ITEM_ID) AS "„›ﬁÊœ œ— MAM"
       ,S.SERIAL_NUMBER_ID
  FROM MAM.MAM_SERIAL_NUMBERS S
 WHERE 1 = 1
       AND EXISTS
 (SELECT NULL
          FROM MAM.MAM_ITEMS I
         WHERE I.ITEM_ID = S.ITEM_ITEM_ID
               AND I.COD_ITEM = '&COD_ITEM')
       AND ( --
        EXISTS ( --
                    SELECT NULL
                      FROM MAM.MAM_TRANSACTION_SERIAL_NUMBERS XS
                     INNER JOIN MAM.MAM_MATERIAL_TRANSACTIONS X
                        ON XS.MTRAN_MATERIAL_TRANSACTION_ID =
                           X.MATERIAL_TRANSACTION_ID
                     WHERE XS.MSER_SERIAL_NUMBER_ID = S.SERIAL_NUMBER_ID
                           AND
                           X.DAT_TRANSACTION_MTRAN <
                           TO_DATE('1400/01/01', 'yyyy/mm/dd', 'nls_calendar=persian')
                    --
                    ) OR EXISTS
        ( --
             SELECT NULL
               FROM MAM.MAM_RCV_SERIAL_TRANSACTIONS RXS
              INNER JOIN MAM.MAM_RCV_TRANSACTIONS RX
                 ON RXS.MRCV_RCV_TRANSACTION_ID = RX.RCV_TRANSACTION_ID
              WHERE RXS.ITEM_ITEM_ID = S.ITEM_ITEM_ID
                    AND UPPER(TRIM(RXS.NUM_SERIAL_MRCVS)) =
                    UPPER(TRIM(S.COD_SERIAL_NUMBER_MSER))
                    AND
                    RX.DAT_TRANSACTION_MRCV <
                    TO_DATE('1400/01/01', 'yyyy/mm/dd', 'nls_calendar=persian')
             --
             )
       
       --
       )
--
;
