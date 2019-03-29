-- Drop SPA analysis task.
EXEC DBMS_SQLPA.DROP_ANALYSIS_TASK(task_name => '&task_name');