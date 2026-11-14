CREATE OR REPLACE PACKAGE MAM_FORM_GENERATOR_PKG IS
  -- 
  -- DISABLE_MENU_MANUAL -------------------------------------------
  FUNCTION DISABLE_MENU_MANUAL RETURN CLOB;
  -- CUSTOM_BODY -------------------------------------------
  FUNCTION CUSTOM_BODY RETURN CLOB;
  -- LOOKUP -------------------------------------------
  FUNCTION LOOKUP( --
                  P_BLOCK_NAME     VARCHAR2
                 ,P_KEY_FIELD_NAME VARCHAR2
                  --     
                  ) RETURN CLOB;
  -- CHECK_ALL -------------------------------------------
  FUNCTION CHECK_ALL( --
                     P_BLOCK_NAME    VARCHAR2
                    ,P_CHECKBOX_NAME VARCHAR2
                     --     
                     ) RETURN CLOB;
  -- FIND_PRIOR_REC_ID -------------------------------------------
  FUNCTION FIND_PRIOR_REC_ID( --
                             P_BLOCK_NAME     VARCHAR2
                            ,P_KEY_FIELD_NAME VARCHAR2
                             --     
                             ) RETURN CLOB;
  -- KEY_ENTQRY -------------------------------------------
  FUNCTION KEY_ENTQRY RETURN CLOB;
  -- PRE_QUERY -------------------------------------------
  FUNCTION PRE_QUERY(P_BLOCK_NAME VARCHAR2) RETURN CLOB;
  -- POST_QUERY -------------------------------------------
  FUNCTION POST_QUERY(P_BLOCK_NAME VARCHAR2) RETURN CLOB;
  -- POST_TEXT_ITEM_NULLIFY -------------------------------------------
  FUNCTION POST_TEXT_ITEM_NULLIFY( --
                                  P_FIELD_NAME      VARCHAR2
                                 ,P_NULL_FIELD_NAME VARCHAR2
                                  --     
                                  ) RETURN CLOB;
