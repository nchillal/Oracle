COLUMN Percent_Used FORMAT 99.99
COLUMN type FORMAT A30
COLUMN Size_MB FORMAT 99,999,999.00
SELECT    a.type,
          SUM(a.bytes)/1048576 size_mb,
          b.total_mb asm_volume_size_mb,
          ((SUM(a.bytes)/1048576)/b.TOTAL_MB)*100 AS "Percent_Used"
FROM      v$asm_file a,v$asm_diskgroup b
WHERE     a.group_number=b.group_number
GROUP BY  a.type,b.TOTAL_MB
ORDER BY  4;
