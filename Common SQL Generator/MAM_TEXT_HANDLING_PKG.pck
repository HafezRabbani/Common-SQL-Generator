CREATE OR REPLACE PACKAGE MAM_TEXT_HANDLING_PKG IS
  -- ENQUOTE_LITERAL -----------------------------------------
  FUNCTION ENQUOTE_LITERAL( --
                           P_INPUT VARCHAR2
                           --
                           ) RETURN VARCHAR2;

  -- MAKE_TABLE_FROM_VALUES -----------------------------------------
  FUNCTION MAKE_TABLE_FROM_VALUES( --
                                  P_COLUMN1_VALUE    VARCHAR2
                                 ,P_COLUMN1_ALIAS    VARCHAR2
                                 ,P_COLUMN2_VALUE    VARCHAR2
                                 ,P_COLUMN2_ALIAS    VARCHAR2
                                 ,P_WITH_ROW_COUNTER NUMBER --0 WITHOUT ROW COUNTER 
                                  --
                                  ) RETURN VARCHAR2;
/*
  -- MAKE_TABLE_FROM_VALUES -----------------------------------------
  FUNCTION MAKE_TABLE_FROM_VALUES( --
                                  P_VALUES           VARCHAR2
                                 ,P_ALIASES          VARCHAR2
                                 ,P_WITH_ROW_COUNTER NUMBER --0 WITHOUT ROW COUNTER 
                                  --
                                  ) RETURN VARCHAR2;
*/

