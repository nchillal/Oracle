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
