BREAK ON disk_name SKIP 1
COMPUTE SUM LABEL 'TOTAL_MB' OF size_mb ON disk_name
COLUMN percent_used FORMAT 999.99
COLUMN type FORMAT A30
COLUMN size_MB FORMAT 99,999,999.00
COLUMN asm_volume_size_mb FORMAT 99,999,999.00

SELECT    b.name disk_name,
          a.type,
          SUM(a.bytes)/1048576 size_mb,
          b.total_mb asm_volume_size_mb,
          ROUND(ratio_to_report(SUM(a.bytes/1048576)) over(), 2)*100 as PERCENT_USED
FROM      v$asm_file a,v$asm_diskgroup b
WHERE     a.group_number=b.group_number
GROUP BY  b.name,a.type,b.total_mb
ORDER BY  1,5;
