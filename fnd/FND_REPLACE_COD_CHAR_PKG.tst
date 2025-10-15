PL/SQL Developer Test script 3.0
8
BEGIN
  -- Call the procedure
  FND.FND_REPLACE_COD_CHAR_PKG.REPLACE_CHAR_IN_SCHEMA_PRC( --
                                                          NAM_SCHEMA => UPPER(:NAM_SCHEMA)
                                                         ,TYP_COMMIT => UPPER(:TYP_COMMIT)
                                                          --
                                                          );
END;
2
nam_schema
1
mam
5
typ_commit
1
with
5
0
