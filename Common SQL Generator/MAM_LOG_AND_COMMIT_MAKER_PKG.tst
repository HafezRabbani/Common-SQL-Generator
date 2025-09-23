PL/SQL Developer Test script 3.0
15
BEGIN
  :RESULT1 := APPS.MAM_LOG_AND_COMMIT_MAKER_PKG.CREATE_CHECK_ROUTINE(P_PACKAGE_NAME    => :P_PACKAGE_NAME
                                                                    ,P_ROUTINE_NAME    => :P_ROUTINE_NAME
                                                                    ,P_ROUTINE_CREATED => :P_ROUTINE_CREATED1);
  :RESULT2 := APPS.MAM_LOG_AND_COMMIT_MAKER_PKG.CREATE_IMPLEMENT_CHECK_ROUTINE(P_PACKAGE_NAME    => :P_PACKAGE_NAME
                                                                              ,P_ROUTINE_NAME    => :P_ROUTINE_NAME
                                                                              ,P_ROUTINE_CREATED => :P_ROUTINE_CREATED2);
  :RESULT3 := APPS.MAM_LOG_AND_COMMIT_MAKER_PKG.CREATE_LOG_ROUTINE(P_PACKAGE_NAME    => :P_PACKAGE_NAME
                                                                  ,P_ROUTINE_NAME    => :P_ROUTINE_NAME
                                                                  ,P_ROUTINE_CREATED => :P_ROUTINE_CREATED3) ||
              CHR(10) ||
              APPS.MAM_LOG_AND_COMMIT_MAKER_PKG.CREATE_COMMIT_ROUTINE(P_PACKAGE_NAME    => :P_PACKAGE_NAME
                                                                     ,P_ROUTINE_NAME    => :P_ROUTINE_NAME
                                                                     ,P_ROUTINE_CREATED => :P_ROUTINE_CREATED4);
END;
9
P_PACKAGE_NAME
0
5
P_ROUTINE_NAME
0
5
result1
1
<CLOB>
112
P_ROUTINE_CREATED1
0
5
result2
1
<CLOB>
112
P_ROUTINE_CREATED2
0
5
result3
1
<CLOB>
112
P_ROUTINE_CREATED3
0
5
P_ROUTINE_CREATED4
0
5
0
