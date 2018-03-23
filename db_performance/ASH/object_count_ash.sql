COLUMN object_name FORMAT a30

SELECT    username, object_name, object_type, COUNT(*)
FROM      v$active_session_history ash, dba_objects do, dba_users du
WHERE     ash.user_id = du.user_id
AND       sample_time > TO_DATE('&start_datetime','DDMMRRHH24MI')
AND       sample_time < TO_DATE('&end_datetime','DDMMRRHH24MI')
AND       ash.user_id > 0
AND       ash.current_obj# = do.object_id
HAVING    COUNT(*) > 10
GROUP BY  username, object_name, object_type
ORDER BY  COUNT(*);

SELECT    username, object_name, object_type, COUNT(*)
FROM      dba_hist_active_sess_history ash, dba_objects do, dba_users du
WHERE     ash.user_id = du.user_id
AND       sample_time > TO_DATE('&start_datetime','DDMMRRHH24MI')
AND       sample_time < TO_DATE('&end_datetime','DDMMRRHH24MI')
AND       ash.user_id > 0
AND       ash.current_obj# = do.object_id
HAVING    COUNT(*) > 10
GROUP BY  username, object_name, object_type
ORDER BY  COUNT(*);
