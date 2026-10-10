CREATE OR REPLACE PACKAGE MAM_PACKAGE_GENERATOR_PKG IS
  -- 
  -- MAKE_SPEC ------------------------------
  FUNCTION MAKE_SPEC(P_PACKAGE_NAME VARCHAR2) RETURN CLOB;
  -- MAKE_BODY ------------------------------
  FUNCTION MAKE_BODY( --
                     P_FORM_NAME    VARCHAR2
                    ,P_PACKAGE_NAME VARCHAR2
                     --     
                     ) RETURN CLOB;
  -- MAKE ------------------------------
  FUNCTION MAKE( --
                P_FORM_NAME    VARCHAR2
               ,P_PACKAGE_NAME OUT VARCHAR2
               ,P_LENGHT       OUT NUMBER
                --     
                ) RETURN VARCHAR2;

END;
/
CREATE OR REPLACE PACKAGE BODY MAM_PACKAGE_GENERATOR_PKG IS
  -- 
  C_CHECK_AUTHORIZATION_1      CONSTANT VARCHAR2(128) := 'IDENTIFY AUTHORIZED GROUPS';
  C_CHECK_AUTHORIZATION_1_CMNT CONSTANT VARCHAR2(128) := 'AUTHORIZED GROUPS';

  C_CHECK_AUTHORIZATION_2      CONSTANT VARCHAR2(128) := 'AUTHORIZED_GROUPS';
  C_CHECK_AUTHORIZATION_2_CMNT CONSTANT VARCHAR2(128) := 'AUTHORIZED GROUPS';

  C_CHECK_AUTHORIZATION_3      CONSTANT VARCHAR2(128) := 'IS_USR_ATHRZD_ON_FORM';
  C_CHECK_AUTHORIZATION_3_CMNT CONSTANT VARCHAR2(128) := 'IS USER ATHORIZED ON FORM';

  C_CHECK_AUTHORIZATION_4      CONSTANT VARCHAR2(128) := 'IS_CURRENT_USR_ATHRZD_ON_FORM';
  C_CHECK_AUTHORIZATION_4_CMNT CONSTANT VARCHAR2(128) := 'IS CURRENT USER ATHORIZED ON FORM';

  C_CHECK_AUTHORIZATION_5      CONSTANT VARCHAR2(128) := 'CHECK_CRNT_USR_ATHRZD_ON_FORM';
  C_CHECK_AUTHORIZATION_5_CMNT CONSTANT VARCHAR2(128) := 'CHECK IF CURRENT USER IS AUTHORIZED ON FORM';
  -- CREATE_AUTHORIZED_GROUPS ------------------------------
  FUNCTION CREATE_GROUP_ROW_AND_TAB RETURN CLOB IS
    LV_RESULT CLOB;
  BEGIN
    LV_RESULT := LV_RESULT || '  -- ' || CHR(10);
    LV_RESULT := LV_RESULT || '  TYPE GROUP_ROW IS RECORD( --' || CHR(10);
    LV_RESULT := LV_RESULT || '     GROUP_NAME VARCHAR2(100)' || CHR(10);
    LV_RESULT := LV_RESULT || '    --' || CHR(10);
    LV_RESULT := LV_RESULT || '    );' || CHR(10);
    LV_RESULT := LV_RESULT || '  TYPE GROUP_TAB IS TABLE OF GROUP_ROW;' ||
                 CHR(10) || CHR(10);
    LV_RESULT := LV_RESULT ||
                 '  -- GET_FORM_NAME -----------------------------------------' ||
                 CHR(10);
    LV_RESULT := LV_RESULT || '  FUNCTION GET_FORM_NAME RETURN VARCHAR2;' ||
                 CHR(10);
    RETURN LV_RESULT;
  END;
  -- CHECK_AUTHORIZATION_1_DCL ------------------------------
  FUNCTION CHECK_AUTHORIZATION_1_DCL RETURN CLOB IS
    LV_RESULT CLOB;
  BEGIN
    /*
    LV_RESULT := LV_RESULT || CHR(10) || '  -- ' ||
                 C_CHECK_AUTHORIZATION_1_CMNT ||
                 ' -----------------------------------------' || CHR(10);
    LV_RESULT := LV_RESULT || '  FUNCTION ' || C_CHECK_AUTHORIZATION_1 ||
                 ' RETURN GROUP_TAB' || CHR(10);
    LV_RESULT := LV_RESULT || '    PIPELINED;' || CHR(10);
    */
    RETURN LV_RESULT;
  END;
  -- CHECK_AUTHORIZATION_1_BODY ------------------------------
  FUNCTION CHECK_AUTHORIZATION_1_BODY(P_FORM_NAME VARCHAR2) RETURN CLOB IS
    LV_RESULT CLOB;
  BEGIN
    LV_RESULT := LV_RESULT ||
                 '  C_FORM_NAME CONSTANT FND.FND_MENU_NODES.PROG_NAM_PRG_PROG%TYPE := ''' ||
                 UPPER(TRIM(P_FORM_NAME)) || ''';' || CHR(10) || CHR(10);
    LV_RESULT := LV_RESULT ||
                 '  -- GET_FORM_NAME -----------------------------------------' ||
                 CHR(10);
    LV_RESULT := LV_RESULT || '  FUNCTION GET_FORM_NAME RETURN VARCHAR2 IS' ||
                 CHR(10);
    LV_RESULT := LV_RESULT || '  BEGIN' || CHR(10);
    LV_RESULT := LV_RESULT || '    RETURN C_FORM_NAME;' || CHR(10);
    LV_RESULT := LV_RESULT || '  END;' || CHR(10);
    RETURN LV_RESULT;
  END;
  -- CHECK_AUTHORIZATION_2_DCL ------------------------------
  FUNCTION CHECK_AUTHORIZATION_2_DCL RETURN CLOB IS
    LV_RESULT CLOB;
  BEGIN
    LV_RESULT := LV_RESULT || CHR(10) || '  -- ' ||
                 C_CHECK_AUTHORIZATION_2_CMNT ||
                 ' -----------------------------------------' || CHR(10);
    LV_RESULT := LV_RESULT || '  FUNCTION ' || C_CHECK_AUTHORIZATION_2 ||
                 ' RETURN GROUP_TAB' || CHR(10);
    LV_RESULT := LV_RESULT || '    PIPELINED;' || CHR(10);
    RETURN LV_RESULT;
  END;
  -- CHECK_AUTHORIZATION_2_BODY ------------------------------
  FUNCTION CHECK_AUTHORIZATION_2_BODY(P_FORM_NAME VARCHAR2) RETURN CLOB IS
    LV_RESULT CLOB;
  BEGIN
    LV_RESULT := LV_RESULT || CHR(10) || '  -- ' ||
                 C_CHECK_AUTHORIZATION_2_CMNT ||
                 ' -----------------------------------------' || CHR(10);
    LV_RESULT := LV_RESULT || '  FUNCTION ' || C_CHECK_AUTHORIZATION_2 ||
                 ' RETURN GROUP_TAB' || CHR(10);
    LV_RESULT := LV_RESULT || '    PIPELINED IS' || CHR(10);
    LV_RESULT := LV_RESULT || '    LV_ROW GROUP_ROW;' || CHR(10);
    LV_RESULT := LV_RESULT || '  BEGIN' || CHR(10);
    LV_RESULT := LV_RESULT || '    FOR C IN ( --' || CHR(10);
    LV_RESULT := LV_RESULT ||
                 '              SELECT G.IDE_GRP_GROUP AS GROUP_NAME' ||
                 CHR(10);
    LV_RESULT := LV_RESULT || '                FROM FND.FND_GROUPS G' ||
                 CHR(10);
    LV_RESULT := LV_RESULT ||
                 '               WHERE UPPER(TRIM(G.IDE_GRP_GROUP)) IN ( --' ||
                 CHR(10);
    LV_RESULT := LV_RESULT ||
                 '                                                      UPPER(TRIM(''' ||
                 UPPER(SUBSTR(P_FORM_NAME, 2, 3)) || '_ADMIN''))' ||
                 CHR(10);
    LV_RESULT := LV_RESULT ||
                 '                                                      --                      ' ||
                 CHR(10);
    LV_RESULT := LV_RESULT ||
                 '                                                      )' ||
                 CHR(10);
    LV_RESULT := LV_RESULT || '              --                      ' ||
                 CHR(10);
    LV_RESULT := LV_RESULT || '              )' || CHR(10);
    LV_RESULT := LV_RESULT || '    LOOP' || CHR(10);
    LV_RESULT := LV_RESULT || '      LV_ROW.GROUP_NAME := C.GROUP_NAME;' ||
                 CHR(10);
    LV_RESULT := LV_RESULT || '      PIPE ROW(LV_ROW);' || CHR(10);
    LV_RESULT := LV_RESULT || '    END LOOP;' || CHR(10);
    LV_RESULT := LV_RESULT || '  END;' || CHR(10);
    RETURN LV_RESULT;
  END;
  -- CHECK_AUTHORIZATION_3_DCL ------------------------------
  FUNCTION CHECK_AUTHORIZATION_3_DCL RETURN CLOB IS
    LV_RESULT CLOB;
  BEGIN
    LV_RESULT := LV_RESULT || '  -- ' || C_CHECK_AUTHORIZATION_3_CMNT ||
                 ' -----------------------------------------' || CHR(10);
    LV_RESULT := LV_RESULT || '  FUNCTION ' || C_CHECK_AUTHORIZATION_3 ||
                 '(P_IDE_USER_USRS FND.FND_USERS.IDE_USER_USRS%TYPE)' ||
                 CHR(10);
    LV_RESULT := LV_RESULT || '    RETURN NUMBER;' || CHR(10);
    RETURN LV_RESULT;
  END;
  -- CHECK_AUTHORIZATION_3_BODY ------------------------------
  FUNCTION CHECK_AUTHORIZATION_3_BODY(P_PACKAGE_NAME VARCHAR2) RETURN CLOB IS
    LV_RESULT CLOB;
  BEGIN
    LV_RESULT := LV_RESULT || '  -- ' || C_CHECK_AUTHORIZATION_3_CMNT ||
                 ' -----------------------------------------' || CHR(10);
    LV_RESULT := LV_RESULT || '  FUNCTION ' || C_CHECK_AUTHORIZATION_3 ||
                 '(P_IDE_USER_USRS FND.FND_USERS.IDE_USER_USRS%TYPE)' ||
                 CHR(10);
    LV_RESULT := LV_RESULT || '    RETURN NUMBER IS' || CHR(10);
    LV_RESULT := LV_RESULT || '    LV_RESULT NUMBER := 0;' || CHR(10);
    LV_RESULT := LV_RESULT || '  BEGIN' || CHR(10);
    LV_RESULT := LV_RESULT ||
                 '    LV_RESULT := "MAM_AUTHENTICATE_AUTHORIZE_PKG".IS_USER_ATHORIZED_ON_FORM(P_IDE_USER  => P_IDE_USER_USRS' ||
                 CHR(10);
    LV_RESULT := LV_RESULT ||
                 '                                                                           ,P_FORM_NAME => C_FORM_NAME);' ||
                 CHR(10);
    LV_RESULT := LV_RESULT || '    IF LV_RESULT = 0' || CHR(10);
    LV_RESULT := LV_RESULT || '    THEN' || CHR(10);
    LV_RESULT := LV_RESULT || '      BEGIN' || CHR(10);
    LV_RESULT := LV_RESULT || '        SELECT 1' || CHR(10);
    LV_RESULT := LV_RESULT || '          INTO LV_RESULT' || CHR(10);
    LV_RESULT := LV_RESULT || '          FROM DUAL' || CHR(10);
    LV_RESULT := LV_RESULT || '         WHERE EXISTS (SELECT NULL' ||
                 CHR(10);
    LV_RESULT := LV_RESULT ||
                 '                  FROM FND.FND_GROUP_USERS GU' || CHR(10);
    LV_RESULT := LV_RESULT ||
                 '                 WHERE UPPER(TRIM(GU.GROUP_IDE_GRP_GROUP)) IN ( --' ||
                 CHR(10);
    LV_RESULT := LV_RESULT ||
                 '                                                               SELECT T.GROUP_NAME' ||
                 CHR(10);
    LV_RESULT := LV_RESULT ||
                 '                                                                 FROM TABLE(' ||
                 P_PACKAGE_NAME || '.AUTHORIZED_GROUPS) T' || CHR(10);
    LV_RESULT := LV_RESULT ||
                 '                                                               --  ' ||
                 CHR(10);
    LV_RESULT := LV_RESULT ||
                 '                                                               )' ||
                 CHR(10);
    LV_RESULT := LV_RESULT ||
                 '                   AND UPPER(TRIM(GU.USRS_IDE_USER_USRS)) =' ||
                 CHR(10);
    LV_RESULT := LV_RESULT ||
                 '                       UPPER(TRIM(P_IDE_USER_USRS)))' ||
                 CHR(10);
    LV_RESULT := LV_RESULT || '        --                        ' ||
                 CHR(10);
    LV_RESULT := LV_RESULT || '        ;' || CHR(10);
    LV_RESULT := LV_RESULT || '      EXCEPTION' || CHR(10);
    LV_RESULT := LV_RESULT || '        WHEN OTHERS THEN' || CHR(10);
    LV_RESULT := LV_RESULT || '          LV_RESULT := 0;' || CHR(10);
    LV_RESULT := LV_RESULT || '      END;' || CHR(10);
    LV_RESULT := LV_RESULT || '    END IF;' || CHR(10);
    LV_RESULT := LV_RESULT || '    RETURN LV_RESULT;' || CHR(10);
    LV_RESULT := LV_RESULT || '  END;' || CHR(10);
    RETURN LV_RESULT;
  END;
  -- CHECK_AUTHORIZATION_4_DCL ------------------------------
  FUNCTION CHECK_AUTHORIZATION_4_DCL RETURN CLOB IS
    LV_RESULT CLOB;
  BEGIN
    LV_RESULT := LV_RESULT || '  -- ' || C_CHECK_AUTHORIZATION_4_CMNT ||
                 ' -----------------------------------------' || CHR(10);
    LV_RESULT := LV_RESULT || '  FUNCTION ' || C_CHECK_AUTHORIZATION_4 ||
                 ' RETURN NUMBER;' || CHR(10);
    RETURN LV_RESULT;
  END;
  -- CHECK_AUTHORIZATION_4_BODY ------------------------------
  FUNCTION CHECK_AUTHORIZATION_4_BODY RETURN CLOB IS
    LV_RESULT CLOB;
  BEGIN
    LV_RESULT := LV_RESULT || '  -- ' || C_CHECK_AUTHORIZATION_4_CMNT ||
                 ' -----------------------------------------' || CHR(10);
    LV_RESULT := LV_RESULT || '  FUNCTION ' || C_CHECK_AUTHORIZATION_4 ||
                 ' RETURN NUMBER IS' || CHR(10);
    LV_RESULT := LV_RESULT || '  BEGIN' || CHR(10);
    LV_RESULT := LV_RESULT ||
                 '    RETURN IS_USR_ATHRZD_ON_FORM(MAM_AUTHENTICATE_AUTHORIZE_PKG.GET_CURRENT_USER);' ||
                 CHR(10);
    LV_RESULT := LV_RESULT || '  END;' || CHR(10);
    RETURN LV_RESULT;
  END;

  -- CHECK_AUTHORIZATION_5_DCL ------------------------------
  FUNCTION CHECK_AUTHORIZATION_5_DCL RETURN CLOB IS
    LV_RESULT CLOB;
  BEGIN
    LV_RESULT := LV_RESULT || '  -- ' || C_CHECK_AUTHORIZATION_5_CMNT ||
                 ' -----------------------------------------' || CHR(10);
    LV_RESULT := LV_RESULT || '  FUNCTION ' || C_CHECK_AUTHORIZATION_5 ||
                 ' RETURN VARCHAR2;' || CHR(10);
    RETURN LV_RESULT;
  END;
  -- CHECK_AUTHORIZATION_5_BODY ------------------------------
  FUNCTION CHECK_AUTHORIZATION_5_BODY RETURN CLOB IS
    LV_RESULT CLOB;
  BEGIN
    LV_RESULT := LV_RESULT || '  -- ' || C_CHECK_AUTHORIZATION_5_CMNT ||
                 ' -----------------------------------------' || CHR(10);
    LV_RESULT := LV_RESULT || '  FUNCTION ' || C_CHECK_AUTHORIZATION_5 ||
                 ' RETURN VARCHAR2 IS' || CHR(10);
    LV_RESULT := LV_RESULT || ' lv_error_message VARCHAR2(300); BEGIN' ||
                 CHR(10);
    LV_RESULT := LV_RESULT ||
                 '    if IS_USR_ATHRZD_ON_FORM(MAM_AUTHENTICATE_AUTHORIZE_PKG.GET_CURRENT_USER)=0 ' ||
                 CHR(10);
    LV_RESULT := LV_RESULT || '    then ' || CHR(10);
    LV_RESULT := LV_RESULT ||
                 '         LV_ERROR_MESSAGE:=''{شما مجاز به انجام این کار نیستید}''; END IF;' ||
                 CHR(10);
    LV_RESULT := LV_RESULT || '    RETURN LV_ERROR_MESSAGE; ' || CHR(10);
    LV_RESULT := LV_RESULT || '  END;' || CHR(10);
    RETURN LV_RESULT;
  END;
  -- MAKE_SPEC ------------------------------
  FUNCTION MAKE_SPEC(P_PACKAGE_NAME VARCHAR2) RETURN CLOB IS
    LV_DECLARATION CLOB;
  BEGIN
    LV_DECLARATION := LV_DECLARATION || '--' || CHR(10);
    LV_DECLARATION := LV_DECLARATION ||
                      MAM_PACKAGE_GENERATOR_PKG.CREATE_GROUP_ROW_AND_TAB;
    LV_DECLARATION := LV_DECLARATION ||
                      MAM_PACKAGE_GENERATOR_PKG.CHECK_AUTHORIZATION_1_DCL ||
                      CHR(10);
    LV_DECLARATION := LV_DECLARATION ||
                      MAM_PACKAGE_GENERATOR_PKG.CHECK_AUTHORIZATION_2_DCL ||
                      CHR(10);
    LV_DECLARATION := LV_DECLARATION ||
                      MAM_PACKAGE_GENERATOR_PKG.CHECK_AUTHORIZATION_3_DCL ||
                      CHR(10);
    LV_DECLARATION := LV_DECLARATION ||
                      MAM_PACKAGE_GENERATOR_PKG.CHECK_AUTHORIZATION_4_DCL ||
                      CHR(10);
    LV_DECLARATION := LV_DECLARATION ||
                      MAM_PACKAGE_GENERATOR_PKG.CHECK_AUTHORIZATION_5_DCL ||
                      CHR(10);
    RETURN LV_DECLARATION;
  END;
  -- MAKE_BODY ------------------------------
  FUNCTION MAKE_BODY( --
                     P_FORM_NAME    VARCHAR2
                    ,P_PACKAGE_NAME VARCHAR2
                     --     
                     ) RETURN CLOB IS
    LV_BODY CLOB;
  BEGIN
    LV_BODY := LV_BODY || '--' || CHR(10);
    LV_BODY := LV_BODY ||
               MAM_PACKAGE_GENERATOR_PKG.CHECK_AUTHORIZATION_1_BODY(P_FORM_NAME => P_FORM_NAME) ||
               CHR(10);
    LV_BODY := LV_BODY ||
               MAM_PACKAGE_GENERATOR_PKG.CHECK_AUTHORIZATION_2_BODY(P_FORM_NAME => P_FORM_NAME) ||
               CHR(10);
    LV_BODY := LV_BODY ||
               MAM_PACKAGE_GENERATOR_PKG.CHECK_AUTHORIZATION_3_BODY(P_PACKAGE_NAME => P_PACKAGE_NAME) ||
               CHR(10);
    LV_BODY := LV_BODY ||
               MAM_PACKAGE_GENERATOR_PKG.CHECK_AUTHORIZATION_4_BODY ||
               CHR(10);
    LV_BODY := LV_BODY ||
               MAM_PACKAGE_GENERATOR_PKG.CHECK_AUTHORIZATION_5_BODY ||
               CHR(10);
    RETURN LV_BODY;
  END;
  -- MAKE_PACKAGE_NAME ------------------------------
  FUNCTION MAKE_PACKAGE_NAME(P_FORM_NAME VARCHAR2) RETURN VARCHAR2 IS
    LV_RESULT VARCHAR2(1000);
  BEGIN
    IF SUBSTR(TRIM(P_FORM_NAME), 5, 1) = '_'
    THEN
      LV_RESULT := SUBSTR(TRIM(P_FORM_NAME)
                         ,2
                         ,LENGTH(TRIM(P_FORM_NAME)) - 1) || '_pkg';
    ELSE
      LV_RESULT := SUBSTR(TRIM(P_FORM_NAME), 2, 3) || '_' ||
                   SUBSTR(TRIM(P_FORM_NAME)
                         ,5
                         ,LENGTH(TRIM(P_FORM_NAME)) - 4) || '_pkg';
    END IF;
    LV_RESULT := UPPER(LV_RESULT);
    RETURN LV_RESULT;
  END;
  -- MAKE ------------------------------
  FUNCTION MAKE( --
                P_FORM_NAME    VARCHAR2
               ,P_PACKAGE_NAME OUT VARCHAR2
               ,P_LENGHT       OUT NUMBER
                --     
                ) RETURN VARCHAR2 IS
    LV_RESULT      VARCHAR2(32000);
    LV_FORM_NAME   VARCHAR2(1000);
    LV_DECLARATION CLOB;
    LV_BODY        CLOB;
  BEGIN
  
    P_PACKAGE_NAME := MAKE_PACKAGE_NAME(P_FORM_NAME => P_FORM_NAME);
    P_LENGHT       := LENGTH(P_PACKAGE_NAME);
    LV_DECLARATION := 'create package ' || P_PACKAGE_NAME || ' is ' ||
                      CHR(10) ||
                      MAM_PACKAGE_GENERATOR_PKG.MAKE_SPEC(P_PACKAGE_NAME => P_PACKAGE_NAME) ||
                      'end;' || CHR(10);
    LV_BODY        := 'create package body ' || P_PACKAGE_NAME || ' is ' ||
                      CHR(10) ||
                      MAM_PACKAGE_GENERATOR_PKG.MAKE_BODY( --
                                                          P_FORM_NAME    => P_FORM_NAME
                                                         ,P_PACKAGE_NAME => P_PACKAGE_NAME
                                                          --                                                          
                                                          ) || CHR(10) ||
                      'begin null; end;' || CHR(10);
    BEGIN
      EXECUTE IMMEDIATE LV_DECLARATION;
      EXECUTE IMMEDIATE LV_BODY;
    EXCEPTION
      WHEN OTHERS THEN
        LV_RESULT := '{' || P_PACKAGE_NAME || ' خطا دارد ' || SQLERRM || '}';
    END;
    RETURN LV_RESULT;
  END;

BEGIN
  NULL;
END;
/
