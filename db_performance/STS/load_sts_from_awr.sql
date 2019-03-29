-- Loading a SQL Tuning Set from AWR.
DECLARE
    baseline_cursor DBMS_SQLTUNE.SQLSET_CURSOR;
BEGIN
    OPEN baseline_cursor FOR
        SELECT VALUE(p) FROM TABLE (DBMS_SQLTUNE.SELECT_WORKLOAD_REPOSITORY(begin_snap => '&begin_snap', end_snap => '&end_snap', basic_filter => 'parsing_schema_name = ''PCS_USER''')) p;
    DBMS_SQLTUNE.LOAD_SQLSET(sqlset_name => 'for_spa_nchillal', populate_cursor => baseline_cursor);
END;
/

