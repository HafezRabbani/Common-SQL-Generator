SELECT  
V.ERRNO ,V.ERR_NAME ,V.ERR_TXT,
--
       'UNION SELECT ' || V.ERRNO || ' AS ERRNO, ''' || V.ERR_NAME ||
       ''' AS ERR_NAME, ''' || V.ERR_TXT || ''' AS ERR_TXT FROM DUAL '
  FROM MAM_ERRORS_VIW V
  /*
 WHERE V.ERRNO NOT IN ( --
                       -20200
                      ,-20103
                      ,-20102
                      ,-20101
                      ,-20100
                      ,-20014
                      ,-20010
                      ,-20009
                      ,-20008
                      ,-20007
                      ,-20006
                      ,-20005
                      ,-20004
                      ,-20003
                      ,-20002
                      ,-20001
                       --
                       )
*/
 ORDER BY V.ERRNO
