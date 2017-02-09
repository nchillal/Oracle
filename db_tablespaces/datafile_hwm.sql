set verify off
COLUMN file_name FORMAT a50 WORD_WRAPPED
COLUMN smallest FORMAT 999,990 HEADING "Smallest|Size|Poss."
COLUMN currsize FORMAT 999,990 HEADING "Current|Size"
COLUMN savings  FORMAT 999,990 HEADING "Poss.|Savings"
BREAK ON report
COMPUTE SUM OF savings ON report
COLUMN value NEW_VAL blksize

SELECT    value
FROM      v$parameter
WHERE     name = 'db_block_size';
/

SELECT    file_name,
          CEIL((NVL(hwm,1)*&&blksize)/1024/1024) smallest,
          CEIL(blocks*&&blksize/1024/1024) currsize,
          CEIL(blocks*&&blksize/1024/1024) - CEIL((NVL(hwm,1)*&&blksize)/1024/1024) savings
FROM      dba_data_files a,
          (
          SELECT file_id, MAX(block_id+blocks-1) hwm
          FROM dba_extents
          GROUP BY file_id
          ) b
WHERE     a.file_id = b.file_id(+)
ORDER BY  savings
/
