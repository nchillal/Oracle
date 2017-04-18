BREAK ON hash_value SKIP 1
SET PAGESIZE 1000 LINESIZE 160
COLUMN sql_fulltext FORMAT a140

SELECT 		inst_id, DBMS_LOB.SUBSTR(sql_fulltext, 5000, 1) sql_fulltext
FROM 			gv$sqlarea
WHERE			sql_id = '&sql_id'
/

SELECT		hash_value,
					sql_text
FROM 			v$sqltext
WHERE 		hash_value = (SELECT sql_hash_value FROM v$session WHERE sid = &sid)
ORDER BY 	piece
/

SELECT 		sql_id, sql_child_number
FROM 			v$session
WHERE			sid=&sid;
