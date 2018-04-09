SET NUMWIDTH 15 LINESIZE 165
COLUMN component FORMAT a30
SELECT    inst_id, component, current_size, user_specified_size, granule_size, 'Granules_Count - '||(current_size - user_specified_size)/granule_size granules_avail
FROM      gv$sga_dynamic_components
WHERE     component LIKE 'DEFAULT buffer cache'
ORDER BY  inst_id;

SELECT    bytes
FROM      v$sgainfo
WHERE     name LIKE 'Granule Size';

BREAK ON REPORT
COLUMN object_name FORMAT a30
COMPUTE SUM OF BYTES ON REPORT
COLUMN bytes FORMAT 999,999,999,999

SELECT    object_name, COUNT(*)*8192 "BYTES"
FROM      v$bh vbh, dba_objects do
WHERE     vbh.objd = do.object_id
GROUP BY  object_name
ORDER BY  2;

SELECT    pool, SUM(bytes) "BYTES"
FROM      v$sgastat
GROUP BY  pool;

BREAK ON REPORT
COMPUTE SUM OF BYTES ON REPORT
SELECT    name, bytes, percentage
FROM      (
          SELECT    name, bytes, ROUND(100*RATIO_TO_REPORT(bytes) OVER(), 2.2) "PERCENTAGE"
          FROM      v$sgastat
          WHERE     pool='shared pool'
          ORDER BY  bytes DESC
          )
WHERE     rownum < 20;
