SET numwidth 30 lines 230
SELECT  thread#, 
        sequence#, 
        first_change#, 
        next_change# 
FROM    v$archived_log 
WHERE   &change between first_change# AND next_change#;
