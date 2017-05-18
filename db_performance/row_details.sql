-- Details of the object / block / row that is causing wait.
SELECT  row_wait_obj#, row_wait_file#, row_wait_block#, row_wait_row#
FROM    v$session
WHERE   event='&event_name'
AND     state='WAITING'
;

-- Get object_name from object_id
SELECT  object_name
FROM    dba_objects
WHERE   object_id='&object_id';

-- Detail of row based on object, file, block and row number.
SELECT  *
FROM    &table_name
WHERE   rowid = DBMS_ROWID.rowid_create(&rowid_type, &row_wait_obj, &row_wait_file, &row_wait_block, &row_wait_row)
;
