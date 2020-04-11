SET LINESIZE 200
SET PAGESIZE 1000
SET VERIFY OFF

COLUMN username FORMAT A20
COLUMN event FORMAT A40

SELECT    NVL(s.username, '(oracle)') AS username,
          s.sid,
          s.serial#,
          se.event,
          se.total_waits,
          se.total_timeouts,
          se.time_waited,
          se.average_wait,
          se.max_wait,
          se.time_waited_micro
FROM      v$session_event se,
          v$session s
WHERE     s.sid = se.sid
AND       s.sid = &sid
ORDER BY  se.time_waited DESC;

SELECT    sql_id, sql_child_number, event, percentage
FROM
(
  SELECT    sql_id, sql_child_number, event, ROUND(ratio_to_report(COUNT(*)) over(), 2)*100 as PERCENTAGE
  FROM      v$active_session_history
  WHERE     sample_time > SYSDATE - INTERVAL '&minutes' MINUTE
  AND       user_id > 0
  AND       session_id = &sid
  GROUP BY  sql_id, sql_child_number, event
  ORDER BY  1, 2, 4 DESC
)
WHERE percentage > 0;

SELECT    sql_id, SESSION_STATE, percentage
FROM
(
  SELECT    sql_id, SESSION_STATE, ROUND(ratio_to_report(COUNT(*)) over(), 2)*100 as PERCENTAGE
  FROM      v$active_session_history
  WHERE     sample_time > SYSDATE - INTERVAL '&hours' HOUR
  AND       user_id > 0
  AND       session_id = &sid
  GROUP BY  sql_id, SESSION_STATE
  ORDER BY  1, 2, 3 DESC
)
WHERE percentage > 0;

SELECT    sql_id, percentage
FROM
(
  SELECT    sql_id, ROUND(ratio_to_report(COUNT(*)) over(), 2)*100 as PERCENTAGE
  FROM      dba_hist_active_sess_history
  WHERE     snap_id BETWEEN &&begin_snap AND &&end_snap
  AND       user_id > 0
  AND       event = &sid
  GROUP BY  sql_id
  ORDER BY  2 DESC
)
WHERE percentage > 0;
