SET LINESIZE 230
COLUMN value FORMAT a20
BREAK ON inst_id SKIP 1
SELECT    inst_id, name, value, time_computed
FROM      gv$dataguard_stats
WHERE     name IN ('transport lag', 'apply lag')
AND       value IS NOT NULL
ORDER BY  inst_id;

SELECT    ROUND((sysdate - a.NEXT_TIME)*24*60) as "Backlog MIN",
          m.sequence# "Sequence Applied",
          a.thread#,
          m.process,
          m.block# "Block",
          m.status,
          a.dest_id
FROM      v$archived_log a, (SELECT process, block#, sequence#, status FROM v$managed_standby WHERE process LIKE '%MRP%') m
WHERE     a.sequence#=(m.sequence#-1)
AND       a.status='A'
/
