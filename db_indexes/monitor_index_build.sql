COLUMN "Index Operation" FORMAT a60 TRUNC
COLUMN "ETA Mins" FORMAT 9999.99
COLUMN "Runtime Mins" FORMAT 9999.99
SELECT    sess.sid AS "Session ID",
          sql.sql_text AS "Index Operation",
          longops.totalwork, longops.sofar,
          longops.elapsed_seconds/60 AS "Runtime Mins",
          longops.time_remaining/60 AS "ETA Mins"
FROM      v$session sess, v$sql sql, v$session_longops longops
WHERE     sess.sid = longops.sid
AND       sess.sql_address = sql.address
AND       sess.sql_address = longops.sql_address
AND       sess.status  = 'ACTIVE'
AND       longops.totalwork > longops.sofar
AND       sess.sid NOT IN ( SELECT SYS_CONTEXT('USERENV', 'SID') sid FROM dual)
AND       UPPER(sql.sql_text) LIKE '%INDEX%'
ORDER BY  3,4;
