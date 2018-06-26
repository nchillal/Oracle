set linesize 260
set feedback on
set pagesize 1000
COLUMN sid FORMAT 99999
COLUMN event FORMAT a50
COLUMN module FORMAT a60
COLUMN username FORMAT a12
COLUMN seconds_in_wait FORMAT 999999
COLUMN p1 FORMAT 999999999999999

SELECT    b.inst_id,
          b.sid,
          a.serial#,
          b.event,
          SUBSTR(a.action,1,1)||'-'||a.module module ,
          a.username ,
          b.p1,
          b.p2,
          b.p3,
          b.seconds_in_wait
FROM      gv$session_wait b, gv$session a
WHERE     b.event NOT IN  (
                          'slave wait',
                          'SQL*Net message FROM client',
                          'rdbms ipc message',
                          'pmon timer',
                          'smon timer',
                          'pipe get',
                          'queue messages',
                          'wakeup time manager',
                          'jobq slave wait',
                          'gcs remote message',
                          'DIAG idle wait',
                          'Streams AQ: waiting for time management or cleanup tasks',
                          'Streams AQ: waiting for messages in the queue',
                          'ges remote message',
                          'Streams AQ: qmn slave idle wait',
                          'Streams AQ: qmn coordinator idle wait'
                          )
AND       a.sid  = b.sid
AND       a.inst_id = b.inst_id
AND       a.status = 'ACTIVE'
ORDER BY  1, last_call_et;
