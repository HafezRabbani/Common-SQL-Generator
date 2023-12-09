SELECT F.MSER_SERIAL_NUMBER_ID
      ,F.NUM_ASSET_FIXAS
      ,F.*
  FROM FIA.FIA_FIXED_ASSETS F
 WHERE 1 = 1
       AND MTRAN_MATERIAL_TRANSACTION_ID IN
       ( --
            SELECT X.MATERIAL_TRANSACTION_ID
              FROM MAM.MAM_MATERIAL_TRANSACTIONS X
             WHERE X.ITEM_ITEM_ID_FOR = (SELECT ITEM_ID
                                           FROM MAM.MAM_ITEMS I
                                          WHERE I.COD_ITEM = TRIM('&COD_ITEM')
                                         --
                                         ))
       AND F.MSER_SERIAL_NUMBER_ID NOT IN ( --
                                           &SERIAL_NUMBER_ID
                                           --
                                           )
 ORDER BY F.MSER_SERIAL_NUMBER_ID
