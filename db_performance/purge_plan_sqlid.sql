SELECT 	address, hash_value, plan_hash_value
FROM 	  v$sqlarea
WHERE 	sql_id='&sql_id';

exec DBMS_SHARED_POOL.PURGE('&address, &hash_value', 'C');
