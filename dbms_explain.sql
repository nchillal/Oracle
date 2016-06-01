set lines 230 pages 200
col PLAN_TABLE_OUTPUT for a140

SELECT  * 
FROM    table(DBMS_XPLAN.DISPLAY_CURSOR('&sql_id',&child_number))
/
