SET PAGESIZE 60 LINESIZE 300

COLUMN mb_used FORMAT 999,999,999
COLUMN mb_free FORMAT 999,999,999

SELECT    a.tablespace_name tablespace,
          d.mb_total,
          SUM(a.used_blocks * d.block_size)/1024/1024 mb_used,
          d.mb_total - SUM(a.used_blocks * d.block_size)/1024/1024 mb_free
FROM      v$sort_segment a,
          (
          SELECT    b.name,
                    c.block_size,
                    SUM(c.bytes)/1024/1024 mb_total
          FROM      v$tablespace b, v$tempfile c
          WHERE     b.ts#= c.ts#
          GROUP BY  b.name,
                    c.block_size
          ) d
WHERE     a.tablespace_name = d.name
GROUP BY  a.tablespace_name,
          d.mb_total
/
