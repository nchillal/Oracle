COLUMN object_name FORMAT a30

SELECT    object_name, object_type, COUNT(*)
FROM      v$active_session_history ash, dba_objects do
WHERE     sample_time > TO_DATE('&start_datetime','MMDDYYHH24MI')
AND       sample_time < TO_DATE('&end_datetime','MMDDYYHH24MI')
AND       user_id > 0
AND       ash.current_obj# = do.object_id
HAVING    COUNT(*) > 10
GROUP BY  object_name, object_type
ORDER BY  COUNT(*);

SELECT    object_name, object_type, COUNT(*)
FROM      dba_hist_active_sess_history ash, dba_objects do
WHERE     sample_time > TO_DATE('&start_datetime','MMDDYYHH24MI')
AND       sample_time < TO_DATE('&end_datetime','MMDDYYHH24MI')
AND       user_id > 0
AND       ash.current_obj# = do.object_id
HAVING    COUNT(*) > 10
GROUP BY  object_name, object_type
ORDER BY  COUNT(*);
