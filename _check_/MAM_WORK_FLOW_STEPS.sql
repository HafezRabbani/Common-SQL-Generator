SELECT S.*
  FROM MAM.MAM_WORK_FLOW_STEPS S
 WHERE 1 = 1
   AND S.WORK_FLOW_STEP_ID IN (&WORK_FLOW_STEP_ID)
