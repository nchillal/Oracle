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

SELECT    apply_name, queue_name, rule_set_name, apply_user, apply_tag
FROM      dba_apply;
