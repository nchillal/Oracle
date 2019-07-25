COLUMN SIZE_GB FORMAT 999,999.00
COLUMN FREE_GB FORMAT 999,999.00
COLUMN USED_SPACE_GB FORMAT 999,999.00
COLUMN PERCENT_USED FORMAT 999,999.00
COLUMN name FORMAT A20

SELECT  name,
        total_mb/1024 size_gb,
        free_mb/1024 free_gb,
        (total_mb - free_mb)/1024 AS USED_SPACE_GB,
        ((total_mb - free_mb)/total_mb)*100 PERCENT_USED
FROM    v$asm_diskgroup;
