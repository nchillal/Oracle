-- Create SPA analysis task.
VARIABLE task_name VARCHAR2(35);

EXEC :task_name := DBMS_SQLPA.CREATE_ANALYSIS_TASK(sql_text => '&sql_text', parsing_schema => '&parsing_schema_name');
EXEC :task_name := DBMS_SQLPA.CREATE_ANALYSIS_TASK(sql_id => '&sql_id');
EXEC :task_name := DBMS_SQLPA.CREATE_ANALYSIS_TASK(begin_snap => '&begin_snap', end_snap => '&end_snap');
EXEC :task_name := DBMS_SQLPA.CREATE_ANALYSIS_TASK('&sqlset_name', basic_filter => 'parsing_schema_name = ''PCS_USER''');

SELECT owner, task_name, status FROM dba_advisor_tasks WHERE advisor_name = 'SQL Performance Analyzer';