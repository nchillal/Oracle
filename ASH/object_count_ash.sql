SELECT    current_obj#, COUNT(*)
FROM      v$active_session_history
WHERE     sample_time > TO_DATE('&start_datetime','MMDDYYHH24MI')
AND       sample_time < TO_DATE('&end_datetime','MMDDYYHH24MI')
AND       user_id > 0
GROUP BY  current_obj#
ORDER BY  COUNT(*);

SELECT    current_obj#, COUNT(*)
FROM      dba_hist_active_sess_history
WHERE     sample_time > TO_DATE('&start_datetime','MMDDYYHH24MI')
AND       sample_time < TO_DATE('&end_datetime','MMDDYYHH24MI')
AND       user_id > 0
GROUP BY  current_obj#
ORDER BY  COUNT(*);
