BREAK ON streams_name ON table_owner skip 1
SELECT      streams_name, table_owner, table_name, streams_type, COUNT(*) CNT
FROM        dba_streams_table_rules
GROUP BY    streams_name, streams_type, table_name, table_owner
ORDER BY    table_owner, table_name;