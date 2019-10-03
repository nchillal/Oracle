-- SELECT * FROM V$LOGMNR_DICTIONARY     The dictionary file in use.
-- SELECT * FROM V$LOGMNR_PARAMETERS     Current parameter settings for LogMiner.
-- SELECT * FROM V$LOGMNR_LOGS           Which redo log files are being analyzed.
-- SELECT * FROM V$LOGMNR_CONTENTS       The contents of the redo log files being analyzed.

SET LINESIZE 250 PAGES 2000
COLUMN name FORMAT a70
SELECT first_time, name FROM v$archived_log WHERE dest_id=1 AND first_time > SYSDATE - INTERVAL '&days' DAY;
SELECT first_time, name FROM v$archived_log WHERE dest_id=1 AND first_time > SYSDATE - INTERVAL '&hours' HOUR;
SELECT first_time, name FROM v$archived_log WHERE dest_id=1 AND first_time > SYSDATE - INTERVAL '&minutes' MINUTE;
SELECT first_time, name FROM v$archived_log WHERE dest_id=1 AND sequence# BETWEEN &begin_sequence AND &end_sequence ORDER BY 1;

-- Add initial archive logfile to be mined.
EXEC DBMS_LOGMNR.ADD_LOGFILE (options => DBMS_LOGMNR.NEW, logfilename => '&archive_logfile');

-- Add additional logfiles you wish to be mined either one by one or
EXEC DBMS_LOGMNR.ADD_LOGFILE (options => DBMS_LOGMNR.ADDFILE, logfilename => '&archive_logfile');

-- Using time add logfile to be mined.
BEGIN
    DBMS_OUTPUT.PUT_LINE(chr(13));
    FOR rec in  (
                SELECT first_time, name FROM v$archived_log WHERE dest_id=1 AND first_time BETWEEN '&start_date' AND '&end_date' ORDER BY 1
                )
    LOOP
        DBMS_OUTPUT.PUT_LINE('Adding archive logfile '||rec.name||' for logminer to mine');
        DBMS_LOGMNR.ADD_LOGFILE (options => DBMS_LOGMNR.ADDFILE, logfilename => rec.name);
    END LOOP;
END;
/

-- Using SCN add logfile to be mined.
BEGIN
    DBMS_OUTPUT.PUT_LINE(chr(13));
    FOR rec in  (
                SELECT first_time, name FROM v$archived_log WHERE dest_id=1 AND sequence# BETWEEN &begin_sequence AND &end_sequence ORDER BY 1
                )
    LOOP
        DBMS_OUTPUT.PUT_LINE('Adding archive logfile '||rec.name||' for logminer to mine');
        DBMS_LOGMNR.ADD_LOGFILE (options => DBMS_LOGMNR.ADDFILE, logfilename => rec.name);
    END LOOP;
END;
/

BEGIN
    DBMS_LOGMNR.START_LOGMNR (
        options => DBMS_LOGMNR.DICT_FROM_ONLINE_CATALOG +
                   DBMS_LOGMNR.PRINT_PRETTY_SQL +
                   DBMS_LOGMNR.NO_SQL_DELIMITER +
                   DBMS_LOGMNR.COMMITTED_DATA_ONLY
    );
END;
/

COLUMN sql_redo FORMAT a100
COLUMN xid FORMAT a15

SELECT      start_timestamp, commit_timestamp, username, sql_redo
FROM        v$logmnr_contents
WHERE       username != 'SYS'
AND         seg_owner IS NULL OR seg_owner NOT IN ('SYS', 'SYSTEM')
ORDER BY    1;

EXECUTE DBMS_LOGMNR.END_LOGMNR();

-- Extracting the LogMiner Dictionary to a Flat File
DBMS_LOGMNR_D.BUILD ('act6502p_logminer_dump.txt', '/home/oracle/admin/act6502p/work/nchillal', DBMS_LOGMNR_D.STORE_IN_FLAT_FILE);
EXEC DBMS_LOGMNR.START_LOGMNR (DictFileName => '/home/oracle/admin/act6502p/work/nchillal/act6502p_logminer_dump.txt');