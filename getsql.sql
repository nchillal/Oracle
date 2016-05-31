break on hash_value
set pagesize 1000
set long 2000000
select hash_value, sql_text
from v$sqltext
where hash_value = 
	(select sql_hash_value from
		v$session where sid = &sid)
order by piece
/
