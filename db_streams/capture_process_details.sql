-- Check when capture process table instantiation SCN.
SELECT  table_owner,
        table_name,
        scn,
        TO_CHAR(timestamp, 'HH24:MI:SS MM/DD/YY') TIMESTAMP
FROM    dba_capture_prepared_tables;

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
AND     action LIKE '%Capture%';

SELECT  c.capture_name,
        SUBSTR(s.program,INSTR(s.program,'(')+1,4) process_name,
        c.sid,
        c.serial#,
        c.state,
        c.total_messages_captured,
        c.total_messages_enqueued
FROM    v$streams_capture c, v$session s
WHERE   c.sid = s.sid AND
        c.serial# = s.serial#;

SELECT capture_name, checkpoint_retention_time FROM sys.dba_capture;
EXECUTE DBMS_CAPTURE_ADM.ALTER_CAPTURE(capture_name => '&capture_name' , checkpoint_retention_time => 7);
EXECUTE DBMS_CAPTURE_ADM.SET_PARAMETER ('&capture_name', '_checkpoint_frequency', '1000');
