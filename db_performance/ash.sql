
COLUMN  event FORMAT a40
SELECT  *
FROM    (
        SELECT    session_id, event, session_state, username, sql_id, count(*)
        FROM      v$active_session_history ash, dba_users du
        WHERE     ash.user_id=du.user_id
        AND       sample_time > SYSDATE - interval '&mins' minute
        GROUP BY  session_id, event, session_state, username, sql_id
        ORDER BY  6 DESC
        )
WHERE   rownum < 11;

SELECT  *
FROM    (
        SELECT    session_id,
                  username,
                  sql_id,
                  SUM(DECODE(session_state,'ON CPU',1,0)) as CPU,
                  SUM(DECODE(session_state,'WAITING',1,0)) - SUM(DECODE(session_state,'WAITING', DECODE(wait_class, 'User I/O',1,0),0)) as WAIT,
                  SUM(DECODE(session_state,'WAITING', DECODE(wait_class, 'User I/O',1,0),0)) as IO,
                  SUM(DECODE(session_state,'ON CPU',1,1)) as TOTAL
        from      v$active_session_history ash, dba_users du
        where     ash.user_id=du.user_id
        AND       sample_time > SYSDATE - interval '&mins' minute
        AND       sql_id IS NOT NULL
        GROUP BY  session_id, username, sql_id
        ORDER BY  SUM(DECODE(session_state,'ON CPU',1,1)) DESC
)
WHERE   ROWNUM <11;
