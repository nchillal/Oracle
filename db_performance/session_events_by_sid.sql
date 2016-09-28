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
AND       s.sid = &1
ORDER BY  se.time_waited DESC;
