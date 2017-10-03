SET linesize 230 pagesize 2000

BREAK ON inst_id

COLUMN event FORMAT a50
COLUMN machine FORMAT a40

SELECT  inst_id,
        sid,
        username,
        event,
        seconds_in_wait,
        status,
        machine,
        program
FROM    gv$session
WHERE   wait_time=0
AND     type <> 'BACKGROUND'
AND     event NOT IN  (
                      'dispatcher timer',
                      'pipe get',
                      'pmon timer',
                      'PX Idle Wait',
                      'PX Deq Credit: need buffer',
                      'rdbms ipc message',
                      'shared server idle wait',
                      'smon timer',
                      'SQL*Net message from client'
                      );

SET linesize 230 pagesize 2000
BREAK ON REPORT
COMPUTE SUM OF total_wait_time ON REPORT

SELECT    NVL(a.event, 'ON CPU') AS event,
          COUNT(*) AS total_wait_time
FROM      v$active_session_history a
WHERE     sample_time > TO_DATE('&start_time','MMDDYYHH24MI')
AND       sample_time < TO_DATE('&end_time','MMDDYYHH24MI')
GROUP BY  event
ORDER BY  total_wait_time DESC;


          SELECT    NVL(a.event, 'ON CPU') AS event,
                    COUNT(*) AS total_wait_time
          FROM      dba_hist_active_sess_history a
          WHERE     sample_time > TO_DATE('&start_datetime','MMDDYYHH24MI')
          AND       sample_time < TO_DATE('&end_datetime','MMDDYYHH24MI')
          GROUP BY  event
          ORDER BY  total_wait_time DESC;
