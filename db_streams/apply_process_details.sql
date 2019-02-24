-- Check Apply latency
SELECT  (apply_time - applied_message_create_time) * 86400 "latency_in_seconds",
        (SYSDATE - apply_time) * 86400 "latency_in_seconds",
        TO_CHAR(applied_message_create_time, 'MON-DD-YYYY HH24:MI:SS') "event_creation",
        TO_CHAR(apply_time, 'MON-DD-YYYY HH24:MI:SS') "apply_time"
FROM    dba_apply_progress;
