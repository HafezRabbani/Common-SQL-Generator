SELECT X.MATERIAL_TRANSACTION_ID
      ,(SELECT I.COD_ITEM || ': ' || I.DES_ITEM
          FROM MAM.MAM_ITEMS I
         WHERE I.ITEM_ID = X.ITEM_ITEM_ID_FOR) AS ITEM
      ,TO_CHAR(X.DAT_TRANSACTION_MTRAN
              ,'YYYY/MM/DD HH24:MI:SS'
              ,'NLS_CALENDAR=PERSIAN') AS DH
      ,X.*
  FROM MAM.MAM_MATERIAL_TRANSACTIONS X
 WHERE X.MATERIAL_TRANSACTION_ID IN (&MATERIAL_TRANSACTION_ID)
--FOR UPDATE
--
;

SELECT D.*
  FROM MAM.MAM_RCV_CONTRACT_X_DLVRS D
 WHERE D.MTRAN_MATERIAL_TRANSACTION_ID IN (&MATERIAL_TRANSACTION_ID)
--FOR UPDATE
--
;
SELECT TO_CHAR(N.DAT_ACTION_MRCXN
              ,'YYYY/MM/DD HH24:MI:SS'
              ,'NLS_CALENDAR=PERSIAN') AS DH
      ,N.*
  FROM MAM.MAM_RCV_CONTRACT_X_NSPCTS N
 WHERE N.RCV_CONTRACT_X_NSPCT_ID IN
       (SELECT D.MRCXN_RCV_CONTRACT_X_NSPCT_ID
          FROM MAM.MAM_RCV_CONTRACT_X_DLVRS D
         WHERE D.MTRAN_MATERIAL_TRANSACTION_ID IN (&MATERIAL_TRANSACTION_ID))
--FOR UPDATE
--
;
SELECT TO_CHAR(R.DAT_ACTION_MRCXR
              ,'YYYY/MM/DD HH24:MI:SS'
              ,'NLS_CALENDAR=PERSIAN') AS DH
      ,R.*
  FROM MAM.MAM_RCV_CONTRACT_X_RCPTS R
 WHERE R.RCV_CONTRACT_X_RCPT_ID IN
       (SELECT N.MRCXR_RCV_CONTRACT_X_RCPT_ID
          FROM MAM.MAM_RCV_CONTRACT_X_NSPCTS N
         WHERE N.RCV_CONTRACT_X_NSPCT_ID IN
               (SELECT D.MRCXN_RCV_CONTRACT_X_NSPCT_ID
                  FROM MAM.MAM_RCV_CONTRACT_X_DLVRS D
                 WHERE D.MTRAN_MATERIAL_TRANSACTION_ID IN
                       (&MATERIAL_TRANSACTION_ID)))
--FOR UPDATE
--
;
SELECT W.WAYBILL_ID
      ,W.NUM_WYB_GOV_WYBIL
      ,W.QTY_REL_ITEM_WYBIL
      ,WI.NUM_RECEIPT_INV_WYBIT
      ,W.DAT_ENTR_WYBIL
      ,TO_CHAR(W.DAT_ENTR_WYBIL
              ,'YYYY/MM/DD HH24:MI:SS'
              ,'NLS_CALENDAR=PERSIAN') AS DH
      ,I.COD_ITEM
      ,I.DES_ITEM
  FROM PUA.PUA_WAYBILLS W
 INNER JOIN PUA.PUA_WAYBILL_ITEMS WI
    ON W.WAYBILL_ID = WI.WYBIL_WAYBILL_ID
 INNER JOIN MAM.MAM_ITEMS I
    ON WI.ITEM_ITEM_ID = I.ITEM_ID
 WHERE W.WAYBILL_ID IN
       (SELECT R.WYBIL_WAYBILL_ID
          FROM MAM.MAM_RCV_CONTRACT_X_RCPTS R
         WHERE R.RCV_CONTRACT_X_RCPT_ID IN
               (SELECT N.MRCXR_RCV_CONTRACT_X_RCPT_ID
                  FROM MAM.MAM_RCV_CONTRACT_X_NSPCTS N
                 WHERE N.RCV_CONTRACT_X_NSPCT_ID IN
                       (SELECT D.MRCXN_RCV_CONTRACT_X_NSPCT_ID
                          FROM MAM.MAM_RCV_CONTRACT_X_DLVRS D
                         WHERE D.MTRAN_MATERIAL_TRANSACTION_ID IN
                               (&MATERIAL_TRANSACTION_ID))))
--
;
