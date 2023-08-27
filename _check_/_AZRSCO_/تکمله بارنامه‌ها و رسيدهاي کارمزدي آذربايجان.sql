SELECT W.* FROM PUA.PUA_WAYBILLS W WHERE W.WAYBILL_ID = &WAYBILL_ID;
SELECT R.RCV_CONTRACT_X_RCPT_ID
      ,R.MRCXR_RCV_CONTRACT_X_RCPT_ID
      ,R.*
  FROM MAM.MAM_RCV_CONTRACT_X_RCPTS R
 WHERE R.WYBIL_WAYBILL_ID = &WAYBILL_ID
       OR R.MRCXR_RCV_CONTRACT_X_RCPT_ID IN
       ( --
           SELECT R1.MRCXR_RCV_CONTRACT_X_RCPT_ID
             FROM MAM.MAM_RCV_CONTRACT_X_RCPTS R1
            WHERE R1.WYBIL_WAYBILL_ID = &WAYBILL_ID
           --
           )
   FOR UPDATE
--
;
SELECT N.RCV_CONTRACT_X_NSPCT_ID
      ,N.MRCXN_RCV_CONTRACT_X_NSPCT_ID
      ,N.MRCXR_RCV_CONTRACT_X_RCPT_ID
      ,N.*
  FROM MAM.MAM_RCV_CONTRACT_X_NSPCTS N
 WHERE N.MRCXR_RCV_CONTRACT_X_RCPT_ID IN
       ( --
        SELECT R.RCV_CONTRACT_X_RCPT_ID
          FROM MAM.MAM_RCV_CONTRACT_X_RCPTS R
         WHERE R.WYBIL_WAYBILL_ID = &WAYBILL_ID
               OR R.MRCXR_RCV_CONTRACT_X_RCPT_ID IN
               ( --
                   SELECT R1.MRCXR_RCV_CONTRACT_X_RCPT_ID
                     FROM MAM.MAM_RCV_CONTRACT_X_RCPTS R1
                    WHERE R1.WYBIL_WAYBILL_ID = &WAYBILL_ID
                   --
                   )
        --
        )
       OR N.MRCXN_RCV_CONTRACT_X_NSPCT_ID IN ( --
                                              SELECT N1.RCV_CONTRACT_X_NSPCT_ID
                                                FROM MAM.MAM_RCV_CONTRACT_X_NSPCTS N1
                                               WHERE N1.MRCXR_RCV_CONTRACT_X_RCPT_ID IN ( --
                                                                                         SELECT R.RCV_CONTRACT_X_RCPT_ID
                                                                                           FROM MAM.MAM_RCV_CONTRACT_X_RCPTS R
                                                                                          WHERE R.WYBIL_WAYBILL_ID =
                                                                                                &WAYBILL_ID
                                                                                         --
                                                                                         )
                                              --
                                              )
   FOR UPDATE
--
;

SELECT D.RCV_CONTRACT_X_DLVR_ID
      ,D.MRCXD_RCV_CONTRACT_X_DLVR_ID
      ,D.MRCXN_RCV_CONTRACT_X_NSPCT_ID
      ,D.MTRAN_MATERIAL_TRANSACTION_ID
      ,(SELECT X0.QTY_PRIMARY_MTRAN
          FROM MAM.MAM_MATERIAL_TRANSACTIONS X0
         WHERE X0.MATERIAL_TRANSACTION_ID = D.MTRAN_MATERIAL_TRANSACTION_ID) AS QTY_PRIMARY_MTRAN
      ,D.*
  FROM MAM.MAM_RCV_CONTRACT_X_DLVRS D
 WHERE D.MRCXN_RCV_CONTRACT_X_NSPCT_ID IN
       ( --
        SELECT N.RCV_CONTRACT_X_NSPCT_ID
          FROM MAM.MAM_RCV_CONTRACT_X_NSPCTS N
         WHERE N.MRCXR_RCV_CONTRACT_X_RCPT_ID IN
               ( --
                SELECT R.RCV_CONTRACT_X_RCPT_ID
                  FROM MAM.MAM_RCV_CONTRACT_X_RCPTS R
                 WHERE R.WYBIL_WAYBILL_ID = &WAYBILL_ID
                       OR R.MRCXR_RCV_CONTRACT_X_RCPT_ID IN
                       ( --
                           SELECT R1.MRCXR_RCV_CONTRACT_X_RCPT_ID
                             FROM MAM.MAM_RCV_CONTRACT_X_RCPTS R1
                            WHERE R1.WYBIL_WAYBILL_ID = &WAYBILL_ID
                           --
                           )
                --
                )
               OR N.MRCXN_RCV_CONTRACT_X_NSPCT_ID IN ( --
                                                      SELECT N1.RCV_CONTRACT_X_NSPCT_ID
                                                        FROM MAM.MAM_RCV_CONTRACT_X_NSPCTS N1
                                                       WHERE N1.MRCXR_RCV_CONTRACT_X_RCPT_ID IN ( --
                                                                                                 SELECT R.RCV_CONTRACT_X_RCPT_ID
                                                                                                   FROM MAM.MAM_RCV_CONTRACT_X_RCPTS R
                                                                                                  WHERE R.WYBIL_WAYBILL_ID =
                                                                                                        &WAYBILL_ID
                                                                                                 --
                                                                                                 )
                                                      --
                                                      )
        --
        )
       OR D.MRCXD_RCV_CONTRACT_X_DLVR_ID IN ( --
                                             SELECT D1.RCV_CONTRACT_X_DLVR_ID
                                               FROM MAM.MAM_RCV_CONTRACT_X_DLVRS D1
                                              WHERE D1.MRCXN_RCV_CONTRACT_X_NSPCT_ID IN ( --
                                                                                         SELECT N.RCV_CONTRACT_X_NSPCT_ID
                                                                                           FROM MAM.MAM_RCV_CONTRACT_X_NSPCTS N
                                                                                          WHERE N.MRCXR_RCV_CONTRACT_X_RCPT_ID IN
                                                                                                (SELECT R.RCV_CONTRACT_X_RCPT_ID
                                                                                                   FROM MAM.MAM_RCV_CONTRACT_X_RCPTS R
                                                                                                  WHERE R.WYBIL_WAYBILL_ID =
                                                                                                        &WAYBILL_ID)
                                                                                         --
                                                                                         )
                                             --
                                             )
   FOR UPDATE
 ORDER BY D.RCV_CONTRACT_X_DLVR_ID
