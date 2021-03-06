-- Create the tuning task
SET SERVEROUTPUT ON PAUSE ON

DECLARE
    task_name VARCHAR2(40);
BEGIN
    task_name := DBMS_SQLTUNE.CREATE_TUNING_TASK(sql_id => '&sql_id', scope=> 'COMPREHENSIVE');
    DBMS_OUTPUT.PUT_LINE('task_id: ' ||task_name);
END;
/

-- Run the SQL TUNING TASK
EXEC DBMS_SQLTUNE.EXECUTE_TUNING_TASK(task_name => '&&task_name');

-- Monitor the processing of the tuning task with the statement
SELECT  TASK_NAME, STATUS
FROM    DBA_ADVISOR_LOG
WHERE   TASK_NAME = '&&task_name';

-- View the recommendation
SET linesize 200
SET LONG 999999999
SET pagesize 1000
SET longchunksize 20000
SELECT  DBMS_SQLTUNE.REPORT_TUNING_TASK('&&task_name') AS recommendations
FROM    dual;
