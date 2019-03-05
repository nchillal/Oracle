SELECT  first_load_time, address, hash_value, plan_hash_value
FROM    v$sqlarea
WHERE   sql_id='&sql_id';

SELECT  first_load_time, last_load_time, address, hash_value, plan_hash_value
FROM    v$sql
WHERE   sql_id='&sql_id';

EXEC DBMS_SHARED_POOL.PURGE('&address,&hash_value', 'C');
