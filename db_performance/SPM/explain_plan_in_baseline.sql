-- Display plan in SQL Baseline.
SELECT *
FROM   TABLE(DBMS_XPLAN.DISPLAY_SQL_PLAN_BASELINE(plan_name=>'&plan_name'));