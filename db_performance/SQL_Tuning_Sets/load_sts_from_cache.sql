-- Create SQL Tuning set
BEGIN
    DBMS_SQLTUNE.CREATE_SQLSET
    (
      sqlset_name  => '&&sqlset_name',
      description  => '&&sqlset_name'
    );
END;
/

-- Load SQL Tuning set
DECLARE
  c_sqlarea_cursor DBMS_SQLTUNE.SQLSET_CURSOR;
BEGIN
 OPEN c_sqlarea_cursor FOR
    SELECT VALUE(p)
    FROM   TABLE(DBMS_SQLTUNE.SELECT_CURSOR_CACHE('parsing_schema_name = ''&parsing_schema_name''')) p;
    -- load the tuning set
    DBMS_SQLTUNE.LOAD_SQLSET(sqlset_name => '&&sqlset_name', populate_cursor => c_sqlarea_cursor);
END;
/

-- To display the contents of an STS
COLUMN SQL_TEXT FORMAT a100
COLUMN SCH FORMAT a20
COLUMN ELAPSED FORMAT 999999999

SELECT sql_id, parsing_schema_name AS "SCH", elapsed_time AS "ELAPSED", buffer_gets
FROM   TABLE(DBMS_SQLTUNE.SELECT_SQLSET('&&sqlset_name'));

-- In case you need to fix plan using STS, first
-- Loading all plans from SQL Tuning Sets
DECLARE
    my_plans PLS_INTEGER;
BEGIN
    my_plans := DBMS_SPM.LOAD_PLANS_FROM_SQLSET(sqlset_name => '&&sqlset_name');
END;
/

-- Loading specific SQL_ID plan from SQL Tuning Sets
DECLARE
    my_plans PLS_INTEGER;
BEGIN
    my_plans := DBMS_SPM.LOAD_PLANS_FROM_SQLSET(sqlset_name => '&&sqlset_name', 'sql_id=''&&sql_id''');
END;
/

-- To verify the execution Plan of a SQL_ID in the STS
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_SQLSET('&&sqlset_name','&&sql_id'));


SELECT  sql_id,
        parsing_schema_name as "schema",
        plan_hash_value, elapsed_time "elapsed",
        buffer_gets, 
        rows_processed,
        disk_reads,
        executions
FROM    TABLE(DBMS_SQLTUNE.SELECT_SQLSET('&&sqlset_name'));
