CREATE OR REPLACE PACKAGE MAM_PLSQL_COMPILER_PKG IS

  TYPE TOKEN_ROW IS RECORD(
     OBJECT_TYPE VARCHAR2(256)
    ,TOKEN       VARCHAR2(256)
    ,LINE        NUMBER
    ,COL         NUMBER
    ,TOKEN_TYPE  VARCHAR2(256)
    --
    );
  TYPE TOKEN_TAB IS TABLE OF TOKEN_ROW;
  TYPE SCANNER_STRUCTURE_ROW IS RECORD(
     VALUE_ VARCHAR2(256)
    ,TYPE_  VARCHAR2(256)
    --
    );
  TYPE SCANNER_STRUCTURE_TAB IS TABLE OF SCANNER_STRUCTURE_ROW;

  -- BUILD_SCANNER_STRUCKTURE -----------------------------------------
  FUNCTION BUILD_RESERVED_WORDS RETURN SCANNER_STRUCTURE_TAB
    PIPELINED;
  -- BUILD_BUILD_KEYWORDS -----------------------------------------
  FUNCTION BUILD_KEYWORDS RETURN SCANNER_STRUCTURE_TAB
    PIPELINED;
  -- BUILD_DELIMITERS -----------------------------------------
  FUNCTION BUILD_DELIMITERS RETURN SCANNER_STRUCTURE_TAB
    PIPELINED;
  -- BUILD_SCANNER_STRUCKTURE -----------------------------------------
  FUNCTION BUILD_SCANNER_STRUCTURE RETURN SCANNER_STRUCTURE_TAB
    PIPELINED;

  -- SCAN -----------------------------------------
  FUNCTION SCAN( --
                P_OBJECT VARCHAR2
                --
                ) RETURN TOKEN_TAB
    PIPELINED;
