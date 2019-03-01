-- Check Apply latency
SELECT  (apply_time - applied_message_create_time) * 86400 "latency_in_seconds",
        (SYSDATE - apply_time) * 86400 "latency_in_seconds",
        TO_CHAR(applied_message_create_time, 'MON-DD-YYYY HH24:MI:SS') "event_creation",
        TO_CHAR(apply_time, 'MON-DD-YYYY HH24:MI:SS') "apply_time"
FROM    dba_apply_progress;


-- Group apply errors by Apply Process.
BREAK ON apply_name SKIP 1
SELECT      apply_name, REGEXP_SUBSTR(error_message, 'ORA-\d{5}') "Error Table", COUNT(*)
FROM        dba_apply_error
GROUP BY    apply_name, REGEXP_SUBSTR(error_message, 'ORA-\d{5}');

-- List all objects in apply error tables.
COLUMN "Table" FORMAT a50
COLUMN "Error" FORMAT a20
SELECT      apply_name, REGEXP_SUBSTR(error_message, 'ORA-\d{5}') "Error", REGEXP_SUBSTR(error_message, '\w+_OWNER.\w+') "Table"
FROM        dba_apply_error
ORDER BY    3;

-- List distinct objects having apply errors.
COLUMN "Table" FORMAT a50
COLUMN "Error" FORMAT a20
SELECT      distinct apply_name, REGEXP_SUBSTR(error_message, '\w+_OWNER.\w+') "Table"
FROM        dba_apply_error
ORDER BY    2;