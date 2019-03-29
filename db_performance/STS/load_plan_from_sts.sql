-- In case you need to fix plan using STS, first
-- Loading all plans from SQL Tuning Sets into SQL plan baselines.
DECLARE
    my_plans PLS_INTEGER;
BEGIN
    my_plans := DBMS_SPM.LOAD_PLANS_FROM_SQLSET(sqlset_name => '&&sqlset_name');
END;
/

-- Loading specific SQL_ID plan from SQL Tuning Sets into SQL plan baselines.
DECLARE
    my_plans PLS_INTEGER;
BEGIN
    my_plans := DBMS_SPM.LOAD_PLANS_FROM_SQLSET(sqlset_name => '&&sqlset_name', 'sql_id=''&&sql_id''');
END;
/