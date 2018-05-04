BREAK ON sql_id SKIP 1

SELECT  DISTINCT sql_id, child_number, sql_handle, plan_name, a.parsing_schema_name, origin, enabled, accepted
FROM    dba_sql_plan_baselines a, v$sql b
WHERE   a.signature = b.exact_matching_signature
AND     a.signature = b.force_matching_signature;



DECLARE
  v_sqlid VARCHAR2(13);
  v_num NUMBER;
BEGIN
  dbms_output.put_line('SQL_ID       '||' '|| 'PLAN_HASH_VALUE' || ' ' || 'SQL_HANDLE                    ' || ' ' || 'PLAN_NAME');
  dbms_output.put_line('-------------'||' '|| '---------------' || ' ' || '------------------------------' || ' ' || '--------------------------------');
  FOR a IN (SELECT sql_handle, plan_name, TRIM(SUBSTR(g.plan_table_output, INSTR(g.plan_table_output, ':') +1)) plan_hash_value, sql_text
            FROM  (
                  SELECT t.*, c.sql_handle, c.plan_name, c.sql_text FROM dba_sql_plan_baselines c, table(dbms_xplan.DISPLAY_SQL_PLAN_BASELINE(c.sql_handle, c.plan_name)) t
                  where c.sql_handle = '&sql_handle'
                  ) g
            WHERE plan_table_output LIKE 'Plan hash value%'
          ) LOOP
    v_num := TO_NUMBER(sys.utl_raw.reverse(sys.UTL_RAW.SUBSTR(sys.dbms_crypto.hash(src => UTL_I18N.string_to_raw(a.sql_text || chr(0),'AL32UTF8'), typ => 2),9,4)) || sys.UTL_RAW.reverse(sys.UTL_RAW.SUBSTR(sys.dbms_crypto.hash(src => UTL_I18N.string_to_raw(a.sql_text || chr(0),'AL32UTF8'), typ => 2),13,4)),RPAD('x', 16, 'x'));
    v_sqlid := '';
    FOR i IN 0 .. FLOOR(LN(v_num) / LN(32))
    LOOP
        v_sqlid := SUBSTR('0123456789abcdfghjkmnpqrstuvwxyz',FLOOR(MOD(v_num / POWER(32, i), 32)) + 1,1) || v_sqlid;
    END LOOP;
    dbms_output.put_line(v_sqlid ||' ' || rpad(a.plan_hash_value,15) || ' ' || rpad(a.sql_handle,30) ||  ' ' || rpad(a.plan_name,30));
END LOOP;
END;
/
