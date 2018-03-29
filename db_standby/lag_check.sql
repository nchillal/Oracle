SET LINESIZE 230
BREAK ON inst_id SKIP 1
SELECT    inst_id, name, value, time_computed
FROM      gv$dataguard_stats
WHERE     name IN ('transport lag', 'apply lag')
AND       value IS NOT NULL
ORDER BY  inst_id;
