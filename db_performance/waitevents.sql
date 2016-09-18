SET linesize 230 pagesize 200

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
                      'SQL*Net message FROM client'
                      );
