-- Evolve SQL Plan Baseline.
DECLARE
    report clob;
BEGIN
    report := DBMS_SPM.EVOLVE_SQL_PLAN_BASELINE(sql_handle => '&sql_handle');
    DBMS_OUTPUT.PUT_LINE(report);
END;
/