END;
/
CREATE OR REPLACE PACKAGE BODY MAM_TEXT_HANDLING_PKG IS

  -- ENQUOTE_LITERAL -----------------------------------------
  FUNCTION ENQUOTE_LITERAL( --
                           P_INPUT VARCHAR2
                           --
                           ) RETURN VARCHAR2 IS
  BEGIN
    RETURN DBMS_ASSERT.ENQUOTE_LITERAL(P_INPUT);
  END;
  -- MAKE_COLUMN -----------------------------------------
  FUNCTION MAKE_COLUMN( --
                       P_COL_VALUE    VARCHAR2
                      ,P_COLUMN_ALIAS VARCHAR2
                      ,P_COL_COUNTER  NUMBER
                      ,P_IS_NUMBER    NUMBER
                       --
                       ) RETURN VARCHAR2 IS
    LV_RESULT VARCHAR2(32767);
    LV_PRE_ADDITIVE CONSTANT VARCHAR2(100) := UPPER(CASE
                                                      WHEN P_COL_COUNTER = 1 THEN
                                                       NULL
                                                      ELSE
                                                       ', '
                                                    END);
    LV_POST_ADDITIVE CONSTANT VARCHAR2(100) := UPPER(' as ' || CASE
                                                       WHEN TRIM(P_COLUMN_ALIAS) IS NULL THEN
                                                        'col___' || P_COL_COUNTER
                                                       ELSE
                                                        TRIM(P_COLUMN_ALIAS)
                                                     END);
    LV_COL_VALUE VARCHAR2(32767);
  BEGIN
    LV_COL_VALUE := TRIM(P_COL_VALUE);
    IF LV_COL_VALUE IS NOT NULL
    THEN
      IF NVL(P_IS_NUMBER, 0) = 0
      THEN
        LV_COL_VALUE := MAM_TEXT_HANDLING_PKG.ENQUOTE_LITERAL(P_INPUT => LV_COL_VALUE);
      END IF;
    END IF;
  
    LV_RESULT := LV_PRE_ADDITIVE || CASE
                   WHEN LV_COL_VALUE IS NULL THEN
                    'null'
                   ELSE
                    LV_COL_VALUE
                 END || LV_POST_ADDITIVE;
    RETURN LV_RESULT;
  END;
  -- MAKE_ROW -----------------------------------------
  FUNCTION MAKE_ROW( --
                    P_COLUMN1_VALUE    VARCHAR2
                   ,P_COLUMN1_ALIAS    VARCHAR2
                   ,P_WITH_ROW_COUNTER NUMBER --0 WITHOUT ROW COUNTER 
                   ,P_COUNTER          NUMBER
                    --
                    ) RETURN VARCHAR2 IS
    LV_RESULT VARCHAR2(32767);
    C_PRE_ADDITIVE CONSTANT VARCHAR2(100) := UPPER(CASE
                                                     WHEN P_COUNTER = 1 THEN
                                                      'select '
                                                     ELSE
                                                      CHR(10) || ' union ' ||
                                                      CHR(10) || 'select '
                                                   END);
    C_FINAL_ADDITIVE CONSTANT VARCHAR2(100) := UPPER(' from dual');
    LV_COLUMN_COUNTER NUMBER := 1;
  BEGIN
    LV_RESULT := C_PRE_ADDITIVE;
    IF NVL(P_WITH_ROW_COUNTER, 0) > 0
    THEN
      LV_RESULT         := LV_RESULT || MAKE_COLUMN( --
                                                    P_COL_VALUE    => P_COUNTER
                                                   ,P_COLUMN_ALIAS => 'counter___'
                                                   ,P_COL_COUNTER  => LV_COLUMN_COUNTER
                                                   ,P_IS_NUMBER    => 1
                                                    --
                                                    );
      LV_COLUMN_COUNTER := LV_COLUMN_COUNTER + 1;
    END IF;
    LV_RESULT := LV_RESULT || MAKE_COLUMN( --
                                          P_COL_VALUE    => P_COLUMN1_VALUE
                                         ,P_COLUMN_ALIAS => P_COLUMN1_ALIAS
                                         ,P_COL_COUNTER  => LV_COLUMN_COUNTER
                                         ,P_IS_NUMBER    => 0
                                          --
                                          );
    RETURN LV_RESULT || C_FINAL_ADDITIVE;
  END;
  -- MAKE_ROW -----------------------------------------
  FUNCTION MAKE_ROW( --
                    P_COLUMN1_VALUE    VARCHAR2
                   ,P_COLUMN1_ALIAS    VARCHAR2
                   ,P_COLUMN2_VALUE    VARCHAR2
                   ,P_COLUMN2_ALIAS    VARCHAR2
                   ,P_WITH_ROW_COUNTER NUMBER --0 WITHOUT ROW COUNTER 
                   ,P_COUNTER          NUMBER
                    --
                    ) RETURN VARCHAR2 IS
    LV_RESULT VARCHAR2(32767);
    C_PRE_ADDITIVE CONSTANT VARCHAR2(100) := UPPER(CASE
                                                     WHEN P_COUNTER = 1 THEN
                                                      'select '
                                                     ELSE
                                                      CHR(10) || ' union ' ||
                                                      CHR(10) || 'select '
                                                   END);
    C_FINAL_ADDITIVE CONSTANT VARCHAR2(100) := UPPER(' from dual');
    LV_COLUMN_COUNTER NUMBER := 1;
  BEGIN
    LV_RESULT := C_PRE_ADDITIVE;
    IF NVL(P_WITH_ROW_COUNTER, 0) > 0
    THEN
      LV_RESULT         := LV_RESULT || MAKE_COLUMN( --
                                                    P_COL_VALUE    => P_COUNTER
                                                   ,P_COLUMN_ALIAS => 'counter___'
                                                   ,P_COL_COUNTER  => LV_COLUMN_COUNTER
                                                   ,P_IS_NUMBER    => 1
                                                    --
                                                    );
      LV_COLUMN_COUNTER := LV_COLUMN_COUNTER + 1;
    END IF;
    LV_RESULT         := LV_RESULT || MAKE_COLUMN( --
                                                  P_COL_VALUE    => P_COLUMN1_VALUE
                                                 ,P_COLUMN_ALIAS => P_COLUMN1_ALIAS
                                                 ,P_COL_COUNTER  => LV_COLUMN_COUNTER
                                                 ,P_IS_NUMBER    => 0
                                                  --
                                                  );
    LV_COLUMN_COUNTER := LV_COLUMN_COUNTER + 1;
    LV_RESULT         := LV_RESULT || MAKE_COLUMN( --
                                                  P_COL_VALUE    => P_COLUMN2_VALUE
                                                 ,P_COLUMN_ALIAS => P_COLUMN2_ALIAS
                                                 ,P_COL_COUNTER  => LV_COLUMN_COUNTER
                                                 ,P_IS_NUMBER    => 0
                                                  --
                                                  );
    RETURN LV_RESULT || C_FINAL_ADDITIVE;
  END;
  -- PREPROCCESS_VALUES -----------------------------------------
  FUNCTION PREPROCCESS_VALUES( --
                              P_COLUMN_VALUE VARCHAR2
                              --
                              ) RETURN VARCHAR2 IS
    LV_RESULT VARCHAR2(32767);
  BEGIN
    LV_RESULT := TRIM(P_COLUMN_VALUE);
    LV_RESULT := REPLACE(SRCSTR => LV_RESULT
                        ,OLDSUB => ',,'
                        ,NEWSUB => ',' ||
                                   MAM_TEXT_HANDLING_PKG.ENQUOTE_LITERAL(P_INPUT => '') || ',');
  
    RETURN LV_RESULT;
  END;
  -- MAKE_TABLE_FROM_VALUES -----------------------------------------
  FUNCTION PRIVATE_MAKE_TABLE_FROM_VALUES( --
                                          P_COLUMN1_VALUE    VARCHAR2
                                         ,P_COLUMN1_ALIAS    VARCHAR2
                                         ,P_WITH_ROW_COUNTER NUMBER --0 WITHOUT ROW COUNTER 
                                          --
                                          ) RETURN VARCHAR2 IS
    LV_INPUT     VARCHAR2(32767);
    LV_RESULT    VARCHAR2(32767);
    LV_COMMA_LOC NUMBER;
    LV_COUNTER   NUMBER := 0;
  BEGIN
    LV_INPUT := PREPROCCESS_VALUES( --
                                   P_COLUMN_VALUE => P_COLUMN1_VALUE
                                   --
                                   );
    WHILE LV_INPUT IS NOT NULL
    LOOP
      LV_COUNTER   := LV_COUNTER + 1;
      LV_INPUT     := TRIM(LV_INPUT);
      LV_COMMA_LOC := INSTR(LV_INPUT, ',');
      IF LV_COMMA_LOC > 0
      THEN
        LV_RESULT := LV_RESULT || MAKE_ROW( --
                                           P_COLUMN1_VALUE    => SUBSTR(LV_INPUT
                                                                       ,1
                                                                       ,LV_COMMA_LOC - 1)
                                          ,P_COLUMN1_ALIAS    => P_COLUMN1_ALIAS
                                          ,P_WITH_ROW_COUNTER => P_WITH_ROW_COUNTER
                                          ,P_COUNTER          => LV_COUNTER
                                           --
                                           );
        LV_INPUT  := SUBSTR(LV_INPUT
                           ,LV_COMMA_LOC + 1
                           ,LENGTH(LV_INPUT) - LV_COMMA_LOC);
      ELSE
        LV_RESULT := LV_RESULT || MAKE_ROW( --
                                           P_COLUMN1_VALUE    => LV_INPUT
                                          ,P_COLUMN1_ALIAS    => P_COLUMN1_ALIAS
                                          ,P_WITH_ROW_COUNTER => P_WITH_ROW_COUNTER
                                          ,P_COUNTER          => LV_COUNTER
                                           --
                                           );
      
        LV_INPUT := NULL;
      END IF;
    END LOOP;
    RETURN LV_RESULT;
  END;

  -- MAKE_TABLE_FROM_VALUES -----------------------------------------
  FUNCTION MAKE_TABLE_FROM_VALUES( --
                                  P_COLUMN1_VALUE    VARCHAR2
                                 ,P_COLUMN1_ALIAS    VARCHAR2
                                 ,P_COLUMN2_VALUE    VARCHAR2
                                 ,P_COLUMN2_ALIAS    VARCHAR2
                                 ,P_WITH_ROW_COUNTER NUMBER --0 WITHOUT ROW COUNTER 
                                  --
                                  ) RETURN VARCHAR2 IS
    LV_INPUT1        VARCHAR2(32767);
    LV_INPUT2        VARCHAR2(32767);
    LV_RESULT        VARCHAR2(32767);
    LV_COMMA_LOC1    NUMBER;
    LV_COMMA_LOC2    NUMBER;
    LV_COLUMN1_VALUE VARCHAR2(32767);
    LV_COLUMN2_VALUE VARCHAR2(32767);
  
    LV_COUNTER NUMBER := 0;
  BEGIN
    LV_INPUT1 := PREPROCCESS_VALUES( --
                                    P_COLUMN_VALUE => P_COLUMN1_VALUE
                                    --
                                    );
    LV_INPUT2 := PREPROCCESS_VALUES( --
                                    P_COLUMN_VALUE => P_COLUMN2_VALUE
                                    --
                                    );
    WHILE LV_INPUT1 IS NOT NULL OR LV_INPUT2 IS NOT NULL
    LOOP
      LV_COUNTER    := LV_COUNTER + 1;
      LV_INPUT1     := TRIM(LV_INPUT1);
      LV_COMMA_LOC1 := INSTR(LV_INPUT1, ',');
      IF LV_COMMA_LOC1 > 0
      THEN
        LV_COLUMN1_VALUE := SUBSTR(LV_INPUT1, 1, LV_COMMA_LOC1 - 1);
        LV_INPUT1        := SUBSTR(LV_INPUT1
                                  ,LV_COMMA_LOC1 + 1
                                  ,LENGTH(LV_INPUT1) - LV_COMMA_LOC1);
      ELSE
        LV_COLUMN1_VALUE := LV_INPUT1;
        LV_INPUT1        := NULL;
      END IF;
    
      LV_INPUT2     := TRIM(LV_INPUT2);
      LV_COMMA_LOC2 := INSTR(LV_INPUT2, ',');
      IF LV_COMMA_LOC2 > 0
      THEN
        LV_COLUMN2_VALUE := SUBSTR(LV_INPUT2, 1, LV_COMMA_LOC2 - 1);
        LV_INPUT2        := SUBSTR(LV_INPUT2
                                  ,LV_COMMA_LOC2 + 1
                                  ,LENGTH(LV_INPUT2) - LV_COMMA_LOC2);
      ELSE
        LV_COLUMN2_VALUE := LV_INPUT2;
        LV_INPUT2        := NULL;
      END IF;
    
      LV_RESULT := LV_RESULT || MAKE_ROW( --
                                         P_COLUMN1_VALUE    => LV_COLUMN1_VALUE
                                        ,P_COLUMN1_ALIAS    => P_COLUMN1_ALIAS
                                        ,P_COLUMN2_VALUE    => LV_COLUMN2_VALUE
                                        ,P_COLUMN2_ALIAS    => P_COLUMN2_ALIAS
                                        ,P_WITH_ROW_COUNTER => P_WITH_ROW_COUNTER
                                        ,P_COUNTER          => LV_COUNTER
                                         --
                                         );
    END LOOP;
    RETURN LV_RESULT;
  END;
