SELECT    TO_CHAR(first_time, 'DD-MON-YYYY'), COUNT(*)
FROM      v$log_history
WHERE     TO_CHAR(first_time, 'DD-MON-YYYY') >= to_char(SYSDATE - &num_days, 'DD-MON-YYYY')
GROUP BY  TO_CHAR(first_time, 'DD-MON-YYYY')
ORDER BY  1
/

select    TO_CHAR(first_time, 'HH24'), COUNT(*)
from      v$log_history
where     TO_CHAR(first_time, 'DD-MON-YYYY') = to_char(SYSDATE - &num_days, 'DD-MON-YYYY')
group by  TO_CHAR(first_time, 'HH24')
order by  1
/