END;
/
CREATE OR REPLACE PACKAGE BODY MAM_FORM_GENERATOR_PKG IS
  -- 
  -- DISABLE_MENU_MANUAL -------------------------------------------
  FUNCTION DISABLE_MENU_MANUAL RETURN CLOB IS
    LV_RESULT CLOB;
  BEGIN
    LV_RESULT := LV_RESULT || 'PROCEDURE DISABLE_MENU_MANUAL IS' || CHR(10);
    LV_RESULT := LV_RESULT || 'BEGIN' || CHR(10);
    LV_RESULT := LV_RESULT ||
                 '  SET_MENU_ITEM_PROPERTY(''Action.Save'', ENABLED, PROPERTY_FALSE);   ' ||
                 CHR(10);
    LV_RESULT := LV_RESULT ||
                 '  SET_MENU_ITEM_PROPERTY(''Action.Print'',ENABLED,PROPERTY_FALSE);' ||
                 CHR(10);
    LV_RESULT := LV_RESULT ||
                 '  SET_MENU_ITEM_PROPERTY(''Record.Insert'', ENABLED, PROPERTY_FALSE);' ||
                 CHR(10);
    LV_RESULT := LV_RESULT ||
                 '  SET_MENU_ITEM_PROPERTY(''Record.Remove'', ENABLED, PROPERTY_FALSE);' ||
                 CHR(10);
    LV_RESULT := LV_RESULT ||
                 '  SET_MENU_ITEM_PROPERTY(''Record.Previous'', ENABLED, PROPERTY_FALSE);' ||
                 CHR(10);
    LV_RESULT := LV_RESULT ||
                 '  SET_MENU_ITEM_PROPERTY(''Record.Next'', ENABLED, PROPERTY_FALSE);' ||
                 CHR(10);
    LV_RESULT := LV_RESULT ||
                 '  SET_MENU_ITEM_PROPERTY(''Record.FIRST_REC'', ENABLED, PROPERTY_FALSE);' ||
                 CHR(10);
    LV_RESULT := LV_RESULT ||
                 '  SET_MENU_ITEM_PROPERTY(''Record.LAST_REC'', ENABLED, PROPERTY_FALSE);' ||
                 CHR(10);
    LV_RESULT := LV_RESULT ||
                 '  SET_MENU_ITEM_PROPERTY(''Query.Enter'', ENABLED, PROPERTY_FALSE);' ||
                 CHR(10);
    LV_RESULT := LV_RESULT ||
                 '  SET_MENU_ITEM_PROPERTY(''Query.ENTER_execute'', ENABLED, PROPERTY_FALSE);' ||
                 CHR(10);
    LV_RESULT := LV_RESULT || 'END;' || CHR(10);
    RETURN LV_RESULT;
  END;
  -- CUSTOM_BODY -------------------------------------------
  FUNCTION CUSTOM_BODY RETURN CLOB IS
    LV_RESULT CLOB;
  BEGIN
    LV_RESULT := LV_RESULT || 'PACKAGE BODY CUSTOM IS' || CHR(10);
    LV_RESULT := LV_RESULT || '' || CHR(10);
    LV_RESULT := LV_RESULT || '  PROCEDURE WHEN_NEW_FORM_INSTANCE IS' ||
                 CHR(10);
    LV_RESULT := LV_RESULT || '  BEGIN' || CHR(10);
    LV_RESULT := LV_RESULT || '    LOOKUP_REQUEST(NULL);' || CHR(10);
    LV_RESULT := LV_RESULT ||
                 '    --SET_RECORD_PROPERTY(:SYSTEM.CURSOR_RECORD,''BLOCK_OPERATION'',STATUS,QUERY_STATUS);' ||
                 CHR(10);
    LV_RESULT := LV_RESULT || '  END;' || CHR(10);
    LV_RESULT := LV_RESULT || '' || CHR(10);
    LV_RESULT := LV_RESULT || '  PROCEDURE KEY_COMMIT IS' || CHR(10);
    LV_RESULT := LV_RESULT || '  BEGIN' || CHR(10);
    LV_RESULT := LV_RESULT || '    NULL;' || CHR(10);
    LV_RESULT := LV_RESULT || '  END;' || CHR(10);
    LV_RESULT := LV_RESULT || '' || CHR(10);
    LV_RESULT := LV_RESULT || '  PROCEDURE KEY_COMMIT2 IS' || CHR(10);
    LV_RESULT := LV_RESULT || '  BEGIN' || CHR(10);
    LV_RESULT := LV_RESULT || '    NULL;' || CHR(10);
    LV_RESULT := LV_RESULT || '  END;' || CHR(10);
    LV_RESULT := LV_RESULT || '' || CHR(10);
    LV_RESULT := LV_RESULT || '  PROCEDURE KEY_CLRFRM IS' || CHR(10);
    LV_RESULT := LV_RESULT || '  BEGIN' || CHR(10);
    LV_RESULT := LV_RESULT || '    NULL;' || CHR(10);
    LV_RESULT := LV_RESULT || '  END;' || CHR(10);
    LV_RESULT := LV_RESULT || '' || CHR(10);
    LV_RESULT := LV_RESULT || '  PROCEDURE KEY_CLRBLK IS' || CHR(10);
    LV_RESULT := LV_RESULT || '  BEGIN' || CHR(10);
    LV_RESULT := LV_RESULT || '    NULL;' || CHR(10);
    LV_RESULT := LV_RESULT || '  END;' || CHR(10);
    LV_RESULT := LV_RESULT || '' || CHR(10);
    LV_RESULT := LV_RESULT || '  PROCEDURE KEY_DELREC IS' || CHR(10);
    LV_RESULT := LV_RESULT || '  BEGIN' || CHR(10);
    LV_RESULT := LV_RESULT || '    NULL;' || CHR(10);
    LV_RESULT := LV_RESULT || '  END;' || CHR(10);
    LV_RESULT := LV_RESULT || '' || CHR(10);
    LV_RESULT := LV_RESULT || '  PROCEDURE KEY_ENTQRY IS' || CHR(10);
    LV_RESULT := LV_RESULT || '  BEGIN' || CHR(10);
    LV_RESULT := LV_RESULT || '    NULL;' || CHR(10);
    LV_RESULT := LV_RESULT || '  END;' || CHR(10);
    LV_RESULT := LV_RESULT || '' || CHR(10);
    LV_RESULT := LV_RESULT || '  PROCEDURE KEY_EXIT IS' || CHR(10);
    LV_RESULT := LV_RESULT || '  BEGIN' || CHR(10);
    LV_RESULT := LV_RESULT || '    NULL;' || CHR(10);
    LV_RESULT := LV_RESULT || '  END;' || CHR(10);
    LV_RESULT := LV_RESULT || '' || CHR(10);
    LV_RESULT := LV_RESULT || '  PROCEDURE KEY_MENU IS' || CHR(10);
    LV_RESULT := LV_RESULT || '  BEGIN' || CHR(10);
    LV_RESULT := LV_RESULT || '    NULL;' || CHR(10);
    LV_RESULT := LV_RESULT || '  END;' || CHR(10);
    LV_RESULT := LV_RESULT || '' || CHR(10);
    LV_RESULT := LV_RESULT || '  PROCEDURE PRE_FORM IS' || CHR(10);
    LV_RESULT := LV_RESULT || '  BEGIN' || CHR(10);
    LV_RESULT := LV_RESULT || '    NULL;' || CHR(10);
    LV_RESULT := LV_RESULT || '  END;' || CHR(10);
    LV_RESULT := LV_RESULT || '' || CHR(10);
    LV_RESULT := LV_RESULT || '  PROCEDURE KEY_EXEQRY IS' || CHR(10);
    LV_RESULT := LV_RESULT || '  BEGIN' || CHR(10);
    LV_RESULT := LV_RESULT || '    NULL;' || CHR(10);
    LV_RESULT := LV_RESULT || '  END;' || CHR(10);
    LV_RESULT := LV_RESULT || '' || CHR(10);
    LV_RESULT := LV_RESULT || '  PROCEDURE KEY_CQUERY IS' || CHR(10);
    LV_RESULT := LV_RESULT || '  BEGIN' || CHR(10);
    LV_RESULT := LV_RESULT || '    NULL;' || CHR(10);
    LV_RESULT := LV_RESULT || '  END;' || CHR(10);
    LV_RESULT := LV_RESULT || '' || CHR(10);
    LV_RESULT := LV_RESULT || '  PROCEDURE WHEN_TIMER_EXPIRED IS' ||
                 CHR(10);
    LV_RESULT := LV_RESULT || '  BEGIN' || CHR(10);
    LV_RESULT := LV_RESULT || '    NULL;' || CHR(10);
    LV_RESULT := LV_RESULT || '  END;' || CHR(10);
    LV_RESULT := LV_RESULT || '' || CHR(10);
    LV_RESULT := LV_RESULT || '  PROCEDURE WHEN_WINDOW_RESIZED IS' ||
                 CHR(10);
    LV_RESULT := LV_RESULT || '  BEGIN' || CHR(10);
    LV_RESULT := LV_RESULT || '    NULL;' || CHR(10);
    LV_RESULT := LV_RESULT || '  END;' || CHR(10);
    LV_RESULT := LV_RESULT || '' || CHR(10);
    LV_RESULT := LV_RESULT || '  PROCEDURE KEY_ENTER IS' || CHR(10);
    LV_RESULT := LV_RESULT || '  BEGIN' || CHR(10);
    LV_RESULT := LV_RESULT || '    NULL;' || CHR(10);
    LV_RESULT := LV_RESULT || '  END;' || CHR(10);
    LV_RESULT := LV_RESULT || '' || CHR(10);
    LV_RESULT := LV_RESULT || '  PROCEDURE KEY_DOWN IS' || CHR(10);
    LV_RESULT := LV_RESULT || '  BEGIN' || CHR(10);
    LV_RESULT := LV_RESULT || '    NULL;' || CHR(10);
    LV_RESULT := LV_RESULT || '  END;' || CHR(10);
    LV_RESULT := LV_RESULT || '' || CHR(10);
    LV_RESULT := LV_RESULT || '  PROCEDURE KEY_UP IS' || CHR(10);
    LV_RESULT := LV_RESULT || '  BEGIN' || CHR(10);
    LV_RESULT := LV_RESULT || '    NULL;' || CHR(10);
    LV_RESULT := LV_RESULT || '  END;' || CHR(10);
    LV_RESULT := LV_RESULT || '' || CHR(10);
    LV_RESULT := LV_RESULT || '  PROCEDURE KEY_SCRDOWN IS' || CHR(10);
    LV_RESULT := LV_RESULT || '  BEGIN' || CHR(10);
    LV_RESULT := LV_RESULT || '    NULL;' || CHR(10);
    LV_RESULT := LV_RESULT || '  END;' || CHR(10);
    LV_RESULT := LV_RESULT || '' || CHR(10);
    LV_RESULT := LV_RESULT || '  PROCEDURE KEY_SCRUP IS' || CHR(10);
    LV_RESULT := LV_RESULT || '  BEGIN' || CHR(10);
    LV_RESULT := LV_RESULT || '    NULL;' || CHR(10);
    LV_RESULT := LV_RESULT || '  END;' || CHR(10);
    LV_RESULT := LV_RESULT || '' || CHR(10);
    LV_RESULT := LV_RESULT || '  PROCEDURE KEY_CREREC IS' || CHR(10);
    LV_RESULT := LV_RESULT || '  BEGIN' || CHR(10);
    LV_RESULT := LV_RESULT || '    NULL;' || CHR(10);
    LV_RESULT := LV_RESULT || '  END;' || CHR(10);
    LV_RESULT := LV_RESULT || '' || CHR(10);
    LV_RESULT := LV_RESULT || '  PROCEDURE KEY_DUPREC IS' || CHR(10);
    LV_RESULT := LV_RESULT || '  BEGIN' || CHR(10);
    LV_RESULT := LV_RESULT || '    NULL;' || CHR(10);
    LV_RESULT := LV_RESULT || '  END;' || CHR(10);
    LV_RESULT := LV_RESULT || '' || CHR(10);
    LV_RESULT := LV_RESULT || '  PROCEDURE KEY_OTHERS IS' || CHR(10);
    LV_RESULT := LV_RESULT || '  BEGIN' || CHR(10);
    LV_RESULT := LV_RESULT || '    NULL;' || CHR(10);
    LV_RESULT := LV_RESULT || '  END;' || CHR(10);
    LV_RESULT := LV_RESULT || '' || CHR(10);
    LV_RESULT := LV_RESULT || '  PROCEDURE KEY_LISTVAL IS' || CHR(10);
    LV_RESULT := LV_RESULT || '  BEGIN' || CHR(10);
    LV_RESULT := LV_RESULT || '    NULL;' || CHR(10);
    LV_RESULT := LV_RESULT || '  END;' || CHR(10);
    LV_RESULT := LV_RESULT || '' || CHR(10);
    LV_RESULT := LV_RESULT || '  PROCEDURE KEY_NXTREC IS' || CHR(10);
    LV_RESULT := LV_RESULT || '  BEGIN' || CHR(10);
    LV_RESULT := LV_RESULT || '    NULL;' || CHR(10);
    LV_RESULT := LV_RESULT || '  END;' || CHR(10);
    LV_RESULT := LV_RESULT || '' || CHR(10);
    LV_RESULT := LV_RESULT || '  PROCEDURE KEY_PRVREC IS' || CHR(10);
    LV_RESULT := LV_RESULT || '  BEGIN' || CHR(10);
    LV_RESULT := LV_RESULT || '    NULL;' || CHR(10);
    LV_RESULT := LV_RESULT || '  END;' || CHR(10);
    LV_RESULT := LV_RESULT || '' || CHR(10);
    LV_RESULT := LV_RESULT || '  PROCEDURE BUT1_PRESS IS' || CHR(10);
    LV_RESULT := LV_RESULT || '  BEGIN' || CHR(10);
    LV_RESULT := LV_RESULT || '    NULL;' || CHR(10);
    LV_RESULT := LV_RESULT || '  END;' || CHR(10);
    LV_RESULT := LV_RESULT || '' || CHR(10);
    LV_RESULT := LV_RESULT || '  PROCEDURE BUT2_PRESS IS' || CHR(10);
    LV_RESULT := LV_RESULT || '  BEGIN' || CHR(10);
    LV_RESULT := LV_RESULT || '    NULL;' || CHR(10);
    LV_RESULT := LV_RESULT || '  END;' || CHR(10);
    LV_RESULT := LV_RESULT || '' || CHR(10);
    LV_RESULT := LV_RESULT || '  PROCEDURE BUT3_PRESS IS' || CHR(10);
    LV_RESULT := LV_RESULT || '  BEGIN' || CHR(10);
    LV_RESULT := LV_RESULT || '    NULL;' || CHR(10);
    LV_RESULT := LV_RESULT || '  END;' || CHR(10);
    LV_RESULT := LV_RESULT || '' || CHR(10);
    LV_RESULT := LV_RESULT || '  PROCEDURE BUT4_PRESS IS' || CHR(10);
    LV_RESULT := LV_RESULT || '  BEGIN' || CHR(10);
    LV_RESULT := LV_RESULT || '    NULL;' || CHR(10);
    LV_RESULT := LV_RESULT || '  END;' || CHR(10);
    LV_RESULT := LV_RESULT || 'END;' || CHR(10);
    RETURN LV_RESULT;
  END;
  -- LOOKUP -------------------------------------------
  FUNCTION LOOKUP( --
                  P_BLOCK_NAME     VARCHAR2
                 ,P_KEY_FIELD_NAME VARCHAR2
                  --     
                  ) RETURN CLOB IS
    LV_RESULT CLOB;
  BEGIN
    LV_RESULT := LV_RESULT || 'PROCEDURE LOOKUP_' || P_KEY_FIELD_NAME ||
                 '(P_' || P_KEY_FIELD_NAME || ' NUMBER) IS' || CHR(10);
    LV_RESULT := LV_RESULT || 'BEGIN' || CHR(10);
    LV_RESULT := LV_RESULT || '  GO_BLOCK(''' || P_BLOCK_NAME || ''');' ||
                 CHR(10);
    LV_RESULT := LV_RESULT || '  EXECUTE_QUERY;' || CHR(10);
    LV_RESULT := LV_RESULT || '  IF P_' || P_KEY_FIELD_NAME ||
                 ' IS NOT NULL' || CHR(10);
    LV_RESULT := LV_RESULT || '  THEN' || CHR(10);
    LV_RESULT := LV_RESULT || '    LOOP' || CHR(10);
    LV_RESULT := LV_RESULT ||
                 '      EXIT WHEN :SYSTEM.LAST_RECORD = ''TRUE'' OR :' ||
                 P_BLOCK_NAME || '.' || P_KEY_FIELD_NAME || ' = P_' ||
                 P_KEY_FIELD_NAME || ';' || CHR(10);
    LV_RESULT := LV_RESULT || '      NEXT_RECORD;' || CHR(10);
    LV_RESULT := LV_RESULT || '    END LOOP;' || CHR(10);
    LV_RESULT := LV_RESULT || '  END IF;' || CHR(10);
    LV_RESULT := LV_RESULT || 'END;' || CHR(10);
  
    RETURN LV_RESULT;
  END;
  -- CHECK_ALL -------------------------------------------
  FUNCTION CHECK_ALL( --
                     P_BLOCK_NAME    VARCHAR2
                    ,P_CHECKBOX_NAME VARCHAR2
                     --     
                     ) RETURN CLOB IS
    LV_RESULT CLOB;
  BEGIN
    LV_RESULT := LV_RESULT || 'PROCEDURE CHECK_ALL(P_CHECK NUMBER) IS';
    LV_RESULT := LV_RESULT || 'BEGIN';
    LV_RESULT := LV_RESULT || '  GO_BLOCK(' ||
                 APPS.MAM_TEXT_HANDLING_PKG.ENQUOTE_LITERAL(P_INPUT => P_BLOCK_NAME) || ');';
    LV_RESULT := LV_RESULT || '  FIRST_RECORD;';
    LV_RESULT := LV_RESULT || '  LOOP';
    LV_RESULT := LV_RESULT || '  	:' || P_CHECKBOX_NAME || ' := P_CHECK;';
    LV_RESULT := LV_RESULT || '    EXIT WHEN :SYSTEM.LAST_RECORD = ' ||
                 APPS.MAM_TEXT_HANDLING_PKG.ENQUOTE_LITERAL(P_INPUT => 'TRUE') || ';';
    LV_RESULT := LV_RESULT || '    NEXT_RECORD;';
    LV_RESULT := LV_RESULT || '  END LOOP;';
    LV_RESULT := LV_RESULT || 'END;';
  
    RETURN LV_RESULT;
  END;
  -- FIND_PRIOR_REC_ID -------------------------------------------
  FUNCTION FIND_PRIOR_REC_ID( --
                             P_BLOCK_NAME     VARCHAR2
                            ,P_KEY_FIELD_NAME VARCHAR2
                             --     
                             ) RETURN CLOB IS
    LV_RESULT CLOB;
  BEGIN
    LV_RESULT := LV_RESULT || 'FUNCTION FIND_PRIOR_' || P_KEY_FIELD_NAME ||
                 ' RETURN NUMBER IS' || CHR(10);
    LV_RESULT := LV_RESULT || 'BEGIN' || CHR(10);
    LV_RESULT := LV_RESULT || '  GO_BLOCK(''' || P_BLOCK_NAME || ''');' ||
                 CHR(10);
    LV_RESULT := LV_RESULT || '  IF :SYSTEM.CURSOR_RECORD = ''1''' ||
                 CHR(10);
    LV_RESULT := LV_RESULT || '  THEN' || CHR(10);
    LV_RESULT := LV_RESULT || '    RETURN NULL;' || CHR(10);
    LV_RESULT := LV_RESULT || '  ELSE' || CHR(10);
    LV_RESULT := LV_RESULT || '    PREVIOUS_RECORD;' || CHR(10);
    LV_RESULT := LV_RESULT || '    RETURN :' || P_BLOCK_NAME || '.' ||
                 P_KEY_FIELD_NAME || ';' || CHR(10);
    LV_RESULT := LV_RESULT || '  END IF;' || CHR(10);
    LV_RESULT := LV_RESULT || 'END;' || CHR(10);
    RETURN LV_RESULT;
  END;

  -- KEY_ENTQRY -------------------------------------------
  FUNCTION KEY_ENTQRY RETURN CLOB IS
    LV_RESULT CLOB;
  BEGIN
    LV_RESULT := LV_RESULT || 'BEGIN' || CHR(10);
    LV_RESULT := LV_RESULT || '  CUSTOM.GV_FILTER := NULL;' || CHR(10);
    LV_RESULT := LV_RESULT || '  GENERAL_EVENT.ACTION(''KEY-ENTQRY'');' ||
                 CHR(10);
    LV_RESULT := LV_RESULT || 'END;' || CHR(10);
    RETURN LV_RESULT;
  END;
  -- PRE_QUERY -------------------------------------------
  FUNCTION PRE_QUERY(P_BLOCK_NAME VARCHAR2) RETURN CLOB IS
    LV_RESULT CLOB;
  BEGIN
    LV_RESULT := LV_RESULT || 'DECLARE' || CHR(10);
    LV_RESULT := LV_RESULT || '  LV_ITEM  VARCHAR2(200);' || CHR(10);
    LV_RESULT := LV_RESULT || '  LV_VALUE VARCHAR2(4000);' || CHR(10);
    LV_RESULT := LV_RESULT || '  LV_AND   VARCHAR2(10);' || CHR(10);
    LV_RESULT := LV_RESULT || 'BEGIN' || CHR(10);
    LV_RESULT := LV_RESULT || '  CUSTOM.GV_FILTER := NULL;' || CHR(10);
    LV_RESULT := LV_RESULT || '  LV_ITEM          := GET_BLOCK_PROPERTY(''' ||
                 P_BLOCK_NAME || '''' || CHR(10);
    LV_RESULT := LV_RESULT ||
                 '                                        ,FIRST_ITEM);' ||
                 CHR(10);
    LV_RESULT := LV_RESULT || '  WHILE LV_ITEM IS NOT NULL' || CHR(10);
    LV_RESULT := LV_RESULT || '  LOOP' || CHR(10);
    LV_RESULT := LV_RESULT || '    LV_VALUE := NAME_IN(''' || P_BLOCK_NAME ||
                 '.'' || LV_ITEM);' || CHR(10);
    LV_RESULT := LV_RESULT || '    IF LV_VALUE IS NOT NULL' || CHR(10);
    LV_RESULT := LV_RESULT || '    THEN' || CHR(10);
    LV_RESULT := LV_RESULT ||
                 '      CUSTOM.GV_FILTER := CUSTOM.GV_FILTER || LV_AND || LV_ITEM || '' = '' ||' ||
                 CHR(10);
    LV_RESULT := LV_RESULT || '                          LV_VALUE;' ||
                 CHR(10);
    LV_RESULT := LV_RESULT || '      LV_AND           := '' AND '';' ||
                 CHR(10);
    LV_RESULT := LV_RESULT || '    END IF;' || CHR(10);
    LV_RESULT := LV_RESULT || '    LV_ITEM := GET_ITEM_PROPERTY(''' ||
                 P_BLOCK_NAME || '.'' || LV_ITEM' || CHR(10);
    LV_RESULT := LV_RESULT || '                                ,NEXTITEM);' ||
                 CHR(10);
    LV_RESULT := LV_RESULT || '  END LOOP;' || CHR(10);
    LV_RESULT := LV_RESULT || 'END;' || CHR(10);
    RETURN LV_RESULT;
  END;
  -- POST_QUERY -------------------------------------------
  FUNCTION POST_QUERY(P_BLOCK_NAME VARCHAR2) RETURN CLOB IS
    LV_RESULT CLOB;
  BEGIN
    LV_RESULT := LV_RESULT || 'DECLARE' || CHR(10);
    LV_RESULT := LV_RESULT || '  CUR_ITM             VARCHAR2(80);' ||
                 CHR(10);
    LV_RESULT := LV_RESULT || '  LV_VISUAL_ATTRIBUTE VARCHAR2(100);' ||
                 CHR(10);
    LV_RESULT := LV_RESULT || 'BEGIN' || CHR(10);
    LV_RESULT := LV_RESULT || '  IF :' || P_BLOCK_NAME ||
                 '.LKP_PRIORITY_MREQL = ''EMERGENCY''' || CHR(10);
    LV_RESULT := LV_RESULT || '  THEN' || CHR(10);
    LV_RESULT := LV_RESULT ||
                 '    LV_VISUAL_ATTRIBUTE := ''VA_EMERGENCY'';' || CHR(10);
    LV_RESULT := LV_RESULT || '  ELSIF :' || P_BLOCK_NAME ||
                 '.LKP_PRIORITY_MREQL = ''PLANNED''' || CHR(10);
    LV_RESULT := LV_RESULT || '  THEN' || CHR(10);
    LV_RESULT := LV_RESULT || '    LV_VISUAL_ATTRIBUTE := ''VA_PLANNED'';' ||
                 CHR(10);
    LV_RESULT := LV_RESULT || '  END IF;' || CHR(10);
    LV_RESULT := LV_RESULT || '  IF LV_VISUAL_ATTRIBUTE IS NOT NULL' ||
                 CHR(10);
    LV_RESULT := LV_RESULT || '  THEN' || CHR(10);
    LV_RESULT := LV_RESULT || '    CUR_ITM := GET_BLOCK_PROPERTY(''' ||
                 P_BLOCK_NAME || ''', FIRST_ITEM);' || CHR(10);
    LV_RESULT := LV_RESULT || '    WHILE (CUR_ITM IS NOT NULL)' || CHR(10);
    LV_RESULT := LV_RESULT || '    LOOP' || CHR(10);
    LV_RESULT := LV_RESULT || '      IF UPPER(GET_ITEM_PROPERTY(''' ||
                 P_BLOCK_NAME ||
                 '.'' ||CUR_ITM, ITEM_TYPE)) = ''TEXT ITEM''' || CHR(10);
    LV_RESULT := LV_RESULT || '         AND GET_ITEM_PROPERTY(''' ||
                 P_BLOCK_NAME || '.''|| CUR_ITM, ITEM_CANVAS) IS NOT NULL' ||
                 CHR(10);
    LV_RESULT := LV_RESULT || ' THEN' || CHR(10);
    LV_RESULT := LV_RESULT || ' SET_ITEM_INSTANCE_PROPERTY(''' ||
                 P_BLOCK_NAME || '.'' || CUR_ITM' || CHR(10);
    LV_RESULT := LV_RESULT ||
                 '                                  ,CURRENT_RECORD' ||
                 CHR(10);
    LV_RESULT := LV_RESULT ||
                 '                                  ,VISUAL_ATTRIBUTE' ||
                 CHR(10);
    LV_RESULT := LV_RESULT ||
                 '                                  ,LV_VISUAL_ATTRIBUTE);' ||
                 CHR(10);
    LV_RESULT := LV_RESULT || '      END IF;' || CHR(10);
    LV_RESULT := LV_RESULT ||
                 '      CUR_ITM := GET_ITEM_PROPERTY(CUR_ITM, NEXTITEM);' ||
                 CHR(10);
    LV_RESULT := LV_RESULT || '    END LOOP;' || CHR(10);
    LV_RESULT := LV_RESULT || '  END IF;' || CHR(10);
    LV_RESULT := LV_RESULT || 'END;' || CHR(10);
    RETURN LV_RESULT;
  END;

  -- POST_TEXT_ITEM_NULLIFY -------------------------------------------
  FUNCTION POST_TEXT_ITEM_NULLIFY( --
                                  P_FIELD_NAME      VARCHAR2
                                 ,P_NULL_FIELD_NAME VARCHAR2
                                  --     
                                  ) RETURN CLOB IS
    LV_RESULT CLOB;
  BEGIN
    LV_RESULT := LV_RESULT || 'BEGIN' || CHR(10);
    LV_RESULT := LV_RESULT || '  IF :' || P_FIELD_NAME || ' IS NULL ' ||
                 CHR(10);
    LV_RESULT := LV_RESULT || '  THEN' || CHR(10);
    LV_RESULT := LV_RESULT || '    :' || P_NULL_FIELD_NAME || ' := NULL;' ||
                 CHR(10);
    LV_RESULT := LV_RESULT || '  END IF;' || CHR(10);
    LV_RESULT := LV_RESULT || 'END;' || CHR(10);
    RETURN LV_RESULT;
  END;

BEGIN
  NULL;
END;
/