END;
/
CREATE OR REPLACE PACKAGE BODY MAM_PLSQL_COMPILER_PKG IS
  GV_CURRENT_LINE   NUMBER;
  GV_CURRENT_COLUMN NUMBER;
  --GV_OBJECT         VARCHAR2(256);
  GV_CLOB CLOB;
  -- BUILD_SCANNER_STRUCKTURE -----------------------------------------
  FUNCTION BUILD_RESERVED_WORDS RETURN SCANNER_STRUCTURE_TAB
    PIPELINED IS
    LV_ROW SCANNER_STRUCTURE_ROW;
  BEGIN
    FOR C IN ( --
              SELECT 'ALL' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'ALTER' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'AND' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'ANY' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'AS' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'ASC' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'AT' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'BEGIN' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'BETWEEN' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'BY' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'CASE' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'CHECK' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'CLUSTERS' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'CLUSTER' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'COLAUTH' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'COLUMNS' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'COMPRESS' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'CONNECT' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'CRASH' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'CREATE' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'CURSOR' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'DECLARE' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'DEFAULT' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'DESC' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'DISTINCT' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'DROP' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'ELSE' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'END' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'EXCEPTION' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'EXCLUSIVE' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'FETCH' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'FOR' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'FROM' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'FUNCTION' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'GOTO' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'GRANT' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'GROUP' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'HAVING' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'IDENTIFIED' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'IF' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'IN' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'INDEX' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'INDEXES' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'INSERT' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'INTERSECT' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'INTO' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'IS' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'LIKE' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'LOCK' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'MINUS' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'MODE' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'NOCOMPRESS' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'NOT' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'NOWAIT' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'NULL' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'OF' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'ON' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'OPTION' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'OR' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'ORDER' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'OVERLAPS' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'PROCEDURE' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'PUBLIC' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'RESOURCE' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'REVOKE' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'SELECT' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'SHARE' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'SIZE' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'SQL' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'START' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'SUBTYPE' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'TABAUTH' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'TABLE' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'THEN' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'TO' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'TYPE' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'UNION' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'UNIQUE' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'UPDATE' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'VALUES' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'VIEW' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'VIEWS' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'WHEN' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'WHERE' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'WITH' AS VALUE_
                FROM DUAL
              --
              )
    LOOP
      LV_ROW. VALUE_ := C.VALUE_;
      LV_ROW.TYPE_ := 'RESERVED_WORD';
      PIPE ROW(LV_ROW);
    END LOOP;
  END;
  -- BUILD_BUILD_KEYWORDS -----------------------------------------
  FUNCTION BUILD_KEYWORDS RETURN SCANNER_STRUCTURE_TAB
    PIPELINED IS
    LV_ROW SCANNER_STRUCTURE_ROW;
  BEGIN
    FOR C IN ( --
              SELECT 'A' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'ADD' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'ACCESSIBLE' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'AGENT' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'AGGREGATE' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'ARRAY' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'ATTRIBUTE' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'AUTHID' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'AVG' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'BFILE_BASE' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'BINARY' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'BLOB_BASE' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'BLOCK' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'BODY' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'BOTH' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'BOUND' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'BULK' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'BYTE' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'C' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'CALL' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'CALLING' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'CASCADE' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'CHAR' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'CHAR_BASE' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'CHARACTER' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'CHARSET' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'CHARSETFORM' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'CHARSETID' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'CLOB_BASE' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'CLONE' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'CLOSE' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'COLLECT' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'COMMENT' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'COMMIT' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'COMMITTED' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'COMPILED' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'CONSTANT' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'CONSTRUCTOR' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'CONTEXT' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'CONTINUE' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'CONVERT' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'COUNT' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'CREDENTIAL' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'CURRENT' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'CUSTOMDATUM' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'DANGLING' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'DATA' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'DATE' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'DATE_BASE' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'DAY' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'DEFINE' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'DELETE' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'DETERMINISTIC' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'DIRECTORY' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'DOUBLE' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'DURATION' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'ELEMENT' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'ELSIF' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'EMPTY' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'ESCAPE' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'EXCEPT' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'EXCEPTIONS' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'EXECUTE' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'EXISTS' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'EXIT' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'EXTERNAL' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'FINAL' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'FIRST' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'FIXED' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'FLOAT' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'FORALL' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'FORCE' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'GENERAL' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'HASH' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'HEAP' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'HIDDEN' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'HOUR' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'IMMEDIATE' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'INCLUDING' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'INDICATOR' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'INDICES' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'INFINITE' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'INSTANTIABLE' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'INT' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'INTERFACE' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'INTERVAL' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'INVALIDATE' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'ISOLATION' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'JAVA' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'LANGUAGE' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'LARGE' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'LEADING' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'LENGTH' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'LEVEL' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'LIBRARY' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'LIKE2' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'LIKE4' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'LIKEC' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'LIMIT' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'LIMITED' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'LOCAL' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'LONG' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'LOOP' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'MAP' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'MAX' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'MAXLEN' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'MEMBER' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'MERGE' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'MIN' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'MINUTE' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'MOD' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'MODIFY' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'MONTH' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'MULTISET' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'NAME' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'NAN' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'NATIONAL' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'NATIVE' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'NCHAR' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'NEW' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'NOCOPY' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'NUMBER_BASE' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'OBJECT' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'OCICOLL' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'OCIDATE' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'OCIDATETIME' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'OCIDURATION' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'OCIINTERVAL' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'OCILOBLOCATOR' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'OCINUMBER' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'OCIRAW' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'OCIREF' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'OCIREFCURSOR' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'OCIROWID' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'OCISTRING' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'OCITYPE' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'OLD' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'ONLY' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'OPAQUE' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'OPEN' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'OPERATOR' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'ORACLE' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'ORADATA' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'ORGANIZATION' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'ORLANY' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'ORLVARY' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'OTHERS' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'OUT' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'OVERRIDING' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'PACKAGE' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'PARALLEL_ENABLE' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'PARAMETER' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'PARAMETERS' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'PARENT' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'PARTITION' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'PASCAL' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'PERSISTABLE' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'PIPE' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'PIPELINED' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'PLUGGABLE' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'POLYMORPHIC' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'PRAGMA' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'PRECISION' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'PRIOR' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'PRIVATE' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'RAISE' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'RANGE' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'RAW' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'READ' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'RECORD' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'REF' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'REFERENCE' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'RELIES_ON' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'REM' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'REMAINDER' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'RENAME' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'RESULT' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'RESULT_CACHE' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'RETURN' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'RETURNING' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'REVERSE' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'ROLLBACK' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'ROW' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'SAMPLE' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'SAVE' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'SAVEPOINT' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'SB1' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'SB2' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'SB4' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'SECOND' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'SEGMENT' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'SELF' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'SEPARATE' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'SEQUENCE' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'SERIALIZABLE' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'SET' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'SHORT' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'SIZE_T' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'SOME' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'SPARSE' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'SQLCODE' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'SQLDATA' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'SQLNAME' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'SQLSTATE' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'STANDARD' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'STATIC' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'STDDEV' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'STORED' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'STRING' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'STRUCT' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'STYLE' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'SUBMULTISET' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'SUBPARTITION' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'SUBSTITUTABLE' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'SUM' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'SYNONYM' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'TDO' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'THE' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'TIME' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'TIMESTAMP' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'TIMEZONE_ABBR' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'TIMEZONE_HOUR' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'TIMEZONE_MINUTE' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'TIMEZONE_REGION' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'TRAILING' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'TRANSACTION' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'TRANSACTIONAL' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'TRUSTED' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'UB1' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'UB2' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'UB4' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'UNDER' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'UNPLUG' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'UNSIGNED' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'UNTRUSTED' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'USE' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'USING' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'VALIST' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'VALUE' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'VARIABLE' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'VARIANCE' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'VARRAY' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'VARYING' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'VOID' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'WHILE' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'WORK' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'WRAPPED' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'WRITE' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'YEAR' AS VALUE_
                FROM DUAL
              UNION
              SELECT 'ZONE' AS VALUE_
                FROM DUAL
              --
              )
    LOOP
      LV_ROW. VALUE_ := C.VALUE_;
      LV_ROW.TYPE_ := 'KEYWORD';
      PIPE ROW(LV_ROW);
    END LOOP;
  END;
  -- BUILD_DELIMITERS -----------------------------------------
  FUNCTION BUILD_DELIMITERS RETURN SCANNER_STRUCTURE_TAB
    PIPELINED IS
    LV_ROW SCANNER_STRUCTURE_ROW;
  BEGIN
    FOR C IN ( --
              SELECT '+' AS VALUE_
                FROM DUAL
              UNION
              SELECT ':=' AS VALUE_
                FROM DUAL
              UNION
              SELECT '=>' AS VALUE_
                FROM DUAL
              UNION
              SELECT '%' AS VALUE_
                FROM DUAL
              UNION
              SELECT CHR(39) AS VALUE_
                FROM DUAL
              UNION
              SELECT '.' AS VALUE_
                FROM DUAL
              UNION
              SELECT '||' AS VALUE_
                FROM DUAL
              UNION
              SELECT '/' AS VALUE_
                FROM DUAL
              UNION
              SELECT '**' AS VALUE_
                FROM DUAL
              UNION
              SELECT '(' AS VALUE_
                FROM DUAL
              UNION
              SELECT ')' AS VALUE_
                FROM DUAL
              UNION
              SELECT ':' AS VALUE_
                FROM DUAL
              UNION
              SELECT ',' AS VALUE_
                FROM DUAL
              UNION
              SELECT '<<' AS VALUE_
                FROM DUAL
              UNION
              SELECT CHR(47) || CHR(42) AS VALUE_
                FROM DUAL
              UNION
              SELECT CHR(42) || CHR(47) AS VALUE_
                FROM DUAL
              UNION
              SELECT '*' AS VALUE_
                FROM DUAL
              UNION
              SELECT '"' AS VALUE_
                FROM DUAL
              UNION
              SELECT '..' AS VALUE_
                FROM DUAL
              UNION
              SELECT '<>' AS VALUE_
                FROM DUAL
              UNION
              SELECT '!=' AS VALUE_
                FROM DUAL
              UNION
              SELECT '~=' AS VALUE_
                FROM DUAL
              UNION
              SELECT '^=' AS VALUE_
                FROM DUAL
              UNION
              SELECT '<' AS VALUE_
                FROM DUAL
              UNION
              SELECT '<=' AS VALUE_
                FROM DUAL
              UNION
              SELECT '=' AS VALUE_
                FROM DUAL
              UNION
              SELECT '@' AS VALUE_
                FROM DUAL
              UNION
              SELECT '--' AS VALUE_
                FROM DUAL
              UNION
              SELECT ';' AS VALUE_
                FROM DUAL
              --
              )
    LOOP
      LV_ROW. VALUE_ := C.VALUE_;
      LV_ROW.TYPE_ := 'DELIMITER';
      PIPE ROW(LV_ROW);
    END LOOP;
  END;
  -- BUILD_SCANNER_STRUCKTURE -----------------------------------------
  FUNCTION BUILD_SCANNER_STRUCTURE RETURN SCANNER_STRUCTURE_TAB
    PIPELINED IS
    LV_ROW SCANNER_STRUCTURE_ROW;
  BEGIN
    NULL;
    FOR C IN ( --
              SELECT T.VALUE_, T.TYPE_
                FROM TABLE(MAM_PLSQL_COMPILER_PKG.BUILD_RESERVED_WORDS) T
              UNION
              SELECT T.VALUE_, T.TYPE_
                FROM TABLE(MAM_PLSQL_COMPILER_PKG.BUILD_KEYWORDS) T
              UNION
              SELECT T.VALUE_, T.TYPE_
                FROM TABLE(MAM_PLSQL_COMPILER_PKG.BUILD_DELIMITERS) T
              --
              )
    LOOP
      LV_ROW. VALUE_ := UPPER(TRIM(C.VALUE_));
      LV_ROW.TYPE_ := UPPER(TRIM(C.TYPE_));
      PIPE ROW(LV_ROW);
    END LOOP;
  END;
  -- FILL_CLOB -----------------------------------------
  FUNCTION FILL_CLOB(P_OBJECT VARCHAR2
                     --
                     ) RETURN VARCHAR2 IS
    LV_RESULT    VARCHAR2(256);
    LV_OBJECT    VARCHAR2(256) := UPPER(TRIM(P_OBJECT));
    LV_VIEW_TEXT ALL_VIEWS.TEXT%TYPE;
    LV_TEXT      ALL_SOURCE.TEXT%TYPE;
  BEGIN
    BEGIN
      SELECT O.OBJECT_TYPE
        INTO LV_RESULT
        FROM ALL_OBJECTS O
       WHERE 1 = 1
         AND O.OBJECT_NAME = LV_OBJECT
         AND O.OBJECT_TYPE IN (UPPER('view')
                              ,UPPER('PACKAGE')
                              ,UPPER('FUNCTION')
                              ,UPPER('PROCEDURE'))
      --
      ;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    IF LV_RESULT IN (UPPER('view'))
    THEN
      BEGIN
        SELECT V.TEXT
          INTO LV_VIEW_TEXT
          FROM ALL_VIEWS V
         WHERE V.VIEW_NAME = LV_OBJECT
        --
        ;
        GV_CLOB := LV_VIEW_TEXT;
      EXCEPTION
        WHEN OTHERS THEN
          LV_RESULT := NULL;
      END;
    ELSIF LV_RESULT IN (UPPER('PACKAGE'))
    THEN
      FOR C IN ( --
                SELECT S.TEXT
                  FROM ALL_SOURCE S
                 WHERE S.NAME = LV_OBJECT
                   AND S.TYPE = UPPER('PACKAGE')
                 ORDER BY S.TYPE, S.LINE
                --
                )
      LOOP
        GV_CLOB := GV_CLOB || C.TEXT;
      END LOOP;
      FOR C IN ( --
                SELECT S.TEXT
                  FROM ALL_SOURCE S
                 WHERE S.NAME = LV_OBJECT
                   AND S.TYPE = UPPER('PACKAGE BODY')
                 ORDER BY S.TYPE, S.LINE
                --
                )
      LOOP
        GV_CLOB := GV_CLOB || C.TEXT;
      END LOOP;
    ELSIF LV_RESULT IN (UPPER('FUNCTION'), UPPER('PROCEDURE'))
    THEN
      FOR C IN ( --
                SELECT S.TEXT
                  FROM ALL_SOURCE S
                 WHERE S.NAME = LV_OBJECT
                 ORDER BY S.TYPE, S.LINE
                --
                )
      LOOP
        GV_CLOB := GV_CLOB || C.TEXT;
      END LOOP;
    
    END IF;
    RETURN LV_RESULT;
  END;
  -- GET_TOKEN -----------------------------------------
  FUNCTION GET_TOKEN( --
                     P_TOKEN  OUT VARCHAR2
                    ,P_LINE   OUT NUMBER
                    ,P_COLUMN OUT NUMBER
                     --
                     ) RETURN BOOLEAN IS
  BEGIN
    RETURN FALSE;
  END;
  -- SCAN -----------------------------------------
  FUNCTION SCAN( --
                P_OBJECT VARCHAR2
                --
                ) RETURN TOKEN_TAB
    PIPELINED IS
    LV_ROW         TOKEN_ROW;
    LV_OBJECT      VARCHAR2(256) := UPPER(TRIM(P_OBJECT));
    LV_OBJECT_TYPE VARCHAR2(256);
  BEGIN
    LV_OBJECT_TYPE := FILL_CLOB(P_OBJECT => LV_OBJECT);
    IF LV_OBJECT IS NOT NULL
    THEN
      LV_ROW.OBJECT_TYPE := LV_OBJECT_TYPE;
      PIPE ROW(LV_ROW); --
      WHILE GET_TOKEN( --
                      P_TOKEN  => LV_ROW.TOKEN
                     ,P_LINE   => LV_ROW.LINE
                     ,P_COLUMN => LV_ROW.COL
                      --
                      ) --
      LOOP
        LV_ROW.OBJECT_TYPE := LV_OBJECT_TYPE;
        --      LV_ROW.NAM_SUB_INVENTORY := C.NAM_SUB_INVENTORY_MSINV;
        --      LV_ROW.TOKEN VARCHAR2(256) LV_ROW.LINE NUMBER LV_ROW.COLUMN NUMBER LV_ROW.TOKEN_TYPE VARCHAR2(256)
        PIPE ROW(LV_ROW);
      END LOOP;
    END IF;
  END;

BEGIN
  GV_CURRENT_LINE   := 0;
  GV_CURRENT_COLUMN := 0;
  GV_CLOB           := NULL;
  --  GV_SCANNER_STRUCTURE := MAM_PLSQL_COMPILER_PKG.BUILD_SCANNER_STRUCTURE;
/*insert into GV_SCANNER_STRUCTURE(VALUE_ 
  ,TYPE_) 
  select VALUE_ 
  ,TYPE_ from table ()t
  --
  ;*/
END;
/
