SELECT  *
FROM    (
        SELECT    username, sql_id, sql_child_number, COUNT(*)
        FROM      v$active_session_history ash, dba_users du
        WHERE     ash.user_id = du.user_id
        AND       sample_time > TO_DATE('&&start_datetime','DDMMRRHH24MI')
        AND       sample_time < TO_DATE('&&end_datetime','DDMMRRHH24MI')
        AND       ash.user_id > 0
        GROUP BY  username, sql_id, sql_child_number
        ORDER BY  COUNT(*) DESC
        )
WHERE   rownum <= 10;

SELECT  *
FROM    (
        SELECT    instance_number, username, sql_id, sql_child_number, COUNT(*)
        FROM      dba_hist_active_sess_history ash, dba_users du
        WHERE     ash.user_id = du.user_id
        AND       snap_id BETWEEN &&begin_snap AND &&end_snap
        AND       ash.user_id > 0
        GROUP BY  instance_number, username, sql_id, sql_child_number
        ORDER BY  COUNT(*) DESC
        )
WHERE   rownum <= 10;

BREAK ON sql_id ON sql_child_number ON username SKIP 1
SELECT      username, sql_id, sql_child_number, sample_time, COUNT(*)
FROM        v$active_session_history ash, dba_users du
WHERE       ash.user_id = du.user_id
AND         ash.user_id > 0
AND         sql_id = '&sql_id'
AND         sql_child_number = '&sql_child_number'
GROUP BY    username, sample_time, sql_id, sql_child_number
ORDER BY    sample_time;