SELECT L.LOG_ID
      ,TO_CHAR(L.CREATE_DATE
              ,'YYYY/MM/DD HH24:MI:SS'
              ,'NLS_CALENDAR=PERSIAN') AS CREATE_DATE_H
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
      --   AND L.LOG_ID IN (&LOG_ID)
   AND L.CREATE_DATE > TRUNC(SYSDATE)
 ORDER BY L.LOG_ID DESC
--
;
SELECT L.LOG_ID
      ,TO_CHAR(L.CREATE_DATE
              ,'YYYY/MM/DD HH24:MI:SS'
              ,'NLS_CALENDAR=PERSIAN') AS CREATE_DATE_H
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
      ,LR.TXT_RESPONSE_MLOGR
  FROM MAM.MAM_LOGS L
 INNER JOIN MAM.MAM_LOG_RESPONSES LR
    ON L.LOG_ID = LR.LOG_ID_MLOGR
 WHERE 1 = 1
      --   AND L.LOG_ID IN (&LOG_ID)
   AND LR.TXT_RESPONSE_MLOGR != 'OK'
   AND L.CREATE_DATE > TRUNC(SYSDATE)
 ORDER BY L.LOG_ID DESC
--
;
/*
DELETE MAM.MAM_LOG_RESPONSES L WHERE L.OS_USERNAME = 'h.rabbani';
DELETE MAM.MAM_LOGS L WHERE L.OS_USERNAME = 'h.rabbani';
*/
