SET PAGESIZE 1000 LINESIZE 260

BREAK ON username
COLUMN username FORMAT a20
COLUMN event FORMAT a45
COLUMN module FORMAT a50
COLUMN client_info FORMAT a50
COLUMN "sid, serial#" FORMAT a15
SELECT 		s.sid||','||s.serial# "sid, serial#", s.username, s.module, s.client_info, s.event, p.sql_id, s.sql_child_number, s.sql_hash_value, p.plan_hash_value
FROM 			v$session s, v$sqlarea p
WHERE			s.sql_hash_value = p.hash_value
AND       s.sql_address = p.address
AND 			status='ACTIVE';

BREAK ON username
COLUMN username FORMAT a20
COLUMN event FORMAT a45
COLUMN "sid, serial#" FORMAT a15
SELECT 		s.sid||','||s.serial# "sid, serial#", s.status, s.username, s.sql_id, s.sql_child_number, s.sql_hash_value, p.plan_hash_value
FROM 			v$session s, v$sql_plan p
WHERE			s.sql_id = p.sql_id
AND 			s.sql_child_number = p.child_number
AND 			s.sql_id='&sql_id';

COLUMN sql_fulltext FORMAT a140
SELECT 		inst_id, DBMS_LOB.SUBSTR(sql_fulltext, 5000, 1) sql_fulltext
FROM 			gv$sqlarea
WHERE			sql_id = '&sql_id'
/
