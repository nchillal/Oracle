# Create the tuning task
SET SERVEROUTPUT ON

DECLARE
  stmt_task VARCHAR2(40);
BEGIN
  stmt_task := DBMS_SQLTUNE.CREATE_TUNING_TASK(sql_id => '&sql_id', scope=> 'COMPREHENSIVE');
  DBMS_OUTPUT.put_line('task_id: ' || stmt_task );
END;
/

# Run the SQL TUNING TASK
BEGIN
  DBMS_SQLTUNE.EXECUTE_TUNING_TASK(task_name => '&task_name');
END;
/

# Monitor the processing of the tuning task with the statement
SELECT  TASK_NAME, STATUS
FROM    DBA_ADVISOR_LOG
WHERE   TASK_NAME = '&task_name';

# View the recommendation
SELECT  DBMS_SQLTUNE.REPORT_TUNING_TASK('&task_name') AS recommendations
FROM    dual;
