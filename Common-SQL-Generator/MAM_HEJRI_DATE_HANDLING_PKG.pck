CREATE OR REPLACE PACKAGE "MAM_HEJRI_DATE_HANDLING_PKG" IS
  --
  -- GET_FIRST_OF_HEJRI_MONTH
  FUNCTION GET_FIRST_OF_HEJRI_MONTH(P_DATE DATE) RETURN DATE;
  -- GET_FIRST_OF_HEJRI_MONTH
  FUNCTION GET_FIRST_OF_HEJRI_MONTH RETURN DATE;
  -- GET_LAST_OF_HEJRI_MONTH
  FUNCTION GET_LAST_OF_HEJRI_MONTH(P_DATE DATE) RETURN DATE;
  -- GET_LAST_OF_HEJRI_MONTH
  FUNCTION GET_LAST_OF_HEJRI_MONTH RETURN DATE;

  -- GET_FIRST_OF_N_MONTHS_NEXT_AGO
  FUNCTION GET_FIRST_OF_N_MONTHS_NEXT_AGO(P_DATE DATE
                                         ,P_N    NUMBER) RETURN DATE;
  -- GET_FIRST_OF_N_MONTHS_NEXT_AGO
  FUNCTION GET_FIRST_OF_N_MONTHS_NEXT_AGO(P_N NUMBER) RETURN DATE;
  -- GET_LAST_OF_N_MONTHS_NEXT_AGO
  FUNCTION GET_LAST_OF_N_MONTHS_NEXT_AGO(P_DATE DATE
                                        ,P_N    NUMBER) RETURN DATE;
  -- GET_LAST_OF_N_MONTHS_NEXT_AGO
  FUNCTION GET_LAST_OF_N_MONTHS_NEXT_AGO(P_N NUMBER) RETURN DATE;

  -- GET_FIRST_OF_N_YEARS_NEXT_AGO --------------------------------------
  FUNCTION GET_FIRST_OF_N_YEARS_NEXT_AGO(P_DATE DATE
                                        ,P_N    NUMBER) RETURN DATE;
  -- GET_FIRST_OF_N_YEARS_NEXT_AGO --------------------------------------
  FUNCTION GET_FIRST_OF_N_YEARS_NEXT_AGO(P_N NUMBER) RETURN DATE;
  -- GET_LAST_OF_N_YEARS_NEXT_AGO --------------------------------------
  FUNCTION GET_LAST_OF_N_YEARS_NEXT_AGO(P_DATE DATE
                                       ,P_N    NUMBER) RETURN DATE;
  -- GET_LAST_OF_N_YEARS_NEXT_AGO --------------------------------------
  FUNCTION GET_LAST_OF_N_YEARS_NEXT_AGO(P_N NUMBER) RETURN DATE;

  -- GET_SHANBEH_OF --------------------------------------
  FUNCTION GET_SHANBEH(P_DATE DATE) RETURN DATE;
  -- GET_WEEK_DAY_NAME --------------------------------------
  FUNCTION GET_WEEK_DAY_NAME(P_DATE DATE) RETURN VARCHAR2;
  -- GET_MONTH_NAME --------------------------------------
  FUNCTION GET_MONTH_NAME(P_DATE DATE) RETURN VARCHAR2;
  -- GET_MONTH_DAY_NAME --------------------------------------
  FUNCTION GET_MONTH_DAY_NAME(P_DATE DATE) RETURN VARCHAR2;

END;

/*EXPORT/IMPORT BY IRISA_RABBANI AT 30/05/1403
        AND THE LOG_ID IS 3896*/
