exec dbms_stats.gather_table_stats('&owner', '&table_name', estimate_percent => dbms_stats.auto_sample_size);
