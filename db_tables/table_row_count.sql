SELECT    'SELECT COUNT(*) FROM '||owner||'.'||table_name||';' "NUM_ROWS_TABLE"
FROM      dba_tables
WHERE     owner='&schema_owner'
ORDER BY  table_name;

SET SERVEROUTPUT ON
DECLARE
    sql_stat VARCHAR(200);
    cnt NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE(CHR(13));
    FOR rec IN (SELECT owner, table_name FROM dba_tables WHERE owner='&schema_name')
    LOOP

        sql_stat := 'SELECT COUNT(*) FROM '||rec.owner||'.'||rec.table_name;
        EXECUTE IMMEDIATE sql_stat INTO cnt;
        DBMS_OUTPUT.PUT_LINE(rec.owner||'.'||rec.table_name||' (row count -> '||cnt||')');
    END LOOP;
END;
/
