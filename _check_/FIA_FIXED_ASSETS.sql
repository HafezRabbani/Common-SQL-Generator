SELECT FA.MSER_SERIAL_NUMBER_ID AS S_ID
      ,(SELECT S.LKP_STA_CURRENT_MSER
          FROM MAM.MAM_SERIAL_NUMBERS S
         WHERE S.SERIAL_NUMBER_ID = FA.MSER_SERIAL_NUMBER_ID) AS LKP_STA_CURRENT_MSER
      ,FA.NUM_ASSET_FIXAS
      ,(SELECT S.COD_SERIAL_NUMBER_MSER
          FROM MAM.MAM_SERIAL_NUMBERS S
         WHERE S.SERIAL_NUMBER_ID = FA.MSER_SERIAL_NUMBER_ID) AS COD_SERIAL_NUMBER
      ,FA.MRCV_RCV_TRANSACTION_ID
      ,(SELECT RX.NUM_RECEIPT_AP_MRCV || ' - ' ||
               RX.LKP_TYP_TRANSACTION_MRCV || ' @ ' ||
               TO_CHAR(RX.DAT_TRANSACTION_MRCV
                      ,'yyyy/mm/dd hh24:mi:ss'
                      ,'nls_calendar=persian')
          FROM MAM.MAM_RCV_TRANSACTIONS RX
         WHERE RX.RCV_TRANSACTION_ID = FA.MRCV_RCV_TRANSACTION_ID) AS RX
      ,CASE
         WHEN EXISTS (SELECT NULL
                 FROM MAM.MAM_RCV_SERIAL_TRANSACTIONS RXS
                INNER JOIN MAM.MAM_SERIAL_NUMBERS S1
                   ON RXS.ITEM_ITEM_ID = S1.ITEM_ITEM_ID
                  AND RXS.NUM_SERIAL_MRCVS = S1.COD_SERIAL_NUMBER_MSER
                WHERE RXS.MRCV_RCV_TRANSACTION_ID =
                      FA.MRCV_RCV_TRANSACTION_ID
                  AND S1.SERIAL_NUMBER_ID = FA.MSER_SERIAL_NUMBER_ID
                  AND RXS.MRCV_RCV_TRANSACTION_ID =
                      FA.MRCV_RCV_TRANSACTION_ID) THEN
          'OK'
       END RXS
      ,FA.MTRAN_MATERIAL_TRANSACTION_ID
      ,(SELECT 'TT: ' || X.MTYP_TRANSACTION_TYPE_ID || '   @ ' ||
               TO_CHAR(X.DAT_TRANSACTION_MTRAN
                      ,'yyyy/mm/dd hh24:mi:ss'
                      ,'nls_calendar=persian') || '   # ' ||
               X.MSINV_NAM_SUB_INVENTORY_MSIFOR ||
               (SELECT CASE
                         WHEN L.COD_LOCATOR_MSLOC IS NOT NULL THEN
                          ' -> '
                       END || L.COD_LOCATOR_MSLOC
                  FROM MAM.MAM_SUB_INVENTORY_LOCATORS L
                 WHERE L.SUB_INVENTORY_LOCATOR_ID =
                       X.MSLOC_SUB_INVENTORY_LOCATORFOR)
          FROM MAM.MAM_MATERIAL_TRANSACTIONS X
         WHERE X.MATERIAL_TRANSACTION_ID = FA.MTRAN_MATERIAL_TRANSACTION_ID) AS X
      ,CASE
         WHEN EXISTS
          (SELECT NULL
                 FROM MAM.MAM_TRANSACTION_SERIAL_NUMBERS XS
                WHERE XS.MTRAN_MATERIAL_TRANSACTION_ID =
                      FA.MTRAN_MATERIAL_TRANSACTION_ID
                  AND XS.MSER_SERIAL_NUMBER_ID = FA.MSER_SERIAL_NUMBER_ID) THEN
          'OK'
       END AS XS

  FROM FIA.FIA_FIXED_ASSETS FA
 WHERE 1 = 1
      --   AND FA.MSER_SERIAL_NUMBER_ID IN (&SERIAL_NUMBER_ID)
   AND EXISTS (SELECT NULL
          FROM MAM.MAM_ITEMS I
         WHERE FA.ITEM_ITEM_ID = I.ITEM_ID
           AND I.COD_ITEM IN (&COD_ITEM))
--
;
SELECT Z.MTRAN_MATERIAL_TRANSACTION_ID
      ,Z.MSER_SERIAL_NUMBER_ID
      ,APPS.MAM_MATERIAL_TRNSCTNS_CTRL_PKG.GET_DESCRIPTION(P_MATERIAL_TRANSACTION_ID => Z.MTRAN_MATERIAL_TRANSACTION_ID) AS X
      ,APPS.MAM_SERIAL_NUMBERS_CTRL_PKG.GET_DESCRIPTION(P_SERIAL_NUMBER_ID => Z.MSER_SERIAL_NUMBER_ID) AS S
      ,'œ— ”Ì” „ œ«—«ÌÌ À«»  À»  ‰‘œÂ «” ' AS ERR
  FROM ( --
        SELECT XS.MTRAN_MATERIAL_TRANSACTION_ID, XS.MSER_SERIAL_NUMBER_ID
          FROM MAM.MAM_TRANSACTION_SERIAL_NUMBERS XS
         WHERE 1 = 1
              --   AND XS.MSER_SERIAL_NUMBER_ID IN (&SERIAL_NUMBER_ID)
           AND EXISTS
         (SELECT NULL
                  FROM MAM.MAM_MATERIAL_TRANSACTIONS X
                 WHERE X.MATERIAL_TRANSACTION_ID =
                       XS.MTRAN_MATERIAL_TRANSACTION_ID
                   AND EXISTS (SELECT NULL
                          FROM FIA.FIA_FIXED_ASSETS FA
                         WHERE 1 = 1
                           AND FA.MTRAN_MATERIAL_TRANSACTION_ID =
                               X.MATERIAL_TRANSACTION_ID
                              --   AND FA.MSER_SERIAL_NUMBER_ID IN (&SERIAL_NUMBER_ID)
                           AND EXISTS
                         (SELECT NULL
                                  FROM MAM.MAM_ITEMS I
                                 WHERE FA.ITEM_ITEM_ID = I.ITEM_ID
                                   AND I.COD_ITEM IN (&COD_ITEM)))
                   AND X.ITEM_ITEM_ID_FOR IN
                       (SELECT I.ITEM_ID
                          FROM MAM.MAM_ITEMS I
                         WHERE I.COD_ITEM IN (&COD_ITEM)))
        --
        MINUS
        SELECT FA.MTRAN_MATERIAL_TRANSACTION_ID, FA.MSER_SERIAL_NUMBER_ID
          FROM FIA.FIA_FIXED_ASSETS FA
         WHERE 1 = 1
              --   AND FA.MSER_SERIAL_NUMBER_ID IN (&SERIAL_NUMBER_ID)
           AND EXISTS (SELECT NULL
                  FROM MAM.MAM_ITEMS I
                 WHERE FA.ITEM_ITEM_ID = I.ITEM_ID
                   AND I.COD_ITEM IN (&COD_ITEM))
        --
        ) Z
--
;
