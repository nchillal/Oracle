SELECT  inst_id,
        process,
        status,
        thread#,
        sequence#,
        block#,
        blocks
FROM    gv$managed_standby
WHERE   process like 'MRP%';
