SET LINES 200 PAGES 1000

COLUMN xid FORMAT a16
COLUMN username FORMAT a18
COLUMN schemaname FORMAT a18
COLUMN osuser FORMAT a12
COLUMN spid FORMAT a8
SELECT      t.start_time,
            t.xidusn||'.'||t.xidslot||'.'||t.xidsqn xid,
            s.status,
            s.sid,
            s.serial#,
            p.spid spid,
            s.username,
            s.status,
            DECODE(s.sql_id, NULL,s.prev_sql_id) sqlid,
            DECODE(s.sql_child_number, NULL,s.prev_child_number) child,
            s.schemaname,
            t.used_urec,
            t.used_ublk
FROM        v$transaction t, v$session s, v$process p
WHERE       s.saddr = t.ses_addr
AND         s.paddr = p.addr
ORDER BY    t.start_time;