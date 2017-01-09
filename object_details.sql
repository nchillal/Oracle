SET linesize 230 echo off pagesize 200
COLUMN object_name FORMAT a30
COLUMN segment_name FORMAT a30
ACCEPT ONAME PROMPT 'Enter Object Name:'

SELECT    owner,
          object_id,
          object_name,
          object_type,
          last_ddl_time,
          status
FROM      dba_objects
WHERE     object_name = UPPER('&ONAME');

SELECT    segment_name, segment_type, SUM(bytes/1024/1024) "Size (MB)"
FROM      dba_segments
WHERE     segment_name='&ONAME'
GROUP BY  segment_name, segment_type
/

SELECT    owner, table_name, sample_size, partitioned, last_analyzed, num_rows, global_stats, user_stats
FROM      dba_tables
WHERE     table_name='&ONAME'
/
