SELECT  name, value, time_computed
FROM		v$dataguard_stats
WHERE 	name in ('transport lag', 'apply lag');
