SELECT I.ITEM_ID
      ,(SELECT U.NAM_UNIT_OF_MEASURE_MUOM
          FROM MAM.MAM_MEASUREMENT_UNITS U
         WHERE I.MUOM_MEASUREMENT_UNIT_ID = U.MEASUREMENT_UNIT_ID) U
      ,I.DES_ITEM
      ,I.COD_SERIAL_NUMBER_CONTROL_ITEM
      ,I.COD_ITEM
      ,CASE
         WHEN EXISTS (SELECT NULL
                 FROM MAM.MAM_MATERIAL_TRANSACTIONS X
                WHERE X.ITEM_ITEM_ID_FOR = I.ITEM_ID) THEN
          'yes'
       END AS HASX
      ,CASE
         WHEN EXISTS (SELECT NULL
                 FROM MAM.MAM_MATERIAL_TRANSACTIONS X
                INNER JOIN MAM.MAM_TRANSACTION_SERIAL_NUMBERS XS
                   ON X.MATERIAL_TRANSACTION_ID =
                      XS.MTRAN_MATERIAL_TRANSACTION_ID
                WHERE X.ITEM_ITEM_ID_FOR = I.ITEM_ID) THEN
          'yes'
       END AS HASXS
      ,CASE
         WHEN EXISTS (SELECT NULL
                 FROM MAM.MAM_RCV_TRANSACTIONS RX
                WHERE RX.ITEM_ITEM_ID = I.ITEM_ID) THEN
          'yes'
       END AS HASRX
      ,CASE
         WHEN EXISTS
          (SELECT NULL
                 FROM MAM.MAM_RCV_TRANSACTIONS RX
                INNER JOIN MAM.MAM_RCV_SERIAL_TRANSACTIONS RXS
                   ON RX.RCV_TRANSACTION_ID = RXS.MRCV_RCV_TRANSACTION_ID
                WHERE RX.ITEM_ITEM_ID = I.ITEM_ID) THEN
          'yes'
       END AS HASRXS
  FROM MAM.MAM_ITEMS I
 WHERE I.COD_ITEM =
       (SELECT REPLACE(C, CHR(10), '')
          FROM (SELECT UPPER(TRIM('&cod_item')) AS C FROM DUAL));
