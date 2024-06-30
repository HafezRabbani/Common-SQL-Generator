SELECT Y.OBJECT_NAME
      ,Y.PROCEDURE_NAME
      ,Y.OVERLOAD
      ,Y.SUBPROGRAM_ID
      ,Y.NEXT_PROCEDURE_NAME
      ,Y.NEXT_SUBPROGRAM_ID
      ,Y.SPEC_LINE_NO
      ,REGEXP_SUBSTR (Y.SPEC_LINE_NO,'\d*,',1,Y.OVERLOAD)
  FROM ( --
        
        SELECT Z.OBJECT_NAME
               ,Z.PROCEDURE_NAME
               ,Z.OVERLOAD
               ,Z.SUBPROGRAM_ID
               ,Z.NEXT_PROCEDURE_NAME
               ,Z.NEXT_SUBPROGRAM_ID
               ,( --
                 SELECT LISTAGG(S1.LINE, ',') WITHIN GROUP(ORDER BY S1.LINE)
                   FROM ALL_SOURCE S1
                  WHERE S1.TYPE = 'PACKAGE'
                    AND S1.NAME = Z.OBJECT_NAME
                    AND S1.TEXT LIKE '%' || Z.PROCEDURE_NAME || '%'
                    AND (REPLACE(S1.TEXT, '  ', ' ') LIKE
                        UPPER('%-- function%') OR REPLACE(S1.TEXT, '  ', ' ') LIKE
                        UPPER('%-- procedure%'))
                 --
                 ) AS SPEC_LINE_NO
          FROM ( --
                 SELECT P.OBJECT_NAME
                        ,P.PROCEDURE_NAME
                        ,P.OVERLOAD
                        ,P.SUBPROGRAM_ID
                        ,LEAD(P.PROCEDURE_NAME, 1) OVER(ORDER BY P.SUBPROGRAM_ID) AS NEXT_PROCEDURE_NAME
                        ,LEAD(P.SUBPROGRAM_ID, 1) OVER(ORDER BY P.SUBPROGRAM_ID) AS NEXT_SUBPROGRAM_ID
                 
                   FROM ALL_PROCEDURES P
                 --  inner join all_source s on p.
                  WHERE P.OBJECT_NAME = UPPER('&OBJECT_NAME')
                    AND P.SUBPROGRAM_ID != 0
                 --
                 ) Z
        --
        ) Y
 ORDER BY Y.SUBPROGRAM_ID
