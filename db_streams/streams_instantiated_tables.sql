-- Capture objects instantiated details.
BREAK ON table_owner SKIP 1
COLUMN table_owner HEADING 'Table Owner'  FORMAT A30
COLUMN table_name  HEADING 'Table Name'   FORMAT A40
COLUMN scn         HEADING 'Instantiation SCN'
COLUMN timestamp   HEADING 'Time Ready for|Instantiation'
SELECT      table_owner, table_name, scn, TO_CHAR(timestamp, 'HH24:MI:SS MM/DD/YY') timestamp
FROM        dba_capture_prepared_tables
ORDER BY    1, 3;

-- Displaying the Redo Log Files that Are Required by Each Capture Process
BREAK ON consumer_name SKIP 1
COLUMN consumer_name HEADING 'Capture|Process|Name' FORMAT A30
COLUMN source_database HEADING 'Source|Database' FORMAT A10
COLUMN sequence# HEADING 'Sequence|Number' FORMAT 99999999
COLUMN name HEADING 'Required|Archived Redo Log|File Name' FORMAT A100

SELECT  r.consumer_name, r.source_database, r.sequence#, r.name
FROM    dba_registered_archived_log r, dba_capture c
WHERE   r.consumer_name =  c.capture_name
AND     r.next_scn >= c.required_checkpoint_scn;

-- Apply objects instantiated details.
BREAK ON source_object_owner SKIP 1
SELECT      source_object_owner, source_object_name, instantiation_scn, ignore_scn
FROM        dba_apply_instantiated_objects
ORDER BY    source_object_owner;

-- Remove invalid entries from DBA_APPLY_INSTANTIATED_OBJECTS
EXEC DBMS_APPLY_ADM.SET_TABLE_INSTANTIATION_SCN('&schema.table', instantiation_scn => NULL);