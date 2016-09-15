-- This query returns username and their status count
SELECT    *
FROM      (
          SELECT  username, status
          FROM    v$session
          WHERE   username LIKE '%_USER'
          )
PIVOT     (
          COUNT(status)
          FOR (status) IN ('ACTIVE' as ACTIVE, 'INACTIVE' as INACTIVE)
          )
ORDER BY  username
;

-- This query returns machine, username and their status count
SELECT    *
FROM     (
	       SELECT  machine, username, status
	       FROM    v$session
	       WHERE   username LIKE '%_USER'
	       )
PIVOT    (
	       COUNT(status)
	       FOR (status) IN ('ACTIVE' as ACTIVE, 'INACTIVE' as INACTIVE)
	       )
ORDER BY  machine
;

-- This query returns username, sql they are executing and their status count
SELECT    *
FROM      (
          SELECT  username, sql_id, status
          FROM    v$session
          WHERE   username like '%_USER'
          )
PIVOT     (
          COUNT(status)
          FOR (status) IN ('ACTIVE' as ACTIVE, 'INACTIVE' as INACTIVE)
          )
ORDER BY  sql_id, username
;

-- This query returns username, logon_time and their count
SELECT    *
FROM      (
          SELECT  username, status, TO_CHAR(LOGON_TIME, 'DD-MON-YYYY HH24:MI') LOGON_TIME
          FROM    v$session
          WHERE   username LIKE '%_USER'
          )
PIVOT     (
          COUNT(status)
          FOR (status) IN ('ACTIVE' as ACTIVE, 'INACTIVE' as INACTIVE)
          )
ORDER BY  username
;
