SET numwidth 30 linesize 230
SELECT  thread#,
        sequence#,
        first_change#,
        next_change#
FROM    v$archived_log
WHERE   &change BETWEEN first_change# AND next_change#;
