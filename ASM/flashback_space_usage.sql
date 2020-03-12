select  *
from    v$recovery_area_usage;

SELECT  file_type,
        percent_space_used,
        percent_space_used * p.value/100/1024/1024 "MB Used",
        percent_space_reclaimable,
        number_of_files,
        percent_space_reclaimable * p.value/100/1024/1024 "MB Reclaimable"
FROM    v$flash_recovery_area_usage f, v$parameter p
WHERE   p.name='db_recovery_file_dest_size';

DECLARE
    pcntrclm number;
    pcntused number;
    recdestsize number;
    totrcml number;
    totused number;
BEGIN
    SELECT SUM(percent_space_reclaimable) INTO pcntrclm FROM v$flash_recovery_area_usage;
    SELECT SUM(percent_space_used) INTO pcntused from v$flash_recovery_area_usage;
    SELECT value INTO recdestsize FROM v$parameter where name='db_recovery_file_dest_size';
    totrcml := pcntrclm*recdestsize/100/1024/1024;
    totused := pcntused*recdestsize/100/1024/1024;
    DBMS_OUTPUT.PUT_LINE('Total FRA space: '||to_char(recdestsize/1024/1024)||' Mb');
    DBMS_OUTPUT.PUT_LINE('Total used: '||to_char(totused)||' Mb');
    DBMS_OUTPUT.PUT_LINE('Total free: '||to_char(recdestsize/1024/1024-totused)||' Mb');
    DBMS_OUTPUT.PUT_LINE('Total reclaimable: '||to_char(totrcml)||' Mb');
END;
/
