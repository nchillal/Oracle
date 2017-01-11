SET LINESIZE 230
SELECT  name, value, time_computed
FROM		v$dataguard_stats
WHERE 	name IN ('transport lag', 'apply lag');
