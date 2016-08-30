SELECT    sample_size, partitioned, last_analyzed, num_rows, global_stats, user_stats
FROM      dba_tables
WHERE     table_name='&table_name';
