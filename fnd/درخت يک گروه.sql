--GRANT SELECT ON FND.FND_MENU_NODES TO SUP_BACKEND
--GRANT SELECT ON FND.FND_MENU_NODE_GROUPS TO SUP_BACKEND
--GRANT SELECT ON FND.FND_SETUPS TO SUP_BACKEND
WITH B AS
 ( --
  SELECT N.NAM_NOD_MNOD AS NODE
         ,N.MNOD_NAM_NOD_MNOD AS FATHER
         ,N.PROG_NAM_PRG_PROG AS RELATED_FORM
         ,CASE
            WHEN N.PROG_NAM_PRG_PROG LIKE UPPER(TRIM('%&RELATED_FROM_LIKE%')) THEN
             'THIS ONE!'
          END AS THE_ONE
         ,N.DES_NOD_MNOD AS CAPTION
    FROM FND.FND_MENU_NODES N
   WHERE (N.NAM_NOD_MNOD LIKE UPPER('MAM%'))
   START WITH N.MNOD_NAM_NOD_MNOD = UPPER('IS')
  CONNECT BY PRIOR NAM_NOD_MNOD = N.MNOD_NAM_NOD_MNOD
  --
  ),
A AS
 (SELECT MNG.GROUP_IDE_GRP_GROUP AS IDE_GRP_GROUP
        ,B.*
    FROM B
   INNER JOIN FND.FND_MENU_NODE_GROUPS MNG
      ON B.NODE = MNG.MNOD_NAM_NOD_MNOD
   WHERE MNG.GROUP_IDE_GRP_GROUP LIKE UPPER('%&GROUP_IDE_GRP_GROUP%'))
SELECT DS.*
      ,Z.*
  FROM (SELECT S.NAM_PROJECT_SETUP
              ,S.COD_PROJECT_SETUP
          FROM FND.FND_SETUPS S) DS
 CROSS JOIN ( --
             
             SELECT IDE_GRP_GROUP
                    ,NODE
                    ,FATHER
                    ,RELATED_FORM
                    ,NULL AS THE_ONE
                    ,CAPTION
               FROM A
             UNION
             SELECT IDE_GRP_GROUP
                    ,NODE
                    ,FATHER
                    ,RELATED_FORM
                    ,THE_ONE
                    ,CAPTION
               FROM A
              WHERE THE_ONE IS NOT NULL
             UNION
             SELECT NULL AS IDE_GRP_GROUP
                    ,NULL AS NODE
                    ,NULL AS FATHER
                    ,NULL AS RELATED_FORM
                    ,'XXXXXXXXXX' AS THE_ONE
                    ,NULL AS CAPTION
               FROM A
              WHERE THE_ONE IS NOT NULL
             --
             ) Z
 ORDER BY THE_ONE
         ,NODE
