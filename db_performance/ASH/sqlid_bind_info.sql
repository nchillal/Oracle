-- Get bind values FROM memory
COLUMN sql_text FORMAT a120
COLUMN bind_name FORMAT a10
COLUMN bind_value FORMAT a25

SELECT    name bind_name,
          value_string bind_value
FROM      v$sql_bind_capture
WHERE     value_string is not null
AND       sql_id = '&sql_id';

-- Get bind values from AWR
BREAK ON snap_id SKIP 1
SELECT    snap_id, name bind_name, value_string bind_value
FROM      dba_hist_sqlbind
WHERE     sql_id = '&sql_id'
AND       snap_id BETWEEN '&begin_snap' AND '&end_snap'
ORDER BY  snap_id, bind_name;
