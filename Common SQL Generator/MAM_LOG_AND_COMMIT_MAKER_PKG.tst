PL/SQL Developer Test script 3.0
29
BEGIN
  :CHECK_FUNCTION_BODY            := APPS.MAM_LOG_AND_COMMIT_MAKER_PKG.CREATE_CHECK_ROUTINE(P_PACKAGE_NAME    => :P_PACKAGE_NAME
                                                                                           ,P_ROUTINE_NAME    => :P_ROUTINE_NAME
                                                                                           ,P_ROUTINE_CREATED => :CHECK_FUNCTION_BODY_OUT);
  :IMPLEMENTATION_OF_CHECK        := APPS.MAM_LOG_AND_COMMIT_MAKER_PKG.CREATE_IMPLEMENT_CHECK_ROUTINE(P_PACKAGE_NAME    => :P_PACKAGE_NAME
                                                                                                     ,P_ROUTINE_NAME    => :P_ROUTINE_NAME
                                                                                                     ,P_ROUTINE_CREATED => :IMPLEMENTATION_OF_CHECK_OUT);
  :LOG_AND_COMMIT_FUNCTIONS       := APPS.MAM_LOG_AND_COMMIT_MAKER_PKG.CREATE_LOG_ROUTINE(P_PACKAGE_NAME    => :P_PACKAGE_NAME
                                                                                         ,P_ROUTINE_NAME    => :P_ROUTINE_NAME
                                                                                         ,P_ROUTINE_CREATED => :LOG_FUNCTION_OUT) ||
                                     CHR(10) ||
                                     APPS.MAM_LOG_AND_COMMIT_MAKER_PKG.CREATE_COMMIT_ROUTINE(P_PACKAGE_NAME    => :P_PACKAGE_NAME
                                                                                            ,P_ROUTINE_NAME    => :P_ROUTINE_NAME
                                                                                            ,P_ROUTINE_CREATED => :COMMIT_FUNCTION_OUT);
  :WARNING                        := NULL;
  :CHECK_WARNING_FUNCTION_BODY    := APPS.MAM_LOG_AND_COMMIT_MAKER_PKG.CREATE_CHK_WRNNG_ROUTINE(P_PACKAGE_NAME    => :P_PACKAGE_NAME
                                                                                               ,P_ROUTINE_NAME    => :P_ROUTINE_NAME
                                                                                               ,P_ROUTINE_CREATED => :CHECK_FUNCTION_BODY_OUT);
  :IMPLEMENTATION_OF_CHECK_WRNNG  := APPS.MAM_LOG_AND_COMMIT_MAKER_PKG.CREATE_IMPL_CHCK_WRNNG_ROUTINE(P_PACKAGE_NAME    => :P_PACKAGE_NAME
                                                                                                     ,P_ROUTINE_NAME    => :P_ROUTINE_NAME
                                                                                                     ,P_ROUTINE_CREATED => :IMPLEMENTATION_OF_CHECK_OUT);
  :LOG_AND_COMMIT_WRNNG_FUNCTIONS := APPS.MAM_LOG_AND_COMMIT_MAKER_PKG.CREATE_LOG_WARNING_ROUTINE(P_PACKAGE_NAME    => :P_PACKAGE_NAME
                                                                                                 ,P_ROUTINE_NAME    => :P_ROUTINE_NAME
                                                                                                 ,P_ROUTINE_CREATED => :LOG_FUNCTION_OUT) ||
                                     CHR(10) ||
                                     APPS.MAM_LOG_AND_COMMIT_MAKER_PKG.CREATE_COMMIT_ROUTINE(P_PACKAGE_NAME    => :P_PACKAGE_NAME
                                                                                            ,P_ROUTINE_NAME    => :P_ROUTINE_NAME
                                                                                            ,P_ROUTINE_CREATED => :COMMIT_FUNCTION_OUT);
END;
13
P_PACKAGE_NAME
0
5
P_ROUTINE_NAME
0
5
CHECK_FUNCTION_BODY_OUT
0
5
IMPLEMENTATION_OF_CHECK_OUT
0
5
LOG_FUNCTION_OUT
0
5
COMMIT_FUNCTION_OUT
0
5
CHECK_FUNCTION_BODY
1
<CLOB>
4208
IMPLEMENTATION_OF_CHECK
1
<CLOB>
4208
LOG_AND_COMMIT_FUNCTIONS
1
<CLOB>
4208
WARNING
0
5
CHECK_WARNING_FUNCTION_BODY
1
<CLOB>
4208
IMPLEMENTATION_OF_CHECK_WRNNG
1
<CLOB>
4208
LOG_AND_COMMIT_WRNNG_FUNCTIONS
1
<CLOB>
4208
0
