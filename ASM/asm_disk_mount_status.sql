COLUMN path FORMAT a40
COLUMN "Disk Name" FORMAT a15
COLUMN failgroup FORMAT a15
COLUMN "Disk Group Name" FORMAT a15
COLUMN "Total MB" FORMAT a10
COLUMN "Free MB" FORMAT a10
COLUMN "Usable Free MB" FORMAT a10
COLUMN ReqMirrorFree FORMAT a15

SELECT    group_number, disk_number, failgroup, name, header_status, mount_status, state, mode_status, path
FROM      v$asm_disk
ORDER BY  failgroup, name, path;

SELECT    dg.name "Disk Group Name",
          TO_CHAR(NVL(dg.total_mb,0)) "Total MB",
          TO_CHAR(NVL(dg.free_mb, 0)) "Free MB",
          type "Type",
          TO_CHAR(NVL(dg.usable_file_mb, 0)) "Usable Free MB",
          TO_CHAR(NVL(dg.required_mirror_free_mb, 0)) "ReqMirrorFree",
          DECODE(type, 'EXTERN', 1, 'NORMAL', 2, 'HIGH', 3, 1) redundancy_factor, ROUND(100 - (dg.free_mb/dg.total_mb*100)) "percentUsed"
FROM      v$asm_diskgroup_stat dg
WHERE     state = 'MOUNTED';

SELECT      NVL(REGEXP_SUBSTR(failgroup, 'DATA|SYSTEMDG'), 'NOT_USED') "Disk Group Name",
            COUNT(*) "COUNT"
FROM        v$asm_disk
GROUP BY    REGEXP_SUBSTR(failgroup, 'DATA|SYSTEMDG');
