CREATE OR REPLACE FUNCTION SRM_REMOVE_DUPLICATES_FUN(INPUT_STRING IN VARCHAR2)
  RETURN VARCHAR2 IS
  V_RESULT         VARCHAR2(4000); -- ���� ����� �� ������ ���
  V_TEMP           VARCHAR2(4000); -- ���� ���� ���� ������
  V_ITEM           VARCHAR2(100); -- ����� ��� ��� �� ����
  V_DISTINCT_ITEMS VARCHAR2(4000); -- ���� ���� ������ ������ ���
BEGIN
  -- ����� ���� ���� �� ������ ���� ���� ������
  V_TEMP := INPUT_STRING || ',';

  -- ������ ����
  WHILE INSTR(V_TEMP, ',') > 0
  LOOP
    -- ������� ����� ����� �� ����
    V_ITEM := TRIM(SUBSTR(V_TEMP, 1, INSTR(V_TEMP, ',') - 1));
    -- ��� ����� ������ ��� �� ����
    V_TEMP := SUBSTR(V_TEMP, INSTR(V_TEMP, ',') + 1);

    -- ǐ� ����� �� ���� ������ ��� ���ʡ ����� ��
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

  -- ��Ґ������ ������ ���
  RETURN V_DISTINCT_ITEMS;
END;
/
