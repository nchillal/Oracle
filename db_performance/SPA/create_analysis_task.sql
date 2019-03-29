-- Create SPA analysis task.
DECLARE
    task_name VARCHAR2(100);
BEGIN
    t_name := DBMS_SQLPA.CREATE_ANALYSIS_TASK(sqlset_name => '&sqlset_name', task_name => 'my_spa_task');
    DBMS_OUTPUT.PUT_LINE('task_id: '||task_name);
END;
/
