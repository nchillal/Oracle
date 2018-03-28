--Corresponding Equivalent AWR table is DBA_HIST_SQLBIND.
COLUMN sql_text FORMAT a120
COLUMN bind_name FORMAT a10
COLUMN bind_value FORMAT a25
SELECT    t.sql_text sql_text,
          b.name bind_name,
          b.value_string bind_value
FROM      v$sql t
JOIN      v$sql_bind_capture b using (sql_id)
WHERE     b.value_string is not null
AND       sql_id = '&sql_id';

BREAK ON snap_id SKIP 1
SELECT    snap_id, name bind_name, value_string bind_value
FROM      dba_hist_sqlbind
WHERE     sql_id = '&sql_id'
AND       snap_id BETWEEN '&begin_snap' AND '&end_snap'
ORDER BY  snap_id, bind_name;