/
CREATE OR REPLACE PACKAGE BODY "MAM_HEJRI_DATE_HANDLING_PKG" IS

  -- MINUS_ONE_SECOND --------------------------------------
  FUNCTION MINUS_A_MOMENT(P_DATE DATE) RETURN DATE IS
  BEGIN
    RETURN P_DATE -(1 / 172800);
  END;
  -- GET_FIRST_OF_HEJRI_MONTH --------------------------------------
  FUNCTION GET_FIRST_OF_HEJRI_MONTH(P_DATE DATE) RETURN DATE IS
    LV_D VARCHAR2(20) := TO_CHAR(NVL(P_DATE, SYSDATE)
                                ,'YYYY/MM'
                                ,'NLS_CALENDAR=PERSIAN');
  BEGIN
    LV_D := LV_D || '/01';
    RETURN TO_DATE(LV_D, 'YYYY/MM/DD', 'NLS_CALENDAR=PERSIAN');
  END;
  -- GET_FIRST_OF_HEJRI_MONTH --------------------------------------
  FUNCTION GET_FIRST_OF_HEJRI_MONTH RETURN DATE IS
  BEGIN
    RETURN GET_FIRST_OF_HEJRI_MONTH(P_DATE => SYSDATE);
  END;
  -- GET_LAST_OF_HEJRI_MONTH --------------------------------------
  FUNCTION GET_LAST_OF_HEJRI_MONTH(P_DATE DATE) RETURN DATE IS
    LV_D DATE := MAM_HEJRI_DATE_HANDLING_PKG.GET_FIRST_OF_N_MONTHS_NEXT_AGO(P_DATE => P_DATE
                                                                           ,P_N    => 1);
  
  BEGIN
    LV_D := MINUS_A_MOMENT(LV_D);
    RETURN LV_D;
  END;
  -- GET_LAST_OF_HEJRI_MONTH --------------------------------------
  FUNCTION GET_LAST_OF_HEJRI_MONTH RETURN DATE IS
  BEGIN
    RETURN MAM_HEJRI_DATE_HANDLING_PKG.GET_LAST_OF_HEJRI_MONTH(P_DATE => NULL);
  END;
  -- GET_FIRST_OF_N_MONTHS_NEXT_AGO --------------------------------------
  FUNCTION GET_FIRST_OF_N_MONTHS_NEXT_AGO(P_DATE DATE
                                         ,P_N    NUMBER) RETURN DATE IS
    LV_D DATE := NVL(P_DATE, SYSDATE);
    LV_Y NUMBER := TO_NUMBER(TO_CHAR(LV_D, 'YYYY', 'NLS_CALENDAR=PERSIAN'));
    LV_M NUMBER;
    LV_N NUMBER := NVL(P_N, 0) +
                   TO_NUMBER(TO_CHAR(LV_D, 'MM', 'NLS_CALENDAR=PERSIAN'));
  BEGIN
    LV_M := MOD(LV_N, 12);
    IF LV_M = 0
    THEN
      LV_M := 12;
    ELSIF LV_M < 0
    THEN
      LV_M := LV_M + 12;
    END IF;
  
    IF LV_N < 1
    THEN
      LV_Y := LV_Y + TRUNC((LV_N - 12) / 12);
    ELSIF LV_N > 12
    THEN
      LV_Y := LV_Y + TRUNC((LV_N - 1) / 12);
    END IF;
    LV_D := TO_DATE(LV_Y || '/' || LPAD(LV_M, 2, '0') || '/01'
                   ,'YYYY/MM/DD'
                   ,'NLS_CALENDAR=PERSIAN');
  
    RETURN LV_D;
  END;
  -- GET_FIRST_OF_N_MONTHS_NEXT_AGO --------------------------------------
  FUNCTION GET_FIRST_OF_N_MONTHS_NEXT_AGO(P_N NUMBER) RETURN DATE IS
  BEGIN
    RETURN GET_FIRST_OF_N_MONTHS_NEXT_AGO(P_DATE => SYSDATE, P_N => P_N);
  END;

  -- GET_FIRST_OF_N_MONTHS_NEXT_AGO --------------------------------------
  FUNCTION GET_LAST_OF_N_MONTHS_NEXT_AGO(P_DATE DATE
                                        ,P_N    NUMBER) RETURN DATE IS
    LV_D DATE := MAM_HEJRI_DATE_HANDLING_PKG.GET_FIRST_OF_N_MONTHS_NEXT_AGO( --
                                                                            P_DATE => NVL(P_DATE
                                                                                         ,SYSDATE)
                                                                           ,P_N    => P_N + 1
                                                                            --
                                                                            );
  BEGIN
    LV_D := MINUS_A_MOMENT(LV_D);
    RETURN LV_D;
  END;
  -- GET_FIRST_OF_N_MONTHS_NEXT_AGO --------------------------------------
  FUNCTION GET_LAST_OF_N_MONTHS_NEXT_AGO(P_N NUMBER) RETURN DATE IS
  BEGIN
    RETURN GET_LAST_OF_N_MONTHS_NEXT_AGO( --
                                         P_DATE => NULL
                                        ,P_N    => P_N
                                         --
                                         );
  END;
  -- GET_FIRST_OF_N_YEARS_NEXT_AGO --------------------------------------
  FUNCTION GET_FIRST_OF_N_YEARS_NEXT_AGO(P_DATE DATE
                                        ,P_N    NUMBER) RETURN DATE IS
    LV_D DATE := NVL(P_DATE, SYSDATE);
    LV_Y NUMBER := TO_NUMBER(TO_CHAR(LV_D, 'YYYY', 'NLS_CALENDAR=PERSIAN')) + P_N;
  BEGIN
    LV_D := TO_DATE(LV_Y || '/01/01', 'YYYY/MM/DD', 'NLS_CALENDAR=PERSIAN');
  
    RETURN LV_D;
  END;
  -- GET_FIRST_OF_N_YEARS_NEXT_AGO --------------------------------------
  FUNCTION GET_FIRST_OF_N_YEARS_NEXT_AGO(P_N NUMBER) RETURN DATE IS
  BEGIN
    RETURN GET_FIRST_OF_N_YEARS_NEXT_AGO( --
                                         P_DATE => SYSDATE
                                        ,P_N    => P_N
                                         --
                                         );
  END;
  -- GET_LAST_OF_N_YEARS_NEXT_AGO --------------------------------------
  FUNCTION GET_LAST_OF_N_YEARS_NEXT_AGO(P_DATE DATE
                                       ,P_N    NUMBER) RETURN DATE IS
    LV_D DATE := MAM_HEJRI_DATE_HANDLING_PKG.GET_FIRST_OF_N_YEARS_NEXT_AGO( --
                                                                           P_DATE => NVL(P_DATE
                                                                                        ,SYSDATE)
                                                                          ,P_N    => P_N + 1
                                                                           --
                                                                           );
  BEGIN
    LV_D := MINUS_A_MOMENT(LV_D);
    RETURN LV_D;
  END;
  -- GET_LAST_OF_N_YEARS_NEXT_AGO --------------------------------------
  FUNCTION GET_LAST_OF_N_YEARS_NEXT_AGO(P_N NUMBER) RETURN DATE IS
  
  BEGIN
    RETURN GET_LAST_OF_N_YEARS_NEXT_AGO( --
                                        P_DATE => NULL
                                       ,P_N    => P_N
                                        --
                                        );
  END;
  -- GET_SHANBEH_OF --------------------------------------
  FUNCTION GET_SHANBEH(P_DATE DATE) RETURN DATE IS
  BEGIN
    RETURN TRUNC(P_DATE) - MOD(TO_NUMBER(TO_CHAR(P_DATE
                                                ,'D'
                                                ,'NLS_CALENDAR=PERSIAN'))
                              ,7);
  END;
  -- GET_WEEK_DAY_NAME --------------------------------------
  FUNCTION GET_WEEK_DAY_NAME(P_DATE DATE) RETURN VARCHAR2 IS
    LV_N NUMBER;
  BEGIN
    LV_N := TO_NUMBER(TO_CHAR(P_DATE, 'D', 'NLS_CALENDAR=PERSIAN'));
    IF LV_N = 7
    THEN
      RETURN '‘‰»Â';
    ELSIF LV_N = 1
    THEN
      RETURN 'Ìò‘‰»Â';
    ELSIF LV_N = 2
    THEN
      RETURN 'œÊ‘‰»Â';
    ELSIF LV_N = 3
    THEN
      RETURN '”Âù‘‰»Â';
    ELSIF LV_N = 4
    THEN
      RETURN 'çÂ«—‘‰»Â';
    ELSIF LV_N = 5
    THEN
      RETURN 'Å‰Ã‘‰»Â';
    ELSIF LV_N = 6
    THEN
      RETURN 'Ã„⁄Â';
    END IF;
  END;
  -- GET_MONTH_NAME --------------------------------------
  FUNCTION GET_MONTH_NAME(P_DATE DATE) RETURN VARCHAR2 IS
    LV_N NUMBER;
  BEGIN
    LV_N := TO_NUMBER(TO_CHAR(P_DATE, 'MM', 'NLS_CALENDAR=PERSIAN'));
    IF LV_N = 1
    THEN
      RETURN '›—Ê—œÌ‰';
    ELSIF LV_N = 2
    THEN
      RETURN '«—œÌ»Â‘ ';
    ELSIF LV_N = 3
    THEN
      RETURN 'Œ—œ«œ';
    ELSIF LV_N = 4
    THEN
      RETURN ' Ì—';
    ELSIF LV_N = 5
    THEN
      RETURN '„—œ«œ';
    ELSIF LV_N = 6
    THEN
      RETURN '‘Â—ÌÊ—';
    ELSIF LV_N = 7
    THEN
      RETURN '„Â—';
    ELSIF LV_N = 8
    THEN
      RETURN '¬»«‰';
    ELSIF LV_N = 9
    THEN
      RETURN '¬–—';
    ELSIF LV_N = 10
    THEN
      RETURN 'œÌ';
    ELSIF LV_N = 11
    THEN
      RETURN '»Â„‰';
    ELSIF LV_N = 12
    THEN
      RETURN '«”›‰œ';
    END IF;
  END;
  FUNCTION GET_NUMBER_SRIPT(P_N NUMBER) RETURN VARCHAR2 IS
    LV_RESULT VARCHAR2(1000);
    LV_IN     NUMBER := P_N;
    LV_N      NUMBER;
  BEGIN
    LV_N := MOD(LV_IN, 20);
    IF LV_N = 1
    THEN
      RETURN '«Ê·';
    ELSIF LV_N = 2
    THEN
      RETURN 'œÊ„';
    ELSIF LV_N = 3
    THEN
      RETURN '”Ê„';
    ELSIF LV_N = 4
    THEN
      RETURN 'çÂ«—„';
    ELSIF LV_N = 5
    THEN
      RETURN 'Å‰Ã„';
    ELSIF LV_N = 6
    THEN
      RETURN '‘‘„';
    ELSIF LV_N = 7
    THEN
      RETURN 'Â› „';
    ELSIF LV_N = 8
    THEN
      RETURN 'Â‘ „';
    ELSIF LV_N = 9
    THEN
      RETURN '‰Â„';
    ELSIF LV_N = 10
    THEN
      RETURN 'œÂ„';
    ELSIF LV_N = 11
    THEN
      RETURN 'Ì«“œÂ„';
    ELSIF LV_N = 12
    THEN
      RETURN 'œÊ«“œÂ„';
    ELSIF LV_N = 13
    THEN
      RETURN '”Ì“œÂ„';
    ELSIF LV_N = 14
    THEN
      RETURN 'çÂ«—œÂ„';
    ELSIF LV_N = 15
    THEN
      RETURN 'Å«‰“œÂ„';
    ELSIF LV_N = 16
    THEN
      RETURN '‘«‰“œÂ„';
    ELSIF LV_N = 17
    THEN
      RETURN 'Â›œÂ„';
    ELSIF LV_N = 18
    THEN
      RETURN 'ÂÃœÂ„';
    ELSIF LV_N = 19
    THEN
      RETURN '‰Ê“œÂ„';
    END IF;
  END;
  -- GET_MONTH_DAY_NAME --------------------------------------
  FUNCTION GET_MONTH_DAY_NAME(P_DATE DATE) RETURN VARCHAR2 IS
    LV_N NUMBER;
  BEGIN
    LV_N := TO_NUMBER(TO_CHAR(P_DATE, 'dd', 'NLS_CALENDAR=PERSIAN'));
    IF LV_N = 1
    THEN
      RETURN '«Ê·';
    ELSIF LV_N = 2
    THEN
      RETURN 'œÊ„';
    ELSIF LV_N = 3
    THEN
      RETURN '”Ê„';
    ELSIF LV_N = 4
    THEN
      RETURN 'çÂ«—„';
    ELSIF LV_N = 5
    THEN
      RETURN 'Å‰Ã„';
    ELSIF LV_N = 6
    THEN
      RETURN '‘‘„';
    ELSIF LV_N = 7
    THEN
      RETURN 'Â› „';
    ELSIF LV_N = 8
    THEN
      RETURN 'Â‘ „';
    ELSIF LV_N = 9
    THEN
      RETURN '‰Â„';
    ELSIF LV_N = 10
    THEN
      RETURN 'œÂ„';
    ELSIF LV_N = 11
    THEN
      RETURN 'Ì«“œÂ„';
    ELSIF LV_N = 12
    THEN
      RETURN 'œÊ«“œÂ„';
    ELSIF LV_N = 13
    THEN
      RETURN '”Ì“œÂ„';
    ELSIF LV_N = 14
    THEN
      RETURN 'çÂ«—œÂ„';
    ELSIF LV_N = 15
    THEN
      RETURN 'Å«‰“œÂ„';
    ELSIF LV_N = 16
    THEN
      RETURN '‘«‰“œÂ„';
    ELSIF LV_N = 17
    THEN
      RETURN 'Â›œÂ„';
    ELSIF LV_N = 18
    THEN
      RETURN 'ÂÃœÂ„';
    ELSIF LV_N = 19
    THEN
      RETURN '‰Ê“œÂ„';
    ELSIF LV_N = 20
    THEN
      RETURN '»Ì” „';
    ELSIF LV_N = 21
    THEN
      RETURN '»Ì”  Ê Ìò„';
    ELSIF LV_N = 22
    THEN
      RETURN '»Ì”  Ê œÊ„';
    ELSIF LV_N = 23
    THEN
      RETURN '»Ì”  Ê ”Ê„';
    ELSIF LV_N = 24
    THEN
      RETURN '»Ì”  Ê çÂ«—„';
    ELSIF LV_N = 25
    THEN
      RETURN '»Ì”  Ê Å‰Ã„';
    ELSIF LV_N = 26
    THEN
      RETURN '»Ì”  Ê ‘‘„';
    ELSIF LV_N = 27
    THEN
      RETURN '»Ì”  Ê Â› „';
    ELSIF LV_N = 28
    THEN
      RETURN '»Ì”  Ê Â‘ „';
    ELSIF LV_N = 29
    THEN
      RETURN '»Ì”  Ê ‰Â„';
    ELSIF LV_N = 30
    THEN
      RETURN '”Ì„';
    ELSIF LV_N = 31
    THEN
      RETURN '”Ì Ê Ìò„';
    END IF;
  END;

BEGIN
  -- Initialization
  NULL;
END;

/*EXPORT/IMPORT BY IRISA_RABBANI AT 30/05/1403
        AND THE LOG_ID IS 3896*/
/