--
;

SELECT X.MATERIAL_TRANSACTION_ID
      ,CASE
         WHEN X.ORPYD_ORPYM_NUM_ORD_PYM_ORPYM IS NOT NULL
              OR X.SPINV_NUM_SRL_SPINV IS NOT NULL THEN
          'Err!'
       END AS ERR
      ,X.QTY_PRIMARY_MTRAN
      ,(SELECT I.COD_ITEM || ': ' || I.DES_ITEM
         FROM MAM.MAM_ITEMS I
        WHERE I.ITEM_ID = X.ITEM_ITEM_ID_FOR)
      ,TO_CHAR(X.DAT_TRANSACTION_MTRAN
              ,'YYYY/MM/DD HH24:MI:SS'
              ,'NLS_CALENDAR=PERSIAN') AS DH
      ,X.*
  FROM MAM.MAM_MATERIAL_TRANSACTIONS X
 WHERE X.MATERIAL_TRANSACTION_ID IN
       ( --
        SELECT D.MTRAN_MATERIAL_TRANSACTION_ID
          FROM MAM.MAM_RCV_CONTRACT_X_DLVRS D
         WHERE D.MRCXN_RCV_CONTRACT_X_NSPCT_ID IN
               ( --
                SELECT N.RCV_CONTRACT_X_NSPCT_ID
                  FROM MAM.MAM_RCV_CONTRACT_X_NSPCTS N
                 WHERE N.MRCXR_RCV_CONTRACT_X_RCPT_ID IN
                       ( --
                        SELECT R.RCV_CONTRACT_X_RCPT_ID
                          FROM MAM.MAM_RCV_CONTRACT_X_RCPTS R
                         WHERE R.WYBIL_WAYBILL_ID = &WAYBILL_ID
                               OR R.MRCXR_RCV_CONTRACT_X_RCPT_ID IN
                               ( --
                                   SELECT R1.MRCXR_RCV_CONTRACT_X_RCPT_ID
                                     FROM MAM.MAM_RCV_CONTRACT_X_RCPTS R1
                                    WHERE R1.WYBIL_WAYBILL_ID = &WAYBILL_ID
                                   --
                                   )
                        --
                        )
                       OR N.MRCXN_RCV_CONTRACT_X_NSPCT_ID IN ( --
                                                              SELECT N1.RCV_CONTRACT_X_NSPCT_ID
                                                                FROM MAM.MAM_RCV_CONTRACT_X_NSPCTS N1
                                                               WHERE N1.MRCXR_RCV_CONTRACT_X_RCPT_ID IN ( --
                                                                                                         SELECT R.RCV_CONTRACT_X_RCPT_ID
                                                                                                           FROM MAM.MAM_RCV_CONTRACT_X_RCPTS R
                                                                                                          WHERE R.WYBIL_WAYBILL_ID =
                                                                                                                &WAYBILL_ID
                                                                                                         --
                                                                                                         )
                                                              --
                                                              )
                --
                )
               OR D.MRCXD_RCV_CONTRACT_X_DLVR_ID IN ( --
                                                     SELECT D1.RCV_CONTRACT_X_DLVR_ID
                                                       FROM MAM.MAM_RCV_CONTRACT_X_DLVRS D1
                                                      WHERE D1.MRCXN_RCV_CONTRACT_X_NSPCT_ID IN ( --
                                                                                                 SELECT N.RCV_CONTRACT_X_NSPCT_ID
                                                                                                   FROM MAM.MAM_RCV_CONTRACT_X_NSPCTS N
                                                                                                  WHERE N.MRCXR_RCV_CONTRACT_X_RCPT_ID IN
                                                                                                        (SELECT R.RCV_CONTRACT_X_RCPT_ID
                                                                                                           FROM MAM.MAM_RCV_CONTRACT_X_RCPTS R
                                                                                                          WHERE R.WYBIL_WAYBILL_ID =
                                                                                                                &WAYBILL_ID)
                                                                                                 --
                                                                                                 )
                                                     --
                                                     )
        --
        )
   FOR UPDATE
 ORDER BY X.MATERIAL_TRANSACTION_ID
--
;
