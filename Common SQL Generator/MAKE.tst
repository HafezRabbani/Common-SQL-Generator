PL/SQL Developer Test script 3.0
12
BEGIN
  -- Call the function
  :CTRL_PACKAGE_NAME := NULL;
  :APP_PACKAGE_NAME  := NULL;
  :RESULT            := MAM_APP_MAKER_PKG.MAKE(TABLE_NAME          => :TABLE_NAME
                                              ,CTRL_PACKAGE_NAME   => :CTRL_PACKAGE_NAME
                                              ,CREATE_CTRL_PACKAGE => :CREATE_CTRL_PACKAGE
                                              ,APP_PACKAGE_NAME    => :APP_PACKAGE_NAME
                                              ,CREATE_APP_PACKAGE  => :CREATE_APP_PACKAGE);
  DBMS_OUTPUT.PUT_LINE(:CTRL_PACKAGE_NAME);
  DBMS_OUTPUT.PUT_LINE(:APP_PACKAGE_NAME);
END;
6
result
0
5
table_name
1
﻿MAM_MEASUREMENT_UNITS
5
ctrl_package_name
1
﻿MAM_TRANSACTION_RESNS_CTRL_PKG
5
create_ctrl_package
0
4
app_package_name
1
﻿APP_MAM_TRANSACTION_REASNS_PKG
5
create_app_package
0
4
0
