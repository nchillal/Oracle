-- Alert SQL Plan Baseline.
DECLARE
    l_plans_altered PLS_INTEGER;
BEGIN
    l_plans_altered := DBMS_SPM.ALTER_SQL_PLAN_BASELINE(sql_handle => '&sql_handle', plan_name => '&plan_name', attribute_name => 'FIXED', attribute_value => 'YES');
    DBMS_OUTPUT.PUT_LINE('Plans Altered: ' || l_plans_altered);
END;
/