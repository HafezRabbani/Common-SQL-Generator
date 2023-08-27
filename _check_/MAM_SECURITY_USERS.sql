SELECT T.SECURITY_USER_ID
      ,T.LKP_LEVEL_MSECU
      ,T.COD_USR_MSECU
      ,(SELECT U.NAM_USER_USRS
          FROM FND.FND_USERS U
         WHERE U.IDE_USER_USRS = T.COD_USR_MSECU) AS NAM_USER_USRSFROM
  FROM MAM.MAM_SECURITY_USERS T
 WHERE T.MIHN_ITEM_HIERARCHY_NAME_ID IS NULL
 ORDER BY T.LKP_LEVEL_MSECU
         ,T.COD_USR_MSECU
--   FOR UPDATE