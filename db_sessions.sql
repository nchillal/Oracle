SELECT    username, status, sql_id, count(*)
FROM      v$session
WHERE     username LIKE '%_USER'
GROUP BY  username, status, sql_id;

BREAK ON username

SELECT    username, status, COUNT(*)
FROM      v$session
GROUP BY  username, status
ORDER BY  1,3 desc;
