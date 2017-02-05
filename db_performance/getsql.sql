break on hash_value
set pagesize 1000
set long 2000000

SELECT 		sql_fulltext
FROM 			v$sqlarea
WHERE			sql_id = '&sql_id'
/

SELECT		hash_value,
					sql_text
FROM 			v$sqltext
WHERE 		hash_value = (SELECT sql_hash_value FROM v$session WHERE sid = &sid)
ORDER BY 	piece
/
