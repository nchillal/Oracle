-- This query returns username and their status count
BREAK ON inst_id SKIP 1
COMPUTE SUM LABEL 'TOTAL' OF 'ACTIVE' ON inst_id
COMPUTE SUM LABEL 'TOTAL' OF 'INACTIVE' ON inst_id
SELECT    *
FROM      (
          SELECT  inst_id, username, status
          FROM    gv$session
          WHERE   type <> 'BACKGROUND'
          )
PIVOT     (
          COUNT(status)
          FOR (status) IN ('ACTIVE' AS ACTIVE, 'INACTIVE' AS INACTIVE)
          )
ORDER BY  inst_id, username
;

-- This query returns machine, username and their status count
BREAK ON inst_id SKIP 1
COMPUTE SUM LABEL 'TOTAL' OF 'ACTIVE' ON inst_id
COMPUTE SUM LABEL 'TOTAL' OF 'INACTIVE' ON inst_id
SELECT    *
FROM     (
	       SELECT  inst_id, machine, username, status
	       FROM    gv$session
	       WHERE   type <> 'BACKGROUND'
	       )
PIVOT    (
	       COUNT(status)
	       FOR (status) IN ('ACTIVE' AS ACTIVE, 'INACTIVE' AS INACTIVE)
	       )
ORDER BY  inst_id, machine
;

-- This query returns username, logon_time and their count
BREAK ON inst_id SKIP 1
COMPUTE SUM LABEL 'TOTAL' OF 'ACTIVE' ON inst_id
COMPUTE SUM LABEL 'TOTAL' OF 'INACTIVE' ON inst_id
SELECT    *
FROM      (
          SELECT  inst_id, username, status, TO_CHAR(LOGON_TIME, 'DD-MON-YYYY HH24:MI:SS') LOGON_TIME
          FROM    gv$session
          WHERE   type <> 'BACKGROUND'
          AND     TO_CHAR(LOGON_TIME, 'DD-MON-YYYY HH24:MI:SS') > SYSDATE - &min/1440
          )
PIVOT     (
          COUNT(status)
          FOR (status) IN ('ACTIVE' AS ACTIVE, 'INACTIVE' AS INACTIVE)
          )
ORDER BY  inst_id, username
;

-- This query returns username, sql they are executing and their status count
BREAK ON inst_id SKIP 1
COMPUTE SUM LABEL 'TOTAL' OF 'ACTIVE' ON inst_id
COMPUTE SUM LABEL 'TOTAL' OF 'INACTIVE' ON inst_id
SELECT    *
FROM      (
          SELECT  inst_id, username, event, sql_id, sql_child_number, status
          FROM    gv$session
          WHERE   type <> 'BACKGROUND'
          AND     last_call_et > 0
          )
PIVOT     (
          COUNT(status)
          FOR (status) IN ('ACTIVE' AS ACTIVE, 'INACTIVE' AS INACTIVE)
          )
ORDER BY  inst_id, username, sql_id, sql_child_number, event
;

-- This query to display plan hash value being used for a SQL_ID.
SELECT  vs.inst_id, username, client_info, event, vs.sql_id, vs.sql_child_number, plan_hash_value, status
FROM    gv$session vs, gv$sql_plan vp
WHERE   type <> 'BACKGROUND'
AND     vs.status='ACTIVE'
AND     vs.sql_id = vp.sql_id
AND     last_call_et > 0
AND     vs.sql_id = '&sql_id';
