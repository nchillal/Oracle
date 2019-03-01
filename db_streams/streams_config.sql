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
AND       object_name = '&table_name'
ORDER BY  schema_name;

SELECT    capture_name, dc.rule_set_name capture_rule_set, queue_name, queue_table, propagation_name, dp.rule_set_name propgation_rule_set, destination_dblink, schema_name, object_name
FROM      dba_capture dc, dba_queues du, dba_propagation dp, dba_streams_rules dsr
WHERE     dc.queue_name = du.name
AND       dc.queue_name = dp.source_queue_name
AND       dc.capture_name = dsr.streams_name
AND       dc.capture_name = '&capture_name'
ORDER BY  schema_name;

SELECT owner, name, queue_table FROM dba_queues WHERE owner = 'STRMADMIN' AND queue_type = 'NORMAL_QUEUE' ORDER BY queue_table;
SELECT capture_name, queue_name, status FROM dba_capture WHERE queue_owner='STRMADMIN';
SELECT propagation_name, source_queue_name, destination_queue_name, destination_dblink, status FROM dba_propagation WHERE source_queue_owner = 'STRMADMIN';
SELECT apply_name, queue_name, status FROM dba_apply WHERE queue_owner='STRMADMIN';

SELECT queue_name, subscriber_name FROM v$buffered_subscribers WHERE queue_schema='STRMADMIN';
SELECT queue_name, sender_name, sender_address FROM v$buffered_publishers WHERE queue_schema = 'STRMADMIN';
SELECT queue_name, dst_queue_name, dblink, propagation_name, state FROM v$propagation_sender WHERE queue_schema = 'STRMADMIN';
SELECT sid, serial#, apply_name, state FROM V$STREAMS_APPLY_READER;

BREAK ON apply_name SKIP 1
SELECT sid, serial#, apply_name, state FROM V$STREAMS_APPLY_SERVER ORDER BY apply_name;


COLUMN parameter FORMAT a30
COLUMN value FORMAT a50
BREAK ON parameter SKIP 1
SELECT distinct parameter, value FROM dba_apply_parameters ORDER BY parameter;
SELECT distinct parameter, value FROM dba_capture_parameters ORDER BY parameter;

-- Set APPLY tag value
EXEC DBMS_STREAMS.SET_TAG('17');
-- fix the data on the apply site
EXEC DBMS_STREAMS.SET_TAG(null);

-- Check if is set or not.
SELECT DBMS_STREAMS.GET_TAG FROM DUAL;

-- Re-executing the error
exec DBMS_APPLY_ADM.EXECUTE_ERROR('&local_transaction_id');
exec DBMS_APPLY_ADM.EXECUTE_ALL_ERRORS();
exec DBMS_APPLY_ADM.EXECUTE_ALL_ERRORS(apply_name => '&apply_name');

-- Deleting error from error queue
exec DBMS_APPLY_ADM.DELETE_ERROR('&local_transaction_id');
exec DBMS_APPLY_ADM.DELETE_ALL_ERRORS();
EXEC DBMS_APPLY_ADM.DELETE_ALL_ERRORS(apply_name => '&apply_name');

SELECT owner, job_name, state FROM dba_scheduler_jobs WHERE owner LIKE '%OWNER';

-- Check total messages captured and applied in 10 seconds interval.
SET SERVEROUTPUT ON
DECLARE
    capMsgCount1 number;
    capMsgCount2 number;
    appMsgCount1 number;
    appMsgCount2 number;
    sleepSeconds number := 10;
    oracleSid varchar2(10);
BEGIN
    SELECT instance_name INTO oracleSid FROM v$instance;
    SELECT SUM(TOTAL_MESSAGES_ENQUEUED) INTO capMsgCount1 FROM v$streams_capture;
    SELECT SUM(TOTAL_APPLIED) INTO appMsgCount1 FROM v$streams_apply_coordinator;

    DBMS_LOCK.SLEEP(sleepSeconds);

    SELECT SUM(TOTAL_MESSAGES_ENQUEUED) INTO capMsgCount2 FROM v$streams_capture;
    SELECT SUM(TOTAL_APPLIED) INTO appMsgCount2 FROM v$streams_apply_coordinator;

    DBMS_OUTPUT.PUT_LINE('For ' || oracleSid || ', activity for the last ' || sleepSeconds || ' seconds:');
    DBMS_OUTPUT.PUT_LINE(RPAD('Messages captured', 20, ' ') || ' : ' || (capMsgCount2 - capMsgCount1) );
    DBMS_OUTPUT.PUT_LINE(RPAD('Messages applied', 20, ' ') || ' : ' || (appMsgCount2 - appMsgCount1));
END;
/