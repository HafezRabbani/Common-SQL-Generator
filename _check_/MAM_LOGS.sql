SELECT L.LOG_ID
      ,L.TXT_LOG
      ,L.NAM_CALLER_ROUTINE_MLOGS
      ,L.TXT_PARAMETERS_MLOGS
      ,L.LAST_CHANGE_TS
      ,L.MODULE_NAME
      ,L.OS_USERNAME
      ,L.NAM_SESSION_MLOGS
      ,L.NAM_MAC_MLOGS
      ,L.NAM_IP_MLOGS
      ,L.NAM_COMPUTER_NAME_MLOGS
      ,L.CREATE_DATE
      ,L.CREATE_BY_DB_USER
      ,L.CREATE_BY_APP_USER
  FROM MAM.MAM_LOGS L
 WHERE 1 = 1
   AND L.LOG_ID IN (&LOG_ID)
--
;
