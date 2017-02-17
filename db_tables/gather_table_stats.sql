EXEC DBMS_STATS.GATHER_TABLE_STATS('&owner', '&table_name', estimate_percent => dbms_stats.auto_sample_size);
