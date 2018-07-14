SELECT    INST_ID,
          DECODE(request,0,'Holder: ','Waiter: ') || sid sess, id1, id2, lmode, request, type
FROM      GV$LOCK
WHERE     (id1, id2, type) IN (SELECT id1, id2, type FROM GV$LOCK WHERE request > 0)
ORDER BY  id1, request;

SELECT    blocking_session, sid, serial#, sql_id, p1text, p1, p2text, p2, p3text, p3, wait_class, seconds_in_wait
FROM      v$session
WHERE     blocking_session IS NOT NULL
ORDER BY  blocking_session;

SELECT    inst_id, sid||','||serial# "SID_SERIAL#", sql_id, blocking_session, blocking_session_status, status, event
FROM      gv$session
WHERE     event ='&event_name'
AND       blocking_session IS NOT NULL;
