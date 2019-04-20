-- Get capture process session details.
COLUMN action heading 'Capture Process Component' FORMAT A30
COLUMN sid heading 'Session ID' FORMAT 999999
COLUMN serial# heading 'Session|Serial|Number' FORMAT 99999999
COLUMN process heading 'Operating System|Process Number' FORMAT A30
COLUMN process_name heading 'Process|Name' FORMAT A20
COLUMN total_messages_captured HEADING 'Redo|Entries|Evaluated|In Detail' FORMAT 999999999999
COLUMN total_messages_enqueued HEADING 'Total|LCRs|Enqueued' FORMAT 999999999999
COLUMN state HEADING 'State' FORMAT A30

SELECT  /*+PARAM('_module_action_old_length',0)*/ action,
        sid,
        serial#,
        sql_id,
        process,
        event,
        SUBSTR(program,INSTR(program,'(')+1,4) process_name
FROM    v$session
WHERE   module ='Streams'
AND     action LIKE '%Apply%';

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
COLUMN "ORA-Error" FORMAT a20
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