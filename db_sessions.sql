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