--
--FOR DIRECT DELIVERY ORDERS
SELECT RX.RCV_TRANSACTION_ID
      ,RX.PARENT_TRANSACTION_ID_MRCV
      ,RX.LKP_TYP_TRANSACTION_MRCV
      ,RXS.MSER_SERIAL_NUMBER_ID
      ,RXS.NUM_SERIAL_MRCVS
      ,RX.QTY_PRIMARY_MRCV
      ,COUNT(RXS.RCV_SERIAL_TRANSACTION_ID) OVER(PARTITION BY RXS.MRCV_RCV_TRANSACTION_ID) AS COUNT_SERIAL
      ,RX.ITEM_ITEM_ID
      ,(SELECT I.COD_ITEM
          FROM MAM.MAM_ITEMS I
         WHERE I.ITEM_ID = RX.ITEM_ITEM_ID) I
      ,(SELECT U.NAM_UNIT_OF_MEASURE_MUOM
          FROM MAM.MAM_ITEMS I
         INNER JOIN MAM.MAM_MEASUREMENT_UNITS U
            ON I.MUOM_MEASUREMENT_UNIT_ID = U.MEASUREMENT_UNIT_ID
         WHERE I.ITEM_ID = RX.ITEM_ITEM_ID) NAM_UNIT_OF_MEASURE_MUOM
      ,(CASE
         WHEN RX.ORPYDORPYM_NUM_ORD_PYM_ORPYM IS NOT NULL
              OR RX.ORPYD_NUM_SEQ_ORPYD IS NOT NULL
              OR RX.DAT_STL_MRCV IS NOT NULL
              OR RX.SPINV_NUM_SRL_SPINV IS NOT NULL THEN
          'Don''t Change!'
       END) AS ERR
      ,RX.NUM_RECEIPT_AP_MRCV
      ,RX.MTRAN_MATERIAL_TRANSACTION_ID
      ,(SELECT O.NUM_PGV_PUROR
          FROM PUR.PUR_ORDERS O
         INNER JOIN PUR.PUR_ORDER_POSITIONS OP
            ON O.ORDER_ID = OP.PUROR_ORDER_ID
         WHERE OP.PUROP_ID = RX.PUROP_PUROP_ID) AS NUM_PGV_PUROR
      ,RX.PUROP_PUROP_ID
      ,RX.DLVNH_DELIVERY_NOTE_ID
      ,RX.LKP_COD_INSPECTION_STATUS_MRCV
      ,RX.DAT_TRANSACTION_MRCV
      ,TO_CHAR(RX.DAT_TRANSACTION_MRCV, 'YYYY/MM/DD HH24:MI:SS', 'NLS_CALENDAR=PERSIAN') AS DAT_TRANSACTION_MRCV_H
      ,RX.QTY_MRCV
      ,RX.LKP_ROUTING_RECEIPT_MRCV
      ,RX.NAM_UNIT_OF_MEASURE_MRCV
      ,RX.NAM_UNIT_OF_MEASURE_PRIMARY_MR
      ,RX.NUM_RECEIPT_INV_MRCV
  FROM --
       MAM.MAM_RCV_TRANSACTIONS RX
  LEFT OUTER JOIN MAM.MAM_RCV_SERIAL_TRANSACTIONS RXS
    ON RX.RCV_TRANSACTION_ID = RXS.MRCV_RCV_TRANSACTION_ID
 WHERE 1 = 1
       AND
       RX.ITEM_ITEM_ID =
       (SELECT ITEM_ID
          FROM MAM.MAM_ITEMS I
         WHERE I.COD_ITEM =
               (SELECT REPLACE(C, CHR(10), '')
                  FROM (SELECT UPPER(TRIM('&cod_item')) AS C FROM DUAL)))
 ORDER BY RX.NUM_RECEIPT_AP_MRCV
         ,RX.DAT_TRANSACTION_MRCV
         ,RX.RCV_TRANSACTION_ID;
--
SELECT (SELECT NULL FROM MAM.MAM_TRANSACTION_SERIAL_NUMBERS WHERE ROWNUM = 1) AS NUL
      ,XS.MSER_SERIAL_NUMBER_ID
      ,XS.MTRAN_MATERIAL_TRANSACTION_ID
      ,(SELECT FA.NUM_ASSET_FIXAS
          FROM FIA.FIA_FIXED_ASSETS FA
         WHERE FA.MSER_SERIAL_NUMBER_ID = XS.MSER_SERIAL_NUMBER_ID) AS NUM_ASSET_FIXAS
  FROM MAM.MAM_TRANSACTION_SERIAL_NUMBERS XS
 WHERE XS.MTRAN_MATERIAL_TRANSACTION_ID IN
       (0, NVL(&MATERIAL_TRANSACTION_ID1, 0), NVL(&MATERIAL_TRANSACTION_ID2, 0))
   FOR UPDATE
 ORDER BY XS.MSER_SERIAL_NUMBER_ID;

--
SELECT (SELECT 'all'
          FROM MAM.MAM_TRANSACTION_SERIAL_NUMBERS
         WHERE ROWNUM = 1) AS NUL
      ,XS.MSER_SERIAL_NUMBER_ID
      ,XS.MTRAN_MATERIAL_TRANSACTION_ID
