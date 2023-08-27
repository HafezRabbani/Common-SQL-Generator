SELECT *
  FROM MAM.MAM_MATERIAL_TRANSACTIONS X
 WHERE EXISTS ( --
        SELECT NULL
          FROM ( --
                 SELECT &MATERIAL_TRANSACTION_ID AS ID_
                   FROM DUAL
                 UNION
                 SELECT X2.ID_TRANSFER_MTRAN AS ID_
                   FROM MAM.MAM_MATERIAL_TRANSACTIONS X2
                  WHERE X2.ID_TRANSFER_MTRAN = &MATERIAL_TRANSACTION_ID
                 --
                 ) Z
         WHERE X.MATERIAL_TRANSACTION_ID = Z.ID_
               OR X.ID_TRANSFER_MTRAN = Z.ID_
        --
        )
