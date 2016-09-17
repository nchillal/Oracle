SELECT  process,
        status,
        thread#,
        sequence#,
        block#,
        blocks
FROM    v$managed_standby;
