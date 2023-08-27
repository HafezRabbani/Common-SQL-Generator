SELECT *
  FROM MAM.MAM_TRANSACTION_SERIAL_NUMBERS XS
 WHERE XS.MTRAN_MATERIAL_TRANSACTION_ID IN
       (0, NVL(&MATERIAL_TRANSACTION_ID, 0))
   FOR UPDATE
 ORDER BY XS.MSER_SERIAL_NUMBER_ID;
--
SELECT *
  FROM MAM.MAM_RCV_SERIAL_TRANSACTIONS RXS
 WHERE RXS.MRCV_RCV_TRANSACTION_ID = NVL(&RCV_TRANSACTION_ID, 0)
   FOR UPDATE
 ORDER BY RXS.NUM_SERIAL_MRCVS;
--
SELECT *
  FROM ( --
        SELECT SUM(Z.QTY_PRIMARY_MTRAN / ABS(Z.QTY_PRIMARY_MTRAN)) OVER(PARTITION BY Z.MSER_SERIAL_NUMBER_ID, Z.ITEM_ITEM_ID_FOR) AS SUM_ITEM_SERIAL
               ,(SELECT I.COD_ITEM
                   FROM MAM.MAM_ITEMS I
                  WHERE I.ITEM_ID = Z.ITEM_ITEM_ID_FOR) AS ITEM
               ,S.SERIAL_NUMBER_ID
               ,S.COD_SERIAL_NUMBER_MSER AS COD_SERIAL_NUMBER
               ,S.LKP_STA_CURRENT_MSER AS SERIAL_LKP_STA
               ,Z.MTYP_TRANSACTION_TYPE_ID AS TT
               ,Z.MSER_SERIAL_NUMBER_ID AS SID
               ,Z.MATERIAL_TRANSACTION_ID AS XID
               ,(SELECT RX.RCV_TRANSACTION_ID
                   FROM MAM.MAM_RCV_TRANSACTIONS RX
                  WHERE RX.MTRAN_MATERIAL_TRANSACTION_ID =
                        Z.MATERIAL_TRANSACTION_ID) AS RXID_BASED_ON_XID
               ,Z.DAT_TRANSACTION_MTRAN
               ,Z.CREATE_BY_APP_USER
          FROM ( --
                 SELECT DISTINCT X.QTY_PRIMARY_MTRAN
                                 ,XS.MSER_SERIAL_NUMBER_ID
                                 ,X.ITEM_ITEM_ID_FOR
                                 ,X.MATERIAL_TRANSACTION_ID
                                 ,X.MTYP_TRANSACTION_TYPE_ID
                                 ,X.DAT_TRANSACTION_MTRAN
                                 ,X.CREATE_BY_APP_USER
                   FROM MAM.MAM_MATERIAL_TRANSACTIONS X
                   LEFT OUTER JOIN MAM.MAM_TRANSACTION_SERIAL_NUMBERS XS
                     ON XS.MTRAN_MATERIAL_TRANSACTION_ID =
                        X.MATERIAL_TRANSACTION_ID
                  WHERE EXISTS
                  (SELECT NULL
                           FROM MAM.MAM_ITEMS I
                          WHERE I.ITEM_ID = X.ITEM_ITEM_ID_FOR
                               --AND (I.COD_ITEM = &COD_ITEM OR &COD_ITEM IS NULL)
                                AND NVL(I.COD_SERIAL_NUMBER_CONTROL_ITEM, 0) = 1)
                 
                 --
                 ) Z
          LEFT OUTER JOIN MAM.MAM_SERIAL_NUMBERS S
            ON Z.MSER_SERIAL_NUMBER_ID = S.SERIAL_NUMBER_ID
        --    where nvl(S.COD_SERIAL_NUMBER_MSER,0)not in('1')
        --
        ) BB
 WHERE SUM_ITEM_SERIAL != 0
       AND ITEM NOT IN (1020030037
                       ,1030020077
                       ,1050010070
                       ,1020030133
                       ,1020030134
                       ,1020030135
                       ,1020030136
                       ,1050050455
                       ,1090010006
                       ,1090010009
                       ,1090010021
                       ,1090010023
                       ,1090010040
                       ,1090010041
                       ,1090010042
                       ,1090010055
                       ,1090010087
                       ,1090010097
                       ,1090010098
                       ,1090020003
                       ,1090020046
                       ,1090020086
                       ,1090020123
                       ,1090030031
                       ,1090030037
                       ,1090030039
                       ,1090030051
                       ,1090030052
                       ,1090030054
                       ,1090030060
                       ,1090030061
                       ,1090030062
                       ,1090030066
                       ,1090030080
                       ,1090030089
                       ,1090030213
                       ,1090030278
                       ,1090030279
                       ,1090030280
                       ,1090030281
                       ,1090030282
                       ,1090030284
                       ,1090030285
                       ,1090020060
                       ,1090020070
                       ,1090060047
                       ,1090060049
                       ,1090060050
                       ,1090060051
                       ,1090060052
                       ,1090060053
                       ,1090060054
                       ,1090060055
                       ,1090020101
                       ,1090030023
                       ,1090030081
                       ,1090030090
                       ,1090030149
                       ,1090030171
                       ,1090030286
                       ,1090030287
                       ,1090030288
                       ,1090030289
                       ,1090030291
                       ,1090030292
                       ,1090030337
                       ,1090030338
                       ,1090030339
                       ,1090040022
                       
                        --
                        )
 ORDER BY --1 DESC, 
          BB.ITEM
         ,BB.COD_SERIAL_NUMBER
         ,BB.DAT_TRANSACTION_MTRAN;
