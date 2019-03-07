-- Check Apply latency
SELECT  (apply_time - applied_message_create_time) * 86400 "latency_in_seconds",
        (SYSDATE - apply_time) * 86400 "latency_in_seconds",
        TO_CHAR(applied_message_create_time, 'MON-DD-YYYY HH24:MI:SS') "event_creation",
        TO_CHAR(apply_time, 'MON-DD-YYYY HH24:MI:SS') "apply_time"
FROM    dba_apply_progress;


-- Group apply errors by Apply Process.
BREAK ON apply_name SKIP 1
COLUMN "Error Table" FORMAT a30
SELECT      apply_name, REGEXP_SUBSTR(error_message, 'ORA-\d{5}') "ORA-ERROR", COUNT(*)
FROM        dba_apply_error
GROUP BY    apply_name, REGEXP_SUBSTR(error_message, 'ORA-\d{5}')
ORDER BY    apply_name;

-- List all objects in apply error tables.
BREAK ON apply_name SKIP 1
COLUMN "Table" FORMAT a50
COLUMN "Error" FORMAT a20
SELECT      apply_name, REGEXP_SUBSTR(error_message, 'ORA-\d{5}') "ORA-Error", REGEXP_SUBSTR(error_message, '\w+_OWNER.\w+') "Table", COUNT(*)
FROM        dba_apply_error
GROUP BY    apply_name, REGEXP_SUBSTR(error_message, 'ORA-\d{5}'), REGEXP_SUBSTR(error_message, '\w+_OWNER.\w+')
ORDER BY    4, 1 DESC;

-- List distinct objects having apply errors.
BREAK ON apply_name SKIP 1
COLUMN "Table" FORMAT a50
COLUMN "Error" FORMAT a20
SELECT      DISTINCT apply_name, REGEXP_SUBSTR(error_message, '\w+_OWNER.\w+') "Table"
FROM        dba_apply_error
ORDER BY    2;