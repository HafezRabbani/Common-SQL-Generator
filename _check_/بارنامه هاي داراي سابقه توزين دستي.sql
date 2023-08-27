SELECT W.NUM_WYB_GOV_WYBIL AS "�.������� �����"
       ,TO_CHAR(W.DAT_WYB_WYBIL
              ,'YYYY/MM/DD'
              ,'NLS_CALENDAR=PERSIAN') AS "����� �������"
       ,TO_CHAR(W.DAT_ENTR_WYBIL
              ,'YYYY/MM/DD HH24:MI:SS'
              ,'NLS_CALENDAR=PERSIAN') AS "����� ����"
  FROM PUA.PUA_WAYBILLS W
 WHERE EXISTS ( --
        SELECT NULL
          FROM JRN.PUA_WAYBILLS_JRN J
         WHERE J.JRN_PROGRAM = 'FMAM9721'
               AND J.WAYBILL_ID = W.WAYBILL_ID
        --
        )
 ORDER BY 2
         ,3
