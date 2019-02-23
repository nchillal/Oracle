-- Capture Lag
SELECT  capture_name, ((SYSDATE - capture_message_create_time) * 86400) LATENCY_SECONDS
FROM    v$streams_capture
WHERE EXISTS (SELECT 1 FROM v$database WHERE database_role='PRIMARY')
UNION
SELECT  apply_name, NVL( (hwm_time - hwm_message_create_time) * 86400, 0) LAG_SEC
FROM    v$streams_apply_coordinator
WHERE EXISTS (SELECT 1 FROM v$database WHERE database_role='PRIMARY');