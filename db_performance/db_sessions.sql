-- This query returns username and their status count
BREAK ON inst_id SKIP 1
SELECT    *
FROM      (
          SELECT  inst_id, username, status
          FROM    gv$session
          WHERE   type <> 'BACKGROUND'
          )
PIVOT     (
          COUNT(status)
          FOR (status) IN ('ACTIVE' as ACTIVE, 'INACTIVE' as INACTIVE)
          )
ORDER BY  inst_id, username
;

-- This query returns machine, username and their status count
BREAK ON inst_id SKIP 1
SELECT    *
FROM     (
	       SELECT  inst_id, machine, username, status
	       FROM    gv$session
	       WHERE   type <> 'BACKGROUND'
	       )
PIVOT    (
	       COUNT(status)
	       FOR (status) IN ('ACTIVE' as ACTIVE, 'INACTIVE' as INACTIVE)
	       )
ORDER BY  inst_id, machine
;

-- This query returns username, logon_time and their count
BREAK ON inst_id SKIP 1
SELECT    *
FROM      (
          SELECT  inst_id, username, status, TO_CHAR(LOGON_TIME, 'DD-MON-YYYY HH24:MI') LOGON_TIME
          FROM    v$session
          WHERE   type <> 'BACKGROUND'
          )
PIVOT     (
          COUNT(status)
          FOR (status) IN ('ACTIVE' as ACTIVE, 'INACTIVE' as INACTIVE)
          )
ORDER BY  inst_id, username
;

-- This query returns username, sql they are executing and their status count
BREAK ON inst_id SKIP 1
SELECT    *
FROM      (
          SELECT  inst_id, username, event, sql_id, status
          FROM    gv$session
          WHERE   type <> 'BACKGROUND'
          )
PIVOT     (
          COUNT(status)
          FOR (status) IN ('ACTIVE' as ACTIVE, 'INACTIVE' as INACTIVE)
          )
ORDER BY  inst_id, username, sql_id, event
;
