-- If you have a good plan in the cursor cache, then you can load these into SPM so that you can use this baseline to preserve the performance.
-- Loading plans from the SQL Shared Area.
SET SERVEROUTPUT ON
SET LONG 10000

DECLARE
    l_plans_loaded  PLS_INTEGER;
BEGIN
    l_plans_loaded := DBMS_SPM.LOAD_PLANS_FROM_CURSOR_CACHE(sql_id => '&sql_id', plan_hash_value => &plan_hash_value, fixed =>'NO', enabled=>'YES');
    DBMS_OUTPUT.PUT_LINE('Plans Loaded: ' || l_plans_loaded);
END;
/