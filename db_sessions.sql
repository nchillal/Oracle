SELECT    username, status, sql_id, count(*) 
FROM      v$session 
WHERE     username LIKE '%_USER' 
GROUP BY  username, status, sql_id;
