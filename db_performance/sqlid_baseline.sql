SET SERVEROUTPUT ON
DECLARE
  v_sqlid VARCHAR2(13);
  v_num NUMBER;
BEGIN
  DBMS_OUTPUT.PUT_LINE('SQL_ID         '||'  '||'PLAN_HASH_VALUE'||'  '||'SQL_HANDLE                    '||'  '||'PLAN_NAME');
  DBMS_OUTPUT.PUT_LINE('---------------'||'  '||'---------------'||'  '||'------------------------------'||'  '||'--------------------------------');
FOR a IN (
          SELECT  sql_handle,
                  plan_name,
                  TRIM(SUBSTR(g.plan_table_output, INSTR(g.plan_table_output,':')+1)) plan_hash_value,
                  sql_text
          FROM    (
                  SELECT  t.*,
                          c.sql_handle,
                          c.plan_name,
                          c.sql_text
                  FROM    dba_sql_plan_baselines c, TABLE(dbms_xplan.DISPLAY_SQL_PLAN_BASELINE(c.sql_handle, c.plan_name)) t) g
                  WHERE   plan_table_output LIKE 'Plan hash value%'
          )
LOOP
    v_num := TO_NUMBER(SYS.UTL_RAW.REVERSE(SYS.UTL_RAW.SUBSTR(SYS.DBMS_CRYPTO.HASH(src => UTL_I18N.STRING_TO_RAW(a.sql_text || CHR(0),'AL32UTF8'), typ => 2),9,4)) || sys.UTL_RAW.REVERSE(sys.UTL_RAW.SUBSTR(sys.DBMS_CRYPTO.HASH(src => UTL_I18N.string_to_raw(a.sql_text || CHR(0),'AL32UTF8'), typ => 2),13,4)),RPAD('x', 16, 'x'));
    v_sqlid := '';
    FOR i IN 0 .. FLOOR(LN(v_num)/LN(32))
    LOOP
        v_sqlid := SUBSTR('0123456789abcdfghjkmnpqrstuvwxyz', FLOOR(MOD(v_num/POWER(32, i), 32)) + 1, 1) || v_sqlid;
    END LOOP;
    dbms_output.put_line(RPAD(v_sqlid, 15)||'  '|| RPAD(a.plan_hash_value,15) ||'  '||RPAD(a.sql_handle,30) ||'  '|| RPAD(a.plan_name,30));
END LOOP;
END;
/