/*
  -- MAKE_TABLE_FROM_VALUES -----------------------------------------
  FUNCTION MAKE_TABLE_FROM_VALUES( --
                                  P_VALUES           VARCHAR2
                                 ,P_ALIASES          VARCHAR2
                                 ,P_WITH_ROW_COUNTER NUMBER --0 WITHOUT ROW COUNTER 
                                  --
                                  ) RETURN VARCHAR2 IS
    LV_INPUT1        VARCHAR2(32767);
    LV_INPUT2        VARCHAR2(32767);
    LV_RESULT        VARCHAR2(32767);
    LV_COMMA_LOC1    NUMBER;
    LV_COMMA_LOC2    NUMBER;
    LV_COLUMN1_VALUE VARCHAR2(32767);
    LV_COLUMN2_VALUE VARCHAR2(32767);
  
    LV_COUNTER NUMBER := 0;
  BEGIN
    LV_INPUT1 := PREPROCCESS_VALUES( --
                                    P_COLUMN_VALUE => P_COLUMN1_VALUE
                                    --
                                    );
    LV_INPUT2 := PREPROCCESS_VALUES( --
                                    P_COLUMN_VALUE => P_COLUMN2_VALUE
                                    --
                                    );
    WHILE LV_INPUT1 IS NOT NULL OR LV_INPUT2 IS NOT NULL
    LOOP
      LV_COUNTER    := LV_COUNTER + 1;
      LV_INPUT1     := TRIM(LV_INPUT1);
      LV_COMMA_LOC1 := INSTR(LV_INPUT1, ',');
      IF LV_COMMA_LOC1 > 0
      THEN
        LV_COLUMN1_VALUE := SUBSTR(LV_INPUT1, 1, LV_COMMA_LOC1 - 1);
        LV_INPUT1        := SUBSTR(LV_INPUT1
                                  ,LV_COMMA_LOC1 + 1
                                  ,LENGTH(LV_INPUT1) - LV_COMMA_LOC1);
      ELSE
        LV_COLUMN1_VALUE := LV_INPUT1;
        LV_INPUT1        := NULL;
      END IF;
    
      LV_INPUT2     := TRIM(LV_INPUT2);
      LV_COMMA_LOC2 := INSTR(LV_INPUT2, ',');
      IF LV_COMMA_LOC2 > 0
      THEN
        LV_COLUMN2_VALUE := SUBSTR(LV_INPUT2, 1, LV_COMMA_LOC2 - 1);
        LV_INPUT2        := SUBSTR(LV_INPUT2
                                  ,LV_COMMA_LOC2 + 1
                                  ,LENGTH(LV_INPUT2) - LV_COMMA_LOC2);
      ELSE
        LV_COLUMN2_VALUE := LV_INPUT2;
        LV_INPUT2        := NULL;
      END IF;
    
      LV_RESULT := LV_RESULT || MAKE_ROW( --
                                         P_COLUMN1_VALUE    => LV_COLUMN1_VALUE
                                        ,P_COLUMN1_ALIAS    => P_COLUMN1_ALIAS
                                        ,P_COLUMN2_VALUE    => LV_COLUMN2_VALUE
                                        ,P_COLUMN2_ALIAS    => P_COLUMN2_ALIAS
                                        ,P_WITH_ROW_COUNTER => P_WITH_ROW_COUNTER
                                        ,P_COUNTER          => LV_COUNTER
                                         --
                                         );
    END LOOP;
    RETURN LV_RESULT;
  END;
*/
BEGIN
  NULL;
END;
/
