SELECT  *
FROM    (
        SELECT    username, sql_id, sql_child_number, COUNT(*)
        FROM      v$active_session_history ash, dba_users du
        WHERE     ash.user_id = du.user_id
        AND       sample_time > TO_DATE('&start_datetime','DDMMRRHH24MI')
        AND       sample_time < TO_DATE('&end_datetime','DDMMRRHH24MI')
        AND       ash.user_id > 0
        GROUP BY  username, sql_id, sql_child_number
        ORDER BY  COUNT(*) DESC
        )
WHERE   rownum <= 10;

SELECT  *
FROM    (
        SELECT    username, sql_id,sql_child_number, COUNT(*)
        FROM      dba_hist_active_sess_history ash, dba_users du
        WHERE     ash.user_id = du.user_id
        AND       sample_time > TO_DATE('&start_datetime','DDMMRRHH24MI')
        AND       sample_time < TO_DATE('&end_datetime','DDMMRRHH24MI')
        AND       ash.user_id > 0
        GROUP BY  username, sql_id, sql_child_number
        ORDER BY  COUNT(*)
        )
WHERE   rownum <= 10;
