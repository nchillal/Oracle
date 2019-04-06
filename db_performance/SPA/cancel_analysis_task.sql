-- Cancelling executing SPA task.
EXEC DBMS_SQLPA.CANCEL_ANALYSIS_TASK(task_name => '&task_name');