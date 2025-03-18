PL/SQL Developer Test script 3.0
9
DECLARE
  LV_RESULT VARCHAR2(32767);
BEGIN
  -- Call the function
  LV_RESULT := MAM_TEXT_HANDLING_PKG.MAKE_TABLE_FROM_VALUES(P_INPUT        => :P_INPUT
                                                           ,P_COLUMN_ALIAS => :P_COLUMN_ALIAS);
  DBMS_OUTPUT.PUT_LINE(LV_RESULT);
  :RESULT := LV_RESULT;
END;
3
result
0
5
p_input
0
5
p_column_alias
1
﻿
5
0
