BREAK ON capture_name ON queue_name ON queue_table ON propagation_name ON schema_name SKIP 1

SELECT    capture_name, queue_name, queue_table, propagation_name, schema_name, object_name
FROM      dba_capture dc, dba_queues du, dba_propagation dp, dba_streams_rules dsr
WHERE     dc.queue_name = du.name
AND       dc.queue_name = dp.source_queue_name
AND       dc.capture_name = dsr.streams_name;
