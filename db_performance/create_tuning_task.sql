-- Create the tuning task
SET SERVEROUTPUT ON PAUSE ON

DECLARE
  stmt_task VARCHAR2(40);
BEGIN
  stmt_task := DBMS_SQLTUNE.create_tuning_task(sql_id => '&sql_id', scope=> 'COMPREHENSIVE');
  DBMS_OUTPUT.put_line('task_id: ' || stmt_task );
END;
/

-- Run the SQL TUNING TASK
BEGIN
  DBMS_SQLTUNE.execute_tuning_task(task_name => '&task_name');
END;
/

-- Monitor the processing of the tuning task with the statement
SELECT  TASK_NAME, STATUS
FROM    DBA_ADVISOR_LOG
WHERE   TASK_NAME = '&task_name';

-- View the recommendation
SET linesize 200
SET LONG 999999999
SET pagesize 1000
SET longchunksize 20000
SELECT  DBMS_SQLTUNE.report_tuning_task('&task_name') AS recommendations
FROM    dual;
