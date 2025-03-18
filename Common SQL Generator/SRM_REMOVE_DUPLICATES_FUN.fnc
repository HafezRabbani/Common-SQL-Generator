CREATE OR REPLACE FUNCTION SRM_REMOVE_DUPLICATES_FUN(INPUT_STRING IN VARCHAR2)
  RETURN VARCHAR2 IS
  V_RESULT         VARCHAR2(4000); -- —‘ Â Œ—ÊÃÌ »« „ﬁ«œÌ— Ìò «
  V_TEMP           VARCHAR2(4000); -- —‘ Â „Êﬁ  »—«Ì Å—œ«“‘
  V_ITEM           VARCHAR2(100); -- „ﬁœ«— Ãœ« ‘œÂ «“ —‘ Â
  V_DISTINCT_ITEMS VARCHAR2(4000); -- —‘ Â »—«Ì ‰êÂœ«—Ì „ﬁ«œÌ— Ìò «
BEGIN
  -- «÷«›Â ò—œ‰ ò«„« »Â «‰ Â«Ì —‘ Â »—«Ì Å—œ«“‘
  V_TEMP := INPUT_STRING || ',';

  -- Å—œ«“‘ —‘ Â
  WHILE INSTR(V_TEMP, ',') > 0
  LOOP
    -- «” Œ—«Ã «Ê·Ì‰ „ﬁœ«— «“ —‘ Â
    V_ITEM := TRIM(SUBSTR(V_TEMP, 1, INSTR(V_TEMP, ',') - 1));
    -- Õ–› „ﬁœ«— Å—œ«“‘ ‘œÂ «“ —‘ Â
    V_TEMP := SUBSTR(V_TEMP, INSTR(V_TEMP, ',') + 1);

    -- «ê— „ﬁœ«— œ— ·Ì”  „ﬁ«œÌ— Ìò « ‰Ì” ° «÷«›Â ò‰
    IF INSTR(',' || V_DISTINCT_ITEMS || ',', ',' || V_ITEM || ',') = 0
    THEN
      IF V_DISTINCT_ITEMS IS NULL
      THEN
        V_DISTINCT_ITEMS := V_ITEM;
      ELSE
        V_DISTINCT_ITEMS := V_DISTINCT_ITEMS || ',' || V_ITEM;
      END IF;
    END IF;
  END LOOP;

  -- »«“ê—œ«‰œ‰ „ﬁ«œÌ— Ìò «
  RETURN V_DISTINCT_ITEMS;
END;
/
