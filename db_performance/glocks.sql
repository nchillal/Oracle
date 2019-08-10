
SELECT    INST_ID,
          DECODE(request,0,'Holder: ','Waiter: ') || sid sess, id1, id2, lmode, request, type
FROM      GV$LOCK
WHERE     (id1, id2, type) IN (SELECT id1, id2, type FROM GV$LOCK WHERE request > 0)
ORDER BY  id1, request;

COLUMN sid_serial# FORMAT a15
COLUMN p1text FORMAT a30
COLUMN p2text FORMAT a30
COLUMN p3text FORMAT a30

SELECT    blocking_session, sid||','||serial# "SID_SERIAL#", username, sql_id, p1text, p1, p2text, p2, p3text, p3, wait_class, seconds_in_wait
FROM      v$session
WHERE     blocking_session IS NOT NULL
ORDER BY  blocking_session;

SELECT    inst_id, sid||','||serial# "SID_SERIAL#", username, sql_id, blocking_session, blocking_session_status, status, event
FROM      gv$session
WHERE     event ='&event_name'
AND       blocking_session IS NOT NULL;

SELECT    session_id||','||session_serial# "SID_SERIAL#", du.username, sql_id, blocking_session, blocking_session_status, session_state, event
FROM      v$active_session_history ash, dba_users du
WHERE     blocking_session IS NOT NULL
AND       ash.user_id = du.user_id
AND       sample_time > SYSDATE - INTERVAL '&minutes' MINUTE;

SELECT    session_id||','||session_serial# "SID_SERIAL#", sql_id, blocking_session, blocking_session_status, session_state, event
FROM      dba_hist_active_sess_history
WHERE     blocking_session IS NOT NULL
AND       snap_id BETWEEN &&begin_snap AND &&end_snap;