--��� �������� ��� ����
  FROM MAM.MAM_TRANSACTION_SERIAL_NUMBERS XS
 WHERE EXISTS (SELECT NULL
          FROM MAM.MAM_ITEMS I
         INNER JOIN MAM.MAM_SERIAL_NUMBERS S
            ON I.ITEM_ID = S.ITEM_ITEM_ID
         WHERE S.SERIAL_NUMBER_ID = XS.MSER_SERIAL_NUMBER_ID
               AND
               (I.COD_ITEM =
               (SELECT REPLACE(C, CHR(10), '')
                   FROM (SELECT UPPER(TRIM('&cod_item')) AS C FROM DUAL)) OR
               (SELECT REPLACE(C, CHR(10), '')
                   FROM (SELECT UPPER(TRIM('&cod_item')) AS C FROM DUAL)) IS NULL)
        --AND NVL(I.COD_SERIAL_NUMBER_CONTROL_ITEM, 0) = 1
        )
   FOR UPDATE
 ORDER BY XS.MSER_SERIAL_NUMBER_ID;
--
SELECT (SELECT NULL FROM MAM.MAM_RCV_SERIAL_TRANSACTIONS WHERE ROWNUM = 1) AS NUL
      ,RXS.RCV_SERIAL_TRANSACTION_ID
      ,RXS.MRCV_RCV_TRANSACTION_ID
      ,RXS.ITEM_ITEM_ID
      ,RXS.MSER_SERIAL_NUMBER_ID
      ,RXS.NUM_SERIAL_MRCVS
      ,(SELECT S.LKP_STA_CURRENT_MSER
          FROM MAM.MAM_SERIAL_NUMBERS S
         WHERE S.ITEM_ITEM_ID = RXS.ITEM_ITEM_ID
               AND S.COD_SERIAL_NUMBER_MSER = RXS.NUM_SERIAL_MRCVS) AS LKP_STA_CURRENT_MSER
  FROM MAM.MAM_RCV_SERIAL_TRANSACTIONS RXS
 WHERE RXS.MRCV_RCV_TRANSACTION_ID = NVL(&RCV_TRANSACTION_ID, 0)
--   FOR UPDATE
 ORDER BY RXS.NUM_SERIAL_MRCVS;
--
SELECT (SELECT 'ALL' FROM MAM.MAM_RCV_SERIAL_TRANSACTIONS WHERE ROWNUM = 1) AS NUL
      ,RXS.RCV_SERIAL_TRANSACTION_ID
      ,RXS.MRCV_RCV_TRANSACTION_ID
      ,RXS.ITEM_ITEM_ID
      ,RXS.MSER_SERIAL_NUMBER_ID
      ,RXS.NUM_SERIAL_MRCVS
      ,(SELECT S.LKP_STA_CURRENT_MSER
          FROM MAM.MAM_SERIAL_NUMBERS S
         WHERE S.ITEM_ITEM_ID = RXS.ITEM_ITEM_ID
               AND S.COD_SERIAL_NUMBER_MSER = RXS.NUM_SERIAL_MRCVS) AS LKP_STA_CURRENT_MSER
--��� �������� ��� ����
  FROM MAM.MAM_RCV_SERIAL_TRANSACTIONS RXS
 WHERE EXISTS (SELECT NULL
          FROM MAM.MAM_ITEMS I
         INNER JOIN MAM.MAM_SERIAL_NUMBERS S
            ON I.ITEM_ID = S.ITEM_ITEM_ID
         WHERE S.COD_SERIAL_NUMBER_MSER = RXS.NUM_SERIAL_MRCVS
               AND S.ITEM_ITEM_ID = RXS.ITEM_ITEM_ID
               AND
               (I.COD_ITEM =
               (SELECT REPLACE(C, CHR(10), '')
                   FROM (SELECT UPPER(TRIM('&cod_item')) AS C FROM DUAL)) OR
               (SELECT REPLACE(C, CHR(10), '')
                   FROM (SELECT UPPER(TRIM('&cod_item')) AS C FROM DUAL)) IS NULL)
        --AND NVL(I.COD_SERIAL_NUMBER_CONTROL_ITEM, 0) = 1
        )
   FOR UPDATE
 ORDER BY RXS.NUM_SERIAL_MRCVS;
