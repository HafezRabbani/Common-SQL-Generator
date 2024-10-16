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
--      ,FA.NUM_DCM_FIXAS
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
           AND EXISTS (SELECT NULL
                  FROM MAM.MAM_ITEMS I
                 WHERE FA.ITEM_ITEM_ID = I.ITEM_ID
                   AND I.COD_ITEM IN (&COD_ITEM))
        --   AND FA.MSER_SERIAL_NUMBER_ID IN (&SERIAL_NUMBER_ID)
        --
        ) Z
--
;
---
SELECT DISTINCT A.MSER_SERIAL_NUMBER_ID
                --      ,M.NUM_DOC_ASMVM
                --      ,A.ITEM_ITEM_ID
                --      ,M.NUM_EMPL_REC_ASMVM
               ,X.MATERIAL_TRANSACTION_ID
               ,X.MTYP_TRANSACTION_TYPE_ID
  FROM FIA.FIA_ASSET_MOVEMENTS M
 INNER JOIN FIA.FIA_ASSET_MOVEMENT_RELATIONS R
    ON M.ASSET_MOVEMENT_ID = R.ASMVM_ASSET_MOVEMENT_ID
 INNER JOIN FIA.FIA_FIXED_ASSETS A
    ON A.NUM_ASSET_FIXAS = R.FIXAS_NUM_ASSET_FIXAS
 INNER JOIN MAM.MAM_REQUEST_HEADERS H
    ON M.NUM_DOC_ASMVM = H.NUM_REQUEST_MREQH
 INNER JOIN MAM.MAM_REQUEST_LINES L
    ON H.REQUEST_HEADER_ID = L.MREQH_REQUEST_HEADER_ID
 INNER JOIN MAM.MAM_MATERIAL_TRANSACTIONS X
    ON L.REQUEST_LINE_ID = X.MREQL_REQUEST_LINE_ID
   AND M.NUM_EMPL_REC_ASMVM = X.EMPLY_NUM_PRSN_EMPLY
 WHERE 1 = 1
   AND M.ASMVT_COD_MVM_ASMVT = 5
   AND EXISTS (SELECT NULL
          FROM MAM.MAM_ITEMS I
         WHERE A.ITEM_ITEM_ID = I.ITEM_ID
           AND I.COD_ITEM IN (&COD_ITEM))
--   AND A.MSER_SERIAL_NUMBER_ID IN (&SERIAL_NUMBER_ID)
--
;
----
SELECT Y.MSER_SERIAL_NUMBER_ID
      ,Y.COD_SERIAL
      ,Y.MRCV_RCV_TRANSACTION_ID
      ,Y.MTRAN_MATERIAL_TRANSACTION_ID
      ,NVL(Y.DAT_TRANSACTION_MRCV, Y.DAT_TRANSACTION_MTRAN) AS DAT
      ,CASE
         WHEN Y.MRCV_RCV_TRANSACTION_ID IS NOT NULL AND
              DAT_TRANSACTION_MTRAN != DAT_TRANSACTION_MRCV THEN
          'dat_x!=Dat_rx'
       END AS ERR1
       
      ,MTYP_TRANSACTION_TYPE_ID
  FROM ( --
        SELECT DISTINCT Z.MSER_SERIAL_NUMBER_ID
                        ,S.COD_SERIAL_NUMBER_MSER AS COD_SERIAL
                        ,Z.MTRAN_MATERIAL_TRANSACTION_ID
                        ,Z.MRCV_RCV_TRANSACTION_ID
                        ,(SELECT X.DAT_TRANSACTION_MTRAN
                            FROM MAM.MAM_MATERIAL_TRANSACTIONS X
                           WHERE X.MATERIAL_TRANSACTION_ID =
                                 Z.MTRAN_MATERIAL_TRANSACTION_ID) AS DAT_TRANSACTION_MTRAN
                        ,(SELECT RX.DAT_TRANSACTION_MRCV
                            FROM MAM.MAM_RCV_TRANSACTIONS RX
                           WHERE RX.RCV_TRANSACTION_ID =
                                 Z.MRCV_RCV_TRANSACTION_ID) AS DAT_TRANSACTION_MRCV
                        ,(SELECT X.MTYP_TRANSACTION_TYPE_ID
                            FROM MAM.MAM_MATERIAL_TRANSACTIONS X
                           WHERE X.MATERIAL_TRANSACTION_ID =
                                 Z.MTRAN_MATERIAL_TRANSACTION_ID) AS MTYP_TRANSACTION_TYPE_ID
        
          FROM MAM.MAM_SERIAL_NUMBERS S
         INNER JOIN ( --
                     SELECT FA.MSER_SERIAL_NUMBER_ID
                            ,FA.MTRAN_MATERIAL_TRANSACTION_ID
                            ,FA.MRCV_RCV_TRANSACTION_ID
                       FROM FIA.FIA_FIXED_ASSETS FA
                      WHERE 1 = 1
                           --                        AND FA.MSER_SERIAL_NUMBER_ID IN (&SERIAL_NUMBER_ID)
                        AND EXISTS
                      (SELECT NULL
                               FROM MAM.MAM_ITEMS I
                              WHERE FA.ITEM_ITEM_ID = I.ITEM_ID
                                AND I.COD_ITEM IN (&COD_ITEM))
                     UNION
                     SELECT A.MSER_SERIAL_NUMBER_ID
                            ,X.MATERIAL_TRANSACTION_ID
                            ,NULL AS MRCV_RCV_TRANSACTION_ID
                       FROM FIA.FIA_ASSET_MOVEMENTS M
                      INNER JOIN FIA.FIA_ASSET_MOVEMENT_RELATIONS R
                         ON M.ASSET_MOVEMENT_ID = R.ASMVM_ASSET_MOVEMENT_ID
                      INNER JOIN FIA.FIA_FIXED_ASSETS A
                         ON A.NUM_ASSET_FIXAS = R.FIXAS_NUM_ASSET_FIXAS
                      INNER JOIN MAM.MAM_REQUEST_HEADERS H
                         ON M.NUM_DOC_ASMVM = H.NUM_REQUEST_MREQH
                      INNER JOIN MAM.MAM_REQUEST_LINES L
                         ON H.REQUEST_HEADER_ID = L.MREQH_REQUEST_HEADER_ID
                      INNER JOIN MAM.MAM_MATERIAL_TRANSACTIONS X
                         ON L.REQUEST_LINE_ID = X.MREQL_REQUEST_LINE_ID
                        AND M.NUM_EMPL_REC_ASMVM = X.EMPLY_NUM_PRSN_EMPLY
                      WHERE 1 = 1
                        AND M.ASMVT_COD_MVM_ASMVT = 5
                        AND EXISTS
                      (SELECT NULL
                               FROM MAM.MAM_ITEMS I
                              WHERE A.ITEM_ITEM_ID = I.ITEM_ID
                                AND I.COD_ITEM IN (&COD_ITEM))
                     --                        AND A.MSER_SERIAL_NUMBER_ID IN (&SERIAL_NUMBER_ID)
                     
                     --
                     ) Z
            ON S.SERIAL_NUMBER_ID = Z.MSER_SERIAL_NUMBER_ID
        --
        ) Y
 ORDER BY Y.MSER_SERIAL_NUMBER_ID
         ,NVL(DAT_TRANSACTION_MRCV, DAT_TRANSACTION_MTRAN)
         ,Y.MRCV_RCV_TRANSACTION_ID
         ,Y.MTRAN_MATERIAL_TRANSACTION_ID
--
