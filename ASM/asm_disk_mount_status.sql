COLUMN path FORMAT a40
COLUMN name FORMAT a15
COLUMN "Disk Name" FORMAT a20
COLUMN failgroup FORMAT a15

SELECT    group_number, disk_number, failgroup,name "Disk Name", mount_status, path
FROM      v$asm_disk
ORDER BY  failgroup, name, path;
