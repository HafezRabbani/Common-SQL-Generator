DECLARE
  LV_ERR BOOLEAN := FALSE;
  LV_SQL VARCHAR2(32767);
BEGIN
  --EXECUTE IMMEDIATE 'GRANT EXECUTE ON APPS.APP_MAM_GLOBAL_TEMPS_PKG TO SUP_BACKEND';
  DBMS_OUTPUT.PUT_LINE('BEGIN');
  --  DBMS_OUTPUT.PUT_LINE('FNDSYS.APP_FND_DB_SECURITY_PKG.REFERESH_ADMIN_PRIVS_PRC(P_USERNAME => ''SUP_BACKEND'');');
  --  DBMS_OUTPUT.PUT_LINE('--  FNDSYS.APP_FND_DB_SECURITY_PKG.SET_ADMIN_PRIVS(P_APP_ZONE => ''SUP'',P_USERNAME => ''SUP_BACKEND'');');
  BEGIN
    FNDSYS.APP_FND_DB_SECURITY_PKG.REFERESH_ADMIN_PRIVS_PRC(P_USERNAME => 'SUP_BACKEND');
    --    ITSSYS.APP_FND_DB_SECURITY_PKG.REFERESH_ADMIN_PRIVS_PRC(P_USERNAME => 'SUP_BACKEND');
    --  FNDSYS.APP_FND_DB_SECURITY_PKG.SET_ADMIN_PRIVS(P_APP_ZONE => 'SUP',P_USERNAME => 'SUP_BACKEND');
    NULL;
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('FAIL TO REFERESH_ADMIN_PRIVS_PRC');
  END;
  /*
    BEGIN
      APPS.MAM_EXECUTE_IMMEDIATE_PKG.EXEC_IMDT('GRANT EXECUTE ON FND.FND_REPLACE_STRING TO SUP_BACKEND');
    EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('FAIL TO GRANT EXECUTE ON FND.FND_REPLACE_STRING TO SUP_BACKEND');
    END;
  */
  FOR C IN ( --
            SELECT UPPER(TRIM(O)) AS O
              FROM ( --
                     SELECT DISTINCT O.OBJECT_NAME AS O
                       FROM ALL_PROCEDURES O
                      WHERE ( --
                             O.OBJECT_NAME LIKE UPPER('PUA%PKG') OR
                             O.OBJECT_NAME LIKE UPPER('MAM%') OR
                             O.OBJECT_NAME LIKE UPPER('BRL_MAM%PKG') OR
                             O.OBJECT_NAME LIKE UPPER('APP_MAM%PKG') OR
                             O.OBJECT_NAME LIKE UPPER('FRM_FMAM%PKG') OR
                             O.OBJECT_NAME LIKE UPPER('PUR%PKG') OR
                             O.OBJECT_NAME LIKE UPPER('CSM%PKG')
                            --
                            )
                     UNION
                     SELECT 'APPS.APP_FND_HIERARCHIES_PKG' AS O
                       FROM DUAL
                     UNION
                     SELECT 'APPS.APP_FND_HIERARCHY_DETAILS_PKG' AS O
                       FROM DUAL
                     UNION
                     SELECT 'APPS.APP_FND_SECURITY_PKG' AS O
                       FROM DUAL
                     UNION
                     SELECT 'APPS.APP_MAM_MATERIAL_TRANSCTNS_PKG' AS O
                       FROM DUAL
                     UNION
                     SELECT 'APPS.APP_PUA_WAYBILLS_PKG' AS O
                       FROM DUAL
                     UNION
                     SELECT 'APPS.COA_VALID_CENTERS_VIW' AS O
                       FROM DUAL
                     UNION
                     SELECT 'APPS.FND_REPORT_PARAMETERS_VIW' AS O
                       FROM DUAL
                     --UNION SELECT 'APPS.MAM_DELETE_PACKING_NO_PRC' AS O FROM DUAL
                     --UNION SELECT 'APPS.MAM_FMAM_X3_X4_SERIAL_PKG' AS O FROM DUAL
                     UNION
                     SELECT 'APPS.PUA_CHK_RCV_RGS_FUN' AS O
                       FROM DUAL
                     UNION
                     SELECT 'APPS.PUA_ORDER_POSITIONS_VIW' AS O
                       FROM DUAL
                     UNION
                     SELECT 'APPS.PUA_WAYBILL_ITEMS_VIW' AS O
                       FROM DUAL
                     UNION
                     SELECT 'APPS.PUA_WAYBILLS_CTRL_PKG' AS O
                       FROM DUAL
                     UNION
                     SELECT 'APPS.PUA_WAYBILLS_ITEMS_ROM_VIW' AS O
                       FROM DUAL
                     UNION
                     SELECT 'APPS.PUA_WAYBILLS_VIW' AS O
                       FROM DUAL
                     UNION
                     SELECT 'APPS.PUR_PACKING_NUMBERS_CTRL_PKG' AS O
                       FROM DUAL
                     UNION
                     SELECT 'APPS.SAL_ORDER_TEC1_VIW' AS O
                       FROM DUAL
                     UNION
                     SELECT 'APPS.SAL_REM_ORDER_MAM_VIW' AS O
                       FROM DUAL
                     UNION
                     SELECT 'APPS.SRM_REMOVE_DUPLICATES_FUN' AS O
                       FROM DUAL
                     UNION
                     SELECT 'BFS.BFS_THIRD_PARTIES' AS O
                       FROM DUAL
                     UNION
                     SELECT 'COA.COA_COST_CENTER_COSTS' AS O
                       FROM DUAL
                     UNION
                     SELECT 'FIA.FIA_ASSET_KEEPERS' AS O
                       FROM DUAL
                     UNION
                     SELECT 'FIA.FIA_ASSET_MOVEMENT_RELATIONS' AS O
                       FROM DUAL
                     UNION
                     SELECT 'FIA.FIA_ASSET_MOVEMENTS' AS O
                       FROM DUAL
                     UNION
                     SELECT 'FIA.FIA_COST_CENTER_KEEPERS' AS O
                       FROM DUAL
                     UNION
                     SELECT 'FIA.FIA_FIXED_ASSETS' AS O
                       FROM DUAL
                     UNION
                     SELECT 'FND.FND_API_PRGREP_CREATE_PKG' AS O
                       FROM DUAL
                     UNION
                     SELECT 'FND.FND_API_USERGRP_ACCESS_PKG' AS O
                       FROM DUAL
                     UNION
                     SELECT 'FND.FND_APPLICATION_SYSTEMS' AS O
                       FROM DUAL
                     UNION
                     SELECT 'FND.FND_ATTACHMENT_DOCUMENTS' AS O
                       FROM DUAL
                     UNION
                     SELECT 'FND.FND_ERRMSGS' AS O
                       FROM DUAL
                     UNION
                     SELECT 'FND.FND_GROUP_REPORTS' AS O
                       FROM DUAL
                     UNION
                     SELECT 'FND.FND_GROUP_REPORTS_VIW' AS O
                       FROM DUAL
                     UNION
                     SELECT 'FND.FND_GROUPS' AS O
                       FROM DUAL
                     UNION
                     SELECT 'FND.FND_GROUP_USERS' AS O
                       FROM DUAL
                     UNION
                     SELECT 'FND.FND_HIERARCHIES' AS O
                       FROM DUAL
                     UNION
                     SELECT 'FND.FND_HIERARCHY_DETAILS' AS O
                       FROM DUAL
                     UNION
                     SELECT 'FND.FND_HIERARCHY_FORMS' AS O
                       FROM DUAL
                     UNION
                     SELECT 'FND.FND_LOOKUP_REL_TABLES' AS O
                       FROM DUAL
                     UNION
                     SELECT 'FND.FND_LOOKUP_VALUES' AS O
                       FROM DUAL
                     UNION
                     SELECT 'FND.FND_LOOKUP_VALUES_VIW' AS O
                       FROM DUAL
                     UNION
                     SELECT 'FND.FND_MENU_NODE_GROUPS' AS O
                       FROM DUAL
                     UNION
                     SELECT 'FND.FND_MENU_NODES' AS O
                       FROM DUAL
                     UNION
                     SELECT 'FND.FND_PROGRAMS' AS O
                       FROM DUAL
                     UNION
                     SELECT 'FND.FND_REPLACE_STRING' AS O
                       FROM DUAL
                     UNION
                     SELECT 'FND.FND_REPORTS' AS O
                       FROM DUAL
                     UNION
                     SELECT 'FND.FND_SETUPS' AS O
                       FROM DUAL
                     UNION
                     SELECT 'FND.FND_SYS_INFO_VIW' AS O
                       FROM DUAL
                     UNION
                     SELECT 'FND.FND_USERS' AS O
                       FROM DUAL
                     UNION
                     SELECT 'FND.FND_REFORM2_FUN' AS O
                       FROM DUAL
                     UNION
                     SELECT 'JRN.PUA_WAYBILL_ITEMS_JRN' AS O
                       FROM DUAL
                     UNION
                     SELECT 'JRN.PUA_WAYBILLS_JRN' AS O
                       FROM DUAL
                     UNION
                     SELECT 'LAB.LAB_CNTR_MAM_REQS' AS O
                       FROM DUAL
                     UNION
                     SELECT 'MAI.MAI_ACTIVITIES' AS O
                       FROM DUAL
                     UNION
                     SELECT 'PDS.PDS_EMPLOYEES' AS O
                       FROM DUAL
                     UNION
                     SELECT 'PUA.PUA_WAYBILL_ITEMS' AS O
                       FROM DUAL
                     UNION
                     SELECT 'PUA.PUA_WAYBILLS' AS O
                       FROM DUAL
                     UNION
                     SELECT 'SAL.SAL_CONTENT_DESCRIPTIONS' AS O
                       FROM DUAL
                     UNION
                     SELECT 'SAL.SAL_ORDER_TEC1_VIW' AS O
                       FROM DUAL
                     UNION
                     SELECT 'SAL.SAL_PILOT_CONTENTS' AS O
                       FROM DUAL
                     UNION
                     SELECT 'SAL.SAL_TITLE_DESCRIPTIONS' AS O
                       FROM DUAL
                     UNION
                     SELECT 'WAC.WAC_TRANSACTION_VALUES' AS O
                       FROM DUAL
                     UNION
                     SELECT 'APPS.PDS_EMPLOYEE_PRT_CAR3_FULL_VIW' AS O
                       FROM DUAL
                     
                     --
                     )
            --
            )
  LOOP
    BEGIN
      IF C.O LIKE UPPER(TRIM('%PKG'))
      THEN
        LV_SQL := 'GRANT EXECUTE ON ' || C.O || ' TO SUP_BACKEND';
      ELSIF C.O LIKE UPPER(TRIM('%PRC'))
      THEN
        LV_SQL := 'GRANT EXECUTE ON ' || C.O || ' TO SUP_BACKEND';
      ELSIF C.O LIKE UPPER(TRIM('%FUN'))
      THEN
        LV_SQL := 'GRANT EXECUTE ON ' || C.O || ' TO SUP_BACKEND';
      ELSE
        LV_SQL := 'GRANT SELECT ON ' || C.O || ' TO SUP_BACKEND';
      END IF;
      /*
            DBMS_OUTPUT.PUT_LINE('BEGIN ' || LV_SQL ||
                                 '; EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE(' ||
                                 '''FAIL TO ' || LV_SQL || '''); END;');
      */
      APPS.MAM_EXECUTE_IMMEDIATE_PKG.EXEC_IMDT(LV_SQL);
    EXCEPTION
      WHEN OTHERS THEN
        LV_ERR := TRUE;
        DBMS_OUTPUT.PUT_LINE('FAIL TO ' || LV_SQL);
    END;
  END LOOP;
  FOR C IN ( --
            SELECT UPPER(TRIM(O)) AS O
              FROM ( --
                     SELECT 'FND.FND_ERRMSGS' AS O
                       FROM DUAL
                     --
                     )
            --
            )
  LOOP
    BEGIN
      LV_SQL := 'GRANT ALL ON ' || C.O || ' TO SUP_BACKEND';
      APPS.MAM_EXECUTE_IMMEDIATE_PKG.EXEC_IMDT(LV_SQL);
    EXCEPTION
      WHEN OTHERS THEN
        LV_ERR := TRUE;
        DBMS_OUTPUT.PUT_LINE('FAIL TO ' || LV_SQL);
    END;
  END LOOP;

  DBMS_OUTPUT.PUT_LINE('END;');
  IF LV_ERR
  THEN
    RAISE_APPLICATION_ERROR(-20001, 'Œÿ« œ«—Ì„!');
  END IF;
END;
