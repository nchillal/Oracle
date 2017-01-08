DECLARE
  v_address VARCHAR2(30);
  v_hash_value VARCHAR2(30);
  v_plan_hash_value VARCHAR2(30);
BEGIN
  SELECT 	address, hash_value, plan_hash_value INTO v_address, v_hash_value, v_plan_hash_value
  FROM 	  v$sqlarea
  WHERE 	sql_id='&sql_id';

  EXEC DBMS_SHARED_POOL.PURGE(''''||v_address||','||v_hash_value||'''', 'C');
END;
/
