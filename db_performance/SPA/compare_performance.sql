EXEC DBMS_SQLPA.EXECUTE_ANALYSIS_TASK(task_name => :v_task, execution_type => 'compare performance', execution_params => DBMS_ADVISOR.ARGLIST( '&before_change', 'before_change', '&after_change', 'after_change'));