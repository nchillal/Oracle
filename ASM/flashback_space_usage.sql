SELECT  *
FROM    v$recovery_area_usage;

SELECT  file_type,
        percent_space_used,
        percent_space_used * p.value/100/1024/1024 "MB Used",
        percent_space_reclaimable,
        number_of_files,
        percent_space_reclaimable * p.value/100/1024/1024 "MB Reclaimable"
FROM    v$flash_recovery_area_usage f, v$parameter p
WHERE   p.name='db_recovery_file_dest_size';

SET SERVEROUTPUT ON
DECLARE
    pcntrclm NUMBER;
    pcntused NUMBER;
    recdestsize NUMBER;
    totrcml NUMBER;
    totused NUMBER;
BEGIN
    SELECT SUM(percent_space_reclaimable) INTO pcntrclm FROM v$flash_recovery_area_usage;
    SELECT SUM(percent_space_used) INTO pcntused FROM v$flash_recovery_area_usage;
    SELECT value INTO recdestsize FROM v$parameter WHERE name='db_recovery_file_dest_size';
    totrcml := pcntrclm*recdestsize/100/1024/1024;
    totused := pcntused*recdestsize/100/1024/1024;
    DBMS_OUTPUT.PUT_LINE(CHR(10)||'Total FRA space: '||TO_CHAR(recdestsize/1024/1024)||' MB');
    DBMS_OUTPUT.PUT_LINE('Total used: '||TO_CHAR(totused)||' MB');
    DBMS_OUTPUT.PUT_LINE('Total free: '||TO_CHAR(recdestsize/1024/1024-totused)||' MB');
    DBMS_OUTPUT.PUT_LINE('Total reclaimable: '||TO_CHAR(totrcml)||' MB');
END;
/

SELECT * FROM v$flashback_database_logfile;
