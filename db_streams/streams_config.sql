COLUMN destination_dblink FORMAT a20
COLUMN capture_rule_set FORMAT a20
COLUMN capture_name FORMAT a20
COLUMN apply_tag FORMAT a10

BREAK ON capture_name ON queue_name ON queue_table ON propagation_name ON destination_dblink ON schema_name SKIP 1

SELECT    capture_name, dc.rule_set_name capture_rule_set, queue_name, queue_table, propagation_name, dp.rule_set_name propgation_rule_set, destination_dblink, schema_name, object_name
FROM      dba_capture dc, dba_queues du, dba_propagation dp, dba_streams_rules dsr
WHERE     dc.queue_name = du.name
AND       dc.queue_name = dp.source_queue_name
AND       dc.capture_name = dsr.streams_name
ORDER BY  schema_name;

SELECT owner, name, queue_table FROM dba_queues WHERE owner = 'STRMADMIN' AND queue_type = 'NORMAL_QUEUE' ORDER BY queue_table;
SELECT capture_name, queue_name, status FROM dba_capture WHERE queue_owner='STRMADMIN';
SELECT propagation_name, source_queue_name, destination_queue_name, destination_dblink, status FROM dba_propagation WHERE source_queue_owner = 'STRMADMIN';
SELECT apply_name, queue_name, status FROM dba_apply WHERE queue_owner='STRMADMIN';
SELECT queue_name, subscriber_name FROM v$buffered_subscribers WHERE queue_schema='STRMADMIN';
SELECT queue_name, sender_name, sender_address FROM v$buffered_publishers WHERE queue_schema = 'STRMADMIN';
SELECT queue_name, dst_queue_name, dblink, propagation_name, state FROM v$propagation_sender WHERE queue_schema = 'STRMADMIN';

SELECT streams_name, table_owner, table_name, streams_type, COUNT(*) CNT
FROM dba_streams_table_rules
GROUP BY streams_name, streams_type, table_name, table_owner
ORDER BY table_owner, table_name;

BREAK ON source_object_owner SKIP 1
SELECT source_object_owner, source_object_name, instantiation_scn, ignore_scn FROM dba_apply_instantiated_objects ORDER BY source_object_owner;

BREAK ON object_owner SKIP 1
SELECT object_owner, object_name, COUNT(*) FROM dba_apply_conflict_columns GROUP BY object_owner, object_name ORDER BY 1;

-- Capture Lag
SELECT  capture_name, ((SYSDATE - capture_message_create_time)*86400) LATENCY_SECONDS
FROM    v$streams_capture
WHERE EXISTS (SELECT 1 FROM v$database WHERE database_role='PRIMARY');

-- Apply Lag
SELECT  apply_name, NVL( (hwm_time-hwm_message_create_time)*86400, 0) LAG_SEC
FROM    v$streams_apply_coordinator
WHERE EXISTS (SELECT 1 FROM v$database WHERE database_role='PRIMARY');
