BREAK ON sql_id ON sql_plan_hash_value SKIP 1
COLUMN  event FORMAT a40
SELECT  *
FROM    (
        SELECT    session_id, NVL(event, 'ON CPU') event, session_state, username, sql_id, sql_child_number, sql_plan_hash_value, COUNT(*)
        FROM      v$active_session_history ash, dba_users du
        WHERE     ash.user_id=du.user_id
        AND       sample_time > SYSDATE - interval '&mins' minute
        AND       sql_id IS NOT NULL
        GROUP BY  session_id, event, session_state, username, sql_id, sql_child_number, sql_plan_hash_value
        ORDER BY  7 DESC
        )
WHERE   rownum < 11;

SELECT  *
FROM    (
        SELECT    session_id,
                  username,
                  sql_id,
                  sql_child_number,
                  SUM(DECODE(session_state,'ON CPU',1,0)) AS CPU,
                  SUM(DECODE(session_state,'WAITING',1,0)) - SUM(DECODE(session_state,'WAITING', DECODE(wait_class, 'User I/O',1,0),0)) AS WAIT,
                  SUM(DECODE(session_state,'WAITING', DECODE(wait_class, 'User I/O',1,0),0)) AS IO,
                  SUM(DECODE(session_state,'ON CPU',1,1)) AS TOTAL
        from      v$active_session_history ash, dba_users du
        where     ash.user_id=du.user_id
        AND       sample_time > SYSDATE - interval '&mins' minute
        AND       sql_id IS NOT NULL
        GROUP BY  session_id, username, sql_id, sql_child_number
        ORDER BY  SUM(DECODE(session_state,'ON CPU',1,1)) DESC
)
WHERE   ROWNUM <11;
