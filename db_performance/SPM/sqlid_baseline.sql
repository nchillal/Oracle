BREAK ON sql_id SKIP 1

SELECT  DISTINCT sql_id, child_number, sql_handle, plan_name, a.parsing_schema_name, origin, enabled, accepted, created, fixed, last_modified, a.elapsed_time
FROM    dba_sql_plan_baselines a, v$sql b
WHERE   a.signature = b.exact_matching_signature
AND     a.signature = b.force_matching_signature
AND     b.sql_id = '&sql_id';



DECLARE
  v_sqlid VARCHAR2(13);
  v_num NUMBER;
BEGIN
  DBMS_OUTPUT.PUT_LINE('SQL_ID       '||' '|| 'PLAN_HASH_VALUE' || ' ' || 'SQL_HANDLE                    ' || ' ' || 'PLAN_NAME');
  DBMS_OUTPUT.PUT_LINE('-------------'||' '|| '---------------' || ' ' || '------------------------------' || ' ' || '--------------------------------');
  FOR a IN (SELECT sql_handle, plan_name, TRIM(SUBSTR(g.plan_table_output, INSTR(g.plan_table_output, ':') +1)) plan_hash_value, sql_text
            FROM  (
                  SELECT t.*, c.sql_handle, c.plan_name, c.sql_text FROM dba_sql_plan_baselines c, table(DBMS_XPLAN.DISPLAY_SQL_PLAN_BASELINE(c.sql_handle, c.plan_name)) t
                  WHERE c.sql_handle = '&sql_handle'
                  ) g
            WHERE plan_table_output LIKE 'Plan hash value%'
          ) LOOP
    v_num := TO_NUMBER(SYS.UTL_RAW.REVERSE(SYS.UTL_RAW.SUBSTR(SYS.DBMS_CRYPTO.HASH(src => UTL_I18N.STRING_TO_RAW(a.sql_text || chr(0), 'AL32UTF8'), typ => 2), 9, 4)) || SYS.UTL_RAW.REVERSE(SYS.UTL_RAW.SUBSTR(SYS.DBMS_CRYPTO.HASH(src => UTL_I18N.STRING_TO_RAW(a.sql_text || chr(0), 'AL32UTF8'), typ => 2), 13, 4)),RPAD('x', 16, 'x'));
    v_sqlid := '';
    FOR i IN 0 .. FLOOR(LN(v_num) / LN(32))
    LOOP
        v_sqlid := SUBSTR('0123456789abcdfghjkmnpqrstuvwxyz', FLOOR(MOD(v_num / POWER(32, i), 32)) + 1,1) || v_sqlid;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(v_sqlid ||' ' || rpad(a.plan_hash_value,15) || ' ' || rpad(a.sql_handle,30) ||  ' ' || rpad(a.plan_name,30));
END LOOP;
END;
/
