SET linesize 230 pagesize 2000
COLUMN plan_table_output FORMAT a160

-- Display execution plan of EXPLAIN FOR <statement>.
SELECT * FROM table(DBMS_XPLAN.DISPLAY);

-- Display current execution plan of sql_id.
SELECT  *
FROM    table(DBMS_XPLAN.display_cursor('&sql_id', &child_number), )
/

-- Display all explain plan for a sql_id.
SELECT  *
FROM    table(DBMS_XPLAN.display_awr('&sql_id'));
