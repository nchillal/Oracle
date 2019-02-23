-- Create streams heartbeat or ping table
DECLARE
  dbname VARCHAR2(10);
  rowcnt NUMBER;
BEGIN
    SELECT global_name INTO dbname FROM global_name;
    EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM dba_objects WHERE object_name = :1' INTO rowcnt USING dbname;
    IF rowcnt = 0 THEN
        EXECUTE IMMEDIATE 'CREATE TABLE strmadmin.streams_pt_'||dbname||'(dbname VARCHAR2(10), modified_ts TIMESTAMP(6))';
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -955 THEN
            DBMS_OUTPUT.PUT_LINE(CHR(13));
            DBMS_OUTPUT.PUT_LINE('Streams heartbeat or ping table strmadmin.streams_pt_'||LOWER(dbname)||' already exists hence not creating.');
        ELSE
            RAISE;
        END IF;
END;
/

-- Manual insert data into heartbeat table.
DECLARE 
    dbname VARCHAR2(10);
    rowcnt NUMBER;
BEGIN
    SELECT global_name INTO dbname FROM global_name;
    DBMS_OUTPUT.PUT_LINE(CHR(13));
    EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM strmadmin.streams_pt_' || dbname INTO rowcnt;
    IF rowcnt = 0 THEN
        EXECUTE IMMEDIATE 'INSERT INTO strmadmin.streams_pt_'||dbname||' VALUES(:1, SYSTIMESTAMP)' USING dbname;
    ELSE
        EXECUTE IMMEDIATE 'UPDATE strmadmin.streams_pt_'||dbname||' SET dbname=:1, modified_ts=SYSTIMESTAMP' USING dbname;
    END IF;
    COMMIT;
END;
/

-- Create procedure to update streams heartbeat or ping table
CREATE OR REPLACE PROCEDURE strmadmin.stream_update_hb_tab IS
    dbname VARCHAR2(10);
    rowcnt NUMBER;
BEGIN
    SELECT global_name INTO dbname FROM global_name;
    DBMS_OUTPUT.PUT_LINE(CHR(13));
    EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM strmadmin.streams_pt_' || dbname INTO rowcnt;
    IF rowcnt = 0 THEN
        EXECUTE IMMEDIATE 'INSERT INTO strmadmin.streams_pt_'||dbname||' VALUES(:1, SYSTIMESTAMP)' USING dbname;
    ELSE
        EXECUTE IMMEDIATE 'UPDATE strmadmin.streams_pt_'||dbname||' SET dbname=:1, modified_ts=SYSTIMESTAMP' USING dbname;
    END IF;
    COMMIT;
END;
/

-- Create dbms_scheduler job to run procedure strmadmin.stream_update_hb_tab to update streams hearbeat or ping table
BEGIN
    DBMS_SCHEDULER.CREATE_JOB
    (
      job_name             => 'strmadmin.streams_hb',
      job_type             => 'STORED_PROCEDURE',
      job_action           => 'strmadmin.stream_update_hb_tab',
      start_date           => SYSDATE,
      repeat_interval      => 'FREQ=SECONDLY; INTERVAL=5',
      enabled              =>  TRUE,
      comments             => 'Streams Update Heartbeat Table Job'
    );
END;
/

-- Setup uni-directional replication for the hearbeat/ping table.
-- Source Database
BEGIN
    DBMS_STREAMS_ADM.ADD_TABLE_PROPAGATION_RULES
    (
      table_name              => 'strmadmin.streams_pt_ntestp',
      streams_name            => 'NTESTP_TO_STESTP',
      source_queue_name       => 'NTESTP_CAPTURE_QUEUE',
      destination_queue_name  => 'STESTP_APPLY_QUEUE@STESTP',
      include_dml             => TRUE,
      include_ddl             => FALSE,
      source_database         => 'NTESTP'
    );
END;
/

BEGIN
    DBMS_STREAMS_ADM.ADD_TABLE_RULES
    (
      table_name      => 'strmadmin.streams_pt_ntestp',
      streams_type    => 'CAPTURE',
      streams_name    => 'NTESTP_CAPTURE',
      queue_name      => 'NTESTP_CAPTURE_QUEUE',
      include_dml     => TRUE,
      include_ddl     => FALSE,
      source_database => 'NTESTP'
    );
END;
/

BEGIN
    DBMS_CAPTURE_ADM.PREPARE_TABLE_INSTANTIATION
    (
      table_name            => 'strmadmin.streams_pt_ntestp',
      supplemental_logging  => 'all'
    );
END;
/

SELECT DBMS_FLASHBACK.GET_SYSTEM_CHANGE_NUMBER FROM dual;

expdp strmadmin TABLES=strmadmin.streams_pt_ntestp DIRECTORY=STREAMS_DIR DUMPFILE=streams_pt_ntestp.dmp FLASHBACK_SCN=15092054 LOGFILE=expdp_$(date +%Y_%m_%d_%H%M).log

-- Target Database
impdp strmadmin TABLES=strmadmin.streams_pt_ntestp DIRECTORY=STREAMS_DIR DUMPFILE=streams_pt_ntestp.dmp LOGFILE=impdp_$(date +%Y_%m_%d_%H%M).log

BEGIN
    DBMS_STREAMS_ADM.ADD_TABLE_RULES
    (
      table_name      => 'strmadmin.streams_pt_ntestp',
      streams_type    => 'APPLY',
      streams_name    => 'STESTP_APPLY',
      queue_name      => 'STESTP_APPLY_QUEUE',
      include_dml     => TRUE,
      include_ddl     => FALSE,
      source_database => 'NTESTP'
    );
END;
/

BEGIN
    DBMS_APPLY_ADM.SET_TABLE_INSTANTIATION_SCN
    (
      source_object_name    => 'strmadmin.streams_pt_ntestp',
      source_database_name  => 'STESTP',
      instantiation_scn     => &scn
    );
END;
/

EXEC DBMS_APPLY_ADM.START_APPLY(apply_name => 'STESTP_APPLY');
EXEC DBMS_CAPTURE_ADM.START_CAPTURE(capture_name => 'NTESTP_CAPTURE');
