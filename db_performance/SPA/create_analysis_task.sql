-- Create SPA analysis task.
SET SERVEROUTPUT ON
DECLARE
    task_name VARCHAR2(100);
BEGIN
    task_name := DBMS_SQLPA.CREATE_ANALYSIS_TASK(sqlset_name => '&sqlset_name');
    DBMS_OUTPUT.PUT_LINE('task_id: '||task_name);
END;
/
