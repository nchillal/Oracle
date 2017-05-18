SET linesize 230 pagesize 200
COLUMN plan_table_output FORMAT a140

SELECT  *
FROM    table(DBMS_XPLAN.display_cursor('&sql_id', &child_number))
/
