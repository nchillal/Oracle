SELECT  inst_id,
        thread#,
        GROUP#,
        bytes/1024/1024,
        status
FROM    gv$standby_log;

set linesize 230 pagesize 200
col member for a70

SELECT  inst_id,
        group#,
        member,
        status
FROM    gv$logfile
WHERE   type = 'STANDBY';
