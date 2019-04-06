SET linesize 230 pagesize 2000
COLUMN plan_table_output FORMAT a160

-- Display execution plan of EXPLAIN FOR <statement>.
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY(FORMAT => 'ALL'));

-- Display current execution plan of sql_id.
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR('&sql_id', &child_number, FORMAT => 'ALL'));

-- Display all execution plan for a sql_id.
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_AWR('&sql_id', FORMAT => 'ALL'));

-- Display execution plan of a sql plan baseline. Pass sql_handle from dba_sql_plan_baselines
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_SQL_PLAN_BASELINE('&sql_handle', FORMAT => 'ALL'));

-- Displays the execution plan of a given statement stored in a SQL tuning set.
SELECT * FROM TABLE (DBMS_XPLAN.DISPLAY_SQLSET('&sqlset_name','&sql_id', &plan_hash_value, FORMAT => 'ALL'));
