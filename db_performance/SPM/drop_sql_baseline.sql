-- Drop SQL Plan Baseline.
DECLARE
    l_plans_dropped  PLS_INTEGER;
BEGIN
    l_plans_dropped := DBMS_SPM.DROP_SQL_PLAN_BASELINE(sql_handle => '&sql_handle', plan_name  => '&plan_name');
    DBMS_OUTPUT.PUT_LINE('Plans Dropped: ' ||l_plans_dropped);
END;
/