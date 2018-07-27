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

SELECT SQL_ID, PARSING_SCHEMA_NAME AS "SCH", SQL_TEXT,
       ELAPSED_TIME AS "ELAPSED", BUFFER_GETS
FROM   TABLE(DBMS_SQLTUNE.SELECT_SQLSET('&&sqlset_name'));

-- In case you need to fix plan using STS, first
-- Loading Plans from SQL Tuning Sets and AWR Snapshots
DECLARE
    my_plans PLS_INTEGER;
BEGIN
    my_plans := DBMS_SPM.LOAD_PLANS_FROM_SQLSET(sqlset_name => '&&sqlset_name');
END;
/

DECLARE
    my_plans PLS_INTEGER;
BEGIN
    my_plans := DBMS_SPM.LOAD_PLANS_FROM_SQLSET(sqlset_name => '&&sqlset_name', 'sql_id=''&&sql_id''');
END;
/


-- To verify the execution Plan of a SQL_ID in the STS
SELECT * FROM table(dbms_xplan.display_sqlset('&&sqlset_name','&&sql_id'));
