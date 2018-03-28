--Corresponding Equivalent AWR table is DBA_HIST_SQLBIND.
SELECT    sql_id,
          t.sql_text sql_text,
          b.name bind_name,
          b.value_string bind_value
FROM      v$sql t
JOIN      v$sql_bind_capture b using (sql_id)
WHERE     b.value_string is not null
AND       sql_id='&sqlid';
