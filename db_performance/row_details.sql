-- Details of the object, datafile, block and row that is causing wait.
SELECT  row_wait_obj#, row_wait_file#, row_wait_block#, row_wait_row#
FROM    v$session
WHERE   event='&event_name'
AND     state='WAITING'
;

-- Details of the object, datafile, block and row that is causing wait from AWR.
SELECT    inst_id, current_obj#, current_file#, current_block#, current_row#
FROM      gv$active_session_history
WHERE     event='&event_name'
AND       sample_time > SYSDATE - INTERVAL '&mins' MINUTE
ORDER BY  inst_id;

SELECT    current_obj#, current_file#, current_block#, current_row#, COUNT(*) CNT
FROM      dba_hist_active_sess_history
WHERE     event='&&event_name'
AND       snap_id BETWEEN &&begin_snap AND &&end_snap
HAVING    COUNT(*) > 1
GROUP BY  current_obj#, current_file#, current_block#, current_row#
ORDER BY  1, 2, 3, 4;

-- Get object_name from object_id
SELECT  object_name
FROM    dba_objects
WHERE   object_id='&object_id';

-- Detail of row based on object, file, block and row number.
SELECT  *
FROM    &table_name
WHERE   rowid = DBMS_ROWID.rowid_create(&rowid_type, &row_wait_obj, &row_wait_file, &row_wait_block, &row_wait_row)
;
