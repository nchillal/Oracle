SELECT    sql_id, sql_child_number, COUNT(*)
FROM      v$active_session_history
WHERE     sample_time > TO_DATE('&start_datetime','MMDDYYHH24MI')
AND       sample_time < TO_DATE('&end_datetime','MMDDYYHH24MI')
AND       user_id > 0
GROUP BY  sql_id, sql_child_number
ORDER BY  COUNT(*);

SELECT    sql_id,sql_child_number, COUNT(*)
FROM      DBA_HIST_ACTIVE_SESS_HISTORY
WHERE     sample_time > TO_DATE('&start_datetime','MMDDYYHH24MI')
AND       sample_time < TO_DATE('&end_datetime','MMDDYYHH24MI')
AND       user_id > 0
GROUP BY  sql_id, sql_child_number
ORDER BY  COUNT(*);
