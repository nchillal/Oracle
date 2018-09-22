SET SERVEROUTPUT ON
DECLARE
  l_plans_loaded  PLS_INTEGER;
BEGIN
  l_plans_loaded := DBMS_SPM.LOAD_PLANS_FROM_CURSOR_CACHE(sql_id => '&sql_id', plan_hash_value => &plan_hash_value);
  DBMS_OUTPUT.PUT_LINE('Plans Loaded: ' || l_plans_loaded);
END;
/

SELECT  TO_CHAR(created, 'DD-MON-RR HH24:MI:SS') CREATED,
        TO_CHAR(last_modified, 'DD-MON-RR HH24:MI:SS') LAST_MODIFIED,
        TO_CHAR(last_executed, 'DD-MON-RR HH24:MI:SS') LAST_EXECUTED,
        sql_handle,
        plan_name,
        enabled,
        accepted,
        fixed
FROM    dba_sql_plan_baselines
WHERE   signature IN (SELECT exact_matching_signature FROM v$sql WHERE sql_id='&SQL_ID');

SELECT *
FROM   TABLE(DBMS_XPLAN.DISPLAY_SQL_PLAN_BASELINE(plan_name=>'&plan_name'));

SET SERVEROUTPUT ON
DECLARE
  l_plans_altered PLS_INTEGER;
BEGIN
  l_plans_altered := DBMS_SPM.ALTER_SQL_PLAN_BASELINE(sql_handle => '&sql_handle', plan_name => '&plan_name', attribute_name => 'FIXED', attribute_value => 'YES');
  DBMS_OUTPUT.put_line('Plans Altered: ' || l_plans_altered);
END;
/

SET SERVEROUTPUT ON
DECLARE
  l_plans_dropped  PLS_INTEGER;
BEGIN
  l_plans_dropped := DBMS_SPM.DROP_SQL_PLAN_BASELINE(sql_handle => '&sql_handle', plan_name  => '&plan_name');
  DBMS_OUTPUT.PUT_LINE('Plans Dropped: ' ||l_plans_dropped);
END;
/