-----
/*
SELECT SUM(X.QTY_PRIMARY_MTRAN)
  FROM MAM.MAM_MATERIAL_TRANSACTIONS X
 WHERE EXISTS
 (SELECT NULL
          FROM MAM.MAM_ITEMS I
         WHERE I.ITEM_ID = X.ITEM_ITEM_ID_FOR
               AND (I.COD_ITEM = (SELECT replace(C,chr(10),'') FROM (SELECT UPPER(trim('&cod_item')) AS C FROM DUAL))OR (SELECT replace(C,chr(10),'') FROM (SELECT UPPER(trim('&cod_item')) AS C FROM DUAL))IS NULL)
               AND NVL(I.COD_SERIAL_NUMBER_CONTROL_ITEM, 0) = 1);
*/
--------------------------------------------------------------------
SELECT *
  FROM ( --
        SELECT 0
               ,SUM(Z.QTY_PRIMARY_MTRAN / ABS(Z.QTY_PRIMARY_MTRAN)) OVER(PARTITION BY Z.MSER_SERIAL_NUMBER_ID, Z.ITEM_ITEM_ID_FOR) AS SUM_ITEM_SERIAL
               ,(SELECT SUM(XX.QTY_PRIMARY_MTRAN)
                   FROM MAM.MAM_MATERIAL_TRANSACTIONS XX
                  WHERE XX.ITEM_ITEM_ID_FOR = Z.ITEM_ITEM_ID_FOR) AS SQ
               ,(SELECT I.COD_ITEM
                   FROM MAM.MAM_ITEMS I
                  WHERE I.ITEM_ID = Z.ITEM_ITEM_ID_FOR) AS ITEM
               ,Z.ITEM_ITEM_ID_FOR AS ITEM_ID
               ,S.SERIAL_NUMBER_ID
               ,(SELECT 'FIA_FIXED_ASSETS'
                   FROM DUAL
                  WHERE EXISTS
                  (SELECT NULL
                           FROM FIA.FIA_FIXED_ASSETS FA
                          WHERE FA.MSER_SERIAL_NUMBER_ID = S.SERIAL_NUMBER_ID)) AS FFA_EXISTS
               ,S.COD_SERIAL_NUMBER_MSER AS COD_SERIAL_NUMBER
               ,(SELECT DISTINCT XY.MSINV_NAM_SUB_INVENTORY_MSIFOR
                   FROM MAM.MAM_MATERIAL_TRANSACTIONS XY
                   LEFT OUTER JOIN MAM.MAM_TRANSACTION_SERIAL_NUMBERS XSY
                     ON XY.MATERIAL_TRANSACTION_ID =
                        XSY.MTRAN_MATERIAL_TRANSACTION_ID
                  WHERE XSY.MSER_SERIAL_NUMBER_ID = S.SERIAL_NUMBER_ID
                        AND
                        XY.MATERIAL_TRANSACTION_ID = Z.MATERIAL_TRANSACTION_ID) AS INV
               ,(SELECT DISTINCT XY.MSLOC_SUB_INVENTORY_LOCATORFOR
                   FROM MAM.MAM_MATERIAL_TRANSACTIONS XY
                   LEFT OUTER JOIN MAM.MAM_TRANSACTION_SERIAL_NUMBERS XSY
                     ON XY.MATERIAL_TRANSACTION_ID =
                        XSY.MTRAN_MATERIAL_TRANSACTION_ID
                  WHERE XSY.MSER_SERIAL_NUMBER_ID = S.SERIAL_NUMBER_ID
                        AND
                        XY.MATERIAL_TRANSACTION_ID = Z.MATERIAL_TRANSACTION_ID) AS LID
               ,S.LKP_STA_CURRENT_MSER AS LKP_STA
               ,Z.MTYP_TRANSACTION_TYPE_ID AS TT
               ,Z.MSER_SERIAL_NUMBER_ID AS SID
               ,Z.MATERIAL_TRANSACTION_ID AS XID
               ,(SELECT RX.RCV_TRANSACTION_ID
                   FROM MAM.MAM_RCV_TRANSACTIONS RX
                  WHERE RX.MTRAN_MATERIAL_TRANSACTION_ID =
                        Z.MATERIAL_TRANSACTION_ID) AS RXID_BASED_ON_XID
               ,(SELECT RX.NUM_RECEIPT_AP_MRCV
                   FROM MAM.MAM_RCV_TRANSACTIONS RX
                  WHERE RX.MTRAN_MATERIAL_TRANSACTION_ID =
                        Z.MATERIAL_TRANSACTION_ID) AS NUM_RECEIPT_AP_MRCV
               ,Z.DAT_TRANSACTION_MTRAN
               ,TO_CHAR(Z.DAT_TRANSACTION_MTRAN, 'YYYY/MM/DD hh24:mi:ss', 'NLS_CALENDAR=PERSIAN') AS DH
               ,COUNT(Z.MATERIAL_TRANSACTION_ID) OVER(PARTITION BY Z.MSER_SERIAL_NUMBER_ID) CNT_ITEM_SERIAL
               ,CASE
                  WHEN ABS(Z.QTY_PRIMARY_MTRAN) != SUM(1)
                   OVER(PARTITION BY Z.MATERIAL_TRANSACTION_ID) THEN
                   '!'
                END AS ABNORMAL
               ,Z.QTY_PRIMARY_MTRAN
               ,SUM(1) OVER(PARTITION BY Z.MATERIAL_TRANSACTION_ID) AS XS_SUM_QTY
          FROM ( --
                 SELECT DISTINCT X.QTY_PRIMARY_MTRAN
                                 ,XS.MSER_SERIAL_NUMBER_ID
                                 ,X.ITEM_ITEM_ID_FOR
                                 ,X.MATERIAL_TRANSACTION_ID
                                 ,X.MTYP_TRANSACTION_TYPE_ID
                                 ,X.DAT_TRANSACTION_MTRAN
                   FROM MAM.MAM_MATERIAL_TRANSACTIONS X
                   LEFT OUTER JOIN MAM.MAM_TRANSACTION_SERIAL_NUMBERS XS
                     ON XS.MTRAN_MATERIAL_TRANSACTION_ID =
                        X.MATERIAL_TRANSACTION_ID
                  WHERE
                 /*X.DAT_TRANSACTION_MTRAN >=
                 TO_DATE('1400/01/01', 'YYYY/MM/DD', 'NLS_CALENDAR=PERSIAN')
                 AND*/
                  EXISTS
                  (SELECT NULL
                     FROM MAM.MAM_ITEMS I
                    WHERE I.ITEM_ID = X.ITEM_ITEM_ID_FOR
                          AND
                          (I.COD_ITEM =
                          (SELECT REPLACE(C, CHR(10), '')
                              FROM (SELECT UPPER(TRIM('&cod_item')) AS C FROM DUAL)) OR
                          (SELECT REPLACE(C, CHR(10), '')
                              FROM (SELECT UPPER(TRIM('&cod_item')) AS C FROM DUAL)) IS NULL)
                   --AND NVL(I.COD_SERIAL_NUMBER_CONTROL_ITEM, 0) = 1
                   )
                 
                 --
                 ) Z
          LEFT OUTER JOIN MAM.MAM_SERIAL_NUMBERS S
            ON Z.MSER_SERIAL_NUMBER_ID = S.SERIAL_NUMBER_ID
        --    where nvl(S.COD_SERIAL_NUMBER_MSER,0)not in('1')
        --
        )
 WHERE (&X = 0 OR CNT_ITEM_SERIAL != 2)
 ORDER BY --0 DESC, 
          COD_SERIAL_NUMBER
         ,DAT_TRANSACTION_MTRAN
