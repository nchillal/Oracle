COLUMN name FORMAT a32
COLUMN size_alloc_mb FORMAT 999,999,999
COLUMN reclaimable_mb FORMAT 999,999,999
COLUMN used_mb FORMAT 999,999,999
COLUMN pct_used FORMAT 999

SELECT    name,
          CEIL(space_limit/1024/1024) SIZE_M,
          CEIL(space_used/1024/1024) USED_M,
          CEIL(space_reclaimable/1024/1024) RECLAIMABLE_M,
          DECODE(NVL(space_used, 0), 0, 0, CEIL(((space_used - space_reclaimable)/space_limit)*100)) PCT_USED
FROM      v$recovery_file_dest
ORDER BY  name
/

SELECT    *
FROM      v$flash_recovery_area_usage
ORDER BY  2
/
